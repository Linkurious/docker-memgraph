{{/*
Expand the name of the chart.
*/}}
{{- define "memgraph.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "memgraph.fullname" -}}
{{- if .Values.fullnameOverride }}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- $name := default .Chart.Name .Values.nameOverride }}
{{- if contains $name .Release.Name }}
{{- .Release.Name | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" }}
{{- end }}
{{- end }}
{{- end }}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "memgraph.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels for umbrella chart resources
*/}}
{{- define "memgraph.labels" -}}
helm.sh/chart: {{ include "memgraph.chart" . }}
{{ include "memgraph.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels for umbrella chart resources
*/}}
{{- define "memgraph.selectorLabels" -}}
app.kubernetes.io/name: {{ include "memgraph.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Default external URL for IngressRoute
*/}}
{{- define "memgraph.defaultHostUrl" -}}
{{- print (include "memgraph.fullname" .) "." .Release.Namespace "." .Values.hostPostfix -}}
{{- end }}

{{/*
Service name for the Memgraph DB sub-chart.
Replicates the sub-chart's fullname helper: if release name contains "memgraph",
it collapses to just the release name.
*/}}
{{- define "memgraph.dbServiceName" -}}
{{- if contains "memgraph" .Release.Name }}
{{- .Release.Name | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- printf "%s-memgraph" .Release.Name | trunc 63 | trimSuffix "-" }}
{{- end }}
{{- end }}

{{/*
Service name for the Memgraph Lab sub-chart.
The sub-chart name is "memgraph-lab"; if release name contains "memgraph-lab"
it collapses, otherwise it's <release>-memgraph-lab.
*/}}
{{- define "memgraph.labServiceName" -}}
{{- if contains "memgraph-lab" .Release.Name }}
{{- .Release.Name | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- printf "%s-memgraph-lab" .Release.Name | trunc 63 | trimSuffix "-" }}
{{- end }}
{{- end }}

{{/*
Selector labels to match Memgraph DB pods (from the memgraph sub-chart)
*/}}
{{- define "memgraph.dbSelectorLabels" -}}
app.kubernetes.io/name: memgraph
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Selector labels to match Memgraph Lab pods (from the memgraph-lab sub-chart)
*/}}
{{- define "memgraph.labSelectorLabels" -}}
app.kubernetes.io/name: memgraph-lab
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}
