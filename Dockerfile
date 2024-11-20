# 使用 PyTorch 官方镜像作为基础镜像
FROM pytorch/pytorch:1.11.0-cuda11.3-cudnn8-devel
RUN apt-get update
RUN apt-get -y install libglib2.0-dev
RUN apt-get -y install libsm6
RUN apt-get -y install libxrender1
RUN apt-get -y install libxext-dev
RUN apt -y --fix-broken install
RUN apt -y install libgl1-mesa-glx

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

# 拷贝字体文件到新环境
COPY ./fonts/* /opt/conda/envs/idm/lib/python3.7/site-packages/matplotlib/mpl-data/fonts/ttf/

# 确保启动容器时进入 Conda 环境
CMD ["bash", "-c", "source activate idm && bash"]
