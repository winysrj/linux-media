Return-path: <mchehab@pedra>
Received: from smtp-vbr8.xs4all.nl ([194.109.24.28]:3013 "EHLO
	smtp-vbr8.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753642Ab1E0O6H (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 27 May 2011 10:58:07 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Subject: [RFCv1 PATCH 5/5] vivi: add autogain/gain support to test the autofoo/foo code.
Date: Fri, 27 May 2011 16:57:55 +0200
Message-Id: <33de42ee5c6a34844bb67e2ec4f18b362fb68457.1306507763.git.hans.verkuil@cisco.com>
In-Reply-To: <1306508275-9228-1-git-send-email-hverkuil@xs4all.nl>
References: <1306508275-9228-1-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <287bab4f54ddce64458a69e0407d5866158fda0a.1306507763.git.hans.verkuil@cisco.com>
References: <287bab4f54ddce64458a69e0407d5866158fda0a.1306507763.git.hans.verkuil@cisco.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

From: Hans Verkuil <hans.verkuil@cisco.com>

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/video/vivi.c |   51 +++++++++++++++++++++++++++++--------------
 1 files changed, 34 insertions(+), 17 deletions(-)

diff --git a/drivers/media/video/vivi.c b/drivers/media/video/vivi.c
index 5184e55..d056fb0 100644
--- a/drivers/media/video/vivi.c
+++ b/drivers/media/video/vivi.c
@@ -217,6 +217,12 @@ struct vivi_dev {
 
 	/* controls */
 	struct v4l2_ctrl	   *volume;
+	struct v4l2_ctrl	   *brightness;
+	struct v4l2_ctrl	   *contrast;
+	struct v4l2_ctrl	   *sat;
+	struct v4l2_ctrl	   *hue;
+	struct v4l2_ctrl	   *autogain;
+	struct v4l2_ctrl	   *gain;
 	struct v4l2_ctrl	   *button;
 	struct v4l2_ctrl	   *boolean;
 	struct v4l2_ctrl	   *int32;
@@ -448,14 +454,6 @@ static void gen_text(struct vivi_dev *dev, char *basep,
 
 static void vivi_fillbuff(struct vivi_dev *dev, struct vivi_buffer *buf)
 {
-	struct v4l2_ctrl *brightness = v4l2_ctrl_find(&dev->ctrl_handler,
-							V4L2_CID_BRIGHTNESS);
-	struct v4l2_ctrl *contrast = v4l2_ctrl_find(&dev->ctrl_handler,
-							V4L2_CID_CONTRAST);
-	struct v4l2_ctrl *saturation = v4l2_ctrl_find(&dev->ctrl_handler,
-							V4L2_CID_SATURATION);
-	struct v4l2_ctrl *hue = v4l2_ctrl_find(&dev->ctrl_handler,
-							V4L2_CID_HUE);
 	int wmax = dev->width;
 	int hmax = dev->height;
 	struct timeval ts;
@@ -463,6 +461,7 @@ static void vivi_fillbuff(struct vivi_dev *dev, struct vivi_buffer *buf)
 	unsigned ms;
 	char str[100];
 	int h, line = 1;
+	s32 gain;
 
 	if (!vbuf)
 		return;
@@ -485,14 +484,17 @@ static void vivi_fillbuff(struct vivi_dev *dev, struct vivi_buffer *buf)
 			dev->width, dev->height, dev->input);
 	gen_text(dev, vbuf, line++ * 16, 16, str);
 
+	gain = v4l2_ctrl_g_ctrl(dev->gain);
 	mutex_lock(&dev->ctrl_handler.lock);
 	snprintf(str, sizeof(str), " brightness %3d, contrast %3d, saturation %3d, hue %d ",
-			brightness->cur.val,
-			contrast->cur.val,
-			saturation->cur.val,
-			hue->cur.val);
+			dev->brightness->cur.val,
+			dev->contrast->cur.val,
+			dev->sat->cur.val,
+			dev->hue->cur.val);
 	gen_text(dev, vbuf, line++ * 16, 16, str);
-	snprintf(str, sizeof(str), " volume %3d ", dev->volume->cur.val);
+	snprintf(str, sizeof(str), " volume %3d, autogain %d, gain %3d ",
+			dev->volume->cur.val, dev->autogain->cur.val,
+			gain);
 	gen_text(dev, vbuf, line++ * 16, 16, str);
 	snprintf(str, sizeof(str), " int32 %d, int64 %lld, bitmask %08x ",
 			dev->int32->cur.val,
@@ -1005,6 +1007,15 @@ static int vidioc_subscribe_event(struct v4l2_fh *fh,
 
 /* --- controls ---------------------------------------------- */
 
+static int vivi_g_volatile_ctrl(struct v4l2_ctrl *ctrl)
+{
+	struct vivi_dev *dev = container_of(ctrl->handler, struct vivi_dev, ctrl_handler);
+
+	if (ctrl == dev->autogain)
+		dev->gain->val = jiffies & 0xff;
+	return 0;
+}
+
 static int vivi_s_ctrl(struct v4l2_ctrl *ctrl)
 {
 	struct vivi_dev *dev = container_of(ctrl->handler, struct vivi_dev, ctrl_handler);
@@ -1074,6 +1085,7 @@ static int vivi_mmap(struct file *file, struct vm_area_struct *vma)
 }
 
 static const struct v4l2_ctrl_ops vivi_ctrl_ops = {
+	.g_volatile_ctrl = vivi_g_volatile_ctrl,
 	.s_ctrl = vivi_s_ctrl,
 };
 
@@ -1247,16 +1259,20 @@ static int __init vivi_create_instance(int inst)
 
 	hdl = &dev->ctrl_handler;
 	v4l2_ctrl_handler_init(hdl, 12);
-	v4l2_ctrl_new_std(hdl, &vivi_ctrl_ops,
+	dev->brightness = v4l2_ctrl_new_std(hdl, &vivi_ctrl_ops,
 			V4L2_CID_BRIGHTNESS, i, 255, 1, 127 + i);
-	v4l2_ctrl_new_std(hdl, &vivi_ctrl_ops,
+	dev->contrast = v4l2_ctrl_new_std(hdl, &vivi_ctrl_ops,
 			V4L2_CID_CONTRAST, i, 255, 1, 16 + i);
-	v4l2_ctrl_new_std(hdl, &vivi_ctrl_ops,
+	dev->sat = v4l2_ctrl_new_std(hdl, &vivi_ctrl_ops,
 			V4L2_CID_SATURATION, i, 255, 1, 127 + i);
-	v4l2_ctrl_new_std(hdl, &vivi_ctrl_ops,
+	dev->hue = v4l2_ctrl_new_std(hdl, &vivi_ctrl_ops,
 			V4L2_CID_HUE, -128 + i, 127, 1, i);
 	dev->volume = v4l2_ctrl_new_std(hdl, &vivi_ctrl_ops,
 			V4L2_CID_AUDIO_VOLUME, 0, 255, 1, 200);
+	dev->autogain = v4l2_ctrl_new_std(hdl, &vivi_ctrl_ops,
+			V4L2_CID_AUTOGAIN, 0, 1, 1, 1);
+	dev->gain = v4l2_ctrl_new_std(hdl, &vivi_ctrl_ops,
+			V4L2_CID_GAIN, 0, 255, 1, 100);
 	dev->button = v4l2_ctrl_new_custom(hdl, &vivi_ctrl_button, NULL);
 	dev->int32 = v4l2_ctrl_new_custom(hdl, &vivi_ctrl_int32, NULL);
 	dev->int64 = v4l2_ctrl_new_custom(hdl, &vivi_ctrl_int64, NULL);
@@ -1268,6 +1284,7 @@ static int __init vivi_create_instance(int inst)
 		ret = hdl->error;
 		goto unreg_dev;
 	}
+	v4l2_ctrl_auto_cluster(2, &dev->autogain, 0, true);
 	dev->v4l2_dev.ctrl_handler = hdl;
 
 	/* initialize locks */
-- 
1.7.1

