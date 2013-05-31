Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr10.xs4all.nl ([194.109.24.30]:1640 "EHLO
	smtp-vbr10.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753229Ab3EaKNN (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 31 May 2013 06:13:13 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>,
	Ondrej Zary <linux@rainbow-software.org>
Subject: [PATCH 21/21] radio-sf16fmi: add control event and prio support.
Date: Fri, 31 May 2013 12:02:41 +0200
Message-Id: <1369994561-25236-22-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1369994561-25236-1-git-send-email-hverkuil@xs4all.nl>
References: <1369994561-25236-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
Cc: Ondrej Zary <linux@rainbow-software.org>
---
 drivers/media/radio/radio-sf16fmi.c |    8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/media/radio/radio-sf16fmi.c b/drivers/media/radio/radio-sf16fmi.c
index b058f36..9e712c8 100644
--- a/drivers/media/radio/radio-sf16fmi.c
+++ b/drivers/media/radio/radio-sf16fmi.c
@@ -28,6 +28,7 @@
 #include <media/v4l2-device.h>
 #include <media/v4l2-ioctl.h>
 #include <media/v4l2-ctrls.h>
+#include <media/v4l2-event.h>
 #include "lm7000.h"
 
 MODULE_AUTHOR("Petr Vandrovec, vandrove@vc.cvut.cz and M. Kirkwood");
@@ -202,6 +203,9 @@ static const struct v4l2_ctrl_ops fmi_ctrl_ops = {
 
 static const struct v4l2_file_operations fmi_fops = {
 	.owner		= THIS_MODULE,
+	.open		= v4l2_fh_open,
+	.release	= v4l2_fh_release,
+	.poll		= v4l2_ctrl_poll,
 	.unlocked_ioctl	= video_ioctl2,
 };
 
@@ -211,6 +215,9 @@ static const struct v4l2_ioctl_ops fmi_ioctl_ops = {
 	.vidioc_s_tuner     = vidioc_s_tuner,
 	.vidioc_g_frequency = vidioc_g_frequency,
 	.vidioc_s_frequency = vidioc_s_frequency,
+	.vidioc_log_status  = v4l2_ctrl_log_status,
+	.vidioc_subscribe_event = v4l2_ctrl_subscribe_event,
+	.vidioc_unsubscribe_event = v4l2_event_unsubscribe,
 };
 
 /* ladis: this is my card. does any other types exist? */
@@ -330,6 +337,7 @@ static int __init fmi_init(void)
 	fmi->vdev.fops = &fmi_fops;
 	fmi->vdev.ioctl_ops = &fmi_ioctl_ops;
 	fmi->vdev.release = video_device_release_empty;
+	set_bit(V4L2_FL_USE_FH_PRIO, &fmi->vdev.flags);
 	video_set_drvdata(&fmi->vdev, fmi);
 
 	mutex_init(&fmi->lock);
-- 
1.7.10.4

