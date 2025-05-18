# Pour l’instant pas nécessaire, mais tu peux y définir :
# - driver Minikube
# - nom du cluster
# - configuration kubeconfig path
# Exemple :

variable "minikube_driver" {
  description = "Driver utilisé par Minikube"
  default     = "virtualbox"
}
