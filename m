Return-path: <mchehab@pedra>
Received: from mailout2.samsung.com ([203.254.224.25]:26230 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752135Ab1DAIva (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 1 Apr 2011 04:51:30 -0400
Date: Fri, 01 Apr 2011 10:51:13 +0200
From: Marek Szyprowski <m.szyprowski@samsung.com>
Subject: RE: [PATCH 1/2] media: vb2: add frame buffer emulator for video output
 devices
In-reply-to: <002801cbf047$cbd1a710$6374f530$%han@samsung.com>
To: 'Jonghun Han' <jonghun.han@samsung.com>,
	linux-samsung-soc@vger.kernel.org, linux-media@vger.kernel.org
Cc: kyungmin.park@samsung.com,
	Tomasz Stanislawski <t.stanislaws@samsung.com>,
	=?ks_c_5601-1987?B?J7DtwOe47Sc=?= <jemings@samsung.com>,
	=?ks_c_5601-1987?B?J8DMwM/Ioyc=?= <ilho215.lee@samsung.com>,
	pawel@osciak.com
Message-id: <003601cbf049$f83c6ea0$e8b54be0$%szyprowski@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=ks_c_5601-1987
Content-language: pl
Content-transfer-encoding: 7BIT
References: <1301468448-25524-1-git-send-email-m.szyprowski@samsung.com>
 <1301468448-25524-2-git-send-email-m.szyprowski@samsung.com>
 <002801cbf047$cbd1a710$6374f530$%han@samsung.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hello,

On Friday, April 01, 2011 10:36 AM Jonghun Han wrote:
 
> On Wednesday, March 30, 2011 4:01 PM Marek Szyprowski wrote:
> >
> > This patch adds generic frame buffer emulator for any video output device
> > that uses videobuf2 framework. This emulator assumes that the driver is
> > capable of working in single-buffering mode and use memory allocator that
> > allows coherent memory mapping.
> >
> > Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
> > Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
> > ---
> >  drivers/media/video/Kconfig        |    7 +
> >  drivers/media/video/Makefile       |    1 +
> >  drivers/media/video/videobuf2-fb.c |  565
> > ++++++++++++++++++++++++++++++++++++
> >  include/media/videobuf2-fb.h       |   22 ++
> >  4 files changed, 595 insertions(+), 0 deletions(-)  create mode 100644
> 
> <snip>
> 
> > +static struct fmt_desc fmt_conv_table[] = {
> > +	{
> > +		.fourcc = V4L2_PIX_FMT_RGB565,
> > +		.bits_per_pixel = 16,
> > +		.red = {	.offset = 11,	.length = 5,	},
> > +		.green = {	.offset = 5,	.length = 6,	},
> > +		.blue = {	.offset = 0,	.length = 5,	},
> > +	}, {
> > +		.fourcc = V4L2_PIX_FMT_RGB555,
> > +		.bits_per_pixel = 16,
> > +		.red = {	.offset = 11,	.length = 5,	},
> > +		.green = {	.offset = 5,	.length = 5,	},
> > +		.blue = {	.offset = 0,	.length = 5,	},
> > +	}, {
> > +		.fourcc = V4L2_PIX_FMT_RGB444,
> > +		.bits_per_pixel = 16,
> > +		.red = {	.offset = 8,	.length = 4,	},
> > +		.green = {	.offset = 4,	.length = 4,	},
> > +		.blue = {	.offset = 0,	.length = 4,	},
> > +		.transp = {	.offset = 12,	.length = 4,	},
> > +	}, {
> > +		.fourcc = V4L2_PIX_FMT_BGR32,
> > +		.bits_per_pixel = 32,
> > +		.red = {	.offset = 16,	.length = 4,	},
> 
> red.length should be 8 in case of BGR32.

Right, stupid copy-paste fault.

> > +		.green = {	.offset = 8,	.length = 8,	},
> > +		.blue = {	.offset = 0,	.length = 8,	},
> > +		.transp = {	.offset = 24,	.length = 8,	},
> > +	},
> > +	/* TODO: add more format descriptors */ };
> > +
> > +/**
> > + * vb2_drv_lock() - a shortcut to call driver specific lock()
> > + * @q:		videobuf2 queue
> > + */
> > +static inline void vb2_drv_lock(struct vb2_queue *q) {
> > +	q->ops->wait_finish(q);
> > +}
> > +
> > +/**
> > + * vb2_drv_unlock() - a shortcut to call driver specific unlock()
> > + * @q:		videobuf2 queue
> > + */
> > +static inline void vb2_drv_unlock(struct vb2_queue *q) {
> > +	q->ops->wait_prepare(q);
> > +}
> > +
> > +/**
> > + * vb2_fb_activate() - activate framebuffer emulator
> > + * @info:	framebuffer vb2 emulator data
> > + * This function activates framebuffer emulator. The pixel format
> > + * is acquired from video node, memory is allocated and framebuffer
> > + * structures are filled with valid data.
> > + */
> > +static int vb2_fb_activate(struct fb_info *info) {
> > +	struct vb2_fb_data *data = info->par;
> > +	struct vb2_queue *q = data->q;
> > +	struct fb_var_screeninfo *var;
> > +	struct v4l2_format fmt;
> > +	struct fmt_desc *conv = NULL;
> > +	int width, height, fourcc, bpl, size;
> > +	int i, ret = 0;
> > +	int (*g_fmt)(struct file *file, void *fh, struct v4l2_format *f);
> > +
> > +	/*
> > +	 * Check if streaming api has not been already activated.
> > +	 */
> > +	if (q->streaming || q->num_buffers > 0)
> > +		return -EBUSY;
> > +
> > +	dprintk(3, "setting up framebuffer\n");
> > +
> > +	/*
> > +	 * Open video node.
> > +	 */
> > +	ret = data->vfd->fops->open(&data->fake_file);
> > +	if (ret)
> > +		return ret;
> > +
> > +	/*
> > +	 * Get format from the video node.
> > +	 */
> > +	memset(&fmt, 0, sizeof(fmt));
> > +	fmt.type = q->type;
> > +	if (data->vfd->ioctl_ops->vidioc_g_fmt_vid_out) {
> > +		g_fmt = data->vfd->ioctl_ops->vidioc_g_fmt_vid_out;
> > +		ret = g_fmt(&data->fake_file, data->fake_file.private_data,
> > &fmt);
> > +		if (ret)
> > +			goto err;
> > +		width = fmt.fmt.pix.width;
> > +		height = fmt.fmt.pix.height;
> > +		fourcc = fmt.fmt.pix.pixelformat;
> > +		bpl = fmt.fmt.pix.bytesperline;
> > +		size = fmt.fmt.pix.sizeimage;
> > +	} else if (data->vfd->ioctl_ops->vidioc_g_fmt_vid_out_mplane) {
> > +		g_fmt = data->vfd->ioctl_ops->vidioc_g_fmt_vid_out_mplane;
> > +		ret = g_fmt(&data->fake_file, data->fake_file.private_data,
> > &fmt);
> > +		if (ret)
> > +			goto err;
> > +		width = fmt.fmt.pix_mp.width;
> > +		height = fmt.fmt.pix_mp.height;
> > +		fourcc = fmt.fmt.pix_mp.pixelformat;
> > +		bpl = fmt.fmt.pix_mp.plane_fmt[0].bytesperline;
> > +		size = fmt.fmt.pix_mp.plane_fmt[0].sizeimage;
> > +	} else {
> > +		ret = -EINVAL;
> > +		goto err;
> > +	}
> > +
> > +	dprintk(3, "fb emu: width %d height %d fourcc %08x size %d bpl
> %d\n",
> > +		width, height, fourcc, size, bpl);
> > +
> > +	/*
> > +	 * Find format mapping with fourcc returned by g_fmt().
> > +	 */
> > +	for (i = 0; i < ARRAY_SIZE(fmt_conv_table); i++) {
> > +		if (fmt_conv_table[i].fourcc == fourcc) {
> > +			conv = &fmt_conv_table[i];
> > +			break;
> > +		}
> > +	}
> > +
> > +	if (conv == NULL) {
> > +		ret = -EBUSY;
> > +		goto err;
> > +	}
> > +
> > +	/*
> > +	 * Request buffers and use MMAP type to force driver
> > +	 * to allocate buffers by itself.
> > +	 */
> > +	data->req.count = 1;
> > +	data->req.memory = V4L2_MEMORY_MMAP;
> > +	data->req.type = q->type;
> > +	ret = vb2_reqbufs(q, &data->req);
> > +	if (ret)
> > +		goto err;
> > +
> > +	/*
> > +	 * Check if plane_count is correct,
> > +	 * multiplane buffers are not supported.
> > +	 */
> > +	if (q->bufs[0]->num_planes != 1) {
> > +		data->req.count = 0;
> > +		ret = -EBUSY;
> > +		goto err;
> > +	}
> > +
> > +	/*
> > +	 * Get kernel address of the buffer.
> > +	 */
> > +	data->vaddr = vb2_plane_vaddr(q->bufs[0], 0);
> > +	if (data->vaddr == NULL) {
> > +		ret = -EINVAL;
> > +		goto err;
> > +	}
> > +	data->size = size = vb2_plane_size(q->bufs[0], 0);
> > +
> > +	/*
> > +	 * Clear the buffer
> > +	 */
> > +	memset(data->vaddr, 0, size);
> > +
> > +	/*
> > +	 * Setup framebuffer parameters
> > +	 */
> > +	info->screen_base = data->vaddr;
> > +	info->screen_size = size;
> > +	info->fix.line_length = bpl;
> > +	info->fix.smem_len = info->fix.mmio_len = size;
> > +
> 
> fix.smem_start is missed.
> Some window systems use it.

fix.smem_start has no meaning for non-contiguous memory allocators. Window system
should call mmap() to get access to framebuffer memory instead of hacking a direct
access with /dev/mem or so. Such mode will be not supported by this emulator.

> > +	var = &info->var;
> > +	var->xres = var->xres_virtual = var->width = width;
> > +	var->yres = var->yres_virtual = var->height = height;
> > +	var->bits_per_pixel = conv->bits_per_pixel;
> > +	var->red = conv->red;
> > +	var->green = conv->green;
> > +	var->blue = conv->blue;
> > +	var->transp = conv->transp;
> > +
> 
> How about setting the fix.xpanstep and fix.ypanstep as 0 explicitly
> if it doesn't support FBIOPAN_DISPLAY ?

Currently fix.xpanstep as well as fix.ypanstep is left as 0. Support for 
FBIOPAN_DISPLAY can be added on top of upcoming S_EXTCROP V4L2 ioctl.

> > +	return 0;
> > +
> > +err:
> > +	data->vfd->fops->release(&data->fake_file);
> > +	return ret;
> > +}
> > +
> 
> <snip>
> 
> > +static struct fb_ops vb2_fb_ops = {
> > +	.owner		= THIS_MODULE,
> > +	.fb_open	= vb2_fb_open,
> > +	.fb_release	= vb2_fb_release,
> > +	.fb_mmap	= vb2_fb_mmap,
> > +	.fb_blank	= vb2_fb_blank,
> > +	.fb_fillrect	= cfb_fillrect,
> > +	.fb_copyarea	= cfb_copyarea,
> > +	.fb_imageblit	= cfb_imageblit,
> > +};
> > +
> 
> fb_ops.fb_check_var, fb_ops.fb_set_par might be added.

Right, this can be added together with support for full display panning.

> Will FBIO_WAITFORVSYNC be added with panning support ?

This can also be added as a proxy to relevant v4l2 vsync event.

In my first version (which is in fact just a proof-of-concept than a real
patch ready for merging) I just wanted to show that it is possible to have
fb interface built on top of v4l2 video node & vb2. The interface of course
can be extended to support as much features as possible.

Best regards
--
Marek Szyprowski
Samsung Poland R&D Center


