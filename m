Return-path: <mchehab@pedra>
Received: from smtp-vbr1.xs4all.nl ([194.109.24.21]:4285 "EHLO
	smtp-vbr1.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755295Ab1FGPFk (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 7 Jun 2011 11:05:40 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Subject: [RFCv3 PATCH 16/18] vivi: support control events.
Date: Tue,  7 Jun 2011 17:05:21 +0200
Message-Id: <80bb8e77ecd34dbf940b6dbdd56414820cec38e5.1307458245.git.hans.verkuil@cisco.com>
In-Reply-To: <1307459123-17810-1-git-send-email-hverkuil@xs4all.nl>
References: <1307459123-17810-1-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <a1daecb26b464ddd980297783d04941f1f34666b.1307458245.git.hans.verkuil@cisco.com>
References: <a1daecb26b464ddd980297783d04941f1f34666b.1307458245.git.hans.verkuil@cisco.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

From: Hans Verkuil <hans.verkuil@cisco.com>

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/video/vivi.c |   28 ++++++++++++++++++++++++++--
 1 files changed, 26 insertions(+), 2 deletions(-)

diff --git a/drivers/media/video/vivi.c b/drivers/media/video/vivi.c
index 6e62ddf..f4f599a 100644
--- a/drivers/media/video/vivi.c
+++ b/drivers/media/video/vivi.c
@@ -32,6 +32,7 @@
 #include <media/v4l2-ioctl.h>
 #include <media/v4l2-ctrls.h>
 #include <media/v4l2-fh.h>
+#include <media/v4l2-event.h>
 #include <media/v4l2-common.h>
 
 #define VIVI_MODULE_NAME "vivi"
@@ -983,12 +984,26 @@ static int vidioc_s_input(struct file *file, void *priv, unsigned int i)
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
+	switch (sub->type) {
+	case V4L2_EVENT_CTRL:
+		return v4l2_ctrl_subscribe_fh(fh, sub, 0);
+	default:
+		return -EINVAL;
+	}
+}
+
 /* --- controls ---------------------------------------------- */
 
 static int vivi_g_volatile_ctrl(struct v4l2_ctrl *ctrl)
@@ -1027,10 +1042,17 @@ static unsigned int
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
@@ -1137,7 +1159,7 @@ static const struct v4l2_ctrl_config vivi_ctrl_string = {
 
 static const struct v4l2_file_operations vivi_fops = {
 	.owner		= THIS_MODULE,
-	.open		= v4l2_fh_open,
+	.open           = v4l2_fh_open,
 	.release        = vivi_close,
 	.read           = vivi_read,
 	.poll		= vivi_poll,
@@ -1161,6 +1183,8 @@ static const struct v4l2_ioctl_ops vivi_ioctl_ops = {
 	.vidioc_s_input       = vidioc_s_input,
 	.vidioc_streamon      = vidioc_streamon,
 	.vidioc_streamoff     = vidioc_streamoff,
+	.vidioc_subscribe_event = vidioc_subscribe_event,
+	.vidioc_unsubscribe_event = v4l2_event_unsubscribe,
 };
 
 static struct video_device vivi_template = {
-- 
1.7.1

