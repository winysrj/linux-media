Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:60436 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753458Ab2GEUiq (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 5 Jul 2012 16:38:46 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: linux-media@vger.kernel.org
Subject: [PATCH v2 6/9] soc_camera: Don't call .s_power() during probe
Date: Thu,  5 Jul 2012 22:38:45 +0200
Message-Id: <1341520728-2707-7-git-send-email-laurent.pinchart@ideasonboard.com>
In-Reply-To: <1341520728-2707-1-git-send-email-laurent.pinchart@ideasonboard.com>
References: <1341520728-2707-1-git-send-email-laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The .s_power() call only covers the .g_mbus_fmt() operation call.
Several clients required to be powered on to retrieve the current mbus
format but have now been fixed. The .s_power() call is thus not needed
anymore and can be removed.

Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 drivers/media/video/soc_camera.c |    6 ------
 1 files changed, 0 insertions(+), 6 deletions(-)

diff --git a/drivers/media/video/soc_camera.c b/drivers/media/video/soc_camera.c
index b03ffec..55b981f 100644
--- a/drivers/media/video/soc_camera.c
+++ b/drivers/media/video/soc_camera.c
@@ -1133,10 +1133,6 @@ static int soc_camera_probe(struct soc_camera_device *icd)
 	if (ret < 0)
 		goto evidstart;
 
-	ret = v4l2_subdev_call(sd, core, s_power, 1);
-	if (ret < 0 && ret != -ENOIOCTLCMD)
-		goto esdpwr;
-
 	/* Try to improve our guess of a reasonable window format */
 	if (!v4l2_subdev_call(sd, video, g_mbus_fmt, &mf)) {
 		icd->user_width		= mf.width;
@@ -1153,8 +1149,6 @@ static int soc_camera_probe(struct soc_camera_device *icd)
 
 	return 0;
 
-esdpwr:
-	video_unregister_device(icd->vdev);
 evidstart:
 	mutex_unlock(&icd->video_lock);
 	soc_camera_free_user_formats(icd);
-- 
1.7.8.6

