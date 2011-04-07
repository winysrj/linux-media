Return-path: <mchehab@pedra>
Received: from perceval.ideasonboard.com ([95.142.166.194]:49560 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753865Ab1DGL6X (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 7 Apr 2011 07:58:23 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: davinci-linux-open-source@linux.davincidsp.com
Subject: Re: [PATCH v16 01/13] davinci vpbe: V4L2 display driver for DM644X SoC
Date: Thu, 7 Apr 2011 13:58:20 +0200
Cc: Manjunath Hadli <manjunath.hadli@ti.com>,
	LMML <linux-media@vger.kernel.org>,
	Kevin Hilman <khilman@deeprootsystems.com>,
	LAK <linux-arm-kernel@lists.infradead.org>,
	Sekhar Nori <nsekhar@ti.com>
References: <1301737249-4012-1-git-send-email-manjunath.hadli@ti.com>
In-Reply-To: <1301737249-4012-1-git-send-email-manjunath.hadli@ti.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201104071358.21451.laurent.pinchart@ideasonboard.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi Manjunath,

On Saturday 02 April 2011 11:40:49 Manjunath Hadli wrote:
> This is the display driver for Texas Instruments's DM644X family
> SoC. This patch contains the main implementation of the driver with the
> V4L2 interface. The driver implements the streaming model with
> support for both kernel allocated buffers and user pointers. It also
> implements all of the necessary IOCTLs necessary and supported by the
> video display device.
> 
> Signed-off-by: Manjunath Hadli <manjunath.hadli@ti.com>
> Acked-by: Muralidharan Karicheri <m-karicheri2@ti.com>
> Acked-by: Hans Verkuil <hverkuil@xs4all.nl>

[snip]

> diff --git a/drivers/media/video/davinci/vpbe_display.c
> b/drivers/media/video/davinci/vpbe_display.c new file mode 100644
> index 0000000..dde5f8a
> --- /dev/null
> +++ b/drivers/media/video/davinci/vpbe_display.c
> @@ -0,0 +1,2085 @@
> +/*
> + * Copyright (C) 2010 Texas Instruments Incorporated - http://www.ti.com/
> + *
> + * This program is free software; you can redistribute it and/or
> + * modify it under the terms of the GNU General Public License as
> + * published by the Free Software Foundation version 2.
> + *
> + * This program is distributed WITHOUT ANY WARRANTY of any
> + * kind, whether express or implied; without even the implied warranty
> + * of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + * GNU General Public License for more details.
> + */
> +#include <linux/kernel.h>
> +#include <linux/init.h>
> +#include <linux/module.h>
> +#include <linux/errno.h>
> +#include <linux/fs.h>

That looks suspicious, do you really need to include linux/fs.h ?

> +#include <linux/interrupt.h>
> +#include <linux/string.h>
> +#include <linux/wait.h>
> +#include <linux/time.h>
> +#include <linux/platform_device.h>
> +#include <linux/irq.h>
> +#include <linux/mm.h>
> +#include <linux/mutex.h>
> +#include <linux/videodev2.h>
> +#include <linux/slab.h>
> +
> +#include <asm/pgtable.h>
> +#include <mach/cputype.h>
> +
> +#include <media/v4l2-dev.h>
> +#include <media/v4l2-common.h>
> +#include <media/v4l2-ioctl.h>
> +#include <media/v4l2-device.h>
> +#include <media/davinci/vpbe_display.h>
> +#include <media/davinci/vpbe_types.h>
> +#include <media/davinci/vpbe.h>
> +#include <media/davinci/vpbe_venc.h>
> +#include <media/davinci/vpbe_osd.h>
> +#include "vpbe_venc_regs.h"
> +
> +#define VPBE_DISPLAY_DRIVER "vpbe-v4l2"
> +
> +static int debug;
> +static u32 video2_numbuffers = 3;
> +static u32 video3_numbuffers = 3;

Why is the number of buffers set by a module parameter ? It should be 
negotiated dynamically with REQBUFS.

> +#define VPBE_DISPLAY_SD_BUF_SIZE (720*576*2)
> +#define VPBE_DEFAULT_NUM_BUFS 3
> +
> +static u32 video2_bufsize = VPBE_DISPLAY_SD_BUF_SIZE;
> +static u32 video3_bufsize = VPBE_DISPLAY_SD_BUF_SIZE;

Those two variables are assigned but never read. You either forgot to read 
them, or to remove them.

> +module_param(video2_numbuffers, uint, S_IRUGO);
> +module_param(video3_numbuffers, uint, S_IRUGO);
> +module_param(video2_bufsize, uint, S_IRUGO);
> +module_param(video3_bufsize, uint, S_IRUGO);
> +module_param(debug, int, 0644);
> +
> +static struct buf_config_params display_buf_config_params = {
> +	.min_numbuffers = VPBE_DEFAULT_NUM_BUFS,
> +	.numbuffers[0] = VPBE_DEFAULT_NUM_BUFS,
> +	.numbuffers[1] = VPBE_DEFAULT_NUM_BUFS,
> +	.min_bufsize[0] = VPBE_DISPLAY_SD_BUF_SIZE,
> +	.min_bufsize[1] = VPBE_DISPLAY_SD_BUF_SIZE,
> +	.layer_bufsize[0] = VPBE_DISPLAY_SD_BUF_SIZE,
> +	.layer_bufsize[1] = VPBE_DISPLAY_SD_BUF_SIZE,
> +};

This also looks like something that shouldn't be hardcoded.

> +static	struct vpbe_device *vpbe_dev;
> +static	struct osd_state *osd_device;

No such global variables please. Pass the pointers around between functions 
instead.

> +static int vpbe_display_nr[] = { 2, 3 };

Is there a reason to register video devices with a specific number ? 
video_register_device() doesn't guarantee, that the requested number will be 
used, so it looks a bit pointless to me.

> +static struct v4l2_capability vpbe_display_videocap = {
> +	.driver = VPBE_DISPLAY_DRIVER,
> +	.bus_info = "platform",
> +	.version = VPBE_DISPLAY_VERSION_CODE,
> +	.capabilities = V4L2_CAP_VIDEO_OUTPUT | V4L2_CAP_STREAMING,
> +};

Please fill v4l2_capability dynamically in vpbe_display_querycap() instead of 
using a global variable.

> +static u8 layer_first_int[VPBE_DISPLAY_MAX_DEVICES];

This belongs to your vpbe_display_obj object, not to a global variable.

> +static int venc_is_second_field()
> +{
> +	int ret = 0;
> +	int val;
> +	ret = v4l2_subdev_call(vpbe_dev->venc,
> +			       core,
> +			       ioctl,
> +			       VENC_GET_FLD,
> +			       &val);
> +	if (ret < 0) {
> +		v4l2_err(&vpbe_dev->v4l2_dev,
> +			 "Error in getting Field ID 0\n");
> +	}
> +	return val;
> +}
> +
> +/*
> + * vpbe_display_isr()
> + * ISR function. It changes status of the displayed buffer, takes next
> buffer + * from the queue and sets its address in VPBE registers
> + */
> +static void vpbe_display_isr(unsigned int event, void *disp_obj)

You can pass a vpbe_display object directly tp vpbe_display_isr() instead of 
using void *.

> +{
> +	unsigned long jiffies_time = get_jiffies_64();
> +	struct timeval timevalue;
> +	int i, fid;
> +	unsigned long addr = 0;
> +	struct vpbe_display_obj *layer = NULL;

No need to initialize addr and layer to NULL.

> +	struct vpbe_display *disp_dev = (struct vpbe_display *)disp_obj;
> +
> +	/* Convert time represention from jiffies to timeval */
> +	jiffies_to_timeval(jiffies_time, &timevalue);

Please use ktime_get_ts() or ktime_get_real_ts() to get the timestamp.

> +	for (i = 0; i < VPBE_DISPLAY_MAX_DEVICES; i++) {
> +		layer = disp_dev->dev[i];
> +		/* If streaming is started in this layer */
> +		if (!layer->started)
> +			continue;
> +		/* Check the field format */
> +		if ((V4L2_FIELD_NONE == layer->pix_fmt.field) &&
> +		    (event & OSD_END_OF_FRAME)) {
> +			/* Progressive mode */
> +			if (layer_first_int[i]) {
> +				layer_first_int[i] = 0;
> +				continue;
> +			}
> +			/*
> +			 * Mark status of the cur_frm to
> +			 * done and unlock semaphore on it
> +			 */
> +
> +			if (layer->cur_frm != layer->next_frm) {
> +				layer->cur_frm->ts = timevalue;
> +				layer->cur_frm->state = VIDEOBUF_DONE;

Please use videobuf2.

> +				wake_up_interruptible(
> +					&layer->cur_frm->done);
> +				/* Make cur_frm pointing to next_frm */
> +				layer->cur_frm = layer->next_frm;
> +			}
> +			/* Get the next buffer from buffer queue */
> +			spin_lock(&disp_dev->dma_queue_lock);
> +			if (!list_empty(&layer->dma_queue)) {
> +				layer->next_frm =
> +				    list_entry(layer->dma_queue.next,
> +				       struct videobuf_buffer, queue);
> +				/* Remove that buffer from the buffer queue */
> +				list_del(&layer->next_frm->queue);

Do the next statements until the end of the if () {} block need to be 
protected by the spinlock ?

> +				/* Mark status of the buffer as active */
> +				layer->next_frm->state = VIDEOBUF_ACTIVE;
> +
> +				addr = videobuf_to_dma_contig(layer->next_frm);
> +				osd_device->ops.start_layer(osd_device,
> +						    layer->layer_info.id,
> +						    addr, disp_dev->cbcr_ofst);
> +			}
> +			spin_unlock(&disp_dev->dma_queue_lock);
> +		} else {
> +			/*
> +			 * Interlaced mode
> +			 * If it is first interrupt, ignore it
> +			 */
> +			if (layer_first_int[i]) {
> +				layer_first_int[i] = 0;
> +				return;
> +			}
> +
> +			layer->field_id ^= 1;
> +			if (event & OSD_FIRST_FIELD)
> +				fid = 0;
> +			else if (event & OSD_SECOND_FIELD)
> +				fid = 1;

Did you mean VENC_FIRST_FIELD and VENC_SECOND_FIELD ?

> +			else
> +				return;

I don't think this can happen.

> +
> +			/*
> +			 * If field id does not match with stored
> +			 * field id
> +			 */
> +			if (fid != layer->field_id) {
> +				/* Make them in sync */
> +				if (0 == fid)
> +					layer->field_id = fid;
> +
> +				return;
> +			}
> +			/*
> +			 * device field id and local field id are
> +			 * in sync. If this is even field
> +			 */
> +			if (0 == fid) {
> +				if (layer->cur_frm == layer->next_frm)
> +					continue;
> +				/*
> +				 * one frame is displayed If next frame is
> +				 * available, release cur_frm and move on
> +				 * copy frame display time
> +				 */
> +				layer->cur_frm->ts = timevalue;
> +				/* Change status of the cur_frm */
> +				layer->cur_frm->state = VIDEOBUF_DONE;
> +				/* unlock semaphore on cur_frm */
> +				wake_up_interruptible(&layer->cur_frm->done);
> +				/* Make cur_frm pointing to next_frm */
> +				layer->cur_frm = layer->next_frm;
> +			} else if (1 == fid) {	/* odd field */
> +
> +			  if (list_empty(&layer->dma_queue)
> +				    || (layer->cur_frm != layer->next_frm))
> +					continue;

Indentation is wrong here.

Doesn't the list_empty() check need to be protected by a spinlock ?

> +
> +				/*
> +				 * one field is displayed configure
> +				 * the next frame if it is available
> +				 * otherwise hold on current frame
> +				 * Get next from the buffer queue
> +				 */
> +				spin_lock(&disp_dev->dma_queue_lock);
> +				layer->next_frm = list_entry(
> +							layer->dma_queue.next,
> +							struct	videobuf_buffer,
> +							queue);
> +
> +				/* Remove that from the buffer queue */
> +				list_del(&layer->next_frm->queue);
> +

Do the next statements need to be protected by the spinlock ?

> +				/* Mark state of the frame to active */
> +				layer->next_frm->state = VIDEOBUF_ACTIVE;
> +				addr = videobuf_to_dma_contig(layer->next_frm);
> +				osd_device->ops.start_layer(osd_device,
> +						layer->layer_info.id,
> +						addr,
> +						disp_dev->cbcr_ofst);
> +				spin_unlock(&disp_dev->dma_queue_lock);
> +			}
> +		}
> +	}
> +}
> +
> +/* interrupt service routine */
> +static irqreturn_t venc_isr(int irq, void *arg)
> +{
> +	static unsigned last_event;
> +	unsigned event = 0;
> +
> +	if (venc_is_second_field())
> +		event |= VENC_SECOND_FIELD;
> +	else
> +		event |= VENC_FIRST_FIELD;
> +
> +	if (event == (last_event & ~VENC_END_OF_FRAME)) {
> +		/*
> +		* If the display is non-interlaced, then we need to flag the
> +		* end-of-frame event at every interrupt regardless of the
> +		* value of the FIDST bit.  We can conclude that the display is
> +		* non-interlaced if the value of the FIDST bit is unchanged
> +		* from the previous interrupt.
> +		*/

What about checking pix_fmt.field instead ?

> +		event |= VENC_END_OF_FRAME;
> +	} else if (event == VENC_SECOND_FIELD) {
> +		/* end-of-frame for interlaced display */
> +		event |= VENC_END_OF_FRAME;
> +	}
> +	last_event = event;
> +
> +	vpbe_display_isr(event, arg);
> +	return IRQ_HANDLED;
> +}

[snip]

> +static int vpbe_set_video_display_params(struct vpbe_display *disp_dev,
> +			struct vpbe_display_obj *layer)

This function seems to enable OSD. Shouldn't it be renamed it make that clear 
?

> +{
> +	struct osd_layer_config *cfg  = &layer->layer_info.config;
> +	unsigned long addr;
> +	int ret = 0;
> +
> +	addr = videobuf_to_dma_contig(layer->cur_frm);
> +	/* Set address in the display registers */
> +	osd_device->ops.start_layer(osd_device,
> +				    layer->layer_info.id,
> +				    addr,
> +				    disp_dev->cbcr_ofst);
> +
> +	ret = osd_device->ops.enable_layer(osd_device,
> +				layer->layer_info.id, 0);
> +	if (ret < 0) {
> +		v4l2_err(&vpbe_dev->v4l2_dev,
> +			"Error in enabling osd window layer 0\n");
> +		return -1;
> +	}
> +
> +	/* Enable the window */

Could you please explain how this work ? I fail to understand the relationship 
between layers, windows, OSD, ...

> +	layer->layer_info.enable = 1;
> +	if (cfg->pixfmt == PIXFMT_NV12) {
> +		struct vpbe_display_obj *otherlayer =
> +			_vpbe_display_get_other_win(disp_dev, layer);

The _vpbe_display_get_other_win() function returns a vpbe_display_obj that you 
call otherlayer. Is it a layer, a window or an 'obj' ? Please keep the code 
consistent and rename functions, types and variables where needed.

> +
> +		ret = osd_device->ops.enable_layer(osd_device,
> +				otherlayer->layer_info.id, 1);
> +		if (ret < 0) {
> +			v4l2_err(&vpbe_dev->v4l2_dev,
> +				"Error in enabling osd window layer 1\n");
> +			return -1;
> +		}
> +		otherlayer->layer_info.enable = 1;
> +	}
> +	return 0;
> +}
> +
> +static void
> +vpbe_disp_calculate_scale_factor(struct vpbe_display *disp_dev,
> +			struct vpbe_display_obj *layer,
> +			int expected_xsize, int expected_ysize)
> +{
> +	struct display_layer_info *layer_info = &layer->layer_info;
> +	struct v4l2_pix_format *pixfmt = &layer->pix_fmt;
> +	struct osd_layer_config *cfg  = &layer->layer_info.config;
> +	int h_scale = 0, v_scale = 0, h_exp = 0, v_exp = 0, temp;

Please split the variable declaration on multiple lines, this gets hard to 
read.

No need to initialize h_scale and v_scale to 0.

temp is a bad name.

> +	v4l2_std_id standard_id = vpbe_dev->current_timings.timings.std_id;
> +
> +	/*
> +	 * Application initially set the image format. Current display
> +	 * size is obtained from the vpbe display controller. expected_xsize
> +	 * and expected_ysize are set through S_CROP ioctl. Based on this,
> +	 * driver will calculate the scale factors for vertical and
> +	 * horizontal direction so that the image is displayed scaled
> +	 * and expanded. Application uses expansion to display the image
> +	 * in a square pixel. Otherwise it is displayed using displays
> +	 * pixel aspect ratio.It is expected that application chooses
> +	 * the crop coordinates for cropped or scaled display. if crop
> +	 * size is less than the image size, it is displayed cropped or
> +	 * it is displayed scaled and/or expanded.
> +	 *
> +	 * to begin with, set the crop window same as expected. Later we
> +	 * will override with scaled window size
> +	 */
> +
> +	cfg->xsize = pixfmt->width;
> +	cfg->ysize = pixfmt->height;
> +	layer_info->h_zoom = ZOOM_X1;	/* no horizontal zoom */
> +	layer_info->v_zoom = ZOOM_X1;	/* no horizontal zoom */
> +	layer_info->h_exp = H_EXP_OFF;	/* no horizontal zoom */
> +	layer_info->v_exp = V_EXP_OFF;	/* no horizontal zoom */
> +
> +	if (pixfmt->width < expected_xsize) {
> +		h_scale = vpbe_dev->current_timings.xres / pixfmt->width;
> +		if (h_scale < 2)
> +			h_scale = 1;
> +		else if (h_scale >= 4)
> +			h_scale = 4;
> +		else
> +			h_scale = 2;
> +		cfg->xsize *= h_scale;
> +		if (cfg->xsize < expected_xsize) {
> +			if ((standard_id & V4L2_STD_525_60) ||
> +			(standard_id & V4L2_STD_625_50)) {
> +				temp = (cfg->xsize *
> +					VPBE_DISPLAY_H_EXP_RATIO_N) /
> +					VPBE_DISPLAY_H_EXP_RATIO_D;
> +				if (temp <= expected_xsize) {
> +					h_exp = 1;
> +					cfg->xsize = temp;
> +				}
> +			}
> +		}
> +		if (h_scale == 2)
> +			layer_info->h_zoom = ZOOM_X2;
> +		else if (h_scale == 4)
> +			layer_info->h_zoom = ZOOM_X4;
> +		if (h_exp)
> +			layer_info->h_exp = H_EXP_9_OVER_8;
> +	} else {
> +		/* no scaling, only cropping. Set display area to crop area */
> +		cfg->xsize = expected_xsize;
> +	}
> +
> +	if (pixfmt->height < expected_ysize) {
> +		v_scale = expected_ysize / pixfmt->height;
> +		if (v_scale < 2)
> +			v_scale = 1;
> +		else if (v_scale >= 4)
> +			v_scale = 4;
> +		else
> +			v_scale = 2;
> +		cfg->ysize *= v_scale;
> +		if (cfg->ysize < expected_ysize) {
> +			if ((standard_id & V4L2_STD_625_50)) {
> +				temp = (cfg->ysize *
> +					VPBE_DISPLAY_V_EXP_RATIO_N) /
> +					VPBE_DISPLAY_V_EXP_RATIO_D;
> +				if (temp <= expected_ysize) {
> +					v_exp = 1;
> +					cfg->ysize = temp;
> +				}
> +			}
> +		}
> +		if (v_scale == 2)
> +			layer_info->v_zoom = ZOOM_X2;
> +		else if (v_scale == 4)
> +			layer_info->v_zoom = ZOOM_X4;
> +		if (v_exp)
> +			layer_info->h_exp = V_EXP_6_OVER_5;
> +	} else {
> +		/* no scaling, only cropping. Set display area to crop area */
> +		cfg->ysize = expected_ysize;
> +	}
> +	v4l2_dbg(1, debug, &vpbe_dev->v4l2_dev,
> +		"crop display xsize = %d, ysize = %d\n",
> +		cfg->xsize, cfg->ysize);
> +}
> +
> +static void vpbe_disp_adj_position(struct vpbe_display *disp_dev,
> +			struct vpbe_display_obj *layer,
> +			int top, int left)
> +{
> +	struct osd_layer_config *cfg = &layer->layer_info.config;
> +
> +	cfg->xpos = cfg->ypos = 0;

Please split this on two lines.

> +	if (left + cfg->xsize <= vpbe_dev->current_timings.xres)
> +		cfg->xpos = left;
> +	if (top + cfg->ysize <= vpbe_dev->current_timings.yres)
> +		cfg->ypos = top;

Shouldn't you set cfg->xpos to min(left, vpbe_dev->current_timings.xres - cfg-
>xsize) unconditionally instead ? Same for ypos.

> +	v4l2_dbg(1, debug, &vpbe_dev->v4l2_dev,
> +		"new xpos = %d, ypos = %d\n",
> +		cfg->xpos, cfg->ypos);
> +}
> +
> +static int vpbe_disp_check_window_params(struct vpbe_display *disp_dev,
> +			struct v4l2_rect *c)
> +{
> +	if ((c->width == 0) ||
> +	  ((c->width + c->left) > vpbe_dev->current_timings.xres) ||
> +	  (c->height == 0) || ((c->height + c->top) >
> +	  vpbe_dev->current_timings.yres)) {
> +		v4l2_err(&vpbe_dev->v4l2_dev, "Invalid crop values\n");
> +		return -1;
> +	}
> +	if ((c->height & 0x1) && (vpbe_dev->current_timings.interlaced)) {
> +		v4l2_err(&vpbe_dev->v4l2_dev,
> +		"window height must be even for interlaced display\n");
> +		return -1;
> +	}

Instead of returning an error when crop setting are invalid, you should adjust 
them are return the adjusted value to userspace.

> +	return 0;
> +}
> +
> +/**
> + * vpbe_try_format()
> + * If user application provides width and height, and have bytesperline
> set
> + * to zero, driver calculates bytesperline and sizeimage based on hardware
> + * limits. If application likes to add pads at the end of each line and
> + * end of the buffer , it can set bytesperline to line size and sizeimage
> to
> + * bytesperline * height of the buffer. If driver fills zero for active
> + * video width and height, and has requested user bytesperline and
> sizeimage,
> + * width and height is adjusted to maximum display limit or buffer width
> + * height which ever is lower

Filling width and height based on the bytesperline and sizeimage fields isn't 
a standard V4L2 behaviour. Do you have a use case for that ?

> + */
> +static int vpbe_try_format(struct vpbe_display *disp_dev,
> +			struct v4l2_pix_format *pixfmt, int check)
> +{
> +	int min_sizeimage, bpp, min_height = 1, min_width = 32,
> +		max_width, max_height, user_info = 0;

Split this please.

> +
> +	if ((pixfmt->pixelformat != V4L2_PIX_FMT_UYVY) &&
> +	    (pixfmt->pixelformat != V4L2_PIX_FMT_NV12))
> +		/* choose default as V4L2_PIX_FMT_UYVY */
> +		pixfmt->pixelformat = V4L2_PIX_FMT_UYVY;
> +
> +	/* Check the field format */
> +	if (pixfmt->field == V4L2_FIELD_ANY) {
> +		if (vpbe_dev->current_timings.interlaced)
> +			pixfmt->field = V4L2_FIELD_INTERLACED;
> +		else
> +			pixfmt->field = V4L2_FIELD_NONE;
> +	}
> +
> +	if (pixfmt->field == V4L2_FIELD_INTERLACED)
> +		min_height = 2;
> +
> +	if (pixfmt->pixelformat == V4L2_PIX_FMT_NV12)
> +		bpp = 1;
> +	else
> +		bpp = 2;
> +
> +	max_width = vpbe_dev->current_timings.xres;
> +	max_height = vpbe_dev->current_timings.yres;
> +
> +	min_width /= bpp;
> +
> +	if (!pixfmt->width && !pixfmt->bytesperline) {
> +		v4l2_err(&vpbe_dev->v4l2_dev, "bytesperline and width"
> +			" cannot be zero\n");
> +		return -EINVAL;

Don't fail, just set sane default values. This comment applies to the rest of 
the function as well.

> +	}
> +
> +	/* if user provided bytesperline, it must provide sizeimage as well */
> +	if (pixfmt->bytesperline && !pixfmt->sizeimage) {
> +		v4l2_err(&vpbe_dev->v4l2_dev,
> +			"sizeimage must be non zero, when user"
> +			" provides bytesperline\n");
> +		return -EINVAL;

If sizeimage is not provided, the driver should compute it.

> +	}
> +
> +	/* adjust bytesperline as per hardware - multiple of 32 */
> +	if (!pixfmt->width)
> +		pixfmt->width = pixfmt->bytesperline / bpp;
> +
> +	if (!pixfmt->bytesperline)
> +		pixfmt->bytesperline = pixfmt->width * bpp;
> +	else
> +		user_info = 1;
> +	pixfmt->bytesperline = ((pixfmt->bytesperline + 31) & ~31);
> +
> +	if (pixfmt->width < min_width) {
> +		if (check) {
> +			v4l2_err(&vpbe_dev->v4l2_dev,
> +				"height is less than minimum,"
> +				"input width = %d, min_width = %d\n",
> +				pixfmt->width, min_width);
> +			return -EINVAL;
> +		}
> +		pixfmt->width = min_width;
> +	}
> +
> +	if (pixfmt->width > max_width) {
> +		if (check) {
> +			v4l2_err(&vpbe_dev->v4l2_dev,
> +				"width is more than maximum,"
> +				"input width = %d, max_width = %d\n",
> +				pixfmt->width, max_width);
> +			return -EINVAL;
> +		}
> +		pixfmt->width = max_width;
> +	}
> +
> +	/*
> +	 * If height is zero, then atleast we need to have sizeimage
> +	 * to calculate height
> +	 */
> +	if (!pixfmt->height) {
> +		if (user_info) {
> +			if (pixfmt->pixelformat == V4L2_PIX_FMT_NV12) {
> +				/*
> +				 * for NV12 format, sizeimage is y-plane size
> +				 * + CbCr plane which is half of y-plane
> +				 */
> +				pixfmt->height = pixfmt->sizeimage /
> +						(pixfmt->bytesperline +
> +						(pixfmt->bytesperline >> 1));
> +			} else
> +				pixfmt->height = pixfmt->sizeimage/
> +						pixfmt->bytesperline;
> +		}
> +	}
> +
> +	if (pixfmt->height > max_height) {
> +		if (check && !user_info) {
> +			v4l2_err(&vpbe_dev->v4l2_dev,
> +				"height is more than maximum,"
> +				"input height = %d, max_height = %d\n",
> +				pixfmt->height, max_height);
> +			return -EINVAL;
> +		}
> +		pixfmt->height = max_height;
> +	}
> +
> +	if (pixfmt->height < min_height) {
> +		if (check && !user_info) {
> +			v4l2_err(&vpbe_dev->v4l2_dev,
> +				"width is less than minimum,"
> +				"input height = %d, min_height = %d\n",
> +				pixfmt->height, min_height);
> +			return -EINVAL;
> +		}
> +		pixfmt->height = min_width;
> +	}
> +
> +	/* if user has not provided bytesperline calculate it based on width */
> +	if (!user_info)
> +		pixfmt->bytesperline = (((pixfmt->width * bpp) + 31) & ~31);
> +
> +	if (pixfmt->pixelformat == V4L2_PIX_FMT_NV12)
> +		min_sizeimage = pixfmt->bytesperline * pixfmt->height +
> +				(pixfmt->bytesperline * pixfmt->height >> 1);
> +	else
> +		min_sizeimage = pixfmt->bytesperline * pixfmt->height;
> +
> +	if (pixfmt->sizeimage < min_sizeimage) {
> +		if (check && user_info) {
> +			v4l2_err(&vpbe_dev->v4l2_dev, "sizeimage is less, %d\n",
> +				min_sizeimage);
> +			return -EINVAL;
> +		}
> +		pixfmt->sizeimage = min_sizeimage;
> +	}
> +	return 0;
> +}

[snip]

> +static int vpbe_display_querycap(struct file *file, void  *priv,
> +			       struct v4l2_capability *cap)
> +{
> +	struct vpbe_fh *fh = file->private_data;
> +	struct vpbe_display_obj *layer = fh->layer;
> +
> +	v4l2_dbg(1, debug, &vpbe_dev->v4l2_dev,
> +		"VIDIOC_QUERYCAP, layer id = %d\n", layer->device_id);

Do you really need a debugging call here ?

> +	*cap = vpbe_display_videocap;
> +
> +	return 0;
> +}
> +
> +static int vpbe_display_s_crop(struct file *file, void *priv,
> +			     struct v4l2_crop *crop)
> +{
> +	int ret = 0;
> +	struct vpbe_fh *fh = file->private_data;
> +	struct vpbe_display_obj *layer = fh->layer;
> +	struct vpbe_display *disp_dev = video_drvdata(file);
> +	struct osd_layer_config *cfg = &layer->layer_info.config;
> +
> +	v4l2_dbg(1, debug, &vpbe_dev->v4l2_dev,
> +		"VIDIOC_S_CROP, layer id = %d\n", layer->device_id);
> +
> +	if (crop->type == V4L2_BUF_TYPE_VIDEO_OUTPUT) {

Do it the other way around. If crop->type != V4L2_BUF_TYPE_VIDEO_OUTPUT return 
an error. That will save an indentation level for the rest of the function. 
This comment appleis to the whole driver, you have several occurences of the 
same issue (such as in vpbe_display_g_crop()).

> +		struct v4l2_rect *rect = &crop->c;
> +
> +		if (rect->top < 0 || rect->left < 0) {
> +			v4l2_err(&vpbe_dev->v4l2_dev, "Error:S_CROP params\n");
> +			return -EINVAL;
> +		}

Don't fail, adjust the values.

> +
> +		if (vpbe_disp_check_window_params(disp_dev, rect)) {
> +			v4l2_err(&vpbe_dev->v4l2_dev, "Error:S_CROP params\n");
> +			return -EINVAL;
> +		}
> +		osd_device->ops.get_layer_config(osd_device,
> +				layer->layer_info.id, cfg);
> +
> +		vpbe_disp_calculate_scale_factor(disp_dev, layer,
> +						rect->width,
> +						rect->height);
> +		vpbe_disp_adj_position(disp_dev, layer, rect->top,
> +						rect->left);
> +		ret = osd_device->ops.set_layer_config(osd_device,
> +					layer->layer_info.id, cfg);
> +		if (ret < 0) {
> +			v4l2_err(&vpbe_dev->v4l2_dev,
> +				"Error in set layer config:\n");
> +			return -EINVAL;
> +		}
> +
> +		/* apply zooming and h or v expansion */
> +		osd_device->ops.set_zoom(osd_device,
> +				layer->layer_info.id,
> +				layer->layer_info.h_zoom,
> +				layer->layer_info.v_zoom);
> +		ret = osd_device->ops.set_vid_expansion(osd_device,
> +				layer->layer_info.h_exp,
> +				layer->layer_info.v_exp);
> +		if (ret < 0) {
> +			v4l2_err(&vpbe_dev->v4l2_dev,
> +			"Error in set vid expansion:\n");
> +			return -EINVAL;
> +		}
> +
> +		if ((layer->layer_info.h_zoom != ZOOM_X1) ||
> +			(layer->layer_info.v_zoom != ZOOM_X1) ||
> +			(layer->layer_info.h_exp != H_EXP_OFF) ||
> +			(layer->layer_info.v_exp != V_EXP_OFF))
> +			/* Enable expansion filter */
> +			osd_device->ops.set_interpolation_filter(osd_device, 1);
> +		else
> +			osd_device->ops.set_interpolation_filter(osd_device, 0);
> +
> +	} else {
> +		v4l2_err(&vpbe_dev->v4l2_dev, "Invalid buf type\n");
> +		return -EINVAL;
> +	}
> +
> +	return ret;
> +}

[snip]

> +static int vpbe_display_g_fmt(struct file *file, void *priv,
> +				struct v4l2_format *fmt)
> +{
> +	struct vpbe_fh *fh = file->private_data;
> +	struct vpbe_display_obj *layer = fh->layer;
> +
> +	v4l2_dbg(1, debug, &vpbe_dev->v4l2_dev,
> +			"VIDIOC_G_FMT, layer id = %d\n",
> +			layer->device_id);
> +
> +	/* If buffer type is video output */
> +	if (V4L2_BUF_TYPE_VIDEO_OUTPUT == fmt->type) {
> +		struct v4l2_pix_format *pixfmt = &fmt->fmt.pix;
> +		/* Fill in the information about format */
> +		*pixfmt = layer->pix_fmt;

I don't see anything wrong in doing

fmt->fmt.pix = layer->pix_fmt;

directly.

> +	} else {
> +		v4l2_err(&vpbe_dev->v4l2_dev, "invalid type\n");
> +		return -EINVAL;
> +	}
> +
> +	return 0;
> +}
> +
> +static int vpbe_display_enum_fmt(struct file *file, void  *priv,
> +				   struct v4l2_fmtdesc *fmt)
> +{
> +	struct vpbe_fh *fh = file->private_data;
> +	struct vpbe_display_obj *layer = fh->layer;
> +	unsigned int index = 0;
> +
> +	v4l2_dbg(1, debug, &vpbe_dev->v4l2_dev,
> +				"VIDIOC_ENUM_FMT, layer id = %d\n",
> +				layer->device_id);
> +	if (fmt->index > 0) {

You support two formats below, should this be fmt->index > 1 ?

> +		v4l2_err(&vpbe_dev->v4l2_dev, "Invalid format index\n");
> +		return -EINVAL;
> +	}
> +
> +	/* Fill in the information about format */
> +	index = fmt->index;
> +	memset(fmt, 0, sizeof(*fmt));
> +	fmt->index = index;
> +	fmt->type = V4L2_BUF_TYPE_VIDEO_OUTPUT;
> +	if (index == 0) {
> +		strcpy(fmt->description, "YUV 4:2:2 - UYVY");
> +		fmt->pixelformat = V4L2_PIX_FMT_UYVY;
> +	} else if (index == 1) {

A simple else will be enough.

> +		strcpy(fmt->description, "Y/CbCr 4:2:0");
> +		fmt->pixelformat = V4L2_PIX_FMT_NV12;
> +	}
> +	return 0;
> +}
> +
> +static int vpbe_display_s_fmt(struct file *file, void *priv,
> +				struct v4l2_format *fmt)
> +{
> +	int ret = 0;

No need to initialize ret to 0.

> +	struct vpbe_fh *fh = file->private_data;
> +	struct vpbe_display *disp_dev = video_drvdata(file);
> +	struct vpbe_display_obj *layer = fh->layer;
> +	struct osd_layer_config *cfg  = &layer->layer_info.config;

Variables are often declared in longuest to shortest line order in kernel 
drivers. It might not be a requirement though, but I find it to make code more 
readable.

> +
> +	v4l2_dbg(1, debug, &vpbe_dev->v4l2_dev,
> +			"VIDIOC_S_FMT, layer id = %d\n",
> +			layer->device_id);
> +
> +	/* If streaming is started, return error */
> +	if (layer->started) {

I'm pretty sure there's a race condition here.

> +		v4l2_err(&vpbe_dev->v4l2_dev, "Streaming is started\n");
> +		return -EBUSY;
> +	}
> +	if (V4L2_BUF_TYPE_VIDEO_OUTPUT != fmt->type) {
> +		v4l2_dbg(1, debug, &vpbe_dev->v4l2_dev, "invalid type\n");
> +		return -EINVAL;
> +	} else {

No need for an else as the first branch of the if returns.

> +		struct v4l2_pix_format *pixfmt = &fmt->fmt.pix;
> +		/* Check for valid pixel format */
> +		ret = vpbe_try_format(disp_dev, pixfmt, 1);
> +		if (ret)
> +			return ret;
> +
> +		/* YUV420 is requested, check availability of the
> +		other video window */
> +
> +		layer->pix_fmt = *pixfmt;

There's probably a race condition here as well if two applications (or 
threads) call S_FMT at the same time.

> +
> +		/* Get osd layer config */
> +		osd_device->ops.get_layer_config(osd_device,
> +				layer->layer_info.id, cfg);
> +		/* Store the pixel format in the layer object */
> +		cfg->xsize = pixfmt->width;
> +		cfg->ysize = pixfmt->height;
> +		cfg->line_length = pixfmt->bytesperline;
> +		cfg->ypos = 0;
> +		cfg->xpos = 0;
> +		cfg->interlaced = vpbe_dev->current_timings.interlaced;
> +
> +		/* Change of the default pixel format for both video windows */
> +		if (V4L2_PIX_FMT_NV12 == pixfmt->pixelformat) {
> +			struct vpbe_display_obj *otherlayer;

If the requested format isn't NV12, cfg->pixfmt won't be modified. If it has 
been set to NV12 by a previous S_FMT call, it won't become YUYV. Is that 
intentional ?

> +			cfg->pixfmt = PIXFMT_NV12;
> +			otherlayer = _vpbe_display_get_other_win(disp_dev,
> +								 layer);
> +			otherlayer->layer_info.config.pixfmt = PIXFMT_NV12;
> +		}
> +
> +		/* Set the layer config in the osd window */
> +		ret = osd_device->ops.set_layer_config(osd_device,
> +					layer->layer_info.id, cfg);
> +		if (ret < 0) {
> +			v4l2_err(&vpbe_dev->v4l2_dev,
> +				 "Error in S_FMT params:\n");
> +			return -EINVAL;
> +		}
> +
> +		/* Readback and fill the local copy of current pix format */
> +		osd_device->ops.get_layer_config(osd_device,
> +				layer->layer_info.id, cfg);
> +
> +		/* verify if readback values are as expected */
> +		if (layer->pix_fmt.width != cfg->xsize ||
> +			layer->pix_fmt.height != cfg->ysize ||
> +			layer->pix_fmt.bytesperline != layer->layer_info.
> +			config.line_length || (cfg->interlaced &&
> +			layer->pix_fmt.field != V4L2_FIELD_INTERLACED) ||
> +			(!cfg->interlaced && layer->pix_fmt.field !=
> +			V4L2_FIELD_NONE)) {
> +			v4l2_err(&vpbe_dev->v4l2_dev,
> +				 "mismatch:layer conf params:\n");
> +			return -EINVAL;

Can this happen ? If so, why ?

> +		}
> +	}
> +
> +	return 0;
> +}
> +
> +static int vpbe_display_try_fmt(struct file *file, void *priv,
> +				  struct v4l2_format *fmt)
> +{
> +	struct vpbe_display *disp_dev = video_drvdata(file);
> +
> +	v4l2_dbg(1, debug, &vpbe_dev->v4l2_dev, "VIDIOC_TRY_FMT\n");
> +
> +	if (V4L2_BUF_TYPE_VIDEO_OUTPUT == fmt->type) {
> +		struct v4l2_pix_format *pixfmt = &fmt->fmt.pix;
> +		/* Check for valid field format */
> +		return  vpbe_try_format(disp_dev, pixfmt, 0);

Other way around here as well please. Return an error if the type is not 
correct, and continue otherwise.

> +	}
> +	v4l2_err(&vpbe_dev->v4l2_dev, "invalid type\n");
> +	return -EINVAL;
> +}
> +
> +/**
> + * vpbe_display_s_std - Set the given standard in the encoder
> + *
> + * Sets the standard if supported by the current encoder. Return the
> status. + * 0 - success & -EINVAL on error
> + */
> +static int vpbe_display_s_std(struct file *file, void *priv,
> +				v4l2_std_id *std_id)
> +{
> +	struct vpbe_fh *fh = priv;
> +	struct vpbe_display_obj *layer = fh->layer;
> +	int ret = 0;
> +
> +	v4l2_dbg(1, debug, &vpbe_dev->v4l2_dev, "VIDIOC_S_STD\n");
> +
> +	/* If streaming is started, return error */
> +	if (layer->started) {

Race condition here too.

> +		v4l2_err(&vpbe_dev->v4l2_dev, "Streaming is started\n");
> +		return -EBUSY;
> +	}
> +	if (NULL != vpbe_dev->ops.s_std) {
> +		ret = vpbe_dev->ops.s_std(vpbe_dev, std_id);
> +		if (ret) {
> +			v4l2_err(&vpbe_dev->v4l2_dev,
> +			"Failed to set standard for sub devices\n");
> +			return -EINVAL;
> +		}
> +	}
> +	return 0;
> +}
> +
> +/**
> + * vpbe_display_g_std - Get the standard in the current encoder
> + *
> + * Get the standard in the current encoder. Return the status. 0 - success
> + * -EINVAL on error
> + */
> +static int vpbe_display_g_std(struct file *file, void *priv,
> +				v4l2_std_id *std_id)
> +{
> +	v4l2_dbg(1, debug, &vpbe_dev->v4l2_dev,	"VIDIOC_G_STD\n");
> +
> +	/* Get the standard from the current encoder */
> +	if (vpbe_dev->current_timings.timings_type & VPBE_ENC_STD) {
> +		*std_id = vpbe_dev->current_timings.timings.std_id;
> +		return 0;
> +	}
> +	return -EINVAL;

Where do you set timings_type ? When can this return an error ?

> +}
> +
> +/**
> + * vpbe_display_enum_output - enumerate outputs
> + *
> + * Enumerates the outputs available at the vpbe display
> + * returns the status, -EINVAL if end of output list
> + */
> +static int vpbe_display_enum_output(struct file *file, void *priv,
> +				    struct v4l2_output *output)
> +{
> +	int ret = 0;
> +
> +	v4l2_dbg(1, debug, &vpbe_dev->v4l2_dev,	"VIDIOC_ENUM_OUTPUT\n");
> +
> +	/* Enumerate outputs */
> +
> +	if (NULL != vpbe_dev->ops.enum_outputs) {
> +		ret = vpbe_dev->ops.enum_outputs(vpbe_dev, output);
> +		if (ret) {
> +			v4l2_dbg(1, debug, &vpbe_dev->v4l2_dev,
> +				"Failed to enumerate outputs\n");
> +			return -EINVAL;
> +		}
> +	}
> +	return 0;

Shouldn't this return an error if there's no enum_outputs operation ?

> +}
> +
> +/**
> + * vpbe_display_s_output - Set output to
> + * the output specified by the index
> + */
> +static int vpbe_display_s_output(struct file *file, void *priv,
> +				unsigned int i)
> +{
> +	struct vpbe_fh *fh = priv;
> +	struct vpbe_display_obj *layer = fh->layer;
> +	int ret = 0;
> +
> +	v4l2_dbg(1, debug, &vpbe_dev->v4l2_dev,	"VIDIOC_S_OUTPUT\n");
> +	/* If streaming is started, return error */
> +	if (layer->started) {

Race condition.

> +		v4l2_err(&vpbe_dev->v4l2_dev, "Streaming is started\n");
> +		return -EBUSY;
> +	}
> +	if (NULL != vpbe_dev->ops.set_output) {
> +		ret = vpbe_dev->ops.set_output(vpbe_dev, i);
> +		if (ret) {
> +			v4l2_err(&vpbe_dev->v4l2_dev,
> +				"Failed to set output for sub devices\n");
> +			return -EINVAL;
> +		}
> +	}
> +	return ret;

Shouldn't this return an error if there's no set_output operation ?

> +}

[snip]

> +static int vpbe_display_cfg_layer_default(enum vpbe_display_device_id id,
> +			struct vpbe_display *disp_dev)
> +{
> +	int err = 0;

No need to initialize err to 0.

> +	struct osd_layer_config *layer_config;
> +	struct vpbe_display_obj *layer = disp_dev->dev[id];
> +	struct osd_layer_config *cfg  = &layer->layer_info.config;
> +
> +	/* First claim the layer for this device */
> +	err = osd_device->ops.request_layer(osd_device,
> +					    layer->layer_info.id);
> +	if (err < 0) {
> +		/* Couldn't get layer */
> +		v4l2_err(&vpbe_dev->v4l2_dev,
> +			"Display Manager failed to allocate layer\n");
> +		return -EBUSY;
> +	}
> +
> +	layer_config = cfg;
> +	/* Set the default image and crop values */
> +	layer_config->pixfmt = PIXFMT_YCbCrI;
> +	layer->pix_fmt.pixelformat = V4L2_PIX_FMT_UYVY;
> +	layer->pix_fmt.bytesperline = layer_config->line_length =
> +	    vpbe_dev->current_timings.xres * 2;
> +
> +	layer->pix_fmt.width = layer_config->xsize =
> +		vpbe_dev->current_timings.xres;
> +	layer->pix_fmt.height = layer_config->ysize =
> +		vpbe_dev->current_timings.yres;
> +	layer->pix_fmt.sizeimage =
> +		layer->pix_fmt.bytesperline * layer->pix_fmt.height;
> +	layer_config->xpos = 0;
> +	layer_config->ypos = 0;
> +	layer_config->interlaced = vpbe_dev->current_timings.interlaced;

You shouldn't reinitialized the format every time the device is opened. The 
previously set format should be kept.

> +
> +	/*
> +	 * turn off ping-pong buffer and field inversion to fix
> +	 * the image shaking problem in 1080I mode
> +	 */
> +
> +	if (cfg->interlaced)
> +		layer->pix_fmt.field = V4L2_FIELD_INTERLACED;
> +	else
> +		layer->pix_fmt.field = V4L2_FIELD_NONE;
> +
> +	err = osd_device->ops.set_layer_config(osd_device,
> +				layer->layer_info.id,
> +				layer_config);
> +	if (err < 0) {
> +		/* Couldn't set layer */
> +		v4l2_err(&vpbe_dev->v4l2_dev,
> +			"Display Manager failed to set osd layer\n");
> +		return -EBUSY;
> +	}
> +
> +	return 0;
> +}
> +
> +/*
> + * vpbe_display_open()
> + * It creates object of file handle structure and stores it in
> private_data + * member of filepointer
> + */
> +static int vpbe_display_open(struct file *file)
> +{
> +	int minor = iminor(file->f_path.dentry->d_inode);
> +	struct vpbe_display *disp_dev = video_drvdata(file);
> +	struct vpbe_display_obj *layer;
> +	struct vpbe_fh *fh = NULL;
> +	int found = -1;
> +	int i = 0;
> +
> +	/* Check for valid minor number */
> +	for (i = 0; i < VPBE_DISPLAY_MAX_DEVICES; i++) {
> +		/* Get the pointer to the layer object */
> +		layer = disp_dev->dev[i];
> +		if (minor == layer->video_dev->minor) {
> +			found = i;
> +			break;
> +		}
> +	}

Don't rely on minors, store the vpbe_display_obj object into the video device 
private data using video_set_drvdata() at registration time, and retrieve it 
here with video_drvdata().

> +
> +	/* If not found, return error no device */
> +	if (0 > found) {
> +		v4l2_err(&vpbe_dev->v4l2_dev, "device not found\n");
> +		return -ENODEV;
> +	}
> +
> +	/* Allocate memory for the file handle object */
> +	fh = kmalloc(sizeof(struct vpbe_fh), GFP_KERNEL);
> +	if (fh == NULL) {
> +		v4l2_err(&vpbe_dev->v4l2_dev,
> +			"unable to allocate memory for file handle object\n");
> +		return -ENOMEM;
> +	}
> +	v4l2_dbg(1, debug, &vpbe_dev->v4l2_dev,
> +			"vpbe display open plane = %d\n",
> +			layer->device_id);
> +
> +	/* store pointer to fh in private_data member of filep */
> +	file->private_data = fh;
> +	fh->layer = layer;
> +	fh->disp_dev = disp_dev;
> +
> +	if (!layer->usrs) {
> +		/* Configure the default values for the layer */
> +		if (vpbe_display_cfg_layer_default(layer->device_id,
> +						disp_dev)) {
> +			v4l2_err(&vpbe_dev->v4l2_dev,
> +				"Unable to configure video layer"
> +				" for id = %d\n", layer->device_id);
> +			return -EINVAL;

Memory leak, you need to free fh.

> +		}
> +	}
> +	/* Increment layer usrs counter */
> +	layer->usrs++;

Race condition.

> +	/* Set io_allowed member to false */
> +	fh->io_allowed = 0;
> +	/* Initialize priority of this instance to default priority */
> +	fh->prio = V4L2_PRIORITY_UNSET;
> +	v4l2_prio_open(&layer->prio, &fh->prio);
> +	v4l2_dbg(1, debug, &vpbe_dev->v4l2_dev,
> +			"vpbe display device opened successfully\n");
> +	return 0;
> +}
> +
> +/*
> + * vpbe_display_release()
> + * This function deletes buffer queue, frees the buffers and the davinci
> + * display file * handle
> + */
> +static int vpbe_display_release(struct file *file)
> +{
> +	/* Get the layer object and file handle object */
> +	struct vpbe_fh *fh = file->private_data;
> +	struct vpbe_display_obj *layer = fh->layer;
> +	struct osd_layer_config *cfg  = &layer->layer_info.config;
> +	struct vpbe_display *disp_dev = video_drvdata(file);
> +
> +	v4l2_dbg(1, debug, &vpbe_dev->v4l2_dev, "vpbe_display_release\n");
> +	/* If this is doing IO and other layer are not closed */
> +	if ((layer->usrs != 1) && fh->io_allowed) {
> +		v4l2_err(&vpbe_dev->v4l2_dev, "Close other instances\n");
> +		return -EAGAIN;

Don't do that. You can't deny a close() call because other file handles are 
still present. You need to handle that inside the driver.

> +	}
> +
> +	/* if this instance is doing IO */
> +	if (fh->io_allowed) {
> +		/* Reset io_usrs member of layer object */
> +		layer->io_usrs = 0;
> +
> +		osd_device->ops.disable_layer(osd_device,
> +				layer->layer_info.id);
> +		layer->started = 0;
> +		/* Free buffers allocated */
> +		videobuf_queue_cancel(&layer->buffer_queue);
> +		videobuf_mmap_free(&layer->buffer_queue);
> +	}
> +
> +	/* Decrement layer usrs counter */
> +	layer->usrs--;
> +	/* If this file handle has initialize encoder device, reset it */
> +	if (!layer->usrs) {
> +		if (cfg->pixfmt == PIXFMT_NV12) {
> +			struct vpbe_display_obj *otherlayer;
> +			otherlayer =
> +			_vpbe_display_get_other_win(disp_dev, layer);
> +			osd_device->ops.disable_layer(osd_device,
> +					otherlayer->layer_info.id);
> +			osd_device->ops.release_layer(osd_device,
> +					otherlayer->layer_info.id);
> +		}
> +		osd_device->ops.disable_layer(osd_device,
> +				layer->layer_info.id);
> +		osd_device->ops.release_layer(osd_device,
> +				layer->layer_info.id);
> +	}
> +	/* Close the priority */
> +	v4l2_prio_close(&layer->prio, fh->prio);
> +	file->private_data = NULL;
> +
> +	/* Free memory allocated to file handle object */
> +	kfree(fh);
> +
> +	disp_dev->cbcr_ofst = 0;
> +
> +	return 0;
> +}

[snip]

> +/*
> + * vpbe_display_probe()
> + * This function creates device entries by register itself to the V4L2
> driver + * and initializes fields of each layer objects
> + */
> +static __devinit int vpbe_display_probe(struct platform_device *pdev)
> +{
> +	int i, j = 0, k, err = 0;
> +	struct vpbe_display *disp_dev;
> +	struct video_device *vbd = NULL;
> +	struct vpbe_display_obj *vpbe_display_layer = NULL;
> +	struct resource *res;
> +	int irq;
> +
> +	printk(KERN_DEBUG "vpbe_display_probe\n");
> +
> +	/* Allocate memory for vpbe_display */
> +	disp_dev = kzalloc(sizeof(struct vpbe_display), GFP_KERNEL);
> +	if (!disp_dev) {
> +		printk(KERN_ERR "ran out of memory\n");
> +		return -ENOMEM;
> +	}
> +
> +	/* Allocate memory for four plane display objects */
> +	for (i = 0; i < VPBE_DISPLAY_MAX_DEVICES; i++) {
> +		disp_dev->dev[i] =
> +		    kmalloc(sizeof(struct vpbe_display_obj), GFP_KERNEL);
> +		/* If memory allocation fails, return error */
> +		if (!disp_dev->dev[i]) {
> +			printk(KERN_ERR "ran out of memory\n");
> +			err = -ENOMEM;
> +			goto probe_out;
> +		}
> +		spin_lock_init(&disp_dev->dev[i]->irqlock);
> +		mutex_init(&disp_dev->dev[i]->opslock);
> +	}
> +	spin_lock_init(&disp_dev->dma_queue_lock);
> +
> +	err = init_vpbe_layer_objects(i);
> +	if (err) {
> +		printk(KERN_ERR "Error initializing vpbe display\n");
> +		return err;
> +	}
> +
> +	/*
> +	 * Scan all the platform devices to find the vpbe
> +	 * controller device and get the vpbe_dev object
> +	 */
> +	err = bus_for_each_dev(&platform_bus_type, NULL, NULL,
> +			vpbe_device_get);
> +	if (err < 0)
> +		return err;
> +
> +	/* Initialize the vpbe display controller */
> +	if (NULL != vpbe_dev->ops.initialize) {
> +		err = vpbe_dev->ops.initialize(&pdev->dev, vpbe_dev);
> +		if (err) {
> +			v4l2_err(&vpbe_dev->v4l2_dev, "Error initing vpbe\n");
> +			err = -ENOMEM;
> +			goto probe_out;
> +		}
> +	}
> +
> +	/* check the name of davinci device */
> +	if (vpbe_dev->cfg->module_name != NULL)
> +		strcpy(vpbe_display_videocap.card,
> +			vpbe_dev->cfg->module_name);
> +
> +	for (i = 0; i < VPBE_DISPLAY_MAX_DEVICES; i++) {

Please move the content of this loop to a separate function (but not the loop 
itself), it will make the code more readable.

> +		/* Get the pointer to the layer object */
> +		vpbe_display_layer = disp_dev->dev[i];
> +		/* Allocate memory for video device */
> +		vbd = video_device_alloc();
> +		if (vbd == NULL) {
> +			for (j = 0; j < i; j++) {
> +				video_device_release(
> +				disp_dev->dev[j]->video_dev);
> +			}
> +			v4l2_err(&vpbe_dev->v4l2_dev, "ran out of memory\n");
> +			err = -ENOMEM;
> +			goto probe_out;
> +		}
> +		/* Initialize field of video device */
> +		vbd->release	= video_device_release;
> +		vbd->fops	= &vpbe_fops;
> +		vbd->ioctl_ops	= &vpbe_ioctl_ops;
> +		vbd->minor	= -1;
> +		vbd->v4l2_dev   = &vpbe_dev->v4l2_dev;
> +		vbd->lock	= &vpbe_display_layer->opslock;
> +
> +		if (vpbe_dev->current_timings.timings_type & VPBE_ENC_STD) {
> +			vbd->tvnorms	= (V4L2_STD_525_60 | V4L2_STD_625_50);
> +			vbd->current_norm =
> +				vpbe_dev->current_timings.timings.std_id;
> +		} else
> +			vbd->current_norm = 0;
> +
> +		snprintf(vbd->name, sizeof(vbd->name),
> +			 "DaVinci_VPBE Display_DRIVER_V%d.%d.%d",
> +			 (VPBE_DISPLAY_VERSION_CODE >> 16) & 0xff,
> +			 (VPBE_DISPLAY_VERSION_CODE >> 8) & 0xff,
> +			 (VPBE_DISPLAY_VERSION_CODE) & 0xff);
> +
> +		/* Set video_dev to the video device */
> +		vpbe_display_layer->video_dev = vbd;
> +		vpbe_display_layer->device_id = i;
> +
> +		vpbe_display_layer->layer_info.id =
> +		    ((i == VPBE_DISPLAY_DEVICE_0) ? WIN_VID0 : WIN_VID1);
> +		if (display_buf_config_params.numbuffers[i] == 0)
> +			vpbe_display_layer->memory = V4L2_MEMORY_USERPTR;
> +		else
> +			vpbe_display_layer->memory = V4L2_MEMORY_MMAP;
> +
> +		/* Initialize field of the display layer objects */
> +		vpbe_display_layer->usrs = 0;
> +		vpbe_display_layer->io_usrs = 0;
> +		vpbe_display_layer->started = 0;
> +
> +		/* Initialize prio member of layer object */
> +		v4l2_prio_init(&vpbe_display_layer->prio);
> +
> +		/* Register video device */
> +		v4l2_info(&vpbe_dev->v4l2_dev,
> +		       "Trying to register VPBE display device.\n");
> +		v4l2_info(&vpbe_dev->v4l2_dev,
> +				"layer=%x,layer->video_dev=%x\n",
> +				(int)vpbe_display_layer,
> +				(int)&vpbe_display_layer->video_dev);
> +
> +		err = video_register_device(vpbe_display_layer->
> +					    video_dev,
> +					    VFL_TYPE_GRABBER,
> +					    vpbe_display_nr[i]);
> +		if (err)
> +			goto probe_out;
> +		/* set the driver data in platform device */
> +		platform_set_drvdata(pdev, disp_dev);
> +		video_set_drvdata(vpbe_display_layer->video_dev, disp_dev);
> +	}
> +
> +	res = platform_get_resource(pdev, IORESOURCE_IRQ, 0);
> +	if (!res) {
> +		v4l2_err(&vpbe_dev->v4l2_dev,
> +			 "Unable to get VENC interrupt resource\n");
> +		err = -ENODEV;
> +		goto probe_out;
> +	}
> +	irq = res->start;
> +	if (request_irq(irq, venc_isr,  IRQF_DISABLED, VPBE_DISPLAY_DRIVER,
> +		disp_dev)) {
> +		v4l2_err(&vpbe_dev->v4l2_dev, "Unable to request interrupt\n");
> +		err = -ENODEV;
> +		goto probe_out;
> +	}

You probably want to get the resources and register the interrupt handler 
before registering the V4L2 devices, otherwise userspace will be able to open 
devices before you're done with the initialization.

> +	printk(KERN_DEBUG "Successfully completed the probing of vpbe v4l2
> device\n"); +	return 0;
> +probe_out:
> +	kfree(disp_dev);
> +
> +	for (k = 0; k < j; k++) {
> +		/* Get the pointer to the layer object */
> +		vpbe_display_layer = disp_dev->dev[k];
> +		/* Unregister video device */
> +		video_unregister_device(vpbe_display_layer->video_dev);
> +		/* Release video device */
> +		video_device_release(vpbe_display_layer->video_dev);
> +		vpbe_display_layer->video_dev = NULL;
> +	}
> +	return err;
> +}

[snip]

> +MODULE_DESCRIPTION("TI DMXXX VPBE Display controller");

Should this be "TI DM644x" instead ?

> +MODULE_LICENSE("GPL");
> +MODULE_AUTHOR("Texas Instruments");


> diff --git a/include/media/davinci/vpbe_display.h
> b/include/media/davinci/vpbe_display.h new file mode 100644
> index 0000000..d5cce40
> --- /dev/null
> +++ b/include/media/davinci/vpbe_display.h
> @@ -0,0 +1,146 @@
> +/*
> + * Copyright (C) 2010 Texas Instruments Incorporated - http://www.ti.com/
> + *
> + * This program is free software; you can redistribute it and/or
> + * modify it under the terms of the GNU General Public License as
> + * published by the Free Software Foundation version 2.
> + *
> + * This program is distributed WITHOUT ANY WARRANTY of any
> + * kind, whether express or implied; without even the implied warranty
> + * of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + * GNU General Public License for more details.
> + */
> +#ifndef VPBE_DISPLAY_H
> +#define VPBE_DISPLAY_H
> +
> +#ifdef __KERNEL__

This is a kernel header, you don't need to guard it with #ifdef __KERNEL__

> +
> +/* Header files */
> +#include <linux/videodev2.h>
> +#include <media/v4l2-common.h>
> +#include <media/videobuf-dma-contig.h>
> +#include <media/davinci/vpbe_types.h>
> +#include <media/davinci/vpbe_osd.h>
> +#include <media/davinci/vpbe.h>
> +
> +#define VPBE_DISPLAY_MAX_DEVICES 2
> +
> +enum vpbe_display_device_id {
> +	VPBE_DISPLAY_DEVICE_0,
> +	VPBE_DISPLAY_DEVICE_1
> +};
> +
> +#define VPBE_DISPLAY_DRV_NAME	"vpbe-display"
> +
> +#define VPBE_DISPLAY_MAJOR_RELEASE              1
> +#define VPBE_DISPLAY_MINOR_RELEASE              0
> +#define VPBE_DISPLAY_BUILD                      1
> +#define VPBE_DISPLAY_VERSION_CODE ((VPBE_DISPLAY_MAJOR_RELEASE << 16) | \
> +	(VPBE_DISPLAY_MINOR_RELEASE << 8)  | \
> +	VPBE_DISPLAY_BUILD)
> +
> +#define VPBE_DISPLAY_VALID_FIELD(field)   ((V4L2_FIELD_NONE == field) || \
> +	 (V4L2_FIELD_ANY == field) || (V4L2_FIELD_INTERLACED == field))
> +
> +/* Exp ratio numerator and denominator constants */
> +#define VPBE_DISPLAY_H_EXP_RATIO_N   (9)
> +#define VPBE_DISPLAY_H_EXP_RATIO_D   (8)
> +#define VPBE_DISPLAY_V_EXP_RATIO_N   (6)
> +#define VPBE_DISPLAY_V_EXP_RATIO_D   (5)
> +
> +/* Zoom multiplication factor */
> +#define VPBE_DISPLAY_ZOOM_4X (4)
> +#define VPBE_DISPLAY_ZOOM_2X (2)

No need for () around the constants.

> +
> +/* Structures */
> +struct display_layer_info {
> +	int enable;
> +	/* Layer ID used by Display Manager */
> +	enum osd_layer id;
> +	struct osd_layer_config config;
> +	enum osd_zoom_factor h_zoom;
> +	enum osd_zoom_factor v_zoom;
> +	enum osd_h_exp_ratio h_exp;
> +	enum osd_v_exp_ratio v_exp;
> +};
> +
> +/* vpbe display object structure */
> +struct vpbe_display_obj {
> +	/* number of buffers in fbuffers */
> +	unsigned int numbuffers;
> +	/* Pointer pointing to current v4l2_buffer */
> +	struct videobuf_buffer *cur_frm;
> +	/* Pointer pointing to next v4l2_buffer */
> +	struct videobuf_buffer *next_frm;
> +	/* videobuf specific parameters
> +	 * Buffer queue used in video-buf
> +	 */
> +	struct videobuf_queue buffer_queue;
> +	/* Queue of filled frames */
> +	struct list_head dma_queue;
> +	/* Used in video-buf */
> +	spinlock_t irqlock;
> +	/* V4l2 specific parameters */
> +	/* Identifies video device for this layer */
> +	struct video_device *video_dev;
> +	/* This field keeps track of type of buffer exchange mechanism user
> +	 * has selected
> +	 */
> +	enum v4l2_memory memory;
> +	/* Used to keep track of state of the priority */
> +	struct v4l2_prio_state prio;
> +	/* Used to store pixel format */
> +	struct v4l2_pix_format pix_fmt;
> +	enum v4l2_field buf_field;
> +	/* Video layer configuration params */
> +	struct display_layer_info layer_info;
> +	/* vpbe specific parameters
> +	 * enable window for display
> +	 */
> +	unsigned char window_enable;
> +	/* number of open instances of the layer */
> +	unsigned int usrs;
> +	/* number of users performing IO */
> +	unsigned int io_usrs;
> +	/* Indicates id of the field which is being displayed */
> +	unsigned int field_id;
> +	/* Indicates whether streaming started */
> +	unsigned char started;
> +	/* Identifies device object */
> +	enum vpbe_display_device_id device_id;
> +	/* facilitation of ioctl ops lock by v4l2*/
> +	struct mutex opslock;
> +};
> +
> +/* vpbe device structure */
> +struct vpbe_display {
> +	/* layer specific parameters */
> +	/* lock for isr updates to buf layers*/
> +	spinlock_t dma_queue_lock;
> +	/* C-Plane offset from start of y-plane */
> +	unsigned int cbcr_ofst;
> +	struct vpbe_display_obj *dev[VPBE_DISPLAY_MAX_DEVICES];
> +};
> +
> +/* File handle structure */
> +struct vpbe_fh {
> +	/* vpbe device structure */
> +	struct vpbe_display *disp_dev;
> +	/* pointer to layer object for opened device */
> +	struct vpbe_display_obj *layer;
> +	/* Indicates whether this file handle is doing IO */
> +	unsigned char io_allowed;
> +	/* Used to keep track priority of this instance */
> +	enum v4l2_priority prio;
> +};
> +
> +struct buf_config_params {
> +	unsigned char min_numbuffers;
> +	unsigned char numbuffers[VPBE_DISPLAY_MAX_DEVICES];
> +	unsigned int min_bufsize[VPBE_DISPLAY_MAX_DEVICES];
> +	unsigned int layer_bufsize[VPBE_DISPLAY_MAX_DEVICES];
> +};
> +
> +static int venc_is_second_field(void);

If the function is static, there's no need to add it to the header.

> +#endif	/* end of __KERNEL__ */
> +#endif	/* VPBE_DISPLAY_H */
> diff --git a/include/media/davinci/vpbe_types.h
> b/include/media/davinci/vpbe_types.h new file mode 100644
> index 0000000..24a358b
> --- /dev/null
> +++ b/include/media/davinci/vpbe_types.h
> @@ -0,0 +1,91 @@
> +/*
> + * Copyright (C) 2010 Texas Instruments Inc
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License as published by
> + * the Free Software Foundation version 2.
> + *
> + * This program is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
> + * GNU General Public License for more details.
> + *
> + * You should have received a copy of the GNU General Public License
> + * along with this program; if not, write to the Free Software
> + * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA
> + */
> +#ifndef _VPBE_TYPES_H
> +#define _VPBE_TYPES_H
> +
> +enum vpbe_types {
> +	VPBE_VERSION_1 = 1,
> +	VPBE_VERSION_2,
> +	VPBE_VERSION_3,
> +};

Should it be renamed to enum vpbe_version ?

> +
> +/* vpbe_timing_type - Timing types used in vpbe device */
> +enum vpbe_enc_timings_type {
> +	VPBE_ENC_STD = 0x1,
> +	VPBE_ENC_DV_PRESET = 0x2,
> +	VPBE_ENC_CUSTOM_TIMINGS = 0x4,
> +	/* Used when set timings through FB device interface */
> +	VPBE_ENC_TIMINGS_INVALID = 0x8,
> +};
> +
> +union vpbe_timings {
> +	v4l2_std_id std_id;
> +	unsigned int dv_preset;
> +};
> +
> +/*
> + * struct vpbe_enc_mode_info
> + * @name: ptr to name string of the standard, "NTSC", "PAL" etc
> + * @std: standard or non-standard mode. 1 - standard, 0 - nonstandard
> + * @interlaced: 1 - interlaced, 0 - non interlaced/progressive
> + * @xres: x or horizontal resolution of the display
> + * @yres: y or vertical resolution of the display
> + * @fps: frame per second
> + * @left_margin: left margin of the display
> + * @right_margin: right margin of the display
> + * @upper_margin: upper margin of the display
> + * @lower_margin: lower margin of the display
> + * @hsync_len: h-sync length
> + * @vsync_len: v-sync length
> + * @flags: bit field: bit usage is documented below
> + *
> + * Description:
> + *  Structure holding timing and resolution information of a standard.
> + * Used by vpbe_device to set required non-standard timing in the
> + * venc when lcd controller output is connected to a external encoder.
> + * A table of timings is maintained in vpbe device to set this in
> + * venc when external encoder is connected to lcd controller output.
> + * Encoder may provide a g_dv_timings() API to override these values
> + * as needed.
> + *
> + *  Notes
> + *  ------
> + *  if_type should be used only by encoder manager and encoder.
> + *  flags usage
> + *     b0 (LSB) - hsync polarity, 0 - negative, 1 - positive
> + *     b1       - vsync polarity, 0 - negative, 1 - positive
> + *     b2       - field id polarity, 0 - negative, 1  - positive
> + */
> +struct vpbe_enc_mode_info {
> +	unsigned char *name;
> +	enum vpbe_enc_timings_type timings_type;
> +	union vpbe_timings timings;
> +	unsigned int interlaced;
> +	unsigned int xres;
> +	unsigned int yres;
> +	struct v4l2_fract aspect;
> +	struct v4l2_fract fps;
> +	unsigned int left_margin;
> +	unsigned int right_margin;
> +	unsigned int upper_margin;
> +	unsigned int lower_margin;
> +	unsigned int hsync_len;
> +	unsigned int vsync_len;
> +	unsigned int flags;
> +};
> +
> +#endif

-- 
Regards,

Laurent Pinchart
