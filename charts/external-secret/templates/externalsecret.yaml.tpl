{{- if .Values.externalSecret.enabled }}
apiVersion: external-secrets.io/v1
kind: ExternalSecret
metadata:
  name: {{ required "externalSecret.metadata.name es obligatorio" .Values.externalSecret.metadata.name }}
  namespace: {{ default .Release.Namespace .Values.externalSecret.metadata.namespace }}
  labels:
    app.kubernetes.io/managed-by: argocd
    app.kubernetes.io/part-of: external-secrets
    {{- with .Values.externalSecret.metadata.labels }}
    {{- toYaml . | nindent 4 }}
    {{- end }}
  {{- with .Values.externalSecret.metadata.annotations }}
  annotations:
    {{- toYaml . | nindent 4 }}
  {{- end }}
spec:
  refreshInterval: {{ default "1h" .Values.externalSecret.refreshInterval | quote }}
  secretStoreRef:
    name: {{ required "externalSecret.secretStoreRef.name es obligatorio" .Values.externalSecret.secretStoreRef.name }}
    kind: {{ default "ClusterSecretStore" .Values.externalSecret.secretStoreRef.kind }}
  target:
    name: {{ default .Values.externalSecret.metadata.name .Values.externalSecret.target.name }}
    {{- with .Values.externalSecret.target.creationPolicy }}
    creationPolicy: {{ . }}
    {{- end }}
    {{- with .Values.externalSecret.target.deletionPolicy }}
    deletionPolicy: {{ . }}
    {{- end }}
    {{- with .Values.externalSecret.target.template }}
    template:
      {{- with .type }}
      type: {{ . }}
      {{- end }}
      {{- with .engineVersion }}
      engineVersion: {{ . }}
      {{- end }}
      {{- with .metadata }}
      metadata:
        {{- with .labels }}
        labels:
          {{- toYaml . | nindent 10 }}
        {{- end }}
        {{- with .annotations }}
        annotations:
          {{- toYaml . | nindent 10 }}
        {{- end }}
      {{- end }}
      {{- with .data }}
      data:
        {{- toYaml . | nindent 8 }}
      {{- end }}
    {{- end }}
  {{- with .Values.externalSecret.data }}
  data:
    {{- toYaml . | nindent 4 }}
  {{- end }}
  {{- with .Values.externalSecret.dataFrom }}
  dataFrom:
    {{- toYaml . | nindent 4 }}
  {{- end }}
{{- end }}
