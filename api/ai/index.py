"""
Vercel Serverless Function for AI Service
This is a wrapper to make the FastAPI app work with Vercel's Python runtime
"""
import sys
import os

# Add the ai_service directory to the path
sys.path.insert(0, os.path.join(os.path.dirname(__file__), '../../ai_service'))

from fastapi import FastAPI, HTTPException, UploadFile, File
from fastapi.middleware.cors import CORSMiddleware
from pydantic import BaseModel
from typing import List, Dict
import base64

# Import AI service modules
try:
    from recommend import recommend_courses
    from resume_analyzer import analyze_resume
    from code_eval import evaluate_code
    from chat_mentor import chat_with_mentor
    from transcribe_audio import transcriber
    from generate_report import generate_interview_report
    from question_generator import question_generator
    from video_analyzer import video_analyzer
except ImportError as e:
    print(f"Warning: Could not import AI modules: {e}")
    # Provide mock implementations for development
    def recommend_courses(*args, **kwargs):
        return []
    def analyze_resume(*args, **kwargs):
        return {"status": "mock"}
    def evaluate_code(*args, **kwargs):
        return {"status": "mock"}
    def chat_with_mentor(*args, **kwargs):
        return "Mock response"
    class MockTranscriber:
        def transcribe_audio(self, *args, **kwargs):
            return "Mock transcript"
    transcriber = MockTranscriber()
    def generate_interview_report(*args, **kwargs):
        return {}
    class MockQuestionGenerator:
        def get_questions_for_role(self, *args, **kwargs):
            return []
    question_generator = MockQuestionGenerator()
    class MockVideoAnalyzer:
        def analyze_video_stream(self, *args, **kwargs):
            return {}
    video_analyzer = MockVideoAnalyzer()

app = FastAPI(title="InturnX AI Service", version="1.0.0")

# CORS middleware
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# Request models
class RecommendationRequest(BaseModel):
    user_skills: list[str]
    completed_courses: list[str]

class ResumeAnalysisRequest(BaseModel):
    resume: str

class CodeEvaluationRequest(BaseModel):
    code: str
    language: str

class ChatRequest(BaseModel):
    message: str
    context: dict = {}

class QuestionGenerationRequest(BaseModel):
    role: str
    num_questions: int = 8

class VideoAnalysisRequest(BaseModel):
    frames: List[bytes]

class InterviewAnalysisRequest(BaseModel):
    transcript: str
    visual_cues: dict

class ReportGenerationRequest(BaseModel):
    report_data: dict

# Endpoints
@app.get("/api/ai/health")
async def health_check():
    return {"status": "healthy", "service": "InturnX AI on Vercel"}

@app.post("/api/ai/recommend")
async def get_recommendations(request: RecommendationRequest):
    try:
        recommendations = recommend_courses(request.user_skills, request.completed_courses)
        return {"recommendations": recommendations}
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))

@app.post("/api/ai/analyze-resume")
async def analyze_resume_endpoint(request: ResumeAnalysisRequest):
    try:
        analysis = analyze_resume(request.resume)
        return analysis
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))

@app.post("/api/ai/evaluate-code")
async def evaluate_code_endpoint(request: CodeEvaluationRequest):
    try:
        evaluation = evaluate_code(request.code, request.language)
        return {"evaluation": evaluation}
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))

@app.post("/api/ai/chat-mentor")
async def chat_mentor_endpoint(request: ChatRequest):
    try:
        response = chat_with_mentor(request.message, request.context)
        return {"response": response}
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))

@app.post("/api/ai/generate-questions")
async def generate_questions_endpoint(request: QuestionGenerationRequest):
    try:
        questions = question_generator.get_questions_for_role(request.role, request.num_questions)
        return {"questions": questions}
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))

# Export for Vercel
handler = app

