Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pb0-f45.google.com ([209.85.160.45]:41501 "EHLO
	mail-pb0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932176AbaFZBH2 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 25 Jun 2014 21:07:28 -0400
Received: by mail-pb0-f45.google.com with SMTP id rr13so2399616pbb.18
        for <linux-media@vger.kernel.org>; Wed, 25 Jun 2014 18:07:28 -0700 (PDT)
From: Steve Longerbeam <slongerbeam@gmail.com>
To: linux-media@vger.kernel.org
Cc: Steve Longerbeam <steve_longerbeam@mentor.com>
Subject: [PATCH 16/28] gpu: ipu-v3: Add ipu_stride_to_bytes()
Date: Wed, 25 Jun 2014 18:05:43 -0700
Message-Id: <1403744755-24944-17-git-send-email-steve_longerbeam@mentor.com>
In-Reply-To: <1403744755-24944-1-git-send-email-steve_longerbeam@mentor.com>
References: <1403744755-24944-1-git-send-email-steve_longerbeam@mentor.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Adds ipu_stride_to_bytes(), which converts a pixel stride to bytes,
suitable for passing to cpmem.

Signed-off-by: Steve Longerbeam <steve_longerbeam@mentor.com>
---
 drivers/gpu/ipu-v3/ipu-common.c |   30 ++++++++++++++++++++++++++++++
 include/video/imx-ipu-v3.h      |    1 +
 2 files changed, 31 insertions(+)

diff --git a/drivers/gpu/ipu-v3/ipu-common.c b/drivers/gpu/ipu-v3/ipu-common.c
index 7701974..30afef4 100644
--- a/drivers/gpu/ipu-v3/ipu-common.c
+++ b/drivers/gpu/ipu-v3/ipu-common.c
@@ -576,6 +576,36 @@ enum ipu_color_space ipu_mbus_code_to_colorspace(u32 mbus_code)
 }
 EXPORT_SYMBOL_GPL(ipu_mbus_code_to_colorspace);
 
+int ipu_stride_to_bytes(u32 pixel_stride, u32 pixelformat)
+{
+	switch (pixelformat) {
+	case V4L2_PIX_FMT_YUV420:
+	case V4L2_PIX_FMT_YVU420:
+		/*
+		 * for the planar YUV formats, the stride passed to
+		 * cpmem must be the stride in bytes of the Y plane.
+		 * And all the planar YUV formats have an 8-bit
+		 * Y component.
+		 */
+		return (8 * pixel_stride) >> 3;
+	case V4L2_PIX_FMT_RGB565:
+	case V4L2_PIX_FMT_YUYV:
+	case V4L2_PIX_FMT_UYVY:
+		return (16 * pixel_stride) >> 3;
+	case V4L2_PIX_FMT_BGR24:
+	case V4L2_PIX_FMT_RGB24:
+		return (24 * pixel_stride) >> 3;
+	case V4L2_PIX_FMT_BGR32:
+	case V4L2_PIX_FMT_RGB32:
+		return (32 * pixel_stride) >> 3;
+	default:
+		break;
+	}
+
+	return -EINVAL;
+}
+EXPORT_SYMBOL_GPL(ipu_stride_to_bytes);
+
 int ipu_degrees_to_rot_mode(enum ipu_rotate_mode *mode, int degrees,
 			    bool hflip, bool vflip)
 {
diff --git a/include/video/imx-ipu-v3.h b/include/video/imx-ipu-v3.h
index 9ed1c75..17a0bb8 100644
--- a/include/video/imx-ipu-v3.h
+++ b/include/video/imx-ipu-v3.h
@@ -480,6 +480,7 @@ int ipu_cpmem_set_image(struct ipu_ch_param __iomem *cpmem,
 enum ipu_color_space ipu_drm_fourcc_to_colorspace(u32 drm_fourcc);
 enum ipu_color_space ipu_pixelformat_to_colorspace(u32 pixelformat);
 enum ipu_color_space ipu_mbus_code_to_colorspace(u32 mbus_code);
+int ipu_stride_to_bytes(u32 pixel_stride, u32 pixelformat);
 bool ipu_pixelformat_is_planar(u32 pixelformat);
 int ipu_degrees_to_rot_mode(enum ipu_rotate_mode *mode, int degrees,
 			    bool hflip, bool vflip);
-- 
1.7.9.5

