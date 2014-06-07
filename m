Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pb0-f47.google.com ([209.85.160.47]:46297 "EHLO
	mail-pb0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753324AbaFGV5W (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 7 Jun 2014 17:57:22 -0400
Received: by mail-pb0-f47.google.com with SMTP id rp16so3919239pbb.34
        for <linux-media@vger.kernel.org>; Sat, 07 Jun 2014 14:57:21 -0700 (PDT)
From: Steve Longerbeam <slongerbeam@gmail.com>
To: linux-media@vger.kernel.org
Cc: Steve Longerbeam <steve_longerbeam@mentor.com>
Subject: [PATCH 21/43] imx-drm: ipu-v3: Add ipu_bits_per_pixel()
Date: Sat,  7 Jun 2014 14:56:23 -0700
Message-Id: <1402178205-22697-22-git-send-email-steve_longerbeam@mentor.com>
In-Reply-To: <1402178205-22697-1-git-send-email-steve_longerbeam@mentor.com>
References: <1402178205-22697-1-git-send-email-steve_longerbeam@mentor.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add simple conversion from pixelformat to total bits-per-pixel.

Signed-off-by: Steve Longerbeam <steve_longerbeam@mentor.com>
---
 drivers/staging/imx-drm/ipu-v3/ipu-common.c |   27 +++++++++++++++++++++++++++
 include/linux/platform_data/imx-ipu-v3.h    |    1 +
 2 files changed, 28 insertions(+)

diff --git a/drivers/staging/imx-drm/ipu-v3/ipu-common.c b/drivers/staging/imx-drm/ipu-v3/ipu-common.c
index de66d02..8a03ad2 100644
--- a/drivers/staging/imx-drm/ipu-v3/ipu-common.c
+++ b/drivers/staging/imx-drm/ipu-v3/ipu-common.c
@@ -606,6 +606,33 @@ int ipu_stride_to_bytes(u32 pixel_stride, u32 pixelformat)
 }
 EXPORT_SYMBOL_GPL(ipu_stride_to_bytes);
 
+/*
+ * Standard bpp from pixel format.
+ */
+int ipu_bits_per_pixel(u32 pixelformat)
+{
+	switch (pixelformat) {
+	case V4L2_PIX_FMT_YUV420:
+	case V4L2_PIX_FMT_YVU420:
+		return 12;
+	case V4L2_PIX_FMT_RGB565:
+	case V4L2_PIX_FMT_YUYV:
+	case V4L2_PIX_FMT_UYVY:
+		return 16;
+	case V4L2_PIX_FMT_BGR24:
+	case V4L2_PIX_FMT_RGB24:
+		return 24;
+	case V4L2_PIX_FMT_BGR32:
+	case V4L2_PIX_FMT_RGB32:
+		return 32;
+	default:
+		break;
+	}
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(ipu_bits_per_pixel);
+
 int ipu_degrees_to_rot_mode(enum ipu_rotate_mode *mode, int degrees,
 			    bool hflip, bool vflip)
 {
diff --git a/include/linux/platform_data/imx-ipu-v3.h b/include/linux/platform_data/imx-ipu-v3.h
index 75a6a5d..49e69a9 100644
--- a/include/linux/platform_data/imx-ipu-v3.h
+++ b/include/linux/platform_data/imx-ipu-v3.h
@@ -510,6 +510,7 @@ enum ipu_color_space ipu_drm_fourcc_to_colorspace(u32 drm_fourcc);
 enum ipu_color_space ipu_pixelformat_to_colorspace(u32 pixelformat);
 enum ipu_color_space ipu_mbus_code_to_colorspace(u32 mbus_code);
 int ipu_stride_to_bytes(u32 pixel_stride, u32 pixelformat);
+int ipu_bits_per_pixel(u32 pixelformat);
 bool ipu_pixelformat_is_planar(u32 pixelformat);
 int ipu_degrees_to_rot_mode(enum ipu_rotate_mode *mode, int degrees,
 			    bool hflip, bool vflip);
-- 
1.7.9.5

