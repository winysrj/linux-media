Return-path: <mchehab@pedra>
Received: from queueout04-winn.ispmail.ntl.com ([81.103.221.58]:53382 "EHLO
	queueout04-winn.ispmail.ntl.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756234Ab0IXRgJ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 24 Sep 2010 13:36:09 -0400
From: Daniel Drake <dsd@laptop.org>
To: mchehab@infradead.org
Cc: linux-media@vger.kernel.org
Cc: corbet@lwn.net
Subject: [PATCH 4/4] cafe_ccic: Implement VIDIOC_ENUM_FRAMEINTERVALS and ENUM_FRAMESIZES
Message-Id: <20100924171747.DF4369D401C@zog.reactivated.net>
Date: Fri, 24 Sep 2010 18:17:47 +0100 (BST)
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

This allows GStreamer to pick appropriate framerates and resolutions
based on desired capture parameters.

Signed-off-by: Daniel Drake <dsd@laptop.org>
---
 drivers/media/video/cafe_ccic.c |   26 ++++++++++++++++++++++++++
 1 files changed, 26 insertions(+), 0 deletions(-)

diff --git a/drivers/media/video/cafe_ccic.c b/drivers/media/video/cafe_ccic.c
index 8ddd2b6..09ec476 100644
--- a/drivers/media/video/cafe_ccic.c
+++ b/drivers/media/video/cafe_ccic.c
@@ -1650,6 +1650,30 @@ static int cafe_vidioc_g_chip_ident(struct file *file, void *priv,
 	return sensor_call(cam, core, g_chip_ident, chip);
 }
 
+static int cafe_vidioc_enum_framesizes(struct file *filp, void *priv,
+		struct v4l2_frmsizeenum *sizes)
+{
+	struct cafe_camera *cam = priv;
+	int ret;
+
+	mutex_lock(&cam->s_mutex);
+	ret = sensor_call(cam, video, enum_framesizes, sizes);
+	mutex_unlock(&cam->s_mutex);
+	return ret;
+}
+
+static int cafe_vidioc_enum_frameintervals(struct file *filp, void *priv,
+		struct v4l2_frmivalenum *interval)
+{
+	struct cafe_camera *cam = priv;
+	int ret;
+
+	mutex_lock(&cam->s_mutex);
+	ret = sensor_call(cam, video, enum_frameintervals, interval);
+	mutex_unlock(&cam->s_mutex);
+	return ret;
+}
+
 #ifdef CONFIG_VIDEO_ADV_DEBUG
 static int cafe_vidioc_g_register(struct file *file, void *priv,
 		struct v4l2_dbg_register *reg)
@@ -1713,6 +1737,8 @@ static const struct v4l2_ioctl_ops cafe_v4l_ioctl_ops = {
 	.vidioc_s_ctrl		= cafe_vidioc_s_ctrl,
 	.vidioc_g_parm		= cafe_vidioc_g_parm,
 	.vidioc_s_parm		= cafe_vidioc_s_parm,
+	.vidioc_enum_framesizes = cafe_vidioc_enum_framesizes,
+	.vidioc_enum_frameintervals = cafe_vidioc_enum_frameintervals,
 	.vidioc_g_chip_ident    = cafe_vidioc_g_chip_ident,
 #ifdef CONFIG_VIDEO_ADV_DEBUG
 	.vidioc_g_register 	= cafe_vidioc_g_register,
-- 
1.7.2.2

