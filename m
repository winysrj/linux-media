Return-path: <linux-media-owner@vger.kernel.org>
Received: from wf-out-1314.google.com ([209.85.200.174]:19629 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756353AbZFSVYR (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 19 Jun 2009 17:24:17 -0400
Received: by wf-out-1314.google.com with SMTP id 26so952225wfd.4
        for <linux-media@vger.kernel.org>; Fri, 19 Jun 2009 14:24:19 -0700 (PDT)
To: m-karicheri2@ti.com
Cc: linux-media@vger.kernel.org,
	davinci-linux-open-source@linux.davincidsp.com
Subject: Re: [PATCH 10/11 - v3] remove outdated video driver files for dm6446
References: <1245269484-8325-1-git-send-email-m-karicheri2@ti.com>
	<1245269484-8325-2-git-send-email-m-karicheri2@ti.com>
	<1245269484-8325-3-git-send-email-m-karicheri2@ti.com>
	<1245269484-8325-4-git-send-email-m-karicheri2@ti.com>
	<1245269484-8325-5-git-send-email-m-karicheri2@ti.com>
	<1245269484-8325-6-git-send-email-m-karicheri2@ti.com>
	<1245269484-8325-7-git-send-email-m-karicheri2@ti.com>
	<1245269484-8325-8-git-send-email-m-karicheri2@ti.com>
	<1245269484-8325-9-git-send-email-m-karicheri2@ti.com>
	<1245269484-8325-10-git-send-email-m-karicheri2@ti.com>
	<1245269484-8325-11-git-send-email-m-karicheri2@ti.com>
From: Kevin Hilman <khilman@deeprootsystems.com>
Date: Fri, 19 Jun 2009 14:24:14 -0700
In-Reply-To: <1245269484-8325-11-git-send-email-m-karicheri2@ti.com> (m-karicheri2@ti.com's message of "Wed\, 17 Jun 2009 16\:11\:23 -0400")
Message-ID: <87ab43udc1.fsf@deeprootsystems.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

m-karicheri2@ti.com writes:

> From: Muralidharan Karicheri <m-karicheri2@ti.com>
>
> Remove outdated driver files from davinci git tree
>
> Added obsolete driver files for tvp5146 to the files removed.
>  
> Reviewed by: Hans Verkuil <hverkuil@xs4all.nl>
> Reviewed by: Laurent Pinchart <laurent.pinchart@skynet.be>
> Reviewed by: Kevin Hilman <khilman@deeprootsystems.com>
>
> Signed-off-by: Muralidharan Karicheri <m-karicheri2@ti.com>
> ---
> Applies to Davinci GIT Tree

Pushing to DaVinci git today.

Kevin

>  drivers/media/video/ccdc_davinci.c |  124 ----
>  drivers/media/video/davinci_vpfe.c | 1136 ------------------------------------
>  drivers/media/video/tvp5146.c      |  649 --------------------
>  include/media/ccdc_davinci.h       |  144 -----
>  include/media/davinci_vpfe.h       |  121 ----
>  include/media/tvp5146.h            |  104 ----
>  6 files changed, 0 insertions(+), 2278 deletions(-)
>  delete mode 100644 drivers/media/video/ccdc_davinci.c
>  delete mode 100644 drivers/media/video/davinci_vpfe.c
>  delete mode 100644 drivers/media/video/tvp5146.c
>  delete mode 100644 include/media/ccdc_davinci.h
>  delete mode 100644 include/media/davinci_vpfe.h
>  delete mode 100644 include/media/tvp5146.h
>
> diff --git a/drivers/media/video/ccdc_davinci.c b/drivers/media/video/ccdc_davinci.c
> deleted file mode 100644
> index d3cd333..0000000
> --- a/drivers/media/video/ccdc_davinci.c
> +++ /dev/null
> @@ -1,124 +0,0 @@
> -/*
> - *
> - *
> - * Copyright (C) 2006 Texas Instruments Inc
> - *
> - * This program is free software; you can redistribute it and/or modify
> - * it under the terms of the GNU General Public License as published by
> - * the Free Software Foundation; either version 2 of the License, or
> - * (at your option) any later version.
> - *
> - * This program is distributed in the hope that it will be useful,
> - * but WITHOUT ANY WARRANTY; without even the implied warranty of
> - * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> - * GNU General Public License for more details.
> - *
> - * You should have received a copy of the GNU General Public License
> - * along with this program; if not, write to the Free Software
> - * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
> - */
> -/* ccdc_davinci.c */
> -
> -#include <media/ccdc_davinci.h>
> -#define debug_print(x...)	//printk(x)
> -void ccdc_reset()
> -{
> -	int i;
> -	/* disable CCDC */
> -	ccdc_enable(0);
> -	/* set all registers to default value */
> -	for (i = 0; i <= 0x94; i += 4) {
> -		regw(0, i);
> -	}
> -	regw(0, PCR);
> -	regw(0, SYN_MODE);
> -	regw(0, HD_VD_WID);
> -	regw(0, PIX_LINES);
> -	regw(0, HORZ_INFO);
> -	regw(0, VERT_START);
> -	regw(0, VERT_LINES);
> -	regw(0xffff00ff, CULLING);
> -	regw(0, HSIZE_OFF);
> -	regw(0, SDOFST);
> -	regw(0, SDR_ADDR);
> -	regw(0, VDINT);
> -	regw(0, REC656IF);
> -	regw(0, CCDCFG);
> -	regw(0, FMTCFG);
> -	regw(0, VP_OUT);
> -}
> -
> -void ccdc_setwin(ccdc_params_ycbcr * params)
> -{
> -	int horz_start, horz_nr_pixels;
> -	int vert_start, vert_nr_lines;
> -
> -	/* configure horizonal and vertical starts and sizes */
> -	horz_start = params->win.left << 1;
> -	horz_nr_pixels = (params->win.width <<1) - 1;
> -	regw((horz_start << 16) | horz_nr_pixels, HORZ_INFO);
> -
> -	vert_start = params->win.top;
> -
> -	if (params->frm_fmt == CCDC_FRMFMT_INTERLACED) {
> -		vert_nr_lines = (params->win.height >> 1) - 1;
> -		vert_start >>= 1;
> -	} else {
> -		vert_nr_lines = params->win.height - 1;
> -	}
> -	regw((vert_start << 16) | vert_start, VERT_START);
> -	regw(vert_nr_lines, VERT_LINES);
> -}
> -
> -void ccdc_config_ycbcr(ccdc_params_ycbcr * params)
> -{
> -	u32 syn_mode;
> -
> -	/* first reset the CCDC                                          */
> -	/* all registers have default values after reset                 */
> -	/* This is important since we assume default values to be set in */
> -	/* a lot of registers that we didn't touch                       */
> -	ccdc_reset();
> -
> -	/* configure pixel format */
> -	syn_mode = (params->pix_fmt & 0x3) << 12;
> -
> -	/* configure video frame format */
> -	syn_mode |= (params->frm_fmt & 0x1) << 7;
> -
> -	/* setup BT.656 sync mode */
> -	if (params->bt656_enable) {
> -		regw(3, REC656IF);
> -
> -		/* configure the FID, VD, HD pin polarity */
> -		/* fld,hd pol positive, vd negative, 8-bit pack mode */
> -		syn_mode |= 0x00000F04;
> -	} else {/* y/c external sync mode */
> -		syn_mode |= ((params->fid_pol & 0x1) << 4);
> -		syn_mode |= ((params->hd_pol & 0x1) << 3);
> -		syn_mode |= ((params->vd_pol & 0x1) << 2);
> -	}
> -
> -	/* configure video window */
> -	ccdc_setwin(params);
> -
> -	/* configure the order of y cb cr in SD-RAM */
> -	regw((params->pix_order << 11) | 0x8000, CCDCFG);
> -
> -	/* configure the horizontal line offset */
> -	/* this is done by rounding up width to a multiple of 16 pixels */
> -	/* and multiply by two to account for y:cb:cr 4:2:2 data */
> -	regw(((params->win.width * 2) + 31) & 0xffffffe0, HSIZE_OFF);
> -
> -	/* configure the memory line offset */
> -	if (params->buf_type == CCDC_BUFTYPE_FLD_INTERLEAVED) {
> -		/* two fields are interleaved in memory */
> -		regw(0x00000249, SDOFST);
> -	}
> -	/* enable output to SDRAM */
> -	syn_mode |= (0x1 << 17);
> -	/* enable internal timing generator */
> -	syn_mode |= (0x1 << 16);
> -
> -	regw(syn_mode, SYN_MODE);
> -}
> diff --git a/drivers/media/video/davinci_vpfe.c b/drivers/media/video/davinci_vpfe.c
> deleted file mode 100644
> index 1128eb5..0000000
> --- a/drivers/media/video/davinci_vpfe.c
> +++ /dev/null
> @@ -1,1136 +0,0 @@
> -/*
> - *
> - *
> - * Copyright (C) 2006 Texas Instruments Inc
> - *
> - * This program is free software; you can redistribute it and/or modify
> - * it under the terms of the GNU General Public License as published by
> - * the Free Software Foundation; either version 2 of the License, or
> - * (at your option) any later version.
> - *
> - * This program is distributed in the hope that it will be useful,
> - * but WITHOUT ANY WARRANTY; without even the implied warranty of
> - * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> - * GNU General Public License for more details.
> - *
> - * You should have received a copy of the GNU General Public License
> - * along with this program; if not, write to the Free Software
> - * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
> - */
> -/* davinci_vpfe.c */
> -
> -#include <linux/init.h>
> -#include <linux/module.h>
> -#include <linux/delay.h>
> -#include <linux/errno.h>
> -#include <linux/fs.h>
> -#include <linux/kernel.h>
> -#include <linux/sched.h>
> -#include <linux/interrupt.h>
> -#include <linux/kdev_t.h>
> -#include <linux/string.h>
> -#include <linux/videodev.h>
> -#include <linux/wait.h>
> -#include <linux/dma-mapping.h>
> -#include <linux/platform_device.h>
> -
> -#include <asm/irq.h>
> -#include <asm/page.h>
> -#include <asm/io.h>
> -#include <asm/dma-mapping.h>
> -
> -#include <media/davinci_vpfe.h>
> -
> -#define debug_print(x...)	//printk(x)
> -
> -MODULE_LICENSE("GPL");
> -
> -static struct v4l2_rect ntsc_bounds = VPFE_WIN_NTSC;
> -static struct v4l2_rect pal_bounds = VPFE_WIN_PAL;
> -static struct v4l2_fract ntsc_aspect = VPFE_PIXELASPECT_NTSC;
> -static struct v4l2_fract pal_aspect = VPFE_PIXELASPECT_PAL;
> -static struct v4l2_rect ntscsp_bounds = VPFE_WIN_NTSC_SP;
> -static struct v4l2_rect palsp_bounds = VPFE_WIN_PAL_SP;
> -static struct v4l2_fract sp_aspect = VPFE_PIXELASPECT_NTSC_SP;
> -
> -static vpfe_obj vpfe_device = {	/* the default format is NTSC */
> -	.usrs = 0,
> -	.io_usrs = 0,
> -	.std = VPFE_STD_AUTO,
> -	.vwin = VPFE_WIN_PAL,
> -	.bounds = VPFE_WIN_PAL,
> -	.pixelaspect = VPFE_PIXELASPECT_NTSC,
> -	.pixelfmt = V4L2_PIX_FMT_UYVY,
> -	.field = V4L2_FIELD_INTERLACED,
> -	.numbuffers = VPFE_DEFNUM_FBUFS,
> -	.ccdc_params = {
> -		.pix_fmt = CCDC_PIXFMT_YCBCR_8BIT,
> -		.frm_fmt = CCDC_FRMFMT_INTERLACED,
> -		.win = VPFE_WIN_PAL,
> -		.fid_pol = CCDC_PINPOL_POSITIVE,
> -		.vd_pol = CCDC_PINPOL_POSITIVE,
> -		.hd_pol = CCDC_PINPOL_POSITIVE,
> -		.bt656_enable = TRUE,
> -		.pix_order = CCDC_PIXORDER_CBYCRY,
> -		.buf_type = CCDC_BUFTYPE_FLD_INTERLEAVED
> -	},
> -	.tvp5146_params = {
> -		.mode = TVP5146_MODE_AUTO,
> -		.amuxmode = TVP5146_AMUX_COMPOSITE,
> -		.enablebt656sync = TRUE
> -	},
> -        .irqlock = SPIN_LOCK_UNLOCKED
> -};
> -
> -struct v4l2_capability vpfe_drvcap = {
> -	.driver = "vpfe driver",
> -	.card = "DaVinci EVM",
> -	.bus_info = "Platform",
> -	.version = VPFE_VERSION_CODE,
> -	.capabilities = V4L2_CAP_VIDEO_CAPTURE | V4L2_CAP_STREAMING
> -};
> -
> -static int sense_std(v4l2_std_id* std_id)
> -{
> -	v4l2_std_id id = 0;
> -	tvp5146_mode mode;
> -	int ret;
> -	ret = tvp5146_ctrl(TVP5146_GET_STD, &mode);
> -	if(ret < 0)
> -		return ret;
> -	switch (mode & 0x7) {
> -	case TVP5146_MODE_NTSC:
> -		id = V4L2_STD_NTSC;
> -		break;
> -	case TVP5146_MODE_PAL:
> -		id = V4L2_STD_PAL;
> -		break;
> -	case TVP5146_MODE_PAL_M:
> -		id = V4L2_STD_PAL_M;
> -		break;
> -	case TVP5146_MODE_PAL_CN:
> -		id = V4L2_STD_PAL_N;
> -		break;
> -	case TVP5146_MODE_SECAM:
> -		id = V4L2_STD_SECAM;
> -		break;
> -	case TVP5146_MODE_PAL_60:
> -		id = V4L2_STD_PAL_60;
> -		break;
> -	}
> -	if (mode & 0x8) {	/* square pixel mode */
> -		id <<= 32;
> -	}
> -	if (mode == TVP5146_MODE_AUTO) {
> -		id = VPFE_STD_AUTO;	/* auto-detection for all other modes */
> -	} else if (mode == TVP5146_MODE_AUTO_SQP) {
> -		id = VPFE_STD_AUTO_SQP;
> -	}
> -	if(id == 0)
> -		return -EINVAL;
> -	*std_id =  id;
> -	return 0;
> -}
> -
> -static irqreturn_t vpfe_isr(int irq, void *dev_id)
> -{
> -	vpfe_obj *vpfe = &vpfe_device;
> -	int fid;
> -
> -	/* check which field we are in hardware */
> -	fid = ccdc_getfid();
> -	vpfe->field_id ^= 1;	/* switch the software maintained field id */
> -	debug_print(KERN_INFO "field id = %x:%x.\n", fid, vpfe->field_id);
> -	if (fid == vpfe->field_id) {	/* we are in-sync here, continue */
> -		if (fid == 0) {
> -			/*  One frame is just being captured. If the next frame
> -			is available, release the current frame and move on */
> -			if (vpfe->curFrm != vpfe->nextFrm) {
> -				vpfe->curFrm->state = STATE_DONE;
> -				wake_up_interruptible(&vpfe->curFrm->done);
> -				vpfe->curFrm = vpfe->nextFrm;
> -			}
> -			/* based on whether the two fields are stored interleavely      */
> -			/* or separately in memory, reconfigure the CCDC memory address */
> -			if (vpfe->field == V4L2_FIELD_SEQ_TB) {
> -				u32 addr =
> -				    vpfe->curFrm->boff + vpfe->field_offset;
> -				ccdc_setfbaddr((unsigned long)addr);
> -			}
> -	} else if (fid == 1) {
> -			/* if one field is just being captured */
> -			/* configure the next frame */
> -			/* get the next frame from the empty queue */
> -			/* if no frame is available, hold on to the current buffer */
> -			if (!list_empty(&vpfe->dma_queue)
> -			    && vpfe->curFrm == vpfe->nextFrm) {
> -				vpfe->nextFrm = list_entry(vpfe->dma_queue.next,
> -					struct videobuf_buffer, queue);
> -				list_del(&vpfe->nextFrm->queue);
> -				vpfe->nextFrm->state = STATE_ACTIVE;
> -				ccdc_setfbaddr(
> -					(unsigned long)vpfe->nextFrm->boff);
> -			}
> -			if (vpfe->mode_changed) {
> -				ccdc_setwin(&vpfe->ccdc_params);
> -				/* update the field offset */
> -				vpfe->field_offset =
> -				    (vpfe->vwin.height - 2) * vpfe->vwin.width;
> -				vpfe->mode_changed = FALSE;
> -			}
> -		}
> -	} else if (fid == 0) {
> -		/* recover from any hardware out-of-sync due to */
> -		/* possible switch of video source              */
> -		/* for fid == 0, sync up the two fids           */
> -		/* for fid == 1, no action, one bad frame will  */
> -		/* go out, but it is not a big deal             */
> -		vpfe->field_id = fid;
> -	}
> -	debug_print(KERN_INFO "interrupt returned.\n");
> -	return IRQ_RETVAL(1);
> -}
> -
> -/* this is the callback function called from videobuf_qbuf() function */
> -/* the buffer is prepared and queued into the dma queue */
> -static int buffer_prepare(struct videobuf_queue *q,
> -			  struct videobuf_buffer *vb,
> -			  enum v4l2_field field)
> -{
> -	vpfe_obj *vpfe = &vpfe_device;
> -
> -
> -	if (vb->state == STATE_NEEDS_INIT) {
> -		vb->width  = vpfe->vwin.width;
> -		vb->height = vpfe->vwin.height;
> -		vb->size   = VPFE_MAX_FBUF_SIZE;
> -		vb->field  = field;
> -	}
> -	vb->state = STATE_PREPARED;
> -
> -	return 0;
> -
> -}
> -static void
> -buffer_config(struct videobuf_queue *q, unsigned int count)
> -{
> -	vpfe_obj *vpfe = &vpfe_device;
> -	int i;
> -	for(i = 0; i < count; i++) {
> -		q->bufs[i]->boff = virt_to_phys(vpfe->fbuffers[i]);
> -		debug_print(KERN_INFO "buffer address: %x\n", q->bufs[i]->boff);
> -	}
> -}
> -
> -static int
> -buffer_setup(struct videobuf_queue *q, unsigned int *count, unsigned int *size)
> -{
> -	vpfe_obj *vpfe = &vpfe_device;
> -	int i;
> -	*size = VPFE_MAX_FBUF_SIZE;
> -
> -
> -	for (i = VPFE_DEFNUM_FBUFS; i < *count; i++) {
> -		u32 size = PAGE_SIZE << VPFE_MAX_FBUF_ORDER;
> -		void *mem = (void *)__get_free_pages(GFP_KERNEL |GFP_DMA,
> -						     VPFE_MAX_FBUF_ORDER);
> -		if (mem) {
> -			unsigned long adr = (unsigned long)mem;
> -			while (size > 0) {
> -				/* make sure the frame buffers are never
> -				   swapped out of memory */
> -				SetPageReserved(virt_to_page(adr));
> -				adr += PAGE_SIZE;
> -				size -= PAGE_SIZE;
> -			}
> -			vpfe->fbuffers[i] = mem;
> -		} else {
> -			break;
> -		}
> -	}
> -	*count = vpfe->numbuffers = i;
> -
> -	return 0;
> -}
> -
> -static void buffer_queue(struct videobuf_queue *q, struct videobuf_buffer *vb)
> -{
> -	vpfe_obj *vpfe = &vpfe_device;
> -        /* add the buffer to the DMA queue */
> -	list_add_tail(&vb->queue, &vpfe->dma_queue);
> -	vb->state = STATE_QUEUED;
> -}
> -
> -static void buffer_release(struct videobuf_queue *q, struct videobuf_buffer *vb)
> -{
> -	/* free the buffer if it is not one of the 3 allocated at initializaiton time */
> -	if(vb->i < vpfe_device.numbuffers
> -	 && vb->i >= VPFE_DEFNUM_FBUFS
> -	 && vpfe_device.fbuffers[vb->i]){
> -		free_pages((unsigned long)vpfe_device.fbuffers[vb->i],
> -			   VPFE_MAX_FBUF_ORDER);
> -		vpfe_device.fbuffers[vb->i] = NULL;
> -	}
> -}
> -
> -
> -static struct videobuf_queue_ops video_qops = {
> -	.buf_setup    = buffer_setup,
> -	.buf_prepare  = buffer_prepare,
> -	.buf_queue    = buffer_queue,
> -	.buf_release  = buffer_release,
> -	.buf_config   = buffer_config,
> -};
> -
> -
> -
> -
> -static int vpfe_doioctl(struct inode *inode, struct file *file,
> -			unsigned int cmd, void *arg)
> -{
> -	vpfe_obj *vpfe = &vpfe_device;
> -	vpfe_fh *fh = file->private_data;
> -	int ret = 0;
> -	switch (cmd) {
> -	case VIDIOC_S_CTRL:
> -	case VIDIOC_S_FMT:
> -	case VIDIOC_S_STD:
> -	case VIDIOC_S_CROP:
> -		ret = v4l2_prio_check(&vpfe->prio, &fh->prio);
> -		if (0 != ret) {
> -			return ret;
> -		}
> -		break;
> -	}
> -
> -	switch (cmd) {
> -	case VIDIOC_QUERYCAP:
> -	{
> -		struct v4l2_capability *cap =
> -		    (struct v4l2_capability *)arg;
> -		memset(cap, 0, sizeof(*cap));
> -		*cap = vpfe_drvcap;
> -		break;
> -	}
> -	case VIDIOC_ENUM_FMT:
> -	{
> -		struct v4l2_fmtdesc *fmt = (struct v4l2_fmtdesc *)arg;
> -		u32 index = fmt->index;
> -		memset(fmt, 0, sizeof(*fmt));
> -		fmt->index = index;
> -		if (index == 0) {
> -			/* only yuv4:2:2 format is supported at this point */
> -			fmt->type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
> -			strcpy(fmt->description,
> -			       "YCbCr4:2:2 Interleaved UYUV");
> -			fmt->pixelformat = V4L2_PIX_FMT_UYVY;
> -		} else if (index == 1) {
> -			fmt->type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
> -			strcpy(fmt->description,
> -			       "YCbCr4:2:2 Interleaved YUYV");
> -			fmt->pixelformat = V4L2_PIX_FMT_YUYV;
> -		} else {
> -			ret = -EINVAL;
> -		}
> -		break;
> -	}
> -	case VIDIOC_G_FMT:
> -	{
> -		struct v4l2_format *fmt = (struct v4l2_format *)arg;
> -		if (fmt->type != V4L2_BUF_TYPE_VIDEO_CAPTURE) {
> -			ret = -EINVAL;
> -		} else {
> -			struct v4l2_pix_format *pixfmt = &fmt->fmt.pix;
> -			down_interruptible(&vpfe->lock);
> -			pixfmt->width = vpfe->vwin.width;
> -			pixfmt->height = vpfe->vwin.height;
> -			pixfmt->field = vpfe->field;
> -			pixfmt->pixelformat = vpfe->pixelfmt;
> -			pixfmt->bytesperline = pixfmt->width * 2;
> -			pixfmt->sizeimage =
> -			    pixfmt->bytesperline * pixfmt->height;
> -			pixfmt->colorspace = V4L2_COLORSPACE_SMPTE170M;
> -			up(&vpfe->lock);
> -		}
> -		break;
> -	}
> -	case VIDIOC_S_FMT:
> -	{
> -		struct v4l2_format *fmt = (struct v4l2_format *)arg;
> -		struct v4l2_pix_format *pixfmt = &fmt->fmt.pix;
> -		ccdc_params_ycbcr *params = &vpfe->ccdc_params;
> -		if (vpfe->started) {	/* make sure streaming is not started */
> -			ret = -EBUSY;
> -			break;
> -		}
> -
> -		down_interruptible(&vpfe->lock);
> -		if (fmt->type != V4L2_BUF_TYPE_VIDEO_CAPTURE) {
> -			ret = -EINVAL;
> -			up(&vpfe->lock);
> -			break;
> -		}
> -		if ((pixfmt->width + vpfe->vwin.left <=
> -		     vpfe->bounds.width)
> -		    & (pixfmt->height + vpfe->vwin.top <=
> -		       vpfe->bounds.height)) {
> -			/* this is the case when no scaling is supported */
> -			/* crop window is directed modified */
> -			vpfe->vwin.height = pixfmt->height;
> -			vpfe->vwin.width = pixfmt->width;
> -			params->win.width = pixfmt->width;
> -			params->win.height = pixfmt->height;
> -		} else {
> -			ret = -EINVAL;
> -			up(&vpfe->lock);
> -			break;
> -		}
> -		/* setup the CCDC parameters accordingly */
> -		if (pixfmt->pixelformat == V4L2_PIX_FMT_YUYV) {
> -			params->pix_order = CCDC_PIXORDER_YCBYCR;
> -			vpfe->pixelfmt = pixfmt->pixelformat;
> -		} else if (pixfmt->pixelformat == V4L2_PIX_FMT_UYVY) {
> -			params->pix_order = CCDC_PIXORDER_CBYCRY;
> -			vpfe->pixelfmt = pixfmt->pixelformat;
> -		} else {
> -			ret = -EINVAL;	/* not supported format */
> -			up(&vpfe->lock);
> -			break;
> -		}
> -		if (pixfmt->field == V4L2_FIELD_NONE
> -		    || pixfmt->field == V4L2_FIELD_INTERLACED) {
> -			params->buf_type = CCDC_BUFTYPE_FLD_INTERLEAVED;
> -			vpfe->field = pixfmt->field;
> -		} else if (pixfmt->field == V4L2_FIELD_SEQ_TB) {
> -			params->buf_type = CCDC_BUFTYPE_FLD_SEPARATED;
> -			vpfe->field = pixfmt->field;
> -		} else {
> -			ret = -EINVAL;
> -		}
> -		up(&vpfe->lock);
> -		break;
> -	}
> -	case VIDIOC_TRY_FMT:
> -	{
> -		struct v4l2_format *fmt = (struct v4l2_format *)arg;
> -		if (fmt->type != V4L2_BUF_TYPE_VIDEO_CAPTURE) {
> -			ret = -EINVAL;
> -		} else {
> -			struct v4l2_pix_format *pixfmt = &fmt->fmt.pix;
> -			if (pixfmt->width > vpfe->bounds.width
> -			    || pixfmt->height > vpfe->bounds.height
> -			    || (pixfmt->pixelformat != V4L2_PIX_FMT_UYVY
> -				&& pixfmt->pixelformat !=
> -				V4L2_PIX_FMT_YUYV)) {
> -				ret = -EINVAL;
> -			}
> -		}
> -		break;
> -	}
> -	case VIDIOC_G_STD:
> -	{
> -		v4l2_std_id *id = (v4l2_std_id *) arg;
> -		*id = vpfe->std;
> -		break;
> -	}
> -	case VIDIOC_S_STD:
> -	{
> -		v4l2_std_id id = *(v4l2_std_id *) arg;
> -		tvp5146_mode mode = TVP5146_MODE_INV;
> -		int sqp = 0;
> -
> -		if (vpfe->started) {	/* make sure streaming is not started */
> -			ret = -EBUSY;
> -			break;
> -		}
> -		down_interruptible(&vpfe->lock);
> -		if (id & V4L2_STD_625_50) {
> -			vpfe->std = id;
> -			vpfe->bounds = vpfe->vwin = pal_bounds;
> -			vpfe->pixelaspect = pal_aspect;
> -			vpfe->ccdc_params.win = pal_bounds;
> -
> -		} else if (id & V4L2_STD_525_60) {
> -			vpfe->std = id;
> -			vpfe->bounds = vpfe->vwin = ntsc_bounds;
> -			vpfe->pixelaspect = ntsc_aspect;
> -			vpfe->ccdc_params.win = ntsc_bounds;
> -		} else if (id & VPFE_STD_625_50_SQP) {
> -			vpfe->std = id;
> -			vpfe->bounds = vpfe->vwin = palsp_bounds;
> -			vpfe->pixelaspect = sp_aspect;
> -			sqp = 1;
> -			id >>= 32;
> -		} else if (id & VPFE_STD_525_60_SQP) {
> -			vpfe->std = id;
> -			sqp = 1;
> -			vpfe->std = id;
> -			id >>= 32;
> -			vpfe->bounds = vpfe->vwin = ntscsp_bounds;
> -			vpfe->pixelaspect = sp_aspect;
> -			vpfe->ccdc_params.win = ntscsp_bounds;
> -		} else if (id & VPFE_STD_AUTO) {
> -			mode = TVP5146_MODE_AUTO;
> -			vpfe->bounds = vpfe->vwin = pal_bounds;
> -			vpfe->pixelaspect = pal_aspect;
> -			vpfe->ccdc_params.win = pal_bounds;
> -			vpfe->std = id;
> -		} else if (id & VPFE_STD_AUTO_SQP) {
> -			vpfe->std = id;
> -			vpfe->bounds = vpfe->vwin = palsp_bounds;
> -			vpfe->pixelaspect = sp_aspect;
> -			sqp = 1;
> -			mode = TVP5146_MODE_AUTO_SQP;
> -			vpfe->pixelaspect = sp_aspect;
> -		} else {
> -			ret = -EINVAL;
> -		}
> -		if (id == V4L2_STD_PAL_60) {
> -			mode = TVP5146_MODE_PAL_60;
> -		} else if (id == V4L2_STD_PAL_M) {
> -			mode = TVP5146_MODE_PAL_M;
> -		} else if (id == V4L2_STD_PAL_Nc
> -			   || id == V4L2_STD_PAL_N) {
> -			mode = TVP5146_MODE_PAL_CN;
> -		} else if (id & V4L2_STD_PAL) {
> -			mode = TVP5146_MODE_PAL;
> -		} else if (id & V4L2_STD_NTSC) {
> -			mode = TVP5146_MODE_NTSC;
> -		} else if (id & V4L2_STD_SECAM) {
> -			mode = TVP5146_MODE_SECAM;
> -		}
> -		vpfe->tvp5146_params.mode = mode | (sqp << 3);
> -		tvp5146_ctrl(TVP5146_CONFIG, &vpfe->tvp5146_params);
> -
> -		up(&vpfe->lock);
> -		break;
> -	}
> -	case VIDIOC_ENUMSTD:
> -	{
> -		struct v4l2_standard *std = (struct v4l2_standard *)arg;
> -		u32 index = std->index;
> -		memset(std, 0, sizeof(*std));
> -		std->index = index;
> -		if (index == 0) {
> -			std->id = V4L2_STD_525_60;
> -			strcpy(std->name, "SD-525line-30fps");
> -			std->framelines = 525;
> -			std->frameperiod.numerator = 1001;
> -			std->frameperiod.denominator = 30000;
> -		} else if (index == 1) {
> -			std->id = V4L2_STD_625_50;
> -			strcpy(std->name, "SD-625line-25fps");
> -			std->framelines = 625;
> -			std->frameperiod.numerator = 1;
> -			std->frameperiod.denominator = 25;
> -		} else if (index == 2) {
> -			std->id = VPFE_STD_625_50_SQP;
> -			strcpy(std->name,
> -			       "SD-625line-25fps square pixel");
> -			std->framelines = 625;
> -			std->frameperiod.numerator = 1;
> -			std->frameperiod.denominator = 25;
> -		} else if (index == 3) {
> -			std->id = VPFE_STD_525_60_SQP;
> -			strcpy(std->name,
> -			       "SD-525line-25fps square pixel");
> -			std->framelines = 525;
> -			std->frameperiod.numerator = 1001;
> -			std->frameperiod.denominator = 30000;
> -		} else if (index == 4) {
> -			std->id = VPFE_STD_AUTO;
> -			strcpy(std->name, "automatic detect");
> -			std->framelines = 625;
> -			std->frameperiod.numerator = 1;
> -			std->frameperiod.denominator = 1;
> -		} else if (index == 5) {
> -			std->id = VPFE_STD_AUTO_SQP;
> -			strcpy(std->name,
> -			       "automatic detect square pixel");
> -			std->framelines = 625;
> -			std->frameperiod.numerator = 1;
> -			std->frameperiod.denominator = 1;
> -		} else {
> -			ret = -EINVAL;
> -		}
> -		break;
> -	}
> -	case VIDIOC_ENUMINPUT:
> -	{
> -		u32 index=0;
> -		struct v4l2_input *input = (struct v4l2_input *)arg;
> -		if (input->index > 1) 	/* only two inputs are available */
> -			ret = -EINVAL;
> -		index = input->index;
> -		memset(input, 0, sizeof(*input));
> -                input->index = index;
> -		input->type = V4L2_INPUT_TYPE_CAMERA;
> -		input->std = V4L2_STD_ALL;
> -		if(input->index == 0){
> -			sprintf(input->name, "COMPOSITE");
> -		}else if(input->index == 1) {
> -			sprintf(input->name, "S-VIDEO");
> -		}
> -		break;
> -	}
> -	case VIDIOC_G_INPUT:
> -	{
> -		int *index = (int *)arg;
> -		*index = vpfe->tvp5146_params.amuxmode;
> -		break;
> -	}
> -	case VIDIOC_S_INPUT:
> -	{
> -		int *index = (int *)arg;
> -		if (*index > 1 || *index < 0) {
> -			ret = -EINVAL;
> -		}
> -		vpfe->tvp5146_params.amuxmode = *index;
> -		tvp5146_ctrl(TVP5146_SET_AMUXMODE, index);
> -		break;
> -	}
> -	case VIDIOC_CROPCAP:
> -	{
> -		struct v4l2_cropcap *cropcap =
> -		    (struct v4l2_cropcap *)arg;
> -		cropcap->type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
> -		down_interruptible(&vpfe->lock);
> -		cropcap->bounds = cropcap->defrect = vpfe->vwin;
> -		cropcap->pixelaspect = vpfe->pixelaspect;
> -		up(&vpfe->lock);
> -		break;
> -	}
> -	case VIDIOC_G_PARM:
> -	{
> -		struct v4l2_streamparm *parm =
> -		    (struct v4l2_streamparm *)arg;
> -		if (parm->type != V4L2_BUF_TYPE_VIDEO_CAPTURE) {
> -			/* only capture is supported */
> -			ret = -EINVAL;
> -		} else {
> -			struct v4l2_captureparm *capparm =
> -			    &parm->parm.capture;
> -			memset(capparm, 0,
> -			       sizeof(struct v4l2_captureparm));
> -			down_interruptible(&vpfe->lock);
> -			if (vpfe->std & V4L2_STD_625_50) {
> -				capparm->timeperframe.numerator = 1;
> -				capparm->timeperframe.denominator = 25;	/* PAL 25fps */
> -			} else {
> -				capparm->timeperframe.numerator = 1001;
> -				capparm->timeperframe.denominator = 30000;	/*NTSC 29.97fps */
> -			}
> -			capparm->readbuffers = vpfe->numbuffers;
> -			up(&vpfe->lock);
> -		}
> -		break;
> -	}
> -	case VIDIOC_G_CTRL:
> -		down_interruptible(&vpfe->lock);
> -		tvp5146_ctrl(VIDIOC_G_CTRL, arg);
> -		up(&vpfe->lock);
> -		break;
> -	case VIDIOC_S_CTRL:
> -		down_interruptible(&vpfe->lock);
> -		tvp5146_ctrl(VIDIOC_S_CTRL, arg);
> -		up(&vpfe->lock);
> -		break;
> -	case VIDIOC_QUERYCTRL:
> -		down_interruptible(&vpfe->lock);
> -		tvp5146_ctrl(VIDIOC_QUERYCTRL, arg);
> -		up(&vpfe->lock);
> -		break;
> -	case VIDIOC_G_CROP:
> -	{
> -		struct v4l2_crop *crop = arg;
> -		if (crop->type != V4L2_BUF_TYPE_VIDEO_CAPTURE) {
> -			ret = -EINVAL;
> -		} else {
> -			crop->c = vpfe->vwin;
> -		}
> -		break;
> -	}
> -	case VIDIOC_S_CROP:
> -	{
> -		struct v4l2_crop *crop = arg;
> -		ccdc_params_ycbcr *params = &vpfe->ccdc_params;
> -		if (vpfe->started) {	/* make sure streaming is not started */
> -			ret = -EBUSY;
> -			break;
> -		}
> -		/*adjust the width to 16 pixel boundry */
> -                crop->c.width = ((crop->c.width + 15 )/16 ) * 16;
> -
> -		/* make sure parameters are valid */
> -		if (crop->type == V4L2_BUF_TYPE_VIDEO_CAPTURE
> -		    && (crop->c.left + crop->c.width
> -			<= vpfe->bounds.left + vpfe->bounds.width)
> -		    && (crop->c.top + crop->c.height
> -			<= vpfe->bounds.top + vpfe->bounds.height)) {
> -
> -			down_interruptible(&vpfe->lock);
> -			vpfe->vwin = crop->c;
> -			params->win = vpfe->vwin;
> -			up(&vpfe->lock);
> -		} else {
> -			ret = -EINVAL;
> -		}
> -		break;
> -	}
> -	case VIDIOC_QUERYSTD:
> -	{
> -		v4l2_std_id *id = (v4l2_std_id *) arg;
> -		down_interruptible(&vpfe->lock);
> -		ret = sense_std(id);
> -		up(&vpfe->lock);
> -		break;
> -	}
> -	case VIDIOC_G_PRIORITY:
> -	{
> -		enum v4l2_priority *p = arg;
> -		*p = v4l2_prio_max(&vpfe->prio);
> -		break;
> -	}
> -	case VIDIOC_S_PRIORITY:
> -	{
> -		enum v4l2_priority *p = arg;
> -		ret = v4l2_prio_change(&vpfe->prio, &fh->prio, *p);
> -		break;
> -	}
> -
> -	case VIDIOC_REQBUFS:
> -		if (vpfe->io_usrs != 0) {
> -			ret = -EBUSY;
> -			break;
> -		}
> -		down_interruptible(&vpfe->lock);
> -		videobuf_queue_init(&vpfe->bufqueue, &video_qops, NULL,
> -		&vpfe->irqlock, V4L2_BUF_TYPE_VIDEO_CAPTURE, vpfe->field,
> -		sizeof(struct videobuf_buffer), fh);
> -
> -		videobuf_set_buftype(&vpfe->bufqueue, VIDEOBUF_BUF_LINEAR);
> -
> -		fh->io_allowed = TRUE;
> -		vpfe->io_usrs = 1;
> -		INIT_LIST_HEAD(&vpfe->dma_queue);
> -		ret = videobuf_reqbufs(&vpfe->bufqueue, arg);
> -		up(&vpfe->lock);
> -		break;
> -	case VIDIOC_QUERYBUF:
> -		ret = videobuf_querybuf(&vpfe->bufqueue, arg);
> -		break;
> -	case VIDIOC_QBUF:
> -		if (!fh->io_allowed)
> -			ret = -EACCES;
> -		else
> -			ret = videobuf_qbuf(&vpfe->bufqueue, arg);
> -		break;
> -	case VIDIOC_DQBUF:
> -		if (!fh->io_allowed)
> -			ret = -EACCES;
> -		else
> -			ret =  videobuf_dqbuf(&vpfe->bufqueue, arg, 0);
> -		break;
> -	case VIDIOC_STREAMON:
> -		if (!fh->io_allowed) {
> -			ret = -EACCES;
> -			break;
> -		}
> -		if(vpfe->started){
> -			ret = -EBUSY;
> -			break;
> -		}
> -		ret = videobuf_streamon(&vpfe->bufqueue);
> -		if(ret) break;
> -
> -		down_interruptible(&vpfe->lock);
> -		/* get the current and next frame buffers */
> -		/* we expect at least one buffer is in driver at this point */
> -		/* if not, error is returned */
> -		if (list_empty(&vpfe->dma_queue)) {
> -			ret = -EIO;
> -			break;
> -		}
> -		debug_print(KERN_INFO "cur frame %x.\n",
> -			    vpfe->dma_queue.next);
> -		vpfe->nextFrm = vpfe->curFrm =
> -		    list_entry(vpfe->dma_queue.next,
> -			       struct videobuf_buffer, queue);
> -		/* remove the buffer from the queue */
> -		list_del(&vpfe->curFrm->queue);
> -		vpfe->curFrm->state = STATE_ACTIVE;
> -
> -		/* sense the current video input standard */
> -		tvp5146_ctrl(TVP5146_CONFIG, &vpfe->tvp5146_params);
> -		/* configure the ccdc and resizer as needed   */
> -		/* start capture by enabling CCDC and resizer */
> -		ccdc_config_ycbcr(&vpfe->ccdc_params);
> -		/* setup the memory address for the frame buffer */
> -		ccdc_setfbaddr(((unsigned long)(vpfe->curFrm->boff)));
> -		/* enable CCDC */
> -		vpfe->field_id = 0;
> -		vpfe->started = TRUE;
> -		vpfe->mode_changed = FALSE;
> -		vpfe->field_offset =
> -		    (vpfe->vwin.height - 2) * vpfe->vwin.width;
> -		ccdc_enable(TRUE);
> -		up(&vpfe->lock);
> -		debug_print(KERN_INFO "started video streaming.\n");
> -		break;
> -	case VIDIOC_STREAMOFF:
> -	{
> -		if (!fh->io_allowed) {
> -			ret = -EACCES;
> -			break;
> -		}
> -		if(!vpfe->started){
> -			ret = -EINVAL;
> -			break;
> -		}
> -		/* disable CCDC */
> -		down_interruptible(&vpfe->lock);
> -		ccdc_enable(FALSE);
> -		vpfe->started = FALSE;
> -		up(&vpfe->lock);
> -		ret = videobuf_streamoff(&vpfe->bufqueue);
> -		break;
> -	}
> -	case VPFE_CMD_CONFIG_CCDC:
> -	{
> -		/* this can be used directly and bypass the V4L2 APIs */
> -		ccdc_params_ycbcr *params = &vpfe->ccdc_params;
> -		if(vpfe->started){
> -		/* only allowed if streaming is not started */
> -			ret = -EBUSY;
> -			break;
> -		}
> -		down_interruptible(&vpfe->lock);
> -		/* make sure the other v4l2 related fields
> -		   have consistant settings */
> -		*params = (*(ccdc_params_ycbcr *) arg);
> -		vpfe->vwin = params->win;
> -		if (params->buf_type == CCDC_BUFTYPE_FLD_INTERLEAVED) {
> -			vpfe->field = V4L2_FIELD_INTERLACED;
> -		} else if (params->buf_type ==
> -		   CCDC_BUFTYPE_FLD_SEPARATED) {
> -			vpfe->field = V4L2_FIELD_SEQ_TB;
> -		}
> -		if (params->pix_order == CCDC_PIXORDER_YCBYCR) {
> -			vpfe->pixelfmt = V4L2_PIX_FMT_YUYV;
> -		} else if (params->pix_order == CCDC_PIXORDER_CBYCRY) {
> -			vpfe->pixelfmt = V4L2_PIX_FMT_UYVY;
> -		}
> -		up(&vpfe->lock);
> -		break;
> -	}
> -	case VPFE_CMD_CONFIG_TVP5146:
> -	/* this can be used directly and bypass the V4L2 APIs */
> -	{
> -		/* the settings here must be consistant with that of the CCDC's,
> -		   driver does not check the consistancy */
> -		tvp5146_params *params = (tvp5146_params *) arg;
> -		v4l2_std_id std = 0;
> -		if(vpfe->started){
> -		/* only allowed if streaming is not started */
> -			ret = -EBUSY;
> -			break;
> -		}
> -		down_interruptible(&vpfe->lock);
> -		/*make sure the other v4l2 related fields have consistant settings */
> -		switch (params->mode & 0x7) {
> -		case TVP5146_MODE_NTSC:
> -			std = V4L2_STD_NTSC;
> -			break;
> -		case TVP5146_MODE_PAL:
> -			std = V4L2_STD_PAL;
> -			break;
> -		case TVP5146_MODE_PAL_M:
> -			std = V4L2_STD_PAL_M;
> -			break;
> -		case TVP5146_MODE_PAL_CN:
> -			std = V4L2_STD_PAL_N;
> -			break;
> -		case TVP5146_MODE_SECAM:
> -			std = V4L2_STD_SECAM;
> -			break;
> -		case TVP5146_MODE_PAL_60:
> -			std = V4L2_STD_PAL_60;
> -			break;
> -		}
> -
> -		if (params->mode & 0x8) {	/* square pixel mode */
> -			std <<= 32;
> -		}
> -
> -		if (params->mode == TVP5146_MODE_AUTO) {	/* auto-detection modes */
> -			std = VPFE_STD_AUTO;
> -		} else if (params->mode == TVP5146_MODE_AUTO_SQP) {
> -			std = VPFE_STD_AUTO_SQP;
> -		}
> -
> -		if (std & V4L2_STD_625_50) {
> -			vpfe->bounds = pal_bounds;
> -			vpfe->pixelaspect = pal_aspect;
> -		} else if (std & V4L2_STD_525_60) {
> -			vpfe->bounds = ntsc_bounds;
> -			vpfe->pixelaspect = ntsc_aspect;
> -		} else if (std & VPFE_STD_625_50_SQP) {
> -			vpfe->bounds = palsp_bounds;
> -			vpfe->pixelaspect = sp_aspect;
> -		} else if (std & VPFE_STD_525_60_SQP) {
> -			vpfe->bounds = ntscsp_bounds;
> -			vpfe->pixelaspect = sp_aspect;
> -		}
> -		vpfe->std = std;
> -		tvp5146_ctrl(TVP5146_CONFIG, params);
> -		vpfe->tvp5146_params = *params;
> -		up(&vpfe->lock);
> -		break;
> -	}
> -	default:
> -		ret = -ENOIOCTLCMD;
> -		break;
> -	}			/* end switch(cmd) */
> -	return ret;
> -}
> -
> -static int vpfe_ioctl(struct inode *inode, struct file *file,
> -		      unsigned int cmd, unsigned long arg)
> -{
> -	int ret;
> -	ret =  video_usercopy(inode, file, cmd, arg, vpfe_doioctl);
> -	if( cmd == VIDIOC_S_FMT || cmd == VIDIOC_TRY_FMT ){
> -		ret = video_usercopy(inode, file, VIDIOC_G_FMT,
> -			arg, vpfe_doioctl);
> -	}
> -	return ret;
> -}
> -
> -static int vpfe_mmap(struct file *file, struct vm_area_struct *vma)
> -{
> -	return videobuf_mmap_mapper(&vpfe_device.bufqueue, vma);
> -}
> -
> -static int vpfe_open(struct inode *inode, struct file *filep)
> -{
> -	int minor = iminor(inode);
> -	vpfe_obj *vpfe = NULL;
> -	vpfe_fh *fh = NULL;
> -
> -	debug_print(KERN_INFO "vpfe: open minor=%d\n", minor);
> -
> -	/* check to make sure the minor numbers match */
> -	if (vpfe_device.video_dev && vpfe_device.video_dev->minor == minor) {
> -		vpfe = &vpfe_device;
> -	} else {		/* device not found here */
> -		return -ENODEV;
> -	}
> -
> -	/* allocate per filehandle data */
> -	if ((fh = kmalloc(sizeof(*fh), GFP_KERNEL)) == NULL) {
> -		return -ENOMEM;
> -	}
> -	filep->private_data = fh;
> -	fh->dev = vpfe;
> -	fh->io_allowed = FALSE;
> -	fh->prio = V4L2_PRIORITY_UNSET;
> -	v4l2_prio_open(&vpfe->prio, &fh->prio);
> -	vpfe->usrs++;
> -
> -	return 0;
> -}
> -
> -static int vpfe_release(struct inode *inode, struct file *filep)
> -{
> -	vpfe_fh *fh = filep->private_data;
> -	vpfe_obj *vpfe = fh->dev;
> -
> -	down_interruptible(&vpfe->lock);
> -	if (fh->io_allowed) {
> -		vpfe->io_usrs = 0;
> -		ccdc_enable(FALSE);
> -		vpfe->started = FALSE;
> -		videobuf_queue_cancel(&vpfe->bufqueue);
> -		vpfe->numbuffers = VPFE_DEFNUM_FBUFS;
> -	}
> -	vpfe->usrs--;
> -	v4l2_prio_close(&vpfe->prio, &fh->prio);
> -	filep->private_data = NULL;
> -	kfree(fh);
> -	up(&vpfe->lock);
> -
> -	return 0;
> -}
> -
> -static struct file_operations vpfe_fops = {
> -	.owner = THIS_MODULE,
> -	.open = vpfe_open,
> -	.release = vpfe_release,
> -	.ioctl = vpfe_ioctl,
> -	.mmap = vpfe_mmap
> -};
> -
> -static struct video_device vpfe_video_template = {
> -	.name = "vpfe",
> -	.type = VID_TYPE_CAPTURE | VID_TYPE_CLIPPING | VID_TYPE_SCALES,
> -	.hardware = 0,
> -	.fops = &vpfe_fops,
> -	.minor = -1,
> -};
> -
> -static void vpfe_platform_release(struct device *device)
> -{
> -	/* This is called when the reference count goes to zero. */
> -}
> -
> -static int __init vpfe_probe(struct device *device)
> -{
> -	struct video_device *vfd;
> -	vpfe_obj *vpfe = &vpfe_device;
> -
> -	/* alloc video device */
> -	if ((vfd = video_device_alloc()) == NULL) {
> -		return -ENOMEM;
> -	}
> -	*vfd = vpfe_video_template;
> -	vfd->dev = device;
> -	vfd->release = video_device_release;
> -	snprintf(vfd->name, sizeof(vfd->name), "DM644X_VPFE_DRIVER_V%d.%d.%d",
> -		 (VPFE_VERSION_CODE >> 16) & 0xff,
> -		 (VPFE_VERSION_CODE >> 8) & 0xff, (VPFE_VERSION_CODE) & 0xff);
> -
> -	vpfe->video_dev = vfd;
> -	vpfe->usrs = 0;
> -	vpfe->io_usrs = 0;
> -	vpfe->started = FALSE;
> -	vpfe->latest_only = TRUE;
> -
> -	v4l2_prio_init(&vpfe->prio);
> -	init_MUTEX(&vpfe->lock);
> -	/* register video device */
> -	debug_print(KERN_INFO "trying to register vpfe device.\n");
> -	debug_print(KERN_INFO "vpfe=%x,vpfe->video_dev=%x\n", (int)vpfe,
> -		    (int)&vpfe->video_dev);
> -	if (video_register_device(vpfe->video_dev, VFL_TYPE_GRABBER, -1) < 0) {
> -		video_device_release(vpfe->video_dev);
> -		vpfe->video_dev = NULL;
> -		return -1;
> -	}
> -
> -	debug_print(KERN_INFO "DM644X vpfe: driver version V%d.%d.%d loaded\n",
> -		    (VPFE_VERSION_CODE >> 16) & 0xff,
> -		    (VPFE_VERSION_CODE >> 8) & 0xff,
> -		    (VPFE_VERSION_CODE) & 0xff);
> -
> -	debug_print(KERN_INFO "vpfe: registered device video%d\n",
> -		    vpfe->video_dev->minor & 0x1f);
> -
> -	/* all done */
> -	return 0;
> -}
> -
> -static int vpfe_remove(struct device *device)
> -{
> -	/* un-register device */
> -	video_unregister_device(vpfe_device.video_dev);
> -
> -	return 0;
> -}
> -
> -#ifdef NEW
> -static struct platform_driver vpfe_driver = {
> -	.driver = {
> -		.name		= "VPFE",
> -		.owner		= THIS_MODULE,
> -	},
> -	.probe			= vpfe_probe,
> -	.remove			= vpfe_remove,
> -};
> -
> -#else
> -static struct device_driver vpfe_driver = {
> -	.name = "vpfe",
> -	.bus = &platform_bus_type,
> -	.probe = vpfe_probe,
> -	.remove = vpfe_remove,
> -};
> -#endif
> -
> -static struct platform_device _vpfe_device = {
> -	.name = "vpfe",
> -	.id = 1,
> -	.dev = {
> -		.release = vpfe_platform_release,
> -		}
> -};
> -
> -static int vpfe_init(void)
> -{
> -	int i = 0;
> -	void *mem;
> -	/* allocate memory at initialization time to guarentee availability */
> -	for (i = 0; i < VPFE_DEFNUM_FBUFS; i++) {
> -		mem = (void *)__get_free_pages(GFP_KERNEL | GFP_DMA,
> -					       VPFE_MAX_FBUF_ORDER);
> -		if (mem) {
> -			unsigned long adr = (unsigned long)mem;
> -			u32 size = PAGE_SIZE << VPFE_MAX_FBUF_ORDER;
> -			while (size > 0) {
> -				/* make sure the frame buffers
> -				   are never swapped out of memory */
> -				SetPageReserved(virt_to_page(adr));
> -				adr += PAGE_SIZE;
> -				size -= PAGE_SIZE;
> -			}
> -			vpfe_device.fbuffers[i] = (u8 *) mem;
> -			debug_print(KERN_INFO "memory address %d\t%x\n", i,
> -				    mem);
> -		} else {
> -			while (--i >= 0) {
> -				free_pages((unsigned long)vpfe_device.fbuffers[i],
> -					   VPFE_MAX_FBUF_ORDER);
> -			}
> -			debug_print(KERN_INFO
> -				    "frame buffer memory allocation failed.\n");
> -			return -ENOMEM;
> -		}
> -	}
> -	if (driver_register(&vpfe_driver) != 0) {
> -		debug_print(KERN_INFO "driver registration failed\n");
> -		return -1;
> -	}
> -	if (platform_device_register(&_vpfe_device) != 0) {
> -		driver_unregister(&vpfe_driver);
> -		debug_print(KERN_INFO "device registration failed\n");
> -		return -1;
> -	}
> -
> -	ccdc_reset();
> -	tvp5146_ctrl(TVP5146_RESET, NULL);
> -	/* configure the tvp5146 to default parameters */
> -	tvp5146_ctrl(TVP5146_CONFIG, &vpfe_device.tvp5146_params);
> -	/* setup interrupt handling */
> -	request_irq(IRQ_VDINT0, vpfe_isr, SA_INTERRUPT,
> -		    "dm644xv4l2", (void *)&vpfe_device);
> -
> -	printk(KERN_INFO "DaVinci v4l2 capture driver V1.0 loaded\n");
> -	return 0;
> -}
> -
> -static void vpfe_cleanup(void)
> -{
> -	int i = vpfe_device.numbuffers;
> -	platform_device_unregister(&_vpfe_device);
> -	driver_unregister(&vpfe_driver);
> -	/* disable interrupt */
> -	free_irq(IRQ_VDINT0, &vpfe_device);
> -
> -	while (--i >= 0) {
> -		free_pages((unsigned long)vpfe_device.fbuffers[i],
> -			   VPFE_MAX_FBUF_ORDER);
> -	}
> -	debug_print(KERN_INFO "vpfe: un-registered device video.\n");
> -}
> -
> -module_init(vpfe_init);
> -module_exit(vpfe_cleanup);
> diff --git a/drivers/media/video/tvp5146.c b/drivers/media/video/tvp5146.c
> deleted file mode 100644
> index 2ba47eb..0000000
> --- a/drivers/media/video/tvp5146.c
> +++ /dev/null
> @@ -1,649 +0,0 @@
> -/*
> - *
> - *
> - * Copyright (C) 2006 Texas Instruments Inc
> - *
> - * This program is free software; you can redistribute it and/or modify
> - * it under the terms of the GNU General Public License as published by
> - * the Free Software Foundation; either version 2 of the License, or
> - * (at your option) any later version.
> - *
> - * This program is distributed in the hope that it will be useful,
> - * but WITHOUT ANY WARRANTY; without even the implied warranty of
> - * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> - * GNU General Public License for more details.
> - *
> - * You should have received a copy of the GNU General Public License
> - * along with this program; if not, write to the Free Software
> - * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
> - */
> -/* tvp5146.c */
> -
> -#include <linux/init.h>
> -#include <linux/fs.h>
> -#include <linux/vmalloc.h>
> -#include <linux/slab.h>
> -#include <linux/proc_fs.h>
> -#include <linux/ctype.h>
> -#include <linux/delay.h>
> -#include <linux/i2c.h>
> -#include <linux/videodev.h>
> -#include <media/tvp5146.h>
> -
> -#define debug_print(x...)	//printk(x)
> -
> -static struct i2c_client tvp5146_i2c_client;
> -static struct i2c_driver tvp5146_i2c_driver;
> -
> -static int i2c_read_reg(struct i2c_client *client, u8 reg, u8 * val);
> -static int i2c_write_reg(struct i2c_client *client, u8 reg, u8 val);
> -
> -static int configtvp5146(void *arg);
> -static int clrtvp5146lostlock(void);
> -static int enabletvp5146agc(int arg);
> -static int getctrl(void *arg);
> -static int gettvp5146status(void *arg);
> -static int powerdowntvp5146(int powerdownenable);
> -static int queryctrl(void *arg);
> -static int resettvp5146(void);
> -static int setctrl(void *arg);
> -static int settvp5146amuxmode(int mode);
> -static int settvp5146brightness(int arg);
> -static int settvp5146contrast(int arg);
> -static int settvp5146hue(int arg);
> -static int settvp5146saturation(int arg);
> -static int settvp5146std(int arg);
> -static int setup656sync(int enable);
> -
> -/*
> - * ======== configtvp5146 ========
> - */
> -static int configtvp5146(void *arg)
> -{
> -	tvp5146_params *tvp5146params = (tvp5146_params *) arg;
> -	int ret = 0;
> -
> -	ret |= setup656sync(tvp5146params->enablebt656sync);
> -	ret |= settvp5146amuxmode(tvp5146params->amuxmode);
> -	ret |= settvp5146std(tvp5146params->mode);
> -
> -	return ret;
> -}
> -
> -/*
> - * ======== clrtvp5146lostlock  ========
> - */
> -static int clrtvp5146lostlock(void)
> -{
> -	int ret = 0;
> -	u8 clr = 1;
> -	ret = i2c_write_reg(&tvp5146_i2c_client, 0x39, clr);
> -	return ret;
> -}
> -
> -/*
> - * ========  enabletvp5146agc ========
> - */
> -static int enabletvp5146agc(int arg)
> -{
> -	int ret = 0;
> -	int agc;
> -	if (arg == TRUE) {
> -		agc = 0xF;
> -	} else {
> -		agc = 0xC;
> -	}
> -	ret = i2c_write_reg(&tvp5146_i2c_client, 0x01, agc);
> -	return ret;
> -}
> -
> -/*
> - * ========  gettvpctrl ========
> - */
> -static int getctrl(void *arg)
> -{
> -	struct v4l2_control *ctrl = arg;
> -	int ret = 0;
> -	u8 value;
> -
> -	switch (ctrl->id) {
> -	case V4L2_CID_BRIGHTNESS:
> -		ret = i2c_read_reg(&tvp5146_i2c_client, 0x09, &value);
> -		ctrl->value = value;
> -		break;
> -	case V4L2_CID_CONTRAST:
> -		ret = i2c_read_reg(&tvp5146_i2c_client, 0x0A, &value);
> -		ctrl->value = value;
> -		break;
> -	case V4L2_CID_SATURATION:
> -		ret = i2c_read_reg(&tvp5146_i2c_client, 0x0B, &value);
> -		ctrl->value = value;
> -		break;
> -	case V4L2_CID_HUE:
> -		ret = i2c_read_reg(&tvp5146_i2c_client, 0x0C, &value);
> -		ctrl->value = value;
> -		break;
> -	case V4L2_CID_AUTOGAIN:
> -		ret = i2c_read_reg(&tvp5146_i2c_client, 0x01, &value);
> -		if ((value & 0x3) == 3) {
> -			ctrl->value = TRUE;
> -		} else {
> -			ctrl->value = FALSE;
> -		}
> -		break;
> -	default:
> -		ret = -EINVAL;
> -		break;
> -	}
> -	return ret;
> -}
> -
> -/*
> - * ========  gettvp5146std ========
> - */
> -static int gettvp5146std(tvp5146_mode * mode)
> -{
> -	int ret = 0;
> -	u8 output1;
> -	u8 std;
> -	u8 lock_status;
> -
> -	ret |= i2c_read_reg(&tvp5146_i2c_client, 0x2, &std);
> -	std &= 0x7;
> -	if(std == TVP5146_MODE_AUTO){
> -		ret |= i2c_read_reg(&tvp5146_i2c_client, 0x3F, &std);
> -	}
> -	std &= 0x7;
> -	ret |= i2c_read_reg(&tvp5146_i2c_client, 0x33, &output1);
> -	*mode = std  | ((output1 & 0x80) >> 4);	/* square pixel status */
> -	ret |= i2c_read_reg(&tvp5146_i2c_client, 0x3A, &lock_status);
> -	if ((lock_status & 0xe) != 0xe) {
> -		/* not quite locked */
> -		ret = -EAGAIN;
> -	}
> -
> -	return ret;
> -}
> -
> -/*
> - * ========  gettvp5146status ========
> - */
> -static int gettvp5146status(void *arg)
> -{
> -	int ret = 0;
> -	tvp5146_status *status = (tvp5146_status *) arg;
> -	u8 agc, brightness, contrast, hue, saturation;
> -	u8 status_byte;
> -	u8 std;
> -	u8 output1;
> -
> -	ret = i2c_read_reg(&tvp5146_i2c_client, 0x01, &agc);
> -	if ((agc & 0x3) == 3) {
> -		status->agc_enable = TRUE;
> -	} else {
> -		status->agc_enable = FALSE;
> -	}
> -	ret |= i2c_read_reg(&tvp5146_i2c_client, 0x09, &brightness);
> -	status->brightness = brightness;
> -
> -	ret |= i2c_read_reg(&tvp5146_i2c_client, 0x0A, &contrast);
> -	status->contrast = contrast;
> -
> -	ret |= i2c_read_reg(&tvp5146_i2c_client, 0x0B, &saturation);
> -	status->saturation = saturation;
> -
> -	ret |= i2c_read_reg(&tvp5146_i2c_client, 0x0C, &hue);
> -	status->hue = hue;
> -
> -	ret |= i2c_read_reg(&tvp5146_i2c_client, 0x3A, &status_byte);
> -	status->field_rate = (status_byte & 0x20) ? 50 : 60;
> -	status->lost_lock = (status_byte & 0x10) >> 4;
> -	status->csubc_lock = (status_byte & 0x8) >> 3;
> -	status->v_lock = (status_byte & 0x4) >> 2;
> -	status->h_lock = (status_byte & 0x2) >> 1;
> -
> -	ret |= i2c_read_reg(&tvp5146_i2c_client, 0x3F, &std);
> -	ret |= i2c_read_reg(&tvp5146_i2c_client, 0x33, &output1);
> -	if (std | 0x80) {	/* auto switch mode */
> -		status->video_std = TVP5146_MODE_AUTO;
> -	} else {
> -		status->video_std = std;
> -	}
> -	status->video_std |= ((output1 & 0x80) >> 4);	/* square pixel status */
> -	return ret;
> -}
> -
> -/*
> - * ======== powerdowntvp5146 ========
> - */
> -static int powerdowntvp5146(int powerdownenable)
> -{
> -	u8 powerdownsettings = 0x01;
> -
> -	/*Put _tvp5146 in power down mode */
> -	if (!powerdownenable) {
> -		powerdownsettings = 0x00;
> -	}
> -	return i2c_write_reg(&tvp5146_i2c_client, 0x03, powerdownsettings);
> -}
> -
> -/*
> - * ======== resettvp5146========
> - */
> -static int resettvp5146(void)
> -{
> -	setup656sync(TRUE);
> -	settvp5146amuxmode(TVP5146_AMUX_COMPOSITE);
> -	return powerdowntvp5146(FALSE);
> -}
> -
> -/*
> - * ======== queryctrl ========
> - */
> -static int queryctrl(void *arg)
> -{
> -	struct v4l2_queryctrl *queryctrl = arg;
> -	int ret = 0;
> -	int id = queryctrl->id;
> -
> -	memset(queryctrl, 0, sizeof(*queryctrl));
> -	queryctrl->id = id;
> -	switch (id) {
> -	case V4L2_CID_BRIGHTNESS:
> -		strcpy(queryctrl->name, "BRIGHTNESS");
> -		queryctrl->type = V4L2_CTRL_TYPE_INTEGER;
> -		queryctrl->minimum = 0;
> -		queryctrl->maximum = 255;
> -		queryctrl->step = 1;
> -		queryctrl->default_value = 128;
> -		break;
> -	case V4L2_CID_CONTRAST:
> -		strcpy(queryctrl->name, "CONTRAST");
> -		queryctrl->type = V4L2_CTRL_TYPE_INTEGER;
> -		queryctrl->minimum = 0;
> -		queryctrl->maximum = 255;
> -		queryctrl->step = 1;
> -		queryctrl->default_value = 128;
> -		break;
> -
> -	case V4L2_CID_SATURATION:
> -		strcpy(queryctrl->name, "SATURATION");
> -		queryctrl->type = V4L2_CTRL_TYPE_INTEGER;
> -		queryctrl->minimum = 0;
> -		queryctrl->maximum = 255;
> -		queryctrl->step = 1;
> -		queryctrl->default_value = 128;
> -		break;
> -	case V4L2_CID_HUE:
> -		strcpy(queryctrl->name, "HUE");
> -		queryctrl->type = V4L2_CTRL_TYPE_INTEGER;
> -		queryctrl->minimum = -128;	/* -180 DEGREE */
> -		queryctrl->maximum = 127;	/* 180  DEGREE */
> -		queryctrl->step = 1;
> -		queryctrl->default_value = 0;	/* 0 DEGREE */
> -		break;
> -
> -	case V4L2_CID_AUTOGAIN:
> -		strcpy(queryctrl->name, "Automatic Gain Control");
> -		queryctrl->type = V4L2_CTRL_TYPE_BOOLEAN;
> -		queryctrl->minimum = 0;
> -		queryctrl->maximum = 1;
> -		queryctrl->step = 1;
> -		queryctrl->default_value = 1;
> -		break;
> -	default:
> -		if (id < V4L2_CID_LASTP1)
> -			queryctrl->flags = V4L2_CTRL_FLAG_DISABLED;
> -		else
> -			ret = -EINVAL;
> -		break;
> -	}			/* end switch (id) */
> -	return ret;
> -}
> -
> -/*
> - * ======== setctrl ========
> - */
> -static int setctrl(void *arg)
> -{
> -	struct v4l2_control *ctrl = arg;
> -	int ret = 0;
> -
> -	switch (ctrl->id) {
> -	case V4L2_CID_BRIGHTNESS:
> -		ret = settvp5146brightness(ctrl->value);
> -		break;
> -	case V4L2_CID_CONTRAST:
> -		ret = settvp5146contrast(ctrl->value);
> -		break;
> -	case V4L2_CID_SATURATION:
> -		ret = settvp5146saturation(ctrl->value);
> -		break;
> -	case V4L2_CID_HUE:
> -		ret = settvp5146hue(ctrl->value);
> -		break;
> -	case V4L2_CID_AUTOGAIN:
> -		ret = enabletvp5146agc(ctrl->value);
> -		break;
> -	default:
> -		ret = -EINVAL;
> -		break;
> -	}
> -	return ret;
> -}
> -
> -/*
> - * ======== settvp5146amuxmode ========
> - */
> -static int settvp5146amuxmode(int arg)
> -{
> -	u8 input_sel;
> -
> -	if (arg == TVP5146_AMUX_COMPOSITE) {	/* composite */
> -		input_sel = 0x05;
> -	} else if (arg == TVP5146_AMUX_SVIDEO) {	/* s-video */
> -		input_sel = 0x46;
> -	} else {
> -		return -EINVAL;
> -	}
> -	return i2c_write_reg(&tvp5146_i2c_client, 0x00, input_sel);
> -}
> -
> -/*
> - * ======== settvp5146brightness ========
> - */
> -static int settvp5146brightness(int arg)
> -{
> -	int ret = 0;
> -	u8 brightness = (u8) arg;
> -	ret = i2c_write_reg(&tvp5146_i2c_client, 0x09, brightness);
> -	return ret;
> -}
> -
> -/*
> -* ======== settvp5146contrast ========
> -*/
> -static int settvp5146contrast(int arg)
> -{
> -	int ret = 0;
> -	u8 contrast = (u8) arg;
> -	ret = i2c_write_reg(&tvp5146_i2c_client, 0x0A, contrast);
> -	return ret;
> -}
> -
> -/*
> -* ======== settvp5146hue ========
> -*/
> -static int settvp5146hue(int arg)
> -{
> -	int ret = 0;
> -	u8 hue = (u8) arg;
> -	ret = i2c_write_reg(&tvp5146_i2c_client, 0x0C, hue);
> -	return ret;
> -}
> -
> -static int settvp5146saturation(int arg)
> -{
> -	int ret = 0;
> -	u8 saturation = (u8) arg;
> -	ret = i2c_write_reg(&tvp5146_i2c_client, 0x0B, saturation);
> -	return ret;
> -}
> -
> -static int settvp5146std(int arg)
> -{
> -	int ret = 0;
> -	u8 std = (u8) arg & 0x7;	/* the 4th-bit is for squre pixel sampling */
> -	u8 output1;
> -
> -	/* setup the sampling rate: 601 or square pixel */
> -	debug_print(KERN_INFO "reading i2c registers.\n");
> -	ret = i2c_read_reg(&tvp5146_i2c_client, 0x33, &output1);
> -	output1 |= ((arg & 0x8) << 4);
> -	ret = i2c_write_reg(&tvp5146_i2c_client, 0x33, output1);
> -
> -	/* setup the video standard */
> -	ret |= i2c_write_reg(&tvp5146_i2c_client, 0x02, std);
> -	/* if autoswitch mode, enable all modes for autoswitch */
> -	if (std == TVP5146_MODE_AUTO) {
> -		u8 mask = 0x3F;	/* enable autoswitch for  all standards */
> -		ret = i2c_write_reg(&tvp5146_i2c_client, 0x04, mask);
> -	}
> -
> -	return ret;
> -}
> -
> -/*
> - * ======== setup656sync ========
> - */
> -static int setup656sync(int enable)
> -{
> -	int output1, output2, output3, output4;
> -	int output5, output6;
> -	int ret = 0;
> -
> -	if (enable) {
> -		output1 = 0x40;
> -		output4 = 0xFF;
> -		output6 = 0;
> -	} else {
> -		output1 = 0x43;
> -		output4 = 0xAF;
> -		output6 = 0x1E;
> -	}
> -
> -	output2 = 0x11;		/* enable clock, enable Y[9:0] */
> -	output3 = 0x0;
> -	output5 = 0x4;
> -
> -	ret |= i2c_write_reg(&tvp5146_i2c_client, 0x33, output1);
> -	ret |= i2c_write_reg(&tvp5146_i2c_client, 0x34, output2);
> -	ret |= i2c_write_reg(&tvp5146_i2c_client, 0x36, output4);
> -	ret |= i2c_write_reg(&tvp5146_i2c_client, 0x08, output3);
> -	ret |= i2c_write_reg(&tvp5146_i2c_client, 0x0e, output5);
> -	ret |= i2c_write_reg(&tvp5146_i2c_client, 0x32, output6);
> -	return ret;
> -}
> -
> -/*
> - * ======== tvp5146_ctrl ========
> - */
> -int tvp5146_ctrl(tvp5146_cmd cmd, void *arg)
> -{
> -	int ret = 0;
> -	switch (cmd) {
> -	case TVP5146_CONFIG:
> -		ret = configtvp5146(arg);
> -		break;
> -	case TVP5146_RESET:
> -		ret = resettvp5146();
> -		break;
> -	case TVP5146_POWERDOWN:
> -		ret = powerdowntvp5146(*(int *)arg);
> -		break;
> -	case TVP5146_SET_AMUXMODE:
> -		ret = settvp5146amuxmode(*(int *)arg);
> -		break;
> -	case TVP5146_SET_BRIGHTNESS:
> -		ret = settvp5146brightness(*(int *)arg);
> -		break;
> -	case TVP5146_SET_CONTRAST:
> -		ret = settvp5146contrast(*(int *)arg);
> -		break;
> -	case TVP5146_SET_HUE:
> -		ret = settvp5146hue(*(int *)arg);
> -		break;
> -	case TVP5146_SET_SATURATION:
> -		ret = settvp5146saturation(*(int *)arg);
> -		break;
> -	case TVP5146_SET_AGC:
> -		ret = enabletvp5146agc(*(int *)arg);
> -		break;
> -	case TVP5146_SET_VIDEOSTD:
> -		ret = settvp5146std(*(int *)arg);
> -		break;
> -	case TVP5146_CLR_LOSTLOCK:
> -		ret = clrtvp5146lostlock();
> -		break;
> -	case TVP5146_GET_STATUS:
> -		ret = gettvp5146status(arg);
> -		break;
> -	case TVP5146_GET_STD:
> -		ret = gettvp5146std(arg);
> -		break;
> -	case VIDIOC_QUERYCTRL:
> -		ret = queryctrl(arg);
> -		break;
> -	case VIDIOC_G_CTRL:
> -		ret = getctrl(arg);
> -		break;
> -	case VIDIOC_S_CTRL:
> -		ret = setctrl(arg);
> -		break;
> -	default:
> -		ret = -EINVAL;
> -	}
> -	return ret;
> -}
> -
> -static int i2c_read_reg(struct i2c_client *client, u8 reg, u8 * val)
> -{
> -	int err = 0;
> -
> -	struct i2c_msg msg[1];
> -	unsigned char data[1];
> -
> -	if (!client->adapter) {
> -		err = -ENODEV;
> -	} else {
> -		msg->addr = client->addr;
> -		msg->flags = 0;
> -		msg->len = 1;
> -		msg->buf = data;
> -		data[0] = reg;
> -		err = i2c_transfer(client->adapter, msg, 1);
> -		if (err >= 0) {
> -			msg->flags = I2C_M_RD;
> -			err = i2c_transfer(client->adapter, msg, 1);
> -			if (err >= 0) {
> -				*val = data[0];
> -			}
> -		}
> -	}
> -	return err;
> -}
> -
> -static int i2c_write_reg(struct i2c_client *client, u8 reg, u8 val)
> -{
> -	int err = 0;
> -
> -	struct i2c_msg msg[1];
> -	unsigned char data[2];
> -
> -	if (!client->adapter) {
> -		err = -ENODEV;
> -	} else {
> -		msg->addr = client->addr;
> -		msg->flags = 0;
> -		msg->len = 2;
> -		msg->buf = data;
> -		data[0] = reg;
> -		data[1] = val;
> -		err = i2c_transfer(client->adapter, msg, 1);
> -	}
> -	debug_print(KERN_INFO " i2c data write \n");
> -
> -	return err;
> -}
> -
> -static int _i2c_attach_client(struct i2c_client *client,
> -			      struct i2c_driver *driver,
> -			      struct i2c_adapter *adap, int addr)
> -{
> -	int err = 0;
> -
> -	if (client->adapter) {
> -		err = -EBUSY;	/* our client is already attached */
> -	} else {
> -		client->addr = addr;
> -/* 		client->flags = I2C_CLIENT_ALLOW_USE; */
> -		client->driver = driver;
> -		client->adapter = adap;
> -
> -		err = i2c_attach_client(client);
> -		if (err) {
> -			client->adapter = NULL;
> -		}
> -	}
> -	return err;
> -}
> -
> -static int _i2c_detach_client(struct i2c_client *client)
> -{
> -	int err = 0;
> -
> -	if (!client->adapter) {
> -		return -ENODEV;	/* our client isn't attached */
> -	} else {
> -		err = i2c_detach_client(client);
> -		client->adapter = NULL;
> -	}
> -	return err;
> -}
> -
> -static int tvp5146_i2c_probe_adapter(struct i2c_adapter *adap)
> -{
> -	return _i2c_attach_client(&tvp5146_i2c_client, &tvp5146_i2c_driver,
> -				  adap, TVP5146_I2C_ADDR);
> -}
> -
> -static struct i2c_driver tvp5146_i2c_driver = {
> -	.driver = {
> -		.name = "tvp5146",
> -	},
> -	.id = I2C_DRIVERID_TVP5150,
> -
> -	.attach_adapter = tvp5146_i2c_probe_adapter,
> -	.detach_client = _i2c_detach_client,
> -};
> -
> -static int tvp5146_i2c_init(void)
> -{
> -	int err;
> -	struct i2c_driver *driver = &tvp5146_i2c_driver;
> -
> -/* 	driver->owner = THIS_MODULE; */
> -/* 	strlcpy(driver->name, "TVP5146 Video Decoder I2C driver", */
> -/* 		sizeof(driver->name)); */
> -/* 	driver->id = I2C_DRIVERID_EXP0; */
> -/* 	driver->flags = I2C_DF_NOTIFY; */
> -/* 	driver->attach_adapter = tvp5146_i2c_probe_adapter; */
> -/* 	driver->detach_client = _i2c_detach_client; */
> -
> -	err = i2c_add_driver(driver);
> -	if (err) {
> -		debug_print(KERN_ERR
> -			"Failed to register TVP5146 I2C client.\n");
> -	}
> -	debug_print(KERN_INFO "tvp5146 driver registered.\n");
> -	return err;
> -}
> -
> -static void tvp5146_i2c_cleanup(void)
> -{
> -	struct i2c_driver *driver = &tvp5146_i2c_driver;
> -
> -	i2c_detach_client(&tvp5146_i2c_client);
> -	i2c_del_driver(driver);
> -	tvp5146_i2c_client.adapter = NULL;
> -}
> -
> -module_init(tvp5146_i2c_init);
> -module_exit(tvp5146_i2c_cleanup);
> -
> -EXPORT_SYMBOL(tvp5146_ctrl);
> -MODULE_LICENSE("GPL");
> -
> -/**************************************************************************/
> -/* End of file                                                                            */
> -/**************************************************************************/
> diff --git a/include/media/ccdc_davinci.h b/include/media/ccdc_davinci.h
> deleted file mode 100644
> index 9f0a08d..0000000
> --- a/include/media/ccdc_davinci.h
> +++ /dev/null
> @@ -1,144 +0,0 @@
> -/*
> - *
> - * Copyright (C) 2006 Texas Instruments Inc
> - *
> - * This program is free software; you can redistribute it and/or modify
> - * it under the terms of the GNU General Public License as published by
> - * the Free Software Foundation; either version 2 of the License, or
> - * (at your option) any later version.
> - *
> - * This program is distributed in the hope that it will be useful,
> - * but WITHOUT ANY WARRANTY; without even the implied warranty of
> - * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> - * GNU General Public License for more details.
> - *
> - * You should have received a copy of the GNU General Public License
> - * along with this program; if not, write to the Free Software
> - * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
> - */
> -/* ccdc_davinci.h */
> -
> -#ifndef CCDC_DAVINCI_H
> -#define CCDC_DAVINCI_H
> -#include <linux/types.h>
> -
> -#ifdef __KERNEL__
> -#include <asm/arch/hardware.h>
> -#include <asm/io.h>
> -#endif
> -
> -#include <linux/videodev.h>
> -
> -typedef enum ccdc_pixfmt {
> -	CCDC_PIXFMT_RAW = 0,
> -	CCDC_PIXFMT_YCBCR_16BIT = 1,
> -	CCDC_PIXFMT_YCBCR_8BIT = 2
> -} ccdc_pixfmt;
> -
> -typedef enum ccdc_frmfmt {
> -	CCDC_FRMFMT_PROGRESSIVE = 0,
> -	CCDC_FRMFMT_INTERLACED = 1
> -} ccdc_frmfmt;
> -
> -typedef enum ccdc_pinpol {
> -	CCDC_PINPOL_POSITIVE = 0,
> -	CCDC_PINPOL_NEGATIVE = 1
> -} ccdc_pinpol;
> -
> -/* PIXEL ORDER IN MEMORY from LSB to MSB */
> -/* only applicable for 8-bit input mode  */
> -typedef enum ccdc_pixorder {
> -	CCDC_PIXORDER_CBYCRY = 1,
> -	CCDC_PIXORDER_YCBYCR = 0
> -} ccdc_pixorder;
> -
> -typedef enum ccdc_buftype {
> -	CCDC_BUFTYPE_FLD_INTERLEAVED,
> -	CCDC_BUFTYPE_FLD_SEPARATED
> -} ccdc_buftype;
> -
> -typedef struct v4l2_rect ccdc_imgwin;
> -
> -typedef struct ccdc_params_ycbcr {
> -	ccdc_pixfmt pix_fmt;	/* pixel format                     */
> -	ccdc_frmfmt frm_fmt;	/* progressive or interlaced frame  */
> -	ccdc_imgwin win;	/* video window                     */
> -	ccdc_pinpol fid_pol;	/* field id polarity                */
> -	ccdc_pinpol vd_pol;	/* vertical sync polarity           */
> -	ccdc_pinpol hd_pol;	/* horizontal sync polarity         */
> -	int bt656_enable;	/* enable BT.656 embedded sync mode */
> -	ccdc_pixorder pix_order;/* cb:y:cr:y or y:cb:y:cr in memory */
> -	ccdc_buftype buf_type;	/* interleaved or separated fields  */
> -} ccdc_params_ycbcr;
> -
> -#ifdef __KERNEL__
> -/**************************************************************************\
> -* Register OFFSET Definitions
> -\**************************************************************************/
> -#define PID                             0x0
> -#define PCR                             0x4
> -#define SYN_MODE                        0x8
> -#define HD_VD_WID                       0xc
> -#define PIX_LINES                       0x10
> -#define HORZ_INFO                       0x14
> -#define VERT_START                      0x18
> -#define VERT_LINES                      0x1c
> -#define CULLING                         0x20
> -#define HSIZE_OFF                       0x24
> -#define SDOFST                          0x28
> -#define SDR_ADDR                        0x2c
> -#define CLAMP                           0x30
> -#define DCSUB                           0x34
> -#define COLPTN                          0x38
> -#define BLKCMP                          0x3c
> -#define FPC                             0x40
> -#define FPC_ADDR                        0x44
> -#define VDINT                           0x48
> -#define ALAW                            0x4c
> -#define REC656IF                        0x50
> -#define CCDCFG                          0x54
> -#define FMTCFG                          0x58
> -#define FMT_HORZ                        0x5c
> -#define FMT_VERT                        0x50
> -#define FMT_ADDR0                       0x64
> -#define FMT_ADDR1                       0x68
> -#define FMT_ADDR2                       0x6c
> -#define FMT_ADDR3                       0x70
> -#define FMT_ADDR4                       0x74
> -#define FMT_ADDR5                       0x78
> -#define FMT_ADDR6                       0x7c
> -#define FMT_ADDR7                       0x80
> -#define PRGEVEN_0                       0x84
> -#define PRGEVEN_1                       0x88
> -#define PRGODD_0                        0x8c
> -#define PRGODD_1                        0x90
> -#define VP_OUT                          0x94
> -
> -#define CCDC_IOBASE                     (0x01c70400)
> -
> -#define regw(val, reg)    davinci_writel(val, (reg)+CCDC_IOBASE)
> -#define regr(reg)         davinci_readl((reg)+CCDC_IOBASE)
> -
> -extern void ccdc_reset(void);
> -extern void ccdc_config_ycbcr(ccdc_params_ycbcr * params);
> -extern void ccdc_setwin(ccdc_params_ycbcr * params);
> -
> -/* inline functions that must be fast because they are called frequently */
> -static inline void ccdc_enable(int flag)
> -{
> -	regw(flag, PCR);
> -}
> -
> -static inline void ccdc_setfbaddr(unsigned long paddr)
> -{
> -	regw(paddr & 0xffffffe0, SDR_ADDR);
> -}
> -
> -static inline int ccdc_getfid(void)
> -{
> -	int fid = (regr(SYN_MODE) >> 15) & 0x1;
> -	return fid;
> -}
> -#endif
> -
> -#endif /* CCDC_DAVINCI_H */
> diff --git a/include/media/davinci_vpfe.h b/include/media/davinci_vpfe.h
> deleted file mode 100644
> index 26e7b2c..0000000
> --- a/include/media/davinci_vpfe.h
> +++ /dev/null
> @@ -1,121 +0,0 @@
> -/*
> - * Copyright (C) 2006 Texas Instruments Inc
> - *
> - * This program is free software; you can redistribute it and/or modify
> - * it under the terms of the GNU General Public License as published by
> - * the Free Software Foundation; either version 2 of the License, or
> - * (at your option) any later version.
> - *
> - * This program is distributed in the hope that it will be useful,
> - * but WITHOUT ANY WARRANTY; without even the implied warranty of
> - * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> - * GNU General Public License for more details.
> - *
> - * You should have received a copy of the GNU General Public License
> - * along with this program; if not, write to the Free Software
> - * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
> - */
> -/* davinci_vpfe.h */
> -
> -#ifndef DAVINCI_VPFE_H
> -#define DAVINCI_VPFE_H
> -#ifdef __KERNEL__
> -#include <media/v4l2-dev.h>
> -#endif
> -
> -#include <media/ccdc_davinci.h>
> -#include <media/tvp5146.h>
> -
> -#define TRUE 1
> -#define FALSE 0
> -
> -/* vpfe specific video standards */
> -#define VPFE_STD_625_50_SQP ((V4L2_STD_625_50)<<32)
> -#define VPFE_STD_525_60_SQP ((V4L2_STD_525_60)<<32)
> -#define VPFE_STD_AUTO ((v4l2_std_id)(0x1000000000000000ULL))
> -#define VPFE_STD_AUTO_SQP ((v4l2_std_id)(0x2000000000000000ULL))
> -
> -#define VPFE_CMD_CONFIG_CCDC _IOW('V',BASE_VIDIOC_PRIVATE + 1,ccdc_params_ycbcr)
> -#define VPFE_CMD_LATEST_FRM_ONLY   _IOW('V',BASE_VIDIOC_PRIVATE + 2,int)
> -#define VPFE_CMD_CONFIG_TVP5146 _IOW('V',BASE_VIDIOC_PRIVATE + 3,tvp5146_params)
> -
> -/* settings for commonly used video formats */
> -#define VPFE_WIN_NTSC    {0,0,720,480}
> -#define VPFE_WIN_PAL     {0,0,720,576}
> -#define VPFE_WIN_NTSC_SP {0,0,640,480}	/* ntsc square pixel */
> -#define VPFE_WIN_PAL_SP  {0,0,768,576}	/* pal square pixel */
> -#define VPFE_WIN_CIF     {0,0,352,288}
> -#define VPFE_WIN_QCIF    {0,0,176,144}
> -#define VPFE_WIN_QVGA    {0,0,320,240}
> -#define VPFE_WIN_SIF     {0,0,352,240}
> -
> -
> -#ifdef __KERNEL__
> -
> -#include <media/video-buf.h>
> -
> -#define VPFE_MAJOR_RELEASE 0
> -#define VPFE_MINOR_RELEASE 0
> -#define VPFE_BUILD         1
> -
> -#define VPFE_VERSION_CODE \
> -     (VPFE_MAJOR_RELEASE<<16)  | (VPFE_MINOR_RELEASE<<8) | VPFE_BUILD
> -
> -/* By default, the driver is setup for auto-swich mode */
> -#define VPFE_DEFAULT_STD VPFE_STD_AUTO
> -
> -#define VPFE_PIXELASPECT_NTSC {11, 10}
> -#define VPFE_PIXELASPECT_PAL  {54, 59}
> -#define VPFE_PIXELASPECT_NTSC_SP    {1, 1}
> -#define VPFE_PIXELASPECT_PAL_SP     {1, 1}
> -#define VPFE_PIXELASPECT_DEFAULT    {1, 1}
> -
> -#define VPFE_MAX_FRAME_WIDTH      768	/* account for PAL Square pixel mode */
> -#define VPFE_MAX_FRAME_HEIGHT     576	/* account for PAL                   */
> -/* 4:2:2 data */
> -#define VPFE_MAX_FBUF_SIZE       (VPFE_MAX_FRAME_WIDTH*VPFE_MAX_FRAME_HEIGHT*2)
> -/* frame buffers allocate at driver initialization time */
> -#define VPFE_DEFNUM_FBUFS             3
> -
> -#define VPFE_MAX_FBUF_ORDER \
> -   get_order(roundup_pow_of_two(VPFE_MAX_FBUF_SIZE))
> -
> -/* device object */
> -typedef struct vpfe_obj {
> -	struct video_device *video_dev;
> -	struct videobuf_queue bufqueue;/* queue with frame buffers      */
> -	struct list_head dma_queue;
> -	u32 latest_only;		/* indicate whether to return the most */
> -					/* recent captured buffers only        */
> -	u32 usrs;
> -	u32 io_usrs;
> -	struct v4l2_prio_state prio;
> -	v4l2_std_id std;
> -	struct v4l2_rect vwin;
> -	struct v4l2_rect bounds;
> -	struct v4l2_fract pixelaspect;
> -       	spinlock_t irqlock;
> -	struct semaphore lock;
> -	enum v4l2_field field;
> -	u32 pixelfmt;
> -	u32 numbuffers;
> -	u8* fbuffers[VIDEO_MAX_FRAME];
> -	struct videobuf_buffer *curFrm;
> -	struct videobuf_buffer *nextFrm;
> -	int field_id;
> -	int mode_changed;
> -	int started;
> -	int field_offset;
> -	tvp5146_params tvp5146_params;
> -	ccdc_params_ycbcr ccdc_params;
> -} vpfe_obj;
> -
> -/* file handle */
> -typedef struct vpfe_fh {
> -	struct vpfe_obj *dev;
> -	int io_allowed;
> -	enum v4l2_priority prio;
> -} vpfe_fh;
> -#endif
> -
> -#endif /* DAVINCI_VPFE_H */
> diff --git a/include/media/tvp5146.h b/include/media/tvp5146.h
> deleted file mode 100644
> index c82935f..0000000
> --- a/include/media/tvp5146.h
> +++ /dev/null
> @@ -1,104 +0,0 @@
> -/*
> - *
> - *
> - * Copyright (C) 2006 Texas Instruments Inc
> - *
> - * This program is free software; you can redistribute it and/or modify
> - * it under the terms of the GNU General Public License as published by
> - * the Free Software Foundation; either version 2 of the License, or
> - * (at your option) any later version.
> - *
> - * This program is distributed in the hope that it will be useful,
> - * but WITHOUT ANY WARRANTY; without even the implied warranty of
> - * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> - * GNU General Public License for more details.
> - *
> - * You should have received a copy of the GNU General Public License
> - * along with this program; if not, write to the Free Software
> - * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
> - */
> -/* tvp5146.h file */
> -
> -#ifndef TVP5146_H
> -#define TVP5146_H
> -
> -#ifdef TRUE
> -#undef TRUE
> -#endif
> -#ifdef FALSE
> -#undef FALSE
> -#endif
> -
> -#define TRUE 1
> -#define FALSE 0
> -
> -/* analog muxing mode */
> -#define    TVP5146_AMUX_COMPOSITE  0
> -#define    TVP5146_AMUX_SVIDEO     1
> -
> -typedef enum {
> -	TVP5146_MODE_INV = -1,
> -	TVP5146_MODE_AUTO = 0,	        /* autoswitch mode (default)   */
> -	TVP5146_MODE_NTSC = 1,	        /* (M, J) NTSC      525-line   */
> -	TVP5146_MODE_PAL = 2,	        /* (B, D, G, H, I, N) PAL      */
> -	TVP5146_MODE_PAL_M = 3,	        /* (M) PAL          525-line   */
> -	TVP5146_MODE_PAL_CN = 4,	/* (Combination-N) PAL         */
> -	TVP5146_MODE_NTSC_443 = 5,	/* NTSC 4.43        525-line   */
> -	TVP5146_MODE_SECAM = 6,	        /* SECAM                       */
> -	TVP5146_MODE_PAL_60 = 7,	/* PAL 60          525-line    */
> -	TVP5146_MODE_AUTO_SQP = 8,	/* autoswitch mode (default)   */
> -	TVP5146_MODE_NTSC_SQP = 9,	/* (M, J) NTSC      525-line   */
> -	TVP5146_MODE_PAL_SQP = 0xA,	/* (B, D, G, H, I, N) PAL      */
> -	TVP5146_MODE_PAL_M_SQP = 0xB,	/* (M) PAL          525-line   */
> -	TVP5146_MODE_PAL_CN_SQP = 0xC,	/* (Combination-N) PAL         */
> -	TVP5146_MODE_NTSC_443_SQP = 0xD,/* NTSC 4.43        525-line   */
> -	TVP5146_MODE_SECAM_SQP = 0xE,	/* SECAM                       */
> -	TVP5146_MODE_PAL_60_SQP = 0xF,	/* PAL 60          525-line    */
> -} tvp5146_mode;
> -
> -typedef struct {
> -	tvp5146_mode mode;
> -	int amuxmode;
> -	int enablebt656sync;
> -} tvp5146_params;
> -
> -#ifdef __KERNEL__
> -
> -typedef struct {
> -	int agc_enable;
> -	tvp5146_mode video_std;
> -	int brightness;
> -	int contrast;
> -	int saturation;
> -	int hue;
> -	int field_rate;		/* 50 or 60 in Hz */
> -	int lost_lock;
> -	int csubc_lock;
> -	int v_lock;
> -	int h_lock;
> -} tvp5146_status;
> -
> -typedef unsigned int tvp5146_cmd;
> -
> -/* commands for setup the decoder */
> -#define TVP5146_SET_AMUXMODE        4
> -#define TVP5146_SET_BRIGHTNESS      5
> -#define TVP5146_SET_CONTRAST        6
> -#define TVP5146_SET_HUE             7
> -#define TVP5146_SET_SATURATION      8
> -#define TVP5146_SET_AGC             9
> -#define TVP5146_SET_VIDEOSTD        10
> -#define TVP5146_CLR_LOSTLOCK        11
> -#define TVP5146_CONFIG              12
> -#define TVP5146_RESET               13
> -#define TVP5146_POWERDOWN           14
> -
> -#define TVP5146_GET_STATUS          15
> -#define TVP5146_GET_STD             16
> -
> -#define TVP5146_I2C_ADDR (0xBA >> 1)
> -
> -extern int tvp5146_ctrl(tvp5146_cmd cmd, void *arg);
> -
> -#endif
> -#endif
> -- 
> 1.6.0.4
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
