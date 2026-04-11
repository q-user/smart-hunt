from fastapi import FastAPI

app = FastAPI(title="FastAPI Boilerplate")


@app.get("/health")
async def health_check():
    return {"status": "ok", "version": "0.1.0"}
