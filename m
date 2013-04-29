Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.w1.samsung.com ([210.118.77.12]:16204 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757031Ab3D2RUU (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 29 Apr 2013 13:20:20 -0400
Received: from eucpsbgm1.samsung.com (unknown [203.254.199.244])
 by mailout2.w1.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0MM10066J1HU0TC0@mailout2.w1.samsung.com> for
 linux-media@vger.kernel.org; Mon, 29 Apr 2013 18:20:18 +0100 (BST)
Message-id: <517EABCF.2020805@samsung.com>
Date: Mon, 29 Apr 2013 19:20:15 +0200
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
MIME-version: 1.0
To: Scott Jiang <scott.jiang.linux@gmail.com>
Cc: linux-media@vger.kernel.org,
	uclinux-dist-devel@blackfin.uclinux.org, hverkuil@xs4all.nl,
	mchehab@redhat.com
Subject: Re: [PATCH RFC v2] [media] blackfin: add video display device driver
References: <1367184052-688-1-git-send-email-scott.jiang.linux@gmail.com>
In-reply-to: <1367184052-688-1-git-send-email-scott.jiang.linux@gmail.com>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Scott,

On 04/28/2013 11:20 PM, Scott Jiang wrote:
> This is a V4L2 driver for Blackfin video display (E)PPI interface.
> This module is common for BF537/BF561/BF548/BF609.
> 
> Signed-off-by: Scott Jiang <scott.jiang.linux@gmail.com>

>From a quick review this patch looks good to me. Feel free to add

Reviewed-by: Sylwester Nawrocki <s.nawrocki@samsung.com>

Just couple remarks below.

> +static const struct bfin_disp_format bfin_disp_formats[] = {
> +	{
> +		.desc        = "YCbCr 4:2:2 Interleaved UYVY 8bits",

This string will like get truncated, since buffer is only 32 character
long, including trailing 0. It could be verified with e.g. v4l2-ctl
how much of this string actually shows up in user space.
	
> +		.pixelformat = V4L2_PIX_FMT_UYVY,
> +		.mbus_code   = V4L2_MBUS_FMT_UYVY8_2X8,
> +		.bpp         = 16,
> +		.dlen        = 8,
> +	},
> +	{
> +		.desc        = "YCbCr 4:2:2 Interleaved YUYV 8bits",

Ditto.

> +		.pixelformat = V4L2_PIX_FMT_YUYV,
> +		.mbus_code   = V4L2_MBUS_FMT_YUYV8_2X8,
> +		.bpp         = 16,
> +		.dlen        = 8,
> +	},
> +	{
> +		.desc        = "YCbCr 4:2:2 Interleaved UYVY 16bits",

Ditto.

> +		.pixelformat = V4L2_PIX_FMT_UYVY,
> +		.mbus_code   = V4L2_MBUS_FMT_UYVY8_1X16,
> +		.bpp         = 16,
> +		.dlen        = 16,
> +	},
[...]

> +static irqreturn_t bfin_disp_isr(int irq, void *dev_id)
> +{
> +	struct ppi_if *ppi = dev_id;
> +	struct bfin_disp_device *disp = ppi->priv;
> +	struct vb2_buffer *vb = &disp->cur_frm->vb;
> +	dma_addr_t addr;
> +
> +	spin_lock(&disp->lock);
> +
> +	if (!list_empty(&disp->dma_queue)) {
> +		v4l2_get_timestamp(&vb->v4l2_buf.timestamp);
> +		vb->v4l2_buf.flags |= V4L2_BUF_FLAG_TIMESTAMP_MONOTONIC;

There is no need to set this flag for each buffer, it will be done internally
in videbuf2, if timestamp_type type is set before calling vb2_queue_init().

> +		vb2_buffer_done(vb, VB2_BUF_STATE_DONE);
> +		disp->cur_frm = list_entry(disp->dma_queue.next,
> +				struct bfin_disp_buffer, list);
> +		list_del(&disp->cur_frm->list);
> +	}
> +
> +	clear_dma_irqstat(ppi->info->dma_ch);
> +
> +	addr = vb2_dma_contig_plane_dma_addr(&disp->cur_frm->vb, 0);
> +	ppi->ops->update_addr(ppi, (unsigned long)addr);
> +	ppi->ops->start(ppi);
> +
> +	spin_unlock(&disp->lock);
> +
> +	return IRQ_HANDLED;
> +}

> +static int bfin_disp_probe(struct platform_device *pdev)
> +{
> +	struct bfin_disp_device *disp;
> +	struct video_device *vfd;
> +	struct i2c_adapter *i2c_adap;
> +	struct bfin_display_config *config;
> +	struct vb2_queue *q;
> +	struct disp_route *route;
> +	int ret;
> +
> +	config = pdev->dev.platform_data;
> +	if (!config || !config->num_outputs) {
> +		v4l2_err(pdev->dev.driver, "Invalid board config\n");
> +		return -ENODEV;
> +	}
> +
> +	disp = kzalloc(sizeof(*disp), GFP_KERNEL);

devm_kzalloc() ?

> +	if (!disp)
> +		return -ENOMEM;
[...]
> +
> +	/* initialize queue */
> +	q = &disp->buffer_queue;
> +	q->type = V4L2_BUF_TYPE_VIDEO_OUTPUT;
> +	q->io_modes = VB2_MMAP;
> +	q->drv_priv = disp;
> +	q->buf_struct_size = sizeof(struct bfin_disp_buffer);
> +	q->ops = &bfin_disp_video_qops;
> +	q->mem_ops = &vb2_dma_contig_memops;
> +	/* provide a mutex to vb2 queue */
> +	q->lock = &disp->qlock;

And the timestamp type set up:

	q->timestamp_type = V4L2_BUF_FLAG_TIMESTAMP_MONOTONIC;

> +	ret = vb2_queue_init(q);
> +	if (ret) {
> +		v4l2_err(&disp->v4l2_dev,
> +				"Unable to init videobuf2 queue\n");
> +		goto err_free_handler;
> +	}

Thanks,
Sylwester
