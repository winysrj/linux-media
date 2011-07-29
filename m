Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.126.186]:58593 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756061Ab1G2K5D (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 29 Jul 2011 06:57:03 -0400
Received: from 6a.grange (6a.grange [192.168.1.11])
	by axis700.grange (Postfix) with ESMTPS id CE21D18B046
	for <linux-media@vger.kernel.org>; Fri, 29 Jul 2011 12:57:00 +0200 (CEST)
Received: from lyakh by 6a.grange with local (Exim 4.72)
	(envelope-from <g.liakhovetski@gmx.de>)
	id 1QmkkW-0007nt-Gf
	for linux-media@vger.kernel.org; Fri, 29 Jul 2011 12:57:00 +0200
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: linux-media@vger.kernel.org
Subject: [PATCH 19/59] V4L: rj54n1cb0c: support the new mbus-config subdev ops
Date: Fri, 29 Jul 2011 12:56:19 +0200
Message-Id: <1311937019-29914-20-git-send-email-g.liakhovetski@gmx.de>
In-Reply-To: <1311937019-29914-1-git-send-email-g.liakhovetski@gmx.de>
References: <1311937019-29914-1-git-send-email-g.liakhovetski@gmx.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Extend the driver to also support [gs]_mbus_config() subdevice video
operations.

Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
---
 drivers/media/video/rj54n1cb0c.c |   34 ++++++++++++++++++++++++++++++++++
 1 files changed, 34 insertions(+), 0 deletions(-)

diff --git a/drivers/media/video/rj54n1cb0c.c b/drivers/media/video/rj54n1cb0c.c
index 847ccc0..d19c79b 100644
--- a/drivers/media/video/rj54n1cb0c.c
+++ b/drivers/media/video/rj54n1cb0c.c
@@ -1337,6 +1337,38 @@ static struct v4l2_subdev_core_ops rj54n1_subdev_core_ops = {
 #endif
 };
 
+static int rj54n1_g_mbus_config(struct v4l2_subdev *sd,
+				struct v4l2_mbus_config *cfg)
+{
+	struct i2c_client *client = v4l2_get_subdevdata(sd);
+	struct soc_camera_device *icd = client->dev.platform_data;
+	struct soc_camera_link *icl = to_soc_camera_link(icd);
+
+	cfg->flags =
+		V4L2_MBUS_PCLK_SAMPLE_RISING | V4L2_MBUS_PCLK_SAMPLE_FALLING |
+		V4L2_MBUS_MASTER | V4L2_MBUS_DATA_ACTIVE_HIGH |
+		V4L2_MBUS_HSYNC_ACTIVE_HIGH | V4L2_MBUS_VSYNC_ACTIVE_HIGH;
+	cfg->type = V4L2_MBUS_PARALLEL;
+	cfg->flags = soc_camera_apply_board_flags(icl, cfg);
+
+	return 0;
+}
+
+static int rj54n1_s_mbus_config(struct v4l2_subdev *sd,
+				const struct v4l2_mbus_config *cfg)
+{
+	struct i2c_client *client = v4l2_get_subdevdata(sd);
+	struct soc_camera_device *icd = client->dev.platform_data;
+	struct soc_camera_link *icl = to_soc_camera_link(icd);
+
+	/* Figures 2.5-1 to 2.5-3 - default falling pixclk edge */
+	if (soc_camera_apply_board_flags(icl, cfg) &
+	    V4L2_MBUS_PCLK_SAMPLE_RISING)
+		return reg_write(client, RJ54N1_OUT_SIGPO, 1 << 4);
+	else
+		return reg_write(client, RJ54N1_OUT_SIGPO, 0);
+}
+
 static struct v4l2_subdev_video_ops rj54n1_subdev_video_ops = {
 	.s_stream	= rj54n1_s_stream,
 	.s_mbus_fmt	= rj54n1_s_fmt,
@@ -1346,6 +1378,8 @@ static struct v4l2_subdev_video_ops rj54n1_subdev_video_ops = {
 	.g_crop		= rj54n1_g_crop,
 	.s_crop		= rj54n1_s_crop,
 	.cropcap	= rj54n1_cropcap,
+	.g_mbus_config	= rj54n1_g_mbus_config,
+	.s_mbus_config	= rj54n1_s_mbus_config,
 };
 
 static struct v4l2_subdev_ops rj54n1_subdev_ops = {
-- 
1.7.2.5

