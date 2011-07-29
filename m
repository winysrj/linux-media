Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.126.186]:61187 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755692Ab1G2K5D (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 29 Jul 2011 06:57:03 -0400
Received: from 6a.grange (6a.grange [192.168.1.11])
	by axis700.grange (Postfix) with ESMTPS id 8D60D189B6D
	for <linux-media@vger.kernel.org>; Fri, 29 Jul 2011 12:57:00 +0200 (CEST)
Received: from lyakh by 6a.grange with local (Exim 4.72)
	(envelope-from <g.liakhovetski@gmx.de>)
	id 1QmkkW-0007nb-7v
	for linux-media@vger.kernel.org; Fri, 29 Jul 2011 12:57:00 +0200
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: linux-media@vger.kernel.org
Subject: [PATCH 13/59] V4L: ov5642: support the new mbus-config subdev ops
Date: Fri, 29 Jul 2011 12:56:13 +0200
Message-Id: <1311937019-29914-14-git-send-email-g.liakhovetski@gmx.de>
In-Reply-To: <1311937019-29914-1-git-send-email-g.liakhovetski@gmx.de>
References: <1311937019-29914-1-git-send-email-g.liakhovetski@gmx.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Extend the driver to also support [gs]_mbus_config() subdevice video
operations.

Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
---
 drivers/media/video/ov5642.c |   12 ++++++++++++
 1 files changed, 12 insertions(+), 0 deletions(-)

diff --git a/drivers/media/video/ov5642.c b/drivers/media/video/ov5642.c
index 3cdae97..60ffc60 100644
--- a/drivers/media/video/ov5642.c
+++ b/drivers/media/video/ov5642.c
@@ -854,6 +854,17 @@ static int ov5642_cropcap(struct v4l2_subdev *sd, struct v4l2_cropcap *a)
 	return 0;
 }
 
+static int ov5642_g_mbus_config(struct v4l2_subdev *sd,
+				struct v4l2_mbus_config *cfg)
+{
+	cfg->type = V4L2_MBUS_CSI2;
+	cfg->flags = V4L2_MBUS_CSI2_2_LANE |
+		V4L2_MBUS_CSI2_CHANNEL_0 |
+		V4L2_MBUS_CSI2_CONTINUOUS_CLOCK;
+
+	return 0;
+}
+
 static struct v4l2_subdev_video_ops ov5642_subdev_video_ops = {
 	.s_mbus_fmt	= ov5642_s_fmt,
 	.g_mbus_fmt	= ov5642_g_fmt,
@@ -861,6 +872,7 @@ static struct v4l2_subdev_video_ops ov5642_subdev_video_ops = {
 	.enum_mbus_fmt	= ov5642_enum_fmt,
 	.g_crop		= ov5642_g_crop,
 	.cropcap	= ov5642_cropcap,
+	.g_mbus_config	= ov5642_g_mbus_config,
 };
 
 static struct v4l2_subdev_core_ops ov5642_subdev_core_ops = {
-- 
1.7.2.5

