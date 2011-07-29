Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.126.186]:49469 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755532Ab1G2K5D (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 29 Jul 2011 06:57:03 -0400
Received: from 6a.grange (6a.grange [192.168.1.11])
	by axis700.grange (Postfix) with ESMTPS id 170DC189B83
	for <linux-media@vger.kernel.org>; Fri, 29 Jul 2011 12:57:00 +0200 (CEST)
Received: from lyakh by 6a.grange with local (Exim 4.72)
	(envelope-from <g.liakhovetski@gmx.de>)
	id 1QmkkV-0007nB-TH
	for linux-media@vger.kernel.org; Fri, 29 Jul 2011 12:56:59 +0200
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: linux-media@vger.kernel.org
Subject: [PATCH 05/59] V4L: imx074: support the new mbus-config subdev ops
Date: Fri, 29 Jul 2011 12:56:05 +0200
Message-Id: <1311937019-29914-6-git-send-email-g.liakhovetski@gmx.de>
In-Reply-To: <1311937019-29914-1-git-send-email-g.liakhovetski@gmx.de>
References: <1311937019-29914-1-git-send-email-g.liakhovetski@gmx.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Extend the driver to also support [gs]_mbus_config() subdevice video
operations.

Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
---
 drivers/media/video/imx074.c |   12 ++++++++++++
 1 files changed, 12 insertions(+), 0 deletions(-)

diff --git a/drivers/media/video/imx074.c b/drivers/media/video/imx074.c
index 0382ea7..63f17aa 100644
--- a/drivers/media/video/imx074.c
+++ b/drivers/media/video/imx074.c
@@ -267,6 +267,17 @@ static int imx074_g_chip_ident(struct v4l2_subdev *sd,
 	return 0;
 }
 
+static int imx074_g_mbus_config(struct v4l2_subdev *sd,
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
 static struct v4l2_subdev_video_ops imx074_subdev_video_ops = {
 	.s_stream	= imx074_s_stream,
 	.s_mbus_fmt	= imx074_s_fmt,
@@ -275,6 +286,7 @@ static struct v4l2_subdev_video_ops imx074_subdev_video_ops = {
 	.enum_mbus_fmt	= imx074_enum_fmt,
 	.g_crop		= imx074_g_crop,
 	.cropcap	= imx074_cropcap,
+	.g_mbus_config	= imx074_g_mbus_config,
 };
 
 static struct v4l2_subdev_core_ops imx074_subdev_core_ops = {
-- 
1.7.2.5

