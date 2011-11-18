Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ey0-f174.google.com ([209.85.215.174]:50393 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758000Ab1KRQH0 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 18 Nov 2011 11:07:26 -0500
Received: by eye27 with SMTP id 27so3490655eye.19
        for <linux-media@vger.kernel.org>; Fri, 18 Nov 2011 08:07:24 -0800 (PST)
Message-ID: <4EC682B8.10300@gmail.com>
Date: Fri, 18 Nov 2011 17:07:20 +0100
From: Sylwester Nawrocki <snjw23@gmail.com>
MIME-Version: 1.0
To: Javier Martin <javier.martin@vista-silicon.com>
CC: linux-media@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	m.szyprowski@samsung.com, laurent.pinchart@ideasonboard.com,
	s.nawrocki@samsung.com, hverkuil@xs4all.nl,
	kyungmin.park@samsung.com, shawn.guo@linaro.org,
	richard.zhao@linaro.org, fabio.estevam@freescale.com,
	kernel@pengutronix.de
Subject: Re: [PATCH] MEM2MEM: Add support for eMMa-PrP mem2mem operations.
References: <1321460614-2108-1-git-send-email-javier.martin@vista-silicon.com>
In-Reply-To: <1321460614-2108-1-git-send-email-javier.martin@vista-silicon.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Javier,

Good to see non Samsung device using v4l2 mem-to-mem framework. What is your
experience, have you encountered any specific problems with it ?

And just out of curiosity, are you planning to develop video codec driver 
in v4l2 for i.MX27 as well ?

I have a few comments, please see below...

On 11/16/2011 05:23 PM, Javier Martin wrote:
> i.MX2x SoCs have a PrP which is capable of resizing and format
> conversion of video frames. This driver provides support for
> resizing and format conversion from YUYV to YUV420.
> 
> This operation is of the utmost importance since some of these
> SoCs like i.MX27 include an H.264 video codec which only
> accepts YUV420 as input.
> 
> Signed-off-by: Javier Martin<javier.martin@vista-silicon.com>
> ---
>   arch/arm/mach-imx/devices-imx27.h               |    2 +
>   arch/arm/plat-mxc/devices/platform-mx2-camera.c |   33 +
>   arch/arm/plat-mxc/include/mach/devices-common.h |    2 +
>   drivers/media/video/Kconfig                     |   11 +
>   drivers/media/video/Makefile                    |    2 +
>   drivers/media/video/mx2_emmaprp.c               | 1059 +++++++++++++++++++++++
>   6 files changed, 1109 insertions(+), 0 deletions(-)
>   create mode 100644 drivers/media/video/mx2_emmaprp.c
> 
> diff --git a/arch/arm/mach-imx/devices-imx27.h b/arch/arm/mach-imx/devices-imx27.h
> index 2f727d7..519aa36 100644
> --- a/arch/arm/mach-imx/devices-imx27.h
> +++ b/arch/arm/mach-imx/devices-imx27.h
> @@ -50,6 +50,8 @@ extern const struct imx_imx_uart_1irq_data imx27_imx_uart_data[];
>   extern const struct imx_mx2_camera_data imx27_mx2_camera_data;
>   #define imx27_add_mx2_camera(pdata)	\
>   	imx_add_mx2_camera(&imx27_mx2_camera_data, pdata)
> +#define imx27_alloc_mx2_emmaprp(pdata)	\
> +	imx_alloc_mx2_emmaprp(&imx27_mx2_camera_data)
> 
>   extern const struct imx_mxc_ehci_data imx27_mxc_ehci_otg_data;
>   #define imx27_add_mxc_ehci_otg(pdata)	\
> diff --git a/arch/arm/plat-mxc/devices/platform-mx2-camera.c b/arch/arm/plat-mxc/devices/platform-mx2-camera.c
> index b3f4828..4a8bd73 100644
> --- a/arch/arm/plat-mxc/devices/platform-mx2-camera.c
> +++ b/arch/arm/plat-mxc/devices/platform-mx2-camera.c
> @@ -6,6 +6,7 @@
>    * the terms of the GNU General Public License version 2 as published by the
>    * Free Software Foundation.
>    */
> +#include<linux/dma-mapping.h>
>   #include<mach/hardware.h>
>   #include<mach/devices-common.h>
> 
> @@ -62,3 +63,35 @@ struct platform_device *__init imx_add_mx2_camera(
>   			res, data->iobaseemmaprp ? 4 : 2,
>   			pdata, sizeof(*pdata), DMA_BIT_MASK(32));
>   }
> +
> +struct platform_device *__init imx_alloc_mx2_emmaprp(
> +		const struct imx_mx2_camera_data *data)
> +{
> +	struct resource res[] = {
> +		{
> +			.start = data->iobaseemmaprp,
> +			.end = data->iobaseemmaprp + data->iosizeemmaprp - 1,
> +			.flags = IORESOURCE_MEM,
> +		}, {
> +			.start = data->irqemmaprp,
> +			.end = data->irqemmaprp,
> +			.flags = IORESOURCE_IRQ,
> +		},
> +	};
> +	struct platform_device *pdev;
> +	int ret = -ENOMEM;
> +
> +	pdev = platform_device_alloc("m2m-emmaprp", 0);
> +	if (!pdev)
> +		goto err;
> +
> +	ret = platform_device_add_resources(pdev, res, ARRAY_SIZE(res));
> +	if (ret)
> +		goto err;
> +
> +	return pdev;
> +err:
> +	platform_device_put(pdev);
> +	return ERR_PTR(-ENODEV);
> +
> +}
> diff --git a/arch/arm/plat-mxc/include/mach/devices-common.h b/arch/arm/plat-mxc/include/mach/devices-common.h
> index def9ba5..ce64bd5 100644
> --- a/arch/arm/plat-mxc/include/mach/devices-common.h
> +++ b/arch/arm/plat-mxc/include/mach/devices-common.h
> @@ -223,6 +223,8 @@ struct imx_mx2_camera_data {
>   struct platform_device *__init imx_add_mx2_camera(
>   		const struct imx_mx2_camera_data *data,
>   		const struct mx2_camera_platform_data *pdata);
> +struct platform_device *__init imx_alloc_mx2_emmaprp(
> +		const struct imx_mx2_camera_data *data);
> 
>   #include<mach/mxc_ehci.h>
>   struct imx_mxc_ehci_data {
> diff --git a/drivers/media/video/Kconfig b/drivers/media/video/Kconfig
> index b303a3f..6e57825 100644
> --- a/drivers/media/video/Kconfig
> +++ b/drivers/media/video/Kconfig
> @@ -1107,4 +1107,15 @@ config VIDEO_SAMSUNG_S5P_MFC
>   	help
>   	    MFC 5.1 driver for V4L2.
> 
> +config VIDEO_MX2_EMMAPRP
> +	tristate "MX2 eMMa-PrP support"
> +	depends on VIDEO_DEV&&  VIDEO_V4L2&&  MACH_MX27
> +	select VIDEOBUF2_DMA_CONTIG
> +	select V4L2_MEM2MEM_DEV
> +	default n

The default is 'n' so this line is redundant.

> +	help
> +	    MX2X chips have a PrP that can be used to process buffers from
> +	    memory to memory. Operations include resizing and format
> +	    conversion.
> +
>   endif # V4L_MEM2MEM_DRIVERS
> diff --git a/drivers/media/video/Makefile b/drivers/media/video/Makefile
> index 117f9c4..7ae711e 100644
> --- a/drivers/media/video/Makefile
> +++ b/drivers/media/video/Makefile
> @@ -176,6 +176,8 @@ obj-$(CONFIG_VIDEO_SH_MOBILE_CEU)	+= sh_mobile_ceu_camera.o
>   obj-$(CONFIG_VIDEO_OMAP1)		+= omap1_camera.o
>   obj-$(CONFIG_VIDEO_ATMEL_ISI)		+= atmel-isi.o
> 
> +obj-$(CONFIG_VIDEO_MX2_EMMAPRP)		+= mx2_emmaprp.o
> +
>   obj-$(CONFIG_VIDEO_SAMSUNG_S5P_FIMC) 	+= s5p-fimc/
>   obj-$(CONFIG_VIDEO_SAMSUNG_S5P_MFC)	+= s5p-mfc/
>   obj-$(CONFIG_VIDEO_SAMSUNG_S5P_TV)	+= s5p-tv/
> diff --git a/drivers/media/video/mx2_emmaprp.c b/drivers/media/video/mx2_emmaprp.c
> new file mode 100644
> index 0000000..ad65e90
> --- /dev/null
> +++ b/drivers/media/video/mx2_emmaprp.c
> @@ -0,0 +1,1059 @@
> +/*
> + * Support eMMa-PrP through mem2mem framework.
> + *
> + * eMMa-PrP is a piece of HW that allows fetching buffers
> + * from one memory location and do several operations on
> + * them such as scaling or format conversion giving, as a result
> + * a new processed buffer in another memory location.
> + *
> + * Based on mem2mem_testdev.c by Pawel Osciak.
> + *
> + * Copyright (c) 2011 Vista Silicon S.L.
> + * Javier Martin<javier.martin@vista-silicon.com>
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License as published by the
> + * Free Software Foundation; either version 2 of the
> + * License, or (at your option) any later version
> + */
> +#include<linux/module.h>
> +#include<linux/clk.h>
> +#include<linux/slab.h>
> +#include<linux/interrupt.h>
> +
> +#include<linux/platform_device.h>
> +#include<media/v4l2-mem2mem.h>
> +#include<media/v4l2-device.h>
> +#include<media/v4l2-ioctl.h>
> +#include<media/videobuf2-dma-contig.h>
> +
> +#define MEM2MEM_TEST_MODULE_NAME "mem2mem-emmaprp"

Don't you want to use a name more specific to your device ?..

> +
> +MODULE_DESCRIPTION("mem2mem device which supports eMMa-PrP present in mx2 SoCs");
> +MODULE_AUTHOR("Javier Martin<javier.martin@vista-silicon.com");
> +MODULE_LICENSE("GPL");
> +MODULE_VERSION("0.0.1");
> +
> +static bool debug = true;
> +module_param(debug, bool, 0644);
> +
> +#define MIN_W 32
> +#define MIN_H 32
> +#define MAX_W 2040
> +#define MAX_H 2046
> +
> +#define W_ALIGN_MASK_YUV420	0x07 /* multiple of 8 */
> +#define W_ALIGN_MASK_OTHERS	0x03 /* multiple of 4 */
> +#define H_ALIGN_MASK		0x01 /* multiple of 2 */
> +
> +/* Flags that indicate a format can be used for capture/output */
> +#define MEM2MEM_CAPTURE	(1<<  0)
> +#define MEM2MEM_OUTPUT	(1<<  1)
> +
> +#define MEM2MEM_NAME		"m2m-emmaprp"
> +
> +/* In bytes, per queue */
> +#define MEM2MEM_VID_MEM_LIMIT	(16 * 1024 * 1024)

SZ_1M could also be used here, but you may as well don't like it;)

> +
> +#define dprintk(dev, fmt, arg...) \
> +	v4l2_dbg(1, debug,&dev->v4l2_dev, "%s: " fmt, __func__, ## arg)
> +
> +/* EMMA PrP */
> +#define PRP_CNTL                        0x00
...
> +#define PRP_INTR_ST_CH2OVF	(1<<  8)
> +
> +struct emmaprp_fmt {
> +	char	*name;
> +	u32	fourcc;
> +	/* Types the format can be used for */
> +	u32	types;
> +};
> +
> +static struct emmaprp_fmt formats[] = {
> +	{
> +		.name	= "YUV 4:2:0 Planar",
> +		.fourcc	= V4L2_PIX_FMT_YUV420,
> +		.types	= MEM2MEM_CAPTURE,
> +	},
> +	{
> +		.name	= "4:2:2, packed, YUYV",
> +		.fourcc	= V4L2_PIX_FMT_YUYV,
> +		.types	= MEM2MEM_OUTPUT,
> +	},
> +};
> +
> +/* Per-queue, driver-specific private data */
> +struct emmaprp_q_data {
> +	unsigned int		width;
> +	unsigned int		height;
> +	unsigned int		sizeimage;
> +	struct emmaprp_fmt	*fmt;
> +};
> +
> +enum {
> +	V4L2_M2M_SRC = 0,
> +	V4L2_M2M_DST = 1,
> +};
> +
> +/* Source and destination queue data */
> +static struct emmaprp_q_data q_data[2];

Isn't it possible to embed this data into struct emmaprp_ctx ?
struct emmaprp_ctx object is available anywhere where get_q_data() is used.

And that would have to be changed anyway in case there are multiple instances
of a device this driver binds to.

> +
> +static struct emmaprp_q_data *get_q_data(enum v4l2_buf_type type)
> +{
> +	switch (type) {
> +	case V4L2_BUF_TYPE_VIDEO_OUTPUT:
> +		return&q_data[V4L2_M2M_SRC];
> +	case V4L2_BUF_TYPE_VIDEO_CAPTURE:
> +		return&q_data[V4L2_M2M_DST];
> +	default:
> +		BUG();
> +	}
> +	return NULL;
> +}
> +
> +#define NUM_FORMATS ARRAY_SIZE(formats)
> +
> +static struct emmaprp_fmt *find_format(struct v4l2_format *f)
> +{
> +	struct emmaprp_fmt *fmt;
> +	unsigned int k;
> +
> +	for (k = 0; k<  NUM_FORMATS; k++) {
> +		fmt =&formats[k];
> +		if (fmt->fourcc == f->fmt.pix.pixelformat)
> +			break;
> +	}
> +
> +	if (k == NUM_FORMATS)
> +		return NULL;
> +
> +	return&formats[k];
> +}
> +
> +struct emmaprp_dev {
> +	struct v4l2_device	v4l2_dev;
> +	struct video_device	*vfd;
> +
> +	atomic_t		busy;
> +	struct mutex		dev_mutex;
> +	spinlock_t		irqlock;
> +
> +	int			irq_emma;
> +	void __iomem		*base_emma;
> +	struct clk		*clk_emma;
> +	struct resource		*res_emma;
> +
> +	struct v4l2_m2m_dev	*m2m_dev;
> +	struct vb2_alloc_ctx	*alloc_ctx;
> +};
> +
> +struct emmaprp_ctx {
> +	struct emmaprp_dev	*dev;
> +
> +	/* Abort requested by m2m */
> +	int			aborting;
> +
> +	struct v4l2_m2m_ctx	*m2m_ctx;
> +};
> +
> +/*
> + * mem2mem callbacks
> + */
> +static int emmaprp_job_ready(void *priv)
> +{
> +	struct emmaprp_ctx *ctx = priv;
> +	struct emmaprp_dev *pcdev = ctx->dev;
> +
> +	if ((v4l2_m2m_num_src_bufs_ready(ctx->m2m_ctx)>  0)
> +	&&  (v4l2_m2m_num_dst_bufs_ready(ctx->m2m_ctx)>  0)
> +	&&  (atomic_read(&pcdev->busy) == 0))
> +		return 1;
> +
> +	dprintk(pcdev, "Task not ready to run\n");
> +
> +	return 0;
> +}

It looks like only one buffer on each queue is needed for single device_run(),
i.e. you H/W doesn't need more than 2 buffers for processing. In this case
job_ready callback may be left unimplemented and you can remove the 'busy' variable
altogether. 


Here is description of the job_ready callback, from include/media/v4l2-mem2mem.h:

 * @job_ready:	optional. Should return 0 if the driver does not have a job
 *		fully prepared to run yet (i.e. it will not be able to finish a
 *		transaction without sleeping). If not provided, it will be
 *		assumed that one source and one destination buffer are all
 *		that is required for the driver to perform one full transaction.
 *		This method may not sleep.

> +
> +static void emmaprp_job_abort(void *priv)
> +{
> +	struct emmaprp_ctx *ctx = priv;
> +	struct emmaprp_dev *pcdev = ctx->dev;
> +
> +	ctx->aborting = 1;
> +
> +	dprintk(pcdev, "Aborting task\n");
> +
> +	v4l2_m2m_job_finish(pcdev->m2m_dev, ctx->m2m_ctx);
> +}
> +
> +static void emmaprp_lock(void *priv)
> +{
> +	struct emmaprp_ctx *ctx = priv;
> +	struct emmaprp_dev *pcdev = ctx->dev;
> +	mutex_lock(&pcdev->dev_mutex);
> +}
> +
> +static void emmaprp_unlock(void *priv)
> +{
> +	struct emmaprp_ctx *ctx = priv;
> +	struct emmaprp_dev *pcdev = ctx->dev;
> +	mutex_unlock(&pcdev->dev_mutex);
> +}
> +
> +static inline void emmaprp_dump_regs(struct emmaprp_dev *pcdev)
> +{
> +	dprintk(pcdev,
> +		"eMMa-PrP Registers:\n"
> +		"  SOURCE_Y_PTR = 0x%08X\n"
> +		"  SRC_FRAME_SIZE = 0x%08X\n"
> +		"  DEST_Y_PTR = 0x%08X\n"
> +		"  DEST_CR_PTR = 0x%08X\n"
> +		"  DEST_CB_PTR = 0x%08X\n"
> +		"  CH2_OUT_IMAGE_SIZE = 0x%08X\n"
> +		"  CNTL = 0x%08X\n",
> +		readl(pcdev->base_emma + PRP_SOURCE_Y_PTR),
> +		readl(pcdev->base_emma + PRP_SRC_FRAME_SIZE),
> +		readl(pcdev->base_emma + PRP_DEST_Y_PTR),
> +		readl(pcdev->base_emma + PRP_DEST_CR_PTR),
> +		readl(pcdev->base_emma + PRP_DEST_CB_PTR),
> +		readl(pcdev->base_emma + PRP_CH2_OUT_IMAGE_SIZE),
> +		readl(pcdev->base_emma + PRP_CNTL));
> +}
> +
> +static void emmaprp_device_run(void *priv)
> +{
> +	struct emmaprp_ctx *ctx = priv;
> +	struct emmaprp_q_data *s_q_data, *d_q_data;
> +	struct vb2_buffer *src_buf, *dst_buf;
> +	struct emmaprp_dev *pcdev = ctx->dev;
> +	unsigned int s_width, s_height;
> +	unsigned int d_width, d_height;
> +	unsigned int d_size;
> +	u8 *p_in, *p_out;

How about using dma_addr_t instead of (u8 *) ?

> +	u32 tmp;
> +
> +	atomic_set(&ctx->dev->busy, 1);
> +
> +	src_buf = v4l2_m2m_next_src_buf(ctx->m2m_ctx);
> +	dst_buf = v4l2_m2m_next_dst_buf(ctx->m2m_ctx);
> +
> +	s_q_data = get_q_data(V4L2_BUF_TYPE_VIDEO_OUTPUT);
> +	s_width	= s_q_data->width;
> +	s_height = s_q_data->height;
> +
> +	d_q_data = get_q_data(V4L2_BUF_TYPE_VIDEO_CAPTURE);
> +	d_width = d_q_data->width;
> +	d_height = d_q_data->height;
> +	d_size = d_width * d_height;
> +
> +	p_in = (u8 *)vb2_dma_contig_plane_dma_addr(src_buf, 0);
> +	p_out = (u8 *)vb2_dma_contig_plane_dma_addr(dst_buf, 0);
> +	if (!p_in || !p_out) {
> +		v4l2_err(&pcdev->v4l2_dev,
> +			 "Acquiring kernel pointers to buffers failed\n");
> +		return;
> +	}
> +
> +	/* Input frame parameters */
> +	writel(p_in, pcdev->base_emma + PRP_SOURCE_Y_PTR);
> +	writel(PRP_SIZE_WIDTH(s_width) | PRP_SIZE_HEIGHT(s_height),
> +	       pcdev->base_emma + PRP_SRC_FRAME_SIZE);
> +
> +	/* Output frame parameters */
> +	writel(p_out, pcdev->base_emma + PRP_DEST_Y_PTR);
> +	writel(p_out + d_size, pcdev->base_emma + PRP_DEST_CB_PTR);
> +	writel(p_out + d_size + (d_size>>  2),
> +	       pcdev->base_emma + PRP_DEST_CR_PTR);
> +	writel(PRP_SIZE_WIDTH(d_width) | PRP_SIZE_HEIGHT(d_height),
> +	       pcdev->base_emma + PRP_CH2_OUT_IMAGE_SIZE);
> +
> +	/* IRQ configuration */
> +	tmp = readl(pcdev->base_emma + PRP_INTR_CNTL);
> +	writel(tmp | PRP_INTR_RDERR |
> +		PRP_INTR_CH2WERR |
> +		PRP_INTR_CH2FC,
> +		pcdev->base_emma + PRP_INTR_CNTL);
> +
> +	emmaprp_dump_regs(pcdev);
> +
> +	/* Enable transfer */
> +	tmp = readl(pcdev->base_emma + PRP_CNTL);
> +	writel(tmp | PRP_CNTL_CH2_OUT_YUV420 |
> +		PRP_CNTL_DATA_IN_YUV422 |
> +		PRP_CNTL_CH2EN,
> +		pcdev->base_emma + PRP_CNTL);
> +}
> +
> +static irqreturn_t emmaprp_irq(int irq_emma, void *data)
> +{
> +	struct emmaprp_dev *pcdev = (struct emmaprp_dev *)data;

No need for casting.

> +	struct emmaprp_ctx *curr_ctx;
> +	struct vb2_buffer *src_vb, *dst_vb;
> +	unsigned long flags;
> +	u32 irqst;
> +
> +	/* Check irq flags and clear irq */
> +	irqst = readl(pcdev->base_emma + PRP_INTRSTATUS);
> +	writel(irqst, pcdev->base_emma + PRP_INTRSTATUS);
> +	dprintk(pcdev, "irqst = 0x%08x\n", irqst);
> +
> +	curr_ctx = v4l2_m2m_get_curr_priv(pcdev->m2m_dev);
> +	if (NULL == curr_ctx) {
> +		printk(KERN_ERR
> +			"Instance released before the end of transaction\n");

In new drivers, instead if printk(<LEVEL>.. pr_<level>(.. is preferred, i.e.
in this case pr_err(). 

> +		return IRQ_HANDLED;
> +	}
> +
> +	if (curr_ctx->aborting)
> +		goto irq_ok;
> +
> +	if ((irqst&  PRP_INTR_ST_RDERR) ||
> +	    (irqst&  PRP_INTR_ST_CH2WERR)) {
> +		printk(KERN_ERR
> +			"PrP bus error ocurred, this transfer is probably corrupted\n");

Ditto.

> +		writel(PRP_CNTL_SWRST, pcdev->base_emma + PRP_CNTL);
> +		goto irq_ok;
> +	}
> +
> +	if (irqst&  PRP_INTR_ST_CH2B1CI) { /* buffer ready */
> +		src_vb = v4l2_m2m_src_buf_remove(curr_ctx->m2m_ctx);
> +		dst_vb = v4l2_m2m_dst_buf_remove(curr_ctx->m2m_ctx);
> +
> +		spin_lock_irqsave(&pcdev->irqlock, flags);
> +		v4l2_m2m_buf_done(src_vb, VB2_BUF_STATE_DONE);
> +		v4l2_m2m_buf_done(dst_vb, VB2_BUF_STATE_DONE);
> +		spin_unlock_irqrestore(&pcdev->irqlock, flags);
> +		goto irq_ok;
> +	}
> +
> +irq_ok:
> +	atomic_set(&pcdev->busy, 0);
> +	v4l2_m2m_job_finish(pcdev->m2m_dev, curr_ctx->m2m_ctx);
> +
> +	return IRQ_HANDLED;
> +}
> +
> +/*
> + * video ioctls
> + */
...
> +
> +static int vidioc_try_fmt(struct v4l2_format *f, struct emmaprp_fmt *fmt)

fmt is unused in this function, perhaps this argument can be removed.

> +{
> +	enum v4l2_field field;
> +
> +	field = f->fmt.pix.field;
> +
> +	if (field == V4L2_FIELD_ANY)
> +		field = V4L2_FIELD_NONE;
> +	else if (V4L2_FIELD_NONE != field)
> +		return -EINVAL;
> +
> +	/* V4L2 specification suggests the driver corrects the format struct
> +	 * if any of the dimensions is unsupported */
> +	f->fmt.pix.field = field;
> +
> +	if (f->fmt.pix.height<  MIN_H)
> +		f->fmt.pix.height = MIN_H;
> +	else if (f->fmt.pix.height>  MAX_H)
> +		f->fmt.pix.height = MAX_H;
> +
> +	if (f->fmt.pix.width<  MIN_W)
> +		f->fmt.pix.width = MIN_W;
> +	else if (f->fmt.pix.width>  MAX_W)
> +		f->fmt.pix.width = MAX_W;

I would go for a clamp_t here, e.g. 

	f->fmt.pix.height = clamp_t(u32, f->fmt.pix.height, MIN_H, MAX_H);
	f->fmt.pix.width = clamp_t(u32, f->fmt.pix.width, MIN_W, MAX_W);

> +
> +	f->fmt.pix.height&= ~H_ALIGN_MASK;
> +	if (f->fmt.pix.pixelformat == V4L2_PIX_FMT_YUV420) {
> +		f->fmt.pix.width&= ~W_ALIGN_MASK_YUV420;
> +		f->fmt.pix.bytesperline = f->fmt.pix.width * 3 / 2;
> +	} else { /* YUYV */
> +		f->fmt.pix.width&= ~W_ALIGN_MASK_OTHERS;
> +		f->fmt.pix.bytesperline = f->fmt.pix.width * 2;
> +	}
> +	f->fmt.pix.sizeimage = f->fmt.pix.height * f->fmt.pix.bytesperline;
> +
> +	return 0;
> +}
> +
> +static int vidioc_try_fmt_vid_cap(struct file *file, void *priv,
> +				  struct v4l2_format *f)
> +{
> +	struct emmaprp_fmt *fmt;
> +	struct emmaprp_ctx *ctx = priv;
> +
> +	fmt = find_format(f);
> +	if (!fmt || !(fmt->types&  MEM2MEM_CAPTURE)) {
> +		v4l2_err(&ctx->dev->v4l2_dev,
> +			 "Fourcc format (0x%08x) invalid.\n",
> +			 f->fmt.pix.pixelformat);
> +		return -EINVAL;
> +	}
> +
> +	return vidioc_try_fmt(f, fmt);
> +}
> +
> +static int vidioc_try_fmt_vid_out(struct file *file, void *priv,
> +				  struct v4l2_format *f)
> +{
> +	struct emmaprp_fmt *fmt;
> +	struct emmaprp_ctx *ctx = priv;
> +
> +	fmt = find_format(f);
> +	if (!fmt || !(fmt->types&  MEM2MEM_OUTPUT)) {
> +		v4l2_err(&ctx->dev->v4l2_dev,
> +			 "Fourcc format (0x%08x) invalid.\n",
> +			 f->fmt.pix.pixelformat);
> +		return -EINVAL;
> +	}
> +
> +	return vidioc_try_fmt(f, fmt);
> +}
> +
> +static int vidioc_s_fmt(struct emmaprp_ctx *ctx, struct v4l2_format *f)
> +{
> +	struct emmaprp_q_data *q_data;
> +	struct vb2_queue *vq;
> +
> +	vq = v4l2_m2m_get_vq(ctx->m2m_ctx, f->type);
> +	if (!vq)
> +		return -EINVAL;
> +
> +	q_data = get_q_data(f->type);
> +	if (!q_data)
> +		return -EINVAL;
> +
> +	if (vb2_is_busy(vq)) {
> +		v4l2_err(&ctx->dev->v4l2_dev, "%s queue busy\n", __func__);
> +		return -EBUSY;
> +	}

I can't see where the format is adjusted against the device capabilities, perhaps 
something like:

	ret = vidioc_try_fmt(f, ...
	if (ret < 0)
		return ret;
would do.

> +
> +	q_data->fmt		= find_format(f);
> +	q_data->width		= f->fmt.pix.width;
> +	q_data->height		= f->fmt.pix.height;
> +	if (q_data->fmt->fourcc == V4L2_PIX_FMT_YUV420)
> +		q_data->sizeimage = q_data->width * q_data->height * 3 / 2;
> +	else /* YUYV */
> +		q_data->sizeimage = q_data->width * q_data->height * 2;
> +
> +	dprintk(ctx->dev,
> +		"Setting format for type %d, wxh: %dx%d, fmt: %d\n",
> +		f->type, q_data->width, q_data->height, q_data->fmt->fourcc);
> +
> +	return 0;
> +}
> +
...
> +/*
> + * File operations
> + */
> +static int emmaprp_open(struct file *file)
> +{
> +	struct emmaprp_dev *pcdev = video_drvdata(file);
> +	struct emmaprp_ctx *ctx = NULL;

The assignment is unnecessary.

> +
> +	ctx = kzalloc(sizeof *ctx, GFP_KERNEL);
> +	if (!ctx)
> +		return -ENOMEM;
> +
> +	file->private_data = ctx;
> +	ctx->dev = pcdev;
> +
> +	ctx->m2m_ctx = v4l2_m2m_ctx_init(pcdev->m2m_dev, ctx,&queue_init);
> +
> +	if (IS_ERR(ctx->m2m_ctx)) {
> +		int ret = PTR_ERR(ctx->m2m_ctx);
> +
> +		kfree(ctx);
> +		return ret;
> +	}
> +
> +	clk_enable(pcdev->clk_emma);
> +
> +	dprintk(pcdev, "Created instance %p, m2m_ctx: %p\n", ctx, ctx->m2m_ctx);
> +
> +	return 0;
> +}
> +
...
> +
> +static int emmaprp_probe(struct platform_device *pdev)
> +{
> +	struct emmaprp_dev *pcdev;
> +	struct video_device *vfd;
> +	struct resource *res_emma;
> +	int irq_emma;
> +	int ret;
> +
> +	pcdev = kzalloc(sizeof *pcdev, GFP_KERNEL);
> +	if (!pcdev)
> +		return -ENOMEM;
> +
> +	spin_lock_init(&pcdev->irqlock);
> +
> +	pcdev->clk_emma = clk_get(NULL, "emma");
> +	if (IS_ERR(pcdev->clk_emma)) {
> +		ret = PTR_ERR(pcdev->clk_emma);
> +		goto free_dev;
> +	}
> +
> +	irq_emma = platform_get_irq(pdev, 0);
> +	res_emma = platform_get_resource(pdev, IORESOURCE_MEM, 0);
> +	if (irq_emma<  0 || res_emma == NULL) {
> +		dev_err(&pdev->dev, "Missing platform resources data\n");
> +		ret = -ENODEV;
> +		goto free_clk;
> +	}
> +
> +	ret = v4l2_device_register(&pdev->dev,&pcdev->v4l2_dev);
> +	if (ret)
> +		goto free_clk;
> +
> +	atomic_set(&pcdev->busy, 0);
> +	mutex_init(&pcdev->dev_mutex);
> +
> +	vfd = video_device_alloc();
> +	if (!vfd) {
> +		v4l2_err(&pcdev->v4l2_dev, "Failed to allocate video device\n");
> +		ret = -ENOMEM;
> +		goto unreg_dev;
> +	}
> +
> +	*vfd = emmaprp_videodev;
> +	vfd->lock =&pcdev->dev_mutex;
> +
> +	ret = video_register_device(vfd, VFL_TYPE_GRABBER, 0);

It's to early to register a video device at this point, it should be done
as the last thing, after all needed resources are prepared. Let's imagine
the corresponding /dev/video? is opened by a user process right at this point,
would that work ?

> +	if (ret) {
> +		v4l2_err(&pcdev->v4l2_dev, "Failed to register video device\n");
> +		goto rel_vdev;
> +	}
> +
> +	video_set_drvdata(vfd, pcdev);
> +	snprintf(vfd->name, sizeof(vfd->name), "%s", emmaprp_videodev.name);
> +	pcdev->vfd = vfd;
> +	v4l2_info(&pcdev->v4l2_dev, MEM2MEM_TEST_MODULE_NAME
> +			" Device registered as /dev/video%d\n", vfd->num);
> +
> +	platform_set_drvdata(pdev, pcdev);
> +
> +	if (!request_mem_region(res_emma->start, resource_size(res_emma),
> +				MEM2MEM_NAME)) {
> +		ret = -EBUSY;
> +		goto rel_vdev;
> +	}
> +
> +	pcdev->base_emma = ioremap(res_emma->start, resource_size(res_emma));
> +	if (!pcdev->base_emma) {
> +		ret = -ENOMEM;
> +		goto rel_mem;
> +	}
> +	pcdev->irq_emma = irq_emma;
> +	pcdev->res_emma = res_emma;
> +
> +	ret = request_irq(pcdev->irq_emma, emmaprp_irq, 0,
> +			  MEM2MEM_NAME, pcdev);
> +	if (ret)
> +		goto rel_map;
> +
> +
> +	pcdev->alloc_ctx = vb2_dma_contig_init_ctx(&pdev->dev);
> +	if (IS_ERR(pcdev->alloc_ctx)) {
> +		v4l2_err(&pcdev->v4l2_dev, "Failed to alloc vb2 context\n");
> +		ret = PTR_ERR(pcdev->alloc_ctx);
> +		goto err_ctx;
> +	}
> +
> +	pcdev->m2m_dev = v4l2_m2m_init(&m2m_ops);
> +	if (IS_ERR(pcdev->m2m_dev)) {
> +		v4l2_err(&pcdev->v4l2_dev, "Failed to init mem2mem device\n");
> +		ret = PTR_ERR(pcdev->m2m_dev);
> +		goto err_m2m;
> +	}
> +
> +	q_data[V4L2_M2M_SRC].fmt =&formats[1];
> +	q_data[V4L2_M2M_DST].fmt =&formats[0];
> +
> +	return 0;
> +
> +	v4l2_m2m_release(pcdev->m2m_dev);
> +err_m2m:
> +	video_unregister_device(pcdev->vfd);
> +err_ctx:
> +	vb2_dma_contig_cleanup_ctx(pcdev->alloc_ctx);
> +	free_irq(pcdev->irq_emma, pcdev);
> +rel_map:
> +	iounmap(pcdev->base_emma);
> +rel_mem:
> +	release_mem_region(res_emma->start, resource_size(res_emma));
> +rel_vdev:
> +	video_device_release(vfd);
> +unreg_dev:
> +	v4l2_device_unregister(&pcdev->v4l2_dev);
> +free_clk:
> +	clk_put(pcdev->clk_emma);
> +free_dev:
> +	kfree(pcdev);
> +
> +	return ret;
> +}
> +
> +static int emmaprp_remove(struct platform_device *pdev)
> +{
> +	struct resource *res_emma;
> +	struct emmaprp_dev *pcdev =
> +		(struct emmaprp_dev *)platform_get_drvdata(pdev);

No need for type casting here.

> +
> +	v4l2_info(&pcdev->v4l2_dev, "Removing " MEM2MEM_TEST_MODULE_NAME);
> +	v4l2_m2m_release(pcdev->m2m_dev);
> +	free_irq(pcdev->irq_emma, pcdev);
> +	iounmap(pcdev->base_emma);
> +	res_emma = pcdev->res_emma;
> +	release_mem_region(res_emma->start, resource_size(res_emma));
> +	video_unregister_device(pcdev->vfd);

You may want to unregister the video device as the first, before freeing
any resources associated with it.

> +	v4l2_device_unregister(&pcdev->v4l2_dev);
> +	clk_put(pcdev->clk_emma);
> +	vb2_dma_contig_cleanup_ctx(pcdev->alloc_ctx);
> +
> +	kfree(pcdev);
> +
> +	return 0;
> +}

--
Regards,
Sylwester

