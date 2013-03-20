Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr1.xs4all.nl ([194.109.24.21]:2011 "EHLO
	smtp-vbr1.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751381Ab3CTSjS (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 20 Mar 2013 14:39:18 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Janne Grunau <j@jannau.net>, Hans Verkuil <hans.verkuil@cisco.com>
Subject: [REVIEW PATCH 05/11] hdpvr: add prio and control event support.
Date: Wed, 20 Mar 2013 19:38:56 +0100
Message-Id: <1363804742-5355-6-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1363804742-5355-1-git-send-email-hverkuil@xs4all.nl>
References: <1363804742-5355-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/usb/hdpvr/hdpvr-video.c |   20 ++++++++++++--------
 1 file changed, 12 insertions(+), 8 deletions(-)

diff --git a/drivers/media/usb/hdpvr/hdpvr-video.c b/drivers/media/usb/hdpvr/hdpvr-video.c
index 873bb23..789d808 100644
--- a/drivers/media/usb/hdpvr/hdpvr-video.c
+++ b/drivers/media/usb/hdpvr/hdpvr-video.c
@@ -23,6 +23,7 @@
 #include <media/v4l2-dev.h>
 #include <media/v4l2-common.h>
 #include <media/v4l2-ioctl.h>
+#include <media/v4l2-event.h>
 #include "hdpvr.h"
 
 #define BULK_URB_TIMEOUT   90 /* 0.09 seconds */
@@ -478,16 +479,15 @@ err:
 
 static unsigned int hdpvr_poll(struct file *filp, poll_table *wait)
 {
+	unsigned long req_events = poll_requested_events(wait);
 	struct hdpvr_buffer *buf = NULL;
 	struct hdpvr_device *dev = video_drvdata(filp);
-	unsigned int mask = 0;
+	unsigned int mask = v4l2_ctrl_poll(filp, wait);
 
-	mutex_lock(&dev->io_mutex);
+	if (!(req_events & (POLLIN | POLLRDNORM)))
+		return mask;
 
-	if (!video_is_registered(dev->video_dev)) {
-		mutex_unlock(&dev->io_mutex);
-		return -EIO;
-	}
+	mutex_lock(&dev->io_mutex);
 
 	if (dev->status == STATUS_IDLE) {
 		if (hdpvr_start_streaming(dev)) {
@@ -878,10 +878,13 @@ static const struct v4l2_ioctl_ops hdpvr_ioctl_ops = {
 	.vidioc_enumaudio	= vidioc_enumaudio,
 	.vidioc_g_audio		= vidioc_g_audio,
 	.vidioc_s_audio		= vidioc_s_audio,
-	.vidioc_enum_fmt_vid_cap	= vidioc_enum_fmt_vid_cap,
-	.vidioc_g_fmt_vid_cap		= vidioc_g_fmt_vid_cap,
+	.vidioc_enum_fmt_vid_cap= vidioc_enum_fmt_vid_cap,
+	.vidioc_g_fmt_vid_cap	= vidioc_g_fmt_vid_cap,
 	.vidioc_encoder_cmd	= vidioc_encoder_cmd,
 	.vidioc_try_encoder_cmd	= vidioc_try_encoder_cmd,
+	.vidioc_log_status	= v4l2_ctrl_log_status,
+	.vidioc_subscribe_event = v4l2_ctrl_subscribe_event,
+	.vidioc_unsubscribe_event = v4l2_event_unsubscribe,
 };
 
 static void hdpvr_device_release(struct video_device *vdev)
@@ -1006,6 +1009,7 @@ int hdpvr_register_videodev(struct hdpvr_device *dev, struct device *parent,
 	strcpy(dev->video_dev->name, "Hauppauge HD PVR");
 	dev->video_dev->v4l2_dev = &dev->v4l2_dev;
 	video_set_drvdata(dev->video_dev, dev);
+	set_bit(V4L2_FL_USE_FH_PRIO, &dev->video_dev->flags);
 
 	res = video_register_device(dev->video_dev, VFL_TYPE_GRABBER, devnum);
 	if (res < 0) {
-- 
1.7.10.4

