Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pb0-f44.google.com ([209.85.160.44]:56586 "EHLO
	mail-pb0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932307AbaFZBHh (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 25 Jun 2014 21:07:37 -0400
Received: by mail-pb0-f44.google.com with SMTP id md12so2421196pbc.3
        for <linux-media@vger.kernel.org>; Wed, 25 Jun 2014 18:07:36 -0700 (PDT)
From: Steve Longerbeam <slongerbeam@gmail.com>
To: linux-media@vger.kernel.org
Cc: Steve Longerbeam <steve_longerbeam@mentor.com>,
	Dmitry Eremin-Solenikov <dmitry_eremin@mentor.com>,
	Mohsin Kazmi <mohsin_kazmi@mentor.com>
Subject: [PATCH 26/28] gpu: ipu-v3: Add more planar formats support
Date: Wed, 25 Jun 2014 18:05:53 -0700
Message-Id: <1403744755-24944-27-git-send-email-steve_longerbeam@mentor.com>
In-Reply-To: <1403744755-24944-1-git-send-email-steve_longerbeam@mentor.com>
References: <1403744755-24944-1-git-send-email-steve_longerbeam@mentor.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Adds support for the following planar and partial-planar formats:

YUV422
NV12
NV21
NV16
NV61

Signed-off-by: Dmitry Eremin-Solenikov <dmitry_eremin@mentor.com>
Signed-off-by: Mohsin Kazmi <mohsin_kazmi@mentor.com>
Signed-off-by: Steve Longerbeam <steve_longerbeam@mentor.com>
---
 drivers/gpu/ipu-v3/ipu-common.c |   21 ++++++
 drivers/gpu/ipu-v3/ipu-cpmem.c  |  146 +++++++++++++++++++++++++++++++++++++--
 2 files changed, 161 insertions(+), 6 deletions(-)

diff --git a/drivers/gpu/ipu-v3/ipu-common.c b/drivers/gpu/ipu-v3/ipu-common.c
index 81930f3..115572e 100644
--- a/drivers/gpu/ipu-v3/ipu-common.c
+++ b/drivers/gpu/ipu-v3/ipu-common.c
@@ -80,6 +80,12 @@ enum ipu_color_space ipu_drm_fourcc_to_colorspace(u32 drm_fourcc)
 	case DRM_FORMAT_UYVY:
 	case DRM_FORMAT_YUV420:
 	case DRM_FORMAT_YVU420:
+	case DRM_FORMAT_YUV422:
+	case DRM_FORMAT_YVU422:
+	case DRM_FORMAT_NV12:
+	case DRM_FORMAT_NV21:
+	case DRM_FORMAT_NV16:
+	case DRM_FORMAT_NV61:
 		return IPUV3_COLORSPACE_YUV;
 	default:
 		return IPUV3_COLORSPACE_UNKNOWN;
@@ -92,8 +98,13 @@ enum ipu_color_space ipu_pixelformat_to_colorspace(u32 pixelformat)
 	switch (pixelformat) {
 	case V4L2_PIX_FMT_YUV420:
 	case V4L2_PIX_FMT_YVU420:
+	case V4L2_PIX_FMT_YUV422P:
 	case V4L2_PIX_FMT_UYVY:
 	case V4L2_PIX_FMT_YUYV:
+	case V4L2_PIX_FMT_NV12:
+	case V4L2_PIX_FMT_NV21:
+	case V4L2_PIX_FMT_NV16:
+	case V4L2_PIX_FMT_NV61:
 		return IPUV3_COLORSPACE_YUV;
 	case V4L2_PIX_FMT_RGB32:
 	case V4L2_PIX_FMT_BGR32:
@@ -112,6 +123,11 @@ bool ipu_pixelformat_is_planar(u32 pixelformat)
 	switch (pixelformat) {
 	case V4L2_PIX_FMT_YUV420:
 	case V4L2_PIX_FMT_YVU420:
+	case V4L2_PIX_FMT_YUV422P:
+	case V4L2_PIX_FMT_NV12:
+	case V4L2_PIX_FMT_NV21:
+	case V4L2_PIX_FMT_NV16:
+	case V4L2_PIX_FMT_NV61:
 		return true;
 	}
 
@@ -137,6 +153,11 @@ int ipu_stride_to_bytes(u32 pixel_stride, u32 pixelformat)
 	switch (pixelformat) {
 	case V4L2_PIX_FMT_YUV420:
 	case V4L2_PIX_FMT_YVU420:
+	case V4L2_PIX_FMT_YUV422P:
+	case V4L2_PIX_FMT_NV12:
+	case V4L2_PIX_FMT_NV21:
+	case V4L2_PIX_FMT_NV16:
+	case V4L2_PIX_FMT_NV61:
 		/*
 		 * for the planar YUV formats, the stride passed to
 		 * cpmem must be the stride in bytes of the Y plane.
diff --git a/drivers/gpu/ipu-v3/ipu-cpmem.c b/drivers/gpu/ipu-v3/ipu-cpmem.c
index cfe2f53..45a014e 100644
--- a/drivers/gpu/ipu-v3/ipu-cpmem.c
+++ b/drivers/gpu/ipu-v3/ipu-cpmem.c
@@ -193,8 +193,18 @@ static int v4l2_pix_fmt_to_drm_fourcc(u32 pixelformat)
 		return DRM_FORMAT_YUYV;
 	case V4L2_PIX_FMT_YUV420:
 		return DRM_FORMAT_YUV420;
+	case V4L2_PIX_FMT_YUV422P:
+		return DRM_FORMAT_YUV422;
 	case V4L2_PIX_FMT_YVU420:
 		return DRM_FORMAT_YVU420;
+	case V4L2_PIX_FMT_NV12:
+		return DRM_FORMAT_NV12;
+	case V4L2_PIX_FMT_NV21:
+		return DRM_FORMAT_NV21;
+	case V4L2_PIX_FMT_NV16:
+		return DRM_FORMAT_NV16;
+	case V4L2_PIX_FMT_NV61:
+		return DRM_FORMAT_NV61;
 	}
 
 	return -EINVAL;
@@ -394,6 +404,7 @@ void ipu_cpmem_set_yuv_planar_full(struct ipuv3_channel *ch,
 {
 	switch (pixel_format) {
 	case V4L2_PIX_FMT_YUV420:
+	case V4L2_PIX_FMT_YUV422P:
 		ipu_ch_param_write_field(ch, IPU_FIELD_SLUV, (stride / 2) - 1);
 		ipu_ch_param_write_field(ch, IPU_FIELD_UBO, u_offset / 8);
 		ipu_ch_param_write_field(ch, IPU_FIELD_VBO, v_offset / 8);
@@ -403,6 +414,18 @@ void ipu_cpmem_set_yuv_planar_full(struct ipuv3_channel *ch,
 		ipu_ch_param_write_field(ch, IPU_FIELD_UBO, v_offset / 8);
 		ipu_ch_param_write_field(ch, IPU_FIELD_VBO, u_offset / 8);
 		break;
+	case V4L2_PIX_FMT_NV12:
+	case V4L2_PIX_FMT_NV16:
+		ipu_ch_param_write_field(ch, IPU_FIELD_SLUV, stride - 1);
+		ipu_ch_param_write_field(ch, IPU_FIELD_UBO, u_offset / 8);
+		ipu_ch_param_write_field(ch, IPU_FIELD_VBO, u_offset / 8);
+		break;
+	case V4L2_PIX_FMT_NV21:
+	case V4L2_PIX_FMT_NV61:
+		ipu_ch_param_write_field(ch, IPU_FIELD_SLUV, stride - 1);
+		ipu_ch_param_write_field(ch, IPU_FIELD_UBO, v_offset / 8);
+		ipu_ch_param_write_field(ch, IPU_FIELD_VBO, v_offset / 8);
+		break;
 	}
 }
 EXPORT_SYMBOL_GPL(ipu_cpmem_set_yuv_planar_full);
@@ -422,6 +445,25 @@ void ipu_cpmem_set_yuv_planar(struct ipuv3_channel *ch,
 		ipu_cpmem_set_yuv_planar_full(ch, pixel_format, stride,
 					      u_offset, v_offset);
 		break;
+	case V4L2_PIX_FMT_YUV422P:
+		uv_stride = stride / 2;
+		u_offset = stride * height;
+		v_offset = u_offset + (uv_stride * height);
+		ipu_cpmem_set_yuv_planar_full(ch, pixel_format, stride,
+					      u_offset, v_offset);
+		break;
+	case V4L2_PIX_FMT_NV12:
+	case V4L2_PIX_FMT_NV16:
+		u_offset = stride * height;
+		ipu_cpmem_set_yuv_planar_full(ch, pixel_format, stride,
+					      u_offset, 0);
+		break;
+	case V4L2_PIX_FMT_NV21:
+	case V4L2_PIX_FMT_NV61:
+		v_offset = stride * height;
+		ipu_cpmem_set_yuv_planar_full(ch, pixel_format, stride,
+					      0, v_offset);
+		break;
 	}
 }
 EXPORT_SYMBOL_GPL(ipu_cpmem_set_yuv_planar);
@@ -475,11 +517,20 @@ static const struct ipu_rgb def_bgr_16 = {
 };
 
 #define Y_OFFSET(pix, x, y)	((x) + pix->width * (y))
-#define U_OFFSET(pix, x, y)	((pix->width * pix->height) + \
-					(pix->width * (y) / 4) + (x) / 2)
-#define V_OFFSET(pix, x, y)	((pix->width * pix->height) + \
-					(pix->width * pix->height / 4) + \
-					(pix->width * (y) / 4) + (x) / 2)
+#define U_OFFSET(pix, x, y)	((pix->width * pix->height) +		\
+				 (pix->width * (y) / 4) + (x) / 2)
+#define V_OFFSET(pix, x, y)	((pix->width * pix->height) +		\
+				 (pix->width * pix->height / 4) +	\
+				 (pix->width * (y) / 4) + (x) / 2)
+#define U2_OFFSET(pix, x, y)	((pix->width * pix->height) +		\
+				 (pix->width * (y) / 2) + (x) / 2)
+#define V2_OFFSET(pix, x, y)	((pix->width * pix->height) +		\
+				 (pix->width * pix->height / 2) +	\
+				 (pix->width * (y) / 2) + (x) / 2)
+#define UV_OFFSET(pix, x, y)	((pix->width * pix->height) +	\
+				 (pix->width * (y) / 2) + (x))
+#define UV2_OFFSET(pix, x, y)	((pix->width * pix->height) +	\
+				 (pix->width * y) + (x))
 
 int ipu_cpmem_set_fmt(struct ipuv3_channel *ch, u32 drm_fourcc)
 {
@@ -491,6 +542,27 @@ int ipu_cpmem_set_fmt(struct ipuv3_channel *ch, u32 drm_fourcc)
 		/* burst size */
 		ipu_ch_param_write_field(ch, IPU_FIELD_NPB, 31);
 		break;
+	case DRM_FORMAT_YUV422:
+	case DRM_FORMAT_YVU422:
+		/* pix format */
+		ipu_ch_param_write_field(ch, IPU_FIELD_PFS, 1);
+		/* burst size */
+		ipu_ch_param_write_field(ch, IPU_FIELD_NPB, 31);
+		break;
+	case DRM_FORMAT_NV12:
+	case DRM_FORMAT_NV21:
+		/* pix format */
+		ipu_ch_param_write_field(ch, IPU_FIELD_PFS, 4);
+		/* burst size */
+		ipu_ch_param_write_field(ch, IPU_FIELD_NPB, 31);
+		break;
+	case DRM_FORMAT_NV16:
+	case DRM_FORMAT_NV61:
+		/* pix format */
+		ipu_ch_param_write_field(ch, IPU_FIELD_PFS, 3);
+		/* burst size */
+		ipu_ch_param_write_field(ch, IPU_FIELD_NPB, 31);
+		break;
 	case DRM_FORMAT_UYVY:
 		/* bits/pixel */
 		ipu_ch_param_write_field(ch, IPU_FIELD_BPP, 3);
@@ -559,7 +631,69 @@ int ipu_cpmem_set_image(struct ipuv3_channel *ch, struct ipu_image *image)
 				    image->rect.top) - y_offset;
 
 		ipu_cpmem_set_yuv_planar_full(ch, pix->pixelformat,
-				pix->bytesperline, u_offset, v_offset);
+					      pix->bytesperline,
+					      u_offset, v_offset);
+		ipu_cpmem_set_buffer(ch, 0, image->phys0 + y_offset);
+		ipu_cpmem_set_buffer(ch, 1, image->phys1 + y_offset);
+		break;
+	case V4L2_PIX_FMT_YUV422P:
+		y_offset = Y_OFFSET(pix, image->rect.left, image->rect.top);
+		u_offset = U2_OFFSET(pix, image->rect.left,
+				     image->rect.top) - y_offset;
+		v_offset = V2_OFFSET(pix, image->rect.left,
+				     image->rect.top) - y_offset;
+
+		ipu_cpmem_set_yuv_planar_full(ch, pix->pixelformat,
+					      pix->bytesperline,
+					      u_offset, v_offset);
+		ipu_cpmem_set_buffer(ch, 0, image->phys0 + y_offset);
+		ipu_cpmem_set_buffer(ch, 1, image->phys1 + y_offset);
+		break;
+	case V4L2_PIX_FMT_NV12:
+		y_offset = Y_OFFSET(pix, image->rect.left, image->rect.top);
+		u_offset = UV_OFFSET(pix, image->rect.left,
+				     image->rect.top) - y_offset;
+		v_offset = 0;
+
+		ipu_cpmem_set_yuv_planar_full(ch, pix->pixelformat,
+					      pix->bytesperline,
+					      u_offset, v_offset);
+		ipu_cpmem_set_buffer(ch, 0, image->phys0 + y_offset);
+		ipu_cpmem_set_buffer(ch, 1, image->phys1 + y_offset);
+		break;
+	case V4L2_PIX_FMT_NV21:
+		y_offset = Y_OFFSET(pix, image->rect.left, image->rect.top);
+		u_offset = 0;
+		v_offset = UV_OFFSET(pix, image->rect.left,
+				     image->rect.top) - y_offset;
+
+		ipu_cpmem_set_yuv_planar_full(ch, pix->pixelformat,
+					      pix->bytesperline,
+					      u_offset, v_offset);
+		ipu_cpmem_set_buffer(ch, 0, image->phys0 + y_offset);
+		ipu_cpmem_set_buffer(ch, 1, image->phys1 + y_offset);
+		break;
+	case V4L2_PIX_FMT_NV16:
+		y_offset = Y_OFFSET(pix, image->rect.left, image->rect.top);
+		u_offset = UV2_OFFSET(pix, image->rect.left,
+				      image->rect.top) - y_offset;
+		v_offset = 0;
+
+		ipu_cpmem_set_yuv_planar_full(ch, pix->pixelformat,
+					      pix->bytesperline,
+					      u_offset, v_offset);
+		ipu_cpmem_set_buffer(ch, 0, image->phys0 + y_offset);
+		ipu_cpmem_set_buffer(ch, 1, image->phys1 + y_offset);
+		break;
+	case V4L2_PIX_FMT_NV61:
+		y_offset = Y_OFFSET(pix, image->rect.left, image->rect.top);
+		u_offset = 0;
+		v_offset = UV2_OFFSET(pix, image->rect.left,
+				      image->rect.top) - y_offset;
+
+		ipu_cpmem_set_yuv_planar_full(ch, pix->pixelformat,
+					      pix->bytesperline,
+					      u_offset, v_offset);
 		ipu_cpmem_set_buffer(ch, 0, image->phys0 + y_offset);
 		ipu_cpmem_set_buffer(ch, 1, image->phys1 + y_offset);
 		break;
-- 
1.7.9.5

