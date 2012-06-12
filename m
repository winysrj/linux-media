Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bk0-f46.google.com ([209.85.214.46]:40916 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751092Ab2FLK5v (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 12 Jun 2012 06:57:51 -0400
Received: by bkcji2 with SMTP id ji2so4364160bkc.19
        for <linux-media@vger.kernel.org>; Tue, 12 Jun 2012 03:57:49 -0700 (PDT)
Message-ID: <4FD720AC.8000906@gmail.com>
Date: Tue, 12 Jun 2012 12:57:48 +0200
From: Sylwester Nawrocki <snjw23@gmail.com>
MIME-Version: 1.0
To: Sakari Ailus <sakari.ailus@iki.fi>
CC: linux-media@vger.kernel.org, hverkuil@xs4all.nl,
	laurent.pinchart@ideasonboard.com
Subject: Re: [PATCH 3/4] v4l: Unify selection targets across V4L2 and V4L2
 subdev interfaces
References: <4FD4F6B6.1070605@iki.fi> <1339356878-2179-3-git-send-email-sakari.ailus@iki.fi>
In-Reply-To: <1339356878-2179-3-git-send-email-sakari.ailus@iki.fi>
Content-Type: multipart/mixed;
 boundary="------------020001070208020907080405"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is a multi-part message in MIME format.
--------------020001070208020907080405
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Hi Sakari,

On 06/10/2012 09:34 PM, Sakari Ailus wrote:
> Signed-off-by: Sakari Ailus<sakari.ailus@iki.fi>
> ---
>   drivers/media/video/omap3isp/ispccdc.c    |    6 ++--
>   drivers/media/video/omap3isp/isppreview.c |    6 ++--
>   drivers/media/video/omap3isp/ispresizer.c |    6 ++--
>   drivers/media/video/smiapp/smiapp-core.c  |   30 +++++++++---------
>   drivers/media/video/v4l2-subdev.c         |    4 +-
>   include/linux/v4l2-common.h               |   49 +++++++++++++++++++++++++++++
>   include/linux/v4l2-subdev.h               |   13 +------
>   include/linux/videodev2.h                 |   20 +----------
>   8 files changed, 79 insertions(+), 55 deletions(-)
>   create mode 100644 include/linux/v4l2-common.h
<snip>
> diff --git a/include/linux/v4l2-common.h b/include/linux/v4l2-common.h
> new file mode 100644
> index 0000000..e0db6e3
> --- /dev/null
> +++ b/include/linux/v4l2-common.h
> @@ -0,0 +1,49 @@
> +/*
> + * include/linux/v4l2-common.h
> + *
> + * Common V4L2 and V4L2 subdev definitions.
> + *
> + * Users are adviced to #include this file either videodev2.h (V4L2)

s/either videodev2.h/either from videodev2.h ?

> + * or v4l2-subdev.h (V4L2 subdev) rather than to refer to this file

s/or v4l2-subdev.h/or from v4l2-subdev.h ?

> + * directly.
> + *
> + * Copyright (C) 2012 Nokia Corporation
> + * Contact: Sakari Ailus<sakari.ailus@maxwell.research.nokia.com>
> + *
> + * This program is free software; you can redistribute it and/or
> + * modify it under the terms of the GNU General Public License
> + * version 2 as published by the Free Software Foundation.
> + *
> + * This program is distributed in the hope that it will be useful, but
> + * WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
> + * General Public License for more details.
> + *
> + * You should have received a copy of the GNU General Public License
> + * along with this program; if not, write to the Free Software
> + * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA
> + * 02110-1301 USA
> + *
> + */
> +
> +#ifndef __V4L2_COMMON__
> +#define __V4L2_COMMON__
> +
> +/* Selection target definitions */
> +
> +/* Current cropping area */
> +#define V4L2_SEL_TGT_CROP		0x0000
> +/* Default cropping area */
> +#define V4L2_SEL_TGT_CROP_DEFAULT	0x0001
> +/* Cropping bounds */
> +#define V4L2_SEL_TGT_CROP_BOUNDS	0x0002
> +/* Current composing area */
> +#define V4L2_SEL_TGT_COMPOSE		0x0100
> +/* Default composing area */
> +#define V4L2_SEL_TGT_COMPOSE_DEFAULT	0x0101
> +/* Composing bounds */
> +#define V4L2_SEL_TGT_COMPOSE_BOUNDS	0x0102
> +/* Current composing area plus all padding pixels */
> +#define V4L2_SEL_TGT_COMPOSE_PADDED	0x0103
> +
> +#endif /* __V4L2_COMMON__  */
> diff --git a/include/linux/v4l2-subdev.h b/include/linux/v4l2-subdev.h
> index 01eee06..b75f535 100644
> --- a/include/linux/v4l2-subdev.h
> +++ b/include/linux/v4l2-subdev.h
> @@ -127,22 +127,13 @@ struct v4l2_subdev_frame_interval_enum {
>   #define V4L2_SUBDEV_SEL_FLAG_SIZE_LE			(1<<  1)
>   #define V4L2_SUBDEV_SEL_FLAG_KEEP_CONFIG		(1<<  2)
>
> -/* active cropping area */
> -#define V4L2_SUBDEV_SEL_TGT_CROP			0x0000
> -/* cropping bounds */
> -#define V4L2_SUBDEV_SEL_TGT_CROP_BOUNDS			0x0002
> -/* current composing area */
> -#define V4L2_SUBDEV_SEL_TGT_COMPOSE			0x0100
> -/* composing bounds */
> -#define V4L2_SUBDEV_SEL_TGT_COMPOSE_BOUNDS		0x0102
> -
> -

Should this patch at the same time be adding:

#include <linux/v4l2-common.h>

to avoid build errors ?

>   /**
>    * struct v4l2_subdev_selection - selection info
>    *
>    * @which: either V4L2_SUBDEV_FORMAT_ACTIVE or V4L2_SUBDEV_FORMAT_TRY
>    * @pad: pad number, as reported by the media API
> - * @target: selection target, used to choose one of possible rectangles
> + * @target: Selection target, used to choose one of possible rectangles,
> + *	    defined in v4l2-common.h; V4L2_SEL_TGT_* .
>    * @flags: constraint flags
>    * @r: coordinates of the selection window
>    * @reserved: for future use, set to zero for now
> diff --git a/include/linux/videodev2.h b/include/linux/videodev2.h
> index 2cff49c..10edd1d 100644
> --- a/include/linux/videodev2.h
> +++ b/include/linux/videodev2.h
> @@ -765,27 +765,11 @@ struct v4l2_crop {
>   #define V4L2_SEL_FLAG_GE	0x00000001
>   #define V4L2_SEL_FLAG_LE	0x00000002

And also in videdev2.h:

#include <linux/v4l2-common.h>

?
> -/* Selection targets */
> -
> -/* Current cropping area */
> -#define V4L2_SEL_TGT_CROP		0x0000
> -/* Default cropping area */
> -#define V4L2_SEL_TGT_CROP_DEFAULT	0x0001
> -/* Cropping bounds */
> -#define V4L2_SEL_TGT_CROP_BOUNDS	0x0002
> -/* Current composing area */
> -#define V4L2_SEL_TGT_COMPOSE		0x0100
> -/* Default composing area */
> -#define V4L2_SEL_TGT_COMPOSE_DEFAULT	0x0101
> -/* Composing bounds */
> -#define V4L2_SEL_TGT_COMPOSE_BOUNDS	0x0102
> -/* Current composing area plus all padding pixels */
> -#define V4L2_SEL_TGT_COMPOSE_PADDED	0x0103
> -
>   /**
>    * struct v4l2_selection - selection info
>    * @type:	buffer type (do not use *_MPLANE types)
> - * @target:	selection target, used to choose one of possible rectangles
> + * @target:	Selection target, used to choose one of possible rectangles;
> + *		defined in v4l2-common.h.
>    * @flags:	constraints flags
>    * @r:		coordinates of selection window
>    * @reserved:	for future use, rounds structure size to 64 bytes, set to zero

There are now some missing renames, due to some patches that were merged
recently. Please feel free to squash the attached patch with this one.

--
Regards,
Sylwester

--------------020001070208020907080405
Content-Type: text/x-patch;
 name="0001-s5p-fimc-use-new-selection-target-names.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="0001-s5p-fimc-use-new-selection-target-names.patch"

>From 4fc78303e1f6e8d82fdddee7108ff730595fa6d3 Mon Sep 17 00:00:00 2001
From: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
Date: Tue, 12 Jun 2012 12:52:12 +0200
Subject: [PATCH] s5p-fimc: use new selection target names

Signed-off-by: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
---
 drivers/media/video/s5p-fimc/fimc-capture.c |   18 +++++++++---------
 drivers/media/video/s5p-fimc/fimc-lite.c    |   11 +++++------
 2 files changed, 14 insertions(+), 15 deletions(-)

diff --git a/drivers/media/video/s5p-fimc/fimc-capture.c b/drivers/media/video/s5p-fimc/fimc-capture.c
index 356cc5c..22c28ab 100644
--- a/drivers/media/video/s5p-fimc/fimc-capture.c
+++ b/drivers/media/video/s5p-fimc/fimc-capture.c
@@ -1429,9 +1429,9 @@ static int fimc_subdev_get_selection(struct v4l2_subdev *sd,
 	mutex_lock(&fimc->lock);
 
 	switch (sel->target) {
-	case V4L2_SUBDEV_SEL_TGT_COMPOSE_BOUNDS:
+	case V4L2_SEL_TGT_COMPOSE_BOUNDS:
 		f = &ctx->d_frame;
-	case V4L2_SUBDEV_SEL_TGT_CROP_BOUNDS:
+	case V4L2_SEL_TGT_CROP_BOUNDS:
 		r->width = f->o_width;
 		r->height = f->o_height;
 		r->left = 0;
@@ -1439,10 +1439,10 @@ static int fimc_subdev_get_selection(struct v4l2_subdev *sd,
 		mutex_unlock(&fimc->lock);
 		return 0;
 
-	case V4L2_SUBDEV_SEL_TGT_CROP_ACTUAL:
+	case V4L2_SEL_TGT_CROP:
 		try_sel = v4l2_subdev_get_try_crop(fh, sel->pad);
 		break;
-	case V4L2_SUBDEV_SEL_TGT_COMPOSE_ACTUAL:
+	case V4L2_SEL_TGT_COMPOSE:
 		try_sel = v4l2_subdev_get_try_compose(fh, sel->pad);
 		f = &ctx->d_frame;
 		break;
@@ -1486,9 +1486,9 @@ static int fimc_subdev_set_selection(struct v4l2_subdev *sd,
 	fimc_capture_try_selection(ctx, r, V4L2_SEL_TGT_CROP);
 
 	switch (sel->target) {
-	case V4L2_SUBDEV_SEL_TGT_COMPOSE_BOUNDS:
+	case V4L2_SEL_TGT_COMPOSE_BOUNDS:
 		f = &ctx->d_frame;
-	case V4L2_SUBDEV_SEL_TGT_CROP_BOUNDS:
+	case V4L2_SEL_TGT_CROP_BOUNDS:
 		r->width = f->o_width;
 		r->height = f->o_height;
 		r->left = 0;
@@ -1496,10 +1496,10 @@ static int fimc_subdev_set_selection(struct v4l2_subdev *sd,
 		mutex_unlock(&fimc->lock);
 		return 0;
 
-	case V4L2_SUBDEV_SEL_TGT_CROP_ACTUAL:
+	case V4L2_SEL_TGT_CROP:
 		try_sel = v4l2_subdev_get_try_crop(fh, sel->pad);
 		break;
-	case V4L2_SUBDEV_SEL_TGT_COMPOSE_ACTUAL:
+	case V4L2_SEL_TGT_COMPOSE:
 		try_sel = v4l2_subdev_get_try_compose(fh, sel->pad);
 		f = &ctx->d_frame;
 		break;
@@ -1515,7 +1515,7 @@ static int fimc_subdev_set_selection(struct v4l2_subdev *sd,
 		set_frame_crop(f, r->left, r->top, r->width, r->height);
 		set_bit(ST_CAPT_APPLY_CFG, &fimc->state);
 		spin_unlock_irqrestore(&fimc->slock, flags);
-		if (sel->target == V4L2_SUBDEV_SEL_TGT_COMPOSE_ACTUAL)
+		if (sel->target == V4L2_SEL_TGT_COMPOSE)
 			ctx->state |= FIMC_COMPOSE;
 	}
 
diff --git a/drivers/media/video/s5p-fimc/fimc-lite.c b/drivers/media/video/s5p-fimc/fimc-lite.c
index 52ede56..8785089 100644
--- a/drivers/media/video/s5p-fimc/fimc-lite.c
+++ b/drivers/media/video/s5p-fimc/fimc-lite.c
@@ -1086,9 +1086,9 @@ static int fimc_lite_subdev_get_selection(struct v4l2_subdev *sd,
 	struct fimc_lite *fimc = v4l2_get_subdevdata(sd);
 	struct flite_frame *f = &fimc->inp_frame;
 
-	if ((sel->target != V4L2_SUBDEV_SEL_TGT_CROP_ACTUAL &&
-	     sel->target != V4L2_SUBDEV_SEL_TGT_CROP_BOUNDS) ||
-	    sel->pad != FLITE_SD_PAD_SINK)
+	if ((sel->target != V4L2_SEL_TGT_CROP &&
+	     sel->target != V4L2_SEL_TGT_CROP_BOUNDS) ||
+	     sel->pad != FLITE_SD_PAD_SINK)
 		return -EINVAL;
 
 	if (sel->which == V4L2_SUBDEV_FORMAT_TRY) {
@@ -1097,7 +1097,7 @@ static int fimc_lite_subdev_get_selection(struct v4l2_subdev *sd,
 	}
 
 	mutex_lock(&fimc->lock);
-	if (sel->target == V4L2_SUBDEV_SEL_TGT_CROP_ACTUAL) {
+	if (sel->target == V4L2_SEL_TGT_CROP) {
 		sel->r = f->rect;
 	} else {
 		sel->r.left = 0;
@@ -1122,8 +1122,7 @@ static int fimc_lite_subdev_set_selection(struct v4l2_subdev *sd,
 	struct flite_frame *f = &fimc->inp_frame;
 	int ret = 0;
 
-	if (sel->target != V4L2_SUBDEV_SEL_TGT_CROP_ACTUAL ||
-	    sel->pad != FLITE_SD_PAD_SINK)
+	if (sel->target != V4L2_SEL_TGT_CROP || sel->pad != FLITE_SD_PAD_SINK)
 		return -EINVAL;
 
 	mutex_lock(&fimc->lock);
-- 
1.7.4.1


--------------020001070208020907080405--
