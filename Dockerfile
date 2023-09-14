FROM python:3.8.10-slim
LABEL system="task-work"
LABEL version="0.0.1"
ARG system="task-work"
ENV PYTHONUNBUFFERED=1 PYTHONIOENCODING=UTF-8
COPY $system /opt/$system
WORKDIR /opt/$system
RUN pip install -r requirements.txt
CMD ["python", "./api.py"]