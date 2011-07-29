Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.17.9]:63146 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756142Ab1G2K5D (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 29 Jul 2011 06:57:03 -0400
Received: from 6a.grange (6a.grange [192.168.1.11])
	by axis700.grange (Postfix) with ESMTPS id 798EE18B03F
	for <linux-media@vger.kernel.org>; Fri, 29 Jul 2011 12:57:00 +0200 (CEST)
Received: from lyakh by 6a.grange with local (Exim 4.72)
	(envelope-from <g.liakhovetski@gmx.de>)
	id 1QmkkW-0007ne-9h
	for linux-media@vger.kernel.org; Fri, 29 Jul 2011 12:57:00 +0200
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: linux-media@vger.kernel.org
Subject: [PATCH 14/59] V4L: ov6650: support the new mbus-config subdev ops
Date: Fri, 29 Jul 2011 12:56:14 +0200
Message-Id: <1311937019-29914-15-git-send-email-g.liakhovetski@gmx.de>
In-Reply-To: <1311937019-29914-1-git-send-email-g.liakhovetski@gmx.de>
References: <1311937019-29914-1-git-send-email-g.liakhovetski@gmx.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Extend the driver to also support [gs]_mbus_config() subdevice video
operations.

Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
---
 drivers/media/video/ov6650.c |   53 +++++++++++++++++++++++++++++++++++++++++-
 1 files changed, 52 insertions(+), 1 deletions(-)

diff --git a/drivers/media/video/ov6650.c b/drivers/media/video/ov6650.c
index 456d9ad..a26734d 100644
--- a/drivers/media/video/ov6650.c
+++ b/drivers/media/video/ov6650.c
@@ -30,9 +30,9 @@
 #include <linux/slab.h>
 
 #include <media/soc_camera.h>
+#include <media/soc_mediabus.h>
 #include <media/v4l2-chip-ident.h>
 
-
 /* Register definitions */
 #define REG_GAIN		0x00	/* range 00 - 3F */
 #define REG_BLUE		0x01
@@ -1111,6 +1111,55 @@ static struct v4l2_subdev_core_ops ov6650_core_ops = {
 #endif
 };
 
+static int ov6650_g_mbus_config(struct v4l2_subdev *sd,
+				struct v4l2_mbus_config *cfg)
+{
+	struct i2c_client *client = v4l2_get_subdevdata(sd);
+	struct soc_camera_device *icd = client->dev.platform_data;
+	struct soc_camera_link *icl = to_soc_camera_link(icd);
+
+	cfg->flags = V4L2_MBUS_MASTER |
+		V4L2_MBUS_PCLK_SAMPLE_RISING | V4L2_MBUS_PCLK_SAMPLE_FALLING |
+		V4L2_MBUS_HSYNC_ACTIVE_HIGH | V4L2_MBUS_HSYNC_ACTIVE_LOW |
+		V4L2_MBUS_VSYNC_ACTIVE_HIGH | V4L2_MBUS_VSYNC_ACTIVE_LOW |
+		V4L2_MBUS_DATA_ACTIVE_HIGH;
+	cfg->type = V4L2_MBUS_PARALLEL;
+	cfg->flags = soc_camera_apply_board_flags(icl, cfg);
+
+	return 0;
+}
+
+static int ov6650_s_mbus_config(struct v4l2_subdev *sd,
+				const struct v4l2_mbus_config *cfg)
+{
+	struct i2c_client *client = v4l2_get_subdevdata(sd);
+	struct soc_camera_device *icd = client->dev.platform_data;
+	struct soc_camera_link *icl = to_soc_camera_link(icd);
+	unsigned long flags = soc_camera_apply_board_flags(icl, cfg);
+	int ret;
+
+	if (flags & V4L2_MBUS_PCLK_SAMPLE_RISING)
+		ret = ov6650_reg_rmw(client, REG_COMJ, COMJ_PCLK_RISING, 0);
+	else
+		ret = ov6650_reg_rmw(client, REG_COMJ, 0, COMJ_PCLK_RISING);
+	if (ret)
+		return ret;
+
+	if (flags & V4L2_MBUS_HSYNC_ACTIVE_LOW)
+		ret = ov6650_reg_rmw(client, REG_COMF, COMF_HREF_LOW, 0);
+	else
+		ret = ov6650_reg_rmw(client, REG_COMF, 0, COMF_HREF_LOW);
+	if (ret)
+		return ret;
+
+	if (flags & V4L2_MBUS_VSYNC_ACTIVE_HIGH)
+		ret = ov6650_reg_rmw(client, REG_COMJ, COMJ_VSYNC_HIGH, 0);
+	else
+		ret = ov6650_reg_rmw(client, REG_COMJ, 0, COMJ_VSYNC_HIGH);
+
+	return ret;
+}
+
 static struct v4l2_subdev_video_ops ov6650_video_ops = {
 	.s_stream	= ov6650_s_stream,
 	.g_mbus_fmt	= ov6650_g_fmt,
@@ -1122,6 +1171,8 @@ static struct v4l2_subdev_video_ops ov6650_video_ops = {
 	.s_crop		= ov6650_s_crop,
 	.g_parm		= ov6650_g_parm,
 	.s_parm		= ov6650_s_parm,
+	.g_mbus_config	= ov6650_g_mbus_config,
+	.s_mbus_config	= ov6650_s_mbus_config,
 };
 
 static struct v4l2_subdev_ops ov6650_subdev_ops = {
-- 
1.7.2.5

