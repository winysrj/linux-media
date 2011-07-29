Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.126.171]:50410 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756074Ab1G2K5D (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 29 Jul 2011 06:57:03 -0400
Received: from 6a.grange (6a.grange [192.168.1.11])
	by axis700.grange (Postfix) with ESMTPS id 9698A18B041
	for <linux-media@vger.kernel.org>; Fri, 29 Jul 2011 12:57:00 +0200 (CEST)
Received: from lyakh by 6a.grange with local (Exim 4.72)
	(envelope-from <g.liakhovetski@gmx.de>)
	id 1QmkkW-0007nk-CV
	for linux-media@vger.kernel.org; Fri, 29 Jul 2011 12:57:00 +0200
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: linux-media@vger.kernel.org
Subject: [PATCH 16/59] V4L: ov772x: support the new mbus-config subdev ops
Date: Fri, 29 Jul 2011 12:56:16 +0200
Message-Id: <1311937019-29914-17-git-send-email-g.liakhovetski@gmx.de>
In-Reply-To: <1311937019-29914-1-git-send-email-g.liakhovetski@gmx.de>
References: <1311937019-29914-1-git-send-email-g.liakhovetski@gmx.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Extend the driver to also support [gs]_mbus_config() subdevice video
operations.

Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
---
 drivers/media/video/ov772x.c |   24 +++++++++++++++++++++---
 1 files changed, 21 insertions(+), 3 deletions(-)

diff --git a/drivers/media/video/ov772x.c b/drivers/media/video/ov772x.c
index 458265b..b70ffba 100644
--- a/drivers/media/video/ov772x.c
+++ b/drivers/media/video/ov772x.c
@@ -21,11 +21,12 @@
 #include <linux/slab.h>
 #include <linux/delay.h>
 #include <linux/videodev2.h>
-#include <media/v4l2-chip-ident.h>
-#include <media/v4l2-subdev.h>
+
+#include <media/ov772x.h>
 #include <media/soc_camera.h>
 #include <media/soc_mediabus.h>
-#include <media/ov772x.h>
+#include <media/v4l2-chip-ident.h>
+#include <media/v4l2-subdev.h>
 
 /*
  * register offset
@@ -1095,6 +1096,22 @@ static int ov772x_enum_fmt(struct v4l2_subdev *sd, unsigned int index,
 	return 0;
 }
 
+static int ov772x_g_mbus_config(struct v4l2_subdev *sd,
+				struct v4l2_mbus_config *cfg)
+{
+	struct i2c_client *client = v4l2_get_subdevdata(sd);
+	struct soc_camera_device *icd = client->dev.platform_data;
+	struct soc_camera_link *icl = to_soc_camera_link(icd);
+
+	cfg->flags = V4L2_MBUS_PCLK_SAMPLE_RISING | V4L2_MBUS_MASTER |
+		V4L2_MBUS_VSYNC_ACTIVE_HIGH | V4L2_MBUS_HSYNC_ACTIVE_HIGH |
+		V4L2_MBUS_DATA_ACTIVE_HIGH;
+	cfg->type = V4L2_MBUS_PARALLEL;
+	cfg->flags = soc_camera_apply_board_flags(icl, cfg);
+
+	return 0;
+}
+
 static struct v4l2_subdev_video_ops ov772x_subdev_video_ops = {
 	.s_stream	= ov772x_s_stream,
 	.g_mbus_fmt	= ov772x_g_fmt,
@@ -1103,6 +1120,7 @@ static struct v4l2_subdev_video_ops ov772x_subdev_video_ops = {
 	.cropcap	= ov772x_cropcap,
 	.g_crop		= ov772x_g_crop,
 	.enum_mbus_fmt	= ov772x_enum_fmt,
+	.g_mbus_config	= ov772x_g_mbus_config,
 };
 
 static struct v4l2_subdev_ops ov772x_subdev_ops = {
-- 
1.7.2.5

