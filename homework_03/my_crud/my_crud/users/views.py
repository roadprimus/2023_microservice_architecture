from django.contrib.auth.models import User
from rest_framework.permissions import AllowAny
from rest_framework.viewsets import ModelViewSet

from users.serializers import UserSerializer


class UserViewSet(ModelViewSet):

    queryset = User.objects.all()
    permission_classes = [AllowAny]
    serializer_class = UserSerializer
