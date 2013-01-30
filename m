Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr5.xs4all.nl ([194.109.24.25]:3797 "EHLO
	smtp-vbr5.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752478Ab3A3OyZ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 30 Jan 2013 09:54:25 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Ondrej Zary <linux@rainbow-software.org>,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [RFC PATCH 4/6] radio-miropcm20: add prio and control event support.
Date: Wed, 30 Jan 2013 15:54:02 +0100
Message-Id: <77cefca73dd889289e2e06145eaccba56561cbbe.1359557431.git.hans.verkuil@cisco.com>
In-Reply-To: <1359557644-10982-1-git-send-email-hverkuil@xs4all.nl>
References: <1359557644-10982-1-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <6fc0e0fabcd9ccf60c95ed5cd9c7a08834b43f9b.1359557431.git.hans.verkuil@cisco.com>
References: <6fc0e0fabcd9ccf60c95ed5cd9c7a08834b43f9b.1359557431.git.hans.verkuil@cisco.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/radio/radio-miropcm20.c |    9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/drivers/media/radio/radio-miropcm20.c b/drivers/media/radio/radio-miropcm20.c
index 061ebcf..4ac813c 100644
--- a/drivers/media/radio/radio-miropcm20.c
+++ b/drivers/media/radio/radio-miropcm20.c
@@ -18,6 +18,8 @@
 #include <media/v4l2-device.h>
 #include <media/v4l2-ioctl.h>
 #include <media/v4l2-ctrls.h>
+#include <media/v4l2-fh.h>
+#include <media/v4l2-event.h>
 #include <sound/aci.h>
 
 static int radio_nr = -1;
@@ -75,6 +77,9 @@ static int pcm20_setfreq(struct pcm20 *dev, unsigned long freq)
 
 static const struct v4l2_file_operations pcm20_fops = {
 	.owner		= THIS_MODULE,
+	.open		= v4l2_fh_open,
+	.poll		= v4l2_ctrl_poll,
+	.release	= v4l2_fh_release,
 	.unlocked_ioctl	= video_ioctl2,
 };
 
@@ -158,6 +163,9 @@ static const struct v4l2_ioctl_ops pcm20_ioctl_ops = {
 	.vidioc_s_tuner     = vidioc_s_tuner,
 	.vidioc_g_frequency = vidioc_g_frequency,
 	.vidioc_s_frequency = vidioc_s_frequency,
+	.vidioc_log_status  = v4l2_ctrl_log_status,
+	.vidioc_subscribe_event = v4l2_ctrl_subscribe_event,
+	.vidioc_unsubscribe_event = v4l2_event_unsubscribe,
 };
 
 static const struct v4l2_ctrl_ops pcm20_ctrl_ops = {
@@ -202,6 +210,7 @@ static int __init pcm20_init(void)
 	dev->vdev.ioctl_ops = &pcm20_ioctl_ops;
 	dev->vdev.release = video_device_release_empty;
 	dev->vdev.lock = &dev->lock;
+	set_bit(V4L2_FL_USE_FH_PRIO, &dev->vdev.flags);
 	video_set_drvdata(&dev->vdev, dev);
 
 	if (video_register_device(&dev->vdev, VFL_TYPE_RADIO, radio_nr) < 0)
-- 
1.7.10.4

