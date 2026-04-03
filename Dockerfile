# clean base image containing only comfyui, comfy-cli and comfyui-manager
FROM runpod/worker-comfyui:5.8.5-base

# install custom nodes into comfyui
WORKDIR /comfyui/custom_nodes

RUN git clone https://github.com/city96/ComfyUI-GGUF.git
RUN git clone https://github.com/glowcone/comfyui-base64-to-image.git

# dependency for ComfyUI-GGUF
RUN pip install --no-cache-dir --upgrade gguf

# install any node requirements if present
RUN for d in /comfyui/custom_nodes/*; do \
      if [ -f "$d/requirements.txt" ]; then \
        pip install --no-cache-dir -r "$d/requirements.txt"; \
      fi; \
    done

# download models into comfyui
RUN mkdir -p /comfyui/models/unet /comfyui/models/clip /comfyui/models/vae

RUN wget -O /comfyui/models/clip/Qwen2.5-VL-7B-Instruct-abliterated.Q8_0.gguf \
    "https://huggingface.co/Phil2Sat/Qwen-Image-Edit-Rapid-AIO-GGUF/resolve/main/Qwen2.5-VL-7B-Instruct-abliterated/Qwen2.5-VL-7B-Instruct-abliterated.Q8_0.gguf"

RUN wget -O /comfyui/models/unet/Qwen-Rapid-NSFW-v23_Q4_K.gguf \
    "https://huggingface.co/Arunk25/Qwen-Image-Edit-Rapid-AIO-GGUF/resolve/main/v23/Qwen-Rapid-NSFW-v23_Q4_K.gguf"

RUN wget -O /comfyui/models/vae/pig_qwen_image_vae_fp32-f16.gguf \
    "https://huggingface.co/calcuis/pig-vae/resolve/main/pig_qwen_image_vae_fp32-f16.gguf"

# copy all input data (like images or videos) into comfyui
# COPY input/ /comfyui/input/
