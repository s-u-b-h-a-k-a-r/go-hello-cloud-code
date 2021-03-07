# Start from the latest golang base image
FROM golang:latest as build

# Add Maintainer Info
LABEL maintainer="SubhakarKotta <subhakarkotta@gmail.com>"

# Set the Current Working Directory inside the container
WORKDIR /hello-world

# Copy go mod and sum files
COPY go.mod go.sum ./

# Download all dependancies. Dependencies will be cached if the go.mod and go.sum files are not changed
RUN go mod download

# Copy the source from the current directory to the Working Directory inside the container
COPY . .

ARG SKAFFOLD_GO_GCFLAGS
RUN echo "Go gcflags: ${SKAFFOLD_GO_GCFLAGS}"
RUN go build -gcflags="${SKAFFOLD_GO_GCFLAGS}" -mod=readonly -v -o /app


######## Start a new stage from scratch #######
FROM gcr.io/distroless/base

ENV GOTRACEBACK=single

WORKDIR /hello-world
COPY --from=build /app .

ENTRYPOINT ["./app"]