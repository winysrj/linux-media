Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr15.xs4all.nl ([194.109.24.35]:4228 "EHLO
	smtp-vbr15.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754586Ab3FVKHJ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 22 Jun 2013 06:07:09 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Manjunatha Halli <manjunatha_halli@ti.com>,
	Fengguang Wu <fengguang.wu@intel.com>,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [RFC PATCH 1/6] wl128x: add missing struct v4l2_device.
Date: Sat, 22 Jun 2013 12:06:50 +0200
Message-Id: <1371895615-14162-2-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1371895615-14162-1-git-send-email-hverkuil@xs4all.nl>
References: <1371895615-14162-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

This struct is now required for all video device nodes, but it was missing
in this driver.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/radio/wl128x/fmdrv.h      | 2 ++
 drivers/media/radio/wl128x/fmdrv_v4l2.c | 8 ++++++++
 2 files changed, 10 insertions(+)

diff --git a/drivers/media/radio/wl128x/fmdrv.h b/drivers/media/radio/wl128x/fmdrv.h
index aac0f02..a587c9b 100644
--- a/drivers/media/radio/wl128x/fmdrv.h
+++ b/drivers/media/radio/wl128x/fmdrv.h
@@ -30,6 +30,7 @@
 #include <linux/timer.h>
 #include <media/v4l2-ioctl.h>
 #include <media/v4l2-common.h>
+#include <media/v4l2-device.h>
 #include <media/v4l2-ctrls.h>
 
 #define FM_DRV_VERSION            "0.1.1"
@@ -202,6 +203,7 @@ struct fmtx_data {
 /* FM driver operation structure */
 struct fmdev {
 	struct video_device *radio_dev;	/* V4L2 video device pointer */
+	struct v4l2_device v4l2_dev;	/* V4L2 top level struct */
 	struct snd_card *card;	/* Card which holds FM mixer controls */
 	u16 asci_id;
 	spinlock_t rds_buff_lock; /* To protect access to RDS buffer */
diff --git a/drivers/media/radio/wl128x/fmdrv_v4l2.c b/drivers/media/radio/wl128x/fmdrv_v4l2.c
index 5dec323..b55012c 100644
--- a/drivers/media/radio/wl128x/fmdrv_v4l2.c
+++ b/drivers/media/radio/wl128x/fmdrv_v4l2.c
@@ -533,6 +533,11 @@ int fm_v4l2_init_video_device(struct fmdev *fmdev, int radio_nr)
 	struct v4l2_ctrl *ctrl;
 	int ret;
 
+	strlcpy(fmdev->v4l2_dev.name, FM_DRV_NAME, sizeof(fmdev->v4l2_dev.name));
+	ret = v4l2_device_register(NULL, &fmdev->v4l2_dev);
+	if (ret < 0)
+		return ret;
+
 	/* Init mutex for core locking */
 	mutex_init(&fmdev->mutex);
 
@@ -549,6 +554,7 @@ int fm_v4l2_init_video_device(struct fmdev *fmdev, int radio_nr)
 	video_set_drvdata(gradio_dev, fmdev);
 
 	gradio_dev->lock = &fmdev->mutex;
+	gradio_dev->v4l2_dev = &fmdev->v4l2_dev;
 
 	/* Register with V4L2 subsystem as RADIO device */
 	if (video_register_device(gradio_dev, VFL_TYPE_RADIO, radio_nr)) {
@@ -611,5 +617,7 @@ void *fm_v4l2_deinit_video_device(void)
 	/* Unregister RADIO device from V4L2 subsystem */
 	video_unregister_device(gradio_dev);
 
+	v4l2_device_unregister(&fmdev->v4l2_dev);
+
 	return fmdev;
 }
-- 
1.8.3.1

