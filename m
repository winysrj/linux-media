Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.126.171]:56605 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753596Ab1IMIL0 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 13 Sep 2011 04:11:26 -0400
Date: Tue, 13 Sep 2011 10:11:23 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Scott Jiang <scott.jiang.linux@gmail.com>
cc: Mauro Carvalho Chehab <mchehab@infradead.org>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org,
	uclinux-dist-devel@blackfin.uclinux.org
Subject: Re: [PATCH 4/4] v4l2: add blackfin capture bridge driver
In-Reply-To: <1315938892-20243-4-git-send-email-scott.jiang.linux@gmail.com>
Message-ID: <Pine.LNX.4.64.1109130943021.17902@axis700.grange>
References: <1315938892-20243-1-git-send-email-scott.jiang.linux@gmail.com>
 <1315938892-20243-4-git-send-email-scott.jiang.linux@gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Again, no complete review, just a couple of remarks

On Tue, 13 Sep 2011, Scott Jiang wrote:

> this is a v4l2 bridge driver for Blackfin video capture device,
> support ppi interface
> 
> Signed-off-by: Scott Jiang <scott.jiang.linux@gmail.com>
> ---

[snip]

> diff --git a/drivers/media/video/blackfin/bfin_capture.c b/drivers/media/video/blackfin/bfin_capture.c
> new file mode 100644
> index 0000000..24f89f2
> --- /dev/null
> +++ b/drivers/media/video/blackfin/bfin_capture.c
> @@ -0,0 +1,1099 @@
> +/*
> + * Analog Devices video capture driver
> + *
> + * Copyright (c) 2011 Analog Devices Inc.
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License version 2 as
> + * published by the Free Software Foundation.
> + *
> + * This program is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + * GNU General Public License for more details.
> + *
> + * You should have received a copy of the GNU General Public License
> + * along with this program; if not, write to the Free Software
> + * Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
> + */
> +
> +
> +#include <linux/kernel.h>
> +#include <linux/init.h>
> +#include <linux/module.h>
> +#include <linux/io.h>
> +#include <linux/delay.h>
> +#include <linux/errno.h>
> +#include <linux/fs.h>
> +#include <linux/interrupt.h>
> +#include <linux/completion.h>
> +#include <linux/mm.h>
> +#include <linux/moduleparam.h>
> +#include <linux/time.h>
> +#include <linux/version.h>
> +#include <linux/device.h>
> +#include <linux/platform_device.h>
> +#include <linux/clk.h>
> +#include <linux/sched.h>
> +#include <linux/slab.h>
> +
> +#include <media/v4l2-common.h>
> +#include <media/v4l2-ioctl.h>
> +#include <media/v4l2-device.h>
> +#include <media/videobuf2-dma-contig.h>
> +#include <media/v4l2-chip-ident.h>
> +
> +#include <asm/dma.h>
> +
> +#include <media/blackfin/bfin_capture.h>

Alphabetic order of headers is preferred. Also holds for other your patches.

> +
> +#define CAPTURE_DRV_NAME        "bfin_capture"
> +#define BCAP_MIN_NUM_BUF        2
> +
> +struct bcap_format {
> +	u8 *desc;
> +	u32 pixelformat;
> +	enum v4l2_mbus_pixelcode mbus_code;
> +	int bpp; /* bytes per pixel */

Don't you think you might have to process 12 bpp formats at some point, 
like YUV 4:2:0, or NV12? Maybe better calculate in bits from the beginning?

> +};
> +
> +struct bcap_buffer {
> +	struct vb2_buffer vb;
> +	struct list_head list;
> +};
> +
> +struct bcap_device {
> +	/* capture device instance */
> +	struct v4l2_device v4l2_dev;
> +	/* device node data */
> +	struct video_device *video_dev;
> +	/* sub device instance */
> +	struct v4l2_subdev *sd;
> +	/* caputre config */
> +	struct bfin_capture_config *cfg;
> +	/* ppi interface */
> +	struct ppi_if *ppi;
> +	/* current input */
> +	unsigned int cur_input;
> +	/* current selected standard */
> +	v4l2_std_id std;
> +	/* used to store pixel format */
> +	struct v4l2_pix_format fmt;
> +	/* bytes per pixel*/
> +	int bpp;
> +	/* pointing to current video buffer */
> +	struct bcap_buffer *cur_frm;
> +	/* pointing to next video buffer */
> +	struct bcap_buffer *next_frm;
> +	/* buffer queue used in videobuf2 */
> +	struct vb2_queue buffer_queue;
> +	/* allocator-specific contexts for each plane */
> +	struct vb2_alloc_ctx *alloc_ctx;
> +	/* queue of filled frames */
> +	struct list_head dma_queue;
> +	/* used in videobuf2 callback */
> +	spinlock_t lock;
> +	/* used to access capture device */
> +	struct mutex mutex;
> +	/* used to wait ppi to complete one transfer */
> +	struct completion comp;
> +	/* number of users performing IO */
> +	u32 io_usrs;

Does it really have to be fixed 32 bits? Seems a plane simple int would do 
just fine.

> +	/* number of open instances of the device */
> +	u32 usrs;

ditto

> +	/* indicate whether streaming has started */
> +	u8 started;

bool?

> +};
> +
> +struct bcap_fh {
> +	struct v4l2_fh fh;
> +	struct bcap_device *bcap_dev;
> +	/* indicates whether this file handle is doing IO */
> +	u8 io_allowed;

bool

[snip]

> +static irqreturn_t bcap_isr(int irq, void *dev_id)
> +{
> +	struct ppi_if *ppi = dev_id;
> +	struct bcap_device *bcap_dev = ppi->priv;
> +	struct timeval timevalue;
> +	struct vb2_buffer *vb = &bcap_dev->cur_frm->vb;
> +	dma_addr_t *addr;
> +
> +	spin_lock(&bcap_dev->lock);
> +
> +	if (bcap_dev->cur_frm != bcap_dev->next_frm) {
> +		do_gettimeofday(&timevalue);
> +		vb->v4l2_buf.timestamp = timevalue;
> +		vb2_buffer_done(vb, VB2_BUF_STATE_DONE);
> +		bcap_dev->cur_frm = bcap_dev->next_frm;
> +	}
> +
> +	ppi->ops->stop(ppi);
> +
> +	if (!bcap_dev->started)
> +		complete(&bcap_dev->comp);
> +	else {
> +		if (!list_empty(&bcap_dev->dma_queue)) {
> +			bcap_dev->next_frm = list_entry(bcap_dev->dma_queue.next,
> +						struct bcap_buffer, list);
> +			list_del(&bcap_dev->next_frm->list);
> +			addr = vb2_plane_cookie(&bcap_dev->next_frm->vb, 0);

I think, the direct use of vb2_plane_cookie() is discouraged. 
vb2_dma_contig_plane_dma_addr() should work for you.

> +			ppi->ops->update_addr(ppi, (unsigned long)(*addr));
> +		}
> +		ppi->ops->start(ppi);
> +	}
> +
> +	spin_unlock(&bcap_dev->lock);
> +
> +	return IRQ_HANDLED;
> +}

[snip]

> +static int bcap_try_format(struct bcap_device *bcap,
> +				struct v4l2_pix_format *pixfmt,
> +				enum v4l2_mbus_pixelcode *mbus_code,
> +				int *bpp)
> +{
> +	const struct bcap_format *fmt;
> +	struct v4l2_mbus_framefmt mbus_fmt;
> +	int ret, i;
> +
> +	for (i = 0; i < BCAP_MAX_FMTS; i++) {
> +		if ((pixfmt->pixelformat == bcap_formats[i].pixelformat)) {
> +			fmt = &bcap_formats[i];
> +			if (mbus_code)
> +				*mbus_code = fmt->mbus_code;
> +			if (bpp)
> +				*bpp = fmt->bpp;
> +			v4l2_fill_mbus_format(&mbus_fmt, pixfmt,
> +						fmt->mbus_code);
> +			ret = v4l2_subdev_call(bcap->sd, video,
> +						try_mbus_fmt, &mbus_fmt);
> +			if (ret < 0)
> +				return ret;
> +			v4l2_fill_pix_format(pixfmt, &mbus_fmt);
> +			pixfmt->bytesperline = pixfmt->width * fmt->bpp;
> +			pixfmt->sizeimage = pixfmt->bytesperline
> +						* pixfmt->height;
> +			return 0;
> +		}
> +	}
> +	return -EINVAL;
> +}
> +
> +static int bcap_enum_fmt_vid_cap(struct file *file, void  *priv,
> +					struct v4l2_fmtdesc *fmt)
> +{
> +	struct bcap_device *bcap_dev = video_drvdata(file);
> +	enum v4l2_mbus_pixelcode mbus_code;
> +	u32 index = fmt->index;
> +	int ret, i;
> +
> +	ret = v4l2_subdev_call(bcap_dev->sd, video,
> +				enum_mbus_fmt, index, &mbus_code);
> +	if (ret < 0)
> +		return ret;
> +
> +	for (i = 0; i < BCAP_MAX_FMTS; i++) {
> +		if (mbus_code == bcap_formats[i].mbus_code) {
> +			fmt->type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
> +			strlcpy(fmt->description,
> +					bcap_formats[index].desc,
> +					 sizeof(fmt->description));
> +			fmt->pixelformat = bcap_formats[index].pixelformat;
> +			return 0;
> +		}
> +	}
> +	v4l2_err(&bcap_dev->v4l2_dev,
> +			"subdev fmt is not supported by bcap\n");
> +	return -EINVAL;
> +}
> +
> +static int bcap_try_fmt_vid_cap(struct file *file, void *priv,
> +					struct v4l2_format *fmt)
> +{
> +	struct bcap_device *bcap_dev = video_drvdata(file);
> +	struct v4l2_pix_format *pixfmt = &fmt->fmt.pix;
> +
> +	if (fmt->type != V4L2_BUF_TYPE_VIDEO_CAPTURE)
> +		return -EINVAL;
> +
> +	return bcap_try_format(bcap_dev, pixfmt, NULL, NULL);
> +}
> +
> +static int bcap_g_fmt_vid_cap(struct file *file, void *priv,
> +				struct v4l2_format *fmt)
> +{
> +	struct bcap_device *bcap_dev = video_drvdata(file);
> +	struct v4l2_mbus_framefmt mbus_fmt;
> +	const struct bcap_format *bcap_fmt;
> +	struct v4l2_pix_format *pixfmt = &fmt->fmt.pix;
> +	int ret, i;
> +
> +	if (fmt->type != V4L2_BUF_TYPE_VIDEO_CAPTURE)
> +		return -EINVAL;
> +
> +	ret = v4l2_subdev_call(bcap_dev->sd, video,
> +				g_mbus_fmt, &mbus_fmt);
> +	if (ret < 0)
> +		return ret;
> +
> +	for (i = 0; i < BCAP_MAX_FMTS; i++) {
> +		if (mbus_fmt.code == bcap_formats[i].mbus_code) {
> +			bcap_fmt = &bcap_formats[i];
> +			v4l2_fill_pix_format(pixfmt, &mbus_fmt);
> +			pixfmt->bytesperline = pixfmt->width * bcap_fmt->bpp;
> +			pixfmt->sizeimage = pixfmt->bytesperline
> +						* pixfmt->height;

It seems to me, you're forgetting to fill in ->pixelformat?

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
