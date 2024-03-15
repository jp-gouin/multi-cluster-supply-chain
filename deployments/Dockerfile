FROM bitnami/minideb

RUN apt-get -y update &&\
 apt-get -y install curl &&\
 curl -L -o vcluster "https://github.com/loft-sh/vcluster/releases/latest/download/vcluster-linux-amd64" &&\
 curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl" &&\
 curl -L -o kp "https://github.com/buildpacks-community/kpack-cli/releases/download/v0.13.0/kp-linux-amd64-0.13.0" &&\
 install -c -m 0755 vcluster /usr/local/bin &&\
 mv kp /usr/local/bin/ &&\
 chmod +x /usr/local/bin/kp &&\
 chmod 755 /usr/local/bin/kp &&\
 rm -f vcluster &&\
 install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl &&\
 rm -rf kubectl &&\
 (curl -sSL "https://github.com/buildpacks/pack/releases/download/v0.33.2/pack-v0.33.2-linux.tgz" | tar -C /usr/local/bin/ --no-same-owner -xzv pack) &&\
 curl -sSfL https://raw.githubusercontent.com/anchore/syft/main/install.sh | sh -s -- -b /usr/local/bin &&\
 LATEST_VERSION=$(curl https://api.github.com/repos/sigstore/cosign/releases/latest | grep tag_name | cut -d : -f2 | tr -d "v\", ") &&\
 curl -O -L "https://github.com/sigstore/cosign/releases/latest/download/cosign_${LATEST_VERSION}_amd64.deb" &&\
 dpkg -i cosign_${LATEST_VERSION}_amd64.deb &&\
 VERSION="1.1.0" &&\
 curl -LO "https://github.com/oras-project/oras/releases/download/v${VERSION}/oras_${VERSION}_linux_amd64.tar.gz" &&\
 mkdir -p oras-install/ &&\
 tar -zxf oras_${VERSION}_*.tar.gz -C oras-install/ &&\
 mv oras-install/oras /usr/local/bin/ &&\
 rm -rf oras_${VERSION}_*.tar.gz oras-install/ &&\
 rm -rf *.tar.gz &&\
 rm -rf *.deb 
