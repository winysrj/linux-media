Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pb0-f41.google.com ([209.85.160.41]:34984 "EHLO
	mail-pb0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932324AbaFZBHg (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 25 Jun 2014 21:07:36 -0400
Received: by mail-pb0-f41.google.com with SMTP id ma3so2408275pbc.28
        for <linux-media@vger.kernel.org>; Wed, 25 Jun 2014 18:07:35 -0700 (PDT)
From: Steve Longerbeam <slongerbeam@gmail.com>
To: linux-media@vger.kernel.org
Cc: Steve Longerbeam <steve_longerbeam@mentor.com>
Subject: [PATCH 25/28] gpu: ipu-cpmem: Add second buffer support to ipu_cpmem_set_image()
Date: Wed, 25 Jun 2014 18:05:52 -0700
Message-Id: <1403744755-24944-26-git-send-email-steve_longerbeam@mentor.com>
In-Reply-To: <1403744755-24944-1-git-send-email-steve_longerbeam@mentor.com>
References: <1403744755-24944-1-git-send-email-steve_longerbeam@mentor.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add a second buffer physaddr to struct ipu_image, for double-buffering
support.

Signed-off-by: Steve Longerbeam <steve_longerbeam@mentor.com>
---
 drivers/gpu/ipu-v3/ipu-cpmem.c |   32 ++++++++++++++++----------------
 include/video/imx-ipu-v3.h     |    3 ++-
 2 files changed, 18 insertions(+), 17 deletions(-)

diff --git a/drivers/gpu/ipu-v3/ipu-cpmem.c b/drivers/gpu/ipu-v3/ipu-cpmem.c
index f52e4b4..cfe2f53 100644
--- a/drivers/gpu/ipu-v3/ipu-cpmem.c
+++ b/drivers/gpu/ipu-v3/ipu-cpmem.c
@@ -538,7 +538,7 @@ EXPORT_SYMBOL_GPL(ipu_cpmem_set_fmt);
 int ipu_cpmem_set_image(struct ipuv3_channel *ch, struct ipu_image *image)
 {
 	struct v4l2_pix_format *pix = &image->pix;
-	int y_offset, u_offset, v_offset;
+	int offset, y_offset, u_offset, v_offset;
 
 	pr_debug("%s: resolution: %dx%d stride: %d\n",
 		 __func__, pix->width, pix->height,
@@ -560,30 +560,30 @@ int ipu_cpmem_set_image(struct ipuv3_channel *ch, struct ipu_image *image)
 
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
diff --git a/include/video/imx-ipu-v3.h b/include/video/imx-ipu-v3.h
index 3d3cea0..542652f 100644
--- a/include/video/imx-ipu-v3.h
+++ b/include/video/imx-ipu-v3.h
@@ -221,7 +221,8 @@ struct ipu_rgb {
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

