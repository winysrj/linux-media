Return-path: <mchehab@pedra>
Received: from sj-iport-6.cisco.com ([171.71.176.117]:56397 "EHLO
	sj-iport-6.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753081Ab1DDLwW (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 4 Apr 2011 07:52:22 -0400
Received: from OSLEXCP11.eu.tandberg.int ([173.38.136.5])
	by rcdn-core-2.cisco.com (8.14.3/8.14.3) with ESMTP id p34BqDrh001853
	for <linux-media@vger.kernel.org>; Mon, 4 Apr 2011 11:52:21 GMT
Received: from cobaltpc1.rd.tandberg.com (cobaltpc1.rd.tandberg.com [10.47.3.155])
	by ultra.eu.tandberg.int (8.13.1/8.13.1) with ESMTP id p34BqDdM009325
	for <linux-media@vger.kernel.org>; Mon, 4 Apr 2011 13:52:14 +0200
From: Hans Verkuil <hans.verkuil@cisco.com>
To: linux-media@vger.kernel.org
Subject: [RFCv1 PATCH 6/9] vivi: add support for control events.
Date: Mon,  4 Apr 2011 13:51:51 +0200
Message-Id: <a2608527646b3a947d8493feaa4f5df81655e571.1301916466.git.hans.verkuil@cisco.com>
In-Reply-To: <1301917914-27437-1-git-send-email-hans.verkuil@cisco.com>
References: <1301917914-27437-1-git-send-email-hans.verkuil@cisco.com>
In-Reply-To: <2fa42294dbc167cae5daf227d072b2284f77b1ab.1301916466.git.hans.verkuil@cisco.com>
References: <2fa42294dbc167cae5daf227d072b2284f77b1ab.1301916466.git.hans.verkuil@cisco.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/video/vivi.c |   41 +++++++++++++++++++++++++++++++++++++++--
 1 files changed, 39 insertions(+), 2 deletions(-)

diff --git a/drivers/media/video/vivi.c b/drivers/media/video/vivi.c
index 21d8f6a..8790e03 100644
--- a/drivers/media/video/vivi.c
+++ b/drivers/media/video/vivi.c
@@ -32,6 +32,7 @@
 #include <media/v4l2-ioctl.h>
 #include <media/v4l2-ctrls.h>
 #include <media/v4l2-fh.h>
+#include <media/v4l2-event.h>
 #include <media/v4l2-common.h>
 
 #define VIVI_MODULE_NAME "vivi"
@@ -983,6 +984,14 @@ static int vidioc_s_input(struct file *file, void *priv, unsigned int i)
 	return 0;
 }
 
+static int vidioc_subscribe_event(struct v4l2_fh *fh,
+				struct v4l2_event_subscription *sub)
+{
+	if (sub->type != V4L2_EVENT_CTRL_CH_VALUE)
+		return -EINVAL;
+	return v4l2_event_subscribe(fh, sub);
+}
+
 /* --- controls ---------------------------------------------- */
 
 static int vivi_s_ctrl(struct v4l2_ctrl *ctrl)
@@ -998,6 +1007,25 @@ static int vivi_s_ctrl(struct v4l2_ctrl *ctrl)
 	File operations for the device
    ------------------------------------------------------------------*/
 
+static int vivi_open(struct file *filp)
+{
+	int ret = v4l2_fh_open(filp);
+	struct v4l2_fh *fh;
+
+	if (ret)
+		return ret;
+	fh = filp->private_data;
+	ret = v4l2_event_init(fh);
+	if (ret)
+		goto rel_fh;
+	ret = v4l2_event_alloc(fh, 10);
+	if (!ret)
+		return ret;
+rel_fh:
+	v4l2_fh_release(filp);
+	return ret;
+}
+
 static ssize_t
 vivi_read(struct file *file, char __user *data, size_t count, loff_t *ppos)
 {
@@ -1012,10 +1040,17 @@ static unsigned int
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
@@ -1132,7 +1167,7 @@ static const struct v4l2_ctrl_config vivi_ctrl_bitmask = {
 
 static const struct v4l2_file_operations vivi_fops = {
 	.owner		= THIS_MODULE,
-	.open		= v4l2_fh_open,
+	.open		= vivi_open,
 	.release        = vivi_close,
 	.read           = vivi_read,
 	.poll		= vivi_poll,
@@ -1156,6 +1191,8 @@ static const struct v4l2_ioctl_ops vivi_ioctl_ops = {
 	.vidioc_s_input       = vidioc_s_input,
 	.vidioc_streamon      = vidioc_streamon,
 	.vidioc_streamoff     = vidioc_streamoff,
+	.vidioc_subscribe_event = vidioc_subscribe_event,
+	.vidioc_unsubscribe_event = v4l2_event_unsubscribe,
 };
 
 static struct video_device vivi_template = {
-- 
1.7.1

