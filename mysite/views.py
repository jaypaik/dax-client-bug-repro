import logging
import traceback

from amazondax import AmazonDaxClient
from datetime import datetime
from django.http import HttpResponse
from mysite.settings import DAX_ENDPOINT, DAX_REGION_NAME

logger = logging.getLogger(__name__)

def home(request):
    try:
        AmazonDaxClient(
            endpoint_url=DAX_ENDPOINT,
            region_name=DAX_REGION_NAME,
        )
    except Exception as e:
        return HttpResponse(str(e), status=500)

    now = datetime.utcnow()
    logger.info(now)
    return HttpResponse(now)
