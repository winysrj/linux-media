Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f49.google.com ([74.125.82.49]:38697 "EHLO
        mail-wm0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932860AbdGCODp (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Mon, 3 Jul 2017 10:03:45 -0400
Received: by mail-wm0-f49.google.com with SMTP id f67so56113839wmh.1
        for <linux-media@vger.kernel.org>; Mon, 03 Jul 2017 07:03:44 -0700 (PDT)
Subject: Re: [PATCH v2 09/19] media: camms: Add core files
To: Sakari Ailus <sakari.ailus@iki.fi>
Cc: mchehab@kernel.org, hans.verkuil@cisco.com, javier@osg.samsung.com,
        s.nawrocki@samsung.com, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org
References: <1497883719-12410-1-git-send-email-todor.tomov@linaro.org>
 <1497883719-12410-10-git-send-email-todor.tomov@linaro.org>
 <20170629063328.l4j47ubhu2gy7txa@valkosipuli.retiisi.org.uk>
From: Todor Tomov <todor.tomov@linaro.org>
Message-ID: <5abc06cc-d79d-bcda-a4ce-5b6effafeed9@linaro.org>
Date: Mon, 3 Jul 2017 17:03:40 +0300
MIME-Version: 1.0
In-Reply-To: <20170629063328.l4j47ubhu2gy7txa@valkosipuli.retiisi.org.uk>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sakari,

Thank you for the review.

On 06/29/2017 09:33 AM, Sakari Ailus wrote:
> Hi Todor,
> 
> On Mon, Jun 19, 2017 at 05:48:29PM +0300, Todor Tomov wrote:
>> These files implement the platform driver code.
>>
>> Signed-off-by: Todor Tomov <todor.tomov@linaro.org>
>> ---
>>  drivers/media/platform/qcom/camss-8x16/camss.c | 630 +++++++++++++++++++++++++
>>  drivers/media/platform/qcom/camss-8x16/camss.h |  96 ++++
>>  2 files changed, 726 insertions(+)
>>  create mode 100644 drivers/media/platform/qcom/camss-8x16/camss.c
>>  create mode 100644 drivers/media/platform/qcom/camss-8x16/camss.h
>>
>> diff --git a/drivers/media/platform/qcom/camss-8x16/camss.c b/drivers/media/platform/qcom/camss-8x16/camss.c
>> new file mode 100644
>> index 0000000..a8798d1
>> --- /dev/null
>> +++ b/drivers/media/platform/qcom/camss-8x16/camss.c
>> @@ -0,0 +1,630 @@
>> +/*
>> + * camss.c
>> + *
>> + * Qualcomm MSM Camera Subsystem - Core
>> + *
>> + * Copyright (c) 2015, The Linux Foundation. All rights reserved.
>> + * Copyright (C) 2015-2016 Linaro Ltd.
>> + *
>> + * This program is free software; you can redistribute it and/or modify
>> + * it under the terms of the GNU General Public License version 2 and
>> + * only version 2 as published by the Free Software Foundation.
>> + *
>> + * This program is distributed in the hope that it will be useful,
>> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
>> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
>> + * GNU General Public License for more details.
>> + */
>> +#include <linux/clk.h>
>> +#include <linux/media-bus-format.h>
>> +#include <linux/module.h>
>> +#include <linux/platform_device.h>
>> +#include <linux/of.h>
>> +#include <linux/slab.h>
>> +
>> +#include <media/media-device.h>
>> +#include <media/v4l2-async.h>
>> +#include <media/v4l2-device.h>
>> +#include <media/v4l2-mc.h>
>> +#include <media/v4l2-of.h>
>> +
>> +#include "camss.h"
>> +
>> +static struct resources csiphy_res[] = {
>> +	/* CSIPHY0 */
>> +	{
>> +		.regulator = { NULL },
>> +		.clock = { "camss_top_ahb_clk", "ispif_ahb_clk",
>> +			   "camss_ahb_clk", "csiphy0_timer_clk" },
>> +		.clock_rate = { 0, 0, 0, 200000000 },
>> +		.reg = { "csiphy0", "csiphy0_clk_mux" },
>> +		.interrupt = { "csiphy0" }
>> +	},
>> +
>> +	/* CSIPHY1 */
>> +	{
>> +		.regulator = { NULL },
>> +		.clock = { "camss_top_ahb_clk", "ispif_ahb_clk",
>> +			   "camss_ahb_clk", "csiphy1_timer_clk" },
>> +		.clock_rate = { 0, 0, 0, 200000000 },
>> +		.reg = { "csiphy1", "csiphy1_clk_mux" },
>> +		.interrupt = { "csiphy1" }
>> +	}
>> +};
>> +
>> +static struct resources csid_res[] = {
>> +	/* CSID0 */
>> +	{
>> +		.regulator = { "vdda" },
>> +		.clock = { "camss_top_ahb_clk", "ispif_ahb_clk",
>> +			   "csi0_ahb_clk", "camss_ahb_clk",
>> +			   "csi0_clk", "csi0_phy_clk",
>> +			   "csi0_pix_clk", "csi0_rdi_clk" },
>> +		.clock_rate = { 0, 0, 0, 0, 200000000, 0, 0, 0 },
>> +		.reg = { "csid0" },
>> +		.interrupt = { "csid0" }
>> +	},
>> +
>> +	/* CSID1 */
>> +	{
>> +		.regulator = { "vdda" },
>> +		.clock = { "camss_top_ahb_clk", "ispif_ahb_clk",
>> +			   "csi1_ahb_clk", "camss_ahb_clk",
>> +			   "csi1_clk", "csi1_phy_clk",
>> +			   "csi1_pix_clk", "csi1_rdi_clk" },
>> +		.clock_rate = { 0, 0, 0, 0, 200000000, 0, 0, 0 },
>> +		.reg = { "csid1" },
>> +		.interrupt = { "csid1" }
>> +	},
>> +};
>> +
>> +static struct resources_ispif ispif_res = {
>> +	/* ISPIF */
>> +	.clock = { "camss_top_ahb_clk", "camss_ahb_clk", "ispif_ahb_clk",
>> +		   "csi0_clk", "csi0_pix_clk", "csi0_rdi_clk",
>> +		   "csi1_clk", "csi1_pix_clk", "csi1_rdi_clk" },
>> +	.clock_for_reset = { "camss_vfe_vfe_clk", "camss_csi_vfe_clk" },
>> +	.reg = { "ispif", "csi_clk_mux" },
>> +	.interrupt = "ispif"
>> +
>> +};
>> +
>> +static struct resources vfe_res = {
>> +	/* VFE0 */
>> +	.regulator = { NULL },
>> +	.clock = { "camss_top_ahb_clk", "camss_vfe_vfe_clk",
>> +		   "camss_csi_vfe_clk", "iface_clk",
>> +		   "bus_clk", "camss_ahb_clk" },
>> +	.clock_rate = { 0, 320000000, 0, 0, 0, 0, 0, 0 },
>> +	.reg = { "vfe0" },
>> +	.interrupt = { "vfe0" }
>> +};
> 
> Could these be const?

Sure.

> 
>> +
>> +/*
>> + * camss_enable_clocks - Enable multiple clocks
>> + * @nclocks: Number of clocks in clock array
>> + * @clock: Clock array
>> + * @dev: Device
>> + *
>> + * Return 0 on success or a negative error code otherwise
>> + */
>> +int camss_enable_clocks(int nclocks, struct clk **clock, struct device *dev)
>> +{
>> +	int ret;
>> +	int i;
>> +
>> +	for (i = 0; i < nclocks; i++) {
>> +		ret = clk_prepare_enable(clock[i]);
>> +		if (ret) {
>> +			dev_err(dev, "clock enable failed\n");
>> +			goto error;
>> +		}
>> +	}
>> +
>> +	return 0;
>> +
>> +error:
>> +	for (i--; i >= 0; i--)
>> +		clk_disable_unprepare(clock[i]);
>> +
>> +	return ret;
>> +}
>> +
>> +/*
>> + * camss_disable_clocks - Disable multiple clocks
>> + * @nclocks: Number of clocks in clock array
>> + * @clock: Clock array
>> + */
>> +void camss_disable_clocks(int nclocks, struct clk **clock)
>> +{
>> +	int i;
>> +
>> +	for (i = nclocks - 1; i >= 0; i--)
>> +		clk_disable_unprepare(clock[i]);
>> +}
>> +
>> +/*
>> + * camss_of_parse_endpoint_node - Parse port endpoint node
>> + * @dev: Device
>> + * @node: Device node to be parsed
>> + * @csd: Parsed data from port endpoint node
>> + *
>> + * Return 0 on success or a negative error code on failure
>> + */
>> +static int camss_of_parse_endpoint_node(struct device *dev,
>> +					struct device_node *node,
>> +					struct camss_async_subdev *csd)
>> +{
>> +	struct csiphy_lanes_cfg *lncfg = &csd->interface.csi2.lane_cfg;
>> +	int *settle_cnt = &csd->interface.csi2.settle_cnt;
>> +	struct v4l2_of_bus_mipi_csi2 *mipi_csi2;
>> +	struct v4l2_of_endpoint vep = { { 0 } };
> 
> Could you rebase on the current media-tree master?
> 
> The V4L2 OF framework has been replaced by the V4L2 fwnode framework, with
> similar functionality. Mostly changes required are just switching from
> v4l2_of_ to v4l2_fwnode_.

Ok, I'll rebase.

> 
>> +	unsigned int i;
>> +
>> +	v4l2_of_parse_endpoint(node, &vep);
>> +
>> +	csd->interface.csiphy_id = vep.base.port;
>> +
>> +	mipi_csi2 = &vep.bus.mipi_csi2;
>> +	lncfg->clk.pos = mipi_csi2->clock_lane;
>> +	lncfg->clk.pol = mipi_csi2->lane_polarities[0];
>> +	lncfg->num_data = mipi_csi2->num_data_lanes;
>> +
>> +	lncfg->data = devm_kzalloc(dev, lncfg->num_data * sizeof(*lncfg->data),
>> +				   GFP_KERNEL);
>> +	if (!lncfg->data)
>> +		return -ENOMEM;
>> +
>> +	for (i = 0; i < lncfg->num_data; i++) {
>> +		lncfg->data[i].pos = mipi_csi2->data_lanes[i];
>> +		lncfg->data[i].pol = mipi_csi2->lane_polarities[i + 1];
>> +	}
>> +
>> +	of_property_read_u32(node, "qcom,settle-cnt", settle_cnt);
> 
> Isn't this something that depends on the CSI-2 bus speed, for instance?
> Could you calculate it instead of putting it to DT?

Actually, after some digging into this, yes, I can calculate it. I can
calculate the CSI-2 bus speed based on the sensor's output pixel clock
and then calculate the settle time and this settle count value.
So I already have the code to get the sensor's pixel clock using the
standard v4l2 control V4L2_CID_PIXEL_RATE.
Now the question is what to do if the sensor driver doesn't support this
control? Just return an error and refuse to work with this "limited"
sensor driver?

> 
>> +
>> +	return 0;
>> +}
>> +
>> +/*
>> + * camss_of_parse_ports - Parse ports node
>> + * @dev: Device
>> + * @notifier: v4l2_device notifier data
>> + *
>> + * Return number of "port" nodes found in "ports" node
>> + */
>> +static int camss_of_parse_ports(struct device *dev,
>> +				struct v4l2_async_notifier *notifier)
>> +{
>> +	struct device_node *node = NULL;
>> +	unsigned int size, i;
>> +	int ret;
>> +
>> +	while ((node = of_graph_get_next_endpoint(dev->of_node, node)))
>> +		if (of_device_is_available(node))
>> +			notifier->num_subdevs++;
>> +
>> +	size = sizeof(*notifier->subdevs) * notifier->num_subdevs;
>> +	notifier->subdevs = devm_kzalloc(dev, size, GFP_KERNEL);
>> +	if (!notifier->subdevs) {
>> +		dev_err(dev, "Failed to allocate memory\n");
>> +		return -ENOMEM;
>> +	}
>> +
>> +	i = 0;
>> +	while ((node = of_graph_get_next_endpoint(dev->of_node, node))) {
>> +		struct camss_async_subdev *csd;
>> +
>> +		if (!of_device_is_available(node))
>> +			continue;
>> +
>> +		csd = devm_kzalloc(dev, sizeof(*csd), GFP_KERNEL);
>> +		if (!csd) {
>> +			of_node_put(node);
>> +			dev_err(dev, "Failed to allocate memory\n");
>> +			return -ENOMEM;
>> +		}
>> +
>> +		notifier->subdevs[i++] = &csd->asd;
>> +
>> +		ret = camss_of_parse_endpoint_node(dev, node, csd);
>> +		if (ret < 0) {
>> +			of_node_put(node);
>> +			return ret;
>> +		}
>> +
>> +		csd->asd.match.of.node = of_graph_get_remote_port_parent(node);
>> +		of_node_put(node);
>> +		if (!csd->asd.match.of.node) {
>> +			dev_err(dev, "Bad remote port parent\n");
>> +			return -EINVAL;
>> +		}
>> +
>> +		csd->asd.match_type = V4L2_ASYNC_MATCH_OF;
>> +	}
>> +
>> +	return notifier->num_subdevs;
>> +}
>> +
>> +/*
>> + * camss_init_subdevices - Initialize subdev structures and resources
>> + * @camss: CAMSS device
>> + *
>> + * Return 0 on success or a negative error code on failure
>> + */
>> +static int camss_init_subdevices(struct camss *camss)
>> +{
>> +	unsigned int i;
>> +	int ret;
>> +
>> +	for (i = 0; i < ARRAY_SIZE(camss->csiphy); i++) {
>> +		ret = msm_csiphy_subdev_init(&camss->csiphy[i],
>> +					     &csiphy_res[i], i);
>> +		if (ret < 0) {
>> +			dev_err(camss->dev,
>> +				"Failed to init csiphy%d sub-device\n", i);
>> +			return ret;
>> +		}
>> +	}
>> +
>> +	for (i = 0; i < ARRAY_SIZE(camss->csid); i++) {
>> +		ret = msm_csid_subdev_init(&camss->csid[i],
>> +					   &csid_res[i], i);
>> +		if (ret < 0) {
>> +			dev_err(camss->dev,
>> +				"Failed to init csid%d sub-device\n", i);
>> +			return ret;
>> +		}
>> +	}
>> +
>> +	ret = msm_ispif_subdev_init(&camss->ispif, &ispif_res);
>> +	if (ret < 0) {
>> +		dev_err(camss->dev, "Failed to init ispif sub-device\n");
>> +		return ret;
>> +	}
>> +
>> +	ret = msm_vfe_subdev_init(&camss->vfe, &vfe_res);
>> +	if (ret < 0) {
>> +		dev_err(camss->dev, "Fail to init vfe sub-device\n");
>> +		return ret;
>> +	}
>> +
>> +	return 0;
>> +}
>> +
>> +/*
>> + * camss_register_entities - Register subdev nodes and create links
>> + * @camss: CAMSS device
>> + *
>> + * Return 0 on success or a negative error code on failure
>> + */
>> +static int camss_register_entities(struct camss *camss)
>> +{
>> +	int i, j;
>> +	int ret;
>> +
>> +	for (i = 0; i < ARRAY_SIZE(camss->csiphy); i++) {
>> +		ret = msm_csiphy_register_entity(&camss->csiphy[i],
>> +						 &camss->v4l2_dev);
>> +		if (ret < 0) {
>> +			dev_err(camss->dev,
>> +				"Failed to register csiphy%d entity\n", i);
>> +			goto err_reg_csiphy;
>> +		}
>> +	}
>> +
>> +	for (i = 0; i < ARRAY_SIZE(camss->csid); i++) {
>> +		ret = msm_csid_register_entity(&camss->csid[i],
>> +					       &camss->v4l2_dev);
>> +		if (ret < 0) {
>> +			dev_err(camss->dev,
>> +				"Failed to register csid%d entity\n", i);
>> +			goto err_reg_csid;
>> +		}
>> +	}
>> +
>> +	ret = msm_ispif_register_entities(&camss->ispif, &camss->v4l2_dev);
>> +	if (ret < 0) {
>> +		dev_err(camss->dev, "Failed to register ispif entities\n");
>> +		goto err_reg_ispif;
>> +	}
> 
> Could you send the media graph (i.e. media-ctl --print-dot) for the device,
> please? That'd help understanding the topoogy quite well.

Already sent.

> 
>> +
>> +	ret = msm_vfe_register_entities(&camss->vfe, &camss->v4l2_dev);
>> +	if (ret < 0) {
>> +		dev_err(camss->dev, "Failed to register vfe entities\n");
>> +		goto err_reg_vfe;
>> +	}
>> +
>> +	for (i = 0; i < ARRAY_SIZE(camss->csiphy); i++) {
>> +		for (j = 0; j < ARRAY_SIZE(camss->csid); j++) {
>> +			ret = media_create_pad_link(
>> +				&camss->csiphy[i].subdev.entity,
>> +				MSM_CSIPHY_PAD_SRC,
>> +				&camss->csid[j].subdev.entity,
>> +				MSM_CSID_PAD_SINK,
>> +				0);
>> +			if (ret < 0) {
>> +				dev_err(camss->dev,
>> +					"Failed to link %s->%s entities\n",
>> +					camss->csiphy[i].subdev.entity.name,
>> +					camss->csid[j].subdev.entity.name);
>> +				goto err_link;
>> +			}
>> +		}
>> +	}
>> +
>> +	for (i = 0; i < ARRAY_SIZE(camss->csid); i++) {
>> +		for (j = 0; j < ARRAY_SIZE(camss->ispif.line); j++) {
>> +			ret = media_create_pad_link(
>> +				&camss->csid[i].subdev.entity,
>> +				MSM_CSID_PAD_SRC,
>> +				&camss->ispif.line[j].subdev.entity,
>> +				MSM_ISPIF_PAD_SINK,
>> +				0);
>> +			if (ret < 0) {
>> +				dev_err(camss->dev,
>> +					"Failed to link %s->%s entities\n",
>> +					camss->csid[i].subdev.entity.name,
>> +					camss->ispif.line[j].subdev.entity.name
>> +					);
>> +				goto err_link;
>> +			}
>> +		}
>> +	}
>> +
>> +	for (i = 0; i < ARRAY_SIZE(camss->ispif.line); i++) {
>> +		for (j = 0; j < ARRAY_SIZE(camss->vfe.line); j++) {
>> +			ret = media_create_pad_link(
>> +				&camss->ispif.line[i].subdev.entity,
>> +				MSM_ISPIF_PAD_SRC,
>> +				&camss->vfe.line[j].subdev.entity,
>> +				MSM_VFE_PAD_SINK,
>> +				0);
>> +			if (ret < 0) {
>> +				dev_err(camss->dev,
>> +					"Failed to link %s->%s entities\n",
>> +					camss->ispif.line[i].subdev.entity.name,
>> +					camss->vfe.line[j].subdev.entity.name);
>> +				goto err_link;
>> +			}
>> +		}
>> +	}
>> +
>> +	return 0;
>> +
>> +err_link:
>> +	msm_vfe_unregister_entities(&camss->vfe);
>> +err_reg_vfe:
>> +	msm_ispif_unregister_entities(&camss->ispif);
>> +err_reg_ispif:
>> +
>> +	i = ARRAY_SIZE(camss->csid);
>> +err_reg_csid:
>> +	for (i--; i >= 0; i--)
>> +		msm_csid_unregister_entity(&camss->csid[i]);
>> +
>> +	i = ARRAY_SIZE(camss->csiphy);
>> +err_reg_csiphy:
>> +	for (i--; i >= 0; i--)
>> +		msm_csiphy_unregister_entity(&camss->csiphy[i]);
>> +
>> +	return ret;
>> +}
>> +
>> +/*
>> + * camss_unregister_entities - Unregister subdev nodes
>> + * @camss: CAMSS device
>> + *
>> + * Return 0 on success or a negative error code on failure
>> + */
>> +static void camss_unregister_entities(struct camss *camss)
>> +{
>> +	unsigned int i;
>> +
>> +	for (i = 0; i < ARRAY_SIZE(camss->csiphy); i++)
>> +		msm_csiphy_unregister_entity(&camss->csiphy[i]);
>> +
>> +	for (i = 0; i < ARRAY_SIZE(camss->csid); i++)
>> +		msm_csid_unregister_entity(&camss->csid[i]);
>> +
>> +	msm_ispif_unregister_entities(&camss->ispif);
>> +	msm_vfe_unregister_entities(&camss->vfe);
>> +}
>> +
>> +static int camss_subdev_notifier_bound(struct v4l2_async_notifier *async,
>> +				       struct v4l2_subdev *subdev,
>> +				       struct v4l2_async_subdev *asd)
>> +{
>> +	struct camss *camss = container_of(async, struct camss, notifier);
>> +	struct camss_async_subdev *csd =
>> +		container_of(asd, struct camss_async_subdev, asd);
>> +	u8 id = csd->interface.csiphy_id;
>> +	struct csiphy_device *csiphy = &camss->csiphy[id];
>> +
>> +	csiphy->cfg.csi2 = &csd->interface.csi2;
>> +	subdev->host_priv = csiphy;
>> +
>> +	return 0;
>> +}
>> +
>> +static int camss_subdev_notifier_complete(struct v4l2_async_notifier *async)
>> +{
>> +	struct camss *camss = container_of(async, struct camss, notifier);
>> +	struct v4l2_device *v4l2_dev = &camss->v4l2_dev;
>> +	struct v4l2_subdev *sd;
>> +	int ret;
>> +
>> +	list_for_each_entry(sd, &v4l2_dev->subdevs, list) {
>> +		if (sd->host_priv) {
> 
> if (!sd->host_priv)
> 	continue;
> 
> And you can unindent the rest of the loop. Up to you.

I will have to split the variable definitions and initializations below.
So I'd prefer to keep it.

> 
>> +			struct media_entity *sensor = &sd->entity;
>> +			struct csiphy_device *csiphy =
>> +					(struct csiphy_device *) sd->host_priv;
>> +			struct media_entity *input = &csiphy->subdev.entity;
>> +			unsigned int i;
>> +
>> +			for (i = 0; i < sensor->num_pads; i++) {
>> +				if (sensor->pads[i].flags & MEDIA_PAD_FL_SOURCE)
>> +					break;
>> +			}
>> +			if (i == sensor->num_pads) {
>> +				dev_err(camss->dev,
>> +					"No source pad in external entity\n");
>> +				return -EINVAL;
>> +			}
>> +
>> +			ret = media_create_pad_link(sensor, i,
>> +				input, MSM_CSIPHY_PAD_SINK,
>> +				MEDIA_LNK_FL_IMMUTABLE | MEDIA_LNK_FL_ENABLED);
>> +			if (ret < 0) {
>> +				dev_err(camss->dev,
>> +					"Failed to link %s->%s entities\n",
>> +					sensor->name, input->name);
>> +				return ret;
>> +			}
>> +		}
>> +	}
>> +
>> +	ret = v4l2_device_register_subdev_nodes(&camss->v4l2_dev);
>> +	if (ret < 0)
>> +		return ret;
>> +
>> +	return media_device_register(&camss->media_dev);
>> +}
>> +
>> +static const struct media_device_ops camss_media_ops = {
>> +	.link_notify = v4l2_pipeline_link_notify,
>> +};
>> +
>> +/*
>> + * camss_probe - Probe CAMSS platform device
>> + * @pdev: Pointer to CAMSS platform device
>> + *
>> + * Return 0 on success or a negative error code on failure
>> + */
>> +static int camss_probe(struct platform_device *pdev)
>> +{
>> +	struct device *dev = &pdev->dev;
>> +	struct camss *camss;
>> +	int ret;
>> +
>> +	camss = kzalloc(sizeof(*camss), GFP_KERNEL);
>> +	if (!camss)
>> +		return -ENOMEM;
>> +
>> +	atomic_set(&camss->ref_count, 0);
>> +	camss->dev = dev;
>> +	platform_set_drvdata(pdev, camss);
>> +
>> +	ret = camss_of_parse_ports(dev, &camss->notifier);
>> +	if (ret < 0)
>> +		return ret;
>> +
>> +	ret = camss_init_subdevices(camss);
>> +	if (ret < 0)
>> +		return ret;
>> +
>> +	ret = dma_set_mask_and_coherent(dev, 0xffffffff);
>> +	if (ret)
>> +		return ret;
>> +
>> +	camss->media_dev.dev = camss->dev;
>> +	strlcpy(camss->media_dev.model, "Qualcomm Camera Subsystem",
>> +		sizeof(camss->media_dev.model));
>> +	camss->media_dev.ops = &camss_media_ops;
>> +	media_device_init(&camss->media_dev);
>> +
>> +	camss->v4l2_dev.mdev = &camss->media_dev;
>> +	ret = v4l2_device_register(camss->dev, &camss->v4l2_dev);
>> +	if (ret < 0) {
>> +		dev_err(dev, "Failed to register V4L2 device\n");
>> +		return ret;
>> +	}
>> +
>> +	ret = camss_register_entities(camss);
>> +	if (ret < 0)
>> +		goto err_register_entities;
>> +
>> +	if (camss->notifier.num_subdevs) {
>> +		camss->notifier.bound = camss_subdev_notifier_bound;
>> +		camss->notifier.complete = camss_subdev_notifier_complete;
>> +
>> +		ret = v4l2_async_notifier_register(&camss->v4l2_dev,
>> +						   &camss->notifier);
>> +		if (ret) {
>> +			dev_err(dev, "Failed to register async subdev nodes");
>> +			goto err_register_subdevs;
>> +		}
>> +	} else {
>> +		ret = v4l2_device_register_subdev_nodes(&camss->v4l2_dev);
>> +		if (ret < 0) {
>> +			dev_err(dev, "Failed to register subdev nodes");
>> +			goto err_register_subdevs;
>> +		}
>> +
>> +		ret = media_device_register(&camss->media_dev);
>> +		if (ret < 0) {
>> +			dev_err(dev, "Failed to register media device");
>> +			goto err_register_subdevs;
>> +		}
>> +	}
>> +
>> +	return 0;
>> +
>> +err_register_subdevs:
>> +	camss_unregister_entities(camss);
>> +err_register_entities:
>> +	v4l2_device_unregister(&camss->v4l2_dev);
>> +
>> +	return ret;
>> +}
>> +
>> +void camss_delete(struct camss *camss)
>> +{
>> +	v4l2_device_unregister(&camss->v4l2_dev);
>> +	media_device_unregister(&camss->media_dev);
>> +	media_device_cleanup(&camss->media_dev);
>> +
>> +	kfree(camss);
>> +}
>> +
>> +/*
>> + * camss_remove - Remove CAMSS platform device
>> + * @pdev: Pointer to CAMSS platform device
>> + *
>> + * Always returns 0.
>> + */
>> +static int camss_remove(struct platform_device *pdev)
>> +{
>> +	struct camss *camss = platform_get_drvdata(pdev);
>> +
>> +	msm_vfe_stop_streaming(&camss->vfe);
>> +
>> +	v4l2_async_notifier_unregister(&camss->notifier);
>> +	camss_unregister_entities(camss);
>> +
>> +	if (atomic_read(&camss->ref_count) == 0)
>> +		camss_delete(camss);
>> +
>> +	return 0;
>> +}
>> +
>> +static const struct of_device_id camss_dt_match[] = {
>> +	{ .compatible = "qcom,msm8916-camss" },
>> +	{ }
>> +};
>> +
>> +MODULE_DEVICE_TABLE(of, camss_dt_match);
>> +
>> +static struct platform_driver qcom_camss_driver = {
>> +	.probe = camss_probe,
>> +	.remove = camss_remove,
>> +	.driver = {
>> +		.name = "qcom-camss",
>> +		.of_match_table = camss_dt_match,
>> +	},
>> +};
>> +
>> +module_platform_driver(qcom_camss_driver);
>> +
>> +MODULE_ALIAS("platform:qcom-camss");
>> +MODULE_DESCRIPTION("Qualcomm Camera Subsystem driver");
>> +MODULE_LICENSE("GPL");
> 
> "GPL" or "GPL v2"?

v2.

> 
>> diff --git a/drivers/media/platform/qcom/camss-8x16/camss.h b/drivers/media/platform/qcom/camss-8x16/camss.h
>> new file mode 100644
>> index 0000000..e1a8b90
>> --- /dev/null
>> +++ b/drivers/media/platform/qcom/camss-8x16/camss.h
>> @@ -0,0 +1,96 @@
>> +/*
>> + * camss.h
>> + *
>> + * Qualcomm MSM Camera Subsystem - Core
>> + *
>> + * Copyright (c) 2015, The Linux Foundation. All rights reserved.
>> + * Copyright (C) 2015-2016 Linaro Ltd.
>> + *
>> + * This program is free software; you can redistribute it and/or modify
>> + * it under the terms of the GNU General Public License version 2 and
>> + * only version 2 as published by the Free Software Foundation.
>> + *
>> + * This program is distributed in the hope that it will be useful,
>> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
>> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
>> + * GNU General Public License for more details.
>> + */
>> +#ifndef QC_MSM_CAMSS_H
>> +#define QC_MSM_CAMSS_H
>> +
>> +#include <linux/types.h>
>> +#include <media/v4l2-async.h>
>> +#include <media/v4l2-device.h>
>> +#include <media/v4l2-subdev.h>
>> +#include <media/media-device.h>
>> +#include <media/media-entity.h>
>> +#include <linux/device.h>
>> +
>> +#include "csid.h"
>> +#include "csiphy.h"
>> +#include "ispif.h"
>> +#include "vfe.h"
>> +
>> +#define CAMSS_CSID_NUM 2
>> +#define CAMSS_CSIPHY_NUM 2
>> +
>> +#define to_camss(ptr_module)	\
>> +	container_of(ptr_module, struct camss, ptr_module)
>> +
>> +#define to_device(ptr_module)	\
>> +	(to_camss(ptr_module)->dev)
>> +
>> +#define module_pointer(ptr_module, index)	\
>> +	((const struct ptr_module##_device (*)[]) &(ptr_module[-(index)]))
>> +
>> +#define to_camss_index(ptr_module, index)	\
>> +	container_of(module_pointer(ptr_module, index),	\
>> +		     struct camss, ptr_module)
>> +
>> +#define to_device_index(ptr_module, index)	\
>> +	(to_camss_index(ptr_module, index)->dev)
>> +
>> +#define CAMSS_RES_MAX 15
>> +
>> +struct resources {
>> +	char *regulator[CAMSS_RES_MAX];
>> +	char *clock[CAMSS_RES_MAX];
>> +	s32 clock_rate[CAMSS_RES_MAX];
>> +	char *reg[CAMSS_RES_MAX];
>> +	char *interrupt[CAMSS_RES_MAX];
>> +};
>> +
>> +struct resources_ispif {
>> +	char *clock[CAMSS_RES_MAX];
>> +	char *clock_for_reset[CAMSS_RES_MAX];
>> +	char *reg[CAMSS_RES_MAX];
>> +	char *interrupt;
>> +};
>> +
>> +struct camss {
>> +	struct v4l2_device v4l2_dev;
>> +	struct v4l2_async_notifier notifier;
>> +	struct media_device media_dev;
>> +	struct device *dev;
>> +	struct csiphy_device csiphy[CAMSS_CSIPHY_NUM];
>> +	struct csid_device csid[CAMSS_CSID_NUM];
>> +	struct ispif_device ispif;
>> +	struct vfe_device vfe;
>> +	atomic_t ref_count;
>> +};
>> +
>> +struct camss_camera_interface {
>> +	u8 csiphy_id;
>> +	struct csiphy_csi2_cfg csi2;
>> +};
>> +
>> +struct camss_async_subdev {
>> +	struct camss_camera_interface interface;
>> +	struct v4l2_async_subdev asd;
>> +};
>> +
>> +int camss_enable_clocks(int nclocks, struct clk **clock, struct device *dev);
>> +void camss_disable_clocks(int nclocks, struct clk **clock);
>> +void camss_delete(struct camss *camss);
>> +
>> +#endif /* QC_MSM_CAMSS_H */
> 

-- 
Best regards,
Todor Tomov
