Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr14.xs4all.nl ([194.109.24.34]:1060 "EHLO
	smtp-vbr14.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754136Ab3CKLq7 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 11 Mar 2013 07:46:59 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Volokh Konstantin <volokh84@gmail.com>,
	Pete Eberlein <pete@sensoray.com>,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [REVIEW PATCH 27/42] go7007: add prio and control event support.
Date: Mon, 11 Mar 2013 12:46:05 +0100
Message-Id: <153d784837fa2962a737dae9515ab9c0a7a82c21.1363000605.git.hans.verkuil@cisco.com>
In-Reply-To: <1363002380-19825-1-git-send-email-hverkuil@xs4all.nl>
References: <1363002380-19825-1-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <38bc3cc42d0c021432afd29c2c1e22cf380b06e0.1363000605.git.hans.verkuil@cisco.com>
References: <38bc3cc42d0c021432afd29c2c1e22cf380b06e0.1363000605.git.hans.verkuil@cisco.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/staging/media/go7007/go7007-priv.h |    2 ++
 drivers/staging/media/go7007/go7007-v4l2.c |   23 ++++++++++++++++++-----
 2 files changed, 20 insertions(+), 5 deletions(-)

diff --git a/drivers/staging/media/go7007/go7007-priv.h b/drivers/staging/media/go7007/go7007-priv.h
index d127a8d..2321fd7 100644
--- a/drivers/staging/media/go7007/go7007-priv.h
+++ b/drivers/staging/media/go7007/go7007-priv.h
@@ -23,6 +23,7 @@
 
 #include <media/v4l2-device.h>
 #include <media/v4l2-ctrls.h>
+#include <media/v4l2-fh.h>
 
 struct go7007;
 
@@ -143,6 +144,7 @@ struct go7007_buffer {
 };
 
 struct go7007_file {
+	struct v4l2_fh fh;
 	struct go7007 *go;
 	struct mutex lock;
 	int buf_count;
diff --git a/drivers/staging/media/go7007/go7007-v4l2.c b/drivers/staging/media/go7007/go7007-v4l2.c
index cb89af3..186a56b 100644
--- a/drivers/staging/media/go7007/go7007-v4l2.c
+++ b/drivers/staging/media/go7007/go7007-v4l2.c
@@ -27,13 +27,14 @@
 #include <linux/time.h>
 #include <linux/vmalloc.h>
 #include <linux/pagemap.h>
+#include <linux/i2c.h>
+#include <linux/mutex.h>
+#include <linux/uaccess.h>
 #include <linux/videodev2.h>
 #include <media/v4l2-common.h>
 #include <media/v4l2-ioctl.h>
 #include <media/v4l2-subdev.h>
-#include <linux/i2c.h>
-#include <linux/mutex.h>
-#include <linux/uaccess.h>
+#include <media/v4l2-event.h>
 
 #include "go7007.h"
 #include "go7007-priv.h"
@@ -101,6 +102,8 @@ static int go7007_open(struct file *file)
 	mutex_init(&gofh->lock);
 	gofh->buf_count = 0;
 	file->private_data = gofh;
+	v4l2_fh_init(&gofh->fh, video_devdata(file));
+	v4l2_fh_add(&gofh->fh);
 	return 0;
 }
 
@@ -115,6 +118,8 @@ static int go7007_release(struct file *file)
 		kfree(gofh->bufs);
 		gofh->buf_count = 0;
 	}
+	v4l2_fh_del(&gofh->fh);
+	v4l2_fh_exit(&gofh->fh);
 	kfree(gofh);
 	file->private_data = NULL;
 	return 0;
@@ -1582,16 +1587,20 @@ static int go7007_mmap(struct file *file, struct vm_area_struct *vma)
 
 static unsigned int go7007_poll(struct file *file, poll_table *wait)
 {
+	unsigned long req_events = poll_requested_events(wait);
 	struct go7007_file *gofh = file->private_data;
 	struct go7007_buffer *gobuf;
+	unsigned int res = v4l2_ctrl_poll(file, wait);
 
+	if (!(req_events & (POLLIN | POLLRDNORM)))
+		return res;
 	if (list_empty(&gofh->go->stream))
 		return POLLERR;
 	gobuf = list_entry(gofh->go->stream.next, struct go7007_buffer, stream);
 	poll_wait(file, &gofh->go->frame_waitq, wait);
 	if (gobuf->state == BUF_STATE_DONE)
-		return POLLIN | POLLRDNORM;
-	return 0;
+		return res | POLLIN | POLLRDNORM;
+	return res;
 }
 
 static void go7007_vfl_release(struct video_device *vfd)
@@ -1645,6 +1654,9 @@ static const struct v4l2_ioctl_ops video_ioctl_ops = {
 	.vidioc_cropcap           = vidioc_cropcap,
 	.vidioc_g_crop            = vidioc_g_crop,
 	.vidioc_s_crop            = vidioc_s_crop,
+	.vidioc_log_status        = v4l2_ctrl_log_status,
+	.vidioc_subscribe_event   = v4l2_ctrl_subscribe_event,
+	.vidioc_unsubscribe_event = v4l2_event_unsubscribe,
 };
 
 static struct video_device go7007_template = {
@@ -1707,6 +1719,7 @@ int go7007_v4l2_init(struct go7007 *go)
 	if (go->video_dev == NULL)
 		return -ENOMEM;
 	*go->video_dev = go7007_template;
+	set_bit(V4L2_FL_USE_FH_PRIO, &go->video_dev->flags);
 	video_set_drvdata(go->video_dev, go);
 	go->video_dev->v4l2_dev = &go->v4l2_dev;
 	rv = video_register_device(go->video_dev, VFL_TYPE_GRABBER, -1);
-- 
1.7.10.4

