from pydantic import UUID4, BaseModel, EmailStr


class User(BaseModel):
    """Domain entity representing a system user."""

    id: UUID4 | None = None
    email: EmailStr
    hashed_password: str
    is_active: bool = True
