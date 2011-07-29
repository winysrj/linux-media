Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.126.171]:64952 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756294Ab1G2K5F (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 29 Jul 2011 06:57:05 -0400
Received: from 6a.grange (6a.grange [192.168.1.11])
	by axis700.grange (Postfix) with ESMTPS id 500E218B044
	for <linux-media@vger.kernel.org>; Fri, 29 Jul 2011 12:57:02 +0200 (CEST)
Received: from lyakh by 6a.grange with local (Exim 4.72)
	(envelope-from <g.liakhovetski@gmx.de>)
	id 1QmkkY-0007pb-6g
	for linux-media@vger.kernel.org; Fri, 29 Jul 2011 12:57:02 +0200
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: linux-media@vger.kernel.org
Subject: [PATCH 54/59] V4L: rj54n1cb0c: remove superfluous soc-camera client operations
Date: Fri, 29 Jul 2011 12:56:54 +0200
Message-Id: <1311937019-29914-55-git-send-email-g.liakhovetski@gmx.de>
In-Reply-To: <1311937019-29914-1-git-send-email-g.liakhovetski@gmx.de>
References: <1311937019-29914-1-git-send-email-g.liakhovetski@gmx.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Now that all soc-camera hosts have been ported to use V4L2 subdevice
mediabus-config operations and soc-camera client bus-parameter operations
have been made optional, they can be removed.

Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
---
 drivers/media/video/rj54n1cb0c.c |   27 ---------------------------
 1 files changed, 0 insertions(+), 27 deletions(-)

diff --git a/drivers/media/video/rj54n1cb0c.c b/drivers/media/video/rj54n1cb0c.c
index d19c79b..c302211 100644
--- a/drivers/media/video/rj54n1cb0c.c
+++ b/drivers/media/video/rj54n1cb0c.c
@@ -499,31 +499,6 @@ static int rj54n1_s_stream(struct v4l2_subdev *sd, int enable)
 	return reg_set(client, RJ54N1_STILL_CONTROL, (!enable) << 7, 0x80);
 }
 
-static int rj54n1_set_bus_param(struct soc_camera_device *icd,
-				unsigned long flags)
-{
-	struct v4l2_subdev *sd = soc_camera_to_subdev(icd);
-	struct i2c_client *client = v4l2_get_subdevdata(sd);
-	/* Figures 2.5-1 to 2.5-3 - default falling pixclk edge */
-
-	if (flags & SOCAM_PCLK_SAMPLE_RISING)
-		return reg_write(client, RJ54N1_OUT_SIGPO, 1 << 4);
-	else
-		return reg_write(client, RJ54N1_OUT_SIGPO, 0);
-}
-
-static unsigned long rj54n1_query_bus_param(struct soc_camera_device *icd)
-{
-	struct soc_camera_link *icl = to_soc_camera_link(icd);
-	const unsigned long flags =
-		SOCAM_PCLK_SAMPLE_RISING | SOCAM_PCLK_SAMPLE_FALLING |
-		SOCAM_MASTER | SOCAM_DATAWIDTH_8 |
-		SOCAM_HSYNC_ACTIVE_HIGH | SOCAM_VSYNC_ACTIVE_HIGH |
-		SOCAM_DATA_ACTIVE_HIGH;
-
-	return soc_camera_apply_sensor_flags(icl, flags);
-}
-
 static int rj54n1_set_rect(struct i2c_client *client,
 			   u16 reg_x, u16 reg_y, u16 reg_xy,
 			   u32 width, u32 height)
@@ -1240,8 +1215,6 @@ static const struct v4l2_queryctrl rj54n1_controls[] = {
 };
 
 static struct soc_camera_ops rj54n1_ops = {
-	.set_bus_param		= rj54n1_set_bus_param,
-	.query_bus_param	= rj54n1_query_bus_param,
 	.controls		= rj54n1_controls,
 	.num_controls		= ARRAY_SIZE(rj54n1_controls),
 };
-- 
1.7.2.5

