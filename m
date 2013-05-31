Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr10.xs4all.nl ([194.109.24.30]:3617 "EHLO
	smtp-vbr10.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753448Ab3EaKDU (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 31 May 2013 06:03:20 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>,
	=?UTF-8?q?Richard=20R=C3=B6jfors?= <richard.rojfors@pelagicore.com>
Subject: [PATCH 14/21] radio-timb: add control events and prio support.
Date: Fri, 31 May 2013 12:02:34 +0200
Message-Id: <1369994561-25236-15-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1369994561-25236-1-git-send-email-hverkuil@xs4all.nl>
References: <1369994561-25236-1-git-send-email-hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
Cc: Richard Röjfors <richard.rojfors@pelagicore.com>
---
 drivers/media/radio/radio-timb.c |    9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/drivers/media/radio/radio-timb.c b/drivers/media/radio/radio-timb.c
index 1931ef7..0817964 100644
--- a/drivers/media/radio/radio-timb.c
+++ b/drivers/media/radio/radio-timb.c
@@ -19,6 +19,8 @@
 #include <linux/io.h>
 #include <media/v4l2-ioctl.h>
 #include <media/v4l2-device.h>
+#include <media/v4l2-ctrls.h>
+#include <media/v4l2-event.h>
 #include <linux/platform_device.h>
 #include <linux/interrupt.h>
 #include <linux/slab.h>
@@ -83,10 +85,16 @@ static const struct v4l2_ioctl_ops timbradio_ioctl_ops = {
 	.vidioc_s_tuner		= timbradio_vidioc_s_tuner,
 	.vidioc_g_frequency	= timbradio_vidioc_g_frequency,
 	.vidioc_s_frequency	= timbradio_vidioc_s_frequency,
+	.vidioc_log_status      = v4l2_ctrl_log_status,
+	.vidioc_subscribe_event = v4l2_ctrl_subscribe_event,
+	.vidioc_unsubscribe_event = v4l2_event_unsubscribe,
 };
 
 static const struct v4l2_file_operations timbradio_fops = {
 	.owner		= THIS_MODULE,
+	.open		= v4l2_fh_open,
+	.release	= v4l2_fh_release,
+	.poll		= v4l2_ctrl_poll,
 	.unlocked_ioctl	= video_ioctl2,
 };
 
@@ -118,6 +126,7 @@ static int timbradio_probe(struct platform_device *pdev)
 	tr->video_dev.release = video_device_release_empty;
 	tr->video_dev.minor = -1;
 	tr->video_dev.lock = &tr->lock;
+	set_bit(V4L2_FL_USE_FH_PRIO, &tr->video_dev.flags);
 
 	strlcpy(tr->v4l2_dev.name, DRIVER_NAME, sizeof(tr->v4l2_dev.name));
 	err = v4l2_device_register(NULL, &tr->v4l2_dev);
-- 
1.7.10.4

