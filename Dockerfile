# 使用 PyTorch 官方镜像作为基础镜像
FROM pytorch/pytorch:1.11.0-cuda11.3-cudnn8-devel

RUN apt-key del 7fa2af80 && \
    apt-key adv --fetch-keys https://developer.download.nvidia.com/compute/cuda/repos/ubuntu1804/x86_64/3bf863cc.pub && \
    apt-key adv --fetch-keys https://developer.download.nvidia.com/compute/machine-learning/repos/ubuntu1804/x86_64/7fa2af80.pub

RUN apt-get update && apt-get install -y libgl1-mesa-glx libpci-dev curl nano psmisc zip git && apt-get --fix-broken install -y

# 创建新的 Conda 环境并指定 Python 版本
RUN conda create -n idm python=3.7.10 -y

# 设置 PATH，确保新环境的 Python 和 Pip 可用
ENV PATH="/opt/conda/envs/idm/bin:$PATH"

# 安装 Python 包到新创建的 Conda 环境中
RUN /opt/conda/envs/idm/bin/pip install \
    addict \
    future \
    lmdb \
    "numpy>=1.17" \
    opencv-python \
    Pillow \
    pyyaml \
    pandas \
    requests \
    scikit-image \
    scipy \
    tb-nightly \
    tqdm \
    einops \
    yapf \
    tensorboardx \
    wandb \
    basicsr
RUN /opt/conda/envs/idm/bin/pip install torch==1.11.0+cu113 torchvision==0.12.0+cu113 torchaudio==0.11.0 --extra-index-url https://download.pytorch.org/whl/cu113

# 拷贝字体文件到新环境
COPY ./fonts/* /opt/conda/envs/idm/lib/python3.7/site-packages/matplotlib/mpl-data/fonts/ttf/

# 确保启动容器时进入 Conda 环境
CMD ["bash", "-c", "source activate idm && bash"]
