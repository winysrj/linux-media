Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.126.187]:60993 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754657Ab3DLPlH (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 12 Apr 2013 11:41:07 -0400
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: linux-media@vger.kernel.org
Cc: Sylwester Nawrocki <s.nawrocki@samsung.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Hans Verkuil <hverkuil@xs4all.nl>, linux-sh@vger.kernel.org,
	Magnus Damm <magnus.damm@gmail.com>,
	Sakari Ailus <sakari.ailus@iki.fi>,
	Prabhakar Lad <prabhakar.lad@ti.com>
Subject: [PATCH v9 12/20] soc-camera: make .clock_{start,stop} compulsory, .add / .remove optional
Date: Fri, 12 Apr 2013 17:40:32 +0200
Message-Id: <1365781240-16149-13-git-send-email-g.liakhovetski@gmx.de>
In-Reply-To: <1365781240-16149-1-git-send-email-g.liakhovetski@gmx.de>
References: <1365781240-16149-1-git-send-email-g.liakhovetski@gmx.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

All existing soc-camera host drivers use .clock_start() and .clock_stop()
callbacks to activate and deactivate their camera interfaces, whereas
.add() and .remove() callbacks are usually dummy. Make the former two
compulsory and the latter two optional.

Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
---
 drivers/media/platform/soc_camera/soc_camera.c |   27 +++++++++++------------
 1 files changed, 13 insertions(+), 14 deletions(-)

diff --git a/drivers/media/platform/soc_camera/soc_camera.c b/drivers/media/platform/soc_camera/soc_camera.c
index 2f81af5..507f539 100644
--- a/drivers/media/platform/soc_camera/soc_camera.c
+++ b/drivers/media/platform/soc_camera/soc_camera.c
@@ -513,23 +513,22 @@ static int soc_camera_add_device(struct soc_camera_device *icd)
 	if (ici->icd)
 		return -EBUSY;
 
-	if (ici->ops->clock_start) {
-		ret = ici->ops->clock_start(ici);
+	ret = ici->ops->clock_start(ici);
+	if (ret < 0)
+		return ret;
+
+	if (ici->ops->add) {
+		ret = ici->ops->add(icd);
 		if (ret < 0)
-			return ret;
+			goto eadd;
 	}
 
-	ret = ici->ops->add(icd);
-	if (ret < 0)
-		goto eadd;
-
 	ici->icd = icd;
 
 	return 0;
 
 eadd:
-	if (ici->ops->clock_stop)
-		ici->ops->clock_stop(ici);
+	ici->ops->clock_stop(ici);
 	return ret;
 }
 
@@ -540,9 +539,9 @@ static void soc_camera_remove_device(struct soc_camera_device *icd)
 	if (WARN_ON(icd != ici->icd))
 		return;
 
-	ici->ops->remove(icd);
-	if (ici->ops->clock_stop)
-		ici->ops->clock_stop(ici);
+	if (ici->ops->remove)
+		ici->ops->remove(icd);
+	ici->ops->clock_stop(ici);
 	ici->icd = NULL;
 }
 
@@ -1413,8 +1412,8 @@ int soc_camera_host_register(struct soc_camera_host *ici)
 	    ((!ici->ops->init_videobuf ||
 	      !ici->ops->reqbufs) &&
 	     !ici->ops->init_videobuf2) ||
-	    !ici->ops->add ||
-	    !ici->ops->remove ||
+	    !ici->ops->clock_start ||
+	    !ici->ops->clock_stop ||
 	    !ici->ops->poll ||
 	    !ici->v4l2_dev.dev)
 		return -EINVAL;
-- 
1.7.2.5

