Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wr0-f182.google.com ([209.85.128.182]:33703 "EHLO
        mail-wr0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752076AbdGYOCO (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 25 Jul 2017 10:02:14 -0400
Received: by mail-wr0-f182.google.com with SMTP id v105so89265839wrb.0
        for <linux-media@vger.kernel.org>; Tue, 25 Jul 2017 07:02:13 -0700 (PDT)
Subject: Re: [PATCH v3 10/23] media: camss: Add VFE files
To: Sakari Ailus <sakari.ailus@iki.fi>
Cc: mchehab@kernel.org, hans.verkuil@cisco.com, javier@osg.samsung.com,
        s.nawrocki@samsung.com, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org
References: <1500287629-23703-1-git-send-email-todor.tomov@linaro.org>
 <1500287629-23703-11-git-send-email-todor.tomov@linaro.org>
 <20170720145949.grndikq744zq7ejg@valkosipuli.retiisi.org.uk>
From: Todor Tomov <todor.tomov@linaro.org>
Message-ID: <cdcdda84-56d3-56cb-969c-a7dde7c6a12b@linaro.org>
Date: Tue, 25 Jul 2017 17:02:10 +0300
MIME-Version: 1.0
In-Reply-To: <20170720145949.grndikq744zq7ejg@valkosipuli.retiisi.org.uk>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sakari,

Thank you for the review.

On 20.07.2017 17:59, Sakari Ailus wrote:
> Hi Todor,
> 
> On Mon, Jul 17, 2017 at 01:33:36PM +0300, Todor Tomov wrote:
>> These files control the VFE module. The VFE has different input interfaces.
>> The PIX input interface feeds the input data to an image processing pipeline.
>> Three RDI input interfaces bypass the image processing pipeline. The VFE also
>> contains the AXI bus interface which writes the output data to memory.
>>
>> RDI interfaces are supported in this version. PIX interface is not supported.
>>
>> Signed-off-by: Todor Tomov <todor.tomov@linaro.org>
>> ---
>>  drivers/media/platform/qcom/camss-8x16/camss-vfe.c | 1913 ++++++++++++++++++++
>>  drivers/media/platform/qcom/camss-8x16/camss-vfe.h |  114 ++
>>  2 files changed, 2027 insertions(+)
>>  create mode 100644 drivers/media/platform/qcom/camss-8x16/camss-vfe.c
>>  create mode 100644 drivers/media/platform/qcom/camss-8x16/camss-vfe.h
>>
>> diff --git a/drivers/media/platform/qcom/camss-8x16/camss-vfe.c b/drivers/media/platform/qcom/camss-8x16/camss-vfe.c
>> new file mode 100644
>> index 0000000..b6dd29b
>> --- /dev/null
>> +++ b/drivers/media/platform/qcom/camss-8x16/camss-vfe.c
>> @@ -0,0 +1,1913 @@

<snip>

>> +
>> +static void vfe_set_qos(struct vfe_device *vfe)
>> +{
>> +	u32 val = 0xaaa5aaa5;
>> +	u32 val7 = 0x0001aaa5;
> 
> Huh. What do these mean? :-)

For these here I don't have understanding of the values. I'll remove the magic
values here and on all the other places but these here I'll just move to a #define.

> 
>> +
>> +	writel_relaxed(val, vfe->base + VFE_0_BUS_BDG_QOS_CFG_0);
>> +	writel_relaxed(val, vfe->base + VFE_0_BUS_BDG_QOS_CFG_1);
>> +	writel_relaxed(val, vfe->base + VFE_0_BUS_BDG_QOS_CFG_2);
>> +	writel_relaxed(val, vfe->base + VFE_0_BUS_BDG_QOS_CFG_3);
>> +	writel_relaxed(val, vfe->base + VFE_0_BUS_BDG_QOS_CFG_4);
>> +	writel_relaxed(val, vfe->base + VFE_0_BUS_BDG_QOS_CFG_5);
>> +	writel_relaxed(val, vfe->base + VFE_0_BUS_BDG_QOS_CFG_6);
>> +	writel_relaxed(val7, vfe->base + VFE_0_BUS_BDG_QOS_CFG_7);
>> +}
>> +

<snip>

>> +
>> +/*
>> + * msm_vfe_subdev_init - Initialize VFE device structure and resources
>> + * @vfe: VFE device
>> + * @res: VFE module resources table
>> + *
>> + * Return 0 on success or a negative error code otherwise
>> + */
>> +int msm_vfe_subdev_init(struct vfe_device *vfe, const struct resources *res)
>> +{
>> +	struct device *dev = to_device(vfe);
>> +	struct platform_device *pdev = to_platform_device(dev);
>> +	struct resource *r;
>> +	struct camss *camss = to_camss(vfe);
>> +
>> +	int i;
>> +	int ret;
>> +
>> +	mutex_init(&vfe->power_lock);
>> +	vfe->power_count = 0;
>> +
>> +	mutex_init(&vfe->stream_lock);
>> +	vfe->stream_count = 0;
>> +
>> +	spin_lock_init(&vfe->output_lock);
>> +
>> +	vfe->id = 0;
>> +	vfe->reg_update = 0;
>> +
>> +	for (i = VFE_LINE_RDI0; i <= VFE_LINE_RDI2; i++) {
>> +		vfe->line[i].video_out.type =
>> +					V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE;
>> +		vfe->line[i].video_out.camss = camss;
>> +		vfe->line[i].id = i;
>> +	}
>> +
>> +	/* Memory */
>> +
>> +	r = platform_get_resource_byname(pdev, IORESOURCE_MEM, res->reg[0]);
>> +	vfe->base = devm_ioremap_resource(dev, r);
>> +	if (IS_ERR(vfe->base)) {
>> +		dev_err(dev, "could not map memory\n");
> 
> mutex_destroy() for bothof the mutexes. The same below.
> 
> Do you have a corresponding cleanup function?

msm_vfe_subdev_init() and msm_vfe_register_entities() are called on probe().
msm_vfe_unregister_entities() is called on remove() - this is the cleanup
function. The mutexes are destroyed there. Is there something else that you
are concerned about?

> 
>> +		return PTR_ERR(vfe->base);
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
>> +	vfe->irq = r->start;
>> +	snprintf(vfe->irq_name, sizeof(vfe->irq_name), "%s_%s%d",
>> +		 dev_name(dev), MSM_VFE_NAME, vfe->id);
>> +	ret = devm_request_irq(dev, vfe->irq, vfe_isr,
>> +			       IRQF_TRIGGER_RISING, vfe->irq_name, vfe);
>> +	if (ret < 0) {
>> +		dev_err(dev, "request_irq failed: %d\n", ret);
>> +		return ret;
>> +	}
>> +
>> +	/* Clocks */
>> +
>> +	vfe->nclocks = 0;
>> +	while (res->clock[vfe->nclocks])
>> +		vfe->nclocks++;
>> +
>> +	vfe->clock = devm_kzalloc(dev, vfe->nclocks * sizeof(*vfe->clock),
>> +				  GFP_KERNEL);
>> +	if (!vfe->clock)
>> +		return -ENOMEM;
>> +
>> +	for (i = 0; i < vfe->nclocks; i++) {
>> +		vfe->clock[i] = devm_clk_get(dev, res->clock[i]);
>> +		if (IS_ERR(vfe->clock[i]))
>> +			return PTR_ERR(vfe->clock[i]);
>> +
>> +		if (res->clock_rate[i]) {
>> +			long clk_rate = clk_round_rate(vfe->clock[i],
>> +						       res->clock_rate[i]);
>> +			if (clk_rate < 0) {
>> +				dev_err(dev, "clk round rate failed\n");
>> +				return -EINVAL;
>> +			}
>> +			ret = clk_set_rate(vfe->clock[i], clk_rate);
>> +			if (ret < 0) {
>> +				dev_err(dev, "clk set rate failed\n");
>> +				return ret;
>> +			}
>> +		}
>> +	}
>> +
>> +	init_completion(&vfe->reset_complete);
>> +	init_completion(&vfe->halt_complete);
>> +
>> +	return 0;
>> +}
>> +
>> +/*
>> + * msm_vfe_get_vfe_id - Get VFE HW module id
>> + * @entity: Pointer to VFE media entity structure
>> + * @id: Return CSID HW module id here
>> + */
>> +void msm_vfe_get_vfe_id(struct media_entity *entity, u8 *id)
>> +{
>> +	struct v4l2_subdev *sd;
>> +	struct vfe_line *line;
>> +	struct vfe_device *vfe;
>> +
>> +	sd = media_entity_to_v4l2_subdev(entity);
>> +	line = v4l2_get_subdevdata(sd);
>> +	vfe = to_vfe(line);
>> +
>> +	*id = vfe->id;
>> +}
>> +
>> +/*
>> + * msm_vfe_get_vfe_line_id - Get VFE line id by media entity
>> + * @entity: Pointer to VFE media entity structure
>> + * @id: Return VFE line id here
>> + */
>> +void msm_vfe_get_vfe_line_id(struct media_entity *entity, enum vfe_line_id *id)
>> +{
>> +	struct v4l2_subdev *sd;
>> +	struct vfe_line *line;
>> +
>> +	sd = media_entity_to_v4l2_subdev(entity);
>> +	line = v4l2_get_subdevdata(sd);
>> +
>> +	*id = line->id;
>> +}
>> +
>> +/*
>> + * vfe_link_setup - Setup VFE connections
>> + * @entity: Pointer to media entity structure
>> + * @local: Pointer to local pad
>> + * @remote: Pointer to remote pad
>> + * @flags: Link flags
>> + *
>> + * Return 0 on success
>> + */
>> +static int vfe_link_setup(struct media_entity *entity,
>> +			  const struct media_pad *local,
>> +			  const struct media_pad *remote, u32 flags)
>> +{
>> +	if (flags & MEDIA_LNK_FL_ENABLED)
>> +		if (media_entity_remote_pad(local))
>> +			return -EBUSY;
>> +
>> +	return 0;
>> +}
>> +
>> +static const struct v4l2_subdev_core_ops vfe_core_ops = {
>> +	.s_power = vfe_set_power,
>> +};
>> +
>> +static const struct v4l2_subdev_video_ops vfe_video_ops = {
>> +	.s_stream = vfe_set_stream,
>> +};
>> +
>> +static const struct v4l2_subdev_pad_ops vfe_pad_ops = {
>> +	.enum_mbus_code = vfe_enum_mbus_code,
>> +	.enum_frame_size = vfe_enum_frame_size,
>> +	.get_fmt = vfe_get_format,
>> +	.set_fmt = vfe_set_format,
>> +};
>> +
>> +static const struct v4l2_subdev_ops vfe_v4l2_ops = {
>> +	.core = &vfe_core_ops,
>> +	.video = &vfe_video_ops,
>> +	.pad = &vfe_pad_ops,
>> +};
>> +
>> +static const struct v4l2_subdev_internal_ops vfe_v4l2_internal_ops = {
>> +	.open = vfe_init_formats,
>> +};
>> +
>> +static const struct media_entity_operations vfe_media_ops = {
>> +	.link_setup = vfe_link_setup,
>> +	.link_validate = v4l2_subdev_link_validate,
>> +};
>> +
>> +static const struct camss_video_ops camss_vfe_video_ops = {
>> +	.queue_buffer = vfe_queue_buffer,
>> +	.flush_buffers = vfe_flush_buffers,
>> +};
>> +
>> +void msm_vfe_stop_streaming(struct vfe_device *vfe)
>> +{
>> +	int i;
>> +
>> +	for (i = 0; i < ARRAY_SIZE(vfe->line); i++)
>> +		msm_video_stop_streaming(&vfe->line[i].video_out);
>> +}
>> +
>> +/*
>> + * msm_vfe_register_entities - Register subdev node for VFE module
>> + * @vfe: VFE device
>> + * @v4l2_dev: V4L2 device
>> + *
>> + * Initialize and register a subdev node for the VFE module. Then
>> + * call msm_video_register() to register the video device node which
>> + * will be connected to this subdev node. Then actually create the
>> + * media link between them.
>> + *
>> + * Return 0 on success or a negative error code otherwise
>> + */
>> +int msm_vfe_register_entities(struct vfe_device *vfe,
>> +			      struct v4l2_device *v4l2_dev)
>> +{
>> +	struct device *dev = to_device(vfe);
>> +	struct v4l2_subdev *sd;
>> +	struct media_pad *pads;
>> +	struct camss_video *video_out;
>> +	int ret;
>> +	int i;
>> +
>> +	for (i = 0; i < ARRAY_SIZE(vfe->line); i++) {
>> +		char name[32];
>> +
>> +		sd = &vfe->line[i].subdev;
>> +		pads = vfe->line[i].pads;
>> +		video_out = &vfe->line[i].video_out;
>> +
>> +		v4l2_subdev_init(sd, &vfe_v4l2_ops);
>> +		sd->internal_ops = &vfe_v4l2_internal_ops;
>> +		sd->flags |= V4L2_SUBDEV_FL_HAS_DEVNODE;
>> +		snprintf(sd->name, ARRAY_SIZE(sd->name), "%s%d_%s%d",
>> +			 MSM_VFE_NAME, vfe->id, "rdi", i);
>> +		v4l2_set_subdevdata(sd, &vfe->line[i]);
>> +
>> +		ret = vfe_init_formats(sd, NULL);
>> +		if (ret < 0) {
>> +			dev_err(dev, "Failed to init format: %d\n", ret);
>> +			goto error_init;
>> +		}
>> +
>> +		pads[MSM_VFE_PAD_SINK].flags = MEDIA_PAD_FL_SINK;
>> +		pads[MSM_VFE_PAD_SRC].flags = MEDIA_PAD_FL_SOURCE;
>> +
>> +		sd->entity.function = MEDIA_ENT_F_PROC_VIDEO_PIXEL_FORMATTER;
>> +		sd->entity.ops = &vfe_media_ops;
>> +		ret = media_entity_pads_init(&sd->entity, MSM_VFE_PADS_NUM,
>> +					     pads);
>> +		if (ret < 0) {
>> +			dev_err(dev, "Failed to init media entity: %d\n", ret);
>> +			goto error_init;
>> +		}
>> +
>> +		ret = v4l2_device_register_subdev(v4l2_dev, sd);
>> +		if (ret < 0) {
>> +			dev_err(dev, "Failed to register subdev: %d\n", ret);
>> +			goto error_reg_subdev;
>> +		}
>> +
>> +		video_out->ops = &camss_vfe_video_ops;
>> +		snprintf(name, ARRAY_SIZE(name), "%s%d_%s%d",
>> +			 MSM_VFE_NAME, vfe->id, "video", i);
>> +		ret = msm_video_register(video_out, v4l2_dev, name);
>> +		if (ret < 0) {
>> +			dev_err(dev, "Failed to register video node: %d\n",
>> +				ret);
>> +			goto error_reg_video;
>> +		}
>> +
>> +		ret = media_create_pad_link(
>> +				&sd->entity, MSM_VFE_PAD_SRC,
>> +				&video_out->vdev.entity, 0,
>> +				MEDIA_LNK_FL_IMMUTABLE | MEDIA_LNK_FL_ENABLED);
>> +		if (ret < 0) {
>> +			dev_err(dev, "Failed to link %s->%s entities: %d\n",
>> +				sd->entity.name, video_out->vdev.entity.name,
>> +				ret);
>> +			goto error_link;
>> +		}
>> +
>> +		ret = msm_video_init_format(video_out);
>> +		if (ret < 0) {
>> +			dev_err(dev, "Failed to init format: %d\n", ret);
>> +			goto error_link;
>> +		}
>> +
>> +	}
>> +
>> +	return 0;
>> +
>> +error_link:
>> +	msm_video_unregister(video_out);
>> +
>> +error_reg_video:
>> +	v4l2_device_unregister_subdev(sd);
>> +
>> +error_reg_subdev:
>> +	media_entity_cleanup(&sd->entity);
>> +
>> +error_init:
>> +	for (i--; i >= 0; i--) {
>> +		sd = &vfe->line[i].subdev;
>> +		video_out = &vfe->line[i].video_out;
>> +
>> +		msm_video_unregister(video_out);
>> +		v4l2_device_unregister_subdev(sd);
>> +		media_entity_cleanup(&sd->entity);
>> +	}
>> +
>> +	return ret;
>> +}
>> +
>> +/*
>> + * msm_vfe_unregister_entities - Unregister VFE module subdev node
>> + * @vfe: VFE device
>> + */
>> +void msm_vfe_unregister_entities(struct vfe_device *vfe)
>> +{
>> +	int i;
>> +
>> +	mutex_destroy(&vfe->power_lock);
>> +	mutex_destroy(&vfe->stream_lock);
>> +
>> +	for (i = 0; i < ARRAY_SIZE(vfe->line); i++) {
>> +		struct v4l2_subdev *sd = &vfe->line[i].subdev;
>> +		struct camss_video *video_out = &vfe->line[i].video_out;
>> +
>> +		msm_video_unregister(video_out);
>> +		v4l2_device_unregister_subdev(sd);
>> +		media_entity_cleanup(&sd->entity);
>> +	}
>> +}
>> diff --git a/drivers/media/platform/qcom/camss-8x16/camss-vfe.h b/drivers/media/platform/qcom/camss-8x16/camss-vfe.h
>> new file mode 100644
>> index 0000000..6d2fc57
>> --- /dev/null
>> +++ b/drivers/media/platform/qcom/camss-8x16/camss-vfe.h
>> @@ -0,0 +1,114 @@
>> +/*
>> + * camss-vfe.h
>> + *
>> + * Qualcomm MSM Camera Subsystem - VFE Module
>> + *
>> + * Copyright (c) 2013-2015, The Linux Foundation. All rights reserved.
>> + * Copyright (C) 2015-2017 Linaro Ltd.
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
>> +#ifndef QC_MSM_CAMSS_VFE_H
>> +#define QC_MSM_CAMSS_VFE_H
>> +
>> +#include <linux/clk.h>
>> +#include <linux/spinlock_types.h>
>> +#include <media/media-entity.h>
>> +#include <media/v4l2-device.h>
>> +#include <media/v4l2-subdev.h>
>> +
>> +#include "camss-video.h"
>> +
>> +#define MSM_VFE_PAD_SINK 0
>> +#define MSM_VFE_PAD_SRC 1
>> +#define MSM_VFE_PADS_NUM 2
>> +
>> +#define MSM_VFE_LINE_NUM 3
>> +#define MSM_VFE_IMAGE_MASTERS_NUM 7
>> +
>> +#define MSM_VFE_VFE0_UB_SIZE 1023
>> +#define MSM_VFE_VFE0_UB_SIZE_RDI (MSM_VFE_VFE0_UB_SIZE / 3)
>> +#define MSM_VFE_VFE1_UB_SIZE 1535
>> +#define MSM_VFE_VFE1_UB_SIZE_RDI (MSM_VFE_VFE1_UB_SIZE / 3)
>> +
>> +enum vfe_output_state {
>> +	VFE_OUTPUT_OFF,
>> +	VFE_OUTPUT_RESERVED,
>> +	VFE_OUTPUT_SINGLE,
>> +	VFE_OUTPUT_CONTINUOUS,
>> +	VFE_OUTPUT_IDLE,
>> +	VFE_OUTPUT_STOPPING
>> +};
>> +
>> +enum vfe_line_id {
>> +	VFE_LINE_NONE = -1,
>> +	VFE_LINE_RDI0 = 0,
>> +	VFE_LINE_RDI1 = 1,
>> +	VFE_LINE_RDI2 = 2
>> +};
>> +
>> +struct vfe_output {
>> +	u8 wm_idx;
>> +
>> +	int active_buf;
>> +	struct camss_buffer *buf[2];
>> +	struct camss_buffer *last_buffer;
>> +	struct list_head pending_bufs;
>> +
>> +	unsigned int drop_update_idx;
>> +
>> +	enum vfe_output_state state;
>> +	unsigned int sequence;
>> +};
>> +
>> +struct vfe_line {
>> +	enum vfe_line_id id;
>> +	struct v4l2_subdev subdev;
>> +	struct media_pad pads[MSM_VFE_PADS_NUM];
>> +	struct v4l2_mbus_framefmt fmt[MSM_VFE_PADS_NUM];
>> +	struct camss_video video_out;
>> +	struct vfe_output output;
>> +};
>> +
>> +struct vfe_device {
>> +	u8 id;
>> +	void __iomem *base;
>> +	u32 irq;
>> +	char irq_name[30];
>> +	struct clk **clock;
>> +	int nclocks;
>> +	struct completion reset_complete;
>> +	struct completion halt_complete;
>> +	struct mutex power_lock;
>> +	int power_count;
>> +	struct mutex stream_lock;
>> +	int stream_count;
>> +	spinlock_t output_lock;
>> +	enum vfe_line_id wm_output_map[MSM_VFE_IMAGE_MASTERS_NUM];
>> +	struct vfe_line line[MSM_VFE_LINE_NUM];
>> +	u32 reg_update;
>> +	u8 was_streaming;
>> +};
>> +
>> +struct resources;
>> +
>> +int msm_vfe_subdev_init(struct vfe_device *vfe, const struct resources *res);
>> +
>> +int msm_vfe_register_entities(struct vfe_device *vfe,
>> +			      struct v4l2_device *v4l2_dev);
>> +
>> +void msm_vfe_unregister_entities(struct vfe_device *vfe);
>> +
>> +void msm_vfe_get_vfe_id(struct media_entity *entity, u8 *id);
>> +void msm_vfe_get_vfe_line_id(struct media_entity *entity, enum vfe_line_id *id);
>> +
>> +void msm_vfe_stop_streaming(struct vfe_device *vfe);
>> +
>> +#endif /* QC_MSM_CAMSS_VFE_H */
> 

-- 
Best regards,
Todor Tomov
