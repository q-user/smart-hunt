from fastapi.testclient import TestClient
from presentation.api.main import app

client = TestClient(app)


def test_health_check_returns_200():
    """
    Простейший E2E тест для проверки работоспособности каркаса FastAPI.
    """
    response = client.get("/health")
    assert response.status_code == 200
    assert response.json() == {"status": "ok", "version": "0.1.0"}
