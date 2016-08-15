Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp11.smtpout.orange.fr ([80.12.242.133]:39383 "EHLO
	smtp.smtpout.orange.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753004AbcHOTCU (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 15 Aug 2016 15:02:20 -0400
From: Robert Jarzmik <robert.jarzmik@free.fr>
To: Mauro Carvalho Chehab <mchehab@kernel.org>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Jiri Kosina <trivial@kernel.org>,
	Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
	Robert Jarzmik <robert.jarzmik@free.fr>
Subject: [PATCH v4 09/13] media: platform: pxa_camera: remove set_crop
Date: Mon, 15 Aug 2016 21:01:59 +0200
Message-Id: <1471287723-25451-10-git-send-email-robert.jarzmik@free.fr>
In-Reply-To: <1471287723-25451-1-git-send-email-robert.jarzmik@free.fr>
References: <1471287723-25451-1-git-send-email-robert.jarzmik@free.fr>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is to be seen as a regression as the set_crop function is
removed. This is a temporary situation in the v4l2 porting, and will
have to be added later.

Signed-off-by: Robert Jarzmik <robert.jarzmik@free.fr>
---
 drivers/media/platform/soc_camera/pxa_camera.c | 76 --------------------------
 1 file changed, 76 deletions(-)

diff --git a/drivers/media/platform/soc_camera/pxa_camera.c b/drivers/media/platform/soc_camera/pxa_camera.c
index 2471d036a835..a2fedc9bb71c 100644
--- a/drivers/media/platform/soc_camera/pxa_camera.c
+++ b/drivers/media/platform/soc_camera/pxa_camera.c
@@ -1295,81 +1295,6 @@ static int pxa_camera_check_frame(u32 width, u32 height)
 		(width & 0x01);
 }
 
-static int pxa_camera_set_crop(struct soc_camera_device *icd,
-			       const struct v4l2_crop *a)
-{
-	const struct v4l2_rect *rect = &a->c;
-	struct device *dev = icd->parent;
-	struct soc_camera_host *ici = to_soc_camera_host(dev);
-	struct pxa_camera_dev *pcdev = ici->priv;
-	struct v4l2_subdev *sd = soc_camera_to_subdev(icd);
-	struct soc_camera_sense sense = {
-		.master_clock = pcdev->mclk,
-		.pixel_clock_max = pcdev->ciclk / 4,
-	};
-	struct v4l2_subdev_format fmt = {
-		.which = V4L2_SUBDEV_FORMAT_ACTIVE,
-	};
-	struct v4l2_mbus_framefmt *mf = &fmt.format;
-	struct pxa_cam *cam = icd->host_priv;
-	u32 fourcc = icd->current_fmt->host_fmt->fourcc;
-	int ret;
-
-	/* If PCLK is used to latch data from the sensor, check sense */
-	if (pcdev->platform_flags & PXA_CAMERA_PCLK_EN)
-		icd->sense = &sense;
-
-	ret = sensor_call(pcdev, video, s_crop, a);
-
-	icd->sense = NULL;
-
-	if (ret < 0) {
-		dev_warn(pcdev_to_dev(pcdev), "Failed to crop to %ux%u@%u:%u\n",
-			 rect->width, rect->height, rect->left, rect->top);
-		return ret;
-	}
-
-	ret = sensor_call(pcdev, pad, get_fmt, NULL, &fmt);
-	if (ret < 0)
-		return ret;
-
-	if (pxa_camera_check_frame(mf->width, mf->height)) {
-		/*
-		 * Camera cropping produced a frame beyond our capabilities.
-		 * FIXME: just extract a subframe, that we can process.
-		 */
-		v4l_bound_align_image(&mf->width, 48, 2048, 1,
-			&mf->height, 32, 2048, 0,
-			fourcc == V4L2_PIX_FMT_YUV422P ? 4 : 0);
-		ret = sensor_call(pcdev, pad, set_fmt, NULL, &fmt);
-		if (ret < 0)
-			return ret;
-
-		if (pxa_camera_check_frame(mf->width, mf->height)) {
-			dev_warn(pcdev_to_dev(pcdev),
-				 "Inconsistent state. Use S_FMT to repair\n");
-			return -EINVAL;
-		}
-	}
-
-	if (sense.flags & SOCAM_SENSE_PCLK_CHANGED) {
-		if (sense.pixel_clock > sense.pixel_clock_max) {
-			dev_err(pcdev_to_dev(pcdev),
-				"pixel clock %lu set by the camera too high!",
-				sense.pixel_clock);
-			return -EIO;
-		}
-		recalculate_fifo_timeout(pcdev, sense.pixel_clock);
-	}
-
-	icd->user_width		= mf->width;
-	icd->user_height	= mf->height;
-
-	pxa_camera_setup_cicr(icd, cam->flags, fourcc);
-
-	return ret;
-}
-
 static int pxa_camera_set_fmt(struct soc_camera_device *icd,
 			      struct v4l2_format *f)
 {
@@ -1582,7 +1507,6 @@ static struct soc_camera_host_ops pxa_soc_camera_host_ops = {
 	.remove		= pxa_camera_remove_device,
 	.clock_start	= pxa_camera_clock_start,
 	.clock_stop	= pxa_camera_clock_stop,
-	.set_crop	= pxa_camera_set_crop,
 	.get_formats	= pxa_camera_get_formats,
 	.put_formats	= pxa_camera_put_formats,
 	.set_fmt	= pxa_camera_set_fmt,
-- 
2.1.4

