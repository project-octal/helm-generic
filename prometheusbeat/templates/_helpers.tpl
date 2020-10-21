{{/* vim: set filetype=mustache: */}}
{{/*
Expand the name of the chart.
*/}}
{{- define "beat.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "beat.fullname" -}}
{{- if .Values.fullnameOverride -}}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- $name := default .Chart.Name .Values.nameOverride -}}
{{- if contains $name .Release.Name -}}
{{- .Release.Name | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" -}}
{{- end -}}
{{- end -}}
{{- end -}}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "beat.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Common labels
*/}}
{{- define "beat.labels" -}}
{{- range $key, $value := .Values.labels }}
{{$key}}: {{$value | quote}}
{{- end }}
helm.sh/chart: {{ include "beat.chart" $ | quote }}
{{- if $.Chart.AppVersion }}
app.kubernetes.io/version: {{ $.Chart.AppVersion | quote }}
{{- end }}
{{- end -}}

{{/*
Create the name of the service account to use
*/}}
{{- define "beat.serviceAccountName" -}}
{{- if .Values.serviceAccount.create -}}
    {{ default (include "beat.fullname" .) .Values.serviceAccount.name }}
{{- else -}}
    {{ default "default" .Values.serviceAccount.name }}
{{- end -}}
{{- end -}}



{{/*
Security Context Template
*/}}
{{- define "security.context" -}}

{{- with .security }}
{{- if .drop_all_capabilities -}}
capabilities:
    drop:
    - ALL
{{- end }}
{{- if .read_only_root_filesystem -}}
readOnlyRootFilesystem: {{ .read_only_root_filesystem }}
{{- end }}
{{- if .run_as_group -}}
runAsGroup: {{ .run_as_group }}
{{- end }}
{{- if .run_as_non_root -}}
runAsNonRoot: {{ .run_as_non_root }}
{{- end }}
{{- if .run_as_user -}}
runAsUser: {{ .run_as_user }}
{{- end }}
{{- end }}
{{- end -}}