Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr11.xs4all.nl ([194.109.24.31]:3106 "EHLO
	smtp-vbr11.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753333Ab3EaKDS (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 31 May 2013 06:03:18 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>,
	Fabio Belavenuto <belavenuto@gmail.com>
Subject: [PATCH 09/21] radio-tea5764: add prio and control event support.
Date: Fri, 31 May 2013 12:02:29 +0200
Message-Id: <1369994561-25236-10-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1369994561-25236-1-git-send-email-hverkuil@xs4all.nl>
References: <1369994561-25236-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
Cc: Fabio Belavenuto <belavenuto@gmail.com>
---
 drivers/media/radio/radio-tea5764.c |    8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/media/radio/radio-tea5764.c b/drivers/media/radio/radio-tea5764.c
index 077d906..c22feed 100644
--- a/drivers/media/radio/radio-tea5764.c
+++ b/drivers/media/radio/radio-tea5764.c
@@ -41,6 +41,7 @@
 #include <media/v4l2-ioctl.h>
 #include <media/v4l2-device.h>
 #include <media/v4l2-ctrls.h>
+#include <media/v4l2-event.h>
 
 #define DRIVER_VERSION	"0.0.2"
 
@@ -397,6 +398,9 @@ static const struct v4l2_ctrl_ops tea5764_ctrl_ops = {
 /* File system interface */
 static const struct v4l2_file_operations tea5764_fops = {
 	.owner		= THIS_MODULE,
+	.open		= v4l2_fh_open,
+	.release	= v4l2_fh_release,
+	.poll		= v4l2_ctrl_poll,
 	.unlocked_ioctl	= video_ioctl2,
 };
 
@@ -406,6 +410,9 @@ static const struct v4l2_ioctl_ops tea5764_ioctl_ops = {
 	.vidioc_s_tuner     = vidioc_s_tuner,
 	.vidioc_g_frequency = vidioc_g_frequency,
 	.vidioc_s_frequency = vidioc_s_frequency,
+	.vidioc_log_status  = v4l2_ctrl_log_status,
+	.vidioc_subscribe_event = v4l2_ctrl_subscribe_event,
+	.vidioc_unsubscribe_event = v4l2_event_unsubscribe,
 };
 
 /* V4L2 interface */
@@ -469,6 +476,7 @@ static int tea5764_i2c_probe(struct i2c_client *client,
 	video_set_drvdata(&radio->vdev, radio);
 	radio->vdev.lock = &radio->mutex;
 	radio->vdev.v4l2_dev = v4l2_dev;
+	set_bit(V4L2_FL_USE_FH_PRIO, &radio->vdev.flags);
 
 	/* initialize and power off the chip */
 	tea5764_i2c_read(radio);
-- 
1.7.10.4

