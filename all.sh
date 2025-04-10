echo "exclude=openssl*" | sudo tee -a /etc/dnf/dnf.conf
sudo mkdir -p /mnt/rhel9
sudo mount -o loop ./rhel-9.5-x86_64-dvd.iso /mnt/rhel9
sudo tee /etc/yum.repos.d/rhel9-local.repo > /dev/null <<EOF
[rhel9-local]
name=RHEL 9.5 Local Repo
baseurl=file:///mnt/rhel9/BaseOS
gpgcheck=0
enabled=1

[rhel9-appstream]
name=RHEL 9.5 AppStream
baseurl=file:///mnt/rhel9/AppStream
gpgcheck=0
enabled=1
EOF
echo "rhel9-local repo DONE"

sudo tee /etc/yum.repos.d/kubernetes.repo > /dev/null <<EOF
[kubernetes]
name=Kubernetes
baseurl=https://pkgs.k8s.io/core:/stable:/v1.32/rpm/
enabled=1
gpgcheck=1
gpgkey=https://pkgs.k8s.io/core:/stable:/v1.32/rpm/repodata/repomd.xml.key
exclude=kubelet kubeadm kubectl cri-tools kubernetes-cni
EOF

echo "🔹 Adding CRI-O repository for version $CRIO_VERSION..."
cat <<EOF | sudo tee /etc/yum.repos.d/cri-o.repo
[cri-o]
name=CRI-O
baseurl=https://download.opensuse.org/repositories/isv:/cri-o:/stable:/v1.32/rpm/
enabled=1
gpgcheck=1
gpgkey=https://download.opensuse.org/repositories/isv:/cri-o:/stable:/v1.32/rpm/repodata/repomd.xml.key
EOF

echo "rhel9-local repo DONE3"
sudo systemctl daemon-reload
sudo dnf config-manager --disable \*
sudo dnf config-manager --enable rhel9-local rhel9-appstream kubernetes cri-o
sudo dnf clean all
sudo dnf makecache
sudo setenforce 0
sudo dnf install git nano -y
git clone https://github.com/techiescamp/kubeadm-scripts.git
