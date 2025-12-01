from django.http import HttpResponse
import socket
import os

def health_check(request):
    hostname = socket.gethostname()
    pod_ip = os.getenv('POD_IP', 'unknown')
    return HttpResponse(f"<h1>Hello from K8s!</h1><p>Replica Hostname: <b>{hostname}</b></p><p>Pod IP: {pod_ip}</p>")
