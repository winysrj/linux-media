Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.126.171]:58116 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757196Ab1I2QTD (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 29 Sep 2011 12:19:03 -0400
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Deepthy Ravi <deepthy.ravi@ti.com>
Subject: [PATCH 5/9] V4L: soc-camera: move bus parameter configuration to .vidioc_streamon()
Date: Thu, 29 Sep 2011 18:18:53 +0200
Message-Id: <1317313137-4403-6-git-send-email-g.liakhovetski@gmx.de>
In-Reply-To: <1317313137-4403-1-git-send-email-g.liakhovetski@gmx.de>
References: <1317313137-4403-1-git-send-email-g.liakhovetski@gmx.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

With the Media Controller API various pipeline entities can be configured
independently and in unpredictable order. The only location, where we know
for sure, that the pipeline should be ready, is .vidioc_streamon(). This
makes it the only suitable location for the bus parameter configuration.

Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
---
 drivers/media/video/soc_camera.c |    8 ++++++--
 1 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/media/video/soc_camera.c b/drivers/media/video/soc_camera.c
index 5596688..2905a88 100644
--- a/drivers/media/video/soc_camera.c
+++ b/drivers/media/video/soc_camera.c
@@ -509,8 +509,7 @@ static int soc_camera_set_fmt(struct soc_camera_device *icd,
 	dev_dbg(icd->pdev, "set width: %d height: %d\n",
 		icd->user_width, icd->user_height);
 
-	/* set physical bus parameters */
-	return ici->ops->set_bus_param(icd);
+	return 0;
 }
 
 static int soc_camera_open(struct file *file)
@@ -814,6 +813,11 @@ static int soc_camera_streamon(struct file *file, void *priv,
 	if (icd->streamer != file)
 		return -EBUSY;
 
+	/* set physical bus parameters */
+	ret = ici->ops->set_bus_param(icd);
+	if (ret < 0)
+		return ret;
+
 	/* This calls buf_queue from host driver's videobuf_queue_ops */
 	if (ici->ops->init_videobuf)
 		ret = videobuf_streamon(&icd->vb_vidq);
-- 
1.7.2.5

