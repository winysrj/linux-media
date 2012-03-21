Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:56800 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030892Ab2CULPl (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 21 Mar 2012 07:15:41 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: linux-media@vger.kernel.org
Subject: [PATCH v2 10/9] sh_mobile_ceu_camera: Support user-configurable line stride
Date: Wed, 21 Mar 2012 12:16:05 +0100
Message-Id: <1332328565-6260-1-git-send-email-laurent.pinchart@ideasonboard.com>
In-Reply-To: <1332327808-6056-1-git-send-email-laurent.pinchart@ideasonboard.com>
References: <1332327808-6056-1-git-send-email-laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

In image mode, the CEU allows configurable line strides up to 8188
pixels.

Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 drivers/media/video/sh_mobile_ceu_camera.c |   25 +++++++++++++++++--------
 1 files changed, 17 insertions(+), 8 deletions(-)

Hi Guennadi,

This patch was missing from my "soc-camera: Add support for configurable line
stride" series. It applies on top of the other 9 patches. Sorry about that.

diff --git a/drivers/media/video/sh_mobile_ceu_camera.c b/drivers/media/video/sh_mobile_ceu_camera.c
index b8801bd..6d96136 100644
--- a/drivers/media/video/sh_mobile_ceu_camera.c
+++ b/drivers/media/video/sh_mobile_ceu_camera.c
@@ -338,19 +338,15 @@ static int sh_mobile_ceu_capture(struct sh_mobile_ceu_dev *pcdev)
 
 	ceu_write(pcdev, top1, phys_addr_top);
 	if (V4L2_FIELD_NONE != pcdev->field) {
-		if (planar)
-			phys_addr_bottom = phys_addr_top + icd->user_width;
-		else
-			phys_addr_bottom = phys_addr_top + icd->bytesperline;
+		phys_addr_bottom = phys_addr_top + icd->bytesperline;
 		ceu_write(pcdev, bottom1, phys_addr_bottom);
 	}
 
 	if (planar) {
-		phys_addr_top += icd->user_width *
-			icd->user_height;
+		phys_addr_top += icd->bytesperline * icd->user_height;
 		ceu_write(pcdev, top2, phys_addr_top);
 		if (V4L2_FIELD_NONE != pcdev->field) {
-			phys_addr_bottom = phys_addr_top + icd->user_width;
+			phys_addr_bottom = phys_addr_top + icd->bytesperline;
 			ceu_write(pcdev, bottom2, phys_addr_bottom);
 		}
 	}
@@ -677,7 +673,7 @@ static void sh_mobile_ceu_set_rect(struct soc_camera_device *icd)
 			in_width *= 2;
 			left_offset *= 2;
 		}
-		cdwdr_width = width;
+		cdwdr_width = icd->bytesperline;
 	} else {
 		int bytes_per_line = soc_mbus_bytes_per_line(width,
 						icd->current_fmt->host_fmt);
@@ -1834,6 +1830,8 @@ static int sh_mobile_ceu_set_fmt(struct soc_camera_device *icd,
 	return 0;
 }
 
+#define CEU_CHDW_MAX	8188U	/* Maximum line stride */
+
 static int sh_mobile_ceu_try_fmt(struct soc_camera_device *icd,
 				 struct v4l2_format *f)
 {
@@ -1910,10 +1908,20 @@ static int sh_mobile_ceu_try_fmt(struct soc_camera_device *icd,
 			pix->width = width;
 		if (mf.height > height)
 			pix->height = height;
+
+		pix->bytesperline = max(pix->bytesperline, pix->width);
+		pix->bytesperline = min(pix->bytesperline, CEU_CHDW_MAX);
+		pix->bytesperline &= ~3;
+		break;
+
+	default:
+		/* Configurable stride isn't supported in pass-through mode. */
+		pix->bytesperline  = 0;
 	}
 
 	pix->width	&= ~3;
 	pix->height	&= ~3;
+	pix->sizeimage	= 0;
 
 	dev_geo(icd->parent, "%s(): return %d, fmt 0x%x, %ux%u\n",
 		__func__, ret, pix->pixelformat, pix->width, pix->height);
@@ -2129,6 +2137,7 @@ static int __devinit sh_mobile_ceu_probe(struct platform_device *pdev)
 	pcdev->ici.nr = pdev->id;
 	pcdev->ici.drv_name = dev_name(&pdev->dev);
 	pcdev->ici.ops = &sh_mobile_ceu_host_ops;
+	pcdev->ici.capabilities = SOCAM_HOST_CAP_STRIDE;
 
 	pcdev->alloc_ctx = vb2_dma_contig_init_ctx(&pdev->dev);
 	if (IS_ERR(pcdev->alloc_ctx)) {
-- 
Regards,

Laurent Pinchart

