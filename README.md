# Node.js App — CI/CD Pipeline with Jenkins & AWS EC2 Deployment

A containerized Node.js/Express web application with a fully automated CI/CD pipeline that builds, tests, versions, and deploys to an AWS EC2 instance.

## Tech Stack

- **App**: Node.js / Express
- **Containerization**: Docker, Docker Compose
- **CI/CD**: Jenkins (declarative pipeline with shared library)
- **Registry**: Docker Hub
- **Cloud**: AWS EC2

## How It Works

1. A push to the `main` branch triggers the Jenkins pipeline.
2. The pipeline auto-increments the semantic version in `package.json`.
3. Unit tests are run against the app.
4. A Docker image is built and pushed to Docker Hub with the new version tag.
5. Jenkins SSHs into the EC2 instance, copies over `docker-compose.yaml` and `server-cmds.sh`, and runs the new image via Docker Compose.
6. The version bump commit is pushed back to the repository.

## Project Structure

```
├── app/                  # Node.js application source
│   ├── server.js         # Express server
│   ├── server.test.js    # Unit tests
│   └── package.json
├── Dockerfile            # Multi-stage image build (node:20-alpine)
├── docker-compose.yaml   # Compose config for EC2 deployment
├── server-cmds.sh        # Remote deployment script
└── Jenkinsfile           # Declarative CI/CD pipeline
```

## Running Locally

```bash
docker build -t demo-app .
docker run -p 3000:3000 demo-app
# Visit http://localhost:3000
```

