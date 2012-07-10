Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wi0-f170.google.com ([209.85.212.170]:39888 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753079Ab2GJMjJ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 10 Jul 2012 08:39:09 -0400
Received: by wibhq12 with SMTP id hq12so3562383wib.1
        for <linux-media@vger.kernel.org>; Tue, 10 Jul 2012 05:39:07 -0700 (PDT)
From: Javier Martin <javier.martin@vista-silicon.com>
To: linux-media@vger.kernel.org
Cc: fabio.estevam@freescale.com, laurent.pinchart@ideasonboard.com,
	g.liakhovetski@gmx.de, mchehab@infradead.org,
	Javier Martin <javier.martin@vista-silicon.com>
Subject: [PATCH] media: mx2_camera: Don't modify non volatile parameters in try_fmt.
Date: Tue, 10 Jul 2012 14:38:56 +0200
Message-Id: <1341923936-18503-1-git-send-email-javier.martin@vista-silicon.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

---
 drivers/media/video/mx2_camera.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/media/video/mx2_camera.c b/drivers/media/video/mx2_camera.c
index d5355de..4a96989 100644
--- a/drivers/media/video/mx2_camera.c
+++ b/drivers/media/video/mx2_camera.c
@@ -1370,6 +1370,7 @@ static int mx2_camera_try_fmt(struct soc_camera_device *icd,
 	__u32 pixfmt = pix->pixelformat;
 	struct soc_camera_host *ici = to_soc_camera_host(icd->parent);
 	struct mx2_camera_dev *pcdev = ici->priv;
+	struct mx2_fmt_cfg *emma_prp;
 	unsigned int width_limit;
 	int ret;
 
@@ -1432,7 +1433,7 @@ static int mx2_camera_try_fmt(struct soc_camera_device *icd,
 		__func__, pcdev->s_width, pcdev->s_height);
 
 	/* If the sensor does not support image size try PrP resizing */
-	pcdev->emma_prp = mx27_emma_prp_get_format(xlate->code,
+	emma_prp = mx27_emma_prp_get_format(xlate->code,
 						   xlate->host_fmt->fourcc);
 
 	memset(pcdev->resizing, 0, sizeof(pcdev->resizing));
-- 
1.7.9.5

