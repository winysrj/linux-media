Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.126.171]:55315 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756163Ab1G2K5D (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 29 Jul 2011 06:57:03 -0400
Received: from 6a.grange (6a.grange [192.168.1.11])
	by axis700.grange (Postfix) with ESMTPS id EE9BF18B049
	for <linux-media@vger.kernel.org>; Fri, 29 Jul 2011 12:57:00 +0200 (CEST)
Received: from lyakh by 6a.grange with local (Exim 4.72)
	(envelope-from <g.liakhovetski@gmx.de>)
	id 1QmkkW-0007oB-Pm
	for linux-media@vger.kernel.org; Fri, 29 Jul 2011 12:57:00 +0200
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: linux-media@vger.kernel.org
Subject: [PATCH 25/59] V4L: soc_camera_platform: support the new mbus-config subdev ops
Date: Fri, 29 Jul 2011 12:56:25 +0200
Message-Id: <1311937019-29914-26-git-send-email-g.liakhovetski@gmx.de>
In-Reply-To: <1311937019-29914-1-git-send-email-g.liakhovetski@gmx.de>
References: <1311937019-29914-1-git-send-email-g.liakhovetski@gmx.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Extend the driver to also support [gs]_mbus_config() subdevice video
operations.

Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
---
 drivers/media/video/soc_camera_platform.c |   12 ++++++++++++
 include/media/soc_camera_platform.h       |    3 +++
 2 files changed, 15 insertions(+), 0 deletions(-)

diff --git a/drivers/media/video/soc_camera_platform.c b/drivers/media/video/soc_camera_platform.c
index 8069cd6..7045e45 100644
--- a/drivers/media/video/soc_camera_platform.c
+++ b/drivers/media/video/soc_camera_platform.c
@@ -115,6 +115,17 @@ static int soc_camera_platform_cropcap(struct v4l2_subdev *sd,
 	return 0;
 }
 
+static int soc_camera_platform_g_mbus_config(struct v4l2_subdev *sd,
+					     struct v4l2_mbus_config *cfg)
+{
+	struct soc_camera_platform_info *p = v4l2_get_subdevdata(sd);
+
+	cfg->flags = p->mbus_param;
+	cfg->type = p->mbus_type;
+
+	return 0;
+}
+
 static struct v4l2_subdev_video_ops platform_subdev_video_ops = {
 	.s_stream	= soc_camera_platform_s_stream,
 	.enum_mbus_fmt	= soc_camera_platform_enum_fmt,
@@ -123,6 +134,7 @@ static struct v4l2_subdev_video_ops platform_subdev_video_ops = {
 	.try_mbus_fmt	= soc_camera_platform_fill_fmt,
 	.g_mbus_fmt	= soc_camera_platform_fill_fmt,
 	.s_mbus_fmt	= soc_camera_platform_fill_fmt,
+	.g_mbus_config	= soc_camera_platform_g_mbus_config,
 };
 
 static struct v4l2_subdev_ops platform_subdev_ops = {
diff --git a/include/media/soc_camera_platform.h b/include/media/soc_camera_platform.h
index 74f0fa1..a15f92b 100644
--- a/include/media/soc_camera_platform.h
+++ b/include/media/soc_camera_platform.h
@@ -13,6 +13,7 @@
 
 #include <linux/videodev2.h>
 #include <media/soc_camera.h>
+#include <media/v4l2-mediabus.h>
 
 struct device;
 
@@ -21,6 +22,8 @@ struct soc_camera_platform_info {
 	unsigned long format_depth;
 	struct v4l2_mbus_framefmt format;
 	unsigned long bus_param;
+	unsigned long mbus_param;
+	enum v4l2_mbus_type mbus_type;
 	struct soc_camera_device *icd;
 	int (*set_capture)(struct soc_camera_platform_info *info, int enable);
 };
-- 
1.7.2.5

