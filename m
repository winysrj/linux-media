Return-path: <linux-media-owner@vger.kernel.org>
Received: from tx2ehsobe001.messaging.microsoft.com ([65.55.88.11]:9226 "EHLO
	tx2outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752084Ab2HCIY6 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 3 Aug 2012 04:24:58 -0400
Date: Fri, 3 Aug 2012 16:24:43 +0800
From: Richard Zhao <richard.zhao@freescale.com>
To: Javier Martin <javier.martin@vista-silicon.com>
CC: <linux-media@vger.kernel.org>,
	<sakari.ailus@maxwell.research.nokia.com>,
	<kyungmin.park@samsung.com>, <s.nawrocki@samsung.com>,
	<laurent.pinchart@ideasonboard.com>, <mchehab@infradead.org>,
	<s.hauer@pengutronix.de>, <p.zabel@pengutronix.de>,
	<hverkuil@xs4all.nl>, <linuxzsc@gmail.com>,
	<richard.zhao@freescale.com>, <shawn.guo@linaro.org>
Subject: Re: [v7] media: coda: Add driver for Coda video codec.
Message-ID: <20120803082442.GE29944@b20223-02.ap.freescale.net>
References: <1343043061-24327-1-git-send-email-javier.martin@vista-silicon.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1343043061-24327-1-git-send-email-javier.martin@vista-silicon.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Javier,

Glad to see the vpu patch. I'd like to try it on imx6. What else
do I need to do besides add vpu devices in dts? Do you have a gst
plugin or any other test program to test it?

Please also see below comments.

On Mon, Jul 23, 2012 at 11:31:01AM +0000, Javier Martin wrote:
> Coda is a range of video codecs from Chips&Media that
> support H.264, H.263, MPEG4 and other video standards.
> 
> Currently only support for the codadx6 included in the
> i.MX27 SoC is added. H.264 and MPEG4 video encoding
> are the only supported capabilities by now.
> 
> Signed-off-by: Javier Martin <javier.martin@vista-silicon.com>
> Acked-by: Hans Verkuil <hans.verkuil@cisco.com>
> Reviewed-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
> 
> ---
> Changes since v6:
>  - Cosmetic fixes pointed out by Sakari.
>  - Now passes 'v4l2-compliance'.
> 
> ---
>  drivers/media/video/Kconfig  |    9 +
>  drivers/media/video/Makefile |    1 +
>  drivers/media/video/coda.c   | 1848 ++++++++++++++++++++++++++++++++++++++++++
>  drivers/media/video/coda.h   |  216 +++++
>  4 files changed, 2074 insertions(+)
>  create mode 100644 drivers/media/video/coda.c
>  create mode 100644 drivers/media/video/coda.h
> 

[...]

> +static int coda_start_streaming(struct vb2_queue *q, unsigned int count)
> +{
> +	struct coda_ctx *ctx = vb2_get_drv_priv(q);
> +	struct v4l2_device *v4l2_dev = &ctx->dev->v4l2_dev;
> +	u32 bitstream_buf, bitstream_size;
> +	struct coda_dev *dev = ctx->dev;
> +	struct coda_q_data *q_data_src, *q_data_dst;
> +	u32 dst_fourcc;
> +	struct vb2_buffer *buf;
> +	struct vb2_queue *src_vq;
> +	u32 value;
> +	int i = 0;
> +
> +	if (count < 1)
> +		return -EINVAL;
> +
> +	if (q->type == V4L2_BUF_TYPE_VIDEO_OUTPUT)
> +		ctx->rawstreamon = 1;
> +	else
> +		ctx->compstreamon = 1;
> +
> +	/* Don't start the coda unless both queues are on */
> +	if (!(ctx->rawstreamon & ctx->compstreamon))
> +		return 0;
> +		
Remove spaces above.
> +	ctx->gopcounter = ctx->params.gop_size - 1;
> +
> +	q_data_src = get_q_data(ctx, V4L2_BUF_TYPE_VIDEO_OUTPUT);
> +	buf = v4l2_m2m_next_dst_buf(ctx->m2m_ctx);
> +	bitstream_buf = vb2_dma_contig_plane_dma_addr(buf, 0);
> +	q_data_dst = get_q_data(ctx, V4L2_BUF_TYPE_VIDEO_CAPTURE);
> +	bitstream_size = q_data_dst->sizeimage;
> +	dst_fourcc = q_data_dst->fmt->fourcc;
> +
> +	/* Find out whether coda must encode or decode */
> +	if (q_data_src->fmt->type == CODA_FMT_RAW &&
> +	    q_data_dst->fmt->type == CODA_FMT_ENC) {
> +		ctx->inst_type = CODA_INST_ENCODER;
> +	} else if (q_data_src->fmt->type == CODA_FMT_ENC &&
> +		   q_data_dst->fmt->type == CODA_FMT_RAW) {
> +		ctx->inst_type = CODA_INST_DECODER;
> +		v4l2_err(v4l2_dev, "decoding not supported.\n");
> +		return -EINVAL;
> +	} else {
> +		v4l2_err(v4l2_dev, "couldn't tell instance type.\n");
> +		return -EINVAL;
> +	}
> +
> +	if (!coda_is_initialized(dev)) {
> +		v4l2_err(v4l2_dev, "coda is not initialized.\n");
> +		return -EFAULT;
> +	}
> +	coda_write(dev, ctx->parabuf.paddr, CODA_REG_BIT_PARA_BUF_ADDR);
> +	coda_write(dev, bitstream_buf, CODA_REG_BIT_RD_PTR(ctx->idx));
> +	coda_write(dev, bitstream_buf, CODA_REG_BIT_WR_PTR(ctx->idx));
> +	switch (dev->devtype->product) {
> +	case CODA_DX6:
> +		coda_write(dev, CODADX6_STREAM_BUF_DYNALLOC_EN |
> +			CODADX6_STREAM_BUF_PIC_RESET, CODA_REG_BIT_STREAM_CTRL);
> +		break;
> +	default:
> +		coda_write(dev, CODA7_STREAM_BUF_DYNALLOC_EN |
> +			CODA7_STREAM_BUF_PIC_RESET, CODA_REG_BIT_STREAM_CTRL);
> +	}
> +
> +	/* Configure the coda */
> +	coda_write(dev, 0xffff4c00, CODA_REG_BIT_SEARCH_RAM_BASE_ADDR);
> +
> +	/* Could set rotation here if needed */
> +	switch (dev->devtype->product) {
> +	case CODA_DX6:
> +		value = (q_data_src->width & CODADX6_PICWIDTH_MASK) << CODADX6_PICWIDTH_OFFSET;
longer than 80 characters. Could you run checkpatch to do further check?

> +		break;
> +	default:
> +		value = (q_data_src->width & CODA7_PICWIDTH_MASK) << CODA7_PICWIDTH_OFFSET;
> +	}
> +	value |= (q_data_src->height & CODA_PICHEIGHT_MASK) << CODA_PICHEIGHT_OFFSET;
> +	coda_write(dev, value, CODA_CMD_ENC_SEQ_SRC_SIZE);
> +	coda_write(dev, ctx->params.framerate,
> +		   CODA_CMD_ENC_SEQ_SRC_F_RATE);
> +

[...]

> +static int coda_firmware_request(struct coda_dev *dev)
> +{
> +	char *fw = dev->devtype->firmware;
> +
> +	dev_dbg(&dev->plat_dev->dev, "requesting firmware '%s' for %s\n", fw,
> +		coda_product_name(dev->devtype->product));
> +
> +	return request_firmware_nowait(THIS_MODULE, true,
> +		fw, &dev->plat_dev->dev, GFP_KERNEL, dev, coda_fw_callback);
why not remove the wrapper and call request_firmware_nowait directly?
> +}
> +
> +enum coda_platform {
> +	CODA_IMX27,
> +};
> +
> +static struct coda_devtype coda_devdata[] = {
It's not necessary to be array, so we can remove enum coda_platform.
> +	[CODA_IMX27] = {
> +		.firmware    = "v4l-codadx6-imx27.bin",
> +		.product     = CODA_DX6,
> +		.formats     = codadx6_formats,
> +		.num_formats = ARRAY_SIZE(codadx6_formats),
> +	},
> +};
> +
> +static struct platform_device_id coda_platform_ids[] = {
> +	{ .name = "coda-imx27", .driver_data = CODA_IMX27 },
.driver_data can point to struct coda_devtype directly?
> +	{ /* sentinel */ }
> +};
> +MODULE_DEVICE_TABLE(platform, coda_platform_ids);
> +
> +#ifdef CONFIG_OF
It can pass build without check CONFIG_OF.
> +static const struct of_device_id coda_dt_ids[] = {
> +	{ .compatible = "fsl,imx27-vpu", .data = &coda_platform_ids[CODA_IMX27] },
.data can point to struct coda_devtype directly?
> +	{ /* sentinel */ }
> +};
> +MODULE_DEVICE_TABLE(of, coda_dt_ids);
> +#endif
> +
> +static int __devinit coda_probe(struct platform_device *pdev)
> +{
> +	const struct of_device_id *of_id =
> +			of_match_device(of_match_ptr(coda_dt_ids), &pdev->dev);
If CONFIG_OF checking is removed, maybe we can remove of_match_ptr too.
> +	const struct platform_device_id *pdev_id;
> +	struct coda_dev *dev;
> +	struct resource *res;
> +	int ret, irq;
> +
> +	dev = devm_kzalloc(&pdev->dev, sizeof *dev, GFP_KERNEL);
> +	if (!dev) {
> +		dev_err(&pdev->dev, "Not enough memory for %s\n",
> +			CODA_NAME);
> +		return -ENOMEM;
> +	}
> +
> +	spin_lock_init(&dev->irqlock);
why is irqlock not used anywhere?
> +
> +	dev->plat_dev = pdev;
> +	dev->clk_per = devm_clk_get(&pdev->dev, "per");
> +	if (IS_ERR(dev->clk_per)) {
> +		dev_err(&pdev->dev, "Could not get per clock\n");
> +		return PTR_ERR(dev->clk_per);
> +	}
> +
> +	dev->clk_ahb = devm_clk_get(&pdev->dev, "ahb");
> +	if (IS_ERR(dev->clk_ahb)) {
> +		dev_err(&pdev->dev, "Could not get ahb clock\n");
> +		return PTR_ERR(dev->clk_ahb);
> +	}
> +
> +	/* Get  memory for physical registers */
> +	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
> +	if (res == NULL) {
> +		dev_err(&pdev->dev, "failed to get memory region resource\n");
> +		return -ENOENT;
> +	}
> +
> +	if (devm_request_mem_region(&pdev->dev, res->start,
devm_request_and_ioremap ?
> +			resource_size(res), CODA_NAME) == NULL) {
> +		dev_err(&pdev->dev, "failed to request memory region\n");
> +		return -ENOENT;
> +	}
> +	dev->regs_base = devm_ioremap(&pdev->dev, res->start,
> +				      resource_size(res));
> +	if (!dev->regs_base) {
> +		dev_err(&pdev->dev, "failed to ioremap address region\n");
> +		return -ENOENT;
> +	}
> +
> +	/* IRQ */
> +	irq = platform_get_irq(pdev, 0);
> +	if (irq < 0) {
> +		dev_err(&pdev->dev, "failed to get irq resource\n");
> +		return -ENOENT;
> +	}
> +
> +	if (devm_request_irq(&pdev->dev, irq, coda_irq_handler,
> +		0, CODA_NAME, dev) < 0) {
> +		dev_err(&pdev->dev, "failed to request irq\n");
> +		return -ENOENT;
> +	}
> +
> +	ret = v4l2_device_register(&pdev->dev, &dev->v4l2_dev);
Why not register it until everything is ready?
> +	if (ret)
> +		return ret;
> +
> +	mutex_init(&dev->dev_mutex);
> +
> +	pdev_id = of_id ? of_id->data : platform_get_device_id(pdev);
> +
> +	if (of_id) {
> +		dev->devtype = of_id->data;
> +	} else if (pdev_id) {
> +		dev->devtype = &coda_devdata[pdev_id->driver_data];
> +	} else {
> +		v4l2_device_unregister(&dev->v4l2_dev);
> +		return -EINVAL;
> +	}
> +
> +	/* allocate auxiliary per-device buffers for the BIT processor */
> +	switch (dev->devtype->product) {
> +	case CODA_DX6:
> +		dev->workbuf.size = CODADX6_WORK_BUF_SIZE;
> +		break;
> +	default:
> +		dev->workbuf.size = CODA7_WORK_BUF_SIZE;
> +	}
> +	dev->workbuf.vaddr = dma_alloc_coherent(&pdev->dev, dev->workbuf.size,
> +						    &dev->workbuf.paddr,
> +						    GFP_KERNEL);
> +	if (!dev->workbuf.vaddr) {
> +		dev_err(&pdev->dev, "failed to allocate work buffer\n");
> +		v4l2_device_unregister(&dev->v4l2_dev);
> +		return -ENOMEM;
> +	}
> +
> +	platform_set_drvdata(pdev, dev);
> +
> +	return coda_firmware_request(dev);
> +}
> +

Thanks
Richard

