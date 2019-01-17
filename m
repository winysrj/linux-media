Return-Path: <SRS0=I7H+=PZ=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 50FC7C43444
	for <linux-media@archiver.kernel.org>; Thu, 17 Jan 2019 16:18:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1612520855
	for <linux-media@archiver.kernel.org>; Thu, 17 Jan 2019 16:18:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728983AbfAQQSO (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Thu, 17 Jan 2019 11:18:14 -0500
Received: from lb1-smtp-cloud8.xs4all.net ([194.109.24.21]:36504 "EHLO
        lb1-smtp-cloud8.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728827AbfAQQSH (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 17 Jan 2019 11:18:07 -0500
Received: from marune.fritz.box ([IPv6:2001:983:e9a7:1:3849:86c5:b8c2:266c])
        by smtp-cloud8.xs4all.net with ESMTPA
        id kAMkgeAhPNR5ykAMngTv1I; Thu, 17 Jan 2019 17:18:05 +0100
From:   hverkuil-cisco@xs4all.nl
To:     linux-media@vger.kernel.org
Cc:     Jacopo Mondi <jacopo+renesas@jmondi.org>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>
Subject: [PATCH 7/8] soc_camera/soc_scale_crop: drop this unused code
Date:   Thu, 17 Jan 2019 17:18:01 +0100
Message-Id: <20190117161802.5740-8-hverkuil-cisco@xs4all.nl>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190117161802.5740-1-hverkuil-cisco@xs4all.nl>
References: <20190117161802.5740-1-hverkuil-cisco@xs4all.nl>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CMAE-Envelope: MS4wfNXVrFOTWLJKQxd/CmlGj4OfRj1lc0E0SZWeAKQVbsOP5Be0+ePytfdnAu94IDQqeF2rm5ofTyfB53f7u0nnqFiSPZcf1qK1DH7C2W2mlVbwoek6SAcy
 HeLx4ckB8FZP/w0OMW3/pS7oIqhdHjoS8FsgbEY5b3pqytVq9jucFtM82tXxQ5YaK26w9IXkNBuy69ApCieWIqjVjAcdGSAlzkL2QqGfr9DhEOf4IyZLqTlX
 5/Alh2c7N/4Xp0p4cZ2nf999H0CQgW3ZW1fzRQQtwlgcKEalOQxmTksyfjjvefltSPSYLCtPxcgdLNy0GYchPLOwwZ/iLRkhG2Ycmt0NXlVSZdeNiH21qiLY
 DEIhc2rbLbdmgyPPUQy9GsDumMipYQ==
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

From: Hans Verkuil <hverkuil-cisco@xs4all.nl>

With the removal of sh_mobile_ceu_camera.c this code is no
longer used and can be removed.

Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
---
 drivers/media/platform/soc_camera/Kconfig     |   3 -
 drivers/media/platform/soc_camera/Makefile    |   1 -
 .../platform/soc_camera/soc_scale_crop.c      | 426 ------------------
 .../platform/soc_camera/soc_scale_crop.h      |  47 --
 4 files changed, 477 deletions(-)
 delete mode 100644 drivers/media/platform/soc_camera/soc_scale_crop.c
 delete mode 100644 drivers/media/platform/soc_camera/soc_scale_crop.h

diff --git a/drivers/media/platform/soc_camera/Kconfig b/drivers/media/platform/soc_camera/Kconfig
index 94907d0611d6..d471d34b884c 100644
--- a/drivers/media/platform/soc_camera/Kconfig
+++ b/drivers/media/platform/soc_camera/Kconfig
@@ -7,9 +7,6 @@ config SOC_CAMERA
 	  over a bus like PCI or USB. For example some i2c camera connected
 	  directly to the data bus of an SoC.
 
-config SOC_CAMERA_SCALE_CROP
-	tristate
-
 config SOC_CAMERA_PLATFORM
 	tristate "platform camera support"
 	depends on SOC_CAMERA
diff --git a/drivers/media/platform/soc_camera/Makefile b/drivers/media/platform/soc_camera/Makefile
index aa4b855a0882..2cb7022e073b 100644
--- a/drivers/media/platform/soc_camera/Makefile
+++ b/drivers/media/platform/soc_camera/Makefile
@@ -1,5 +1,4 @@
 obj-$(CONFIG_SOC_CAMERA)		+= soc_camera.o soc_mediabus.o
-obj-$(CONFIG_SOC_CAMERA_SCALE_CROP)	+= soc_scale_crop.o
 
 # a platform subdevice driver stub, allowing to support cameras by adding a
 # couple of callback functions to the board code
diff --git a/drivers/media/platform/soc_camera/soc_scale_crop.c b/drivers/media/platform/soc_camera/soc_scale_crop.c
deleted file mode 100644
index 8d25ca0490f7..000000000000
--- a/drivers/media/platform/soc_camera/soc_scale_crop.c
+++ /dev/null
@@ -1,426 +0,0 @@
-/*
- * soc-camera generic scaling-cropping manipulation functions
- *
- * Copyright (C) 2013 Guennadi Liakhovetski <g.liakhovetski@gmx.de>
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License as published by
- * the Free Software Foundation; either version 2 of the License, or
- * (at your option) any later version.
- */
-
-#include <linux/device.h>
-#include <linux/module.h>
-
-#include <media/soc_camera.h>
-#include <media/v4l2-common.h>
-
-#include "soc_scale_crop.h"
-
-#ifdef DEBUG_GEOMETRY
-#define dev_geo	dev_info
-#else
-#define dev_geo	dev_dbg
-#endif
-
-/* Check if any dimension of r1 is smaller than respective one of r2 */
-static bool is_smaller(const struct v4l2_rect *r1, const struct v4l2_rect *r2)
-{
-	return r1->width < r2->width || r1->height < r2->height;
-}
-
-/* Check if r1 fails to cover r2 */
-static bool is_inside(const struct v4l2_rect *r1, const struct v4l2_rect *r2)
-{
-	return r1->left > r2->left || r1->top > r2->top ||
-		r1->left + r1->width < r2->left + r2->width ||
-		r1->top + r1->height < r2->top + r2->height;
-}
-
-/* Get and store current client crop */
-int soc_camera_client_g_rect(struct v4l2_subdev *sd, struct v4l2_rect *rect)
-{
-	struct v4l2_subdev_selection sdsel = {
-		.which = V4L2_SUBDEV_FORMAT_ACTIVE,
-		.target = V4L2_SEL_TGT_CROP,
-	};
-	int ret;
-
-	ret = v4l2_subdev_call(sd, pad, get_selection, NULL, &sdsel);
-	if (!ret) {
-		*rect = sdsel.r;
-		return ret;
-	}
-
-	sdsel.target = V4L2_SEL_TGT_CROP_BOUNDS;
-	ret = v4l2_subdev_call(sd, pad, get_selection, NULL, &sdsel);
-	if (!ret)
-		*rect = sdsel.r;
-
-	return ret;
-}
-EXPORT_SYMBOL(soc_camera_client_g_rect);
-
-/* Client crop has changed, update our sub-rectangle to remain within the area */
-static void move_and_crop_subrect(struct v4l2_rect *rect,
-				  struct v4l2_rect *subrect)
-{
-	if (rect->width < subrect->width)
-		subrect->width = rect->width;
-
-	if (rect->height < subrect->height)
-		subrect->height = rect->height;
-
-	if (rect->left > subrect->left)
-		subrect->left = rect->left;
-	else if (rect->left + rect->width <
-		 subrect->left + subrect->width)
-		subrect->left = rect->left + rect->width -
-			subrect->width;
-
-	if (rect->top > subrect->top)
-		subrect->top = rect->top;
-	else if (rect->top + rect->height <
-		 subrect->top + subrect->height)
-		subrect->top = rect->top + rect->height -
-			subrect->height;
-}
-
-/*
- * The common for both scaling and cropping iterative approach is:
- * 1. try if the client can produce exactly what requested by the user
- * 2. if (1) failed, try to double the client image until we get one big enough
- * 3. if (2) failed, try to request the maximum image
- */
-int soc_camera_client_s_selection(struct v4l2_subdev *sd,
-			struct v4l2_selection *sel, struct v4l2_selection *cam_sel,
-			struct v4l2_rect *target_rect, struct v4l2_rect *subrect)
-{
-	struct v4l2_subdev_selection sdsel = {
-		.which = V4L2_SUBDEV_FORMAT_ACTIVE,
-		.target = sel->target,
-		.flags = sel->flags,
-		.r = sel->r,
-	};
-	struct v4l2_subdev_selection bounds = {
-		.which = V4L2_SUBDEV_FORMAT_ACTIVE,
-		.target = V4L2_SEL_TGT_CROP_BOUNDS,
-	};
-	struct v4l2_rect *rect = &sel->r, *cam_rect = &cam_sel->r;
-	struct device *dev = sd->v4l2_dev->dev;
-	int ret;
-	unsigned int width, height;
-
-	v4l2_subdev_call(sd, pad, set_selection, NULL, &sdsel);
-	sel->r = sdsel.r;
-	ret = soc_camera_client_g_rect(sd, cam_rect);
-	if (ret < 0)
-		return ret;
-
-	/*
-	 * Now cam_crop contains the current camera input rectangle, and it must
-	 * be within camera cropcap bounds
-	 */
-	if (!memcmp(rect, cam_rect, sizeof(*rect))) {
-		/* Even if camera S_SELECTION failed, but camera rectangle matches */
-		dev_dbg(dev, "Camera S_SELECTION successful for %dx%d@%d:%d\n",
-			rect->width, rect->height, rect->left, rect->top);
-		*target_rect = *cam_rect;
-		return 0;
-	}
-
-	/* Try to fix cropping, that camera hasn't managed to set */
-	dev_geo(dev, "Fix camera S_SELECTION for %dx%d@%d:%d to %dx%d@%d:%d\n",
-		cam_rect->width, cam_rect->height,
-		cam_rect->left, cam_rect->top,
-		rect->width, rect->height, rect->left, rect->top);
-
-	/* We need sensor maximum rectangle */
-	ret = v4l2_subdev_call(sd, pad, get_selection, NULL, &bounds);
-	if (ret < 0)
-		return ret;
-
-	/* Put user requested rectangle within sensor bounds */
-	soc_camera_limit_side(&rect->left, &rect->width, sdsel.r.left, 2,
-			      bounds.r.width);
-	soc_camera_limit_side(&rect->top, &rect->height, sdsel.r.top, 4,
-			      bounds.r.height);
-
-	/*
-	 * Popular special case - some cameras can only handle fixed sizes like
-	 * QVGA, VGA,... Take care to avoid infinite loop.
-	 */
-	width = max_t(unsigned int, cam_rect->width, 2);
-	height = max_t(unsigned int, cam_rect->height, 2);
-
-	/*
-	 * Loop as long as sensor is not covering the requested rectangle and
-	 * is still within its bounds
-	 */
-	while (!ret && (is_smaller(cam_rect, rect) ||
-			is_inside(cam_rect, rect)) &&
-	       (bounds.r.width > width || bounds.r.height > height)) {
-
-		width *= 2;
-		height *= 2;
-
-		cam_rect->width = width;
-		cam_rect->height = height;
-
-		/*
-		 * We do not know what capabilities the camera has to set up
-		 * left and top borders. We could try to be smarter in iterating
-		 * them, e.g., if camera current left is to the right of the
-		 * target left, set it to the middle point between the current
-		 * left and minimum left. But that would add too much
-		 * complexity: we would have to iterate each border separately.
-		 * Instead we just drop to the left and top bounds.
-		 */
-		if (cam_rect->left > rect->left)
-			cam_rect->left = bounds.r.left;
-
-		if (cam_rect->left + cam_rect->width < rect->left + rect->width)
-			cam_rect->width = rect->left + rect->width -
-				cam_rect->left;
-
-		if (cam_rect->top > rect->top)
-			cam_rect->top = bounds.r.top;
-
-		if (cam_rect->top + cam_rect->height < rect->top + rect->height)
-			cam_rect->height = rect->top + rect->height -
-				cam_rect->top;
-
-		sdsel.r = *cam_rect;
-		v4l2_subdev_call(sd, pad, set_selection, NULL, &sdsel);
-		*cam_rect = sdsel.r;
-		ret = soc_camera_client_g_rect(sd, cam_rect);
-		dev_geo(dev, "Camera S_SELECTION %d for %dx%d@%d:%d\n", ret,
-			cam_rect->width, cam_rect->height,
-			cam_rect->left, cam_rect->top);
-	}
-
-	/* S_SELECTION must not modify the rectangle */
-	if (is_smaller(cam_rect, rect) || is_inside(cam_rect, rect)) {
-		/*
-		 * The camera failed to configure a suitable cropping,
-		 * we cannot use the current rectangle, set to max
-		 */
-		sdsel.r = bounds.r;
-		v4l2_subdev_call(sd, pad, set_selection, NULL, &sdsel);
-		*cam_rect = sdsel.r;
-
-		ret = soc_camera_client_g_rect(sd, cam_rect);
-		dev_geo(dev, "Camera S_SELECTION %d for max %dx%d@%d:%d\n", ret,
-			cam_rect->width, cam_rect->height,
-			cam_rect->left, cam_rect->top);
-	}
-
-	if (!ret) {
-		*target_rect = *cam_rect;
-		move_and_crop_subrect(target_rect, subrect);
-	}
-
-	return ret;
-}
-EXPORT_SYMBOL(soc_camera_client_s_selection);
-
-/* Iterative set_fmt, also updates cached client crop on success */
-static int client_set_fmt(struct soc_camera_device *icd,
-			struct v4l2_rect *rect, struct v4l2_rect *subrect,
-			unsigned int max_width, unsigned int max_height,
-			struct v4l2_subdev_format *format, bool host_can_scale)
-{
-	struct v4l2_subdev *sd = soc_camera_to_subdev(icd);
-	struct device *dev = icd->parent;
-	struct v4l2_mbus_framefmt *mf = &format->format;
-	unsigned int width = mf->width, height = mf->height, tmp_w, tmp_h;
-	struct v4l2_subdev_selection sdsel = {
-		.which = V4L2_SUBDEV_FORMAT_ACTIVE,
-		.target = V4L2_SEL_TGT_CROP_BOUNDS,
-	};
-	bool host_1to1;
-	int ret;
-
-	ret = v4l2_device_call_until_err(sd->v4l2_dev,
-					 soc_camera_grp_id(icd), pad,
-					 set_fmt, NULL, format);
-	if (ret < 0)
-		return ret;
-
-	dev_geo(dev, "camera scaled to %ux%u\n", mf->width, mf->height);
-
-	if (width == mf->width && height == mf->height) {
-		/* Perfect! The client has done it all. */
-		host_1to1 = true;
-		goto update_cache;
-	}
-
-	host_1to1 = false;
-	if (!host_can_scale)
-		goto update_cache;
-
-	ret = v4l2_subdev_call(sd, pad, get_selection, NULL, &sdsel);
-	if (ret < 0)
-		return ret;
-
-	if (max_width > sdsel.r.width)
-		max_width = sdsel.r.width;
-	if (max_height > sdsel.r.height)
-		max_height = sdsel.r.height;
-
-	/* Camera set a format, but geometry is not precise, try to improve */
-	tmp_w = mf->width;
-	tmp_h = mf->height;
-
-	/* width <= max_width && height <= max_height - guaranteed by try_fmt */
-	while ((width > tmp_w || height > tmp_h) &&
-	       tmp_w < max_width && tmp_h < max_height) {
-		tmp_w = min(2 * tmp_w, max_width);
-		tmp_h = min(2 * tmp_h, max_height);
-		mf->width = tmp_w;
-		mf->height = tmp_h;
-		ret = v4l2_device_call_until_err(sd->v4l2_dev,
-					soc_camera_grp_id(icd), pad,
-					set_fmt, NULL, format);
-		dev_geo(dev, "Camera scaled to %ux%u\n",
-			mf->width, mf->height);
-		if (ret < 0) {
-			/* This shouldn't happen */
-			dev_err(dev, "Client failed to set format: %d\n", ret);
-			return ret;
-		}
-	}
-
-update_cache:
-	/* Update cache */
-	ret = soc_camera_client_g_rect(sd, rect);
-	if (ret < 0)
-		return ret;
-
-	if (host_1to1)
-		*subrect = *rect;
-	else
-		move_and_crop_subrect(rect, subrect);
-
-	return 0;
-}
-
-/**
- * soc_camera_client_scale
- * @icd:		soc-camera device
- * @rect:		camera cropping window
- * @subrect:		part of rect, sent to the user
- * @mf:			in- / output camera output window
- * @width:		on input: max host input width;
- *			on output: user width, mapped back to input
- * @height:		on input: max host input height;
- *			on output: user height, mapped back to input
- * @host_can_scale:	host can scale this pixel format
- * @shift:		shift, used for scaling
- */
-int soc_camera_client_scale(struct soc_camera_device *icd,
-			struct v4l2_rect *rect, struct v4l2_rect *subrect,
-			struct v4l2_mbus_framefmt *mf,
-			unsigned int *width, unsigned int *height,
-			bool host_can_scale, unsigned int shift)
-{
-	struct device *dev = icd->parent;
-	struct v4l2_subdev_format fmt_tmp = {
-		.which = V4L2_SUBDEV_FORMAT_ACTIVE,
-		.format = *mf,
-	};
-	struct v4l2_mbus_framefmt *mf_tmp = &fmt_tmp.format;
-	unsigned int scale_h, scale_v;
-	int ret;
-
-	/*
-	 * 5. Apply iterative camera S_FMT for camera user window (also updates
-	 *    client crop cache and the imaginary sub-rectangle).
-	 */
-	ret = client_set_fmt(icd, rect, subrect, *width, *height,
-			   &fmt_tmp, host_can_scale);
-	if (ret < 0)
-		return ret;
-
-	dev_geo(dev, "5: camera scaled to %ux%u\n",
-		mf_tmp->width, mf_tmp->height);
-
-	/* 6. Retrieve camera output window (g_fmt) */
-
-	/* unneeded - it is already in "mf_tmp" */
-
-	/* 7. Calculate new client scales. */
-	scale_h = soc_camera_calc_scale(rect->width, shift, mf_tmp->width);
-	scale_v = soc_camera_calc_scale(rect->height, shift, mf_tmp->height);
-
-	mf->width	= mf_tmp->width;
-	mf->height	= mf_tmp->height;
-	mf->colorspace	= mf_tmp->colorspace;
-
-	/*
-	 * 8. Calculate new host crop - apply camera scales to previously
-	 *    updated "effective" crop.
-	 */
-	*width = soc_camera_shift_scale(subrect->width, shift, scale_h);
-	*height = soc_camera_shift_scale(subrect->height, shift, scale_v);
-
-	dev_geo(dev, "8: new client sub-window %ux%u\n", *width, *height);
-
-	return 0;
-}
-EXPORT_SYMBOL(soc_camera_client_scale);
-
-/*
- * Calculate real client output window by applying new scales to the current
- * client crop. New scales are calculated from the requested output format and
- * host crop, mapped backed onto the client input (subrect).
- */
-void soc_camera_calc_client_output(struct soc_camera_device *icd,
-		struct v4l2_rect *rect, struct v4l2_rect *subrect,
-		const struct v4l2_pix_format *pix, struct v4l2_mbus_framefmt *mf,
-		unsigned int shift)
-{
-	struct device *dev = icd->parent;
-	unsigned int scale_v, scale_h;
-
-	if (subrect->width == rect->width &&
-	    subrect->height == rect->height) {
-		/* No sub-cropping */
-		mf->width	= pix->width;
-		mf->height	= pix->height;
-		return;
-	}
-
-	/* 1.-2. Current camera scales and subwin - cached. */
-
-	dev_geo(dev, "2: subwin %ux%u@%u:%u\n",
-		subrect->width, subrect->height,
-		subrect->left, subrect->top);
-
-	/*
-	 * 3. Calculate new combined scales from input sub-window to requested
-	 *    user window.
-	 */
-
-	/*
-	 * TODO: CEU cannot scale images larger than VGA to smaller than SubQCIF
-	 * (128x96) or larger than VGA. This and similar limitations have to be
-	 * taken into account here.
-	 */
-	scale_h = soc_camera_calc_scale(subrect->width, shift, pix->width);
-	scale_v = soc_camera_calc_scale(subrect->height, shift, pix->height);
-
-	dev_geo(dev, "3: scales %u:%u\n", scale_h, scale_v);
-
-	/*
-	 * 4. Calculate desired client output window by applying combined scales
-	 *    to client (real) input window.
-	 */
-	mf->width = soc_camera_shift_scale(rect->width, shift, scale_h);
-	mf->height = soc_camera_shift_scale(rect->height, shift, scale_v);
-}
-EXPORT_SYMBOL(soc_camera_calc_client_output);
-
-MODULE_DESCRIPTION("soc-camera scaling-cropping functions");
-MODULE_AUTHOR("Guennadi Liakhovetski <kernel@pengutronix.de>");
-MODULE_LICENSE("GPL");
diff --git a/drivers/media/platform/soc_camera/soc_scale_crop.h b/drivers/media/platform/soc_camera/soc_scale_crop.h
deleted file mode 100644
index 9ca469312a1f..000000000000
--- a/drivers/media/platform/soc_camera/soc_scale_crop.h
+++ /dev/null
@@ -1,47 +0,0 @@
-/*
- * soc-camera generic scaling-cropping manipulation functions
- *
- * Copyright (C) 2013 Guennadi Liakhovetski <g.liakhovetski@gmx.de>
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License as published by
- * the Free Software Foundation; either version 2 of the License, or
- * (at your option) any later version.
- */
-
-#ifndef SOC_SCALE_CROP_H
-#define SOC_SCALE_CROP_H
-
-#include <linux/kernel.h>
-
-struct soc_camera_device;
-
-struct v4l2_selection;
-struct v4l2_mbus_framefmt;
-struct v4l2_pix_format;
-struct v4l2_rect;
-struct v4l2_subdev;
-
-static inline unsigned int soc_camera_shift_scale(unsigned int size,
-				unsigned int shift, unsigned int scale)
-{
-	return DIV_ROUND_CLOSEST(size << shift, scale);
-}
-
-#define soc_camera_calc_scale(in, shift, out) soc_camera_shift_scale(in, shift, out)
-
-int soc_camera_client_g_rect(struct v4l2_subdev *sd, struct v4l2_rect *rect);
-int soc_camera_client_s_selection(struct v4l2_subdev *sd,
-			struct v4l2_selection *sel, struct v4l2_selection *cam_sel,
-			struct v4l2_rect *target_rect, struct v4l2_rect *subrect);
-int soc_camera_client_scale(struct soc_camera_device *icd,
-			struct v4l2_rect *rect, struct v4l2_rect *subrect,
-			struct v4l2_mbus_framefmt *mf,
-			unsigned int *width, unsigned int *height,
-			bool host_can_scale, unsigned int shift);
-void soc_camera_calc_client_output(struct soc_camera_device *icd,
-		struct v4l2_rect *rect, struct v4l2_rect *subrect,
-		const struct v4l2_pix_format *pix, struct v4l2_mbus_framefmt *mf,
-		unsigned int shift);
-
-#endif
-- 
2.20.1

