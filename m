Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:57773 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758578Ab2CULDN (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 21 Mar 2012 07:03:13 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: linux-media@vger.kernel.org
Subject: [PATCH v2 3/9] soc_camera: Use soc_camera_device::bytesperline to compute line sizes
Date: Wed, 21 Mar 2012 12:03:22 +0100
Message-Id: <1332327808-6056-4-git-send-email-laurent.pinchart@ideasonboard.com>
In-Reply-To: <1332327808-6056-1-git-send-email-laurent.pinchart@ideasonboard.com>
References: <1332327808-6056-1-git-send-email-laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Instead of computing the line sizes, use the previously negotiated
soc_camera_device::bytesperline value.

Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 drivers/media/video/mx3_camera.c           |    7 ++-----
 drivers/media/video/sh_mobile_ceu_camera.c |    4 +---
 2 files changed, 3 insertions(+), 8 deletions(-)

diff --git a/drivers/media/video/mx3_camera.c b/drivers/media/video/mx3_camera.c
index f8ce875..66d9a24 100644
--- a/drivers/media/video/mx3_camera.c
+++ b/drivers/media/video/mx3_camera.c
@@ -265,13 +265,10 @@ static void mx3_videobuf_queue(struct vb2_buffer *vb)
 	struct idmac_channel *ichan = mx3_cam->idmac_channel[0];
 	struct idmac_video_param *video = &ichan->params.video;
 	const struct soc_mbus_pixelfmt *host_fmt = icd->current_fmt->host_fmt;
-	int bytes_per_line = soc_mbus_bytes_per_line(icd->user_width, host_fmt);
 	unsigned long flags;
 	dma_cookie_t cookie;
 	size_t new_size;
 
-	BUG_ON(bytes_per_line <= 0);
-
 	new_size = icd->sizeimage;
 
 	if (vb2_plane_size(vb, 0) < new_size) {
@@ -312,9 +309,9 @@ static void mx3_videobuf_queue(struct vb2_buffer *vb)
 		 * horizontal parameters in this case are expressed in bytes,
 		 * not in pixels.
 		 */
-		video->out_width	= bytes_per_line;
+		video->out_width	= icd->bytesperline;
 		video->out_height	= icd->user_height;
-		video->out_stride	= bytes_per_line;
+		video->out_stride	= icd->bytesperline;
 	} else {
 		/*
 		 * For IPU known formats the pixel unit will be managed
diff --git a/drivers/media/video/sh_mobile_ceu_camera.c b/drivers/media/video/sh_mobile_ceu_camera.c
index f5aa369..932ed5e 100644
--- a/drivers/media/video/sh_mobile_ceu_camera.c
+++ b/drivers/media/video/sh_mobile_ceu_camera.c
@@ -333,9 +333,7 @@ static int sh_mobile_ceu_capture(struct sh_mobile_ceu_dev *pcdev)
 		if (planar)
 			phys_addr_bottom = phys_addr_top + icd->user_width;
 		else
-			phys_addr_bottom = phys_addr_top +
-				soc_mbus_bytes_per_line(icd->user_width,
-							icd->current_fmt->host_fmt);
+			phys_addr_bottom = phys_addr_top + icd->bytesperline;
 		ceu_write(pcdev, bottom1, phys_addr_bottom);
 	}
 
-- 
1.7.3.4

