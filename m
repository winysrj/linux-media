Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.17.8]:60207 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755904Ab1G2K5D (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 29 Jul 2011 06:57:03 -0400
Received: from 6a.grange (6a.grange [192.168.1.11])
	by axis700.grange (Postfix) with ESMTPS id 5026118B03B
	for <linux-media@vger.kernel.org>; Fri, 29 Jul 2011 12:57:00 +0200 (CEST)
Received: from lyakh by 6a.grange with local (Exim 4.72)
	(envelope-from <g.liakhovetski@gmx.de>)
	id 1QmkkW-0007nK-1K
	for linux-media@vger.kernel.org; Fri, 29 Jul 2011 12:57:00 +0200
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: linux-media@vger.kernel.org
Subject: [PATCH 08/59] V4L: mt9m111: support the new mbus-config subdev ops
Date: Fri, 29 Jul 2011 12:56:08 +0200
Message-Id: <1311937019-29914-9-git-send-email-g.liakhovetski@gmx.de>
In-Reply-To: <1311937019-29914-1-git-send-email-g.liakhovetski@gmx.de>
References: <1311937019-29914-1-git-send-email-g.liakhovetski@gmx.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Extend the driver to also support [gs]_mbus_config() subdevice video
operations.

Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
---
 drivers/media/video/mt9m111.c |   20 +++++++++++++++++++-
 1 files changed, 19 insertions(+), 1 deletions(-)

diff --git a/drivers/media/video/mt9m111.c b/drivers/media/video/mt9m111.c
index a357aa8..c2fe5c9 100644
--- a/drivers/media/video/mt9m111.c
+++ b/drivers/media/video/mt9m111.c
@@ -14,9 +14,10 @@
 #include <linux/gpio.h>
 #include <linux/delay.h>
 
+#include <media/soc_camera.h>
+#include <media/soc_mediabus.h>
 #include <media/v4l2-common.h>
 #include <media/v4l2-chip-ident.h>
-#include <media/soc_camera.h>
 
 /*
  * MT9M111, MT9M112 and MT9M131:
@@ -1016,6 +1017,22 @@ static int mt9m111_enum_fmt(struct v4l2_subdev *sd, unsigned int index,
 	return 0;
 }
 
+static int mt9m111_g_mbus_config(struct v4l2_subdev *sd,
+				struct v4l2_mbus_config *cfg)
+{
+	struct i2c_client *client = v4l2_get_subdevdata(sd);
+	struct soc_camera_device *icd = client->dev.platform_data;
+	struct soc_camera_link *icl = to_soc_camera_link(icd);
+
+	cfg->flags = V4L2_MBUS_MASTER | V4L2_MBUS_PCLK_SAMPLE_RISING |
+		V4L2_MBUS_HSYNC_ACTIVE_HIGH | V4L2_MBUS_VSYNC_ACTIVE_HIGH |
+		V4L2_MBUS_DATA_ACTIVE_HIGH;
+	cfg->type = V4L2_MBUS_PARALLEL;
+	cfg->flags = soc_camera_apply_board_flags(icl, cfg);
+
+	return 0;
+}
+
 static struct v4l2_subdev_video_ops mt9m111_subdev_video_ops = {
 	.s_mbus_fmt	= mt9m111_s_fmt,
 	.g_mbus_fmt	= mt9m111_g_fmt,
@@ -1024,6 +1041,7 @@ static struct v4l2_subdev_video_ops mt9m111_subdev_video_ops = {
 	.g_crop		= mt9m111_g_crop,
 	.cropcap	= mt9m111_cropcap,
 	.enum_mbus_fmt	= mt9m111_enum_fmt,
+	.g_mbus_config	= mt9m111_g_mbus_config,
 };
 
 static struct v4l2_subdev_ops mt9m111_subdev_ops = {
-- 
1.7.2.5

