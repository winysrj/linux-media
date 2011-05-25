Return-path: <mchehab@pedra>
Received: from smtp-vbr5.xs4all.nl ([194.109.24.25]:1928 "EHLO
	smtp-vbr5.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932540Ab1EYNeT (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 25 May 2011 09:34:19 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Subject: [RFCv2 PATCH 09/11] vivi: support control events.
Date: Wed, 25 May 2011 15:33:53 +0200
Message-Id: <e901e65931cf0ca2bee57e5458f045b2ffbdfa0e.1306329390.git.hans.verkuil@cisco.com>
In-Reply-To: <1306330435-11799-1-git-send-email-hverkuil@xs4all.nl>
References: <1306330435-11799-1-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <6cea502820c1684f34b9e862a64be2972afb718f.1306329390.git.hans.verkuil@cisco.com>
References: <6cea502820c1684f34b9e862a64be2972afb718f.1306329390.git.hans.verkuil@cisco.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

From: Hans Verkuil <hans.verkuil@cisco.com>

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/video/vivi.c |  161 ++++++++++++++++++++++++++-----------------
 1 files changed, 97 insertions(+), 64 deletions(-)

diff --git a/drivers/media/video/vivi.c b/drivers/media/video/vivi.c
index 21d8f6a..93692ad 100644
--- a/drivers/media/video/vivi.c
+++ b/drivers/media/video/vivi.c
@@ -32,6 +32,7 @@
 #include <media/v4l2-ioctl.h>
 #include <media/v4l2-ctrls.h>
 #include <media/v4l2-fh.h>
+#include <media/v4l2-event.h>
 #include <media/v4l2-common.h>
 
 #define VIVI_MODULE_NAME "vivi"
@@ -157,54 +158,6 @@ struct vivi_dmaqueue {
 
 static LIST_HEAD(vivi_devlist);
 
-struct vivi_dev {
-	struct list_head           vivi_devlist;
-	struct v4l2_device 	   v4l2_dev;
-	struct v4l2_ctrl_handler   ctrl_handler;
-
-	/* controls */
-	struct v4l2_ctrl	   *brightness;
-	struct v4l2_ctrl	   *contrast;
-	struct v4l2_ctrl	   *saturation;
-	struct v4l2_ctrl	   *hue;
-	struct v4l2_ctrl	   *volume;
-	struct v4l2_ctrl	   *button;
-	struct v4l2_ctrl	   *boolean;
-	struct v4l2_ctrl	   *int32;
-	struct v4l2_ctrl	   *int64;
-	struct v4l2_ctrl	   *menu;
-	struct v4l2_ctrl	   *string;
-	struct v4l2_ctrl	   *bitmask;
-
-	spinlock_t                 slock;
-	struct mutex		   mutex;
-
-	/* various device info */
-	struct video_device        *vfd;
-
-	struct vivi_dmaqueue       vidq;
-
-	/* Several counters */
-	unsigned 		   ms;
-	unsigned long              jiffies;
-	unsigned		   button_pressed;
-
-	int			   mv_count;	/* Controls bars movement */
-
-	/* Input Number */
-	int			   input;
-
-	/* video capture */
-	struct vivi_fmt            *fmt;
-	unsigned int               width, height;
-	struct vb2_queue	   vb_vidq;
-	enum v4l2_field		   field;
-	unsigned int		   field_count;
-
-	u8 			   bars[9][3];
-	u8 			   line[MAX_WIDTH * 4];
-};
-
 /* ------------------------------------------------------------------
 	DMA and thread functions
    ------------------------------------------------------------------*/
@@ -257,6 +210,50 @@ static struct bar_std bars[] = {
 
 #define NUM_INPUTS ARRAY_SIZE(bars)
 
+struct vivi_dev {
+	struct list_head           vivi_devlist;
+	struct v4l2_device	   v4l2_dev;
+	struct v4l2_ctrl_handler   ctrl_handler;
+
+	/* controls */
+	struct v4l2_ctrl	   *volume;
+	struct v4l2_ctrl	   *button;
+	struct v4l2_ctrl	   *boolean;
+	struct v4l2_ctrl	   *int32;
+	struct v4l2_ctrl	   *int64;
+	struct v4l2_ctrl	   *menu;
+	struct v4l2_ctrl	   *string;
+	struct v4l2_ctrl	   *bitmask;
+
+	spinlock_t                 slock;
+	struct mutex		   mutex;
+
+	/* various device info */
+	struct video_device        *vfd;
+
+	struct vivi_dmaqueue       vidq;
+
+	/* Several counters */
+	unsigned		   ms;
+	unsigned long              jiffies;
+	unsigned		   button_pressed;
+
+	int			   mv_count;	/* Controls bars movement */
+
+	/* Input Number */
+	int			   input;
+
+	/* video capture */
+	struct vivi_fmt            *fmt;
+	unsigned int               width, height;
+	struct vb2_queue	   vb_vidq;
+	enum v4l2_field		   field;
+	unsigned int		   field_count;
+
+	u8			   bars[9][3];
+	u8			   line[MAX_WIDTH * 4];
+};
+
 #define TO_Y(r, g, b) \
 	(((16829 * r + 33039 * g + 6416 * b  + 32768) >> 16) + 16)
 /* RGB to  V(Cr) Color transform */
@@ -451,6 +448,14 @@ static void gen_text(struct vivi_dev *dev, char *basep,
 
 static void vivi_fillbuff(struct vivi_dev *dev, struct vivi_buffer *buf)
 {
+	struct v4l2_ctrl *brightness = v4l2_ctrl_find(&dev->ctrl_handler,
+							V4L2_CID_BRIGHTNESS);
+	struct v4l2_ctrl *contrast = v4l2_ctrl_find(&dev->ctrl_handler,
+							V4L2_CID_CONTRAST);
+	struct v4l2_ctrl *saturation = v4l2_ctrl_find(&dev->ctrl_handler,
+							V4L2_CID_SATURATION);
+	struct v4l2_ctrl *hue = v4l2_ctrl_find(&dev->ctrl_handler,
+							V4L2_CID_HUE);
 	int wmax = dev->width;
 	int hmax = dev->height;
 	struct timeval ts;
@@ -482,10 +487,10 @@ static void vivi_fillbuff(struct vivi_dev *dev, struct vivi_buffer *buf)
 
 	mutex_lock(&dev->ctrl_handler.lock);
 	snprintf(str, sizeof(str), " brightness %3d, contrast %3d, saturation %3d, hue %d ",
-			dev->brightness->cur.val,
-			dev->contrast->cur.val,
-			dev->saturation->cur.val,
-			dev->hue->cur.val);
+			brightness->cur.val,
+			contrast->cur.val,
+			saturation->cur.val,
+			hue->cur.val);
 	gen_text(dev, vbuf, line++ * 16, 16, str);
 	snprintf(str, sizeof(str), " volume %3d ", dev->volume->cur.val);
 	gen_text(dev, vbuf, line++ * 16, 16, str);
@@ -977,12 +982,29 @@ static int vidioc_s_input(struct file *file, void *priv, unsigned int i)
 	if (i >= NUM_INPUTS)
 		return -EINVAL;
 
+	if (i == dev->input)
+		return 0;
+
 	dev->input = i;
 	precalculate_bars(dev);
 	precalculate_line(dev);
 	return 0;
 }
 
+static int vidioc_subscribe_event(struct v4l2_fh *fh,
+				struct v4l2_event_subscription *sub)
+{
+	int ret;
+
+	switch (sub->type) {
+	case V4L2_EVENT_CTRL:
+		return v4l2_ctrl_sub_fh(fh, sub,
+				v4l2_ctrl_handler_cnt(fh->ctrl_handler) * 2);
+	default:
+		return -EINVAL;
+	}
+}
+
 /* --- controls ---------------------------------------------- */
 
 static int vivi_s_ctrl(struct v4l2_ctrl *ctrl)
@@ -1012,10 +1034,17 @@ static unsigned int
 vivi_poll(struct file *file, struct poll_table_struct *wait)
 {
 	struct vivi_dev *dev = video_drvdata(file);
+	struct v4l2_fh *fh = file->private_data;
 	struct vb2_queue *q = &dev->vb_vidq;
+	unsigned int res;
 
 	dprintk(dev, 1, "%s\n", __func__);
-	return vb2_poll(q, file, wait);
+	res = vb2_poll(q, file, wait);
+	if (v4l2_event_pending(fh))
+		res |= POLLPRI;
+	else
+		poll_wait(file, &fh->events->wait, wait);
+	return res;
 }
 
 static int vivi_close(struct file *file)
@@ -1132,7 +1161,7 @@ static const struct v4l2_ctrl_config vivi_ctrl_bitmask = {
 
 static const struct v4l2_file_operations vivi_fops = {
 	.owner		= THIS_MODULE,
-	.open		= v4l2_fh_open,
+	.open           = v4l2_fh_open,
 	.release        = vivi_close,
 	.read           = vivi_read,
 	.poll		= vivi_poll,
@@ -1156,6 +1185,8 @@ static const struct v4l2_ioctl_ops vivi_ioctl_ops = {
 	.vidioc_s_input       = vidioc_s_input,
 	.vidioc_streamon      = vidioc_streamon,
 	.vidioc_streamoff     = vidioc_streamoff,
+	.vidioc_subscribe_event = vidioc_subscribe_event,
+	.vidioc_unsubscribe_event = v4l2_event_unsubscribe,
 };
 
 static struct video_device vivi_template = {
@@ -1200,6 +1231,7 @@ static int __init vivi_create_instance(int inst)
 	struct v4l2_ctrl_handler *hdl;
 	struct vb2_queue *q;
 	int ret;
+	int i;
 
 	dev = kzalloc(sizeof(*dev), GFP_KERNEL);
 	if (!dev)
@@ -1214,18 +1246,19 @@ static int __init vivi_create_instance(int inst)
 	dev->fmt = &formats[0];
 	dev->width = 640;
 	dev->height = 480;
+
 	hdl = &dev->ctrl_handler;
-	v4l2_ctrl_handler_init(hdl, 11);
+	v4l2_ctrl_handler_init(hdl, 12);
+	v4l2_ctrl_new_std(hdl, &vivi_ctrl_ops,
+			V4L2_CID_BRIGHTNESS, i, 255, 1, 127 + i);
+	v4l2_ctrl_new_std(hdl, &vivi_ctrl_ops,
+			V4L2_CID_CONTRAST, i, 255, 1, 16 + i);
+	v4l2_ctrl_new_std(hdl, &vivi_ctrl_ops,
+			V4L2_CID_SATURATION, i, 255, 1, 127 + i);
+	v4l2_ctrl_new_std(hdl, &vivi_ctrl_ops,
+			V4L2_CID_HUE, -128 + i, 127, 1, i);
 	dev->volume = v4l2_ctrl_new_std(hdl, &vivi_ctrl_ops,
 			V4L2_CID_AUDIO_VOLUME, 0, 255, 1, 200);
-	dev->brightness = v4l2_ctrl_new_std(hdl, &vivi_ctrl_ops,
-			V4L2_CID_BRIGHTNESS, 0, 255, 1, 127);
-	dev->contrast = v4l2_ctrl_new_std(hdl, &vivi_ctrl_ops,
-			V4L2_CID_CONTRAST, 0, 255, 1, 16);
-	dev->saturation = v4l2_ctrl_new_std(hdl, &vivi_ctrl_ops,
-			V4L2_CID_SATURATION, 0, 255, 1, 127);
-	dev->hue = v4l2_ctrl_new_std(hdl, &vivi_ctrl_ops,
-			V4L2_CID_HUE, -128, 127, 1, 0);
 	dev->button = v4l2_ctrl_new_custom(hdl, &vivi_ctrl_button, NULL);
 	dev->int32 = v4l2_ctrl_new_custom(hdl, &vivi_ctrl_int32, NULL);
 	dev->int64 = v4l2_ctrl_new_custom(hdl, &vivi_ctrl_int64, NULL);
@@ -1296,7 +1329,7 @@ static int __init vivi_create_instance(int inst)
 rel_vdev:
 	video_device_release(vfd);
 unreg_dev:
-	v4l2_ctrl_handler_free(hdl);
+	v4l2_ctrl_handler_free(&dev->ctrl_handler);
 	v4l2_device_unregister(&dev->v4l2_dev);
 free_dev:
 	kfree(dev);
-- 
1.7.1

