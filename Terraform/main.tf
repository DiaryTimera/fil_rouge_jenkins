provider "local" {
  # Utilisé pour créer un fichier local de configuration kubeconfig
}

resource "null_resource" "start_minikube" {
  provisioner "local-exec" {
      command = "minikube start --driver=hyperv --hyperv-virtual-switch=\"MinikubeSwitch\""
  }
}
