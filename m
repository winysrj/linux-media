Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([92.198.50.35]:33008 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756077AbaFLRGo (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 12 Jun 2014 13:06:44 -0400
From: Philipp Zabel <p.zabel@pengutronix.de>
To: linux-media@vger.kernel.org
Cc: Steve Longerbeam <steve_longerbeam@mentor.com>,
	Philipp Zabel <philipp.zabel@gmail.com>
Subject: [RFC PATCH 05/26] gpu: ipu-v3: Add support for partial interleaved YCbCr 4:2:0 (NV12) format
Date: Thu, 12 Jun 2014 19:06:19 +0200
Message-Id: <1402592800-2925-6-git-send-email-p.zabel@pengutronix.de>
In-Reply-To: <1402592800-2925-1-git-send-email-p.zabel@pengutronix.de>
References: <1402592800-2925-1-git-send-email-p.zabel@pengutronix.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Philipp Zabel <philipp.zabel@gmail.com>

The partial interleaved format consists of two planes, one with 8-bit
luma (Y) values, and one with alternating 8-bit chroma (CbCr) values.
This format can be produced by CODA960 VPU and VDOA.

Signed-off-by: Philipp Zabel <philipp.zabel@gmail.com>
---
 drivers/gpu/ipu-v3/ipu-common.c | 31 +++++++++++++++++++++++++++++++
 1 file changed, 31 insertions(+)

diff --git a/drivers/gpu/ipu-v3/ipu-common.c b/drivers/gpu/ipu-v3/ipu-common.c
index 94b9e8e..7a0b377 100644
--- a/drivers/gpu/ipu-v3/ipu-common.c
+++ b/drivers/gpu/ipu-v3/ipu-common.c
@@ -260,6 +260,11 @@ void ipu_cpmem_set_yuv_planar_full(struct ipu_ch_param __iomem *p,
 		ipu_ch_param_write_field(p, IPU_FIELD_UBO, v_offset / 8);
 		ipu_ch_param_write_field(p, IPU_FIELD_VBO, u_offset / 8);
 		break;
+	case V4L2_PIX_FMT_NV12:
+		ipu_ch_param_write_field(p, IPU_FIELD_SLUV, stride - 1);
+		ipu_ch_param_write_field(p, IPU_FIELD_UBO, u_offset / 8);
+		ipu_ch_param_write_field(p, IPU_FIELD_VBO, u_offset / 8);
+		break;
 	}
 }
 EXPORT_SYMBOL_GPL(ipu_cpmem_set_yuv_planar_full);
@@ -279,6 +284,11 @@ void ipu_cpmem_set_yuv_planar(struct ipu_ch_param __iomem *p, u32 pixel_format,
 		ipu_cpmem_set_yuv_planar_full(p, pixel_format, stride,
 				u_offset, v_offset);
 		break;
+	case V4L2_PIX_FMT_NV12:
+		u_offset = v_offset = stride * height;
+		ipu_cpmem_set_yuv_planar_full(p, pixel_format, stride,
+				u_offset, v_offset);
+		break;
 	}
 }
 EXPORT_SYMBOL_GPL(ipu_cpmem_set_yuv_planar);
@@ -348,6 +358,10 @@ int ipu_cpmem_set_fmt(struct ipu_ch_param __iomem *cpmem, u32 drm_fourcc)
 		/* burst size */
 		ipu_ch_param_write_field(cpmem, IPU_FIELD_NPB, 63);
 		break;
+	case DRM_FORMAT_NV12:
+		ipu_ch_param_write_field(cpmem, IPU_FIELD_PFS, 4);
+		ipu_ch_param_write_field(cpmem, IPU_FIELD_NPB, 63);
+		break;
 	case DRM_FORMAT_UYVY:
 		/* bits/pixel */
 		ipu_ch_param_write_field(cpmem, IPU_FIELD_BPP, 3);
@@ -433,6 +447,8 @@ static int v4l2_pix_fmt_to_drm_fourcc(u32 pixelformat)
 		return DRM_FORMAT_YUV420;
 	case V4L2_PIX_FMT_YVU420:
 		return DRM_FORMAT_YVU420;
+	case V4L2_PIX_FMT_NV12:
+		return DRM_FORMAT_NV12;
 	}
 
 	return -EINVAL;
@@ -458,6 +474,7 @@ enum ipu_color_space ipu_drm_fourcc_to_colorspace(u32 drm_fourcc)
 	case DRM_FORMAT_UYVY:
 	case DRM_FORMAT_YUV420:
 	case DRM_FORMAT_YVU420:
+	case DRM_FORMAT_NV12:
 		return IPUV3_COLORSPACE_YUV;
 	default:
 		return IPUV3_COLORSPACE_UNKNOWN;
@@ -494,6 +511,19 @@ int ipu_cpmem_set_image(struct ipu_ch_param __iomem *cpmem,
 				pix->bytesperline, u_offset, v_offset);
 		ipu_cpmem_set_buffer(cpmem, 0, image->phys + y_offset);
 		break;
+	case V4L2_PIX_FMT_NV12:
+		y_offset = Y_OFFSET(pix, image->rect.left, image->rect.top);
+		u_offset = U_OFFSET(pix, image->rect.left,
+				image->rect.top) - y_offset;
+
+		ipu_cpmem_set_yuv_planar_full(cpmem, pix->pixelformat,
+				pix->bytesperline, u_offset, u_offset);
+		ipu_cpmem_set_buffer(cpmem, 0, image->phys + y_offset);
+		break;
+		ipu_cpmem_set_yuv_planar_full(cpmem, pix->pixelformat,
+				pix->bytesperline, u_offset, v_offset);
+		ipu_cpmem_set_buffer(cpmem, 0, image->phys + y_offset);
+		break;
 	case V4L2_PIX_FMT_UYVY:
 	case V4L2_PIX_FMT_YUYV:
 		ipu_cpmem_set_buffer(cpmem, 0, image->phys +
@@ -551,6 +581,7 @@ enum ipu_color_space ipu_pixelformat_to_colorspace(u32 pixelformat)
 	case V4L2_PIX_FMT_YVU420:
 	case V4L2_PIX_FMT_UYVY:
 	case V4L2_PIX_FMT_YUYV:
+	case V4L2_PIX_FMT_NV12:
 		return IPUV3_COLORSPACE_YUV;
 	case V4L2_PIX_FMT_RGB32:
 	case V4L2_PIX_FMT_BGR32:
-- 
2.0.0.rc2

