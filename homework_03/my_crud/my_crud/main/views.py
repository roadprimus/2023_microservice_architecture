from rest_framework.decorators import api_view, permission_classes
from rest_framework.permissions import AllowAny
from rest_framework.response import Response
from rest_framework.status import HTTP_200_OK


@api_view(['GET'])
@permission_classes([AllowAny])
def health(request):
    return Response(data={'status': 'OK'}, status=HTTP_200_OK)
