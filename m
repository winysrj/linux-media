Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.126.186]:52135 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S936496Ab3DRVf7 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 18 Apr 2013 17:35:59 -0400
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: linux-media@vger.kernel.org
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Subject: [PATCH 17/24] V4L2: mt9p031: add support for .g_mbus_config() video operation
Date: Thu, 18 Apr 2013 23:35:38 +0200
Message-Id: <1366320945-21591-18-git-send-email-g.liakhovetski@gmx.de>
In-Reply-To: <1366320945-21591-1-git-send-email-g.liakhovetski@gmx.de>
References: <1366320945-21591-1-git-send-email-g.liakhovetski@gmx.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

.g_mbus_config() subdevice video operation is required for subdevice
drivers to be used with the soc-camera framework.

Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
---
 drivers/media/i2c/mt9p031.c |   13 +++++++++++++
 1 files changed, 13 insertions(+), 0 deletions(-)

diff --git a/drivers/media/i2c/mt9p031.c b/drivers/media/i2c/mt9p031.c
index 9ba38f5..eb2de22 100644
--- a/drivers/media/i2c/mt9p031.c
+++ b/drivers/media/i2c/mt9p031.c
@@ -390,6 +390,18 @@ static int mt9p031_set_params(struct mt9p031 *mt9p031)
 	return ret;
 }
 
+static int mt9p031_g_mbus_config(struct v4l2_subdev *sd,
+				 struct v4l2_mbus_config *cfg)
+{
+	cfg->type = V4L2_MBUS_PARALLEL;
+	cfg->flags = V4L2_MBUS_MASTER | V4L2_MBUS_HSYNC_ACTIVE_HIGH |
+		V4L2_MBUS_VSYNC_ACTIVE_HIGH |
+		V4L2_MBUS_PCLK_SAMPLE_FALLING |
+		V4L2_MBUS_DATA_ACTIVE_HIGH;
+
+	return 0;
+}
+
 static int mt9p031_s_stream(struct v4l2_subdev *subdev, int enable)
 {
 	struct mt9p031 *mt9p031 = to_mt9p031(subdev);
@@ -888,6 +900,7 @@ static struct v4l2_subdev_core_ops mt9p031_subdev_core_ops = {
 };
 
 static struct v4l2_subdev_video_ops mt9p031_subdev_video_ops = {
+	.g_mbus_config	= mt9p031_g_mbus_config,
 	.s_stream       = mt9p031_s_stream,
 };
 
-- 
1.7.2.5

