Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:52875 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754578Ab2GRNyF (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 18 Jul 2012 09:54:05 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: linux-media@vger.kernel.org
Subject: [PATCH v3 7/9] soc-camera: Continue the power off sequence if one of the steps fails
Date: Wed, 18 Jul 2012 15:54:02 +0200
Message-Id: <1342619644-5712-8-git-send-email-laurent.pinchart@ideasonboard.com>
In-Reply-To: <1342619644-5712-1-git-send-email-laurent.pinchart@ideasonboard.com>
References: <1342619644-5712-1-git-send-email-laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Powering off a device is a "best effort" task: failure to execute one of
the steps should not prevent the next steps to be executed. For
instance, an I2C communication error when putting the chip in stand-by
mode should not prevent the more agressive next step of turning the
chip's power supply off.

Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 drivers/media/video/soc_camera.c |   22 ++++++++++++++--------
 1 files changed, 14 insertions(+), 8 deletions(-)

diff --git a/drivers/media/video/soc_camera.c b/drivers/media/video/soc_camera.c
index 55b981f..7bf21da 100644
--- a/drivers/media/video/soc_camera.c
+++ b/drivers/media/video/soc_camera.c
@@ -89,24 +89,30 @@ static int soc_camera_power_off(struct soc_camera_device *icd,
 				struct soc_camera_link *icl)
 {
 	struct v4l2_subdev *sd = soc_camera_to_subdev(icd);
-	int ret = v4l2_subdev_call(sd, core, s_power, 0);
+	int ret = 0;
+	int err;
 
-	if (ret < 0 && ret != -ENOIOCTLCMD && ret != -ENODEV)
-		return ret;
+	err = v4l2_subdev_call(sd, core, s_power, 0);
+	if (err < 0 && err != -ENOIOCTLCMD && err != -ENODEV) {
+		dev_err(icd->pdev, "Subdev failed to power-off the camera.\n");
+		ret = err;
+	}
 
 	if (icl->power) {
-		ret = icl->power(icd->control, 0);
-		if (ret < 0) {
+		err = icl->power(icd->control, 0);
+		if (err < 0) {
 			dev_err(icd->pdev,
 				"Platform failed to power-off the camera.\n");
-			return ret;
+			ret = ret ? : err;
 		}
 	}
 
-	ret = regulator_bulk_disable(icl->num_regulators,
+	err = regulator_bulk_disable(icl->num_regulators,
 				     icl->regulators);
-	if (ret < 0)
+	if (err < 0) {
 		dev_err(icd->pdev, "Cannot disable regulators\n");
+		ret = ret ? : err;
+	}
 
 	return ret;
 }
-- 
1.7.8.6

