Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailgw02.mediatek.com ([210.61.82.184]:5158 "EHLO
	mailgw02.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751378AbcGVFgC (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 22 Jul 2016 01:36:02 -0400
Message-ID: <1469165747.18138.6.camel@mtksdaap41>
Subject: Re: [PATCH 3/4] media: Add Mediatek MDP Driver
From: Minghsiu Tsai <minghsiu.tsai@mediatek.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
CC: Hans Verkuil <hans.verkuil@cisco.com>,
	<daniel.thompson@linaro.org>, "Rob Herring" <robh+dt@kernel.org>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Matthias Brugger <matthias.bgg@gmail.com>,
	Daniel Kurtz <djkurtz@chromium.org>,
	Pawel Osciak <posciak@chromium.org>,
	<srv_heupstream@mediatek.com>,
	Eddie Huang <eddie.huang@mediatek.com>,
	Yingjoe Chen <yingjoe.chen@mediatek.com>,
	<devicetree@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<linux-arm-kernel@lists.infradead.org>,
	<linux-media@vger.kernel.org>, <linux-mediatek@lists.infradead.org>
Date: Fri, 22 Jul 2016 13:35:47 +0800
In-Reply-To: <41900916-26c8-014a-6a7f-de3c34a2592f@xs4all.nl>
References: <1468498681-19955-1-git-send-email-minghsiu.tsai@mediatek.com>
	 <1468498681-19955-4-git-send-email-minghsiu.tsai@mediatek.com>
	 <41900916-26c8-014a-6a7f-de3c34a2592f@xs4all.nl>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, 2016-07-18 at 14:18 +0200, Hans Verkuil wrote:
> On 07/14/2016 02:18 PM, Minghsiu Tsai wrote:
> > Add MDP driver for MT8173
> > 
> > Signed-off-by: Minghsiu Tsai <minghsiu.tsai@mediatek.com>
> > ---
> >  drivers/media/platform/Kconfig                |   16 +
> >  drivers/media/platform/Makefile               |    2 +
> >  drivers/media/platform/mtk-mdp/Makefile       |    9 +
> >  drivers/media/platform/mtk-mdp/mtk_mdp_comp.c |  159 +++
> >  drivers/media/platform/mtk-mdp/mtk_mdp_comp.h |   72 ++
> >  drivers/media/platform/mtk-mdp/mtk_mdp_core.c |  294 ++++++
> >  drivers/media/platform/mtk-mdp/mtk_mdp_core.h |  233 +++++
> >  drivers/media/platform/mtk-mdp/mtk_mdp_ipi.h  |  126 +++
> >  drivers/media/platform/mtk-mdp/mtk_mdp_m2m.c  | 1304 +++++++++++++++++++++++++
> >  drivers/media/platform/mtk-mdp/mtk_mdp_m2m.h  |   22 +
> >  drivers/media/platform/mtk-mdp/mtk_mdp_regs.c |  153 +++
> >  drivers/media/platform/mtk-mdp/mtk_mdp_regs.h |   31 +
> >  drivers/media/platform/mtk-mdp/mtk_mdp_vpu.c  |  140 +++
> >  drivers/media/platform/mtk-mdp/mtk_mdp_vpu.h  |   41 +
> >  14 files changed, 2602 insertions(+)
> >  create mode 100644 drivers/media/platform/mtk-mdp/Makefile
> >  create mode 100644 drivers/media/platform/mtk-mdp/mtk_mdp_comp.c
> >  create mode 100644 drivers/media/platform/mtk-mdp/mtk_mdp_comp.h
> >  create mode 100644 drivers/media/platform/mtk-mdp/mtk_mdp_core.c
> >  create mode 100644 drivers/media/platform/mtk-mdp/mtk_mdp_core.h
> >  create mode 100644 drivers/media/platform/mtk-mdp/mtk_mdp_ipi.h
> >  create mode 100644 drivers/media/platform/mtk-mdp/mtk_mdp_m2m.c
> >  create mode 100644 drivers/media/platform/mtk-mdp/mtk_mdp_m2m.h
> >  create mode 100644 drivers/media/platform/mtk-mdp/mtk_mdp_regs.c
> >  create mode 100644 drivers/media/platform/mtk-mdp/mtk_mdp_regs.h
> >  create mode 100644 drivers/media/platform/mtk-mdp/mtk_mdp_vpu.c
> >  create mode 100644 drivers/media/platform/mtk-mdp/mtk_mdp_vpu.h
> > 
> > diff --git a/drivers/media/platform/Kconfig b/drivers/media/platform/Kconfig
> > index 2c2670c..782b618 100644
> > --- a/drivers/media/platform/Kconfig
> > +++ b/drivers/media/platform/Kconfig
> > @@ -166,6 +166,22 @@ config VIDEO_MEDIATEK_VPU
> >  	    To compile this driver as a module, choose M here: the
> >  	    module will be called mtk-vpu.
> >  
> > +config VIDEO_MEDIATEK_MDP
> > +	tristate "Mediatek MDP driver"
> > +	depends on MTK_IOMMU || COMPILE_TEST
> > +	depends on VIDEO_DEV && VIDEO_V4L2
> > +	depends on ARCH_MEDIATEK || COMPILE_TEST
> > +	select VIDEOBUF2_DMA_CONTIG
> > +	select V4L2_MEM2MEM_DEV
> > +	select VIDEO_MEDIATEK_VPU
> > +	default n
> > +	---help---
> > +	    It is a v4l2 driver and present in Mediatek MT8173 SoCs.
> > +	    The driver supports for scaling and color space conversion.
> > +
> > +	    To compile this driver as a module, choose M here: the
> > +	    module will be called mtk-mdp.
> > +
> >  config VIDEO_MEDIATEK_VCODEC
> >  	tristate "Mediatek Video Codec driver"
> >  	depends on MTK_IOMMU || COMPILE_TEST
> > diff --git a/drivers/media/platform/Makefile b/drivers/media/platform/Makefile
> > index c6b3b92..9c54f1a 100644
> > --- a/drivers/media/platform/Makefile
> > +++ b/drivers/media/platform/Makefile
> > @@ -62,3 +62,5 @@ ccflags-y += -I$(srctree)/drivers/media/i2c
> >  obj-$(CONFIG_VIDEO_MEDIATEK_VPU)	+= mtk-vpu/
> >  
> >  obj-$(CONFIG_VIDEO_MEDIATEK_VCODEC)	+= mtk-vcodec/
> > +
> > +obj-$(CONFIG_VIDEO_MEDIATEK_MDP)	+= mtk-mdp/
> > diff --git a/drivers/media/platform/mtk-mdp/Makefile b/drivers/media/platform/mtk-mdp/Makefile
> > new file mode 100644
> > index 0000000..f802569
> > --- /dev/null
> > +++ b/drivers/media/platform/mtk-mdp/Makefile
> > @@ -0,0 +1,9 @@
> > +mtk-mdp-y += mtk_mdp_core.o
> > +mtk-mdp-y += mtk_mdp_comp.o
> > +mtk-mdp-y += mtk_mdp_m2m.o
> > +mtk-mdp-y += mtk_mdp_regs.o
> > +mtk-mdp-y += mtk_mdp_vpu.o
> > +
> > +obj-$(CONFIG_VIDEO_MEDIATEK_MDP) += mtk-mdp.o
> > +
> > +ccflags-y += -I$(srctree)/drivers/media/platform/mtk-vpu
> > diff --git a/drivers/media/platform/mtk-mdp/mtk_mdp_comp.c b/drivers/media/platform/mtk-mdp/mtk_mdp_comp.c
> > new file mode 100644
> > index 0000000..aa8f9fd
> > --- /dev/null
> > +++ b/drivers/media/platform/mtk-mdp/mtk_mdp_comp.c
> > @@ -0,0 +1,159 @@
> > +/*
> > + * Copyright (c) 2016 MediaTek Inc.
> > + * Author: Ming Hsiu Tsai <minghsiu.tsai@mediatek.com>
> > + *
> > + * This program is free software; you can redistribute it and/or modify
> > + * it under the terms of the GNU General Public License version 2 as
> > + * published by the Free Software Foundation.
> > + *
> > + * This program is distributed in the hope that it will be useful,
> > + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> > + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> > + * GNU General Public License for more details.
> > + */
> > +
> > +#include <linux/clk.h>
> > +#include <linux/device.h>
> > +#include <linux/of.h>
> > +#include <linux/of_address.h>
> > +#include <linux/of_platform.h>
> > +#include <soc/mediatek/smi.h>
> > +
> > +#include "mtk_mdp_comp.h"
> > +
> > +
> > +static const char * const mtk_mdp_comp_stem[MTK_MDP_COMP_TYPE_MAX] = {
> > +	"mdp_rdma",
> > +	"mdp_rsz",
> > +	"mdp_wdma",
> > +	"mdp_wrot",
> > +};
> > +
> > +struct mtk_mdp_comp_match {
> > +	enum mtk_mdp_comp_type type;
> > +	int alias_id;
> > +};
> > +
> > +static const struct mtk_mdp_comp_match mtk_mdp_matches[MTK_MDP_COMP_ID_MAX] = {
> > +	{ MTK_MDP_RDMA,	0 },
> > +	{ MTK_MDP_RDMA,	1 },
> > +	{ MTK_MDP_RSZ,	0 },
> > +	{ MTK_MDP_RSZ,	1 },
> > +	{ MTK_MDP_RSZ,	2 },
> > +	{ MTK_MDP_WDMA,	0 },
> > +	{ MTK_MDP_WROT,	0 },
> > +	{ MTK_MDP_WROT,	1 },
> > +};
> > +
> > +int mtk_mdp_comp_get_id(struct device *dev, struct device_node *node,
> > +			enum mtk_mdp_comp_type comp_type)
> > +{
> > +	int id = of_alias_get_id(node, mtk_mdp_comp_stem[comp_type]);
> > +	int i;
> > +
> > +	for (i = 0; i < ARRAY_SIZE(mtk_mdp_matches); i++) {
> > +		if (comp_type == mtk_mdp_matches[i].type &&
> > +		    id == mtk_mdp_matches[i].alias_id)
> > +			return i;
> > +	}
> > +
> > +	dev_err(dev, "Failed to get id. type: %d, id: %d\n", comp_type, id);
> > +
> > +	return -EINVAL;
> > +}
> > +
> > +void mtk_mdp_comp_clock_on(struct device *dev, struct mtk_mdp_comp *comp)
> > +{
> > +	int i, err;
> > +
> > +	if (comp->larb_dev) {
> > +		err = mtk_smi_larb_get(comp->larb_dev);
> > +		if (err)
> > +			dev_err(dev,
> > +				"failed to get larb, err %d. type:%d id:%d\n",
> > +				err, comp->type, comp->id);
> > +	}
> > +
> > +	for (i = 0; i < ARRAY_SIZE(comp->clk); i++) {
> > +		if (!comp->clk[i])
> > +			continue;
> > +		err = clk_prepare_enable(comp->clk[i]);
> > +		if (err)
> > +			dev_err(dev,
> > +			"failed to enable clock, err %d. type:%d id:%d i:%d\n",
> > +				err, comp->type, comp->id, i);
> > +	}
> > +}
> > +
> > +void mtk_mdp_comp_clock_off(struct device *dev, struct mtk_mdp_comp *comp)
> > +{
> > +	int i;
> > +
> > +	for (i = 0; i < ARRAY_SIZE(comp->clk); i++) {
> > +		if (!comp->clk[i])
> > +			continue;
> > +		clk_disable_unprepare(comp->clk[i]);
> > +	}
> > +
> > +	if (comp->larb_dev)
> > +		mtk_smi_larb_put(comp->larb_dev);
> > +}
> > +
> > +int mtk_mdp_comp_init(struct device *dev, struct device_node *node,
> > +		      struct mtk_mdp_comp *comp, enum mtk_mdp_comp_id comp_id)
> > +{
> > +	struct device_node *larb_node;
> > +	struct platform_device *larb_pdev;
> > +	int i;
> > +
> > +	if (comp_id < 0 || comp_id >= MTK_MDP_COMP_ID_MAX) {
> > +		dev_err(dev, "Invalid comp_id %d\n", comp_id);
> > +		return -EINVAL;
> > +	}
> > +
> > +	comp->dev_node = of_node_get(node);
> > +	comp->id = comp_id;
> > +	comp->type = mtk_mdp_matches[comp_id].type;
> > +	comp->regs = of_iomap(node, 0);
> > +
> > +	for (i = 0; i < ARRAY_SIZE(comp->clk); i++) {
> > +		comp->clk[i] = of_clk_get(node, i);
> > +
> > +		/* Only RDMA needs two clocks */
> > +		if (comp->type != MTK_MDP_RDMA)
> > +			break;
> > +	}
> > +
> > +	/* Only DMA capable components need the LARB property */
> > +	comp->larb_dev = NULL;
> > +	if (comp->type != MTK_MDP_RDMA &&
> > +	    comp->type != MTK_MDP_WDMA &&
> > +	    comp->type != MTK_MDP_WROT)
> > +		return 0;
> > +
> > +	larb_node = of_parse_phandle(node, "mediatek,larb", 0);
> > +	if (!larb_node) {
> > +		dev_err(dev,
> > +			"Missing mediadek,larb phandle in %s node\n",
> > +			node->full_name);
> > +		return -EINVAL;
> > +	}
> > +
> > +	larb_pdev = of_find_device_by_node(larb_node);
> > +	if (!larb_pdev) {
> > +		dev_warn(dev, "Waiting for larb device %s\n",
> > +			 larb_node->full_name);
> > +		of_node_put(larb_node);
> > +		return -EPROBE_DEFER;
> > +	}
> > +	of_node_put(larb_node);
> > +
> > +	comp->larb_dev = &larb_pdev->dev;
> > +
> > +	return 0;
> > +}
> > +
> > +void mtk_mdp_comp_deinit(struct device *dev, struct mtk_mdp_comp *comp)
> > +{
> > +	of_node_put(comp->dev_node);
> > +}
> > diff --git a/drivers/media/platform/mtk-mdp/mtk_mdp_comp.h b/drivers/media/platform/mtk-mdp/mtk_mdp_comp.h
> > new file mode 100644
> > index 0000000..63b3983
> > --- /dev/null
> > +++ b/drivers/media/platform/mtk-mdp/mtk_mdp_comp.h
> > @@ -0,0 +1,72 @@
> > +/*
> > + * Copyright (c) 2016 MediaTek Inc.
> > + * Author: Ming Hsiu Tsai <minghsiu.tsai@mediatek.com>
> > + *
> > + * This program is free software; you can redistribute it and/or modify
> > + * it under the terms of the GNU General Public License version 2 as
> > + * published by the Free Software Foundation.
> > + *
> > + * This program is distributed in the hope that it will be useful,
> > + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> > + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> > + * GNU General Public License for more details.
> > + */
> > +
> > +#ifndef __MTK_MDP_COMP_H__
> > +#define __MTK_MDP_COMP_H__
> > +
> > +/**
> > + * enum mtk_mdp_comp_type - the MDP component
> > + * @MTK_MDP_RDMA:	Read DMA
> > + * @MTK_MDP_RSZ:	Riszer
> > + * @MTK_MDP_WDMA:	Write DMA
> > + * @MTK_MDP_WROT:	Write DMA with rotation
> > + */
> > +enum mtk_mdp_comp_type {
> > +	MTK_MDP_RDMA,
> > +	MTK_MDP_RSZ,
> > +	MTK_MDP_WDMA,
> > +	MTK_MDP_WROT,
> > +	MTK_MDP_COMP_TYPE_MAX,
> > +};
> > +
> > +enum mtk_mdp_comp_id {
> > +	MTK_MDP_COMP_RDMA0,
> > +	MTK_MDP_COMP_RDMA1,
> > +	MTK_MDP_COMP_RSZ0,
> > +	MTK_MDP_COMP_RSZ1,
> > +	MTK_MDP_COMP_RSZ2,
> > +	MTK_MDP_COMP_WDMA,
> > +	MTK_MDP_COMP_WROT0,
> > +	MTK_MDP_COMP_WROT1,
> > +	MTK_MDP_COMP_ID_MAX,
> > +};
> > +
> > +/**
> > + * struct mtk_mdp_comp - the MDP's function component data
> > + * @dev_node:	component device node
> > + * @clk:	clocks required for component
> > + * @regs:	Mapped address of component registers.
> > + * @larb_dev:	SMI device required for component
> > + * @type:	component type
> > + * @id:		component ID
> > + */
> > +struct mtk_mdp_comp {
> > +	struct device_node	*dev_node;
> > +	struct clk		*clk[2];
> > +	void __iomem		*regs;
> > +	struct device		*larb_dev;
> > +	enum mtk_mdp_comp_type	type;
> > +	enum mtk_mdp_comp_id	id;
> > +};
> > +
> > +int mtk_mdp_comp_init(struct device *dev, struct device_node *node,
> > +		      struct mtk_mdp_comp *comp, enum mtk_mdp_comp_id comp_id);
> > +void mtk_mdp_comp_deinit(struct device *dev, struct mtk_mdp_comp *comp);
> > +int mtk_mdp_comp_get_id(struct device *dev, struct device_node *node,
> > +			enum mtk_mdp_comp_type comp_type);
> > +void mtk_mdp_comp_clock_on(struct device *dev, struct mtk_mdp_comp *comp);
> > +void mtk_mdp_comp_clock_off(struct device *dev, struct mtk_mdp_comp *comp);
> > +
> > +
> > +#endif /* __MTK_MDP_COMP_H__ */
> > diff --git a/drivers/media/platform/mtk-mdp/mtk_mdp_core.c b/drivers/media/platform/mtk-mdp/mtk_mdp_core.c
> > new file mode 100644
> > index 0000000..8a81dd9
> > --- /dev/null
> > +++ b/drivers/media/platform/mtk-mdp/mtk_mdp_core.c
> > @@ -0,0 +1,294 @@
> > +/*
> > + * Copyright (c) 2015-2016 MediaTek Inc.
> > + * Author: Houlong Wei <houlong.wei@mediatek.com>
> > + *         Ming Hsiu Tsai <minghsiu.tsai@mediatek.com>
> > + *
> > + * This program is free software; you can redistribute it and/or modify
> > + * it under the terms of the GNU General Public License version 2 as
> > + * published by the Free Software Foundation.
> > + *
> > + * This program is distributed in the hope that it will be useful,
> > + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> > + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> > + * GNU General Public License for more details.
> > + */
> > +
> > +#include <linux/clk.h>
> > +#include <linux/device.h>
> > +#include <linux/errno.h>
> > +#include <linux/interrupt.h>
> > +#include <linux/kernel.h>
> > +#include <linux/module.h>
> > +#include <linux/of.h>
> > +#include <linux/of_address.h>
> > +#include <linux/of_platform.h>
> > +#include <linux/platform_device.h>
> > +#include <linux/pm_runtime.h>
> > +#include <linux/workqueue.h>
> > +#include <soc/mediatek/smi.h>
> > +
> > +#include "mtk_mdp_core.h"
> > +#include "mtk_mdp_m2m.h"
> > +#include "mtk_vpu.h"
> > +
> > +/* MDP debug log level (0-3). 3 shows all the logs. */
> > +int mtk_mdp_dbg_level;
> > +EXPORT_SYMBOL(mtk_mdp_dbg_level);
> > +
> > +module_param(mtk_mdp_dbg_level, int, S_IRUGO | S_IWUSR);
> > +
> > +static const struct of_device_id mtk_mdp_comp_dt_ids[] = {
> > +	{
> > +		.compatible = "mediatek,mt8173-mdp-rdma",
> > +		.data = (void *)MTK_MDP_RDMA
> > +	}, {
> > +		.compatible = "mediatek,mt8173-mdp-rsz",
> > +		.data = (void *)MTK_MDP_RSZ
> > +	}, {
> > +		.compatible = "mediatek,mt8173-mdp-wdma",
> > +		.data = (void *)MTK_MDP_WDMA
> > +	}, {
> > +		.compatible = "mediatek,mt8173-mdp-wrot",
> > +		.data = (void *)MTK_MDP_WROT
> > +	}
> > +};
> > +
> > +static const struct of_device_id mtk_mdp_of_ids[] = {
> > +	{ .compatible = "mediatek,mt8173-mdp", },
> > +	{ },
> > +};
> > +MODULE_DEVICE_TABLE(of, mtk_mdp_of_ids);
> > +
> > +static void mtk_mdp_clock_on(struct mtk_mdp_dev *mdp)
> > +{
> > +	struct device *dev = &mdp->pdev->dev;
> > +	int i;
> > +
> > +	for (i = 0; i < ARRAY_SIZE(mdp->comp); i++)
> > +		mtk_mdp_comp_clock_on(dev, mdp->comp[i]);
> > +}
> > +
> > +static void mtk_mdp_clock_off(struct mtk_mdp_dev *mdp)
> > +{
> > +	struct device *dev = &mdp->pdev->dev;
> > +	int i;
> > +
> > +	for (i = 0; i < ARRAY_SIZE(mdp->comp); i++)
> > +		mtk_mdp_comp_clock_off(dev, mdp->comp[i]);
> > +}
> > +
> > +static void mtk_mdp_wdt_worker(struct work_struct *work)
> > +{
> > +	struct mtk_mdp_dev *mdp =
> > +			container_of(work, struct mtk_mdp_dev, wdt_work);
> > +	struct mtk_mdp_ctx *ctx;
> > +
> > +	mtk_mdp_err("Watchdog timeout");
> > +
> > +	list_for_each_entry(ctx, &mdp->ctx_list, list) {
> > +		mtk_mdp_dbg(0, "[%d] Change as state error", ctx->id);
> > +		mtk_mdp_ctx_state_lock_set(ctx, MTK_MDP_CTX_ERROR);
> > +	}
> > +}
> > +
> > +static void mtk_mdp_reset_handler(void *priv)
> > +{
> > +	struct mtk_mdp_dev *mdp = priv;
> > +
> > +	queue_work(mdp->wdt_wq, &mdp->wdt_work);
> > +}
> > +
> > +static int mtk_mdp_probe(struct platform_device *pdev)
> > +{
> > +	struct mtk_mdp_dev *mdp;
> > +	struct device *dev = &pdev->dev;
> > +	struct device_node *node;
> > +	int i, ret = 0;
> > +
> > +	mdp = devm_kzalloc(dev, sizeof(*mdp), GFP_KERNEL);
> > +	if (!mdp)
> > +		return -ENOMEM;
> > +
> > +	mdp->id = pdev->id;
> > +	mdp->pdev = pdev;
> > +	INIT_LIST_HEAD(&mdp->ctx_list);
> > +
> > +	mutex_init(&mdp->lock);
> > +	mutex_init(&mdp->vpulock);
> > +
> > +	/* Iterate over sibling MDP function blocks */
> > +	for_each_child_of_node(dev->of_node->parent, node) {
> > +		const struct of_device_id *of_id;
> > +		enum mtk_mdp_comp_type comp_type;
> > +		int comp_id;
> > +		struct mtk_mdp_comp *comp;
> > +
> > +		of_id = of_match_node(mtk_mdp_comp_dt_ids, node);
> > +		if (!of_id)
> > +			continue;
> > +
> > +		if (!of_device_is_available(node)) {
> > +			dev_err(dev, "Skipping disabled component %s\n",
> > +				node->full_name);
> > +			continue;
> > +		}
> > +
> > +		comp_type = (enum mtk_mdp_comp_type)of_id->data;
> > +		comp_id = mtk_mdp_comp_get_id(dev, node, comp_type);
> > +		if (comp_id < 0) {
> > +			dev_warn(dev, "Skipping unknown component %s\n",
> > +				 node->full_name);
> > +			continue;
> > +		}
> > +
> > +		comp = devm_kzalloc(dev, sizeof(*comp), GFP_KERNEL);
> > +		if (!comp) {
> > +			ret = -ENOMEM;
> > +			goto err_comp;
> > +		}
> > +		mdp->comp[comp_id] = comp;
> > +
> > +		ret = mtk_mdp_comp_init(dev, node, comp, comp_id);
> > +		if (ret)
> > +			goto err_comp;
> > +	}
> > +
> > +	mdp->job_wq = create_singlethread_workqueue(MTK_MDP_MODULE_NAME);
> > +	if (!mdp->job_wq) {
> > +		dev_err(&pdev->dev, "unable to alloc job workqueue\n");
> > +		ret = -ENOMEM;
> > +		goto err_alloc_job_wq;
> > +	}
> > +
> > +	mdp->wdt_wq = create_singlethread_workqueue("mdp_wdt_wq");
> > +	if (!mdp->wdt_wq) {
> > +		dev_err(&pdev->dev, "unable to alloc wdt workqueue\n");
> > +		ret = -ENOMEM;
> > +		goto err_alloc_wdt_wq;
> > +	}
> > +	INIT_WORK(&mdp->wdt_work, mtk_mdp_wdt_worker);
> > +
> > +	ret = v4l2_device_register(dev, &mdp->v4l2_dev);
> > +	if (ret) {
> > +		dev_err(&pdev->dev, "Failed to register v4l2 device\n");
> > +		ret = -EINVAL;
> > +		goto err_dev_register;
> > +	}
> > +
> > +	ret = mtk_mdp_register_m2m_device(mdp);
> > +	if (ret) {
> > +		v4l2_err(&mdp->v4l2_dev, "Failed to init mem2mem device\n");
> > +		goto err_m2m_register;
> > +	}
> > +
> > +	mdp->vpu_dev = vpu_get_plat_device(pdev);
> > +	vpu_wdt_reg_handler(mdp->vpu_dev, mtk_mdp_reset_handler, mdp,
> > +			    VPU_RST_MDP);
> > +
> > +	platform_set_drvdata(pdev, mdp);
> > +
> > +	vb2_dma_contig_set_max_seg_size(&pdev->dev, DMA_BIT_MASK(32));
> > +
> > +	pm_runtime_enable(dev);
> > +	dev_dbg(dev, "mdp-%d registered successfully\n", mdp->id);
> > +
> > +	return 0;
> > +
> > +err_m2m_register:
> > +	v4l2_device_unregister(&mdp->v4l2_dev);
> > +
> > +err_dev_register:
> > +	destroy_workqueue(mdp->wdt_wq);
> > +
> > +err_alloc_wdt_wq:
> > +	destroy_workqueue(mdp->job_wq);
> > +
> > +err_alloc_job_wq:
> > +
> > +err_comp:
> > +	for (i = 0; i < ARRAY_SIZE(mdp->comp); i++)
> > +		mtk_mdp_comp_deinit(dev, mdp->comp[i]);
> > +
> > +	dev_dbg(dev, "err %d\n", ret);
> > +	return ret;
> > +}
> > +
> > +static int mtk_mdp_remove(struct platform_device *pdev)
> > +{
> > +	struct mtk_mdp_dev *mdp = platform_get_drvdata(pdev);
> > +	int i;
> > +
> > +	pm_runtime_disable(&pdev->dev);
> > +	vb2_dma_contig_clear_max_seg_size(&pdev->dev);
> > +	mtk_mdp_unregister_m2m_device(mdp);
> > +	v4l2_device_unregister(&mdp->v4l2_dev);
> > +
> > +	flush_workqueue(mdp->job_wq);
> > +	destroy_workqueue(mdp->job_wq);
> > +
> > +	for (i = 0; i < ARRAY_SIZE(mdp->comp); i++)
> > +		mtk_mdp_comp_deinit(&pdev->dev, mdp->comp[i]);
> > +
> > +	dev_dbg(&pdev->dev, "%s driver unloaded\n", pdev->name);
> > +	return 0;
> > +}
> > +
> > +#if defined(CONFIG_PM_RUNTIME) || defined(CONFIG_PM_SLEEP)
> > +static int mtk_mdp_pm_suspend(struct device *dev)
> > +{
> > +	struct mtk_mdp_dev *mdp = dev_get_drvdata(dev);
> > +
> > +	mtk_mdp_clock_off(mdp);
> > +
> > +	return 0;
> > +}
> > +
> > +static int mtk_mdp_pm_resume(struct device *dev)
> > +{
> > +	struct mtk_mdp_dev *mdp = dev_get_drvdata(dev);
> > +
> > +	mtk_mdp_clock_on(mdp);
> > +
> > +	return 0;
> > +}
> > +#endif /* CONFIG_PM_RUNTIME || CONFIG_PM_SLEEP */
> > +
> > +#ifdef CONFIG_PM_SLEEP
> > +static int mtk_mdp_suspend(struct device *dev)
> > +{
> > +	if (pm_runtime_suspended(dev))
> > +		return 0;
> > +
> > +	return mtk_mdp_pm_suspend(dev);
> > +}
> > +
> > +static int mtk_mdp_resume(struct device *dev)
> > +{
> > +	if (pm_runtime_suspended(dev))
> > +		return 0;
> > +
> > +	return mtk_mdp_pm_resume(dev);
> > +}
> > +#endif /* CONFIG_PM_SLEEP */
> > +
> > +static const struct dev_pm_ops mtk_mdp_pm_ops = {
> > +	SET_SYSTEM_SLEEP_PM_OPS(mtk_mdp_suspend, mtk_mdp_resume)
> > +	SET_RUNTIME_PM_OPS(mtk_mdp_pm_suspend, mtk_mdp_pm_resume, NULL)
> > +};
> > +
> > +static struct platform_driver mtk_mdp_driver = {
> > +	.probe		= mtk_mdp_probe,
> > +	.remove		= mtk_mdp_remove,
> > +	.driver = {
> > +		.name	= MTK_MDP_MODULE_NAME,
> > +		.owner	= THIS_MODULE,
> > +		.pm	= &mtk_mdp_pm_ops,
> > +		.of_match_table = mtk_mdp_of_ids,
> > +	}
> > +};
> > +
> > +module_platform_driver(mtk_mdp_driver);
> > +
> > +MODULE_AUTHOR("Houlong Wei <houlong.wei@mediatek.com>");
> > +MODULE_DESCRIPTION("Mediatek image processor driver");
> > +MODULE_LICENSE("GPL v2");
> > diff --git a/drivers/media/platform/mtk-mdp/mtk_mdp_core.h b/drivers/media/platform/mtk-mdp/mtk_mdp_core.h
> > new file mode 100644
> > index 0000000..9046968
> > --- /dev/null
> > +++ b/drivers/media/platform/mtk-mdp/mtk_mdp_core.h
> > @@ -0,0 +1,233 @@
> > +/*
> > + * Copyright (c) 2015-2016 MediaTek Inc.
> > + * Author: Houlong Wei <houlong.wei@mediatek.com>
> > + *         Ming Hsiu Tsai <minghsiu.tsai@mediatek.com>
> > + *
> > + * This program is free software; you can redistribute it and/or modify
> > + * it under the terms of the GNU General Public License version 2 as
> > + * published by the Free Software Foundation.
> > + *
> > + * This program is distributed in the hope that it will be useful,
> > + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> > + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> > + * GNU General Public License for more details.
> > + */
> > +
> > +#ifndef __MTK_MDP_CORE_H__
> > +#define __MTK_MDP_CORE_H__
> > +
> > +#include <linux/videodev2.h>
> > +#include <media/v4l2-ctrls.h>
> > +#include <media/v4l2-device.h>
> > +#include <media/v4l2-mem2mem.h>
> > +#include <media/videobuf2-core.h>
> > +#include <media/videobuf2-dma-contig.h>
> > +
> > +#include "mtk_mdp_vpu.h"
> > +#include "mtk_mdp_comp.h"
> > +
> > +
> > +#define MTK_MDP_MODULE_NAME		"mtk-mdp"
> > +
> > +#define MTK_MDP_SHUTDOWN_TIMEOUT	((100*HZ)/1000) /* 100ms */
> > +#define MTK_MDP_MAX_CTRL_NUM		10
> > +
> > +#define MTK_MDP_FMT_FLAG_OUTPUT		BIT(0)
> > +#define MTK_MDP_FMT_FLAG_CAPTURE	BIT(1)
> > +
> > +#define MTK_MDP_SRC_FMT			BIT(1)
> > +#define MTK_MDP_DST_FMT			BIT(2)
> > +#define MTK_MDP_CTX_ERROR		BIT(5)
> > +
> > +/**
> > + * struct mtk_mdp_fmt - the driver's internal color format data
> > + * @name: format description
> > + * @pixelformat: the fourcc code for this format, 0 if not applicable
> > + * @num_planes: number of physically non-contiguous data planes
> > + * @depth: per plane driver's private 'number of bits per pixel'
> > + * @flags: flags indicating which operation mode format applies to
> > +	   MTK_MDP_FMT_FLAG_OUTPUT is used in OUTPUT stream
> > +	   MTK_MDP_FMT_FLAG_CAPTURE is used in CAPTURE stream
> > + */
> > +struct mtk_mdp_fmt {
> > +	char	*name;
> > +	u32	pixelformat;
> > +	u16	num_planes;
> > +	u8	depth[VIDEO_MAX_PLANES];
> > +	u32	flags;
> > +};
> > +
> > +/**
> > + * struct mtk_mdp_addr - the image processor physical address set
> > + * @addr:	address of planes
> > + */
> > +struct mtk_mdp_addr {
> > +	dma_addr_t addr[MTK_MDP_MAX_NUM_PLANE];
> > +};
> > +
> > +/* struct mtk_mdp_ctrls - the image processor control set
> > + * @rotate: rotation degree
> > + * @hflip: horizontal flip
> > + * @vflip: vertical flip
> > + * @global_alpha: the alpha value of current frame
> > + */
> > +struct mtk_mdp_ctrls {
> > +	struct v4l2_ctrl *rotate;
> > +	struct v4l2_ctrl *hflip;
> > +	struct v4l2_ctrl *vflip;
> > +	struct v4l2_ctrl *global_alpha;
> > +};
> > +
> > +/**
> > + * struct mtk_mdp_frame - source/target frame properties
> > + * @width:	SRC : SRCIMG_WIDTH, DST : OUTPUTDMA_WHOLE_IMG_WIDTH
> > + * @height:	SRC : SRCIMG_HEIGHT, DST : OUTPUTDMA_WHOLE_IMG_HEIGHT
> > + * @crop:	cropped(source)/scaled(destination) size
> > + * @payload:	image size in bytes (w x h x bpp)
> > + * @pitch:	bytes per line of image in memory
> > + * @addr:	image frame buffer physical addresses
> > + * @fmt:	color format pointer
> > + * @alpha:	frame's alpha value
> > + */
> > +struct mtk_mdp_frame {
> > +	u32				width;
> > +	u32				height;
> > +	struct v4l2_rect		crop;
> > +	unsigned long			payload[VIDEO_MAX_PLANES];
> > +	unsigned int			pitch[VIDEO_MAX_PLANES];
> > +	struct mtk_mdp_addr		addr;
> > +	const struct mtk_mdp_fmt	*fmt;
> > +	u8				alpha;
> > +};
> > +
> > +/**
> > + * struct mtk_mdp_variant - image processor variant information
> > + * @pix_max:		maximum limit of image size
> > + * @pix_min:		minimun limit of image size
> > + * @pix_align:		alignement of image
> > + * @h_scale_up_max:	maximum scale-up in horizontal
> > + * @v_scale_up_max:	maximum scale-up in vertical
> > + * @h_scale_down_max:	maximum scale-down in horizontal
> > + * @v_scale_down_max:	maximum scale-down in vertical
> > + */
> > +struct mtk_mdp_variant {
> > +	struct mtk_mdp_pix_limit	*pix_max;
> > +	struct mtk_mdp_pix_limit	*pix_min;
> > +	struct mtk_mdp_pix_align	*pix_align;
> > +	u16				h_scale_up_max;
> > +	u16				v_scale_up_max;
> > +	u16				h_scale_down_max;
> > +	u16				v_scale_down_max;
> > +};
> > +
> > +/**
> > + * struct mtk_mdp_dev - abstraction for image processor entity
> > + * @lock:	the mutex protecting this data structure
> > + * @vpulock:	the mutex protecting the communication with VPU
> > + * @pdev:	pointer to the image processor platform device
> > + * @variant:	the IP variant information
> > + * @id:		image processor device index (0..MTK_MDP_MAX_DEVS)
> > + * @comp:	MDP function components
> > + * @m2m_dev:	v4l2 memory-to-memory device data
> > + * @ctx_list:	list of struct mtk_mdp_ctx
> > + * @vdev:	video device for image processor driver
> > + * @v4l2_dev:	V4L2 device to register video devices for.
> > + * @job_wq:	processor work queue
> > + * @vpu_dev:	VPU platform device
> > + * @ctx_num:	counter of active MTK MDP context
> > + * @id_counter:	An integer id given to the next opened context
> > + * @wdt_wq:	work queue for VPU watchdog
> > + * @wdt_work:	worker for VPU watchdog
> > + */
> > +struct mtk_mdp_dev {
> > +	struct mutex			lock;
> > +	struct mutex			vpulock;
> > +	struct platform_device		*pdev;
> > +	struct mtk_mdp_variant		*variant;
> > +	u16				id;
> > +	struct mtk_mdp_comp		*comp[MTK_MDP_COMP_ID_MAX];
> > +	struct v4l2_m2m_dev		*m2m_dev;
> > +	struct list_head		ctx_list;
> > +	struct video_device		vdev;
> > +	struct v4l2_device		v4l2_dev;
> > +	struct workqueue_struct		*job_wq;
> > +	struct platform_device		*vpu_dev;
> > +	int				ctx_num;
> > +	unsigned long			id_counter;
> > +	struct workqueue_struct		*wdt_wq;
> > +	struct work_struct		wdt_work;
> > +};
> > +
> > +/**
> > + * mtk_mdp_ctx - the device context data
> > + * @list:		link to ctx_list of mtk_mdp_dev
> > + * @s_frame:		source frame properties
> > + * @d_frame:		destination frame properties
> > + * @id:			index of the context that this structure describes
> > + * @flags:		additional flags for image conversion
> > + * @state:		flags to keep track of user configuration
> > +			Protected by slock
> > + * @rotation:		rotates the image by specified angle
> > + * @hflip:		mirror the picture horizontally
> > + * @vflip:		mirror the picture vertically
> > + * @mdp_dev:		the image processor device this context applies to
> > + * @m2m_ctx:		memory-to-memory device context
> > + * @fh:			v4l2 file handle
> > + * @ctrl_handler:	v4l2 controls handler
> > + * @ctrls		image processor control set
> > + * @ctrls_rdy:		true if the control handler is initialized
> > + * @vpu:		VPU instance
> > + * @slock:		the mutex protecting mtp_mdp_ctx.state
> > + * @work:		worker for image processing
> > + */
> > +struct mtk_mdp_ctx {
> > +	struct list_head		list;
> > +	struct mtk_mdp_frame		s_frame;
> > +	struct mtk_mdp_frame		d_frame;
> > +	u32				flags;
> > +	u32				state;
> > +	int				id;
> > +	int				rotation;
> > +	u32				hflip:1;
> > +	u32				vflip:1;
> > +	struct mtk_mdp_dev		*mdp_dev;
> > +	struct v4l2_m2m_ctx		*m2m_ctx;
> > +	struct v4l2_fh			fh;
> > +	struct v4l2_ctrl_handler	ctrl_handler;
> > +	struct mtk_mdp_ctrls		ctrls;
> > +	bool				ctrls_rdy;
> > +
> > +	struct mtk_mdp_vpu		vpu;
> > +	struct mutex			slock;
> > +	struct work_struct		work;
> > +};
> > +
> > +extern int mtk_mdp_dbg_level;
> > +
> > +#if defined(DEBUG)
> > +
> > +#define mtk_mdp_dbg(level, fmt, args...)				 \
> > +	do {								 \
> > +		if (mtk_mdp_dbg_level >= level)				 \
> > +			pr_info("[MTK_MDP] level=%d %s(),%d: " fmt "\n", \
> > +				level, __func__, __LINE__, ##args);	 \
> > +	} while (0)
> > +
> > +#define mtk_mdp_err(fmt, args...)					\
> > +	pr_err("[MTK_MDP][ERROR] %s:%d: " fmt "\n", __func__, __LINE__, \
> > +	       ##args)
> > +
> > +
> > +#define mtk_mdp_dbg_enter()  mtk_mdp_dbg(3, "+")
> > +#define mtk_mdp_dbg_leave()  mtk_mdp_dbg(3, "-")
> > +
> > +#else
> > +
> > +#define mtk_mdp_dbg(level, fmt, args...)
> > +#define mtk_mdp_err(fmt, args...)
> > +#define mtk_mdp_dbg_enter()
> > +#define mtk_mdp_dbg_leave()
> > +
> > +#endif
> > +
> > +#endif /* __MTK_MDP_CORE_H__ */
> > diff --git a/drivers/media/platform/mtk-mdp/mtk_mdp_ipi.h b/drivers/media/platform/mtk-mdp/mtk_mdp_ipi.h
> > new file mode 100644
> > index 0000000..78e2cc0
> > --- /dev/null
> > +++ b/drivers/media/platform/mtk-mdp/mtk_mdp_ipi.h
> > @@ -0,0 +1,126 @@
> > +/*
> > + * Copyright (c) 2015-2016 MediaTek Inc.
> > + * Author: Houlong Wei <houlong.wei@mediatek.com>
> > + *         Ming Hsiu Tsai <minghsiu.tsai@mediatek.com>
> > + *
> > + * This program is free software; you can redistribute it and/or modify
> > + * it under the terms of the GNU General Public License version 2 as
> > + * published by the Free Software Foundation.
> > + *
> > + * This program is distributed in the hope that it will be useful,
> > + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> > + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> > + * GNU General Public License for more details.
> > + */
> > +
> > +#ifndef __MTK_MDP_IPI_H__
> > +#define __MTK_MDP_IPI_H__
> > +
> > +#define MTK_MDP_MAX_NUM_PLANE		3
> > +
> > +enum mdp_ipi_msgid {
> > +	AP_MDP_INIT		= 0xd000,
> > +	AP_MDP_DEINIT		= 0xd001,
> > +	AP_MDP_PROCESS		= 0xd002,
> > +
> > +	VPU_MDP_INIT_ACK	= 0xe000,
> > +	VPU_MDP_DEINIT_ACK	= 0xe001,
> > +	VPU_MDP_PROCESS_ACK	= 0xe002
> > +};
> > +
> > +#pragma pack(push, 4)
> > +
> > +/**
> > + * struct mdp_ipi_init - for AP_MDP_INIT
> > + * @msg_id   : AP_MDP_INIT
> > + * @ipi_id   : IPI_MDP
> > + * @ap_inst  : AP mtk_mdp_vpu address
> > + */
> > +struct mdp_ipi_init {
> > +	uint32_t msg_id;
> > +	uint32_t ipi_id;
> > +	uint64_t ap_inst;
> > +};
> > +
> > +/**
> > + * struct mdp_ipi_comm - for AP_MDP_PROCESS, AP_MDP_DEINIT
> > + * @msg_id        : AP_MDP_PROCESS, AP_MDP_DEINIT
> > + * @ipi_id        : IPI_MDP
> > + * @ap_inst       : AP mtk_mdp_vpu address
> > + * @vpu_inst_addr : VPU MDP instance address
> > + */
> > +struct mdp_ipi_comm {
> > +	uint32_t msg_id;
> > +	uint32_t ipi_id;
> > +	uint64_t ap_inst;
> > +	uint32_t vpu_inst_addr;
> > +};
> > +
> > +/**
> > + * struct mdp_ipi_comm_ack - for VPU_MDP_DEINIT_ACK, VPU_MDP_PROCESS_ACK
> > + * @msg_id        : VPU_MDP_DEINIT_ACK, VPU_MDP_PROCESS_ACK
> > + * @ipi_id        : IPI_MDP
> > + * @ap_inst       : AP mtk_mdp_vpu address
> > + * @vpu_inst_addr : VPU MDP instance address
> > + * @status        : VPU exeuction result
> > + */
> > +struct mdp_ipi_comm_ack {
> > +	uint32_t msg_id;
> > +	uint32_t ipi_id;
> > +	uint64_t ap_inst;
> > +	uint32_t vpu_inst_addr;
> > +	int32_t status;
> > +};
> > +
> > +/**
> > + * struct mdp_config - configured for source/destination image
> > + * @x        : left
> > + * @y        : top
> > + * @w        : width
> > + * @h        : height
> > + * @w_stride : bytes in horizontal
> > + * @h_stride : bytes in vertical
> > + * @crop_x   : cropped left
> > + * @crop_y   : cropped top
> > + * @crop_w   : cropped width
> > + * @crop_h   : cropped height
> > + * @format   : color format
> > + */
> > +struct mdp_config {
> > +	int32_t x;
> > +	int32_t y;
> > +	int32_t w;
> > +	int32_t h;
> > +	int32_t w_stride;
> > +	int32_t h_stride;
> > +	int32_t crop_x;
> > +	int32_t crop_y;
> > +	int32_t crop_w;
> > +	int32_t crop_h;
> > +	int32_t format;
> > +};
> > +
> > +struct mdp_buffer {
> > +	uint64_t addr_mva[MTK_MDP_MAX_NUM_PLANE];
> > +	int32_t plane_size[MTK_MDP_MAX_NUM_PLANE];
> > +	int32_t plane_num;
> > +};
> > +
> > +struct mdp_config_misc {
> > +	int32_t orientation; /* 0, 90, 180, 270 */
> > +	int32_t hflip; /* 1 will enable the flip */
> > +	int32_t vflip; /* 1 will enable the flip */
> > +	int32_t alpha; /* global alpha */
> > +};
> > +
> > +struct mdp_process_vsi {
> > +	struct mdp_config src_config;
> > +	struct mdp_buffer src_buffer;
> > +	struct mdp_config dst_config;
> > +	struct mdp_buffer dst_buffer;
> > +	struct mdp_config_misc misc;
> > +};
> > +
> > +#pragma pack(pop)
> > +
> > +#endif /* __MTK_MDP_IPI_H__ */
> > diff --git a/drivers/media/platform/mtk-mdp/mtk_mdp_m2m.c b/drivers/media/platform/mtk-mdp/mtk_mdp_m2m.c
> > new file mode 100644
> > index 0000000..e3ea97d
> > --- /dev/null
> > +++ b/drivers/media/platform/mtk-mdp/mtk_mdp_m2m.c
> > @@ -0,0 +1,1304 @@
> > +/*
> > + * Copyright (c) 2015-2016 MediaTek Inc.
> > + * Author: Houlong Wei <houlong.wei@mediatek.com>
> > + *         Ming Hsiu Tsai <minghsiu.tsai@mediatek.com>
> > + *
> > + * This program is free software; you can redistribute it and/or modify
> > + * it under the terms of the GNU General Public License version 2 as
> > + * published by the Free Software Foundation.
> > + *
> > + * This program is distributed in the hope that it will be useful,
> > + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> > + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> > + * GNU General Public License for more details.
> > + */
> > +
> > +#include <linux/device.h>
> > +#include <linux/errno.h>
> > +#include <linux/kernel.h>
> > +#include <linux/pm_runtime.h>
> > +#include <linux/workqueue.h>
> > +#include <media/v4l2-event.h>
> > +#include <media/v4l2-ioctl.h>
> > +
> > +#include "mtk_mdp_core.h"
> > +#include "mtk_mdp_m2m.h"
> > +#include "mtk_mdp_regs.h"
> > +#include "mtk_vpu.h"
> > +
> > +
> > +/**
> > + *  struct mtk_mdp_pix_limit - image pixel size limits
> > + *  @org_w: source pixel width
> > + *  @org_h: source pixel height
> > + *  @target_rot_dis_w: pixel dst scaled width with the rotator is off
> > + *  @target_rot_dis_h: pixel dst scaled height with the rotator is off
> > + *  @target_rot_en_w: pixel dst scaled width with the rotator is on
> > + *  @target_rot_en_h: pixel dst scaled height with the rotator is on
> > + */
> > +struct mtk_mdp_pix_limit {
> > +	u16 org_w;
> > +	u16 org_h;
> > +	u16 target_rot_dis_w;
> > +	u16 target_rot_dis_h;
> > +	u16 target_rot_en_w;
> > +	u16 target_rot_en_h;
> > +};
> > +
> > +/**
> > + *  struct mtk_mdp_pix_align - alignement of image
> > + *  @org_w: source alignment of width
> > + *  @org_h: source alignment of height
> > + *  @target_w: dst alignment of width
> > + *  @target_h: dst alignment of height
> > + */
> > +struct mtk_mdp_pix_align {
> > +	u16 org_w;
> > +	u16 org_h;
> > +	u16 target_w;
> > +	u16 target_h;
> > +};
> > +
> > +static const struct mtk_mdp_fmt mtk_mdp_formats[] = {
> > +	{
> > +		.name		= "YUV420 MT21. 2p, Y/CbCr",
> > +		.pixelformat	= V4L2_PIX_FMT_MT21,
> > +		.depth		= { 8, 4 },
> > +		.num_planes	= 2,
> > +		.flags		= MTK_MDP_FMT_FLAG_OUTPUT,
> > +	}, {
> > +		.name		= "YUV420 non-contig. 2p, Y/CbCr",
> > +		.pixelformat	= V4L2_PIX_FMT_NV12M,
> > +		.depth		= { 8, 4 },
> > +		.num_planes	= 2,
> > +		.flags		= MTK_MDP_FMT_FLAG_OUTPUT |
> > +				  MTK_MDP_FMT_FLAG_CAPTURE,
> > +	}, {
> > +		.name		= "YUV420 non-contig. 3p, Y/Cb/Cr",
> > +		.pixelformat	= V4L2_PIX_FMT_YUV420M,
> > +		.depth		= { 8, 2, 2 },
> > +		.num_planes	= 3,
> > +		.flags		= MTK_MDP_FMT_FLAG_OUTPUT |
> > +				  MTK_MDP_FMT_FLAG_CAPTURE,
> > +	}
> > +};
> > +
> > +static struct mtk_mdp_pix_limit mtk_mdp_size_max = {
> > +	.target_rot_dis_w	= 4096,
> > +	.target_rot_dis_h	= 4096,
> > +	.target_rot_en_w	= 4096,
> > +	.target_rot_en_h	= 4096,
> > +};
> > +
> > +static struct mtk_mdp_pix_limit mtk_mdp_size_min = {
> > +	.org_w			= 16,
> > +	.org_h			= 16,
> > +	.target_rot_dis_w	= 16,
> > +	.target_rot_dis_h	= 16,
> > +	.target_rot_en_w	= 16,
> > +	.target_rot_en_h	= 16,
> > +};
> > +
> > +static struct mtk_mdp_pix_align mtk_mdp_size_align = {
> > +	.org_w			= 16,
> > +	.org_h			= 16,
> > +	.target_w		= 2,
> > +	.target_h		= 2,
> > +};
> > +
> > +static struct mtk_mdp_variant mtk_mdp_default_variant = {
> > +	.pix_max		= &mtk_mdp_size_max,
> > +	.pix_min		= &mtk_mdp_size_min,
> > +	.pix_align		= &mtk_mdp_size_align,
> > +	.h_scale_up_max		= 32,
> > +	.v_scale_up_max		= 32,
> > +	.h_scale_down_max	= 32,
> > +	.v_scale_down_max	= 128,
> > +};
> > +
> > +static const struct mtk_mdp_fmt *mtk_mdp_find_fmt(u32 pixelformat, u32 type)
> > +{
> > +	u32 i, flag;
> > +
> > +	flag = V4L2_TYPE_IS_OUTPUT(type) ? MTK_MDP_FMT_FLAG_OUTPUT :
> > +					   MTK_MDP_FMT_FLAG_CAPTURE;
> > +
> > +	for (i = 0; i < ARRAY_SIZE(mtk_mdp_formats); ++i) {
> > +		if (!(mtk_mdp_formats[i].flags & flag))
> > +			continue;
> > +		if (mtk_mdp_formats[i].pixelformat == pixelformat)
> > +			return &mtk_mdp_formats[i];
> > +	}
> > +	return NULL;
> > +}
> > +
> > +static const struct mtk_mdp_fmt *mtk_mdp_find_fmt_by_index(u32 index, u32 type)
> > +{
> > +	u32 i, flag, num = 0;
> > +
> > +	flag = V4L2_TYPE_IS_OUTPUT(type) ? MTK_MDP_FMT_FLAG_OUTPUT :
> > +					   MTK_MDP_FMT_FLAG_CAPTURE;
> > +
> > +	for (i = 0; i < ARRAY_SIZE(mtk_mdp_formats); ++i) {
> > +		if (!(mtk_mdp_formats[i].flags & flag))
> > +			continue;
> > +		if (index == num)
> > +			return &mtk_mdp_formats[i];
> > +		num++;
> > +	}
> > +	return NULL;
> > +}
> > +
> > +static void mtk_mdp_bound_align_image(u32 *w, unsigned int wmin,
> > +				      unsigned int wmax, unsigned int align_w,
> > +				      u32 *h, unsigned int hmin,
> > +				      unsigned int hmax, unsigned int align_h)
> > +{
> > +	int org_w, org_h, step_w, step_h;
> > +	int walign, halign;
> > +
> > +	org_w = *w;
> > +	org_h = *h;
> > +	walign = ffs(align_w) - 1;
> > +	halign = ffs(align_h) - 1;
> > +	v4l_bound_align_image(w, wmin, wmax, walign, h, hmin, hmax, halign, 0);
> > +
> > +	step_w = 1 << walign;
> > +	step_h = 1 << halign;
> > +	if (*w < org_w && (*w + step_w) <= wmax)
> > +		*w += step_w;
> > +	if (*h < org_h && (*h + step_h) <= hmax)
> > +		*h += step_h;
> > +}
> > +
> > +static const struct mtk_mdp_fmt *mtk_mdp_try_fmt_mplane(struct mtk_mdp_ctx *ctx,
> > +							struct v4l2_format *f)
> > +{
> > +	struct mtk_mdp_dev *mdp = ctx->mdp_dev;
> > +	struct mtk_mdp_variant *variant = mdp->variant;
> > +	struct v4l2_pix_format_mplane *pix_mp = &f->fmt.pix_mp;
> > +	const struct mtk_mdp_fmt *fmt;
> > +	u32 max_w, max_h, align_w, align_h;
> > +	u32 min_w, min_h, org_w, org_h;
> > +	int i;
> > +
> > +	fmt = mtk_mdp_find_fmt(pix_mp->pixelformat, f->type);
> > +	if (!fmt)
> > +		fmt = mtk_mdp_find_fmt_by_index(0, f->type);
> > +	if (!fmt) {
> > +		dev_dbg(&ctx->mdp_dev->pdev->dev,
> > +			"pixelformat format 0x%X invalid\n",
> > +			pix_mp->pixelformat);
> > +		return NULL;
> > +	}
> > +
> > +	pix_mp->field = V4L2_FIELD_NONE;
> > +	pix_mp->pixelformat = fmt->pixelformat;
> > +	memset(pix_mp->reserved, 0, sizeof(pix_mp->reserved));
> > +
> > +	max_w = variant->pix_max->target_rot_dis_w;
> > +	max_h = variant->pix_max->target_rot_dis_h;
> > +
> > +	align_w = variant->pix_align->org_w;
> > +	align_h = variant->pix_align->org_h;
> > +
> > +	if (V4L2_TYPE_IS_OUTPUT(f->type)) {
> > +		min_w = variant->pix_min->org_w;
> > +		min_h = variant->pix_min->org_h;
> > +	} else {
> > +		min_w = variant->pix_min->target_rot_dis_w;
> > +		min_h = variant->pix_min->target_rot_dis_h;
> > +	}
> > +
> > +	mtk_mdp_dbg(2, "[%d] type:%d, wxh:%ux%u, align:%ux%u, max:%ux%u",
> > +		    ctx->id, f->type, pix_mp->width, pix_mp->height,
> > +		    align_w, align_h, max_w, max_h);
> > +	/*
> > +	 * To check if image size is modified to adjust parameter against
> > +	 * hardware abilities
> > +	 */
> > +	org_w = pix_mp->width;
> > +	org_h = pix_mp->height;
> > +
> > +	mtk_mdp_bound_align_image(&pix_mp->width, min_w, max_w, align_w,
> > +				  &pix_mp->height, min_h, max_h, align_h);
> > +
> > +	if (org_w != pix_mp->width || org_h != pix_mp->height)
> > +		mtk_mdp_dbg(1, "[%d] size change:%ux%u to %ux%u", ctx->id,
> > +			    org_w, org_h, pix_mp->width, pix_mp->height);
> > +	pix_mp->num_planes = fmt->num_planes;
> > +
> > +	for (i = 0; i < pix_mp->num_planes; ++i) {
> > +		int bpl = (pix_mp->width * fmt->depth[i]) >> 3;
> > +		int sizeimage = bpl * pix_mp->height;
> > +
> > +		pix_mp->plane_fmt[i].bytesperline = bpl;
> > +		if (pix_mp->plane_fmt[i].sizeimage < sizeimage)
> > +			pix_mp->plane_fmt[i].sizeimage = sizeimage;
> > +		memset(pix_mp->plane_fmt[i].reserved, 0,
> > +		       sizeof(pix_mp->plane_fmt[i].reserved));
> > +		mtk_mdp_dbg(2, "[%d] p%d, bpl:%d, sizeimage:%u (%u)", ctx->id,
> > +			    i, bpl, pix_mp->plane_fmt[i].sizeimage, sizeimage);
> > +	}
> > +
> > +	return fmt;
> > +}
> > +
> > +static struct mtk_mdp_frame *mtk_mdp_ctx_get_frame(struct mtk_mdp_ctx *ctx,
> > +					    enum v4l2_buf_type type)
> > +{
> > +	if (V4L2_TYPE_IS_OUTPUT(type))
> > +		return &ctx->s_frame;
> > +	return &ctx->d_frame;
> > +}
> > +
> > +static void mtk_mdp_check_crop_change(u32 new_w, u32 new_h, u32 *w, u32 *h)
> > +{
> > +	if (new_w != *w || new_h != *h) {
> > +		mtk_mdp_dbg(1, "size change:%dx%d to %dx%d",
> > +			    *w, *h, new_w, new_h);
> > +
> > +		*w = new_w;
> > +		*h = new_h;
> > +	}
> > +}
> > +
> > +static int mtk_mdp_try_crop(struct mtk_mdp_ctx *ctx, struct v4l2_crop *cr)
> > +{
> > +	struct mtk_mdp_frame *frame;
> > +	struct mtk_mdp_dev *mdp = ctx->mdp_dev;
> > +	struct mtk_mdp_variant *variant = mdp->variant;
> > +	u32 align_w, align_h, new_w, new_h;
> > +	u32 min_w, min_h, max_w, max_h;
> > +
> > +	if (cr->c.top < 0 || cr->c.left < 0) {
> > +		dev_err(&ctx->mdp_dev->pdev->dev,
> > +			"doesn't support negative values for top & left\n");
> > +		return -EINVAL;
> > +	}
> > +
> > +	mtk_mdp_dbg(2, "[%d] type:%d, set wxh:%dx%d", ctx->id, cr->type,
> > +		    cr->c.width, cr->c.height);
> > +
> > +	frame = mtk_mdp_ctx_get_frame(ctx, cr->type);
> > +	max_w = frame->width;
> > +	max_h = frame->height;
> > +	new_w = cr->c.width;
> > +	new_h = cr->c.height;
> > +
> > +	if (V4L2_TYPE_IS_OUTPUT(cr->type)) {
> > +		align_w = 1;
> > +		align_h = 1;
> > +		min_w = 64;
> > +		min_h = 32;
> > +	} else {
> > +		align_w = variant->pix_align->target_w;
> > +		align_h = variant->pix_align->target_h;
> > +		if (ctx->ctrls.rotate->val == 90 ||
> > +		    ctx->ctrls.rotate->val == 270) {
> > +			max_w = frame->height;
> > +			max_h = frame->width;
> > +			min_w = variant->pix_min->target_rot_en_w;
> > +			min_h = variant->pix_min->target_rot_en_h;
> > +			new_w = cr->c.height;
> > +			new_h = cr->c.width;
> > +		} else {
> > +			min_w = variant->pix_min->target_rot_dis_w;
> > +			min_h = variant->pix_min->target_rot_dis_h;
> > +		}
> > +	}
> > +
> > +	mtk_mdp_dbg(2, "[%d] align:%dx%d, min:%dx%d, new:%dx%d", ctx->id,
> > +		    align_w, align_h, min_w, min_h, new_w, new_h);
> > +
> > +	mtk_mdp_bound_align_image(&new_w, min_w, max_w, align_w,
> > +				  &new_h, min_h, max_h, align_h);
> > +
> > +	if (!V4L2_TYPE_IS_OUTPUT(cr->type) &&
> > +		(ctx->ctrls.rotate->val == 90 ||
> > +		ctx->ctrls.rotate->val == 270))
> > +		mtk_mdp_check_crop_change(new_h, new_w,
> > +					  &cr->c.width, &cr->c.height);
> > +	else
> > +		mtk_mdp_check_crop_change(new_w, new_h,
> > +					  &cr->c.width, &cr->c.height);
> > +
> > +	/* adjust left/top if cropping rectangle is out of bounds */
> > +	/* Need to add code to algin left value with 2's multiple */
> > +	if (cr->c.left + new_w > max_w)
> > +		cr->c.left = max_w - new_w;
> > +	if (cr->c.top + new_h > max_h)
> > +		cr->c.top = max_h - new_h;
> > +
> > +	if (cr->c.left & 1)
> > +		cr->c.left -= 1;
> > +
> > +	mtk_mdp_dbg(2, "[%d] crop l,t,w,h:%d,%d,%d,%d, max:%dx%d", ctx->id,
> > +		    cr->c.left, cr->c.top, cr->c.width,
> > +		    cr->c.height, max_w, max_h);
> > +	return 0;
> > +}
> > +
> > +static inline struct mtk_mdp_ctx *fh_to_ctx(struct v4l2_fh *fh)
> > +{
> > +	return container_of(fh, struct mtk_mdp_ctx, fh);
> > +}
> > +
> > +static inline struct mtk_mdp_ctx *ctrl_to_ctx(struct v4l2_ctrl *ctrl)
> > +{
> > +	return container_of(ctrl->handler, struct mtk_mdp_ctx, ctrl_handler);
> > +}
> > +
> > +void mtk_mdp_ctx_state_lock_set(struct mtk_mdp_ctx *ctx, u32 state)
> > +{
> > +	mutex_lock(&ctx->slock);
> > +	ctx->state |= state;
> > +	mutex_unlock(&ctx->slock);
> > +}
> > +
> > +static void mtk_mdp_ctx_state_lock_clear(struct mtk_mdp_ctx *ctx, u32 state)
> > +{
> > +	mutex_lock(&ctx->slock);
> > +	ctx->state &= ~state;
> > +	mutex_unlock(&ctx->slock);
> > +}
> > +
> > +static bool mtk_mdp_ctx_state_is_set(struct mtk_mdp_ctx *ctx, u32 mask)
> > +{
> > +	bool ret;
> > +
> > +	mutex_lock(&ctx->slock);
> > +	ret = (ctx->state & mask) == mask;
> > +	mutex_unlock(&ctx->slock);
> > +	return ret;
> > +}
> > +
> > +static void mtk_mdp_ctx_lock(struct vb2_queue *vq)
> > +{
> > +	struct mtk_mdp_ctx *ctx = vb2_get_drv_priv(vq);
> > +
> > +	mutex_lock(&ctx->mdp_dev->lock);
> > +}
> > +
> > +static void mtk_mdp_ctx_unlock(struct vb2_queue *vq)
> > +{
> > +	struct mtk_mdp_ctx *ctx = vb2_get_drv_priv(vq);
> > +
> > +	mutex_unlock(&ctx->mdp_dev->lock);
> > +}
> > +
> > +static void mtk_mdp_set_frame_size(struct mtk_mdp_frame *frame, int width,
> > +				   int height)
> > +{
> > +	frame->width = width;
> > +	frame->height = height;
> > +	frame->crop.width = width;
> > +	frame->crop.height = height;
> > +	frame->crop.left = 0;
> > +	frame->crop.top = 0;
> > +}
> > +
> > +static int mtk_mdp_m2m_start_streaming(struct vb2_queue *q, unsigned int count)
> > +{
> > +	struct mtk_mdp_ctx *ctx = q->drv_priv;
> > +	int ret;
> > +
> > +	ret = pm_runtime_get_sync(&ctx->mdp_dev->pdev->dev);
> > +	if (ret < 0)
> > +		mtk_mdp_dbg(1, "[%d] pm_runtime_get_sync failed:%d",
> > +			    ctx->id, ret);
> > +
> > +	return 0;
> > +}
> > +
> > +static void *mtk_mdp_m2m_buf_remove(struct mtk_mdp_ctx *ctx,
> > +				    enum v4l2_buf_type type)
> > +{
> > +	if (V4L2_TYPE_IS_OUTPUT(type))
> > +		return v4l2_m2m_src_buf_remove(ctx->m2m_ctx);
> > +	else
> > +		return v4l2_m2m_dst_buf_remove(ctx->m2m_ctx);
> > +}
> > +
> > +static void mtk_mdp_m2m_stop_streaming(struct vb2_queue *q)
> > +{
> > +	struct mtk_mdp_ctx *ctx = q->drv_priv;
> > +	struct vb2_buffer *vb;
> > +
> > +	vb = mtk_mdp_m2m_buf_remove(ctx, q->type);
> > +	while (vb != NULL) {
> > +		v4l2_m2m_buf_done(to_vb2_v4l2_buffer(vb), VB2_BUF_STATE_ERROR);
> > +		vb = mtk_mdp_m2m_buf_remove(ctx, q->type);
> > +	}
> > +
> > +	pm_runtime_put(&ctx->mdp_dev->pdev->dev);
> > +}
> > +
> > +static void mtk_mdp_m2m_job_abort(void *priv)
> > +{
> > +}
> > +
> > +/* The color format (num_planes) must be already configured. */
> > +static void mtk_mdp_prepare_addr(struct mtk_mdp_ctx *ctx,
> > +				 struct vb2_buffer *vb,
> > +				 struct mtk_mdp_frame *frame,
> > +				 struct mtk_mdp_addr *addr)
> > +{
> > +	u32 pix_size, planes, i;
> > +
> > +	pix_size = frame->width * frame->height;
> > +	planes = min_t(u32, frame->fmt->num_planes, ARRAY_SIZE(addr->addr));
> > +	for (i = 0; i < planes; i++)
> > +		addr->addr[i] = vb2_dma_contig_plane_dma_addr(vb, i);
> > +
> > +	mtk_mdp_dbg(3, "[%d] planes:%d, size:%d, addr:%p,%p,%p",
> > +		    ctx->id, planes, pix_size, (void *)addr->addr[0],
> > +		    (void *)addr->addr[1], (void *)addr->addr[2]);
> > +}
> > +
> > +static void mtk_mdp_m2m_get_bufs(struct mtk_mdp_ctx *ctx)
> > +{
> > +	struct mtk_mdp_frame *s_frame, *d_frame;
> > +	struct vb2_buffer *src_vb, *dst_vb;
> > +	struct vb2_v4l2_buffer *src_vbuf, *dst_vbuf;
> > +
> > +	s_frame = &ctx->s_frame;
> > +	d_frame = &ctx->d_frame;
> > +
> > +	src_vb = v4l2_m2m_next_src_buf(ctx->m2m_ctx);
> > +	mtk_mdp_prepare_addr(ctx, src_vb, s_frame, &s_frame->addr);
> > +
> > +	dst_vb = v4l2_m2m_next_dst_buf(ctx->m2m_ctx);
> > +	mtk_mdp_prepare_addr(ctx, dst_vb, d_frame, &d_frame->addr);
> > +
> > +	src_vbuf = to_vb2_v4l2_buffer(src_vb);
> > +	dst_vbuf = to_vb2_v4l2_buffer(dst_vb);
> > +	dst_vbuf->vb2_buf.timestamp = src_vbuf->vb2_buf.timestamp;
> > +}
> > +
> > +static void mtk_mdp_process_done(void *priv, int vb_state)
> > +{
> > +	struct mtk_mdp_dev *mdp = priv;
> > +	struct mtk_mdp_ctx *ctx;
> > +	struct vb2_buffer *src_vb, *dst_vb;
> > +	struct vb2_v4l2_buffer *src_vbuf = NULL, *dst_vbuf = NULL;
> > +
> > +	ctx = v4l2_m2m_get_curr_priv(mdp->m2m_dev);
> > +	if (!ctx)
> > +		return;
> > +
> > +	src_vb = v4l2_m2m_src_buf_remove(ctx->m2m_ctx);
> > +	src_vbuf = to_vb2_v4l2_buffer(src_vb);
> > +	dst_vb = v4l2_m2m_dst_buf_remove(ctx->m2m_ctx);
> > +	dst_vbuf = to_vb2_v4l2_buffer(dst_vb);
> > +
> > +	dst_vbuf->vb2_buf.timestamp = src_vbuf->vb2_buf.timestamp;
> > +	dst_vbuf->timecode = src_vbuf->timecode;
> > +	dst_vbuf->flags &= ~V4L2_BUF_FLAG_TSTAMP_SRC_MASK;
> > +	dst_vbuf->flags |= src_vbuf->flags & V4L2_BUF_FLAG_TSTAMP_SRC_MASK;
> > +
> > +	v4l2_m2m_buf_done(src_vbuf, vb_state);
> > +	v4l2_m2m_buf_done(dst_vbuf, vb_state);
> > +	v4l2_m2m_job_finish(ctx->mdp_dev->m2m_dev, ctx->m2m_ctx);
> > +}
> > +
> > +static void mtk_mdp_m2m_worker(struct work_struct *work)
> > +{
> > +	struct mtk_mdp_ctx *ctx =
> > +				container_of(work, struct mtk_mdp_ctx, work);
> > +	struct mtk_mdp_dev *mdp = ctx->mdp_dev;
> > +	enum vb2_buffer_state buf_state = VB2_BUF_STATE_ERROR;
> > +	int ret;
> > +
> > +	if (mtk_mdp_ctx_state_is_set(ctx, MTK_MDP_CTX_ERROR)) {
> > +		dev_err(&mdp->pdev->dev, "ctx is in error state");
> > +		goto worker_end;
> > +	}
> > +
> > +	mtk_mdp_m2m_get_bufs(ctx);
> > +
> > +	mtk_mdp_hw_set_input_addr(ctx, &ctx->s_frame.addr);
> > +	mtk_mdp_hw_set_output_addr(ctx, &ctx->d_frame.addr);
> > +
> > +	mtk_mdp_hw_set_in_size(ctx);
> > +	mtk_mdp_hw_set_in_image_format(ctx);
> > +
> > +	mtk_mdp_hw_set_out_size(ctx);
> > +	mtk_mdp_hw_set_out_image_format(ctx);
> > +
> > +	mtk_mdp_hw_set_rotation(ctx);
> > +	mtk_mdp_hw_set_global_alpha(ctx);
> > +
> > +	ret = mtk_mdp_vpu_process(&ctx->vpu);
> > +	if (ret) {
> > +		dev_err(&mdp->pdev->dev, "processing failed: %d", ret);
> > +		goto worker_end;
> > +	}
> > +
> > +	buf_state = VB2_BUF_STATE_DONE;
> > +
> > +worker_end:
> > +	mtk_mdp_process_done(mdp, buf_state);
> > +}
> > +
> > +static void mtk_mdp_m2m_device_run(void *priv)
> > +{
> > +	struct mtk_mdp_ctx *ctx = priv;
> > +
> > +	queue_work(ctx->mdp_dev->job_wq, &ctx->work);
> > +}
> > +
> > +static int mtk_mdp_m2m_queue_setup(struct vb2_queue *vq,
> > +			unsigned int *num_buffers, unsigned int *num_planes,
> > +			unsigned int sizes[], struct device *alloc_devs[])
> > +{
> > +	struct mtk_mdp_ctx *ctx = vb2_get_drv_priv(vq);
> > +	struct mtk_mdp_frame *frame;
> > +	int i;
> > +
> > +	frame = mtk_mdp_ctx_get_frame(ctx, vq->type);
> > +	*num_planes = frame->fmt->num_planes;
> > +	for (i = 0; i < frame->fmt->num_planes; i++)
> > +		sizes[i] = frame->payload[i];
> > +	mtk_mdp_dbg(2, "[%d] type:%d, planes:%d, buffers:%d, size:%u,%u",
> > +		    ctx->id, vq->type, *num_planes, *num_buffers,
> > +		    sizes[0], sizes[1]);
> > +	return 0;
> > +}
> > +
> > +static int mtk_mdp_m2m_buf_prepare(struct vb2_buffer *vb)
> > +{
> > +	struct mtk_mdp_ctx *ctx = vb2_get_drv_priv(vb->vb2_queue);
> > +	struct mtk_mdp_frame *frame;
> > +	int i;
> > +
> > +	frame = mtk_mdp_ctx_get_frame(ctx, vb->vb2_queue->type);
> > +
> > +	if (!V4L2_TYPE_IS_OUTPUT(vb->vb2_queue->type)) {
> > +		for (i = 0; i < frame->fmt->num_planes; i++)
> > +			vb2_set_plane_payload(vb, i, frame->payload[i]);
> > +	}
> > +
> > +	return 0;
> > +}
> > +
> > +static void mtk_mdp_m2m_buf_queue(struct vb2_buffer *vb)
> > +{
> > +	struct mtk_mdp_ctx *ctx = vb2_get_drv_priv(vb->vb2_queue);
> > +
> > +	v4l2_m2m_buf_queue(ctx->m2m_ctx, to_vb2_v4l2_buffer(vb));
> > +}
> > +
> > +static struct vb2_ops mtk_mdp_m2m_qops = {
> > +	.queue_setup	 = mtk_mdp_m2m_queue_setup,
> > +	.buf_prepare	 = mtk_mdp_m2m_buf_prepare,
> > +	.buf_queue	 = mtk_mdp_m2m_buf_queue,
> > +	.wait_prepare	 = mtk_mdp_ctx_unlock,
> > +	.wait_finish	 = mtk_mdp_ctx_lock,
> > +	.stop_streaming	 = mtk_mdp_m2m_stop_streaming,
> > +	.start_streaming = mtk_mdp_m2m_start_streaming,
> > +};
> > +
> > +static int mtk_mdp_m2m_querycap(struct file *file, void *fh,
> > +				struct v4l2_capability *cap)
> > +{
> > +	struct mtk_mdp_ctx *ctx = fh_to_ctx(fh);
> > +	struct mtk_mdp_dev *mdp = ctx->mdp_dev;
> > +
> > +	strlcpy(cap->driver, MTK_MDP_MODULE_NAME, sizeof(cap->driver));
> > +	strlcpy(cap->card, mdp->pdev->name, sizeof(cap->card));
> > +	strlcpy(cap->bus_info, "platform:mt8173", sizeof(cap->bus_info));
> > +	cap->device_caps = V4L2_CAP_STREAMING | V4L2_CAP_VIDEO_M2M_MPLANE;
> > +	cap->capabilities = cap->device_caps | V4L2_CAP_DEVICE_CAPS;
> 
> Fill in the new device_caps field of struct video_device instead. Once done
> you can drop these two lines as the core will fill them in for you.
> 

I will remove them.

> > +
> > +	return 0;
> > +}
> > +
> > +static int mtk_mdp_enum_fmt_mplane(struct v4l2_fmtdesc *f, u32 type)
> > +{
> > +	const struct mtk_mdp_fmt *fmt;
> > +
> > +	fmt = mtk_mdp_find_fmt_by_index(f->index, type);
> > +	if (!fmt)
> > +		return -EINVAL;
> > +
> > +	strlcpy(f->description, fmt->name, sizeof(f->description));
> 
> Drop this line. The v4l2 core will this in for you. You can probably drop fmt->name
> as well.
> 

I will remove them.

> > +	f->pixelformat = fmt->pixelformat;
> > +
> > +	return 0;
> > +}
> > +
> > +static int mtk_mdp_m2m_enum_fmt_mplane_vid_cap(struct file *file, void *priv,
> > +				       struct v4l2_fmtdesc *f)
> > +{
> > +	return mtk_mdp_enum_fmt_mplane(f, V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE);
> > +}
> > +
> > +static int mtk_mdp_m2m_enum_fmt_mplane_vid_out(struct file *file, void *priv,
> > +				       struct v4l2_fmtdesc *f)
> > +{
> > +	return mtk_mdp_enum_fmt_mplane(f, V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE);
> > +}
> > +
> > +static int mtk_mdp_g_fmt_mplane(struct mtk_mdp_ctx *ctx, struct v4l2_format *f)
> > +{
> > +	struct mtk_mdp_frame *frame;
> > +	struct v4l2_pix_format_mplane *pix_mp;
> > +	int i;
> > +
> > +	mtk_mdp_dbg(2, "[%d] type:%d", ctx->id, f->type);
> > +
> > +	frame = mtk_mdp_ctx_get_frame(ctx, f->type);
> > +	pix_mp = &f->fmt.pix_mp;
> > +
> > +	pix_mp->width = frame->width;
> > +	pix_mp->height = frame->height;
> > +	pix_mp->field = V4L2_FIELD_NONE;
> > +	pix_mp->pixelformat = frame->fmt->pixelformat;
> > +	pix_mp->num_planes = frame->fmt->num_planes;
> > +	mtk_mdp_dbg(2, "[%d] wxh:%dx%d", ctx->id,
> > +		    pix_mp->width, pix_mp->height);
> > +
> > +	for (i = 0; i < pix_mp->num_planes; ++i) {
> > +		pix_mp->plane_fmt[i].bytesperline = (frame->width *
> > +			frame->fmt->depth[i]) / 8;
> > +		pix_mp->plane_fmt[i].sizeimage =
> > +			 pix_mp->plane_fmt[i].bytesperline * frame->height;
> > +
> > +		mtk_mdp_dbg(2, "[%d] p%d, bpl:%d, sizeimage:%d", ctx->id, i,
> > +			    pix_mp->plane_fmt[i].bytesperline,
> > +			    pix_mp->plane_fmt[i].sizeimage);
> > +	}
> 
> Since this is a codec you will need to pass the colorspace-related format
> fields from the video output format to the video capture format.
> 
> I have added tests to v4l2-compliance to check for that. See also the
> vim2m reference driver and this vim2m patch:
> 
> https://patchwork.linuxtv.org/patch/35562/
> 

I will add them as patch 35562 and pull the latest v4l2-compliance to verify.

> > +
> > +	return 0;
> > +}
> > +
> > +static int mtk_mdp_m2m_g_fmt_mplane(struct file *file, void *fh,
> > +				    struct v4l2_format *f)
> > +{
> > +	struct mtk_mdp_ctx *ctx = fh_to_ctx(fh);
> > +
> > +	return mtk_mdp_g_fmt_mplane(ctx, f);
> > +}
> > +
> > +static int mtk_mdp_m2m_try_fmt_mplane(struct file *file, void *fh,
> > +				      struct v4l2_format *f)
> > +{
> > +	struct mtk_mdp_ctx *ctx = fh_to_ctx(fh);
> > +
> > +	if (!mtk_mdp_try_fmt_mplane(ctx, f))
> > +		return -EINVAL;
> > +	return 0;
> > +}
> > +
> > +static int mtk_mdp_m2m_s_fmt_mplane(struct file *file, void *fh,
> > +				    struct v4l2_format *f)
> > +{
> > +	struct mtk_mdp_ctx *ctx = fh_to_ctx(fh);
> > +	struct vb2_queue *vq;
> > +	struct mtk_mdp_frame *frame;
> > +	struct v4l2_pix_format_mplane *pix;
> > +	const struct mtk_mdp_fmt *fmt;
> > +	int i;
> > +
> > +	mtk_mdp_dbg(2, "[%d] type:%d", ctx->id, f->type);
> > +
> > +	frame = mtk_mdp_ctx_get_frame(ctx, f->type);
> > +	fmt = mtk_mdp_try_fmt_mplane(ctx, f);
> > +	if (!fmt) {
> > +		mtk_mdp_err("[%d] try_fmt failed, type:%d", ctx->id, f->type);
> > +		return -EINVAL;
> > +	}
> > +	frame->fmt = fmt;
> > +
> > +	vq = v4l2_m2m_get_vq(ctx->m2m_ctx, f->type);
> > +	if (vb2_is_streaming(vq)) {
> > +		dev_info(&ctx->mdp_dev->pdev->dev, "queue %d busy", f->type);
> > +		return -EBUSY;
> > +	}
> > +
> > +	pix = &f->fmt.pix_mp;
> > +	for (i = 0; i < frame->fmt->num_planes; i++) {
> > +		frame->payload[i] = pix->plane_fmt[i].sizeimage;
> > +		frame->pitch[i] = pix->plane_fmt[i].bytesperline;
> > +	}
> > +
> > +	mtk_mdp_set_frame_size(frame, pix->width, pix->height);
> > +
> > +	if (V4L2_TYPE_IS_OUTPUT(f->type))
> > +		mtk_mdp_ctx_state_lock_set(ctx, MTK_MDP_SRC_FMT);
> > +	else
> > +		mtk_mdp_ctx_state_lock_set(ctx, MTK_MDP_DST_FMT);
> > +
> > +	mtk_mdp_dbg(2, "[%d] type:%d, frame:%dx%d", ctx->id, f->type,
> > +		    frame->width, frame->height);
> > +
> > +	return 0;
> > +}
> > +
> > +static int mtk_mdp_m2m_reqbufs(struct file *file, void *fh,
> > +			       struct v4l2_requestbuffers *reqbufs)
> > +{
> > +	struct mtk_mdp_ctx *ctx = fh_to_ctx(fh);
> > +
> > +	if (reqbufs->count == 0) {
> > +		if (reqbufs->type == V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE)
> > +			mtk_mdp_ctx_state_lock_clear(ctx, MTK_MDP_SRC_FMT);
> > +		else
> > +			mtk_mdp_ctx_state_lock_clear(ctx, MTK_MDP_DST_FMT);
> > +	}
> > +
> > +	return v4l2_m2m_reqbufs(file, ctx->m2m_ctx, reqbufs);
> > +}
> > +
> > +static int mtk_mdp_m2m_querybuf(struct file *file, void *fh,
> > +				struct v4l2_buffer *buf)
> > +{
> > +	struct mtk_mdp_ctx *ctx = fh_to_ctx(fh);
> > +
> > +	return v4l2_m2m_querybuf(file, ctx->m2m_ctx, buf);
> > +}
> 
> Can't you use the v4l2_m2m_ioctl_* helpers here? See v4l2-mem2mem.h.
> 

I will modify it.

> > +
> > +static int mtk_mdp_m2m_qbuf(struct file *file, void *fh,
> > +			    struct v4l2_buffer *buf)
> > +{
> > +	struct mtk_mdp_ctx *ctx = fh_to_ctx(fh);
> > +
> > +	return v4l2_m2m_qbuf(file, ctx->m2m_ctx, buf);
> > +}
> > +
> > +static int mtk_mdp_m2m_dqbuf(struct file *file, void *fh,
> > +			     struct v4l2_buffer *buf)
> > +{
> > +	struct mtk_mdp_ctx *ctx = fh_to_ctx(fh);
> > +
> > +	return v4l2_m2m_dqbuf(file, ctx->m2m_ctx, buf);
> > +}
> > +
> > +static int mtk_mdp_m2m_streamon(struct file *file, void *fh,
> > +				enum v4l2_buf_type type)
> > +{
> > +	struct mtk_mdp_ctx *ctx = fh_to_ctx(fh);
> > +
> > +	/* The source and target color format need to be set */
> > +	if (V4L2_TYPE_IS_OUTPUT(type)) {
> > +		if (!mtk_mdp_ctx_state_is_set(ctx, MTK_MDP_SRC_FMT))
> > +			return -EINVAL;
> > +	} else if (!mtk_mdp_ctx_state_is_set(ctx, MTK_MDP_DST_FMT)) {
> > +		return -EINVAL;
> > +	}
> > +
> > +	return v4l2_m2m_streamon(file, ctx->m2m_ctx, type);
> > +}
> > +
> > +static int mtk_mdp_m2m_streamoff(struct file *file, void *fh,
> > +			    enum v4l2_buf_type type)
> > +{
> > +	struct mtk_mdp_ctx *ctx = fh_to_ctx(fh);
> > +
> > +	return v4l2_m2m_streamoff(file, ctx->m2m_ctx, type);
> > +}
> > +
> > +/*
> > + * Return true if rectangle a is enclosed in rectangle b, or false otherwise.
> > + */
> > +static bool mtk_mdp_m2m_is_rectangle_enclosed(struct v4l2_rect *a,
> > +					     struct v4l2_rect *b)
> > +{
> > +	if (a->left < b->left || a->top < b->top)
> > +		return false;
> > +
> > +	if (a->left + a->width > b->left + b->width)
> > +		return false;
> > +
> > +	if (a->top + a->height > b->top + b->height)
> > +		return false;
> > +
> > +	return true;
> > +}
> > +
> > +static int mtk_mdp_m2m_g_selection(struct file *file, void *fh,
> > +				   struct v4l2_selection *s)
> > +{
> > +	struct mtk_mdp_frame *frame;
> > +	struct mtk_mdp_ctx *ctx = fh_to_ctx(fh);
> > +
> > +	if ((s->type != V4L2_BUF_TYPE_VIDEO_CAPTURE) &&
> > +	    (s->type != V4L2_BUF_TYPE_VIDEO_OUTPUT))
> > +		return -EINVAL;
> > +
> > +	frame = mtk_mdp_ctx_get_frame(ctx, s->type);
> > +
> > +	switch (s->target) {
> > +	case V4L2_SEL_TGT_COMPOSE_DEFAULT:
> > +	case V4L2_SEL_TGT_COMPOSE_BOUNDS:
> > +	case V4L2_SEL_TGT_CROP_BOUNDS:
> > +	case V4L2_SEL_TGT_CROP_DEFAULT:
> > +		s->r.left = 0;
> > +		s->r.top = 0;
> > +		s->r.width = frame->width;
> > +		s->r.height = frame->height;
> > +		return 0;
> > +
> > +	case V4L2_SEL_TGT_COMPOSE:
> > +	case V4L2_SEL_TGT_CROP:
> > +		s->r.left = frame->crop.left;
> > +		s->r.top = frame->crop.top;
> > +		s->r.width = frame->crop.width;
> > +		s->r.height = frame->crop.height;
> > +		return 0;
> > +	}
> 
> This is almost certainly wrong. Unless I am mistaken you support cropping of
> the memory buffer for video output, and composing into a memory buffer for video
> capture. That's the standard behavior for codecs.
> 
> The code above reports both composing and cropping for both capture and output,
> and that's not right. Same in s_selection.
> 

MTK MDP supports to crop source and destination buffer.


> > +
> > +	return -EINVAL;
> > +}
> > +
> > +static int mtk_mdp_check_scaler_ratio(struct mtk_mdp_variant *var, int src_w,
> > +				      int src_h, int dst_w, int dst_h, int rot)
> > +{
> > +	int tmp_w, tmp_h;
> > +
> > +	if (rot == 90 || rot == 270) {
> > +		tmp_w = dst_h;
> > +		tmp_h = dst_w;
> > +	} else {
> > +		tmp_w = dst_w;
> > +		tmp_h = dst_h;
> > +	}
> > +
> > +	if ((src_w / tmp_w) > var->h_scale_down_max ||
> > +	    (src_h / tmp_h) > var->v_scale_down_max ||
> > +	    (tmp_w / src_w) > var->h_scale_up_max ||
> > +	    (tmp_h / src_h) > var->v_scale_up_max)
> > +		return -EINVAL;
> > +
> > +	return 0;
> > +}
> > +
> > +static int mtk_mdp_m2m_s_selection(struct file *file, void *fh,
> > +				   struct v4l2_selection *s)
> > +{
> > +	struct mtk_mdp_frame *frame;
> > +	struct mtk_mdp_ctx *ctx = fh_to_ctx(fh);
> > +	struct v4l2_crop cr;
> > +	struct mtk_mdp_variant *variant = ctx->mdp_dev->variant;
> > +	int ret;
> > +
> > +	cr.type = s->type;
> > +	cr.c = s->r;
> > +
> > +	if ((s->type != V4L2_BUF_TYPE_VIDEO_CAPTURE) &&
> > +	    (s->type != V4L2_BUF_TYPE_VIDEO_OUTPUT))
> > +		return -EINVAL;
> > +
> > +	ret = mtk_mdp_try_crop(ctx, &cr);
> > +	if (ret)
> > +		return ret;
> > +
> > +	if (s->flags & V4L2_SEL_FLAG_LE &&
> > +	    !mtk_mdp_m2m_is_rectangle_enclosed(&cr.c, &s->r))
> > +		return -ERANGE;
> > +
> > +	if (s->flags & V4L2_SEL_FLAG_GE &&
> > +	    !mtk_mdp_m2m_is_rectangle_enclosed(&s->r, &cr.c))
> > +		return -ERANGE;
> > +
> > +	s->r = cr.c;
> > +
> > +	switch (s->target) {
> > +	case V4L2_SEL_TGT_COMPOSE_BOUNDS:
> > +	case V4L2_SEL_TGT_COMPOSE_DEFAULT:
> > +	case V4L2_SEL_TGT_COMPOSE:
> > +		frame = &ctx->s_frame;
> > +		break;
> > +
> > +	case V4L2_SEL_TGT_CROP_BOUNDS:
> > +	case V4L2_SEL_TGT_CROP:
> > +	case V4L2_SEL_TGT_CROP_DEFAULT:
> > +		frame = &ctx->d_frame;
> > +		break;
> > +
> > +	default:
> > +		return -EINVAL;
> > +	}
> > +
> > +	/* Check to see if scaling ratio is within supported range */
> > +	if (mtk_mdp_ctx_state_is_set(ctx, MTK_MDP_DST_FMT | MTK_MDP_SRC_FMT)) {
> > +		if (V4L2_TYPE_IS_OUTPUT(s->type)) {
> > +			ret = mtk_mdp_check_scaler_ratio(variant, cr.c.width,
> > +				cr.c.height, ctx->d_frame.crop.width,
> > +				ctx->d_frame.crop.height,
> > +				ctx->ctrls.rotate->val);
> > +		} else {
> > +			ret = mtk_mdp_check_scaler_ratio(variant,
> > +				ctx->s_frame.crop.width,
> > +				ctx->s_frame.crop.height, cr.c.width,
> > +				cr.c.height, ctx->ctrls.rotate->val);
> > +		}
> > +
> > +		if (ret) {
> > +			dev_info(&ctx->mdp_dev->pdev->dev,
> > +				"Out of scaler range");
> > +			return -EINVAL;
> > +		}
> > +	}
> > +
> > +	frame->crop = cr.c;
> > +
> > +	return 0;
> > +}
> > +
> > +static const struct v4l2_ioctl_ops mtk_mdp_m2m_ioctl_ops = {
> > +	.vidioc_querycap		= mtk_mdp_m2m_querycap,
> > +	.vidioc_enum_fmt_vid_cap_mplane	= mtk_mdp_m2m_enum_fmt_mplane_vid_cap,
> > +	.vidioc_enum_fmt_vid_out_mplane	= mtk_mdp_m2m_enum_fmt_mplane_vid_out,
> > +	.vidioc_g_fmt_vid_cap_mplane	= mtk_mdp_m2m_g_fmt_mplane,
> > +	.vidioc_g_fmt_vid_out_mplane	= mtk_mdp_m2m_g_fmt_mplane,
> > +	.vidioc_try_fmt_vid_cap_mplane	= mtk_mdp_m2m_try_fmt_mplane,
> > +	.vidioc_try_fmt_vid_out_mplane	= mtk_mdp_m2m_try_fmt_mplane,
> > +	.vidioc_s_fmt_vid_cap_mplane	= mtk_mdp_m2m_s_fmt_mplane,
> > +	.vidioc_s_fmt_vid_out_mplane	= mtk_mdp_m2m_s_fmt_mplane,
> > +	.vidioc_reqbufs			= mtk_mdp_m2m_reqbufs,
> > +	.vidioc_create_bufs		= v4l2_m2m_ioctl_create_bufs,
> > +	.vidioc_expbuf			= v4l2_m2m_ioctl_expbuf,
> > +	.vidioc_subscribe_event		= v4l2_ctrl_subscribe_event,
> > +	.vidioc_unsubscribe_event	= v4l2_event_unsubscribe,
> > +	.vidioc_querybuf		= mtk_mdp_m2m_querybuf,
> > +	.vidioc_qbuf			= mtk_mdp_m2m_qbuf,
> > +	.vidioc_dqbuf			= mtk_mdp_m2m_dqbuf,
> > +	.vidioc_streamon		= mtk_mdp_m2m_streamon,
> > +	.vidioc_streamoff		= mtk_mdp_m2m_streamoff,
> > +	.vidioc_g_selection		= mtk_mdp_m2m_g_selection,
> > +	.vidioc_s_selection		= mtk_mdp_m2m_s_selection
> > +};
> > +
> > +static int mtk_mdp_m2m_queue_init(void *priv, struct vb2_queue *src_vq,
> > +				  struct vb2_queue *dst_vq)
> > +{
> > +	struct mtk_mdp_ctx *ctx = priv;
> > +	int ret;
> > +
> > +	memset(src_vq, 0, sizeof(*src_vq));
> > +	src_vq->type = V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE;
> > +	src_vq->io_modes = VB2_MMAP | VB2_USERPTR | VB2_DMABUF;
> > +	src_vq->drv_priv = ctx;
> > +	src_vq->ops = &mtk_mdp_m2m_qops;
> > +	src_vq->mem_ops = &vb2_dma_contig_memops;
> > +	src_vq->buf_struct_size = sizeof(struct v4l2_m2m_buffer);
> > +	src_vq->timestamp_flags = V4L2_BUF_FLAG_TIMESTAMP_COPY;
> 
> Shouldn't src_vq->dev be filled in here?
> 

It is failed to allocate dma really. I have fixed it. Thanks

> > +
> > +	ret = vb2_queue_init(src_vq);
> > +	if (ret)
> > +		return ret;
> > +
> > +	memset(dst_vq, 0, sizeof(*dst_vq));
> > +	dst_vq->type = V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE;
> > +	dst_vq->io_modes = VB2_MMAP | VB2_USERPTR | VB2_DMABUF;
> > +	dst_vq->drv_priv = ctx;
> > +	dst_vq->ops = &mtk_mdp_m2m_qops;
> > +	dst_vq->mem_ops = &vb2_dma_contig_memops;
> > +	dst_vq->buf_struct_size = sizeof(struct v4l2_m2m_buffer);
> > +	dst_vq->timestamp_flags = V4L2_BUF_FLAG_TIMESTAMP_COPY;
> 
> and here?
> 
> Otherwise the dma-contig code won't know the right struct device pointer to
> use for the DMA.
> 
> I'm a bit surprised that this works, actually.
> 

The same as src_vq. I have fixed it. Thanks.

> > +
> > +	return vb2_queue_init(dst_vq);
> > +}
> > +
> > +static int mtk_mdp_s_ctrl(struct v4l2_ctrl *ctrl)
> > +{
> > +	struct mtk_mdp_ctx *ctx = ctrl_to_ctx(ctrl);
> > +	struct mtk_mdp_dev *mdp = ctx->mdp_dev;
> > +	struct mtk_mdp_variant *variant = mdp->variant;
> > +	u32 state = MTK_MDP_DST_FMT | MTK_MDP_SRC_FMT;
> > +	int ret = 0;
> > +
> > +	if (ctrl->flags & V4L2_CTRL_FLAG_INACTIVE)
> > +		return 0;
> > +
> > +	switch (ctrl->id) {
> > +	case V4L2_CID_HFLIP:
> > +		ctx->hflip = ctrl->val;
> > +		break;
> > +	case V4L2_CID_VFLIP:
> > +		ctx->vflip = ctrl->val;
> > +		break;
> > +	case V4L2_CID_ROTATE:
> > +		if (mtk_mdp_ctx_state_is_set(ctx, state)) {
> > +			ret = mtk_mdp_check_scaler_ratio(variant,
> > +					ctx->s_frame.crop.width,
> > +					ctx->s_frame.crop.height,
> > +					ctx->d_frame.crop.width,
> > +					ctx->d_frame.crop.height,
> > +					ctx->ctrls.rotate->val);
> > +
> > +			if (ret)
> > +				return -EINVAL;
> > +		}
> > +
> > +		ctx->rotation = ctrl->val;
> > +		break;
> > +	case V4L2_CID_ALPHA_COMPONENT:
> > +		ctx->d_frame.alpha = ctrl->val;
> > +		break;
> > +	}
> > +
> > +	return 0;
> > +}
> > +
> > +static const struct v4l2_ctrl_ops mtk_mdp_ctrl_ops = {
> > +	.s_ctrl = mtk_mdp_s_ctrl,
> > +};
> > +
> > +static int mtk_mdp_ctrls_create(struct mtk_mdp_ctx *ctx)
> > +{
> > +	v4l2_ctrl_handler_init(&ctx->ctrl_handler, MTK_MDP_MAX_CTRL_NUM);
> > +
> > +	ctx->ctrls.rotate = v4l2_ctrl_new_std(&ctx->ctrl_handler,
> > +			&mtk_mdp_ctrl_ops, V4L2_CID_ROTATE, 0, 270, 90, 0);
> > +	ctx->ctrls.hflip = v4l2_ctrl_new_std(&ctx->ctrl_handler,
> > +					     &mtk_mdp_ctrl_ops,
> > +					     V4L2_CID_HFLIP,
> > +					     0, 1, 1, 0);
> > +	ctx->ctrls.vflip = v4l2_ctrl_new_std(&ctx->ctrl_handler,
> > +					     &mtk_mdp_ctrl_ops,
> > +					     V4L2_CID_VFLIP,
> > +					     0, 1, 1, 0);
> > +	ctx->ctrls.global_alpha = v4l2_ctrl_new_std(&ctx->ctrl_handler,
> > +						    &mtk_mdp_ctrl_ops,
> > +						    V4L2_CID_ALPHA_COMPONENT,
> > +						    0, 255, 1, 0);
> > +	ctx->ctrls_rdy = ctx->ctrl_handler.error == 0;
> > +
> > +	if (ctx->ctrl_handler.error) {
> > +		int err = ctx->ctrl_handler.error;
> > +
> > +		v4l2_ctrl_handler_free(&ctx->ctrl_handler);
> > +		dev_err(&ctx->mdp_dev->pdev->dev,
> > +			"Failed to create control handlers\n");
> > +		return err;
> > +	}
> > +
> > +	return 0;
> > +}
> > +
> > +static void mtk_mdp_set_default_params(struct mtk_mdp_ctx *ctx)
> > +{
> > +	struct mtk_mdp_dev *mdp = ctx->mdp_dev;
> > +	struct mtk_mdp_frame *frame;
> > +
> > +	frame = mtk_mdp_ctx_get_frame(ctx, V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE);
> > +	frame->fmt = mtk_mdp_find_fmt_by_index(0,
> > +					V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE);
> > +	frame->width = mdp->variant->pix_min->org_w;
> > +	frame->height = mdp->variant->pix_min->org_h;
> > +	frame->payload[0] = frame->width * frame->height;
> > +	frame->payload[1] = frame->payload[0] / 2;
> > +
> > +	frame = mtk_mdp_ctx_get_frame(ctx, V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE);
> > +	frame->fmt = mtk_mdp_find_fmt_by_index(0,
> > +					V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE);
> > +	frame->width = mdp->variant->pix_min->target_rot_dis_w;
> > +	frame->height = mdp->variant->pix_min->target_rot_dis_h;
> > +	frame->payload[0] = frame->width * frame->height;
> > +	frame->payload[1] = frame->payload[0] / 2;
> > +
> > +}
> > +
> > +static int mtk_mdp_m2m_open(struct file *file)
> > +{
> > +	struct mtk_mdp_dev *mdp = video_drvdata(file);
> > +	struct video_device *vfd = video_devdata(file);
> > +	struct mtk_mdp_ctx *ctx = NULL;
> > +	int ret;
> > +
> > +	if (mutex_lock_interruptible(&mdp->lock))
> > +		return -ERESTARTSYS;
> > +
> > +	ctx = kzalloc(sizeof(*ctx), GFP_KERNEL);
> > +	if (!ctx) {
> > +		ret = -ENOMEM;
> > +		goto err_ctx_alloc;
> > +	}
> > +
> > +	mutex_init(&ctx->slock);
> > +	ctx->id = mdp->id_counter++;
> > +	v4l2_fh_init(&ctx->fh, vfd);
> > +	file->private_data = &ctx->fh;
> > +	ret = mtk_mdp_ctrls_create(ctx);
> > +	if (ret)
> > +		goto error_ctrls;
> > +
> > +	/* Use separate control handler per file handle */
> > +	ctx->fh.ctrl_handler = &ctx->ctrl_handler;
> > +	v4l2_fh_add(&ctx->fh);
> > +	INIT_LIST_HEAD(&ctx->list);
> > +
> > +	ctx->mdp_dev = mdp;
> > +	mtk_mdp_set_default_params(ctx);
> > +
> > +	INIT_WORK(&ctx->work, mtk_mdp_m2m_worker);
> > +	ctx->m2m_ctx = v4l2_m2m_ctx_init(mdp->m2m_dev, ctx,
> > +					 mtk_mdp_m2m_queue_init);
> > +	if (IS_ERR(ctx->m2m_ctx)) {
> > +		dev_err(&mdp->pdev->dev, "Failed to initialize m2m context");
> > +		ret = PTR_ERR(ctx->m2m_ctx);
> > +		goto error_m2m_ctx;
> > +	}
> > +	ctx->fh.m2m_ctx = ctx->m2m_ctx;
> > +	if (mdp->ctx_num++ == 0) {
> > +		ret = vpu_load_firmware(mdp->vpu_dev);
> > +		if (ret < 0) {
> > +			dev_err(&mdp->pdev->dev,
> > +				"vpu_load_firmware failed %d\n", ret);
> > +			goto err_load_vpu;
> > +		}
> > +
> > +		ret = mtk_mdp_vpu_register(mdp->pdev);
> > +		if (ret < 0) {
> > +			dev_err(&mdp->pdev->dev,
> > +				"mdp_vpu register failed %d\n", ret);
> > +			goto err_load_vpu;
> > +		}
> > +	}
> > +
> > +	ret = mtk_mdp_vpu_init(&ctx->vpu);
> > +	if (ret < 0) {
> > +		dev_err(&mdp->pdev->dev, "Initialize vpu failed %d\n", ret);
> > +		ret = -EINVAL;
> > +		goto err_load_vpu;
> > +	}
> > +	list_add(&ctx->list, &mdp->ctx_list);
> > +	mutex_unlock(&mdp->lock);
> > +
> > +	mtk_mdp_dbg(0, "%s [%d]", dev_name(&mdp->pdev->dev), ctx->id);
> > +
> > +	return 0;
> > +
> > +err_load_vpu:
> > +	mdp->ctx_num--;
> > +	v4l2_m2m_ctx_release(ctx->m2m_ctx);
> > +error_m2m_ctx:
> > +	v4l2_ctrl_handler_free(&ctx->ctrl_handler);
> > +error_ctrls:
> > +	v4l2_fh_del(&ctx->fh);
> > +	v4l2_fh_exit(&ctx->fh);
> > +err_ctx_alloc:
> > +	kfree(ctx);
> > +	mutex_unlock(&mdp->lock);
> > +
> > +	return ret;
> > +}
> > +
> > +static int mtk_mdp_m2m_release(struct file *file)
> > +{
> > +	struct mtk_mdp_ctx *ctx = fh_to_ctx(file->private_data);
> > +	struct mtk_mdp_dev *mdp = ctx->mdp_dev;
> > +
> > +	flush_workqueue(mdp->job_wq);
> > +	mutex_lock(&mdp->lock);
> > +	v4l2_m2m_ctx_release(ctx->m2m_ctx);
> > +	v4l2_ctrl_handler_free(&ctx->ctrl_handler);
> > +	v4l2_fh_del(&ctx->fh);
> > +	v4l2_fh_exit(&ctx->fh);
> > +	mtk_mdp_vpu_deinit(&ctx->vpu);
> > +	mdp->ctx_num--;
> > +	list_del_init(&ctx->list);
> > +
> > +	mtk_mdp_dbg(0, "%s [%d]", dev_name(&mdp->pdev->dev), ctx->id);
> > +
> > +	mutex_unlock(&mdp->lock);
> > +	kfree(ctx);
> > +
> > +	return 0;
> > +}
> > +
> > +static unsigned int mtk_mdp_m2m_poll(struct file *file,
> > +				     struct poll_table_struct *wait)
> > +{
> > +	struct mtk_mdp_ctx *ctx = fh_to_ctx(file->private_data);
> > +	struct mtk_mdp_dev *mdp = ctx->mdp_dev;
> > +	int ret;
> > +
> > +	if (mutex_lock_interruptible(&mdp->lock))
> > +		return -ERESTARTSYS;
> > +
> > +	ret = v4l2_m2m_poll(file, ctx->m2m_ctx, wait);
> > +	mutex_unlock(&mdp->lock);
> > +
> > +	return ret;
> > +}
> > +
> > +static int mtk_mdp_m2m_mmap(struct file *file, struct vm_area_struct *vma)
> > +{
> > +	struct mtk_mdp_ctx *ctx = fh_to_ctx(file->private_data);
> > +	struct mtk_mdp_dev *mdp = ctx->mdp_dev;
> > +	int ret;
> > +
> > +	if (mutex_lock_interruptible(&mdp->lock))
> > +		return -ERESTARTSYS;
> > +
> > +	ret = v4l2_m2m_mmap(file, ctx->m2m_ctx, vma);
> > +	mutex_unlock(&mdp->lock);
> > +
> > +	return ret;
> 
> Can you use the v4l2-mem2mem helpers for mmap and poll?
> 

I will modify them.

> > +}
> > +
> > +static const struct v4l2_file_operations mtk_mdp_m2m_fops = {
> > +	.owner		= THIS_MODULE,
> > +	.open		= mtk_mdp_m2m_open,
> > +	.release	= mtk_mdp_m2m_release,
> > +	.poll		= mtk_mdp_m2m_poll,
> > +	.unlocked_ioctl	= video_ioctl2,
> > +	.mmap		= mtk_mdp_m2m_mmap,
> > +};
> > +
> > +static struct v4l2_m2m_ops mtk_mdp_m2m_ops = {
> > +	.device_run	= mtk_mdp_m2m_device_run,
> > +	.job_abort	= mtk_mdp_m2m_job_abort,
> > +};
> > +
> > +int mtk_mdp_register_m2m_device(struct mtk_mdp_dev *mdp)
> > +{
> > +	struct device *dev = &mdp->pdev->dev;
> > +	int ret;
> > +
> > +	mdp->variant = &mtk_mdp_default_variant;
> > +	mdp->vdev.device_caps = V4L2_CAP_VIDEO_M2M_MPLANE | V4L2_CAP_STREAMING;
> > +	mdp->vdev.fops = &mtk_mdp_m2m_fops;
> > +	mdp->vdev.ioctl_ops = &mtk_mdp_m2m_ioctl_ops;
> > +	mdp->vdev.release = video_device_release_empty;
> > +	mdp->vdev.lock = &mdp->lock;
> > +	mdp->vdev.vfl_dir = VFL_DIR_M2M;
> > +	mdp->vdev.v4l2_dev = &mdp->v4l2_dev;
> > +	snprintf(mdp->vdev.name, sizeof(mdp->vdev.name), "%s:m2m",
> > +		 MTK_MDP_MODULE_NAME);
> > +	video_set_drvdata(&mdp->vdev, mdp);
> > +
> > +	mdp->m2m_dev = v4l2_m2m_init(&mtk_mdp_m2m_ops);
> > +	if (IS_ERR(mdp->m2m_dev)) {
> > +		dev_err(dev, "failed to initialize v4l2-m2m device\n");
> > +		ret = PTR_ERR(mdp->m2m_dev);
> > +		goto err_m2m_init;
> > +	}
> > +
> > +	ret = video_register_device(&mdp->vdev, VFL_TYPE_GRABBER, 2);
> > +	if (ret) {
> > +		dev_err(dev, "failed to register video device\n");
> > +		goto err_vdev_register;
> > +	}
> > +
> > +	v4l2_info(&mdp->v4l2_dev, "driver registered as /dev/video%d",
> > +		  mdp->vdev.num);
> > +	return 0;
> > +
> > +err_vdev_register:
> > +	v4l2_m2m_release(mdp->m2m_dev);
> > +err_m2m_init:
> > +	video_device_release(&mdp->vdev);
> > +
> > +	return ret;
> > +}
> > +
> > +void mtk_mdp_unregister_m2m_device(struct mtk_mdp_dev *mdp)
> > +{
> > +	video_device_release(&mdp->vdev);
> > +	v4l2_m2m_release(mdp->m2m_dev);
> > +}
> > diff --git a/drivers/media/platform/mtk-mdp/mtk_mdp_m2m.h b/drivers/media/platform/mtk-mdp/mtk_mdp_m2m.h
> > new file mode 100644
> > index 0000000..45afd36
> > --- /dev/null
> > +++ b/drivers/media/platform/mtk-mdp/mtk_mdp_m2m.h
> > @@ -0,0 +1,22 @@
> > +/*
> > + * Copyright (c) 2016 MediaTek Inc.
> > + * Author: Ming Hsiu Tsai <minghsiu.tsai@mediatek.com>
> > + *
> > + * This program is free software; you can redistribute it and/or modify
> > + * it under the terms of the GNU General Public License version 2 as
> > + * published by the Free Software Foundation.
> > + *
> > + * This program is distributed in the hope that it will be useful,
> > + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> > + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> > + * GNU General Public License for more details.
> > + */
> > +
> > +#ifndef __MTK_MDP_M2M_H__
> > +#define __MTK_MDP_M2M_H__
> > +
> > +void mtk_mdp_ctx_state_lock_set(struct mtk_mdp_ctx *ctx, u32 state);
> > +int mtk_mdp_register_m2m_device(struct mtk_mdp_dev *mdp);
> > +void mtk_mdp_unregister_m2m_device(struct mtk_mdp_dev *mdp);
> > +
> > +#endif /* __MTK_MDP_M2M_H__ */
> > diff --git a/drivers/media/platform/mtk-mdp/mtk_mdp_regs.c b/drivers/media/platform/mtk-mdp/mtk_mdp_regs.c
> > new file mode 100644
> > index 0000000..063e7b1
> > --- /dev/null
> > +++ b/drivers/media/platform/mtk-mdp/mtk_mdp_regs.c
> > @@ -0,0 +1,153 @@
> > +/*
> > + * Copyright (c) 2015-2016 MediaTek Inc.
> > + * Author: Houlong Wei <houlong.wei@mediatek.com>
> > + *         Ming Hsiu Tsai <minghsiu.tsai@mediatek.com>
> > + *
> > + * This program is free software; you can redistribute it and/or modify
> > + * it under the terms of the GNU General Public License version 2 as
> > + * published by the Free Software Foundation.
> > + *
> > + * This program is distributed in the hope that it will be useful,
> > + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> > + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> > + * GNU General Public License for more details.
> > + */
> > +
> > +#include <linux/platform_device.h>
> > +
> > +#include "mtk_mdp_core.h"
> > +#include "mtk_mdp_regs.h"
> > +
> > +
> > +#define MDP_COLORFMT_PACK(VIDEO, PLANE, COPLANE, HF, VF, BITS, GROUP, SWAP, ID)\
> > +	(((VIDEO) << 27) | ((PLANE) << 24) | ((COPLANE) << 22) |\
> > +	((HF) << 20) | ((VF) << 18) | ((BITS) << 8) | ((GROUP) << 6) |\
> > +	((SWAP) << 5) | ((ID) << 0))
> > +
> > +enum MDP_COLOR_ENUM {
> > +	MDP_COLOR_UNKNOWN = 0,
> > +	MDP_COLOR_NV12 = MDP_COLORFMT_PACK(0, 2, 1, 1, 1, 8, 1, 0, 12),
> > +	MDP_COLOR_I420 = MDP_COLORFMT_PACK(0, 3, 0, 1, 1, 8, 1, 0, 8),
> > +	/* Mediatek proprietary format */
> > +	MDP_COLOR_420_MT21 = MDP_COLORFMT_PACK(5, 2, 1, 1, 1, 256, 1, 0, 12),
> > +};
> > +
> > +static int32_t mtk_mdp_map_color_format(int v4l2_format)
> > +{
> > +	switch (v4l2_format) {
> > +	case V4L2_PIX_FMT_NV12M:
> > +	case V4L2_PIX_FMT_NV12:
> > +		return MDP_COLOR_NV12;
> > +	case V4L2_PIX_FMT_MT21:
> > +		return MDP_COLOR_420_MT21;
> > +	case V4L2_PIX_FMT_YUV420M:
> > +	case V4L2_PIX_FMT_YUV420:
> > +		return MDP_COLOR_I420;
> > +	}
> > +
> > +	mtk_mdp_err("Unknown format 0x%x", v4l2_format);
> > +
> > +	return MDP_COLOR_UNKNOWN;
> > +}
> > +
> > +void mtk_mdp_hw_set_input_addr(struct mtk_mdp_ctx *ctx,
> > +			       struct mtk_mdp_addr *addr)
> > +{
> > +	struct mdp_buffer *src_buf = &ctx->vpu.vsi->src_buffer;
> > +	int i;
> > +
> > +	for (i = 0; i < ARRAY_SIZE(addr->addr); i++)
> > +		src_buf->addr_mva[i] = (uint64_t)addr->addr[i];
> > +}
> > +
> > +void mtk_mdp_hw_set_output_addr(struct mtk_mdp_ctx *ctx,
> > +				struct mtk_mdp_addr *addr)
> > +{
> > +	struct mdp_buffer *dst_buf = &ctx->vpu.vsi->dst_buffer;
> > +	int i;
> > +
> > +	for (i = 0; i < ARRAY_SIZE(addr->addr); i++)
> > +		dst_buf->addr_mva[i] = (uint64_t)addr->addr[i];
> > +}
> > +
> > +void mtk_mdp_hw_set_in_size(struct mtk_mdp_ctx *ctx)
> > +{
> > +	struct mtk_mdp_frame *frame = &ctx->s_frame;
> > +	struct mdp_config *config = &ctx->vpu.vsi->src_config;
> > +
> > +	/* Set input pixel offset */
> > +	config->crop_x = frame->crop.left;
> > +	config->crop_y = frame->crop.top;
> > +
> > +	/* Set input cropped size */
> > +	config->crop_w = frame->crop.width;
> > +	config->crop_h = frame->crop.height;
> > +
> > +	/* Set input original size */
> > +	config->x = 0;
> > +	config->y = 0;
> > +	config->w = frame->width;
> > +	config->h = frame->height;
> > +}
> > +
> > +void mtk_mdp_hw_set_in_image_format(struct mtk_mdp_ctx *ctx)
> > +{
> > +	unsigned int i;
> > +	struct mtk_mdp_frame *frame = &ctx->s_frame;
> > +	struct mdp_config *config = &ctx->vpu.vsi->src_config;
> > +	struct mdp_buffer *src_buf = &ctx->vpu.vsi->src_buffer;
> > +
> > +	src_buf->plane_num = frame->fmt->num_planes;
> > +	config->format = mtk_mdp_map_color_format(frame->fmt->pixelformat);
> > +	config->w_stride = 0; /* MDP will calculate it by color format. */
> > +	config->h_stride = 0; /* MDP will calculate it by color format. */
> > +
> > +	for (i = 0; i < src_buf->plane_num; i++)
> > +		src_buf->plane_size[i] = frame->payload[i];
> > +}
> > +
> > +void mtk_mdp_hw_set_out_size(struct mtk_mdp_ctx *ctx)
> > +{
> > +	struct mtk_mdp_frame *frame = &ctx->d_frame;
> > +	struct mdp_config *config = &ctx->vpu.vsi->dst_config;
> > +
> > +	config->crop_x = frame->crop.left;
> > +	config->crop_y = frame->crop.top;
> > +	config->crop_w = frame->crop.width;
> > +	config->crop_h = frame->crop.height;
> > +	config->x = 0;
> > +	config->y = 0;
> > +	config->w = frame->width;
> > +	config->h = frame->height;
> > +}
> > +
> > +void mtk_mdp_hw_set_out_image_format(struct mtk_mdp_ctx *ctx)
> > +{
> > +	unsigned int i;
> > +	struct mtk_mdp_frame *frame = &ctx->d_frame;
> > +	struct mdp_config *config = &ctx->vpu.vsi->dst_config;
> > +	struct mdp_buffer *dst_buf = &ctx->vpu.vsi->dst_buffer;
> > +
> > +	dst_buf->plane_num = frame->fmt->num_planes;
> > +	config->format = mtk_mdp_map_color_format(frame->fmt->pixelformat);
> > +	config->w_stride = 0; /* MDP will calculate it by color format. */
> > +	config->h_stride = 0; /* MDP will calculate it by color format. */
> > +	for (i = 0; i < dst_buf->plane_num; i++)
> > +		dst_buf->plane_size[i] = frame->payload[i];
> > +}
> > +
> > +void mtk_mdp_hw_set_rotation(struct mtk_mdp_ctx *ctx)
> > +{
> > +	struct mdp_config_misc *misc = &ctx->vpu.vsi->misc;
> > +
> > +	misc->orientation = ctx->ctrls.rotate->val;
> > +	misc->hflip = ctx->ctrls.hflip->val;
> > +	misc->vflip = ctx->ctrls.vflip->val;
> > +}
> > +
> > +void mtk_mdp_hw_set_global_alpha(struct mtk_mdp_ctx *ctx)
> > +{
> > +	struct mdp_config_misc *misc = &ctx->vpu.vsi->misc;
> > +
> > +	misc->alpha = ctx->ctrls.global_alpha->val;
> > +}
> > diff --git a/drivers/media/platform/mtk-mdp/mtk_mdp_regs.h b/drivers/media/platform/mtk-mdp/mtk_mdp_regs.h
> > new file mode 100644
> > index 0000000..42bd057
> > --- /dev/null
> > +++ b/drivers/media/platform/mtk-mdp/mtk_mdp_regs.h
> > @@ -0,0 +1,31 @@
> > +/*
> > + * Copyright (c) 2016 MediaTek Inc.
> > + * Author: Ming Hsiu Tsai <minghsiu.tsai@mediatek.com>
> > + *
> > + * This program is free software; you can redistribute it and/or modify
> > + * it under the terms of the GNU General Public License version 2 as
> > + * published by the Free Software Foundation.
> > + *
> > + * This program is distributed in the hope that it will be useful,
> > + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> > + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> > + * GNU General Public License for more details.
> > + */
> > +
> > +#ifndef __MTK_MDP_REGS_H__
> > +#define __MTK_MDP_REGS_H__
> > +
> > +
> > +void mtk_mdp_hw_set_input_addr(struct mtk_mdp_ctx *ctx,
> > +			       struct mtk_mdp_addr *addr);
> > +void mtk_mdp_hw_set_output_addr(struct mtk_mdp_ctx *ctx,
> > +				struct mtk_mdp_addr *addr);
> > +void mtk_mdp_hw_set_in_size(struct mtk_mdp_ctx *ctx);
> > +void mtk_mdp_hw_set_in_image_format(struct mtk_mdp_ctx *ctx);
> > +void mtk_mdp_hw_set_out_size(struct mtk_mdp_ctx *ctx);
> > +void mtk_mdp_hw_set_out_image_format(struct mtk_mdp_ctx *ctx);
> > +void mtk_mdp_hw_set_rotation(struct mtk_mdp_ctx *ctx);
> > +void mtk_mdp_hw_set_global_alpha(struct mtk_mdp_ctx *ctx);
> > +
> > +
> > +#endif /* __MTK_MDP_REGS_H__ */
> > diff --git a/drivers/media/platform/mtk-mdp/mtk_mdp_vpu.c b/drivers/media/platform/mtk-mdp/mtk_mdp_vpu.c
> > new file mode 100644
> > index 0000000..850376a
> > --- /dev/null
> > +++ b/drivers/media/platform/mtk-mdp/mtk_mdp_vpu.c
> > @@ -0,0 +1,140 @@
> > +/*
> > + * Copyright (c) 2015-2016 MediaTek Inc.
> > + * Author: Houlong Wei <houlong.wei@mediatek.com>
> > + *         Ming Hsiu Tsai <minghsiu.tsai@mediatek.com>
> > + *
> > + * This program is free software; you can redistribute it and/or modify
> > + * it under the terms of the GNU General Public License version 2 as
> > + * published by the Free Software Foundation.
> > + *
> > + * This program is distributed in the hope that it will be useful,
> > + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> > + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> > + * GNU General Public License for more details.
> > + */
> > +
> > +#include "mtk_mdp_core.h"
> > +#include "mtk_mdp_vpu.h"
> > +#include "mtk_vpu.h"
> > +
> > +
> > +static inline struct mtk_mdp_ctx *vpu_to_ctx(struct mtk_mdp_vpu *vpu)
> > +{
> > +	return container_of(vpu, struct mtk_mdp_ctx, vpu);
> > +}
> > +
> > +static void mtk_mdp_vpu_handle_init_ack(struct mdp_ipi_comm_ack *msg)
> > +{
> > +	struct mtk_mdp_vpu *vpu = (struct mtk_mdp_vpu *)msg->ap_inst;
> > +
> > +	/* mapping VPU address to kernel virtual address */
> > +	vpu->vsi = (struct mdp_process_vsi *)
> > +			vpu_mapping_dm_addr(vpu->pdev, msg->vpu_inst_addr);
> > +	vpu->inst_addr = msg->vpu_inst_addr;
> > +}
> > +
> > +static void mtk_mdp_vpu_ipi_handler(void *data, unsigned int len, void *priv)
> > +{
> > +	unsigned int msg_id = *(unsigned int *)data;
> > +	struct mdp_ipi_comm_ack *msg = (struct mdp_ipi_comm_ack *)data;
> > +	struct mtk_mdp_vpu *vpu = (struct mtk_mdp_vpu *)msg->ap_inst;
> > +	struct mtk_mdp_ctx *ctx;
> > +
> > +	vpu->failure = msg->status;
> > +	if (!vpu->failure) {
> > +		switch (msg_id) {
> > +		case VPU_MDP_INIT_ACK:
> > +			mtk_mdp_vpu_handle_init_ack(data);
> > +			break;
> > +		case VPU_MDP_DEINIT_ACK:
> > +		case VPU_MDP_PROCESS_ACK:
> > +			break;
> > +		default:
> > +			ctx = vpu_to_ctx(vpu);
> > +			dev_err(&ctx->mdp_dev->pdev->dev,
> > +				"handle unknown ipi msg:0x%x\n",
> > +				msg_id);
> > +			break;
> > +		}
> > +	} else {
> > +		ctx = vpu_to_ctx(vpu);
> > +		mtk_mdp_dbg(0, "[%d]:msg 0x%x, failure:%d", ctx->id,
> > +			    msg_id, vpu->failure);
> > +	}
> > +}
> > +
> > +int mtk_mdp_vpu_register(struct platform_device *pdev)
> > +{
> > +	struct mtk_mdp_dev *mdp = platform_get_drvdata(pdev);
> > +	int err;
> > +
> > +	err = vpu_ipi_register(mdp->vpu_dev, IPI_MDP,
> > +			       mtk_mdp_vpu_ipi_handler, "mdp_vpu", NULL);
> > +	if (err)
> > +		dev_err(&mdp->pdev->dev,
> > +			"vpu_ipi_registration fail status=%d\n", err);
> > +
> > +	return err;
> > +}
> > +
> > +static int mtk_mdp_vpu_send_msg(void *msg, int len, struct mtk_mdp_vpu *vpu,
> > +				int id)
> > +{
> > +	struct mtk_mdp_ctx *ctx = vpu_to_ctx(vpu);
> > +	int err;
> > +
> > +	mutex_lock(&ctx->mdp_dev->vpulock);
> > +	err = vpu_ipi_send(vpu->pdev, (enum ipi_id)id, msg, len);
> > +	if (err) {
> > +		mutex_unlock(&ctx->mdp_dev->vpulock);
> > +		dev_err(&ctx->mdp_dev->pdev->dev,
> > +			"vpu_ipi_send fail status %d\n", err);
> > +	}
> > +	mutex_unlock(&ctx->mdp_dev->vpulock);
> > +
> > +	return err;
> > +}
> > +
> > +static int mtk_mdp_vpu_send_ap_ipi(struct mtk_mdp_vpu *vpu, uint32_t msg_id)
> > +{
> > +	int err;
> > +	struct mdp_ipi_comm msg;
> > +
> > +	msg.msg_id = msg_id;
> > +	msg.ipi_id = IPI_MDP;
> > +	msg.vpu_inst_addr = vpu->inst_addr;
> > +	msg.ap_inst = (uint64_t)vpu;
> > +	err = mtk_mdp_vpu_send_msg((void *)&msg, sizeof(msg), vpu, IPI_MDP);
> > +	if (!err && vpu->failure)
> > +		err = -EINVAL;
> > +
> > +	return err;
> > +}
> > +
> > +int mtk_mdp_vpu_init(struct mtk_mdp_vpu *vpu)
> > +{
> > +	int err;
> > +	struct mdp_ipi_init msg;
> > +	struct mtk_mdp_ctx *ctx = vpu_to_ctx(vpu);
> > +
> > +	vpu->pdev = ctx->mdp_dev->vpu_dev;
> > +
> > +	msg.msg_id = AP_MDP_INIT;
> > +	msg.ipi_id = IPI_MDP;
> > +	msg.ap_inst = (uint64_t)vpu;
> > +	err = mtk_mdp_vpu_send_msg((void *)&msg, sizeof(msg), vpu, IPI_MDP);
> > +	if (!err && vpu->failure)
> > +		err = -EINVAL;
> > +
> > +	return err;
> > +}
> > +
> > +int mtk_mdp_vpu_deinit(struct mtk_mdp_vpu *vpu)
> > +{
> > +	return mtk_mdp_vpu_send_ap_ipi(vpu, AP_MDP_DEINIT);
> > +}
> > +
> > +int mtk_mdp_vpu_process(struct mtk_mdp_vpu *vpu)
> > +{
> > +	return mtk_mdp_vpu_send_ap_ipi(vpu, AP_MDP_PROCESS);
> > +}
> > diff --git a/drivers/media/platform/mtk-mdp/mtk_mdp_vpu.h b/drivers/media/platform/mtk-mdp/mtk_mdp_vpu.h
> > new file mode 100644
> > index 0000000..df4bdda
> > --- /dev/null
> > +++ b/drivers/media/platform/mtk-mdp/mtk_mdp_vpu.h
> > @@ -0,0 +1,41 @@
> > +/*
> > + * Copyright (c) 2015-2016 MediaTek Inc.
> > + * Author: Houlong Wei <houlong.wei@mediatek.com>
> > + *         Ming Hsiu Tsai <minghsiu.tsai@mediatek.com>
> > + *
> > + * This program is free software; you can redistribute it and/or modify
> > + * it under the terms of the GNU General Public License version 2 as
> > + * published by the Free Software Foundation.
> > + *
> > + * This program is distributed in the hope that it will be useful,
> > + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> > + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> > + * GNU General Public License for more details.
> > + */
> > +
> > +#ifndef __MTK_MDP_VPU_H__
> > +#define __MTK_MDP_VPU_H__
> > +
> > +#include "mtk_mdp_ipi.h"
> > +
> > +
> > +/**
> > + * struct mtk_mdp_vpu - VPU instance for MDP
> > + * @pdev	: pointer to the VPU platform device
> > + * @inst_addr	: VPU MDP instance address
> > + * @failure	: VPU execution result status
> > + * @vsi		: VPU shared information
> > + */
> > +struct mtk_mdp_vpu {
> > +	struct platform_device	*pdev;
> > +	uint32_t		inst_addr;
> > +	int32_t			failure;
> > +	struct mdp_process_vsi	*vsi;
> > +};
> > +
> > +int mtk_mdp_vpu_register(struct platform_device *pdev);
> > +int mtk_mdp_vpu_init(struct mtk_mdp_vpu *vpu);
> > +int mtk_mdp_vpu_deinit(struct mtk_mdp_vpu *vpu);
> > +int mtk_mdp_vpu_process(struct mtk_mdp_vpu *vpu);
> > +
> > +#endif /* __MTK_MDP_VPU_H__ */
> > 
> 
> Regards,
> 
> 	Hans



