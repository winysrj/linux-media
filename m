Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud7.xs4all.net ([194.109.24.28]:40555 "EHLO
        lb2-smtp-cloud7.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1732624AbeKMWWv (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 13 Nov 2018 17:22:51 -0500
Subject: Re: [PATCH 3/5] media: sunxi: Add A10 CSI driver
To: Maxime Ripard <maxime.ripard@bootlin.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
Cc: Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        linux-media@vger.kernel.org, Andrzej Hajda <a.hajda@samsung.com>,
        Chen-Yu Tsai <wens@csie.org>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org,
        Mark Rutland <mark.rutland@arm.com>,
        Rob Herring <robh+dt@kernel.org>,
        Frank Rowand <frowand.list@gmail.com>
References: <cover.71b0f9855c251f9dc389ee77ee6f0e1fad91fb0b.1542097288.git-series.maxime.ripard@bootlin.com>
 <c53e1cdc3b139382b00ee06bf3980d3fd1742ec0.1542097288.git-series.maxime.ripard@bootlin.com>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <f34c79f5-66d6-2c2f-5616-020ad2b96400@xs4all.nl>
Date: Tue, 13 Nov 2018 13:24:47 +0100
MIME-Version: 1.0
In-Reply-To: <c53e1cdc3b139382b00ee06bf3980d3fd1742ec0.1542097288.git-series.maxime.ripard@bootlin.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Maxime,

A quick code review:

On 11/13/18 09:24, Maxime Ripard wrote:
> The older CSI drivers have camera capture interface different from the one
> in the newer ones.
> 
> This IP is pretty simple. Some variants (one controller out of two
> instances on some SoCs) have an ISP embedded, but there's no code that make
> use of it, so we ignored that part for now.
> 
> Signed-off-by: Maxime Ripard <maxime.ripard@bootlin.com>
> ---
>  drivers/media/platform/sunxi/Kconfig                |   1 +-
>  drivers/media/platform/sunxi/Makefile               |   1 +-
>  drivers/media/platform/sunxi/sun4i-csi/Kconfig      |  12 +-
>  drivers/media/platform/sunxi/sun4i-csi/Makefile     |   5 +-
>  drivers/media/platform/sunxi/sun4i-csi/sun4i_csi.c  | 275 +++++++++-
>  drivers/media/platform/sunxi/sun4i-csi/sun4i_csi.h  | 137 +++++-
>  drivers/media/platform/sunxi/sun4i-csi/sun4i_dma.c  | 383 +++++++++++++-
>  drivers/media/platform/sunxi/sun4i-csi/sun4i_v4l2.c | 287 ++++++++++-

Missing MAINTAINERS file update.

>  8 files changed, 1101 insertions(+)
>  create mode 100644 drivers/media/platform/sunxi/sun4i-csi/Kconfig
>  create mode 100644 drivers/media/platform/sunxi/sun4i-csi/Makefile
>  create mode 100644 drivers/media/platform/sunxi/sun4i-csi/sun4i_csi.c
>  create mode 100644 drivers/media/platform/sunxi/sun4i-csi/sun4i_csi.h
>  create mode 100644 drivers/media/platform/sunxi/sun4i-csi/sun4i_dma.c
>  create mode 100644 drivers/media/platform/sunxi/sun4i-csi/sun4i_v4l2.c
> 
> diff --git a/drivers/media/platform/sunxi/Kconfig b/drivers/media/platform/sunxi/Kconfig
> index 1b6e89cb78b2..71808e93ac2e 100644
> --- a/drivers/media/platform/sunxi/Kconfig
> +++ b/drivers/media/platform/sunxi/Kconfig
> @@ -1 +1,2 @@
> +source "drivers/media/platform/sunxi/sun4i-csi/Kconfig"
>  source "drivers/media/platform/sunxi/sun6i-csi/Kconfig"
> diff --git a/drivers/media/platform/sunxi/Makefile b/drivers/media/platform/sunxi/Makefile
> index 8d06f98500ee..a05127529006 100644
> --- a/drivers/media/platform/sunxi/Makefile
> +++ b/drivers/media/platform/sunxi/Makefile
> @@ -1 +1,2 @@
> +obj-y		+= sun4i-csi/
>  obj-y		+= sun6i-csi/
> diff --git a/drivers/media/platform/sunxi/sun4i-csi/Kconfig b/drivers/media/platform/sunxi/sun4i-csi/Kconfig
> new file mode 100644
> index 000000000000..841a6f4d9c99
> --- /dev/null
> +++ b/drivers/media/platform/sunxi/sun4i-csi/Kconfig
> @@ -0,0 +1,12 @@
> +config VIDEO_SUN4I_CSI
> +	tristate "Allwinner A10 CMOS Sensor Interface Support"
> +	depends on VIDEO_DEV && VIDEO_V4L2 && HAS_DMA
> +	depends on ARCH_SUNXI || COMPILE_TEST
> +	select VIDEOBUF2_DMA_CONTIG
> +	select V4L2_FWNODE
> +	select V4L2_MEM2MEM_DEV
> +	help
> +	  This is a V4L2 driver for the Allwinner A10 CSI
> +
> +	  To compile this driver as a module, choose M here: the module
> +	  will be called sun4i_csi.
> diff --git a/drivers/media/platform/sunxi/sun4i-csi/Makefile b/drivers/media/platform/sunxi/sun4i-csi/Makefile
> new file mode 100644
> index 000000000000..7c790a57f5ee
> --- /dev/null
> +++ b/drivers/media/platform/sunxi/sun4i-csi/Makefile
> @@ -0,0 +1,5 @@
> +sun4i-csi-y += sun4i_csi.o
> +sun4i-csi-y += sun4i_dma.o
> +sun4i-csi-y += sun4i_v4l2.o
> +
> +obj-$(CONFIG_VIDEO_SUN4I_CSI)	+= sun4i-csi.o
> diff --git a/drivers/media/platform/sunxi/sun4i-csi/sun4i_csi.c b/drivers/media/platform/sunxi/sun4i-csi/sun4i_csi.c
> new file mode 100644
> index 000000000000..3e0a65ccbbe2
> --- /dev/null
> +++ b/drivers/media/platform/sunxi/sun4i-csi/sun4i_csi.c
> @@ -0,0 +1,275 @@
> +// SPDX-License-Identifier: GPL-2.0-or-later
> +/*
> + * Copyright (C) 2016 NextThing Co
> + * Copyright (C) 2016-2018 Bootlin
> + *
> + * Author: Maxime Ripard <maxime.ripard@bootlin.com>
> + */
> +
> +#include <linux/clk.h>
> +#include <linux/interrupt.h>
> +#include <linux/module.h>
> +#include <linux/mutex.h>
> +#include <linux/of.h>
> +#include <linux/of_graph.h>
> +#include <linux/platform_device.h>
> +#include <linux/pm_runtime.h>
> +#include <linux/reset.h>
> +#include <linux/videodev2.h>
> +
> +#include <media/v4l2-dev.h>
> +#include <media/v4l2-device.h>
> +#include <media/v4l2-fwnode.h>
> +#include <media/v4l2-ioctl.h>
> +#include <media/v4l2-mediabus.h>
> +
> +#include <media/videobuf2-core.h>
> +#include <media/videobuf2-dma-contig.h>
> +
> +#include "sun4i_csi.h"
> +
> +static int csi_notify_bound(struct v4l2_async_notifier *notifier,
> +			    struct v4l2_subdev *subdev,
> +			    struct v4l2_async_subdev *asd)
> +{
> +	struct sun4i_csi *csi = container_of(notifier, struct sun4i_csi,
> +					     notifier);
> +
> +	csi->src_subdev = subdev;
> +	csi->src_pad = media_entity_get_fwnode_pad(&subdev->entity,
> +						   subdev->fwnode,
> +						   MEDIA_PAD_FL_SOURCE);
> +	if (csi->src_pad < 0) {
> +		dev_err(csi->dev, "Couldn't find output pad for subdev %s\n",
> +			subdev->name);
> +		return csi->src_pad;
> +	}
> +
> +	dev_dbg(csi->dev, "Bound %s pad: %d\n", subdev->name, csi->src_pad);
> +	return 0;
> +}
> +
> +static int csi_notify_complete(struct v4l2_async_notifier *notifier)
> +{
> +	struct sun4i_csi *csi = container_of(notifier, struct sun4i_csi,
> +					     notifier);
> +	int ret;
> +
> +	if (notifier->num_subdevs != 1)
> +		return -EINVAL;
> +
> +	ret = v4l2_device_register_subdev_nodes(&csi->v4l);
> +	if (ret < 0)
> +		return ret;
> +
> +	ret = csi_v4l2_register(csi);
> +	if (ret < 0)
> +		return ret;
> +
> +	return media_create_pad_link(&csi->src_subdev->entity, csi->src_pad,
> +				     &csi->vdev.entity, 0,
> +				     MEDIA_LNK_FL_ENABLED |
> +				     MEDIA_LNK_FL_IMMUTABLE);
> +}
> +
> +static const struct v4l2_async_notifier_operations csi_notify_ops = {
> +	.bound		= csi_notify_bound,
> +	.complete	= csi_notify_complete,
> +};
> +
> +static int sun4i_csi_async_parse(struct device *dev,
> +				 struct v4l2_fwnode_endpoint *vep,
> +				 struct v4l2_async_subdev *asd)
> +{
> +	struct sun4i_csi *csi = dev_get_drvdata(dev);
> +
> +	if (vep->base.port || vep->base.id)
> +		return -EINVAL;
> +
> +	if (vep->bus_type != V4L2_MBUS_PARALLEL)
> +		return -EINVAL;
> +
> +	csi->bus = vep->bus.parallel;
> +
> +	return 0;
> +}
> +
> +static int csi_probe(struct platform_device *pdev)
> +{
> +	struct sun4i_csi *csi;
> +	struct resource *res;
> +	int ret;
> +	int irq;
> +
> +	csi = devm_kzalloc(&pdev->dev, sizeof(*csi), GFP_KERNEL);

devm_kzalloc is not recommended: all devm_ memory is freed when the driver
is unbound, but a filehandle might still have a reference open.

> +	if (!csi)
> +		return -ENOMEM;
> +	platform_set_drvdata(pdev, csi);
> +	csi->dev = &pdev->dev;
> +
> +	csi->mdev.dev = csi->dev;
> +	strlcpy(csi->mdev.model, "Allwinner Video Capture Device",
> +		sizeof(csi->mdev.model));

Use strscpy instead of strcpy, strncpy or strlcpy. We're in the process
of converting all of those string copy functions in drivers/media to
strscpy.

> +	csi->mdev.hw_revision = 0;
> +	media_device_init(&csi->mdev);
> +
> +	csi->pad.flags = MEDIA_PAD_FL_SINK | MEDIA_PAD_FL_MUST_CONNECT;
> +	ret = media_entity_pads_init(&csi->vdev.entity, 1, &csi->pad);
> +	if (ret < 0)
> +		return 0;
> +
> +	csi->has_isp = of_property_read_bool(pdev->dev.of_node,
> +					     "allwinner,has-isp");
> +
> +	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
> +	csi->regs = devm_ioremap_resource(&pdev->dev, res);
> +	if (IS_ERR(csi->regs))
> +		return PTR_ERR(csi->regs);
> +
> +	irq = platform_get_irq(pdev, 0);
> +	if (irq < 0)
> +		return irq;
> +
> +	csi->ahb_clk = devm_clk_get(&pdev->dev, "ahb");
> +	if (IS_ERR(csi->ahb_clk)) {
> +		dev_err(&pdev->dev, "Couldn't get our ahb clock\n");
> +		return PTR_ERR(csi->ahb_clk);
> +	}
> +
> +	if (csi->has_isp) {
> +		csi->isp_clk = devm_clk_get(&pdev->dev, "isp");
> +		if (IS_ERR(csi->isp_clk)) {
> +			dev_err(&pdev->dev, "Couldn't get our ISP clock\n");
> +			return PTR_ERR(csi->isp_clk);
> +		}
> +	}
> +
> +	csi->mod_clk = devm_clk_get(&pdev->dev, "mod");
> +	if (IS_ERR(csi->mod_clk)) {
> +		dev_err(&pdev->dev, "Couldn't get our mod clock\n");
> +		return PTR_ERR(csi->mod_clk);
> +	}
> +
> +	csi->ram_clk = devm_clk_get(&pdev->dev, "ram");
> +	if (IS_ERR(csi->ram_clk)) {
> +		dev_err(&pdev->dev, "Couldn't get our ram clock\n");
> +		return PTR_ERR(csi->ram_clk);
> +	}
> +
> +	csi->rst = devm_reset_control_get(&pdev->dev, NULL);
> +	if (IS_ERR(csi->rst)) {
> +		dev_err(&pdev->dev, "Couldn't get our reset line\n");
> +		return PTR_ERR(csi->rst);
> +	}
> +
> +	ret = csi_dma_register(csi, irq);
> +	if (ret)
> +		return ret;
> +
> +	csi->v4l.mdev = &csi->mdev;
> +
> +	ret = media_device_register(&csi->mdev);
> +	if (ret)
> +		goto err_unregister_dma;
> +
> +	ret = v4l2_async_notifier_parse_fwnode_endpoints(csi->dev,
> +							 &csi->notifier,
> +							 sizeof(struct v4l2_async_subdev),
> +							 sun4i_csi_async_parse);
> +	if (ret)
> +		goto err_unregister_media;
> +	csi->notifier.ops = &csi_notify_ops;
> +
> +	ret = v4l2_async_notifier_register(&csi->v4l, &csi->notifier);
> +	if (ret) {
> +		dev_err(csi->dev,
> +			"Couldn't register our v4l2-async notifier\n");
> +		goto err_free_notifier;
> +	}
> +
> +	pm_runtime_enable(&pdev->dev);
> +
> +	return 0;
> +
> +err_free_notifier:
> +	v4l2_async_notifier_cleanup(&csi->notifier);
> +
> +err_unregister_media:
> +	media_device_unregister(&csi->mdev);
> +
> +err_unregister_dma:
> +	csi_dma_unregister(csi);
> +	return ret;
> +}
> +
> +static int csi_remove(struct platform_device *pdev)
> +{
> +	struct sun4i_csi *csi = platform_get_drvdata(pdev);
> +
> +	v4l2_async_notifier_unregister(&csi->notifier);
> +	v4l2_async_notifier_cleanup(&csi->notifier);
> +	media_device_unregister(&csi->mdev);
> +	csi_dma_unregister(csi);
> +
> +	return 0;
> +}
> +
> +static const struct of_device_id csi_of_match[] = {
> +	{ .compatible = "allwinner,sun4i-a10-csi" },
> +	{ /* Sentinel */ }
> +};
> +MODULE_DEVICE_TABLE(of, csi_of_match);
> +
> +static int csi_runtime_resume(struct device *dev)
> +{
> +	struct sun4i_csi *csi = dev_get_drvdata(dev);
> +
> +	reset_control_deassert(csi->rst);
> +	clk_prepare_enable(csi->ahb_clk);
> +	clk_prepare_enable(csi->ram_clk);
> +
> +	if (csi->has_isp) {
> +		clk_set_rate(csi->isp_clk, 80000000);
> +		clk_prepare_enable(csi->isp_clk);
> +	}
> +
> +	clk_set_rate(csi->mod_clk, 24000000);
> +	clk_prepare_enable(csi->mod_clk);
> +
> +	writel(1, csi->regs + CSI_EN_REG);
> +
> +	return 0;
> +}
> +
> +static int csi_runtime_suspend(struct device *dev)
> +{
> +	struct sun4i_csi *csi = dev_get_drvdata(dev);
> +
> +	clk_disable_unprepare(csi->mod_clk);
> +
> +	if (csi->has_isp)
> +		clk_disable_unprepare(csi->isp_clk);
> +
> +	clk_disable_unprepare(csi->ram_clk);
> +	clk_disable_unprepare(csi->ahb_clk);
> +
> +	reset_control_assert(csi->rst);
> +
> +	return 0;
> +}
> +
> +static const struct dev_pm_ops csi_pm_ops = {
> +	.runtime_resume		= csi_runtime_resume,
> +	.runtime_suspend	= csi_runtime_suspend,
> +};
> +
> +static struct platform_driver csi_driver = {
> +	.probe	= csi_probe,
> +	.remove	= csi_remove,
> +	.driver	= {
> +		.name		= "sun4i-csi",
> +		.of_match_table	= csi_of_match,
> +		.pm		= &csi_pm_ops,
> +	},
> +};
> +module_platform_driver(csi_driver);
> diff --git a/drivers/media/platform/sunxi/sun4i-csi/sun4i_csi.h b/drivers/media/platform/sunxi/sun4i-csi/sun4i_csi.h
> new file mode 100644
> index 000000000000..80ced01567fa
> --- /dev/null
> +++ b/drivers/media/platform/sunxi/sun4i-csi/sun4i_csi.h
> @@ -0,0 +1,137 @@
> +/* SPDX-License-Identifier: GPL-2.0-or-later */
> +/*
> + * Copyright (C) 2016 NextThing Co
> + * Copyright (C) 2016-2018 Bootlin
> + *
> + * Author: Maxime Ripard <maxime.ripard@bootlin.com>
> + */
> +
> +#ifndef _SUN4I_CSI_H_
> +#define _SUN4I_CSI_H_
> +
> +#include <media/media-device.h>
> +#include <media/v4l2-async.h>
> +#include <media/v4l2-dev.h>
> +#include <media/v4l2-device.h>
> +#include <media/v4l2-fwnode.h>
> +#include <media/videobuf2-core.h>
> +
> +#define CSI_EN_REG			0x00
> +
> +#define CSI_CFG_REG			0x04
> +#define CSI_CFG_INPUT_FMT(fmt)			((fmt) << 20)
> +#define CSI_CFG_OUTPUT_FMT(fmt)			((fmt) << 16)
> +#define CSI_CFG_YUV_DATA_SEQ(seq)		((seq) << 8)
> +#define CSI_CFG_VSYNC_POL(pol)			((pol) << 2)
> +#define CSI_CFG_HSYNC_POL(pol)			((pol) << 1)
> +#define CSI_CFG_PCLK_POL(pol)			((pol) << 0)
> +
> +#define CSI_CPT_CTRL_REG		0x08
> +#define CSI_CPT_CTRL_VIDEO_START		BIT(1)
> +#define CSI_CPT_CTRL_IMAGE_START		BIT(0)
> +
> +#define CSI_BUF_ADDR_REG(fifo, buf)	(0x10 + (0x8 * (fifo)) + (0x4 * (buf)))
> +
> +#define CSI_BUF_CTRL_REG		0x28
> +#define CSI_BUF_CTRL_DBN			BIT(2)
> +#define CSI_BUF_CTRL_DBS			BIT(1)
> +#define CSI_BUF_CTRL_DBE			BIT(0)
> +
> +#define CSI_INT_EN_REG			0x30
> +#define CSI_INT_FRM_DONE			BIT(1)
> +#define CSI_INT_CPT_DONE			BIT(0)
> +
> +#define CSI_INT_STA_REG			0x34
> +
> +#define CSI_WIN_CTRL_W_REG		0x40
> +#define CSI_WIN_CTRL_W_ACTIVE(w)		((w) << 16)
> +
> +#define CSI_WIN_CTRL_H_REG		0x44
> +#define CSI_WIN_CTRL_H_ACTIVE(h)		((h) << 16)
> +
> +#define CSI_BUF_LEN_REG			0x48
> +
> +#define CSI_MAX_BUFFER	2
> +
> +enum csi_input {
> +	CSI_INPUT_RAW	= 0,
> +	CSI_INPUT_BT656	= 2,
> +	CSI_INPUT_YUV	= 3,
> +};
> +
> +enum csi_output_raw {
> +	CSI_OUTPUT_RAW_PASSTHROUGH = 0,
> +};
> +
> +enum csi_output_yuv {
> +	CSI_OUTPUT_YUV_422_PLANAR	= 0,
> +	CSI_OUTPUT_YUV_420_PLANAR	= 1,
> +	CSI_OUTPUT_YUV_422_UV		= 4,
> +	CSI_OUTPUT_YUV_420_UV		= 5,
> +	CSI_OUTPUT_YUV_422_MACRO	= 8,
> +	CSI_OUTPUT_YUV_420_MACRO	= 9,
> +};
> +
> +enum csi_yuv_data_seq {
> +	CSI_YUV_DATA_SEQ_YUYV	= 0,
> +	CSI_YUV_DATA_SEQ_YVYU	= 1,
> +	CSI_YUV_DATA_SEQ_UYVY	= 2,
> +	CSI_YUV_DATA_SEQ_VYUY	= 3,
> +};
> +
> +struct sun4i_csi_format {
> +	u32			mbus;
> +	u32			fourcc;
> +	enum csi_input		input;
> +	u32			output;
> +	unsigned int		num_planes;
> +	u8			bpp[3];
> +	unsigned int		hsub;
> +	unsigned int		vsub;
> +};
> +
> +struct sun4i_csi {
> +	// Device resources
> +	struct device			*dev;
> +
> +	void __iomem			*regs;
> +	struct clk			*ahb_clk;
> +	struct clk			*isp_clk;
> +	struct clk			*mod_clk;
> +	struct clk			*ram_clk;
> +	struct reset_control		*rst;
> +	unsigned char			has_isp;
> +
> +	const struct sun4i_csi_format	*p_fmt;
> +	struct v4l2_pix_format_mplane	v_fmt;
> +
> +	struct vb2_v4l2_buffer		*current_buf[CSI_MAX_BUFFER];
> +
> +	struct media_device		mdev;
> +	struct media_pad		pad;
> +
> +	struct v4l2_fwnode_bus_parallel	bus;
> +
> +	// V4L2 Async variables
> +	struct v4l2_async_notifier	notifier;
> +	struct v4l2_subdev		*src_subdev;
> +	unsigned int			src_pad;
> +
> +	// V4L2 variables
> +	struct mutex			lock;
> +	struct v4l2_device		v4l;
> +	struct video_device		vdev;
> +
> +	// Videobuf2

Doesn't checkpatch.pl --strict complain about the use of '//'?

> +	struct vb2_queue		queue;
> +	struct list_head		buf_list;
> +	spinlock_t			qlock;
> +	unsigned int			sequence;
> +};
> +
> +int csi_dma_register(struct sun4i_csi *csi, int irq);
> +void csi_dma_unregister(struct sun4i_csi *csi);
> +
> +int csi_v4l2_register(struct sun4i_csi *csi);
> +
> +#endif /* _SUN4I_CSI_H_ */
> diff --git a/drivers/media/platform/sunxi/sun4i-csi/sun4i_dma.c b/drivers/media/platform/sunxi/sun4i-csi/sun4i_dma.c
> new file mode 100644
> index 000000000000..989b46968e87
> --- /dev/null
> +++ b/drivers/media/platform/sunxi/sun4i-csi/sun4i_dma.c
> @@ -0,0 +1,383 @@
> +// SPDX-License-Identifier: GPL-2.0-or-later
> +/*
> + * Copyright (C) 2016 NextThing Co
> + * Copyright (C) 2016-2018 Bootlin
> + *
> + * Author: Maxime Ripard <maxime.ripard@bootlin.com>
> + */
> +
> +#include <linux/device.h>
> +#include <linux/list.h>
> +#include <linux/mutex.h>
> +#include <linux/spinlock.h>
> +#include <media/videobuf2-dma-contig.h>
> +#include <media/videobuf2-v4l2.h>
> +
> +#include "sun4i_csi.h"
> +
> +struct csi_buffer {
> +	struct vb2_v4l2_buffer	vb;
> +	struct list_head	list;
> +};
> +
> +static inline struct csi_buffer *vb2_v4l2_to_csi_buffer(const struct vb2_v4l2_buffer *p)
> +{
> +	return container_of(p, struct csi_buffer, vb);
> +}
> +
> +static inline struct csi_buffer *vb2_to_csi_buffer(const struct vb2_buffer *p)
> +{
> +	return vb2_v4l2_to_csi_buffer(to_vb2_v4l2_buffer(p));
> +}
> +
> +static void csi_capture_start(struct sun4i_csi *csi)
> +{
> +	writel(CSI_CPT_CTRL_VIDEO_START, csi->regs + CSI_CPT_CTRL_REG);
> +}
> +
> +static void csi_capture_stop(struct sun4i_csi *csi)
> +{
> +	writel(0, csi->regs + CSI_CPT_CTRL_REG);
> +}
> +
> +static int csi_queue_setup(struct vb2_queue *vq,
> +			   unsigned int *nbuffers,
> +			   unsigned int *nplanes,
> +			   unsigned int sizes[],
> +			   struct device *alloc_devs[])
> +
> +{
> +	struct sun4i_csi *csi = vb2_get_drv_priv(vq);
> +	unsigned int i;
> +
> +	if (*nbuffers < 3)
> +		*nbuffers = 3;
> +
> +	*nplanes = csi->p_fmt->num_planes;
> +
> +	for (i = 0; i < *nplanes; i++)
> +		sizes[i] = csi->v_fmt.plane_fmt[i].sizeimage;

This function doesn't appear to support the VIDIOC_CREATEBUFS ioctl.
It is recommended to add support for that ioctl.

> +
> +	return 0;
> +};
> +
> +static int csi_buffer_prepare(struct vb2_buffer *vb)
> +{
> +	struct sun4i_csi *csi = vb2_get_drv_priv(vb->vb2_queue);
> +	unsigned int i;
> +
> +	for (i = 0; i < csi->p_fmt->num_planes; i++) {
> +		unsigned long size = csi->v_fmt.plane_fmt[i].sizeimage;
> +
> +		if (vb2_plane_size(vb, i) < size) {
> +			dev_err(csi->dev, "buffer too small (%lu < %lu)\n",
> +				vb2_plane_size(vb, i), size);
> +			return -EINVAL;
> +		}
> +
> +		vb2_set_plane_payload(vb, i, size);
> +	}
> +
> +	return 0;
> +}
> +
> +static int csi_buffer_fill_slot(struct sun4i_csi *csi, unsigned int slot)
> +{
> +	struct csi_buffer *c_buf;
> +	struct vb2_v4l2_buffer *v_buf;
> +	unsigned int plane;
> +
> +	/*
> +	 * We should never end up in a situation where we overwrite an
> +	 * already filled slot.
> +	 */
> +	if (WARN_ON(csi->current_buf[slot]))
> +		return -EINVAL;
> +
> +	if (list_empty(&csi->buf_list)) {
> +		csi->current_buf[slot] = NULL;
> +
> +		dev_warn(csi->dev, "Running out of buffers...\n");
> +		return -ENOMEM;
> +	}
> +
> +	c_buf = list_first_entry(&csi->buf_list, struct csi_buffer, list);
> +	list_del_init(&c_buf->list);
> +
> +	v_buf = &c_buf->vb;
> +	csi->current_buf[slot] = v_buf;
> +
> +	for (plane = 0; plane < csi->p_fmt->num_planes; plane++) {
> +		dma_addr_t buf_addr;
> +
> +		buf_addr = vb2_dma_contig_plane_dma_addr(&v_buf->vb2_buf,
> +							 plane);
> +		writel(buf_addr, csi->regs + CSI_BUF_ADDR_REG(plane, slot));
> +	}
> +
> +	return 0;
> +}
> +
> +static int csi_buffer_fill_all(struct sun4i_csi *csi)
> +{
> +	unsigned int slot;
> +	int ret;
> +
> +	for (slot = 0; slot < CSI_MAX_BUFFER; slot++) {
> +		ret = csi_buffer_fill_slot(csi, slot);
> +		if (ret)
> +			return ret;
> +	}
> +
> +	return 0;
> +}
> +
> +static void csi_buffer_mark_done(struct sun4i_csi *csi,
> +				 unsigned int slot,
> +				 unsigned int sequence)
> +{
> +	struct vb2_v4l2_buffer *v_buf;
> +
> +	if (WARN_ON(!csi->current_buf[slot]))
> +		return;
> +
> +	v_buf = csi->current_buf[slot];
> +	v_buf->field = csi->v_fmt.field;
> +	v_buf->sequence = sequence;
> +	v_buf->vb2_buf.timestamp = ktime_get_ns();
> +	vb2_buffer_done(&v_buf->vb2_buf, VB2_BUF_STATE_DONE);
> +
> +	csi->current_buf[slot] = NULL;
> +}
> +
> +static int csi_buffer_flip(struct sun4i_csi *csi, unsigned int sequence)
> +{
> +	u32 reg = readl(csi->regs + CSI_BUF_CTRL_REG);
> +	int curr, next;
> +
> +	/* Our next buffer is not the current buffer */
> +	curr = !!(reg & CSI_BUF_CTRL_DBS);
> +	next = !curr;
> +
> +	/* Report the previous buffer as done */
> +	csi_buffer_mark_done(csi, next, sequence);
> +
> +	/* Put a new buffer in there */
> +	return csi_buffer_fill_slot(csi, next);
> +}
> +
> +static void csi_buffer_queue(struct vb2_buffer *vb)
> +{
> +	struct sun4i_csi *csi = vb2_get_drv_priv(vb->vb2_queue);
> +	struct csi_buffer *buf = vb2_to_csi_buffer(vb);
> +	unsigned long flags;
> +
> +	spin_lock_irqsave(&csi->qlock, flags);
> +	list_add_tail(&buf->list, &csi->buf_list);
> +	spin_unlock_irqrestore(&csi->qlock, flags);
> +}
> +
> +static void return_all_buffers(struct sun4i_csi *csi,
> +			       enum vb2_buffer_state state)
> +{
> +	struct csi_buffer *buf, *node;
> +	unsigned int slot;
> +
> +	list_for_each_entry_safe(buf, node, &csi->buf_list, list) {
> +		vb2_buffer_done(&buf->vb.vb2_buf, state);
> +		list_del(&buf->list);
> +	}
> +
> +	for (slot = 0; slot < CSI_MAX_BUFFER; slot++) {
> +		struct vb2_v4l2_buffer *v_buf = csi->current_buf[slot];
> +
> +		if (!v_buf)
> +			continue;
> +
> +		vb2_buffer_done(&v_buf->vb2_buf, state);
> +		csi->current_buf[slot] = NULL;
> +	}
> +}
> +
> +static int csi_start_streaming(struct vb2_queue *vq, unsigned int count)
> +{
> +	struct sun4i_csi *csi = vb2_get_drv_priv(vq);
> +	struct v4l2_fwnode_bus_parallel *bus = &csi->bus;
> +	unsigned long hsync_pol, pclk_pol, vsync_pol;
> +	unsigned long flags;
> +	int ret = 0;
> +
> +	csi->sequence = 0;
> +
> +	if (count < 2)
> +		return -ENOBUFS;

Shouldn't be needed. Just fill in the min_buffers_needed field of struct vb2_queue.

> +
> +	ret = media_pipeline_start(&csi->vdev.entity, &csi->vdev.pipe);
> +	if (ret < 0)
> +		goto clear_dma_queue;
> +
> +	dev_dbg(csi->dev, "Starting capture\n");
> +
> +	spin_lock_irqsave(&csi->qlock, flags);
> +
> +	/* Setup timings */
> +	writel(CSI_WIN_CTRL_W_ACTIVE(csi->v_fmt.width * 2),
> +	       csi->regs + CSI_WIN_CTRL_W_REG);
> +	writel(CSI_WIN_CTRL_H_ACTIVE(csi->v_fmt.height),
> +	       csi->regs + CSI_WIN_CTRL_H_REG);
> +
> +	hsync_pol = !!(bus->flags & V4L2_MBUS_HSYNC_ACTIVE_HIGH);
> +	pclk_pol = !!(bus->flags & V4L2_MBUS_DATA_ACTIVE_HIGH);
> +	vsync_pol = !!(bus->flags & V4L2_MBUS_VSYNC_ACTIVE_HIGH);
> +	writel(CSI_CFG_INPUT_FMT(csi->p_fmt->input) |
> +	       CSI_CFG_OUTPUT_FMT(csi->p_fmt->output) |
> +	       CSI_CFG_VSYNC_POL(vsync_pol) |
> +	       CSI_CFG_HSYNC_POL(hsync_pol) |
> +	       CSI_CFG_PCLK_POL(pclk_pol),
> +	       csi->regs + CSI_CFG_REG);
> +
> +	/* Setup buffer length */
> +	writel(csi->v_fmt.plane_fmt[0].bytesperline,
> +	       csi->regs + CSI_BUF_LEN_REG);
> +
> +	/* Prepare our buffers in hardware */
> +	ret = csi_buffer_fill_all(csi);
> +	if (ret) {
> +		spin_unlock_irqrestore(&csi->qlock, flags);
> +		goto disable_pipeline;
> +	}
> +
> +	/* Enable double buffering */
> +	writel(CSI_BUF_CTRL_DBE, csi->regs + CSI_BUF_CTRL_REG);
> +
> +	/* Clear the pending interrupts */
> +	writel(CSI_INT_FRM_DONE, csi->regs + 0x34);
> +
> +	/* Enable frame done interrupt */
> +	writel(CSI_INT_FRM_DONE, csi->regs + CSI_INT_EN_REG);
> +
> +	csi_capture_start(csi);
> +
> +	spin_unlock_irqrestore(&csi->qlock, flags);
> +
> +	ret = v4l2_subdev_call(csi->src_subdev, video, s_stream, 1);
> +	if (ret < 0 && ret != -ENOIOCTLCMD)
> +		goto disable_pipeline;
> +
> +	return 0;
> +
> +disable_pipeline:
> +	media_pipeline_stop(&csi->vdev.entity);
> +
> +clear_dma_queue:
> +	return_all_buffers(csi, VB2_BUF_STATE_QUEUED);
> +
> +	return ret;
> +}
> +
> +static void csi_stop_streaming(struct vb2_queue *vq)
> +{
> +	struct sun4i_csi *csi = vb2_get_drv_priv(vq);
> +	unsigned long flags;
> +
> +	dev_dbg(csi->dev, "Stopping capture\n");
> +
> +	v4l2_subdev_call(csi->src_subdev, video, s_stream, 0);
> +	csi_capture_stop(csi);
> +
> +	/* Release all active buffers */
> +	spin_lock_irqsave(&csi->qlock, flags);
> +	return_all_buffers(csi, VB2_BUF_STATE_ERROR);
> +	spin_unlock_irqrestore(&csi->qlock, flags);
> +
> +	media_pipeline_stop(&csi->vdev.entity);
> +}
> +
> +static struct vb2_ops csi_qops = {
> +	.queue_setup		= csi_queue_setup,
> +	.buf_prepare		= csi_buffer_prepare,
> +	.buf_queue		= csi_buffer_queue,
> +	.start_streaming	= csi_start_streaming,
> +	.stop_streaming		= csi_stop_streaming,
> +	.wait_prepare		= vb2_ops_wait_prepare,
> +	.wait_finish		= vb2_ops_wait_finish,
> +};
> +
> +static irqreturn_t csi_irq(int irq, void *data)
> +{
> +	struct sun4i_csi *csi = data;
> +	unsigned int sequence;
> +	u32 reg;
> +
> +	reg = readl(csi->regs + CSI_INT_STA_REG);
> +
> +	/* Acknowledge the interrupts */
> +	writel(reg, csi->regs + CSI_INT_STA_REG);
> +
> +	sequence = csi->sequence++;
> +
> +	if (!(reg & CSI_INT_FRM_DONE))
> +		goto out;
> +
> +	spin_lock(&csi->qlock);
> +	if (csi_buffer_flip(csi, sequence)) {
> +		dev_warn(csi->dev, "%s: Flip failed\n", __func__);
> +		csi_capture_stop(csi);
> +	}
> +	spin_unlock(&csi->qlock);
> +
> +out:
> +	return IRQ_HANDLED;
> +}
> +
> +int csi_dma_register(struct sun4i_csi *csi, int irq)
> +{
> +	struct vb2_queue *q = &csi->queue;
> +	int ret;
> +	int i;
> +
> +	ret = v4l2_device_register(csi->dev, &csi->v4l);
> +	if (ret) {
> +		dev_err(csi->dev, "Couldn't register the v4l2 device\n");
> +		return ret;
> +	}
> +
> +	spin_lock_init(&csi->qlock);
> +	mutex_init(&csi->lock);
> +
> +	INIT_LIST_HEAD(&csi->buf_list);
> +	for (i = 0; i < CSI_MAX_BUFFER; i++)
> +		csi->current_buf[i] = NULL;
> +
> +	q->type = V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE;
> +	q->io_modes = VB2_MMAP;
> +	q->lock = &csi->lock;
> +	q->drv_priv = csi;
> +	q->buf_struct_size = sizeof(struct csi_buffer);
> +	q->ops = &csi_qops;
> +	q->mem_ops = &vb2_dma_contig_memops;
> +	q->timestamp_flags = V4L2_BUF_FLAG_TIMESTAMP_MONOTONIC;
> +	q->gfp_flags = GFP_DMA32;

This is only needed for 64 bit architectures that require 32 bit DMA.
Since this is a 32 bit architecture, you don't need to set this field.

> +	q->dev = csi->dev;
> +
> +	ret = vb2_queue_init(q);
> +	if (ret < 0) {
> +		dev_err(csi->dev, "failed to initialize VB2 queue\n");
> +		return ret;
> +	}
> +
> +	ret = devm_request_irq(csi->dev, irq, csi_irq, 0,
> +			       dev_name(csi->dev), csi);
> +	if (ret) {
> +		dev_err(csi->dev, "Couldn't register our interrupt\n");
> +		return ret;
> +	}
> +
> +	return 0;
> +}
> +
> +void csi_dma_unregister(struct sun4i_csi *csi)
> +{
> +	v4l2_device_unregister(&csi->v4l);
> +}
> +
> diff --git a/drivers/media/platform/sunxi/sun4i-csi/sun4i_v4l2.c b/drivers/media/platform/sunxi/sun4i-csi/sun4i_v4l2.c
> new file mode 100644
> index 000000000000..0b9487830e6d
> --- /dev/null
> +++ b/drivers/media/platform/sunxi/sun4i-csi/sun4i_v4l2.c
> @@ -0,0 +1,287 @@
> +// SPDX-License-Identifier: GPL-2.0-or-later
> +/*
> + * Copyright (C) 2016 NextThing Co
> + * Copyright (C) 2016-2018 Bootlin
> + *
> + * Author: Maxime Ripard <maxime.ripard@bootlin.com>
> + */
> +
> +#include <linux/device.h>
> +#include <linux/pm_runtime.h>
> +
> +#include <media/v4l2-ioctl.h>
> +#include <media/videobuf2-v4l2.h>
> +
> +#include "sun4i_csi.h"
> +
> +#define CSI_DEFAULT_FORMAT	V4L2_PIX_FMT_YUV420M
> +#define CSI_DEFAULT_WIDTH	640
> +#define CSI_DEFAULT_HEIGHT	480
> +
> +#define CSI_MAX_HEIGHT		8192U
> +#define CSI_MAX_WIDTH		8192U
> +
> +static const struct sun4i_csi_format csi_formats[] = {
> +	/* YUV422 inputs */
> +	{
> +		.mbus		= MEDIA_BUS_FMT_YUYV8_2X8,
> +		.fourcc		= V4L2_PIX_FMT_YUV420M,
> +		.input		= CSI_INPUT_YUV,
> +		.output		= CSI_OUTPUT_YUV_420_PLANAR,
> +		.num_planes	= 3,
> +		.bpp		= { 8, 8, 8 },
> +		.hsub		= 2,
> +		.vsub		= 2,
> +	},
> +};
> +
> +static const struct sun4i_csi_format *
> +csi_get_format_by_fourcc(struct sun4i_csi *csi, u32 fourcc)
> +{
> +	unsigned int i;
> +
> +	for (i = 0; i < ARRAY_SIZE(csi_formats); i++)
> +		if (csi_formats[i].fourcc == fourcc)
> +			return &csi_formats[i];
> +
> +	return NULL;
> +}
> +
> +static int csi_querycap(struct file *file, void *priv,
> +			struct v4l2_capability *cap)
> +{
> +	struct sun4i_csi *csi = video_drvdata(file);
> +
> +	strscpy(cap->driver, KBUILD_MODNAME, sizeof(cap->driver));
> +	strscpy(cap->card, "sun4i-csi", sizeof(cap->card));
> +	snprintf(cap->bus_info, sizeof(cap->bus_info), "platform:%s",
> +		 dev_name(csi->dev));
> +	cap->device_caps = V4L2_CAP_VIDEO_CAPTURE_MPLANE | V4L2_CAP_STREAMING;
> +	cap->capabilities = cap->device_caps | V4L2_CAP_DEVICE_CAPS;

Don't set device_caps/capabilities here. Instead, fill in device_caps in
struct video_device and the core will fill in these fields for you.

> +
> +	return 0;
> +}
> +
> +static int csi_enum_input(struct file *file, void *priv,
> +			  struct v4l2_input *inp)
> +{
> +	if (inp->index != 0)
> +		return -EINVAL;
> +
> +	inp->type = V4L2_INPUT_TYPE_CAMERA;
> +	strlcpy(inp->name, "Camera", sizeof(inp->name));

strscpy.

Please do a search and replace.

> +
> +	return 0;
> +}
> +
> +static int csi_g_input(struct file *file, void *fh,
> +		       unsigned int *i)
> +{
> +	*i = 0;
> +
> +	return 0;
> +}
> +
> +static int csi_s_input(struct file *file, void *fh,
> +		       unsigned int i)
> +{
> +	if (i != 0)
> +		return -EINVAL;
> +
> +	return 0;
> +}
> +
> +static int _csi_try_fmt(struct sun4i_csi *csi,
> +			struct v4l2_pix_format_mplane *pix,
> +			const struct sun4i_csi_format **fmt)
> +{
> +	const struct sun4i_csi_format *_fmt;
> +	unsigned int width = pix->width;
> +	unsigned int height = pix->height;
> +	int i;
> +
> +	_fmt = csi_get_format_by_fourcc(csi, pix->pixelformat);
> +	if (!_fmt)
> +		_fmt = csi_get_format_by_fourcc(csi, csi_formats[0].fourcc);
> +
> +	pix->field = V4L2_FIELD_NONE;
> +	pix->colorspace = V4L2_COLORSPACE_SRGB;
> +	pix->xfer_func = V4L2_MAP_XFER_FUNC_DEFAULT(pix->colorspace);
> +	pix->ycbcr_enc = V4L2_MAP_YCBCR_ENC_DEFAULT(pix->colorspace);
> +	pix->quantization = V4L2_MAP_QUANTIZATION_DEFAULT(true, pix->colorspace,
> +							  pix->ycbcr_enc);
> +
> +	pix->num_planes = _fmt->num_planes;
> +	pix->pixelformat = _fmt->fourcc;
> +
> +	memset(pix->reserved, 0, sizeof(pix->reserved));
> +
> +	/* Align the width and height on the subsampling */
> +	width = ALIGN(width, _fmt->hsub);
> +	height = ALIGN(height, _fmt->vsub);
> +
> +	/* Clamp the width and height to our capabilities */
> +	pix->width = clamp(width, _fmt->hsub, CSI_MAX_WIDTH);
> +	pix->height = clamp(height, _fmt->vsub, CSI_MAX_HEIGHT);
> +
> +	for (i = 0; i < _fmt->num_planes; i++) {
> +		unsigned int hsub = i > 0 ? _fmt->hsub : 1;
> +		unsigned int vsub = i > 0 ? _fmt->vsub : 1;
> +		unsigned int bpl;
> +
> +		bpl = pix->width / hsub * _fmt->bpp[i] / 8;
> +		pix->plane_fmt[i].bytesperline = bpl;
> +		pix->plane_fmt[i].sizeimage = bpl * pix->height / vsub;
> +		memset(pix->plane_fmt[i].reserved, 0,
> +		       sizeof(pix->plane_fmt[i].reserved));
> +	}
> +
> +	if (fmt)
> +		*fmt = _fmt;
> +
> +	return 0;
> +}
> +
> +static int csi_try_fmt_vid_cap(struct file *file, void *priv,
> +			       struct v4l2_format *f)
> +{
> +	struct sun4i_csi *csi = video_drvdata(file);
> +
> +	if (f->type != V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE)
> +		return -EINVAL;

No need for this check.

> +
> +	return _csi_try_fmt(csi, &f->fmt.pix_mp, NULL);
> +}
> +
> +static int csi_s_fmt_vid_cap(struct file *file, void *priv,
> +			     struct v4l2_format *f)
> +{
> +	const struct sun4i_csi_format *fmt;
> +	struct sun4i_csi *csi = video_drvdata(file);
> +	int ret;
> +
> +	if (f->type != V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE)
> +		return -EINVAL;

No need for this check.

> +
> +	ret = _csi_try_fmt(csi, &f->fmt.pix_mp, &fmt);
> +	if (ret)
> +		return ret;
> +
> +	csi->v_fmt = f->fmt.pix_mp;
> +	csi->p_fmt = fmt;
> +
> +	return 0;
> +}
> +
> +static int csi_g_fmt_vid_cap(struct file *file, void *priv,
> +			     struct v4l2_format *f)
> +{
> +	struct sun4i_csi *csi = video_drvdata(file);
> +
> +	if (f->type != V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE)
> +		return -EINVAL;

Drop check.

> +
> +	f->fmt.pix_mp = csi->v_fmt;
> +
> +	return 0;
> +}
> +
> +static int csi_enum_fmt_vid_cap(struct file *file, void *priv,
> +				struct v4l2_fmtdesc *f)
> +{
> +	if (f->index >= ARRAY_SIZE(csi_formats))
> +		return -EINVAL;
> +
> +	f->pixelformat = csi_formats[f->index].fourcc;
> +
> +	return 0;
> +}
> +
> +static const struct v4l2_ioctl_ops csi_ioctl_ops = {
> +	.vidioc_querycap	= csi_querycap,
> +
> +	.vidioc_enum_fmt_vid_cap_mplane	= csi_enum_fmt_vid_cap,
> +	.vidioc_g_fmt_vid_cap_mplane	= csi_g_fmt_vid_cap,
> +	.vidioc_s_fmt_vid_cap_mplane	= csi_s_fmt_vid_cap,
> +	.vidioc_try_fmt_vid_cap_mplane	= csi_try_fmt_vid_cap,
> +
> +	.vidioc_enum_input	= csi_enum_input,
> +	.vidioc_g_input		= csi_g_input,
> +	.vidioc_s_input		= csi_s_input,
> +
> +	.vidioc_reqbufs		= vb2_ioctl_reqbufs,
> +	.vidioc_create_bufs	= vb2_ioctl_create_bufs,

Ah, create_bufs is supported here, but in that case queue_setup
is wrong. Look at other drivers on how to do this.

> +	.vidioc_querybuf	= vb2_ioctl_querybuf,
> +	.vidioc_qbuf		= vb2_ioctl_qbuf,
> +	.vidioc_dqbuf		= vb2_ioctl_dqbuf,
> +	.vidioc_expbuf		= vb2_ioctl_expbuf,
> +	.vidioc_prepare_buf	= vb2_ioctl_prepare_buf,
> +	.vidioc_streamon	= vb2_ioctl_streamon,
> +	.vidioc_streamoff	= vb2_ioctl_streamoff,
> +};
> +
> +static int csi_open(struct file *file)
> +{
> +	struct sun4i_csi *csi = video_drvdata(file);
> +	int ret;
> +
> +	pm_runtime_get_sync(csi->dev);
> +
> +	ret = v4l2_subdev_call(csi->src_subdev, core, s_power, 1);
> +	if (ret < 0 && ret != -ENOIOCTLCMD)
> +		return ret;
> +
> +	return v4l2_fh_open(file);
> +}
> +
> +static int csi_release(struct file *file)
> +{
> +	struct sun4i_csi *csi = video_drvdata(file);
> +
> +	pm_runtime_put(csi->dev);

No call to v4l2_subdev_call(csi->src_subdev, core, s_power, 0); needed here if
the last fh is closed?

> +
> +	return vb2_fop_release(file);
> +}
> +
> +static const struct v4l2_file_operations csi_fops = {
> +	.owner		= THIS_MODULE,
> +	.open		= csi_open,
> +	.release	= csi_release,
> +	.unlocked_ioctl	= video_ioctl2,
> +	.read		= vb2_fop_read,
> +	.write		= vb2_fop_write,
> +	.poll		= vb2_fop_poll,
> +	.mmap		= vb2_fop_mmap,
> +};
> +
> +int csi_v4l2_register(struct sun4i_csi *csi)
> +{
> +	struct video_device *vdev = &csi->vdev;
> +	int ret;
> +
> +	vdev->v4l2_dev = &csi->v4l;
> +	vdev->queue = &csi->queue;
> +	strlcpy(vdev->name, KBUILD_MODNAME, sizeof(vdev->name));
> +	vdev->release = video_device_release_empty;
> +	vdev->lock = &csi->lock;
> +
> +	/* Set a default format */
> +	csi->v_fmt.pixelformat = CSI_DEFAULT_FORMAT;
> +	csi->v_fmt.width = CSI_DEFAULT_WIDTH;
> +	csi->v_fmt.height = CSI_DEFAULT_HEIGHT;
> +	_csi_try_fmt(csi, &csi->v_fmt, NULL);
> +
> +	vdev->fops = &csi_fops;
> +	vdev->ioctl_ops = &csi_ioctl_ops;
> +	video_set_drvdata(vdev, csi);
> +
> +	ret = video_register_device(&csi->vdev, VFL_TYPE_GRABBER, -1);
> +	if (ret)
> +		return ret;
> +
> +	dev_info(csi->dev, "Device registered as %s\n",
> +		 video_device_node_name(vdev));
> +
> +	return 0;
> +}
> +
> 

Regards,

	Hans
