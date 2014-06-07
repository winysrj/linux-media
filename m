Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pb0-f42.google.com ([209.85.160.42]:43393 "EHLO
	mail-pb0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753357AbaFGV51 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 7 Jun 2014 17:57:27 -0400
Received: by mail-pb0-f42.google.com with SMTP id md12so3891849pbc.15
        for <linux-media@vger.kernel.org>; Sat, 07 Jun 2014 14:57:27 -0700 (PDT)
From: Steve Longerbeam <slongerbeam@gmail.com>
To: linux-media@vger.kernel.org
Cc: Steve Longerbeam <steve_longerbeam@mentor.com>
Subject: [PATCH 26/43] imx-drm: ipu-cpmem: Add second buffer support to ipu_cpmem_set_image()
Date: Sat,  7 Jun 2014 14:56:28 -0700
Message-Id: <1402178205-22697-27-git-send-email-steve_longerbeam@mentor.com>
In-Reply-To: <1402178205-22697-1-git-send-email-steve_longerbeam@mentor.com>
References: <1402178205-22697-1-git-send-email-steve_longerbeam@mentor.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add a second buffer physaddr to struct ipu_image, for double-buffering
support.

Signed-off-by: Steve Longerbeam <steve_longerbeam@mentor.com>
---
 drivers/staging/imx-drm/ipu-v3/ipu-cpmem.c |   32 ++++++++++++++--------------
 include/linux/platform_data/imx-ipu-v3.h   |    3 ++-
 2 files changed, 18 insertions(+), 17 deletions(-)

diff --git a/drivers/staging/imx-drm/ipu-v3/ipu-cpmem.c b/drivers/staging/imx-drm/ipu-v3/ipu-cpmem.c
index bd76a38..70e90b40 100644
--- a/drivers/staging/imx-drm/ipu-v3/ipu-cpmem.c
+++ b/drivers/staging/imx-drm/ipu-v3/ipu-cpmem.c
@@ -535,7 +535,7 @@ EXPORT_SYMBOL_GPL(ipu_cpmem_set_fmt);
 int ipu_cpmem_set_image(struct ipuv3_channel *ch, struct ipu_image *image)
 {
 	struct v4l2_pix_format *pix = &image->pix;
-	int y_offset, u_offset, v_offset;
+	int offset, y_offset, u_offset, v_offset;
 
 	pr_debug("%s: resolution: %dx%d stride: %d\n",
 		 __func__, pix->width, pix->height,
@@ -557,30 +557,30 @@ int ipu_cpmem_set_image(struct ipuv3_channel *ch, struct ipu_image *image)
 
 		ipu_cpmem_set_yuv_planar_full(ch, pix->pixelformat,
 				pix->bytesperline, u_offset, v_offset);
-		ipu_cpmem_set_buffer(ch, 0, image->phys + y_offset);
+		ipu_cpmem_set_buffer(ch, 0, image->phys0 + y_offset);
+		ipu_cpmem_set_buffer(ch, 1, image->phys1 + y_offset);
 		break;
 	case V4L2_PIX_FMT_UYVY:
 	case V4L2_PIX_FMT_YUYV:
-		ipu_cpmem_set_buffer(ch, 0, image->phys +
-				     image->rect.left * 2 +
-				     image->rect.top * image->pix.bytesperline);
+	case V4L2_PIX_FMT_RGB565:
+		offset = image->rect.left * 2 +
+			image->rect.top * pix->bytesperline;
+		ipu_cpmem_set_buffer(ch, 0, image->phys0 + offset);
+		ipu_cpmem_set_buffer(ch, 1, image->phys1 + offset);
 		break;
 	case V4L2_PIX_FMT_RGB32:
 	case V4L2_PIX_FMT_BGR32:
-		ipu_cpmem_set_buffer(ch, 0, image->phys +
-				     image->rect.left * 4 +
-				     image->rect.top * image->pix.bytesperline);
-		break;
-	case V4L2_PIX_FMT_RGB565:
-		ipu_cpmem_set_buffer(ch, 0, image->phys +
-				     image->rect.left * 2 +
-				     image->rect.top * image->pix.bytesperline);
+		offset = image->rect.left * 4 +
+			image->rect.top * pix->bytesperline;
+		ipu_cpmem_set_buffer(ch, 0, image->phys0 + offset);
+		ipu_cpmem_set_buffer(ch, 1, image->phys1 + offset);
 		break;
 	case V4L2_PIX_FMT_RGB24:
 	case V4L2_PIX_FMT_BGR24:
-		ipu_cpmem_set_buffer(ch, 0, image->phys +
-				     image->rect.left * 3 +
-				     image->rect.top * image->pix.bytesperline);
+		offset = image->rect.left * 3 +
+			image->rect.top * pix->bytesperline;
+		ipu_cpmem_set_buffer(ch, 0, image->phys0 + offset);
+		ipu_cpmem_set_buffer(ch, 1, image->phys1 + offset);
 		break;
 	default:
 		return -EINVAL;
diff --git a/include/linux/platform_data/imx-ipu-v3.h b/include/linux/platform_data/imx-ipu-v3.h
index 53aab16..4575657 100644
--- a/include/linux/platform_data/imx-ipu-v3.h
+++ b/include/linux/platform_data/imx-ipu-v3.h
@@ -219,7 +219,8 @@ struct ipu_rgb {
 struct ipu_image {
 	struct v4l2_pix_format pix;
 	struct v4l2_rect rect;
-	dma_addr_t phys;
+	dma_addr_t phys0;
+	dma_addr_t phys1;
 };
 
 void ipu_cpmem_zero(struct ipuv3_channel *ch);
-- 
1.7.9.5

