Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr15.xs4all.nl ([194.109.24.35]:3546 "EHLO
	smtp-vbr15.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754752Ab2FJKzS (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 10 Jun 2012 06:55:18 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Steven Toth <stoth@kernellabs.com>,
	Michael Krufky <mkrufky@linuxtv.org>,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [RFCv1 PATCH 08/11] cx88: support control events.
Date: Sun, 10 Jun 2012 12:54:54 +0200
Message-Id: <0a365dd98608df01db5f2f93861bcae73d293d0b.1339325224.git.hans.verkuil@cisco.com>
In-Reply-To: <1339325697-23280-1-git-send-email-hverkuil@xs4all.nl>
References: <1339325697-23280-1-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <541a39bdcc8a94d3de87a6a6d0b1b7c476983984.1339325224.git.hans.verkuil@cisco.com>
References: <541a39bdcc8a94d3de87a6a6d0b1b7c476983984.1339325224.git.hans.verkuil@cisco.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/video/cx88/cx88-blackbird.c |    5 ++++-
 drivers/media/video/cx88/cx88-video.c     |   16 ++++++++++------
 2 files changed, 14 insertions(+), 7 deletions(-)

diff --git a/drivers/media/video/cx88/cx88-blackbird.c b/drivers/media/video/cx88/cx88-blackbird.c
index ac8473e..1a5facb 100644
--- a/drivers/media/video/cx88/cx88-blackbird.c
+++ b/drivers/media/video/cx88/cx88-blackbird.c
@@ -35,6 +35,7 @@
 #include <linux/firmware.h>
 #include <media/v4l2-common.h>
 #include <media/v4l2-ioctl.h>
+#include <media/v4l2-event.h>
 #include <media/cx2341x.h>
 
 #include "cx88.h"
@@ -1053,7 +1054,7 @@ mpeg_poll(struct file *file, struct poll_table_struct *wait)
 	if (!dev->mpeg_active && (req_events & (POLLIN | POLLRDNORM)))
 		blackbird_start_codec(file, fh);
 
-	return videobuf_poll_stream(file, &fh->mpegq, wait);
+	return v4l2_ctrl_poll(file, wait) | videobuf_poll_stream(file, &fh->mpegq, wait);
 }
 
 static int
@@ -1096,6 +1097,8 @@ static const struct v4l2_ioctl_ops mpeg_ioctl_ops = {
 	.vidioc_g_tuner       = vidioc_g_tuner,
 	.vidioc_s_tuner       = vidioc_s_tuner,
 	.vidioc_s_std         = vidioc_s_std,
+	.vidioc_subscribe_event      = v4l2_ctrl_subscribe_event,
+	.vidioc_unsubscribe_event    = v4l2_event_unsubscribe,
 };
 
 static struct video_device cx8802_mpeg_template = {
diff --git a/drivers/media/video/cx88/cx88-video.c b/drivers/media/video/cx88/cx88-video.c
index 673f88b..930d43b 100644
--- a/drivers/media/video/cx88/cx88-video.c
+++ b/drivers/media/video/cx88/cx88-video.c
@@ -40,6 +40,7 @@
 #include "cx88.h"
 #include <media/v4l2-common.h>
 #include <media/v4l2-ioctl.h>
+#include <media/v4l2-event.h>
 #include <media/wm8775.h>
 
 MODULE_DESCRIPTION("v4l2 driver module for cx2388x based TV cards");
@@ -823,12 +824,12 @@ video_poll(struct file *file, struct poll_table_struct *wait)
 	struct video_device *vdev = video_devdata(file);
 	struct cx8800_fh *fh = file->private_data;
 	struct cx88_buffer *buf;
-	unsigned int rc = POLLERR;
+	unsigned int rc = v4l2_ctrl_poll(file, wait);
 
 	if (vdev->vfl_type == VFL_TYPE_VBI) {
 		if (!res_get(fh->dev,fh,RESOURCE_VBI))
-			return POLLERR;
-		return videobuf_poll_stream(file, &fh->vbiq, wait);
+			return rc | POLLERR;
+		return rc | videobuf_poll_stream(file, &fh->vbiq, wait);
 	}
 
 	mutex_lock(&fh->vidq.vb_lock);
@@ -846,9 +847,7 @@ video_poll(struct file *file, struct poll_table_struct *wait)
 	poll_wait(file, &buf->vb.done, wait);
 	if (buf->vb.state == VIDEOBUF_DONE ||
 	    buf->vb.state == VIDEOBUF_ERROR)
-		rc = POLLIN|POLLRDNORM;
-	else
-		rc = 0;
+		rc |= POLLIN|POLLRDNORM;
 done:
 	mutex_unlock(&fh->vidq.vb_lock);
 	return rc;
@@ -1561,6 +1560,8 @@ static const struct v4l2_ioctl_ops video_ioctl_ops = {
 	.vidioc_s_tuner       = vidioc_s_tuner,
 	.vidioc_g_frequency   = vidioc_g_frequency,
 	.vidioc_s_frequency   = vidioc_s_frequency,
+	.vidioc_subscribe_event      = v4l2_ctrl_subscribe_event,
+	.vidioc_unsubscribe_event    = v4l2_event_unsubscribe,
 #ifdef CONFIG_VIDEO_ADV_DEBUG
 	.vidioc_g_register    = vidioc_g_register,
 	.vidioc_s_register    = vidioc_s_register,
@@ -1581,6 +1582,7 @@ static const struct v4l2_file_operations radio_fops =
 {
 	.owner         = THIS_MODULE,
 	.open          = video_open,
+	.poll          = v4l2_ctrl_poll,
 	.release       = video_release,
 	.unlocked_ioctl = video_ioctl2,
 };
@@ -1591,6 +1593,8 @@ static const struct v4l2_ioctl_ops radio_ioctl_ops = {
 	.vidioc_s_tuner       = radio_s_tuner,
 	.vidioc_g_frequency   = vidioc_g_frequency,
 	.vidioc_s_frequency   = vidioc_s_frequency,
+	.vidioc_subscribe_event      = v4l2_ctrl_subscribe_event,
+	.vidioc_unsubscribe_event    = v4l2_event_unsubscribe,
 #ifdef CONFIG_VIDEO_ADV_DEBUG
 	.vidioc_g_register    = vidioc_g_register,
 	.vidioc_s_register    = vidioc_s_register,
-- 
1.7.10

