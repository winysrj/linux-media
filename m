Return-path: <mchehab@pedra>
Received: from moutng.kundenserver.de ([212.227.17.10]:54562 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752497Ab1FGJ6T (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 7 Jun 2011 05:58:19 -0400
Date: Tue, 7 Jun 2011 11:58:14 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
cc: Robert Jarzmik <robert.jarzmik@free.fr>
Subject: [PATCH 3/3 v2] V4L: pxa-camera: switch to using subdev .s_power()
 core operation
In-Reply-To: <Pine.LNX.4.64.1106071150080.31635@axis700.grange>
Message-ID: <Pine.LNX.4.64.1106071157280.31635@axis700.grange>
References: <Pine.LNX.4.64.1106071150080.31635@axis700.grange>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

soc-camera specific .suspend() and .resume() methods are deprecated
and should be replaced by the subdev standard .s_power() operation.

Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
---
 drivers/media/video/pxa_camera.c |   16 ++++++++++++----
 1 files changed, 12 insertions(+), 4 deletions(-)

diff --git a/drivers/media/video/pxa_camera.c b/drivers/media/video/pxa_camera.c
index 88aa1ba..3b3ad08 100644
--- a/drivers/media/video/pxa_camera.c
+++ b/drivers/media/video/pxa_camera.c
@@ -1591,8 +1591,12 @@ static int pxa_camera_suspend(struct soc_camera_device *icd, pm_message_t state)
 	pcdev->save_cicr[i++] = __raw_readl(pcdev->base + CICR3);
 	pcdev->save_cicr[i++] = __raw_readl(pcdev->base + CICR4);
 
-	if ((pcdev->icd) && (pcdev->icd->ops->suspend))
-		ret = pcdev->icd->ops->suspend(pcdev->icd, state);
+	if (pcdev->icd) {
+		struct v4l2_subdev *sd = soc_camera_to_subdev(icd);
+		ret = v4l2_subdev_call(sd, core, s_power, 0);
+		if (ret == -ENOIOCTLCMD)
+			ret = 0;
+	}
 
 	return ret;
 }
@@ -1613,8 +1617,12 @@ static int pxa_camera_resume(struct soc_camera_device *icd)
 	__raw_writel(pcdev->save_cicr[i++], pcdev->base + CICR3);
 	__raw_writel(pcdev->save_cicr[i++], pcdev->base + CICR4);
 
-	if ((pcdev->icd) && (pcdev->icd->ops->resume))
-		ret = pcdev->icd->ops->resume(pcdev->icd);
+	if (pcdev->icd) {
+		struct v4l2_subdev *sd = soc_camera_to_subdev(icd);
+		ret = v4l2_subdev_call(sd, core, s_power, 1);
+		if (ret == -ENOIOCTLCMD)
+			ret = 0;
+	}
 
 	/* Restart frame capture if active buffer exists */
 	if (!ret && pcdev->active)
-- 
1.7.2.5

