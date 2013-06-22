Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr13.xs4all.nl ([194.109.24.33]:2737 "EHLO
	smtp-vbr13.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754735Ab3FVKHM (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 22 Jun 2013 06:07:12 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Manjunatha Halli <manjunatha_halli@ti.com>,
	Fengguang Wu <fengguang.wu@intel.com>,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [RFC PATCH 6/6] wl128x: enable control events.
Date: Sat, 22 Jun 2013 12:06:55 +0200
Message-Id: <1371895615-14162-7-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1371895615-14162-1-git-send-email-hverkuil@xs4all.nl>
References: <1371895615-14162-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/radio/wl128x/fmdrv_v4l2.c | 10 +++++++---
 drivers/media/radio/wl128x/fmdrv_v4l2.h |  1 +
 2 files changed, 8 insertions(+), 3 deletions(-)

diff --git a/drivers/media/radio/wl128x/fmdrv_v4l2.c b/drivers/media/radio/wl128x/fmdrv_v4l2.c
index 6566364..4955b88 100644
--- a/drivers/media/radio/wl128x/fmdrv_v4l2.c
+++ b/drivers/media/radio/wl128x/fmdrv_v4l2.c
@@ -105,15 +105,16 @@ static u32 fm_v4l2_fops_poll(struct file *file, struct poll_table_struct *pts)
 {
 	int ret;
 	struct fmdev *fmdev;
+	u32 rc = v4l2_ctrl_poll(file, pts);
 
 	fmdev = video_drvdata(file);
 	mutex_lock(&fmdev->mutex);
 	ret = fmc_is_rds_data_available(fmdev, file, pts);
 	mutex_unlock(&fmdev->mutex);
 	if (ret < 0)
-		return POLLIN | POLLRDNORM;
+		return rc | POLLIN | POLLRDNORM;
 
-	return 0;
+	return rc;
 }
 
 /*
@@ -480,7 +481,10 @@ static const struct v4l2_ioctl_ops fm_drv_ioctl_ops = {
 	.vidioc_s_frequency = fm_v4l2_vidioc_s_freq,
 	.vidioc_s_hw_freq_seek = fm_v4l2_vidioc_s_hw_freq_seek,
 	.vidioc_g_modulator = fm_v4l2_vidioc_g_modulator,
-	.vidioc_s_modulator = fm_v4l2_vidioc_s_modulator
+	.vidioc_s_modulator = fm_v4l2_vidioc_s_modulator,
+	.vidioc_log_status = v4l2_ctrl_log_status,
+	.vidioc_subscribe_event = v4l2_ctrl_subscribe_event,
+	.vidioc_unsubscribe_event = v4l2_event_unsubscribe,
 };
 
 /* V4L2 RADIO device parent structure */
diff --git a/drivers/media/radio/wl128x/fmdrv_v4l2.h b/drivers/media/radio/wl128x/fmdrv_v4l2.h
index 66d6f3e..9874660 100644
--- a/drivers/media/radio/wl128x/fmdrv_v4l2.h
+++ b/drivers/media/radio/wl128x/fmdrv_v4l2.h
@@ -27,6 +27,7 @@
 #include <media/v4l2-common.h>
 #include <media/v4l2-ctrls.h>
 #include <media/v4l2-fh.h>
+#include <media/v4l2-event.h>
 
 int fm_v4l2_init_video_device(struct fmdev *, int);
 void *fm_v4l2_deinit_video_device(void);
-- 
1.8.3.1

