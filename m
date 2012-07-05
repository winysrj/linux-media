Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:60437 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754030Ab2GEUir (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 5 Jul 2012 16:38:47 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: linux-media@vger.kernel.org
Subject: [PATCH v2 7/9] soc-camera: Continue the power off sequence if one of the steps fails
Date: Thu,  5 Jul 2012 22:38:46 +0200
Message-Id: <1341520728-2707-8-git-send-email-laurent.pinchart@ideasonboard.com>
In-Reply-To: <1341520728-2707-1-git-send-email-laurent.pinchart@ideasonboard.com>
References: <1341520728-2707-1-git-send-email-laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Powering off a device is a "best effort" task: failure to execute one of
the steps should not prevent the next steps to be executed. For
instance, an I2C communication error when putting the chip in stand-by
mode should not prevent the more agressive next step of turning the
chip's power supply off.

Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 drivers/media/video/soc_camera.c |    9 +++------
 1 files changed, 3 insertions(+), 6 deletions(-)

diff --git a/drivers/media/video/soc_camera.c b/drivers/media/video/soc_camera.c
index 55b981f..bbd518f 100644
--- a/drivers/media/video/soc_camera.c
+++ b/drivers/media/video/soc_camera.c
@@ -89,18 +89,15 @@ static int soc_camera_power_off(struct soc_camera_device *icd,
 				struct soc_camera_link *icl)
 {
 	struct v4l2_subdev *sd = soc_camera_to_subdev(icd);
-	int ret = v4l2_subdev_call(sd, core, s_power, 0);
+	int ret;
 
-	if (ret < 0 && ret != -ENOIOCTLCMD && ret != -ENODEV)
-		return ret;
+	v4l2_subdev_call(sd, core, s_power, 0);
 
 	if (icl->power) {
 		ret = icl->power(icd->control, 0);
-		if (ret < 0) {
+		if (ret < 0)
 			dev_err(icd->pdev,
 				"Platform failed to power-off the camera.\n");
-			return ret;
-		}
 	}
 
 	ret = regulator_bulk_disable(icl->num_regulators,
-- 
1.7.8.6

