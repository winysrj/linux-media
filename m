Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.17.8]:61255 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756271Ab1G2K5F (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 29 Jul 2011 06:57:05 -0400
Received: from 6a.grange (6a.grange [192.168.1.11])
	by axis700.grange (Postfix) with ESMTPS id 3577018B046
	for <linux-media@vger.kernel.org>; Fri, 29 Jul 2011 12:57:02 +0200 (CEST)
Received: from lyakh by 6a.grange with local (Exim 4.72)
	(envelope-from <g.liakhovetski@gmx.de>)
	id 1QmkkY-0007pV-3m
	for linux-media@vger.kernel.org; Fri, 29 Jul 2011 12:57:02 +0200
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: linux-media@vger.kernel.org
Subject: [PATCH 52/59] V4L: ov9640: remove superfluous soc-camera client operations
Date: Fri, 29 Jul 2011 12:56:52 +0200
Message-Id: <1311937019-29914-53-git-send-email-g.liakhovetski@gmx.de>
In-Reply-To: <1311937019-29914-1-git-send-email-g.liakhovetski@gmx.de>
References: <1311937019-29914-1-git-send-email-g.liakhovetski@gmx.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Now that all soc-camera hosts have been ported to use V4L2 subdevice
mediabus-config operations and soc-camera client bus-parameter operations
have been made optional, they can be removed.

Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
---
 drivers/media/video/ov9640.c |   28 +---------------------------
 1 files changed, 1 insertions(+), 27 deletions(-)

diff --git a/drivers/media/video/ov9640.c b/drivers/media/video/ov9640.c
index 4156c9f..352a8fb 100644
--- a/drivers/media/video/ov9640.c
+++ b/drivers/media/video/ov9640.c
@@ -286,29 +286,6 @@ static int ov9640_s_stream(struct v4l2_subdev *sd, int enable)
 	return 0;
 }
 
-/* Alter bus settings on camera side */
-static int ov9640_set_bus_param(struct soc_camera_device *icd,
-				unsigned long flags)
-{
-	return 0;
-}
-
-/* Request bus settings on camera side */
-static unsigned long ov9640_query_bus_param(struct soc_camera_device *icd)
-{
-	struct soc_camera_link *icl = to_soc_camera_link(icd);
-
-	/*
-	 * REVISIT: the camera probably can do 10 bit transfers, but I don't
-	 *          have those pins connected on my hardware.
-	 */
-	unsigned long flags = SOCAM_PCLK_SAMPLE_RISING | SOCAM_MASTER |
-		SOCAM_VSYNC_ACTIVE_HIGH | SOCAM_HSYNC_ACTIVE_HIGH |
-		SOCAM_DATA_ACTIVE_HIGH | SOCAM_DATAWIDTH_8;
-
-	return soc_camera_apply_sensor_flags(icl, flags);
-}
-
 /* Get status of additional camera capabilities */
 static int ov9640_g_ctrl(struct v4l2_subdev *sd, struct v4l2_control *ctrl)
 {
@@ -648,8 +625,6 @@ static int ov9640_cropcap(struct v4l2_subdev *sd, struct v4l2_cropcap *a)
 	return 0;
 }
 
-
-
 static int ov9640_video_probe(struct soc_camera_device *icd,
 				struct i2c_client *client)
 {
@@ -707,8 +682,6 @@ err:
 }
 
 static struct soc_camera_ops ov9640_ops = {
-	.set_bus_param		= ov9640_set_bus_param,
-	.query_bus_param	= ov9640_query_bus_param,
 	.controls		= ov9640_controls,
 	.num_controls		= ARRAY_SIZE(ov9640_controls),
 };
@@ -724,6 +697,7 @@ static struct v4l2_subdev_core_ops ov9640_core_ops = {
 
 };
 
+/* Request bus settings on camera side */
 static int ov9640_g_mbus_config(struct v4l2_subdev *sd,
 				struct v4l2_mbus_config *cfg)
 {
-- 
1.7.2.5

