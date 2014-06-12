Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([92.198.50.35]:33011 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756083AbaFLRGo (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 12 Jun 2014 13:06:44 -0400
From: Philipp Zabel <p.zabel@pengutronix.de>
To: linux-media@vger.kernel.org
Cc: Steve Longerbeam <steve_longerbeam@mentor.com>,
	Philipp Zabel <philipp.zabel@gmail.com>
Subject: [RFC PATCH 06/26] gpu: ipu-v3: Add support for planar YUV 4:2:2 (YUV422P) format
Date: Thu, 12 Jun 2014 19:06:20 +0200
Message-Id: <1402592800-2925-7-git-send-email-p.zabel@pengutronix.de>
In-Reply-To: <1402592800-2925-1-git-send-email-p.zabel@pengutronix.de>
References: <1402592800-2925-1-git-send-email-p.zabel@pengutronix.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Philipp Zabel <philipp.zabel@gmail.com>

Signed-off-by: Philipp Zabel <philipp.zabel@gmail.com>
---
 drivers/gpu/ipu-v3/ipu-common.c | 34 ++++++++++++++++++++++++++++++++++
 1 file changed, 34 insertions(+)

diff --git a/drivers/gpu/ipu-v3/ipu-common.c b/drivers/gpu/ipu-v3/ipu-common.c
index 7a0b377..cd4f584 100644
--- a/drivers/gpu/ipu-v3/ipu-common.c
+++ b/drivers/gpu/ipu-v3/ipu-common.c
@@ -251,6 +251,7 @@ void ipu_cpmem_set_yuv_planar_full(struct ipu_ch_param __iomem *p,
 {
 	switch (pixel_format) {
 	case V4L2_PIX_FMT_YUV420:
+	case V4L2_PIX_FMT_YUV422P:
 		ipu_ch_param_write_field(p, IPU_FIELD_SLUV, (stride / 2) - 1);
 		ipu_ch_param_write_field(p, IPU_FIELD_UBO, u_offset / 8);
 		ipu_ch_param_write_field(p, IPU_FIELD_VBO, v_offset / 8);
@@ -284,6 +285,13 @@ void ipu_cpmem_set_yuv_planar(struct ipu_ch_param __iomem *p, u32 pixel_format,
 		ipu_cpmem_set_yuv_planar_full(p, pixel_format, stride,
 				u_offset, v_offset);
 		break;
+	case V4L2_PIX_FMT_YUV422P:
+		uv_stride = stride / 2;
+		u_offset = stride * height;
+		v_offset = u_offset + (uv_stride * height);
+		ipu_cpmem_set_yuv_planar_full(p, pixel_format, stride,
+				u_offset, v_offset);
+		break;
 	case V4L2_PIX_FMT_NV12:
 		u_offset = v_offset = stride * height;
 		ipu_cpmem_set_yuv_planar_full(p, pixel_format, stride,
@@ -347,6 +355,11 @@ static const struct ipu_rgb def_bgr_16 = {
 #define V_OFFSET(pix, x, y)	((pix->width * pix->height) + \
 					(pix->width * pix->height / 4) + \
 					(pix->width * (y) / 4) + (x) / 2)
+#define U_OFFSET2(pix, x, y)	((pix->width * pix->height) + \
+					(pix->width * (y) / 2) + (x) / 2)
+#define V_OFFSET2(pix, x, y)	((pix->width * pix->height) + \
+					(pix->width * pix->height / 2) + \
+					(pix->width * (y) / 2) + (x) / 2)
 
 int ipu_cpmem_set_fmt(struct ipu_ch_param __iomem *cpmem, u32 drm_fourcc)
 {
@@ -358,6 +371,11 @@ int ipu_cpmem_set_fmt(struct ipu_ch_param __iomem *cpmem, u32 drm_fourcc)
 		/* burst size */
 		ipu_ch_param_write_field(cpmem, IPU_FIELD_NPB, 63);
 		break;
+	case DRM_FORMAT_YUV422:
+	case DRM_FORMAT_YVU422:
+		ipu_ch_param_write_field(cpmem, IPU_FIELD_PFS, 1);
+		ipu_ch_param_write_field(cpmem, IPU_FIELD_NPB, 63);
+		break;
 	case DRM_FORMAT_NV12:
 		ipu_ch_param_write_field(cpmem, IPU_FIELD_PFS, 4);
 		ipu_ch_param_write_field(cpmem, IPU_FIELD_NPB, 63);
@@ -447,6 +465,8 @@ static int v4l2_pix_fmt_to_drm_fourcc(u32 pixelformat)
 		return DRM_FORMAT_YUV420;
 	case V4L2_PIX_FMT_YVU420:
 		return DRM_FORMAT_YVU420;
+	case V4L2_PIX_FMT_YUV422P:
+		return DRM_FORMAT_YUV422;
 	case V4L2_PIX_FMT_NV12:
 		return DRM_FORMAT_NV12;
 	}
@@ -474,6 +494,8 @@ enum ipu_color_space ipu_drm_fourcc_to_colorspace(u32 drm_fourcc)
 	case DRM_FORMAT_UYVY:
 	case DRM_FORMAT_YUV420:
 	case DRM_FORMAT_YVU420:
+	case DRM_FORMAT_YUV422:
+	case DRM_FORMAT_YVU422:
 	case DRM_FORMAT_NV12:
 		return IPUV3_COLORSPACE_YUV;
 	default:
@@ -511,6 +533,17 @@ int ipu_cpmem_set_image(struct ipu_ch_param __iomem *cpmem,
 				pix->bytesperline, u_offset, v_offset);
 		ipu_cpmem_set_buffer(cpmem, 0, image->phys + y_offset);
 		break;
+	case V4L2_PIX_FMT_YUV422P:
+		y_offset = Y_OFFSET(pix, image->rect.left, image->rect.top);
+		u_offset = U_OFFSET2(pix, image->rect.left,
+				image->rect.top) - y_offset;
+		v_offset = V_OFFSET2(pix, image->rect.left,
+				image->rect.top) - y_offset;
+
+		ipu_cpmem_set_yuv_planar_full(cpmem, pix->pixelformat,
+				pix->bytesperline, u_offset, v_offset);
+		ipu_cpmem_set_buffer(cpmem, 0, image->phys + y_offset);
+		break;
 	case V4L2_PIX_FMT_NV12:
 		y_offset = Y_OFFSET(pix, image->rect.left, image->rect.top);
 		u_offset = U_OFFSET(pix, image->rect.left,
@@ -579,6 +612,7 @@ enum ipu_color_space ipu_pixelformat_to_colorspace(u32 pixelformat)
 	switch (pixelformat) {
 	case V4L2_PIX_FMT_YUV420:
 	case V4L2_PIX_FMT_YVU420:
+	case V4L2_PIX_FMT_YUV422P:
 	case V4L2_PIX_FMT_UYVY:
 	case V4L2_PIX_FMT_YUYV:
 	case V4L2_PIX_FMT_NV12:
-- 
2.0.0.rc2

