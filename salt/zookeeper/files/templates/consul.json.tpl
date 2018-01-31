{
    "service": {
        "id": "zookeeper{{myid}}",
        "name": "zookeeper",
        "tags": ["{{myid}}"],
        "address": "{{ internal_ip }}",
        "port": 2181
    },
    "check": {
        "id": "service:zookeeper{{myid}}",
        "name": "Zookeeper health check",
        "ServiceID": "zookeeper{{myid}}",
        "args": ["echo ruok | ", "nc localhost 2181", " | grep 'imok'"],
        "interval": "10s",
        "timeout": "1s"
    }
}