Return-path: <linux-media-owner@vger.kernel.org>
Received: from mo-p05-ob.rzone.de ([81.169.146.180]:56153 "EHLO
	mo-p05-ob.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932130Ab0DGGeL (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 7 Apr 2010 02:34:11 -0400
Message-ID: <4BBC24A0.3090005@nt.tu-darmstadt.de>
Date: Wed, 07 Apr 2010 08:22:24 +0200
From: Vladimir Pantelic <pan@nt.tu-darmstadt.de>
MIME-Version: 1.0
To: hvaibhav@ti.com
CC: linux-media@vger.kernel.org, m-karicheri2@ti.com,
	mchehab@redhat.com, linux-omap@vger.kernel.org, tony@atomide.com
Subject: Re: [PATCH 1/2] OMAP2/3 V4L2: Add support for OMAP2/3 V4L2 driver
 on top of DSS2
References: <hvaibhav@ti.com> <1270115880-21404-2-git-send-email-hvaibhav@ti.com>
In-Reply-To: <1270115880-21404-2-git-send-email-hvaibhav@ti.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

hvaibhav@ti.com wrote:
> From: Vaibhav Hiremath<hvaibhav@ti.com>
>
> Features Supported -
> 	1. Provides V4L2 user interface for the video pipelines of DSS
> 	2. Basic streaming working on LCD, DVI and TV.
> 	3. Works on latest DSS2 library from Tomi
> 	4. Support for various pixel formats like YUV, UYVY, RGB32, RGB24,
> 	   RGB565
> 	5. Supports Alpha blending.
> 	6. Supports Color keying both source and destination.
> 	7. Supports rotation.
> 	8. Supports cropping.
> 	9. Supports Background color setting.
> 	10. Allocated buffers to only needed size
>
> Signed-off-by: Vaibhav Hiremath<hvaibhav@ti.com>

<snip>

> diff --git a/drivers/media/video/omap/omap_voutlib.c b/drivers/media/video/omap/omap_voutlib.c
> new file mode 100644
> index 0000000..05c0e17
> --- /dev/null
> +++ b/drivers/media/video/omap/omap_voutlib.c
> @@ -0,0 +1,258 @@
> +/*
> + * omap_voutlib.c
> + *
> + * Copyright (C) 2005-2010 Texas Instruments.
> + *
> + * This file is licensed under the terms of the GNU General Public License
> + * version 2. This program is licensed "as is" without any warranty of any
> + * kind, whether express or implied.
> + *
> + * Based on the OMAP2 camera driver
> + * Video-for-Linux (Version 2) camera capture driver for
> + * the OMAP24xx camera controller.
> + *
> + * Author: Andy Lowe (source@mvista.com)
> + *
> + * Copyright (C) 2004 MontaVista Software, Inc.
> + * Copyright (C) 2010 Texas Instruments.
> + *
> + */
> +
> +#include<linux/module.h>
> +#include<linux/errno.h>
> +#include<linux/kernel.h>
> +#include<linux/types.h>
> +#include<linux/videodev2.h>
> +
> +MODULE_AUTHOR("Texas Instruments");
> +MODULE_DESCRIPTION("OMAP Video library");
> +MODULE_LICENSE("GPL");
> +
> +/* Return the default overlay cropping rectangle in crop given the image
> + * size in pix and the video display size in fbuf.  The default
> + * cropping rectangle is the largest rectangle no larger than the capture size
> + * that will fit on the display.  The default cropping rectangle is centered in
> + * the image.  All dimensions and offsets are rounded down to even numbers.
> + */
> +void omap_vout_default_crop(struct v4l2_pix_format *pix,
> +		  struct v4l2_framebuffer *fbuf, struct v4l2_rect *crop)
> +{
> +	crop->width = (pix->width<  fbuf->fmt.width) ?
> +		pix->width : fbuf->fmt.width;
> +	crop->height = (pix->height<  fbuf->fmt.height) ?
> +		pix->height : fbuf->fmt.height;
> +	crop->width&= ~1;
> +	crop->height&= ~1;
> +	crop->left = ((pix->width - crop->width)>>  1)&  ~1;
> +	crop->top = ((pix->height - crop->height)>>  1)&  ~1;
> +}
> +EXPORT_SYMBOL_GPL(omap_vout_default_crop);
> +
> +/* Given a new render window in new_win, adjust the window to the
> + * nearest supported configuration.  The adjusted window parameters are
> + * returned in new_win.
> + * Returns zero if succesful, or -EINVAL if the requested window is
> + * impossible and cannot reasonably be adjusted.
> + */
> +int omap_vout_try_window(struct v4l2_framebuffer *fbuf,
> +			struct v4l2_window *new_win)
> +{
> +	struct v4l2_rect try_win;
> +
> +	/* make a working copy of the new_win rectangle */
> +	try_win = new_win->w;
> +
> +	/* adjust the preview window so it fits on the display by clipping any
> +	 * offscreen areas
> +	 */
> +	if (try_win.left<  0) {
> +		try_win.width += try_win.left;
> +		try_win.left = 0;
> +	}
> +	if (try_win.top<  0) {
> +		try_win.height += try_win.top;
> +		try_win.top = 0;
> +	}
> +	try_win.width = (try_win.width<  fbuf->fmt.width) ?
> +		try_win.width : fbuf->fmt.width;
> +	try_win.height = (try_win.height<  fbuf->fmt.height) ?
> +		try_win.height : fbuf->fmt.height;
> +	if (try_win.left + try_win.width>  fbuf->fmt.width)
> +		try_win.width = fbuf->fmt.width - try_win.left;
> +	if (try_win.top + try_win.height>  fbuf->fmt.height)
> +		try_win.height = fbuf->fmt.height - try_win.top;
> +	try_win.width&= ~1;
> +	try_win.height&= ~1;
> +
> +	if (try_win.width<= 0 || try_win.height<= 0)
> +		return -EINVAL;
> +
> +	/* We now have a valid preview window, so go with it */
> +	new_win->w = try_win;
> +	new_win->field = V4L2_FIELD_ANY;
> +	return 0;
> +}
> +EXPORT_SYMBOL_GPL(omap_vout_try_window);
> +
> +/* Given a new render window in new_win, adjust the window to the
> + * nearest supported configuration.  The image cropping window in crop
> + * will also be adjusted if necessary.  Preference is given to keeping the
> + * the window as close to the requested configuration as possible.  If
> + * successful, new_win, vout->win, and crop are updated.
> + * Returns zero if succesful, or -EINVAL if the requested preview window is
> + * impossible and cannot reasonably be adjusted.
> + */
> +int omap_vout_new_window(struct v4l2_rect *crop,
> +		struct v4l2_window *win, struct v4l2_framebuffer *fbuf,
> +		struct v4l2_window *new_win)
> +{
> +	int err;
> +
> +	err = omap_vout_try_window(fbuf, new_win);
> +	if (err)
> +		return err;
> +
> +	/* update our preview window */
> +	win->w = new_win->w;
> +	win->field = new_win->field;
> +	win->chromakey = new_win->chromakey;
> +
> +	/* adjust the cropping window to allow for resizing limitations */
> +	if ((crop->height/win->w.height)>= 4) {
> +		/* The maximum vertical downsizing ratio is 4:1 */
> +		crop->height = win->w.height * 4;
> +	}
> +	if ((crop->width/win->w.width)>= 4) {
> +		/* The maximum horizontal downsizing ratio is 4:1 */
> +		crop->width = win->w.width * 4;
> +	}
> +	return 0;
> +}
> +EXPORT_SYMBOL_GPL(omap_vout_new_window);
> +
> +/* Given a new cropping rectangle in new_crop, adjust the cropping rectangle to
> + * the nearest supported configuration.  The image render window in win will
> + * also be adjusted if necessary.  The preview window is adjusted such that the
> + * horizontal and vertical rescaling ratios stay constant.  If the render
> + * window would fall outside the display boundaries, the cropping rectangle
> + * will also be adjusted to maintain the rescaling ratios.  If successful, crop
> + * and win are updated.
> + * Returns zero if succesful, or -EINVAL if the requested cropping rectangle is
> + * impossible and cannot reasonably be adjusted.
> + */
> +int omap_vout_new_crop(struct v4l2_pix_format *pix,
> +	      struct v4l2_rect *crop, struct v4l2_window *win,
> +	      struct v4l2_framebuffer *fbuf, const struct v4l2_rect *new_crop)
> +{
> +	struct v4l2_rect try_crop;
> +	unsigned long vresize, hresize;
> +
> +	/* make a working copy of the new_crop rectangle */
> +	try_crop = *new_crop;
> +
> +	/* adjust the cropping rectangle so it fits in the image */
> +	if (try_crop.left<  0) {
> +		try_crop.width += try_crop.left;
> +		try_crop.left = 0;
> +	}
> +	if (try_crop.top<  0) {
> +		try_crop.height += try_crop.top;
> +		try_crop.top = 0;
> +	}
> +	try_crop.width = (try_crop.width<  pix->width) ?
> +		try_crop.width : pix->width;
> +	try_crop.height = (try_crop.height<  pix->height) ?
> +		try_crop.height : pix->height;
> +	if (try_crop.left + try_crop.width>  pix->width)
> +		try_crop.width = pix->width - try_crop.left;
> +	if (try_crop.top + try_crop.height>  pix->height)
> +		try_crop.height = pix->height - try_crop.top;
> +	try_crop.width&= ~1;
> +	try_crop.height&= ~1;
> +	if (try_crop.width<= 0 || try_crop.height<= 0)
> +		return -EINVAL;
> +

> +	if (crop->height != win->w.height) {
> +		/* If we're resizing vertically, we can't support a crop width
> +		 * wider than 768 pixels.
> +		 */
> +		if (try_crop.width>  768)
> +			try_crop.width = 768;
> +	}

Doesn't the above only apply to OMAP2? OMAP3 does not have this restriction, no?
In my tree, this is under #ifdef CONFIG_ARCH_OMAP2...

> +	/* vertical resizing */
> +	vresize = (1024 * crop->height) / win->w.height;
> +	if (vresize>  4096)
> +		vresize = 4096;
> +	else if (vresize == 0)
> +		vresize = 1;
> +	win->w.height = ((1024 * try_crop.height) / vresize)&  ~1;
> +	if (win->w.height == 0)
> +		win->w.height = 2;
> +	if (win->w.height + win->w.top>  fbuf->fmt.height) {
> +		/* We made the preview window extend below the bottom of the
> +		 * display, so clip it to the display boundary and resize the
> +		 * cropping height to maintain the vertical resizing ratio.
> +		 */
> +		win->w.height = (fbuf->fmt.height - win->w.top)&  ~1;
> +		if (try_crop.height == 0)
> +			try_crop.height = 2;
> +	}
> +	/* horizontal resizing */
> +	hresize = (1024 * crop->width) / win->w.width;
> +	if (hresize>  4096)
> +		hresize = 4096;
> +	else if (hresize == 0)
> +		hresize = 1;
> +	win->w.width = ((1024 * try_crop.width) / hresize)&  ~1;
> +	if (win->w.width == 0)
> +		win->w.width = 2;
> +	if (win->w.width + win->w.left>  fbuf->fmt.width) {
> +		/* We made the preview window extend past the right side of the
> +		 * display, so clip it to the display boundary and resize the
> +		 * cropping width to maintain the horizontal resizing ratio.
> +		 */
> +		win->w.width = (fbuf->fmt.width - win->w.left)&  ~1;
> +		if (try_crop.width == 0)
> +			try_crop.width = 2;
> +	}
> +
> +	/* Check for resizing constraints */
> +	if ((try_crop.height/win->w.height)>= 4) {
> +		/* The maximum vertical downsizing ratio is 4:1 */
> +		try_crop.height = win->w.height * 4;
> +	}
> +	if ((try_crop.width/win->w.width)>= 4) {
> +		/* The maximum horizontal downsizing ratio is 4:1 */
> +		try_crop.width = win->w.width * 4;
> +	}
> +
> +	/* update our cropping rectangle and we're done */
> +	*crop = try_crop;
> +	return 0;
> +}
> +EXPORT_SYMBOL_GPL(omap_vout_new_crop);
> +
> +/* Given a new format in pix and fbuf,  crop and win
> + * structures are initialized to default values. crop
> + * is initialized to the largest window size that will fit on the display.  The
> + * crop window is centered in the image. win is initialized to
> + * the same size as crop and is centered on the display.
> + * All sizes and offsets are constrained to be even numbers.
> + */
> +void omap_vout_new_format(struct v4l2_pix_format *pix,
> +		struct v4l2_framebuffer *fbuf, struct v4l2_rect *crop,
> +		struct v4l2_window *win)
> +{
> +	/* crop defines the preview source window in the image capture
> +	 * buffer
> +	 */
> +	omap_vout_default_crop(pix, fbuf, crop);
> +
> +	/* win defines the preview target window on the display */
> +	win->w.width = crop->width;
> +	win->w.height = crop->height;
> +	win->w.left = ((fbuf->fmt.width - win->w.width)>>  1)&  ~1;
> +	win->w.top = ((fbuf->fmt.height - win->w.height)>>  1)&  ~1;
> +}
> +EXPORT_SYMBOL_GPL(omap_vout_new_format);
> +
