Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr4.xs4all.nl ([194.109.24.24]:3470 "EHLO
	smtp-vbr4.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754507Ab3CKVBK (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 11 Mar 2013 17:01:10 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Devin Heitmueller <dheitmueller@kernellabs.com>,
	Steven Toth <stoth@kernellabs.com>,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [REVIEW PATCH 07/15] au0828: add prio, control event and log_status support
Date: Mon, 11 Mar 2013 22:00:38 +0100
Message-Id: <6e670b2deb4d030800ef989fc593c22c2aa1adad.1363035203.git.hans.verkuil@cisco.com>
In-Reply-To: <1363035646-25244-1-git-send-email-hverkuil@xs4all.nl>
References: <1363035646-25244-1-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <0e2409cf677013b9cad1ba4aee17fe434dae7146.1363035203.git.hans.verkuil@cisco.com>
References: <0e2409cf677013b9cad1ba4aee17fe434dae7146.1363035203.git.hans.verkuil@cisco.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/usb/au0828/au0828-video.c |   42 ++++++++++++++++++++++++-------
 drivers/media/usb/au0828/au0828.h       |    4 +++
 2 files changed, 37 insertions(+), 9 deletions(-)

diff --git a/drivers/media/usb/au0828/au0828-video.c b/drivers/media/usb/au0828/au0828-video.c
index 7d762c0..07287ef 100644
--- a/drivers/media/usb/au0828/au0828-video.c
+++ b/drivers/media/usb/au0828/au0828-video.c
@@ -35,6 +35,7 @@
 #include <linux/suspend.h>
 #include <media/v4l2-common.h>
 #include <media/v4l2-ioctl.h>
+#include <media/v4l2-event.h>
 #include <media/v4l2-chip-ident.h>
 #include <media/tuner.h>
 #include "au0828.h"
@@ -988,6 +989,7 @@ static int au0828_v4l2_open(struct file *filp)
 
 	fh->type = type;
 	fh->dev = dev;
+	v4l2_fh_init(&fh->fh, vdev);
 	filp->private_data = fh;
 
 	if (fh->type == V4L2_BUF_TYPE_VIDEO_CAPTURE && dev->users == 0) {
@@ -1031,6 +1033,7 @@ static int au0828_v4l2_open(struct file *filp)
 				    V4L2_FIELD_SEQ_TB,
 				    sizeof(struct au0828_buffer), fh,
 				    &dev->lock);
+	v4l2_fh_add(&fh->fh);
 	return ret;
 }
 
@@ -1040,6 +1043,8 @@ static int au0828_v4l2_close(struct file *filp)
 	struct au0828_fh *fh = filp->private_data;
 	struct au0828_dev *dev = fh->dev;
 
+	v4l2_fh_del(&fh->fh);
+	v4l2_fh_exit(&fh->fh);
 	if (res_check(fh, AU0828_RESOURCE_VIDEO)) {
 		/* Cancel timeout thread in case they didn't call streamoff */
 		dev->vid_timeout_running = 0;
@@ -1061,6 +1066,7 @@ static int au0828_v4l2_close(struct file *filp)
 	if (dev->users == 1) {
 		if (dev->dev_state & DEV_DISCONNECTED) {
 			au0828_analog_unregister(dev);
+			kfree(fh);
 			kfree(dev);
 			return 0;
 		}
@@ -1128,23 +1134,27 @@ static unsigned int au0828_v4l2_poll(struct file *filp, poll_table *wait)
 {
 	struct au0828_fh *fh = filp->private_data;
 	struct au0828_dev *dev = fh->dev;
-	int rc;
+	unsigned long req_events = poll_requested_events(wait);
+	unsigned int res;
 
-	rc = check_dev(dev);
-	if (rc < 0)
-		return rc;
+	if (check_dev(dev) < 0)
+		return POLLERR;
+
+	res = v4l2_ctrl_poll(filp, wait);
+	if (!(req_events & (POLLIN | POLLRDNORM)))
+		return res;
 
 	if (fh->type == V4L2_BUF_TYPE_VIDEO_CAPTURE) {
 		if (!res_get(fh, AU0828_RESOURCE_VIDEO))
 			return POLLERR;
-		return videobuf_poll_stream(filp, &fh->vb_vidq, wait);
-	} else if (fh->type == V4L2_BUF_TYPE_VBI_CAPTURE) {
+		return res | videobuf_poll_stream(filp, &fh->vb_vidq, wait);
+	}
+	if (fh->type == V4L2_BUF_TYPE_VBI_CAPTURE) {
 		if (!res_get(fh, AU0828_RESOURCE_VBI))
 			return POLLERR;
-		return videobuf_poll_stream(filp, &fh->vb_vbiq, wait);
-	} else {
-		return POLLERR;
+		return res | videobuf_poll_stream(filp, &fh->vb_vbiq, wait);
 	}
+	return POLLERR;
 }
 
 static int au0828_v4l2_mmap(struct file *filp, struct vm_area_struct *vma)
@@ -1760,6 +1770,15 @@ static int vidioc_s_register(struct file *file, void *priv,
 }
 #endif
 
+static int vidioc_log_status(struct file *file, void *fh)
+{
+	struct video_device *vdev = video_devdata(file);
+
+	v4l2_ctrl_log_status(file, fh);
+	v4l2_device_call_all(vdev->v4l2_dev, 0, core, log_status);
+	return 0;
+}
+
 static int vidioc_reqbufs(struct file *file, void *priv,
 			  struct v4l2_requestbuffers *rb)
 {
@@ -1883,6 +1902,9 @@ static const struct v4l2_ioctl_ops video_ioctl_ops = {
 	.vidioc_s_register          = vidioc_s_register,
 #endif
 	.vidioc_g_chip_ident        = vidioc_g_chip_ident,
+	.vidioc_log_status	    = vidioc_log_status,
+	.vidioc_subscribe_event     = v4l2_ctrl_subscribe_event,
+	.vidioc_unsubscribe_event   = v4l2_event_unsubscribe,
 };
 
 static const struct video_device au0828_video_template = {
@@ -1979,12 +2001,14 @@ int au0828_analog_register(struct au0828_dev *dev,
 	*dev->vdev = au0828_video_template;
 	dev->vdev->v4l2_dev = &dev->v4l2_dev;
 	dev->vdev->lock = &dev->lock;
+	set_bit(V4L2_FL_USE_FH_PRIO, &dev->vdev->flags);
 	strcpy(dev->vdev->name, "au0828a video");
 
 	/* Setup the VBI device */
 	*dev->vbi_dev = au0828_video_template;
 	dev->vbi_dev->v4l2_dev = &dev->v4l2_dev;
 	dev->vbi_dev->lock = &dev->lock;
+	set_bit(V4L2_FL_USE_FH_PRIO, &dev->vbi_dev->flags);
 	strcpy(dev->vbi_dev->name, "au0828a vbi");
 
 	/* Register the v4l2 device */
diff --git a/drivers/media/usb/au0828/au0828.h b/drivers/media/usb/au0828/au0828.h
index 803af10..ad40048 100644
--- a/drivers/media/usb/au0828/au0828.h
+++ b/drivers/media/usb/au0828/au0828.h
@@ -29,6 +29,7 @@
 #include <media/videobuf-vmalloc.h>
 #include <media/v4l2-device.h>
 #include <media/v4l2-ctrls.h>
+#include <media/v4l2-fh.h>
 
 /* DVB */
 #include "demux.h"
@@ -119,6 +120,9 @@ enum au0828_dev_state {
 };
 
 struct au0828_fh {
+	/* must be the first field of this struct! */
+	struct v4l2_fh fh;
+
 	struct au0828_dev *dev;
 	unsigned int  resources;
 
-- 
1.7.10.4

