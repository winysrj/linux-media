Return-path: <mchehab@pedra>
Received: from devils.ext.ti.com ([198.47.26.153]:56353 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756695Ab1CHAtx (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 7 Mar 2011 19:49:53 -0500
From: Sergio Aguirre <saaguirre@ti.com>
To: g.liakhovetski@gmx.de
Cc: linux-media@vger.kernel.org, Sergio Aguirre <saaguirre@ti.com>
Subject: [PATCH] v4l: soc-camera: Store negotiated buffer settings
Date: Mon,  7 Mar 2011 18:49:48 -0600
Message-Id: <1299545388-717-1-git-send-email-saaguirre@ti.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

This fixes the problem in which a host driver
sets a personalized sizeimage or bytesperline field,
and gets ignored when doing G_FMT.

Signed-off-by: Sergio Aguirre <saaguirre@ti.com>
---
 drivers/media/video/soc_camera.c |    9 ++++-----
 include/media/soc_camera.h       |    2 ++
 2 files changed, 6 insertions(+), 5 deletions(-)

diff --git a/drivers/media/video/soc_camera.c b/drivers/media/video/soc_camera.c
index a66811b..59dc71d 100644
--- a/drivers/media/video/soc_camera.c
+++ b/drivers/media/video/soc_camera.c
@@ -363,6 +363,8 @@ static int soc_camera_set_fmt(struct soc_camera_device *icd,
 	icd->user_width		= pix->width;
 	icd->user_height	= pix->height;
 	icd->colorspace		= pix->colorspace;
+	icd->bytesperline	= pix->bytesperline;
+	icd->sizeimage		= pix->sizeimage;
 	icd->vb_vidq.field	=
 		icd->field	= pix->field;
 
@@ -608,12 +610,9 @@ static int soc_camera_g_fmt_vid_cap(struct file *file, void *priv,
 	pix->height		= icd->user_height;
 	pix->field		= icd->vb_vidq.field;
 	pix->pixelformat	= icd->current_fmt->host_fmt->fourcc;
-	pix->bytesperline	= soc_mbus_bytes_per_line(pix->width,
-						icd->current_fmt->host_fmt);
+	pix->bytesperline	= icd->bytesperline;
 	pix->colorspace		= icd->colorspace;
-	if (pix->bytesperline < 0)
-		return pix->bytesperline;
-	pix->sizeimage		= pix->height * pix->bytesperline;
+	pix->sizeimage		= icd->sizeimage;
 	dev_dbg(&icd->dev, "current_fmt->fourcc: 0x%08x\n",
 		icd->current_fmt->host_fmt->fourcc);
 	return 0;
diff --git a/include/media/soc_camera.h b/include/media/soc_camera.h
index 9386db8..de81370 100644
--- a/include/media/soc_camera.h
+++ b/include/media/soc_camera.h
@@ -30,6 +30,8 @@ struct soc_camera_device {
 	s32 user_width;
 	s32 user_height;
 	enum v4l2_colorspace colorspace;
+	__u32 bytesperline;	/* for padding, zero if unused */
+	__u32 sizeimage;
 	unsigned char iface;		/* Host number */
 	unsigned char devnum;		/* Device number per host */
 	struct soc_camera_sense *sense;	/* See comment in struct definition */
-- 
1.7.1

