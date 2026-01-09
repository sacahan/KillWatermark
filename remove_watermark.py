#!/usr/bin/env python3
"""
移除 Gemini Nano Banana Pro 浮水印工具
用於 macOS Automator 快速動作

使用方式：
    python3 remove_watermark.py <圖片路徑>

依賴套件：
    pip3 install Pillow numpy
"""

import sys
import os
import base64
from io import BytesIO
import numpy as np
from PIL import Image

# ===== 預設背景素材 (Base64 編碼) =====
# 48x48 背景
BG_48_BASE64 = """
iVBORw0KGgoAAAANSUhEUgAAADAAAAAwCAIAAADYYG7QAAAGVElEQVR4nMVYvXIbNxD+FvKMWInX
md2dK7MTO7sj9QKWS7qy/Ab2o/gNmCp0JyZ9dHaldJcqTHfnSSF1R7kwlYmwKRYA93BHmkrseMcj
gzgA++HbH2BBxhhmBiB/RYgo+hkGSFv/ZOY3b94w89u3b6HEL8JEYCYATCAi2JYiQ8xMDADGWsvM
bfVagm6ZLxKGPXr0qN/vJ0mSpqn0RzuU//Wu9MoyPqxmtqmXJYwxxpiAQzBF4x8/fiyN4XDYoZLA
5LfEhtg0+glMIGZY6wABMMbs4CaiR8brkYIDwGg00uuEMUTQ1MYqPBRRYZjZ+q42nxEsaYiV5VOa
pkmSSLvX62VZprUyM0DiQACIGLCAESIAEINAAAEOcQdD4a+2FJqmhDd/YEVkMpmEtrU2igCocNHW
13swRBQYcl0enxbHpzEhKo0xSZJEgLIsC4Q5HJaJ2Qg7kKBjwMJyCDciBBcw7fjSO4tQapdi5vF4
3IZ+cnISdh9Y0At2RoZWFNtLsxr8N6CUTgCaHq3g+Pg4TVO1FACSaDLmgMhYC8sEQzCu3/mQjNEM
STvoDs4b+nXny5cvo4lBJpNJmKj9z81VrtNhikCgTsRRfAklmurxeKx9JZIsy548eeITKJgAQwzX
JlhDTAwDgrXkxxCD2GfqgEPa4rnBOlApFUC/39fR1CmTyWQwGAQrR8TonMRNjjYpTmPSmUnC8ODA
JcuyzM7O9qNBkCv15tOp4eHh8SQgBICiCGu49YnSUJOiLGJcG2ydmdwnRcvXuwwlpYkSabTaZS1
vymmc7R2Se16z58/f/jw4Z5LA8iy7NmzZ8J76CQ25F2UGsEAJjxo5194q0fn9unp6fHx8f5oRCQ1
nJ+fbxtA3HAjAmCMCaGuAQWgh4eH0+k0y7LGvPiU3CVXV1fz+by+WQkCJYaImKzL6SEN6uMpjBVM
g8FgOp3GfnNPQADqup79MLv59AlWn75E/vAlf20ibmWg0Pn06dPJZNLr9e6nfLu8//Ahv/gFAEdc
WEsgZnYpR3uM9KRpOplMGmb6SlLX9Ww2q29WyjH8+SI+pD0GQJIkJycn/8J/I4mWjaQoijzPb25u
JJsjmAwqprIsG4/HbVZ2L/1fpCiKoijKqgTRBlCWZcPhcDQafUVfuZfUdb1cLpfL5cePf9Lr16/3
zLz/g9T1quNy+F2FiYjSNB0Oh8Ph8HtRtV6vi6JYLpdVVbmb8t3dnSAbjUbRNfmbSlmWeZ6XHytE
UQafEo0xR0dHUdjvG2X3Sd/Fb0We56t6BX8l2mTq6BCVnqOjo7Ozs29hRGGlqqrOr40CIKqeiGg8
Hn/xcri/rG/XeZ7/evnrjjGbC3V05YC/BSRJ8urVq36/3zX7Hjaq63o+n19fX/upUqe5VxFok7UB
tQ+T6XQ6GAz2Vd6Ssizn8/nt7a3ay1ZAYbMN520XkKenpx0B2E2SLOo+FEWxWPwMgMnC3/adejZM
YLLSo2r7oH4LGodpsVgURdHQuIcURbFYLDYlVKg9sCk5wpWNiHym9pUAEQGG6EAqSxhilRQWi0VZ
Vmrz23yI5cPV1dX5TwsmWGYrb2TW36OJGjdXhryKxEeHvjR2Fgzz+bu6XnVgaHEmXhytEK0W1aUA
DJPjAL6CtPZv5rsGSvUKtv7r8/zdj+v1uoOUpsxms7qunT6+g1/TvTQCxE6XR2kBqxjyZo6K66gs
AXB1fZ3neQdJSvI8X61WpNaMWCFuKNrkGuGGmMm95fhpvPkn/f6lAgAuLy/LstyGpq7r9+8d4rAr
443qaln/ehHt1siv3dvt2B/RDpJms5lGE62gEy9az0XGcQCK3DL4DTPr0pPZEjPAZVlusoCSoihW
qzpCHy7ODRXhbUTJly9oDr4fKDaV9NZJUrszPOjsI0a/FzfwNt4eHH+BSyICqK7rqqo0u0VRrFYr
idyN87L3pBYf7qvq3wqc3DMldJmiK06pgi8uLqQjAAorRG+p+zLUxks+z7rOkOzlIUy8yrAcQFVV
3a4/ywBPmJsVMcTM3l/h9xDlLga4I1PDGaD7UNBPuCKBleUfy2gd+DOrPWubGHJJyD+L+LCTDE
XEgH//2uSxhu1/Xzocy+VSL+2cUhrqLVZ/jTYL0IMtQEklT3/iWCutzUljDDNXVSVHRFWW7SOtcc
Hag6V/AF1/slVRyOkZAAAAAElFTkSuQmCC
"""

# 96x96 背景
BG_96_BASE64 = """
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
SuQmCC
"""


class WatermarkRemover:
    """浮水印移除器"""
    
    # 浮水印移除參數設定
    ALPHA_THRESHOLD = 0.002
    MAX_ALPHA = 0.99
    DEFAULT_LOGO_VALUE = 255
    
    def __init__(self):
        self.bg_48 = self._load_base64_image(BG_48_BASE64)
        self.bg_96 = self._load_base64_image(BG_96_BASE64)
        self.alpha_map_48 = None
        self.alpha_map_96 = None
        
    def _load_base64_image(self, base64_str: str) -> Image.Image:
        """從 Base64 字串載入圖片"""
        # 移除空白和換行
        base64_str = base64_str.strip().replace('\n', '').replace('\r', '')
        image_data = base64.b64decode(base64_str)
        return Image.open(BytesIO(image_data)).convert('RGBA')
    
    def _calculate_alpha_map(self, bg_image: Image.Image) -> np.ndarray:
        """
        計算 alpha map（透明度遮罩）
        透過背景樣本計算每個像素的 alpha 強度
        """
        bg_array = np.array(bg_image, dtype=np.float32)
        height, width = bg_array.shape[:2]
        alpha_map = np.zeros((height, width), dtype=np.float32)
        
        for y in range(height):
            for x in range(width):
                r, g, b, a = bg_array[y, x]
                if a > 0:
                    # 計算與白色的差異來推算 alpha
                    max_diff = max(255 - r, 255 - g, 255 - b)
                    alpha_map[y, x] = max_diff / 255.0
                    
        return alpha_map
    
    def _get_alpha_map(self, size: int) -> np.ndarray:
        """取得指定尺寸的 alpha map"""
        if size == 48:
            if self.alpha_map_48 is None:
                self.alpha_map_48 = self._calculate_alpha_map(self.bg_48)
            return self.alpha_map_48
        elif size == 96:
            if self.alpha_map_96 is None:
                self.alpha_map_96 = self._calculate_alpha_map(self.bg_96)
            return self.alpha_map_96
        else:
            # 預設使用 48
            return self._get_alpha_map(48)
    
    def _detect_watermark_position(self, image: Image.Image) -> tuple:
        """
        偵測浮水印位置
        通常在圖片右下角
        """
        width, height = image.size
        
        # 嘗試不同的浮水印尺寸
        for wm_size in [96, 48]:
            # 計算可能的位置（右下角）
            x = width - wm_size
            y = height - wm_size
            
            if x >= 0 and y >= 0:
                # 檢查此區域是否可能有浮水印
                region = image.crop((x, y, x + wm_size, y + wm_size))
                if self._is_watermark_present(region, wm_size):
                    return (x, y, wm_size)
        
        return None
    
    def _is_watermark_present(self, region: Image.Image, size: int) -> bool:
        """
        判斷區域是否存在浮水印
        使用相關性分析
        """
        region_array = np.array(region.convert('RGBA'), dtype=np.float32)
        alpha_map = self._get_alpha_map(size)
        
        # 簡單的相關性檢測
        # 檢查區域的透明度變化是否與預期的浮水印模式匹配
        height, width = min(region_array.shape[0], alpha_map.shape[0]), min(region_array.shape[1], alpha_map.shape[1])
        
        correlation = 0
        count = 0
        
        for y in range(height):
            for x in range(width):
                if alpha_map[y, x] > self.ALPHA_THRESHOLD:
                    r, g, b = region_array[y, x, :3]
                    # 檢查是否有類似浮水印的色彩偏移
                    brightness = (r + g + b) / 3
                    if 200 < brightness < 255:
                        correlation += alpha_map[y, x]
                    count += 1
        
        if count > 0:
            avg_correlation = correlation / count
            return avg_correlation > 0.01
        
        return False
    
    def _remove_watermark_from_region(self, image: Image.Image, 
                                       position: tuple) -> Image.Image:
        """
        從指定區域移除浮水印
        使用反向 alpha 混合
        """
        x, y, size = position
        result = image.copy()
        result_array = np.array(result.convert('RGBA'), dtype=np.float32)
        
        alpha_map = self._get_alpha_map(size)
        
        # 對浮水印區域進行處理
        for dy in range(size):
            for dx in range(size):
                img_x = x + dx
                img_y = y + dy
                
                if img_y < result_array.shape[0] and img_x < result_array.shape[1]:
                    alpha = alpha_map[dy, dx]
                    
                    if alpha > self.ALPHA_THRESHOLD:
                        # 限制 alpha 最大值
                        alpha = min(alpha, self.MAX_ALPHA)
                        
                        # 反向 alpha 混合公式
                        # 原始色彩 = (混合色彩 - logo色彩 * alpha) / (1 - alpha)
                        for c in range(3):  # RGB
                            blended = result_array[img_y, img_x, c]
                            logo_value = self.DEFAULT_LOGO_VALUE
                            original = (blended - logo_value * alpha) / (1 - alpha)
                            result_array[img_y, img_x, c] = np.clip(original, 0, 255)
        
        return Image.fromarray(result_array.astype(np.uint8), 'RGBA')
    
    def remove_watermark(self, image_path: str, output_path: str = None) -> str:
        """
        移除圖片浮水印
        
        Args:
            image_path: 輸入圖片路徑
            output_path: 輸出圖片路徑（若為 None 則覆蓋原檔）
            
        Returns:
            輸出檔案路徑
        """
        # 載入圖片
        image = Image.open(image_path).convert('RGBA')
        
        # 偵測浮水印位置
        position = self._detect_watermark_position(image)
        
        if position is None:
            print(f"未偵測到浮水印: {image_path}")
            return image_path
        
        print(f"偵測到浮水印位置: x={position[0]}, y={position[1]}, size={position[2]}")
        
        # 移除浮水印
        result = self._remove_watermark_from_region(image, position)
        
        # 決定輸出路徑
        if output_path is None:
            # 在原檔名加上 _no_watermark 後綴
            base, ext = os.path.splitext(image_path)
            output_path = f"{base}_no_watermark{ext}"
        
        # 儲存結果
        if output_path.lower().endswith('.png'):
            result.save(output_path, 'PNG')
        elif output_path.lower().endswith(('.jpg', '.jpeg')):
            result.convert('RGB').save(output_path, 'JPEG', quality=95)
        else:
            result.save(output_path)
        
        print(f"已儲存: {output_path}")
        return output_path


def main():
    """主程式"""
    if len(sys.argv) < 2:
        print("使用方式: python3 remove_watermark.py <圖片路徑> [輸出路徑]")
        print("範例: python3 remove_watermark.py input.png")
        print("範例: python3 remove_watermark.py input.png output.png")
        sys.exit(1)
    
    input_path = sys.argv[1]
    output_path = sys.argv[2] if len(sys.argv) > 2 else None
    
    if not os.path.exists(input_path):
        print(f"錯誤: 找不到檔案 {input_path}")
        sys.exit(1)
    
    remover = WatermarkRemover()
    result_path = remover.remove_watermark(input_path, output_path)
    print(f"處理完成: {result_path}")


if __name__ == "__main__":
    main()
