Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr14.xs4all.nl ([194.109.24.34]:4681 "EHLO
	smtp-vbr14.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932251Ab3FVKPH (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 22 Jun 2013 06:15:07 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Manjunatha Halli <manjunatha_halli@ti.com>,
	Fengguang Wu <fengguang.wu@intel.com>,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [RFC PATCH 5/6] wl128x: call video_register_device last, enable prio handling
Date: Sat, 22 Jun 2013 12:06:54 +0200
Message-Id: <1371895615-14162-6-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1371895615-14162-1-git-send-email-hverkuil@xs4all.nl>
References: <1371895615-14162-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

video_register_device must be called last.

This patch also sets the prio flag, allowing the core to handle priorities.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/radio/wl128x/fmdrv_v4l2.c | 39 +++++++++++++++++++--------------
 1 file changed, 23 insertions(+), 16 deletions(-)

diff --git a/drivers/media/radio/wl128x/fmdrv_v4l2.c b/drivers/media/radio/wl128x/fmdrv_v4l2.c
index 337068d..6566364 100644
--- a/drivers/media/radio/wl128x/fmdrv_v4l2.c
+++ b/drivers/media/radio/wl128x/fmdrv_v4l2.c
@@ -518,35 +518,25 @@ int fm_v4l2_init_video_device(struct fmdev *fmdev, int radio_nr)
 	gradio_dev = video_device_alloc();
 	if (NULL == gradio_dev) {
 		fmerr("Can't allocate video device\n");
-		return -ENOMEM;
+		ret = -ENOMEM;
+		goto unreg_v4l2;
 	}
 
 	/* Setup FM driver's V4L2 properties */
-	memcpy(gradio_dev, &fm_viddev_template, sizeof(fm_viddev_template));
+	*gradio_dev = fm_viddev_template;
 
 	video_set_drvdata(gradio_dev, fmdev);
 
 	gradio_dev->lock = &fmdev->mutex;
 	gradio_dev->v4l2_dev = &fmdev->v4l2_dev;
-
-	/* Register with V4L2 subsystem as RADIO device */
-	if (video_register_device(gradio_dev, VFL_TYPE_RADIO, radio_nr)) {
-		video_device_release(gradio_dev);
-		fmerr("Could not register video device\n");
-		return -ENOMEM;
-	}
+	set_bit(V4L2_FL_USE_FH_PRIO, &gradio_dev->flags);
 
 	fmdev->radio_dev = gradio_dev;
 
 	/* Register to v4l2 ctrl handler framework */
 	fmdev->radio_dev->ctrl_handler = &fmdev->ctrl_handler;
 
-	ret = v4l2_ctrl_handler_init(&fmdev->ctrl_handler, 5);
-	if (ret < 0) {
-		fmerr("(fmdev): Can't init ctrl handler\n");
-		v4l2_ctrl_handler_free(&fmdev->ctrl_handler);
-		return -EBUSY;
-	}
+	v4l2_ctrl_handler_init(&fmdev->ctrl_handler, 5);
 
 	/*
 	 * Following controls are handled by V4L2 control framework.
@@ -573,15 +563,32 @@ int fm_v4l2_init_video_device(struct fmdev *fmdev, int radio_nr)
 
 	if (ctrl)
 		ctrl->flags |= V4L2_CTRL_FLAG_VOLATILE;
+	ret = fmdev->ctrl_handler.error;
+	if (ret < 0) {
+		fmerr("(fmdev): Can't init ctrl handler\n");
+		goto free_hdl;
+	}
 
+	/* Register with V4L2 subsystem as RADIO device */
+	ret = video_register_device(gradio_dev, VFL_TYPE_RADIO, radio_nr);
+	if (ret < 0) {
+		fmerr("Could not register video device\n");
+		goto free_hdl;
+	}
 	return 0;
+
+free_hdl:
+	v4l2_ctrl_handler_free(&fmdev->ctrl_handler);
+	video_device_release(gradio_dev);
+unreg_v4l2:
+	v4l2_device_unregister(&fmdev->v4l2_dev);
+	return ret;
 }
 
 void *fm_v4l2_deinit_video_device(void)
 {
 	struct fmdev *fmdev;
 
-
 	fmdev = video_get_drvdata(gradio_dev);
 
 	/* Unregister to v4l2 ctrl handler framework*/
-- 
1.8.3.1

