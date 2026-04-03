# clean base image containing only comfyui, comfy-cli and comfyui-manager
FROM runpod/worker-comfyui:5.8.5-base

WORKDIR /comfyui/custom_nodes

RUN git clone https://github.com/city96/ComfyUI-GGUF.git
RUN git clone https://github.com/calcuis/gguf.git
RUN git clone https://github.com/glowcone/comfyui-base64-to-image.git

RUN pip install --no-cache-dir --upgrade gguf
RUN pip install --no-cache-dir opencv-python pillow numpy

RUN for d in /comfyui/custom_nodes/*; do \
      if [ -f "$d/requirements.txt" ]; then \
        pip install --no-cache-dir -r "$d/requirements.txt"; \
      fi; \
    done

RUN mkdir -p \
    /comfyui/models/unet \
    /comfyui/models/diffusion_models \
    /comfyui/models/clip \
    /comfyui/models/text_encoders \
    /comfyui/models/vae

# main Qwen2.5-VL gguf
RUN wget -O /comfyui/models/text_encoders/Qwen2.5-VL-7B-Instruct-abliterated.Q8_0.gguf \
    "https://huggingface.co/Phil2Sat/Qwen-Image-Edit-Rapid-AIO-GGUF/resolve/main/Qwen2.5-VL-7B-Instruct-abliterated/Qwen2.5-VL-7B-Instruct-abliterated.Q8_0.gguf"

# matching mmproj for the same text encoder
RUN wget -O /comfyui/models/text_encoders/Qwen2.5-VL-7B-Instruct-abliterated.mmproj-Q8_0.gguf \
    "https://huggingface.co/Phil2Sat/Qwen-Image-Edit-Rapid-AIO-GGUF/resolve/main/Qwen2.5-VL-7B-Instruct-abliterated/Qwen2.5-VL-7B-Instruct-abliterated.mmproj-Q8_0.gguf?download=true"

# optional duplicate into /clip if your current loader scans there
RUN cp /comfyui/models/text_encoders/Qwen2.5-VL-7B-Instruct-abliterated.Q8_0.gguf \
    /comfyui/models/clip/Qwen2.5-VL-7B-Instruct-abliterated.Q8_0.gguf \
    && cp /comfyui/models/text_encoders/Qwen2.5-VL-7B-Instruct-abliterated.mmproj-Q8_0.gguf \
    /comfyui/models/clip/Qwen2.5-VL-7B-Instruct-abliterated.mmproj-Q8_0.gguf

RUN wget -O /comfyui/models/unet/Qwen-Rapid-NSFW-v23_Q4_K.gguf \
    "https://huggingface.co/Arunk25/Qwen-Image-Edit-Rapid-AIO-GGUF/resolve/main/v23/Qwen-Rapid-NSFW-v23_Q4_K.gguf" \
    && cp /comfyui/models/unet/Qwen-Rapid-NSFW-v23_Q4_K.gguf /comfyui/models/diffusion_models/Qwen-Rapid-NSFW-v23_Q4_K.gguf

RUN wget -O /comfyui/models/vae/pig_qwen_image_vae_fp32-f16.gguf \
    "https://huggingface.co/calcuis/pig-vae/resolve/main/pig_qwen_image_vae_fp32-f16.gguf"
