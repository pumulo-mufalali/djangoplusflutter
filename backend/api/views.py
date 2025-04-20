# views.py
from rest_framework.decorators import api_view, permission_classes
from rest_framework.permissions import AllowAny
from rest_framework.response import Response


@api_view(['GET'])
@permission_classes([AllowAny])  # Bypass auth for testing
def hello_world(request):
    return Response({"message": "Hello from Django!"})