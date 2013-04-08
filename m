Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr8.xs4all.nl ([194.109.24.28]:2155 "EHLO
	smtp-vbr8.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935376Ab3DHKsD (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 8 Apr 2013 06:48:03 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Eduardo Valentin <edubezval@gmail.com>,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [REVIEW PATCH 7/7] radio-si4713: add prio checking and control events.
Date: Mon,  8 Apr 2013 12:47:41 +0200
Message-Id: <1365418061-23694-8-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1365418061-23694-1-git-send-email-hverkuil@xs4all.nl>
References: <1365418061-23694-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/radio/radio-si4713.c |   10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/drivers/media/radio/radio-si4713.c b/drivers/media/radio/radio-si4713.c
index f8c6137..ba4cfc9 100644
--- a/drivers/media/radio/radio-si4713.c
+++ b/drivers/media/radio/radio-si4713.c
@@ -31,6 +31,9 @@
 #include <media/v4l2-device.h>
 #include <media/v4l2-common.h>
 #include <media/v4l2-ioctl.h>
+#include <media/v4l2-fh.h>
+#include <media/v4l2-ctrls.h>
+#include <media/v4l2-event.h>
 #include <media/radio-si4713.h>
 
 /* module parameters */
@@ -55,6 +58,9 @@ struct radio_si4713_device {
 /* radio_si4713_fops - file operations interface */
 static const struct v4l2_file_operations radio_si4713_fops = {
 	.owner		= THIS_MODULE,
+	.open = v4l2_fh_open,
+	.release = v4l2_fh_release,
+	.poll = v4l2_ctrl_poll,
 	/* Note: locking is done at the subdev level in the i2c driver. */
 	.unlocked_ioctl	= video_ioctl2,
 };
@@ -126,6 +132,9 @@ static struct v4l2_ioctl_ops radio_si4713_ioctl_ops = {
 	.vidioc_s_modulator	= radio_si4713_s_modulator,
 	.vidioc_g_frequency	= radio_si4713_g_frequency,
 	.vidioc_s_frequency	= radio_si4713_s_frequency,
+	.vidioc_log_status      = v4l2_ctrl_log_status,
+	.vidioc_subscribe_event = v4l2_ctrl_subscribe_event,
+	.vidioc_unsubscribe_event = v4l2_event_unsubscribe,
 	.vidioc_default		= radio_si4713_default,
 };
 
@@ -187,6 +196,7 @@ static int radio_si4713_pdriver_probe(struct platform_device *pdev)
 	rsdev->radio_dev = radio_si4713_vdev_template;
 	rsdev->radio_dev.v4l2_dev = &rsdev->v4l2_dev;
 	rsdev->radio_dev.ctrl_handler = sd->ctrl_handler;
+	set_bit(V4L2_FL_USE_FH_PRIO, &rsdev->radio_dev.flags);
 	/* Serialize all access to the si4713 */
 	rsdev->radio_dev.lock = &rsdev->lock;
 	video_set_drvdata(&rsdev->radio_dev, rsdev);
-- 
1.7.10.4

