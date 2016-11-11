Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f47.google.com ([74.125.82.47]:37840 "EHLO
        mail-wm0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755629AbcKKQRH (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 11 Nov 2016 11:17:07 -0500
Received: by mail-wm0-f47.google.com with SMTP id t79so100371495wmt.0
        for <linux-media@vger.kernel.org>; Fri, 11 Nov 2016 08:17:06 -0800 (PST)
Subject: Re: [PATCH v3 3/9] media: venus: adding core part and helper
 functions
To: Stephen Boyd <sboyd@codeaurora.org>,
        Stanimir Varbanov <stanimir.varbanov@linaro.org>
References: <1478540043-24558-1-git-send-email-stanimir.varbanov@linaro.org>
 <1478540043-24558-4-git-send-email-stanimir.varbanov@linaro.org>
 <20161110214339.GF16026@codeaurora.org>
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Andy Gross <andy.gross@linaro.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org
From: Stanimir Varbanov <stanimir.varbanov@linaro.org>
Message-ID: <550b86f3-e687-ddcd-2f20-d430bbe06940@linaro.org>
Date: Fri, 11 Nov 2016 18:17:01 +0200
MIME-Version: 1.0
In-Reply-To: <20161110214339.GF16026@codeaurora.org>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Stephen,

Thanks for the comments!

On 11/10/2016 11:43 PM, Stephen Boyd wrote:
> On 11/07, Stanimir Varbanov wrote:
>> diff --git a/drivers/media/platform/qcom/venus/core.c b/drivers/media/platform/qcom/venus/core.c
>> new file mode 100644
>> index 000000000000..7b14b1f12e20
>> --- /dev/null
>> +++ b/drivers/media/platform/qcom/venus/core.c
>> @@ -0,0 +1,557 @@
>> +/*
>> + * Copyright (c) 2012-2015, The Linux Foundation. All rights reserved.
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
>> + *
>> + */
>> +#include <linux/clk.h>
>> +#include <linux/init.h>
>> +#include <linux/ioctl.h>
>> +#include <linux/list.h>
>> +#include <linux/module.h>
>> +#include <linux/of_device.h>
>> +#include <linux/platform_device.h>
>> +#include <linux/slab.h>
>> +#include <linux/types.h>
>> +#include <linux/remoteproc.h>
>> +#include <linux/pm_runtime.h>
>> +#include <media/videobuf2-v4l2.h>
>> +#include <media/v4l2-ioctl.h>
>> +
>> +#include "core.h"
>> +#include "vdec.h"
>> +#include "venc.h"
>> +
>> +struct venus_sys_error {
>> +	struct venus_core *core;
>> +	struct delayed_work work;
>> +};
>> +
>> +static void venus_sys_error_handler(struct work_struct *work)
>> +{
>> +	struct venus_sys_error *handler =
>> +		container_of(work, struct venus_sys_error, work.work);
> 
> Perhaps to_delayed_work(work) would be better?

I'd say that it will be used only here... but I can do it for you ;)

> 
>> +	struct venus_core *core = handler->core;
>> +	struct device *dev = core->dev;
>> +	int ret;
>> +
>> +	mutex_lock(&core->lock);
>> +	if (core->state != CORE_INVALID)
> 
> Is this ever possible? Couldn't we cancel the delayed work
> instead?

Looks like over engineered, shouldn't be possible.

> 
>> +		goto exit;
>> +
>> +	mutex_unlock(&core->lock);
>> +
>> +	ret = hfi_core_deinit(core);
>> +	if (ret)
>> +		dev_err(dev, "core: deinit failed (%d)\n", ret);
>> +
>> +	mutex_lock(&core->lock);
>> +
>> +	rproc_report_crash(core->rproc, RPROC_FATAL_ERROR);
>> +
>> +	rproc_shutdown(core->rproc);
>> +
>> +	ret = rproc_boot(core->rproc);
>> +	if (ret)
>> +		goto exit;
>> +
>> +	core->state = CORE_INIT;
>> +
>> +exit:
>> +	mutex_unlock(&core->lock);
>> +	kfree(handler);
>> +}
>> +
>> +static int venus_event_notify(struct venus_core *core, u32 event)
>> +{
>> +	struct venus_sys_error *handler;
>> +	struct venus_inst *inst;
>> +
>> +	switch (event) {
>> +	case EVT_SYS_WATCHDOG_TIMEOUT:
>> +	case EVT_SYS_ERROR:
>> +		break;
>> +	default:
>> +		return -EINVAL;
>> +	}
>> +
>> +	mutex_lock(&core->lock);
>> +
>> +	core->state = CORE_INVALID;
>> +
>> +	list_for_each_entry(inst, &core->instances, list) {
>> +		mutex_lock(&inst->lock);
>> +		inst->state = INST_INVALID;
>> +		mutex_unlock(&inst->lock);
>> +	}
>> +
>> +	mutex_unlock(&core->lock);
>> +
>> +	handler = kzalloc(sizeof(*handler), GFP_KERNEL);
>> +	if (!handler)
>> +		return -ENOMEM;
>> +
>> +	handler->core = core;
>> +	INIT_DELAYED_WORK(&handler->work, venus_sys_error_handler);
>> +
>> +	/*
>> +	 * Sleep for 5 sec to ensure venus has completed any
>> +	 * pending cache operations. Without this sleep, we see
>> +	 * device reset when firmware is unloaded after a sys
>> +	 * error.
>> +	 */
>> +	schedule_delayed_work(&handler->work, msecs_to_jiffies(5000));
> 
> Is there a reason we just don't msleep() here instead? Does this
> get called from an interrupt handler or something where we can't
> sleep? A comment in the code with the answer here would be
> helpful.

This function is called from threaded interrupt handler, so it can
sleep. This error handling is not perfect and needs more work, so I will
cleanup and do more testing over this recovery mechanism.

> 
>> +
>> +	return 0;
>> +}
>> +
>> +static const struct hfi_core_ops venus_core_ops = {
>> +	.event_notify = venus_event_notify,
>> +};
>> +
>> +static int venus_open(struct file *file)
>> +{
>> +	struct video_device *vdev = video_devdata(file);
>> +	struct venus_core *core = video_drvdata(file);
>> +	struct venus_inst *inst;
>> +	int ret;
>> +
>> +	inst = kzalloc(sizeof(*inst), GFP_KERNEL);
>> +	if (!inst)
>> +		return -ENOMEM;
>> +
>> +	INIT_LIST_HEAD(&inst->registeredbufs);
>> +	mutex_init(&inst->registeredbufs_lock);
>> +
>> +	INIT_LIST_HEAD(&inst->internalbufs);
>> +	mutex_init(&inst->internalbufs_lock);
>> +
>> +	INIT_LIST_HEAD(&inst->bufqueue);
>> +	mutex_init(&inst->bufqueue_lock);
>> +
>> +	INIT_LIST_HEAD(&inst->list);
>> +	mutex_init(&inst->lock);
>> +
>> +	inst->core = core;
>> +
>> +	if (vdev == core->vdev_dec) {
>> +		inst->session_type = VIDC_SESSION_TYPE_DEC;
>> +		ret = vdec_open(inst);
>> +		if (ret)
>> +			goto err_free_inst;
>> +		v4l2_fh_init(&inst->fh, core->vdev_dec);
>> +	} else {
>> +		inst->session_type = VIDC_SESSION_TYPE_ENC;
>> +		ret = venc_open(inst);
>> +		if (ret)
>> +			goto err_free_inst;
>> +		v4l2_fh_init(&inst->fh, core->vdev_enc);
>> +	}
>> +
>> +	inst->fh.ctrl_handler = &inst->ctrl_handler;
>> +	v4l2_fh_add(&inst->fh);
>> +	file->private_data = &inst->fh;
>> +
>> +	return 0;
>> +
>> +err_free_inst:
>> +	kfree(inst);
>> +	return ret;
>> +}
>> +
>> +const struct v4l2_file_operations venus_fops = {
> 
> static?

yes.

> 
>> +	.owner = THIS_MODULE,
>> +	.open = venus_open,
>> +	.release = venus_close,
>> +	.unlocked_ioctl = video_ioctl2,
>> +	.poll = venus_poll,
>> +	.mmap = venus_mmap,
>> +#ifdef CONFIG_COMPAT
>> +	.compat_ioctl32 = v4l2_compat_ioctl32,
>> +#endif
>> +};
>> +
>> +static irqreturn_t venus_isr_thread(int irq, void *dev_id)
> 
> s/dev_id/core/
> 
>> +{
>> +	struct venus_core *core = dev_id;
>> +
>> +	return hfi_isr_thread(core);
> 
> And replace with hfi_isr_thread(core)?
> 
> Or even just pass int irq to hfi_isr_thread and not have this
> simple wrapper.
> 
>> +}
>> +
>> +static irqreturn_t venus_isr(int irq, void *dev)
>> +{
>> +	struct venus_core *core = dev;
>> +
>> +	return hfi_isr(core);
> 
> Same story here.

OK.

> 
>> +}
> [..]
>> +
>> +static int venus_probe(struct platform_device *pdev)
>> +{
>> +	struct device *dev = &pdev->dev;
>> +	struct venus_core *core;
>> +	struct device_node *rproc;
>> +	struct resource *r;
>> +	int ret;
>> +
>> +	core = devm_kzalloc(dev, sizeof(*core), GFP_KERNEL);
>> +	if (!core)
>> +		return -ENOMEM;
>> +
>> +	core->dev = dev;
>> +	platform_set_drvdata(pdev, core);
>> +
>> +	rproc = of_parse_phandle(dev->of_node, "rproc", 0);
>> +	if (IS_ERR(rproc))
>> +		return PTR_ERR(rproc);
>> +
>> +	core->rproc = rproc_get_by_phandle(rproc->phandle);
>> +	if (IS_ERR(core->rproc))
>> +		return PTR_ERR(core->rproc);
>> +	else if (!core->rproc)
> 
> Could drop the else here.

OK.

> 
>> +		return -EPROBE_DEFER;
>> +
>> +	r = platform_get_resource_byname(pdev, IORESOURCE_MEM, "venus");
>> +	core->base = devm_ioremap_resource(dev, r);
>> +	if (IS_ERR(core->base))
>> +		return PTR_ERR(core->base);
>> +
>> +	core->irq = platform_get_irq_byname(pdev, "venus");
>> diff --git a/drivers/media/platform/qcom/venus/core.h b/drivers/media/platform/qcom/venus/core.h
>> new file mode 100644
>> index 000000000000..21ed053aeb17
>> --- /dev/null
>> +++ b/drivers/media/platform/qcom/venus/core.h
>> @@ -0,0 +1,261 @@
>> +/*
>> + * Copyright (c) 2012-2015, The Linux Foundation. All rights reserved.
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
>> + *
>> + */
>> +
>> +#ifndef __VIDC_CORE_H_
>> +#define __VIDC_CORE_H_
> 
> Maybe these macros should change from VIDC to VENUS?

yes, I forgot to update them.

> 
>> +
>> +#include <media/v4l2-device.h>
>> +#include <media/v4l2-ctrls.h>
>> +#include <media/videobuf2-core.h>
>> +
>> +#include "hfi.h"
>> +
>> +#define VIDC_CLKS_NUM_MAX	12
>> +
>> +struct freq_tbl {
>> +	unsigned int load;
>> +	unsigned long freq;
>> +};
>> +
>> +struct reg_val {
>> +	u32 reg;
>> +	u32 value;
>> +};
>> +
>> +struct venus_resources {
>> +	u64 dma_mask;
>> +	const struct freq_tbl *freq_tbl;
>> +	unsigned int freq_tbl_size;
>> +	const struct reg_val *reg_tbl;
>> +	unsigned int reg_tbl_size;
>> +	const char * const clks[VIDC_CLKS_NUM_MAX];
>> +	unsigned int clks_num;
>> +	enum hfi_version hfi_version;
>> +	u32 max_load;
>> +	unsigned int vmem_id;
>> +	u32 vmem_size;
>> +	u32 vmem_addr;
>> +};
>> +
>> +struct venus_format {
>> +	u32 pixfmt;
>> +	int num_planes;
>> +	u32 type;
>> +};
>> +
>> +struct venus_core {
>> +	void __iomem *base;
>> +	int irq;
> 
> Is this ever used?

yes it is, but can be removed.

> 
>> +	struct clk *clks[VIDC_CLKS_NUM_MAX];
>> +	struct video_device *vdev_dec;
>> +	struct video_device *vdev_enc;
>> +	struct v4l2_device v4l2_dev;
>> +	const struct venus_resources *res;
>> +	struct rproc *rproc;
>> +	struct device *dev;
>> +	struct mutex lock;
>> +	struct list_head instances;
>> +
>> +	/* HFI core fields */
>> +	unsigned int state;
>> +	struct completion done;
>> +	unsigned int error;
>> +
>> +	/* core operations passed by outside world */
>> +	const struct hfi_core_ops *core_ops;
>> +
>> +	/* filled by sys core init */
>> +	u32 enc_codecs;
>> +	u32 dec_codecs;
>> +	unsigned int max_sessions_supported;
>> +
>> +	/* core capabilities */
>> +#define ENC_ROTATION_CAPABILITY		0x1
>> +#define ENC_SCALING_CAPABILITY		0x2
>> +#define ENC_DEINTERLACE_CAPABILITY	0x4
>> +#define DEC_MULTI_STREAM_CAPABILITY	0x8
>> +	unsigned int core_caps;
>> +
>> +	/* internal hfi operations */
>> +	void *priv;
>> +	const struct hfi_ops *ops;
>> +};
>> +
>> +struct vdec_controls {
>> +	u32 post_loop_deb_mode;
>> +	u32 profile;
>> +	u32 level;
>> +};
>> +
>> +struct venc_controls {
>> +	u16 gop_size;
>> +	u32 idr_period;
>> +	u32 num_p_frames;
>> +	u32 num_b_frames;
>> +	u32 bitrate_mode;
>> +	u32 bitrate;
>> +	u32 bitrate_peak;
>> +
>> +	u32 h264_i_period;
>> +	u32 h264_entropy_mode;
>> +	u32 h264_i_qp;
>> +	u32 h264_p_qp;
>> +	u32 h264_b_qp;
>> +	u32 h264_min_qp;
>> +	u32 h264_max_qp;
>> +	u32 h264_loop_filter_mode;
>> +	u32 h264_loop_filter_alpha;
>> +	u32 h264_loop_filter_beta;
>> +
>> +	u32 vp8_min_qp;
>> +	u32 vp8_max_qp;
>> +
>> +	u32 multi_slice_mode;
>> +	u32 multi_slice_max_bytes;
>> +	u32 multi_slice_max_mb;
>> +
>> +	u32 header_mode;
>> +
>> +	u32 profile;
>> +	u32 level;
>> +};
>> +
>> +struct venus_inst {
> 
> Can we have some kernel doc on these structures?

yes, we can ...

> 
>> +	struct list_head list;
>> +	struct mutex lock;
> 
> e.g. what is lock protecting? list?
> 
>> +
>> +	struct venus_core *core;
>> +
>> +	struct list_head internalbufs;
>> +	struct mutex internalbufs_lock;
>> +
>> +	struct list_head registeredbufs;
>> +	struct mutex registeredbufs_lock;
>> +
>> +	struct list_head bufqueue;
>> +	struct mutex bufqueue_lock;
>> +
>> +	struct vb2_queue bufq_out;
>> +	struct vb2_queue bufq_cap;
>> +
>> +	struct v4l2_ctrl_handler ctrl_handler;
>> +	union {
>> +		struct vdec_controls dec;
>> +		struct venc_controls enc;
>> +	} controls;
>> +	struct v4l2_fh fh;
>> +
>> +	/* v4l2 fields */
>> +	u32 width;
>> +	u32 height;
>> +	u32 out_width;
>> +	u32 out_height;
>> +	u32 colorspace;
>> +	u8 ycbcr_enc;
>> +	u8 quantization;
>> +	u8 xfer_func;
>> +	u64 fps;
>> +	struct v4l2_fract timeperframe;
>> +	const struct venus_format *fmt_out;
>> +	const struct venus_format *fmt_cap;
>> +	unsigned int num_input_bufs;
>> +	unsigned int num_output_bufs;
>> +	unsigned int output_buf_size;
>> +	bool in_reconfig;
>> +	u32 reconfig_width;
>> +	u32 reconfig_height;
>> +	u64 sequence;
>> +	bool codec_cfg;
>> +
>> +	/* HFI instance fields */
>> +	unsigned int state;
>> +	struct completion done;
>> +	unsigned int error;
>> +
>> +	/* instance operations passed by outside world */
>> +	const struct hfi_inst_ops *ops;
>> +	void *priv;
>> +	u32 session_type;
>> +	union hfi_get_property hprop;
>> +
>> +	/* capabilities filled by session_init */
>> +	struct hfi_capability cap_width;
>> +	struct hfi_capability cap_height;
>> +	struct hfi_capability cap_mbs_per_frame;
>> +	struct hfi_capability cap_mbs_per_sec;
>> +	struct hfi_capability cap_framerate;
>> +	struct hfi_capability cap_scale_x;
>> +	struct hfi_capability cap_scale_y;
>> +	struct hfi_capability cap_bitrate;
>> +	struct hfi_capability cap_hier_p;
>> +	struct hfi_capability cap_ltr_count;
>> +	struct hfi_capability cap_secure_output2_threshold;
>> +	bool cap_bufs_mode_static;
>> +	bool cap_bufs_mode_dynamic;
>> +
>> +	/* profile & level pairs supported */
>> +	unsigned int pl_count;
>> +	struct hfi_profile_level pl[HFI_MAX_PROFILE_COUNT];
>> +
>> +	/* buffer requirements */
>> +	struct hfi_buffer_requirements bufreq[HFI_BUFFER_TYPE_MAX];
>> +};
>> +
>> +#define ctrl_to_inst(ctrl)	\
>> +	container_of(ctrl->handler, struct venus_inst, ctrl_handler)
>> +
>> +struct venus_ctrl {
>> +	u32 id;
>> +	enum v4l2_ctrl_type type;
>> +	s32 min;
>> +	s32 max;
>> +	s32 def;
>> +	u32 step;
>> +	u64 menu_skip_mask;
>> +	u32 flags;
>> +	const char * const *qmenu;
>> +};
>> diff --git a/drivers/media/platform/qcom/venus/helpers.c b/drivers/media/platform/qcom/venus/helpers.c
>> new file mode 100644
>> index 000000000000..c2d1446ad254
>> --- /dev/null
>> +++ b/drivers/media/platform/qcom/venus/helpers.c
>> @@ -0,0 +1,612 @@
>> +/*
>> + * Copyright (c) 2012-2015, The Linux Foundation. All rights reserved.
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
>> + *
>> + */
>> +#include <linux/clk.h>
>> +#include <linux/list.h>
>> +#include <linux/mutex.h>
>> +#include <linux/pm_runtime.h>
>> +#include <media/videobuf2-dma-sg.h>
>> +
>> +#include "helpers.h"
>> +#include "hfi_helper.h"
>> +
>> +struct intbuf {
>> +	struct list_head list;
>> +	u32 type;
>> +	size_t size;
>> +	void *va;
>> +	dma_addr_t da;
>> +	unsigned long attrs;
>> +};
>> +
>> +static int intbufs_set_buffer(struct venus_inst *inst, u32 type)
>> +{
>> +	struct venus_core *core = inst->core;
>> +	struct device *dev = core->dev;
>> +	struct hfi_buffer_requirements bufreq;
>> +	struct hfi_buffer_desc bd;
>> +	struct intbuf *buf;
>> +	unsigned int i;
>> +	int ret;
>> +
>> +	ret = vidc_get_bufreq(inst, type, &bufreq);
>> +	if (ret)
>> +		return 0;
>> +
>> +	if (!bufreq.size)
>> +		return 0;
>> +
>> +	for (i = 0; i < bufreq.count_actual; i++) {
>> +		buf = kzalloc(sizeof(*buf), GFP_KERNEL);
>> +		if (!buf) {
>> +			ret = -ENOMEM;
>> +			goto fail;
>> +		}
>> +
>> +		buf->type = bufreq.type;
>> +		buf->size = bufreq.size;
>> +		buf->attrs = DMA_ATTR_WRITE_COMBINE |
>> +			     DMA_ATTR_NO_KERNEL_MAPPING;
>> +		buf->va = dma_alloc_attrs(dev, buf->size, &buf->da, GFP_KERNEL,
>> +					  buf->attrs);
>> +		if (!buf->va) {
>> +			ret = -ENOMEM;
>> +			goto fail;
>> +		}
>> +
>> +		memset(&bd, 0, sizeof(bd));
>> +		bd.buffer_size = buf->size;
>> +		bd.buffer_type = buf->type;
>> +		bd.num_buffers = 1;
>> +		bd.device_addr = buf->da;
>> +
>> +		ret = hfi_session_set_buffers(inst, &bd);
>> +		if (ret) {
>> +			dev_err(dev, "set session buffers failed\n");
>> +			goto fail;
>> +		}
>> +
>> +		mutex_lock(&inst->internalbufs_lock);
>> +		list_add_tail(&buf->list, &inst->internalbufs);
>> +		mutex_unlock(&inst->internalbufs_lock);
>> +	}
>> +
>> +	return 0;
>> +
>> +fail:
>> +	kfree(buf);
>> +	return ret;
>> +}
>> +
>> +static int intbufs_unset_buffers(struct venus_inst *inst)
>> +{
>> +	struct hfi_buffer_desc bd = {0};
>> +	struct intbuf *buf, *n;
>> +	int ret = 0;
>> +
>> +	mutex_lock(&inst->internalbufs_lock);
>> +	list_for_each_entry_safe(buf, n, &inst->internalbufs, list) {
>> +		bd.buffer_size = buf->size;
>> +		bd.buffer_type = buf->type;
>> +		bd.num_buffers = 1;
>> +		bd.device_addr = buf->da;
>> +		bd.response_required = true;
>> +
>> +		ret = hfi_session_unset_buffers(inst, &bd);
> 
> Should this be ret |= ? Only the last time through the loop will
> there be an error. Or perhaps we should be bailing out early from
> this loop?

I think that even if unset_buffers fail we need to free the memory. In
case of an error in firmware while unset buffers we should mark the
session as invalid and abort the session acordingly.

> 
>> +
>> +		list_del(&buf->list);
>> +		dma_free_attrs(inst->core->dev, buf->size, buf->va, buf->da,
>> +			       buf->attrs);
>> +		kfree(buf);
>> +	}
>> +	mutex_unlock(&inst->internalbufs_lock);
>> +
>> +	return ret;
>> +}
>> +
>> +static const unsigned int intbuf_types[] = {
>> +	HFI_BUFFER_INTERNAL_SCRATCH,
>> +	HFI_BUFFER_INTERNAL_SCRATCH_1,
>> +	HFI_BUFFER_INTERNAL_SCRATCH_2,
>> +	HFI_BUFFER_INTERNAL_PERSIST,
>> +	HFI_BUFFER_INTERNAL_PERSIST_1,
>> +};
>> +
>> +static int intbufs_alloc(struct venus_inst *inst)
>> +{
>> +	unsigned int i;
>> +	int ret;
>> +
>> +	for (i = 0; i < ARRAY_SIZE(intbuf_types); i++) {
>> +		ret = intbufs_set_buffer(inst, intbuf_types[i]);
>> +		if (ret)
>> +			goto error;
>> +	}
>> +
>> +	return 0;
>> +
>> +error:
>> +	intbufs_unset_buffers(inst);
>> +	return ret;
>> +}
>> +
>> +static int intbufs_free(struct venus_inst *inst)
>> +{
>> +	return intbufs_unset_buffers(inst);
>> +}
>> +
>> +static u32 load_per_instance(struct venus_inst *inst)
>> +{
>> +	u32 w = inst->width;
>> +	u32 h = inst->height;
>> +	u32 mbs;
>> +
>> +	if (!inst || !(inst->state >= INST_INIT && inst->state < INST_STOP))
>> +		return 0;
>> +
>> +	mbs = (ALIGN(w, 16) / 16) * (ALIGN(h, 16) / 16);
>> +
>> +	return mbs * inst->fps;
>> +}
>> +
>> +static u32 load_per_type(struct venus_core *core, u32 session_type)
>> +{
>> +	struct venus_inst *inst = NULL;
>> +	u32 mbs_per_sec = 0;
>> +
>> +	mutex_lock(&core->lock);
>> +	list_for_each_entry(inst, &core->instances, list) {
>> +		if (inst->session_type != session_type)
>> +			continue;
>> +
>> +		mbs_per_sec += load_per_instance(inst);
>> +	}
>> +	mutex_unlock(&core->lock);
>> +
>> +	return mbs_per_sec;
>> +}
>> +
>> +static int load_scale_clocks(struct venus_core *core)
>> +{
>> +	const struct freq_tbl *table = core->res->freq_tbl;
>> +	unsigned int num_rows = core->res->freq_tbl_size;
>> +	unsigned long freq = table[0].freq;
>> +	struct clk *clk = core->clks[0];
>> +	struct device *dev = core->dev;
>> +	u32 mbs_per_sec;
>> +	unsigned int i;
>> +	int ret;
>> +
>> +	mbs_per_sec = load_per_type(core, VIDC_SESSION_TYPE_ENC) +
>> +		      load_per_type(core, VIDC_SESSION_TYPE_DEC);
>> +
>> +	if (mbs_per_sec > core->res->max_load) {
>> +		dev_warn(dev, "HW is overloaded, needed: %d max: %d\n",
>> +			 mbs_per_sec, core->res->max_load);
>> +		return -EBUSY;
>> +	}
>> +
>> +	if (!mbs_per_sec && num_rows > 1) {
>> +		freq = table[num_rows - 1].freq;
>> +		goto set_freq;
>> +	}
>> +
>> +	for (i = 0; i < num_rows; i++) {
>> +		if (mbs_per_sec > table[i].load)
>> +			break;
>> +		freq = table[i].freq;
>> +	}
>> +
>> +set_freq:
>> +
>> +	ret = clk_set_rate(clk, freq);
>> +	if (ret) {
>> +		dev_err(dev, "failed to set clock rate %lu (%d)\n", freq, ret);
>> +		return ret;
>> +	}
>> +
>> +	return 0;
>> +}
>> +
>> +static int session_set_buf(struct vb2_buffer *vb)
>> +{
>> +	struct vb2_v4l2_buffer *vbuf = to_vb2_v4l2_buffer(vb);
>> +	struct vb2_queue *q = vb->vb2_queue;
>> +	struct venus_inst *inst = vb2_get_drv_priv(q);
>> +	struct venus_core *core = inst->core;
>> +	struct device *dev = core->dev;
>> +	struct vidc_buffer *buf = to_vidc_buffer(vbuf);
>> +	struct hfi_frame_data fdata;
>> +	int ret;
>> +
>> +	memset(&fdata, 0, sizeof(fdata));
>> +
>> +	fdata.alloc_len = vb2_plane_size(vb, 0);
>> +	fdata.device_addr = buf->dma_addr;
>> +	fdata.timestamp = vb->timestamp;
>> +	fdata.flags = 0;
>> +	fdata.clnt_data = buf->dma_addr;
>> +
>> +	if (q->type == V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE) {
>> +		fdata.buffer_type = HFI_BUFFER_INPUT;
>> +		fdata.filled_len = vb2_get_plane_payload(vb, 0);
>> +		fdata.offset = vb->planes[0].data_offset;
>> +
>> +		if (vbuf->flags & V4L2_BUF_FLAG_LAST || !fdata.filled_len)
>> +			fdata.flags |= HFI_BUFFERFLAG_EOS;
>> +
>> +		if (inst->codec_cfg == false &&
>> +		    inst->session_type == VIDC_SESSION_TYPE_DEC) {
>> +			inst->codec_cfg = true;
>> +			fdata.flags |= HFI_BUFFERFLAG_CODECCONFIG;
>> +		}
>> +
>> +		ret = hfi_session_etb(inst, &fdata);
>> +	} else if (q->type == V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE) {
>> +		fdata.buffer_type = HFI_BUFFER_OUTPUT;
>> +		fdata.filled_len = 0;
>> +		fdata.offset = 0;
>> +
>> +		ret = hfi_session_ftb(inst, &fdata);
>> +	} else {
>> +		ret = -EINVAL;
>> +	}
> 
> Use a switch statement instead?

EINVAL shouldn't be posible, I will delete the 'else' clause.

> 
>> +
>> +	if (ret) {
>> +		dev_err(dev, "failed to set session buffer (%d)\n", ret);
>> +		return ret;
>> +	}
>> +
>> +	return 0;
>> +}
>> +
>> +static int session_unregister_bufs(struct venus_inst *inst)
>> +{
>> +	struct venus_core *core = inst->core;
>> +	struct device *dev = core->dev;
>> +	struct hfi_buffer_desc *bd;
>> +	struct vidc_buffer *buf, *tmp;
>> +	int ret = 0;
>> +
>> +	if (core->res->hfi_version == HFI_VERSION_3XX)
>> +		return 0;
>> +
>> +	mutex_lock(&inst->registeredbufs_lock);
>> +	list_for_each_entry_safe(buf, tmp, &inst->registeredbufs, hfi_list) {
>> +		list_del(&buf->hfi_list);
>> +		bd = &buf->bd;
>> +		bd->response_required = 1;
>> +		ret = hfi_session_unset_buffers(inst, bd);
>> +		if (ret) {
>> +			dev_err(dev, "%s: session release buffers failed\n",
>> +				__func__);
>> +			break;
>> +		}
>> +	}
>> +	mutex_unlock(&inst->registeredbufs_lock);
>> +
>> +	return ret;
>> +}
>> +
>> +static int session_register_bufs(struct venus_inst *inst)
>> +{
>> +	struct venus_core *core = inst->core;
>> +	struct device *dev = core->dev;
>> +	struct hfi_buffer_desc *bd;
>> +	struct vidc_buffer *buf, *tmp;
>> +	int ret = 0;
>> +
>> +	if (core->res->hfi_version == HFI_VERSION_3XX)
>> +		return 0;
>> +
>> +	mutex_lock(&inst->registeredbufs_lock);
>> +	list_for_each_entry_safe(buf, tmp, &inst->registeredbufs, hfi_list) {
> 
> Do we need to iterate safely? It isn't obvious that the list is
> being modified here.

No, list_for_each_entry should be enough.

> 
>> +		bd = &buf->bd;
>> +		ret = hfi_session_set_buffers(inst, bd);
>> +		if (ret) {
>> +			dev_err(dev, "%s: session: set buffer failed\n",
>> +				__func__);
>> +			break;
>> +		}
>> +	}
>> +	mutex_unlock(&inst->registeredbufs_lock);
>> +
>> +	return ret;
>> +}
>> +
>> +int vidc_get_bufreq(struct venus_inst *inst, u32 type,
>> +		    struct hfi_buffer_requirements *out)
>> +{
>> +	u32 ptype = HFI_PROPERTY_CONFIG_BUFFER_REQUIREMENTS;
>> +	union hfi_get_property hprop;
>> +	int ret, i;
>> +
>> +	if (out)
>> +		memset(out, 0, sizeof(*out));
>> +
>> +	ret = hfi_session_get_property(inst, ptype, &hprop);
>> +	if (ret)
>> +		return ret;
>> +
>> +	ret = -EINVAL;
>> +
>> +	for (i = 0; i < HFI_BUFFER_TYPE_MAX; i++) {
>> +		if (hprop.bufreq[i].type != type)
>> +			continue;
>> +
>> +		if (out)
>> +			memcpy(out, &hprop.bufreq[i], sizeof(*out));
>> +		ret = 0;
>> +		break;
>> +	}
>> +
>> +	return ret;
>> +}
>> +
>> +int vidc_set_color_format(struct venus_inst *inst, u32 type, u32 pixfmt)
>> +{
>> +	struct hfi_uncompressed_format_select fmt;
>> +	u32 ptype = HFI_PROPERTY_PARAM_UNCOMPRESSED_FORMAT_SELECT;
>> +	int ret;
>> +
>> +	fmt.buffer_type = type;
>> +
>> +	switch (pixfmt) {
>> +	case V4L2_PIX_FMT_NV12:
>> +		fmt.format = HFI_COLOR_FORMAT_NV12;
>> +		break;
>> +	case V4L2_PIX_FMT_NV21:
>> +		fmt.format = HFI_COLOR_FORMAT_NV21;
>> +		break;
>> +	default:
>> +		return -EINVAL;
>> +	}
>> +
>> +	ret = hfi_session_set_property(inst, ptype, &fmt);
>> +	if (ret)
>> +		return ret;
>> +
>> +	return 0;
>> +}
>> +
>> +struct vb2_v4l2_buffer *
>> +vidc_vb2_find_buf(struct venus_inst *inst, dma_addr_t addr)
>> +{
>> +	struct vidc_buffer *buf;
>> +	struct vb2_v4l2_buffer *vb = NULL;
>> +
>> +	mutex_lock(&inst->bufqueue_lock);
>> +
>> +	list_for_each_entry(buf, &inst->bufqueue, list) {
>> +		if (buf->dma_addr == addr) {
>> +			vb = &buf->vb;
>> +			break;
>> +		}
>> +	}
>> +
>> +	if (vb)
>> +		list_del(&buf->list);
>> +
>> +	mutex_unlock(&inst->bufqueue_lock);
>> +
>> +	return vb;
>> +}
>> +
>> +int vidc_vb2_buf_init(struct vb2_buffer *vb)
>> +{
>> +	struct vb2_v4l2_buffer *vbuf = to_vb2_v4l2_buffer(vb);
>> +	struct vb2_queue *q = vb->vb2_queue;
>> +	struct venus_inst *inst = vb2_get_drv_priv(q);
>> +	struct vidc_buffer *buf = to_vidc_buffer(vbuf);
>> +	struct hfi_buffer_desc *bd = &buf->bd;
>> +	struct sg_table *sgt;
>> +
>> +	memset(bd, 0, sizeof(*bd));
>> +
>> +	if (q->type != V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE)
>> +		return 0;
>> +
>> +	sgt = vb2_dma_sg_plane_desc(vb, 0);
>> +	if (!sgt)
>> +		return -EINVAL;
>> +
>> +	bd->buffer_size = vb2_plane_size(vb, 0);
>> +	bd->buffer_type = HFI_BUFFER_OUTPUT;
>> +	bd->num_buffers = 1;
>> +	bd->device_addr = sg_dma_address(sgt->sgl);
>> +
>> +	mutex_lock(&inst->registeredbufs_lock);
>> +	list_add_tail(&buf->hfi_list, &inst->registeredbufs);
>> +	mutex_unlock(&inst->registeredbufs_lock);
>> +
>> +	return 0;
>> +}
>> +
>> +int vidc_vb2_buf_prepare(struct vb2_buffer *vb)
>> +{
>> +	struct vb2_v4l2_buffer *vbuf = to_vb2_v4l2_buffer(vb);
>> +	struct vidc_buffer *buf = to_vidc_buffer(vbuf);
>> +	struct sg_table *sgt;
>> +
>> +	sgt = vb2_dma_sg_plane_desc(vb, 0);
>> +	if (!sgt)
>> +		return -EINVAL;
>> +
>> +	buf->dma_addr = sg_dma_address(sgt->sgl);
>> +
>> +	return 0;
>> +}
>> +
>> +void vidc_vb2_buf_queue(struct vb2_buffer *vb)
>> +{
>> +	struct vb2_v4l2_buffer *vbuf = to_vb2_v4l2_buffer(vb);
>> +	struct venus_inst *inst = vb2_get_drv_priv(vb->vb2_queue);
>> +	struct vidc_buffer *buf = to_vidc_buffer(vbuf);
>> +	unsigned int state;
>> +	int ret;
>> +
>> +	mutex_lock(&inst->lock);
>> +	state = inst->state;
>> +	mutex_unlock(&inst->lock);
>> +
> 
> So if we context switch here and then venus_event_notify() runs
> and marks inst->state as INVALID we won't notice?

Hmm, probably yes, this INVALID exeption should be revisit and the
locking as well.

> 
>> +	if (state == INST_INVALID || state >= INST_STOP) {
>> +		vb2_buffer_done(vb, VB2_BUF_STATE_ERROR);
>> +		return;
>> +	}
>> +
>> +	mutex_lock(&inst->bufqueue_lock);
>> +	list_add_tail(&buf->list, &inst->bufqueue);
>> +	mutex_unlock(&inst->bufqueue_lock);
>> +
>> +	if (!vb2_is_streaming(&inst->bufq_cap) ||
>> +	    !vb2_is_streaming(&inst->bufq_out))
>> +		return;
>> +
>> +	ret = session_set_buf(vb);
>> +	if (ret)
>> +		vb2_buffer_done(vb, VB2_BUF_STATE_ERROR);
>> +}
>> +
>> +void vidc_vb2_stop_streaming(struct vb2_queue *q)
>> +{
>> +	struct venus_inst *inst = vb2_get_drv_priv(q);
>> +	struct venus_core *core = inst->core;
>> +	struct device *dev = core->dev;
>> +	struct vb2_queue *other_queue;
>> +	struct vidc_buffer *buf, *n;
>> +	enum vb2_buffer_state state;
>> +	int ret;
>> +
>> +	if (q->type == V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE)
>> +		other_queue = &inst->bufq_cap;
>> +	else
>> +		other_queue = &inst->bufq_out;
>> +
>> +	if (!vb2_is_streaming(other_queue))
>> +		return;
>> +
>> +	ret = hfi_session_stop(inst);
>> +	if (ret) {
>> +		dev_err(dev, "session: stop failed (%d)\n", ret);
>> +		goto abort;
>> +	}
>> +
>> +	ret = hfi_session_unload_res(inst);
>> +	if (ret) {
>> +		dev_err(dev, "session: release resources failed (%d)\n", ret);
>> +		goto abort;
>> +	}
>> +
>> +	ret = session_unregister_bufs(inst);
>> +	if (ret) {
>> +		dev_err(dev, "failed to release capture buffers: %d\n", ret);
>> +		goto abort;
>> +	}
>> +
>> +	ret = intbufs_free(inst);
>> +
>> +	if (inst->state == INST_INVALID || core->state == CORE_INVALID)
> 
> Here we don't have any lock held for inst->state protection? Is
> there some other lock assumed to be held? We should add a
> lockdep_assert() at the top of this function if so.

I was thinking to revisit the locking at some time. The most of the
locking are keeped as is in the downstream kernel. Currently the
inst->lock is manipulated from two places vdec/venc/helpers and hfi
interface functions. Might be a better idea to move the locks on the
most upper layer i.e. vdec and venc.

> 
>> +		ret = -EINVAL;
>> +
>> +abort:
>> +	if (ret)
>> +		hfi_session_abort(inst);
>> +
>> +	load_scale_clocks(core);
>> +
>> +	ret = hfi_session_deinit(inst);
>> +
>> +	pm_runtime_put_sync(dev);
>> +
>> +	mutex_lock(&inst->bufqueue_lock);
>> +
>> +	if (list_empty(&inst->bufqueue)) {
>> +		mutex_unlock(&inst->bufqueue_lock);
>> +		return;
> 
> Or just let that list_for_each_entry_safe() below iterate over nothing?

yes, good catch.

> 
>> +	}
>> +
>> +	if (ret)
>> +		state = VB2_BUF_STATE_ERROR;
>> +	else
>> +		state = VB2_BUF_STATE_DONE;
>> +
>> +	list_for_each_entry_safe(buf, n, &inst->bufqueue, list) {
>> +		vb2_buffer_done(&buf->vb.vb2_buf, state);
>> +		list_del(&buf->list);
>> +	}
>> +
>> +	mutex_unlock(&inst->bufqueue_lock);
>> +}
>> +
>> +int vidc_vb2_start_streaming(struct venus_inst *inst)
>> +{
>> +	struct venus_core *core = inst->core;
>> +	struct vidc_buffer *buf, *n;
>> +	int ret;
>> +
>> +	ret = intbufs_alloc(inst);
>> +	if (ret)
>> +		return ret;
>> +
>> +	ret = session_register_bufs(inst);
>> +	if (ret)
>> +		goto err_bufs_free;
>> +
>> +	load_scale_clocks(core);
>> +
>> +	ret = hfi_session_load_res(inst);
>> +	if (ret)
>> +		goto err_unreg_bufs;
>> +
>> +	ret = hfi_session_start(inst);
>> +	if (ret)
>> +		goto err_unload_res;
>> +
>> +	mutex_lock(&inst->bufqueue_lock);
>> +	list_for_each_entry_safe(buf, n, &inst->bufqueue, list) {
>> +		ret = session_set_buf(&buf->vb.vb2_buf);
>> +		if (ret)
>> +			break;
>> +	}
>> +	mutex_unlock(&inst->bufqueue_lock);
>> +
>> +	if (ret)
>> +		goto err_session_stop;
>> +
>> +	return 0;
>> +
>> +err_session_stop:
>> +	hfi_session_stop(inst);
>> +err_unload_res:
>> +	hfi_session_unload_res(inst);
>> +err_unreg_bufs:
>> +	session_unregister_bufs(inst);
>> +err_bufs_free:
>> +	intbufs_free(inst);
>> +
>> +	mutex_lock(&inst->bufqueue_lock);
>> +
>> +	if (list_empty(&inst->bufqueue))
>> +		goto err_done;
> 
> Or just iterate over nothing below?
> 
>> +
>> +	list_for_each_entry_safe(buf, n, &inst->bufqueue, list) {
>> +		vb2_buffer_done(&buf->vb.vb2_buf, VB2_BUF_STATE_QUEUED);
>> +		list_del(&buf->list);
>> +	}
>> +
>> +err_done:
>> +	mutex_unlock(&inst->bufqueue_lock);
>> +
>> +	return ret;
>> +}
> 

-- 
regards,
Stan
