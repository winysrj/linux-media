Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f54.google.com ([74.125.82.54]:35975 "EHLO
        mail-wm0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751695AbdF2Qgv (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 29 Jun 2017 12:36:51 -0400
Received: by mail-wm0-f54.google.com with SMTP id 62so87763896wmw.1
        for <linux-media@vger.kernel.org>; Thu, 29 Jun 2017 09:36:50 -0700 (PDT)
Subject: Re: [PATCH v2 04/19] media: camss: Add CSIPHY files
To: Sakari Ailus <sakari.ailus@iki.fi>
Cc: mchehab@kernel.org, hans.verkuil@cisco.com, javier@osg.samsung.com,
        s.nawrocki@samsung.com, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org
References: <1497883719-12410-1-git-send-email-todor.tomov@linaro.org>
 <1497883719-12410-5-git-send-email-todor.tomov@linaro.org>
 <20170628213433.7ehkz62rw75t4yxa@valkosipuli.retiisi.org.uk>
From: Todor Tomov <todor.tomov@linaro.org>
Message-ID: <4b28ce1a-84af-858b-50d1-79fb3e461387@linaro.org>
Date: Thu, 29 Jun 2017 19:36:47 +0300
MIME-Version: 1.0
In-Reply-To: <20170628213433.7ehkz62rw75t4yxa@valkosipuli.retiisi.org.uk>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sakari,

On 06/29/2017 12:34 AM, Sakari Ailus wrote:
> Hi Todor,
> 
> It's been a while --- how do you do?
> 
> Thanks for the patchset!

Thank you for the review. I'll focus more on this now, so let's see :)

> 
> On Mon, Jun 19, 2017 at 05:48:24PM +0300, Todor Tomov wrote:
>> These files control the CSIPHY modules which are responsible for the physical
>> layer of the CSI2 receivers.
>>
>> Signed-off-by: Todor Tomov <todor.tomov@linaro.org>
>> ---
>>  drivers/media/platform/qcom/camss-8x16/csiphy.c | 686 ++++++++++++++++++++++++
>>  drivers/media/platform/qcom/camss-8x16/csiphy.h |  77 +++
>>  2 files changed, 763 insertions(+)
>>  create mode 100644 drivers/media/platform/qcom/camss-8x16/csiphy.c
>>  create mode 100644 drivers/media/platform/qcom/camss-8x16/csiphy.h
>>
>> diff --git a/drivers/media/platform/qcom/camss-8x16/csiphy.c b/drivers/media/platform/qcom/camss-8x16/csiphy.c
>> new file mode 100644
>> index 0000000..b9d47ca
>> --- /dev/null
>> +++ b/drivers/media/platform/qcom/camss-8x16/csiphy.c
>> @@ -0,0 +1,686 @@
>> +/*
>> + * csiphy.c
>> + *
>> + * Qualcomm MSM Camera Subsystem - CSIPHY Module
>> + *
>> + * Copyright (c) 2011-2015, The Linux Foundation. All rights reserved.
>> + * Copyright (C) 2016 Linaro Ltd.
> 
> How about 2017?

How time flies...

> 
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
>> +#include <linux/delay.h>
>> +#include <linux/interrupt.h>
>> +#include <linux/kernel.h>
>> +#include <linux/of.h>
>> +#include <linux/platform_device.h>
>> +#include <media/media-entity.h>
>> +#include <media/v4l2-device.h>
>> +#include <media/v4l2-subdev.h>
>> +
> 
> ...
> 
>> +/*
>> + * csiphy_init_formats - Initialize formats on all pads
>> + * @sd: CSIPHY V4L2 subdevice
>> + * @fh: V4L2 subdev file handle
>> + *
>> + * Initialize all pad formats with default values.
>> + *
>> + * Return 0 on success or a negative error code otherwise
>> + */
>> +static int csiphy_init_formats(struct v4l2_subdev *sd,
>> +			       struct v4l2_subdev_fh *fh)
>> +{
>> +	struct v4l2_subdev_format format;
> 
> You can do:
> 
> struct v4l2_subdev_format format = { 0 };
> 
> And drop the memset. Or even better, assign the fields in declaration.

Yes. I'll do so for all memsets in the driver.

> 
>> +
>> +	memset(&format, 0, sizeof(format));
>> +	format.pad = MSM_CSIPHY_PAD_SINK;
>> +	format.which = fh ? V4L2_SUBDEV_FORMAT_TRY : V4L2_SUBDEV_FORMAT_ACTIVE;
>> +	format.format.code = MEDIA_BUS_FMT_UYVY8_2X8;
>> +	format.format.width = 1920;
>> +	format.format.height = 1080;
>> +
>> +	return csiphy_set_format(sd, fh ? fh->pad : NULL, &format);
>> +}
>> +
>> +/*
>> + * msm_csiphy_subdev_init - Initialize CSIPHY device structure and resources
>> + * @csiphy: CSIPHY device
>> + * @res: CSIPHY module resources table
>> + * @id: CSIPHY module id
>> + *
>> + * Return 0 on success or a negative error code otherwise
>> + */
>> +int msm_csiphy_subdev_init(struct csiphy_device *csiphy,
>> +			   struct resources *res, u8 id)
>> +{
>> +	struct device *dev = to_device_index(csiphy, id);
>> +	struct platform_device *pdev = container_of(dev,
>> +						struct platform_device, dev);
> 
> to_platform_device()?

Yes, thanks.

> 
>> +	struct resource *r;
>> +	int i;
>> +	int ret;
>> +
>> +	csiphy->id = id;
>> +	csiphy->cfg.combo_mode = 0;
>> +
>> +	/* Memory */
>> +
>> +	r = platform_get_resource_byname(pdev, IORESOURCE_MEM, res->reg[0]);
>> +	csiphy->base = devm_ioremap_resource(dev, r);
>> +	if (IS_ERR(csiphy->base)) {
>> +		dev_err(dev, "could not map memory\n");
>> +		return PTR_ERR(csiphy->base);
>> +	}
>> +
>> +	r = platform_get_resource_byname(pdev, IORESOURCE_MEM, res->reg[1]);
>> +	csiphy->base_clk_mux = devm_ioremap_resource(dev, r);
>> +	if (IS_ERR(csiphy->base_clk_mux)) {
>> +		dev_err(dev, "could not map memory\n");
>> +		return PTR_ERR(csiphy->base_clk_mux);
>> +	}
>> +
>> +	/* Interrupt */
>> +
>> +	r = platform_get_resource_byname(pdev, IORESOURCE_IRQ,
>> +					 res->interrupt[0]);
>> +	if (!r) {
>> +		dev_err(dev, "missing IRQ\n");
>> +		return -EINVAL;
>> +	}
>> +
>> +	csiphy->irq = r->start;
>> +	snprintf(csiphy->irq_name, sizeof(csiphy->irq_name), "%s_%s%d",
>> +		 dev_name(dev), MSM_CSIPHY_NAME, csiphy->id);
>> +	ret = devm_request_irq(dev, csiphy->irq, csiphy_isr,
>> +			       IRQF_TRIGGER_RISING, csiphy->irq_name, csiphy);
>> +	if (ret < 0) {
>> +		dev_err(dev, "request_irq failed\n");
> 
> Printing the error code as well might be nice for debugging if ever needed.

Ok.

> 
>> +		return ret;
>> +	}
>> +
>> +	disable_irq(csiphy->irq);
>> +
>> +	/* Clocks */
>> +
>> +	csiphy->nclocks = 0;
>> +	while (res->clock[csiphy->nclocks])
>> +		csiphy->nclocks++;
>> +
>> +	csiphy->clock = devm_kzalloc(dev, csiphy->nclocks *
>> +				     sizeof(*csiphy->clock), GFP_KERNEL);
>> +	if (!csiphy->clock)
>> +		return -ENOMEM;
>> +
>> +	for (i = 0; i < csiphy->nclocks; i++) {
>> +		csiphy->clock[i] = devm_clk_get(dev, res->clock[i]);
>> +		if (IS_ERR(csiphy->clock[i]))
>> +			return PTR_ERR(csiphy->clock[i]);
>> +
>> +		if (res->clock_rate[i]) {
>> +			long clk_rate = clk_round_rate(csiphy->clock[i],
>> +						       res->clock_rate[i]);
>> +			if (clk_rate < 0) {
>> +				dev_err(to_device_index(csiphy, csiphy->id),
>> +					"clk round rate failed\n");
>> +				return -EINVAL;
>> +			}
>> +			ret = clk_set_rate(csiphy->clock[i], clk_rate);
>> +			if (ret < 0) {
>> +				dev_err(to_device_index(csiphy, csiphy->id),
>> +					"clk set rate failed\n");
>> +				return ret;
>> +			}
>> +		}
>> +	}
>> +
>> +	return 0;
>> +}
>> +
>> +/*
>> + * csiphy_link_setup - Setup CSIPHY connections
>> + * @entity: Pointer to media entity structure
>> + * @local: Pointer to local pad
>> + * @remote: Pointer to remote pad
>> + * @flags: Link flags
>> + *
>> + * Rreturn 0 on success
>> + */
>> +static int csiphy_link_setup(struct media_entity *entity,
>> +			     const struct media_pad *local,
>> +			     const struct media_pad *remote, u32 flags)
>> +{
>> +	if ((local->flags & MEDIA_PAD_FL_SOURCE) &&
>> +	    (flags & MEDIA_LNK_FL_ENABLED)) {
>> +		struct v4l2_subdev *sd;
>> +		struct csiphy_device *csiphy;
>> +		struct csid_device *csid;
>> +
>> +		if (media_entity_remote_pad((struct media_pad *)local))
> 
> This is ugly.
> 
> What do you intend to find with media_entity_remote_pad()? The pad flags
> haven't been assigned to the pad yet, so media_entity_remote_pad() could
> give you something else than remote.

This is an attempt to check whether the pad is already linked - to refuse
a second active connection from the same src pad. As far as I can say, it
was a successful attempt. Do you see any problem with it?

> 
>> +			return -EBUSY;
>> +
>> +		sd = container_of(entity, struct v4l2_subdev, entity);
> 
> media_entity_to_v4l2_subdev().

Ok.

> 
>> +		csiphy = v4l2_get_subdevdata(sd);
>> +
>> +		sd = container_of(remote->entity, struct v4l2_subdev, entity);
> 
> Ditto.

Ok.

> 
>> +		csid = v4l2_get_subdevdata(sd);
>> +
>> +		csiphy->cfg.csid_id = csid->id;
>> +	}
>> +
>> +	return 0;
>> +}
>> +
>> +static const struct v4l2_subdev_core_ops csiphy_core_ops = {
>> +	.s_power = csiphy_set_power,
>> +};
>> +
>> +static const struct v4l2_subdev_video_ops csiphy_video_ops = {
>> +	.s_stream = csiphy_set_stream,
>> +};
>> +
>> +static const struct v4l2_subdev_pad_ops csiphy_pad_ops = {
>> +	.enum_mbus_code = csiphy_enum_mbus_code,
>> +	.enum_frame_size = csiphy_enum_frame_size,
>> +	.get_fmt = csiphy_get_format,
>> +	.set_fmt = csiphy_set_format,
>> +};
>> +
>> +static const struct v4l2_subdev_ops csiphy_v4l2_ops = {
>> +	.core = &csiphy_core_ops,
>> +	.video = &csiphy_video_ops,
>> +	.pad = &csiphy_pad_ops,
>> +};
>> +
>> +static const struct v4l2_subdev_internal_ops csiphy_v4l2_internal_ops = {
>> +	.open = csiphy_init_formats,
>> +};
>> +
>> +static const struct media_entity_operations csiphy_media_ops = {
>> +	.link_setup = csiphy_link_setup,
>> +	.link_validate = v4l2_subdev_link_validate,
>> +};
>> +
>> +/*
>> + * msm_csiphy_register_entity - Register subdev node for CSIPHY module
>> + * @csiphy: CSIPHY device
>> + * @v4l2_dev: V4L2 device
>> + *
>> + * Return 0 on success or a negative error code otherwise
>> + */
>> +int msm_csiphy_register_entity(struct csiphy_device *csiphy,
>> +			       struct v4l2_device *v4l2_dev)
>> +{
>> +	struct v4l2_subdev *sd = &csiphy->subdev;
>> +	struct media_pad *pads = csiphy->pads;
>> +	struct device *dev = to_device_index(csiphy, csiphy->id);
>> +	int ret;
>> +
>> +	v4l2_subdev_init(sd, &csiphy_v4l2_ops);
>> +	sd->internal_ops = &csiphy_v4l2_internal_ops;
>> +	sd->flags |= V4L2_SUBDEV_FL_HAS_DEVNODE;
>> +	snprintf(sd->name, ARRAY_SIZE(sd->name), "%s%d",
>> +		 MSM_CSIPHY_NAME, csiphy->id);
>> +	v4l2_set_subdevdata(sd, csiphy);
>> +
>> +	ret = csiphy_init_formats(sd, NULL);
>> +	if (ret < 0) {
>> +		dev_err(dev, "Failed to init format\n");
>> +		return ret;
>> +	}
>> +
>> +	pads[MSM_CSIPHY_PAD_SINK].flags = MEDIA_PAD_FL_SINK;
>> +	pads[MSM_CSIPHY_PAD_SRC].flags = MEDIA_PAD_FL_SOURCE;
>> +
>> +	sd->entity.function = MEDIA_ENT_F_IO_V4L;
>> +	sd->entity.ops = &csiphy_media_ops;
>> +	ret = media_entity_pads_init(&sd->entity, MSM_CSIPHY_PADS_NUM, pads);
>> +	if (ret < 0) {
>> +		dev_err(dev, "Failed to init media entity\n");
>> +		return ret;
>> +	}
>> +
>> +	ret = v4l2_device_register_subdev(v4l2_dev, sd);
>> +	if (ret < 0) {
>> +		dev_err(dev, "Failed to register subdev\n");
>> +		media_entity_cleanup(&sd->entity);
>> +	}
>> +
>> +	return ret;
>> +}
>> +
>> +/*
>> + * msm_csiphy_unregister_entity - Unregister CSIPHY module subdev node
>> + * @csiphy: CSIPHY device
>> + */
>> +void msm_csiphy_unregister_entity(struct csiphy_device *csiphy)
>> +{
>> +	v4l2_device_unregister_subdev(&csiphy->subdev);
>> +}
>> diff --git a/drivers/media/platform/qcom/camss-8x16/csiphy.h b/drivers/media/platform/qcom/camss-8x16/csiphy.h
>> new file mode 100644
>> index 0000000..60330a8
>> --- /dev/null
>> +++ b/drivers/media/platform/qcom/camss-8x16/csiphy.h
>> @@ -0,0 +1,77 @@
>> +/*
>> + * csiphy.h
>> + *
>> + * Qualcomm MSM Camera Subsystem - CSIPHY Module
>> + *
>> + * Copyright (c) 2011-2015, The Linux Foundation. All rights reserved.
>> + * Copyright (C) 2016 Linaro Ltd.
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
>> +#ifndef QC_MSM_CAMSS_CSIPHY_H
>> +#define QC_MSM_CAMSS_CSIPHY_H
>> +
>> +#include <linux/clk.h>
>> +#include <media/media-entity.h>
>> +#include <media/v4l2-device.h>
>> +#include <media/v4l2-mediabus.h>
>> +#include <media/v4l2-subdev.h>
>> +
>> +#define MSM_CSIPHY_PAD_SINK 0
>> +#define MSM_CSIPHY_PAD_SRC 1
>> +#define MSM_CSIPHY_PADS_NUM 2
>> +
>> +struct csiphy_lane {
>> +	u8 pos;
>> +	u8 pol;
>> +};
>> +
>> +struct csiphy_lanes_cfg {
>> +	int num_data;
>> +	struct csiphy_lane *data;
>> +	struct csiphy_lane clk;
>> +};
>> +
>> +struct csiphy_csi2_cfg {
>> +	int settle_cnt;
>> +	struct csiphy_lanes_cfg lane_cfg;
>> +};
>> +
>> +struct csiphy_config {
>> +	u8 combo_mode;
>> +	u8 csid_id;
>> +	struct csiphy_csi2_cfg *csi2;
>> +};
>> +
>> +struct csiphy_device {
>> +	u8 id;
>> +	struct v4l2_subdev subdev;
>> +	struct media_pad pads[MSM_CSIPHY_PADS_NUM];
>> +	void __iomem *base;
>> +	void __iomem *base_clk_mux;
>> +	u32 irq;
>> +	char irq_name[30];
>> +	struct clk **clock;
> 
> You could add a forward declaration and avoid including the header file for
> struct clk. Up to you I guess --- for a driver specific header it doesn't
> really matter much.
> 

Ok, I can keep it for now then.

>> +	int nclocks;
>> +	struct csiphy_config cfg;
>> +	struct v4l2_mbus_framefmt fmt[MSM_CSIPHY_PADS_NUM];
>> +};
>> +
>> +struct resources;
>> +
>> +int msm_csiphy_subdev_init(struct csiphy_device *csiphy,
>> +			   struct resources *res, u8 id);
>> +
>> +int msm_csiphy_register_entity(struct csiphy_device *csiphy,
>> +			       struct v4l2_device *v4l2_dev);
>> +
>> +void msm_csiphy_unregister_entity(struct csiphy_device *csiphy);
>> +
>> +#endif /* QC_MSM_CAMSS_CSIPHY_H */
> 

-- 
Best regards,
Todor Tomov
