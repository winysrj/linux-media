Return-path: <mchehab@pedra>
Received: from smtp-vbr1.xs4all.nl ([194.109.24.21]:3407 "EHLO
	smtp-vbr1.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755295Ab1FGPFg (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 7 Jun 2011 11:05:36 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Subject: [RFCv3 PATCH 10/18] vivi: add autogain/gain support to test the autocluster functionality.
Date: Tue,  7 Jun 2011 17:05:15 +0200
Message-Id: <d7900e5fef93bfa3c0209ac07ee9ecea37bb4439.1307458245.git.hans.verkuil@cisco.com>
In-Reply-To: <1307459123-17810-1-git-send-email-hverkuil@xs4all.nl>
References: <1307459123-17810-1-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <a1daecb26b464ddd980297783d04941f1f34666b.1307458245.git.hans.verkuil@cisco.com>
References: <a1daecb26b464ddd980297783d04941f1f34666b.1307458245.git.hans.verkuil@cisco.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

From: Hans Verkuil <hans.verkuil@cisco.com>

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/video/vivi.c |   25 ++++++++++++++++++++++++-
 1 files changed, 24 insertions(+), 1 deletions(-)

diff --git a/drivers/media/video/vivi.c b/drivers/media/video/vivi.c
index 2238a61..6e62ddf 100644
--- a/drivers/media/video/vivi.c
+++ b/drivers/media/video/vivi.c
@@ -167,6 +167,11 @@ struct vivi_dev {
 	struct v4l2_ctrl	   *contrast;
 	struct v4l2_ctrl	   *saturation;
 	struct v4l2_ctrl	   *hue;
+	struct {
+		/* autogain/gain cluster */
+		struct v4l2_ctrl	   *autogain;
+		struct v4l2_ctrl	   *gain;
+	};
 	struct v4l2_ctrl	   *volume;
 	struct v4l2_ctrl	   *button;
 	struct v4l2_ctrl	   *boolean;
@@ -457,6 +462,7 @@ static void vivi_fillbuff(struct vivi_dev *dev, struct vivi_buffer *buf)
 	unsigned ms;
 	char str[100];
 	int h, line = 1;
+	s32 gain;
 
 	if (!vbuf)
 		return;
@@ -479,6 +485,7 @@ static void vivi_fillbuff(struct vivi_dev *dev, struct vivi_buffer *buf)
 			dev->width, dev->height, dev->input);
 	gen_text(dev, vbuf, line++ * 16, 16, str);
 
+	gain = v4l2_ctrl_g_ctrl(dev->gain);
 	mutex_lock(&dev->ctrl_handler.lock);
 	snprintf(str, sizeof(str), " brightness %3d, contrast %3d, saturation %3d, hue %d ",
 			dev->brightness->cur.val,
@@ -486,7 +493,8 @@ static void vivi_fillbuff(struct vivi_dev *dev, struct vivi_buffer *buf)
 			dev->saturation->cur.val,
 			dev->hue->cur.val);
 	gen_text(dev, vbuf, line++ * 16, 16, str);
-	snprintf(str, sizeof(str), " volume %3d ", dev->volume->cur.val);
+	snprintf(str, sizeof(str), " autogain %d, gain %3d, volume %3d ",
+			dev->autogain->cur.val, gain, dev->volume->cur.val);
 	gen_text(dev, vbuf, line++ * 16, 16, str);
 	snprintf(str, sizeof(str), " int32 %d, int64 %lld ",
 			dev->int32->cur.val,
@@ -983,6 +991,15 @@ static int vidioc_s_input(struct file *file, void *priv, unsigned int i)
 
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
@@ -1045,6 +1062,7 @@ static int vivi_mmap(struct file *file, struct vm_area_struct *vma)
 }
 
 static const struct v4l2_ctrl_ops vivi_ctrl_ops = {
+	.g_volatile_ctrl = vivi_g_volatile_ctrl,
 	.s_ctrl = vivi_s_ctrl,
 };
 
@@ -1213,6 +1231,10 @@ static int __init vivi_create_instance(int inst)
 			V4L2_CID_SATURATION, 0, 255, 1, 127);
 	dev->hue = v4l2_ctrl_new_std(hdl, &vivi_ctrl_ops,
 			V4L2_CID_HUE, -128, 127, 1, 0);
+	dev->autogain = v4l2_ctrl_new_std(hdl, &vivi_ctrl_ops,
+			V4L2_CID_AUTOGAIN, 0, 1, 1, 1);
+	dev->gain = v4l2_ctrl_new_std(hdl, &vivi_ctrl_ops,
+			V4L2_CID_GAIN, 0, 255, 1, 100);
 	dev->button = v4l2_ctrl_new_custom(hdl, &vivi_ctrl_button, NULL);
 	dev->int32 = v4l2_ctrl_new_custom(hdl, &vivi_ctrl_int32, NULL);
 	dev->int64 = v4l2_ctrl_new_custom(hdl, &vivi_ctrl_int64, NULL);
@@ -1223,6 +1245,7 @@ static int __init vivi_create_instance(int inst)
 		ret = hdl->error;
 		goto unreg_dev;
 	}
+	v4l2_ctrl_auto_cluster(2, &dev->autogain, 0, true);
 	dev->v4l2_dev.ctrl_handler = hdl;
 
 	/* initialize locks */
-- 
1.7.1

