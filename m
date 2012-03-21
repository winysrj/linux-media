Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:57783 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030788Ab2CULDW (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 21 Mar 2012 07:03:22 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: linux-media@vger.kernel.org
Subject: [PATCH v2 8/9] mx2_camera: Use soc_mbus_image_size() instead of manual computation
Date: Wed, 21 Mar 2012 12:03:27 +0100
Message-Id: <1332327808-6056-9-git-send-email-laurent.pinchart@ideasonboard.com>
In-Reply-To: <1332327808-6056-1-git-send-email-laurent.pinchart@ideasonboard.com>
References: <1332327808-6056-1-git-send-email-laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Use the new soc_mbus_image_size() function to compute the image size.

Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 drivers/media/video/mx2_camera.c |    6 ++++--
 1 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/media/video/mx2_camera.c b/drivers/media/video/mx2_camera.c
index 091f2e1..1269b5f 100644
--- a/drivers/media/video/mx2_camera.c
+++ b/drivers/media/video/mx2_camera.c
@@ -1121,7 +1121,8 @@ static int mx2_camera_try_fmt(struct soc_camera_device *icd,
 				xlate->host_fmt);
 		if (pix->bytesperline < 0)
 			return pix->bytesperline;
-		pix->sizeimage = pix->height * pix->bytesperline;
+		pix->sizeimage = soc_mbus_image_size(xlate->host_fmt,
+						pix->bytesperline, pix->height);
 		/* Check against the CSIRXCNT limit */
 		if (pix->sizeimage > 4 * 0x3ffff) {
 			/* Adjust geometry, preserve aspect ratio */
@@ -1132,7 +1133,8 @@ static int mx2_camera_try_fmt(struct soc_camera_device *icd,
 			pix->bytesperline = soc_mbus_bytes_per_line(pix->width,
 							xlate->host_fmt);
 			BUG_ON(pix->bytesperline < 0);
-			pix->sizeimage = pix->height * pix->bytesperline;
+			pix->sizeimage = soc_mbus_image_size(xlate->host_fmt,
+						pix->bytesperline, pix->height);
 		}
 	}
 
-- 
1.7.3.4

