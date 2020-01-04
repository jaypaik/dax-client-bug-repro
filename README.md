It appears [amazon-dax-client](https://pypi.org/project/amazon-dax-client/)
1.1.3 introduces a bug that propagates loggers to stdout. This is a sample
project that reproduces the bug.

When run on a container with the proper environment variables set (
`DAX_ENDPOINT` and `DAX_REGION_NAME`), a `GET` request on the root should log
the current time to a file called `mysite.log`, and also return that time in
the response, but this shouldn't be logged to standard output. This is the case
for 1.1.2 and below.

However, for versions above 1.1.2, the log propagates to standard output. When
run on Fargate with the default log configuration, we can see the request time
logged to CloudWatch like so:

```
[Sat Jan 04 09:11:21.399028 2020] [wsgi:error] [pid xx:tid xx] [remote xx.xx.xx.xx:xxxxx] INFO:mysite.views:2020-01-04 09:11:21.398708
```

This is problematic because a common pattern for logging requests is to log to
a file and rotate/upload periodically. With high traffic, this generates a lot
of noise in CloudWatch and also has huge cost implications (\$0.50 per GB).

It's hard to tell what changed since `amazon-dax-client` is not open source. It
appears there was a dependency bump for `antlr4-python3-runtime` from 4.7 to
4.7.2, which could also be worth investigating.
