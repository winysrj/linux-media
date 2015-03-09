Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud6.xs4all.net ([194.109.24.24]:39460 "EHLO
	lb1-smtp-cloud6.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753023AbbCIQgM (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 9 Mar 2015 12:36:12 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCH 13/19] wl128x: embed video_device
Date: Mon,  9 Mar 2015 17:34:07 +0100
Message-Id: <1425918853-12371-14-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1425918853-12371-1-git-send-email-hverkuil@xs4all.nl>
References: <1425918853-12371-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Embed the video_device struct to simplify the error handling and in
order to (eventually) get rid of video_device_alloc/release.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/radio/wl128x/fmdrv_v4l2.c | 28 ++++++++++------------------
 1 file changed, 10 insertions(+), 18 deletions(-)

diff --git a/drivers/media/radio/wl128x/fmdrv_v4l2.c b/drivers/media/radio/wl128x/fmdrv_v4l2.c
index a5bd3f6..fb42f0f 100644
--- a/drivers/media/radio/wl128x/fmdrv_v4l2.c
+++ b/drivers/media/radio/wl128x/fmdrv_v4l2.c
@@ -36,7 +36,7 @@
 #include "fmdrv_rx.h"
 #include "fmdrv_tx.h"
 
-static struct video_device *gradio_dev;
+static struct video_device gradio_dev;
 static u8 radio_disconnected;
 
 /* -- V4L2 RADIO (/dev/radioX) device file operation interfaces --- */
@@ -517,7 +517,7 @@ static struct video_device fm_viddev_template = {
 	.fops = &fm_drv_fops,
 	.ioctl_ops = &fm_drv_ioctl_ops,
 	.name = FM_DRV_NAME,
-	.release = video_device_release,
+	.release = video_device_release_empty,
 	/*
 	 * To ensure both the tuner and modulator ioctls are accessible we
 	 * set the vfl_dir to M2M to indicate this.
@@ -543,29 +543,21 @@ int fm_v4l2_init_video_device(struct fmdev *fmdev, int radio_nr)
 	/* Init mutex for core locking */
 	mutex_init(&fmdev->mutex);
 
-	/* Allocate new video device */
-	gradio_dev = video_device_alloc();
-	if (NULL == gradio_dev) {
-		fmerr("Can't allocate video device\n");
-		return -ENOMEM;
-	}
-
 	/* Setup FM driver's V4L2 properties */
-	memcpy(gradio_dev, &fm_viddev_template, sizeof(fm_viddev_template));
+	gradio_dev = fm_viddev_template;
 
-	video_set_drvdata(gradio_dev, fmdev);
+	video_set_drvdata(&gradio_dev, fmdev);
 
-	gradio_dev->lock = &fmdev->mutex;
-	gradio_dev->v4l2_dev = &fmdev->v4l2_dev;
+	gradio_dev.lock = &fmdev->mutex;
+	gradio_dev.v4l2_dev = &fmdev->v4l2_dev;
 
 	/* Register with V4L2 subsystem as RADIO device */
-	if (video_register_device(gradio_dev, VFL_TYPE_RADIO, radio_nr)) {
-		video_device_release(gradio_dev);
+	if (video_register_device(&gradio_dev, VFL_TYPE_RADIO, radio_nr)) {
 		fmerr("Could not register video device\n");
 		return -ENOMEM;
 	}
 
-	fmdev->radio_dev = gradio_dev;
+	fmdev->radio_dev = &gradio_dev;
 
 	/* Register to v4l2 ctrl handler framework */
 	fmdev->radio_dev->ctrl_handler = &fmdev->ctrl_handler;
@@ -611,13 +603,13 @@ void *fm_v4l2_deinit_video_device(void)
 	struct fmdev *fmdev;
 
 
-	fmdev = video_get_drvdata(gradio_dev);
+	fmdev = video_get_drvdata(&gradio_dev);
 
 	/* Unregister to v4l2 ctrl handler framework*/
 	v4l2_ctrl_handler_free(&fmdev->ctrl_handler);
 
 	/* Unregister RADIO device from V4L2 subsystem */
-	video_unregister_device(gradio_dev);
+	video_unregister_device(&gradio_dev);
 
 	v4l2_device_unregister(&fmdev->v4l2_dev);
 
-- 
2.1.4

