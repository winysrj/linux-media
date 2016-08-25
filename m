Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f52.google.com ([74.125.82.52]:36989 "EHLO
        mail-wm0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933843AbcHYM7M (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 25 Aug 2016 08:59:12 -0400
Received: by mail-wm0-f52.google.com with SMTP id i5so70652340wmg.0
        for <linux-media@vger.kernel.org>; Thu, 25 Aug 2016 05:59:11 -0700 (PDT)
Subject: Re: [PATCH 2/8] media: vidc: adding core part and helper functions
To: Bjorn Andersson <bjorn.andersson@linaro.org>
References: <1471871619-25873-1-git-send-email-stanimir.varbanov@linaro.org>
 <1471871619-25873-3-git-send-email-stanimir.varbanov@linaro.org>
 <20160823025026.GZ26240@tuxbot>
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Andy Gross <andy.gross@linaro.org>,
        Stephen Boyd <sboyd@codeaurora.org>,
        Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org
From: Stanimir Varbanov <stanimir.varbanov@linaro.org>
Message-ID: <79bd3757-fa35-d28d-7eda-9d57c6fdb619@linaro.org>
Date: Thu, 25 Aug 2016 15:59:06 +0300
MIME-Version: 1.0
In-Reply-To: <20160823025026.GZ26240@tuxbot>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Bjorn,

Thanks for the review and comments!

On 08/23/2016 05:50 AM, Bjorn Andersson wrote:
> On Mon 22 Aug 06:13 PDT 2016, Stanimir Varbanov wrote:
> 
> Hi Stan,
> 
>> This adds core part of the vidc driver common helper functions
>> used by encoder and decoder specific files.
> 
> I believe "vidc" is short for "video core" and this is not the only
> "video core" from Qualcomm. This driver is the v4l2 <-> hfi interface and

What other "video core"s do you know?

> uses either two ram based fifos _or_ apr tal for communication with the
> implementation.
> 
> In the case of apr, the other side is not the venus core but rather the
> "VIDC" apr service on the Hexagon DSP. In this case the hfi packets are
> encapsulated in apr packets. Although this is not used in 8916 it would
> be nice to be able to add this later...

OK, you are talking about q6_hfi.c which file is found in msm-3.10 and
maybe older kernel versions.

There is a function vidc_hfi_create() which currently creates venus hfi
interface but it aways could be extended to call q6 DSP specific function.

> 
> 
> But I think we should call this driver "hfi" - or at least venus, as
> it's not compatible with e.g the "blackbird" found in 8064, which is
> also called "vidc".

Do you think that vidc driver for 8064 will ever reach the mainline kernel?

I personally don't like hfi nor venus other suggestions? Does "vidcore"
or "vcore" makes sense?

> 
>>
>>  - core.c has implemented the platform dirver methods, file
>> operations and v4l2 registration.
>>
>>  - helpers.c has implemented common helper functions for
>> buffer management, vb2_ops and functions for format propagation.
>>
>>  - int_bufs.c implements functions for allocating and freeing
>> buffers for internal usage. The buffer parameters describing
>> internal buffers depends on current format, resolution and
>> codec.
>>
>>  - load.c consists functions for calculation of current load
>> of the hardware. Depending on the count of instances and
>> resolutions it selects the best clock rate for the video
>> core.
>>
>>  - mem.c has two functions for memory allocation, currently
>> those functions are used for internal buffers and to allocate
>> the shared memory for communication with firmware via HFI
>> (Host Firmware Interface) interface commands.
> 
> Please drop this; see comments on mem_alloc()

OK.

> 
>>
>>  - resources.c exports a structure describing the details
>> specific to platform and SoC.
>>
>> Signed-off-by: Stanimir Varbanov <stanimir.varbanov@linaro.org>
>> ---
> 
> This doesn't compile, as it depends on later patches. Also there are
> plenty of functions that are related to later patches and would with be
> better to include there, to keep the size of this patch down.
> 
>>  drivers/media/platform/qcom/vidc/core.c      | 548 +++++++++++++++++++++++++++
>>  drivers/media/platform/qcom/vidc/core.h      | 196 ++++++++++
>>  drivers/media/platform/qcom/vidc/helpers.c   | 394 +++++++++++++++++++
>>  drivers/media/platform/qcom/vidc/helpers.h   |  43 +++
>>  drivers/media/platform/qcom/vidc/int_bufs.c  | 325 ++++++++++++++++
>>  drivers/media/platform/qcom/vidc/int_bufs.h  |  23 ++
>>  drivers/media/platform/qcom/vidc/load.c      | 104 +++++
>>  drivers/media/platform/qcom/vidc/load.h      |  22 ++
>>  drivers/media/platform/qcom/vidc/mem.c       |  64 ++++
>>  drivers/media/platform/qcom/vidc/mem.h       |  32 ++
>>  drivers/media/platform/qcom/vidc/resources.c |  46 +++
>>  drivers/media/platform/qcom/vidc/resources.h |  46 +++
>>  12 files changed, 1843 insertions(+)
>>  create mode 100644 drivers/media/platform/qcom/vidc/core.c
>>  create mode 100644 drivers/media/platform/qcom/vidc/core.h
>>  create mode 100644 drivers/media/platform/qcom/vidc/helpers.c
>>  create mode 100644 drivers/media/platform/qcom/vidc/helpers.h
>>  create mode 100644 drivers/media/platform/qcom/vidc/int_bufs.c
>>  create mode 100644 drivers/media/platform/qcom/vidc/int_bufs.h
>>  create mode 100644 drivers/media/platform/qcom/vidc/load.c
>>  create mode 100644 drivers/media/platform/qcom/vidc/load.h
>>  create mode 100644 drivers/media/platform/qcom/vidc/mem.c
>>  create mode 100644 drivers/media/platform/qcom/vidc/mem.h
>>  create mode 100644 drivers/media/platform/qcom/vidc/resources.c
>>  create mode 100644 drivers/media/platform/qcom/vidc/resources.h
>>
>> diff --git a/drivers/media/platform/qcom/vidc/core.c b/drivers/media/platform/qcom/vidc/core.c
>> new file mode 100644
>> index 000000000000..e005be178fc0
>> --- /dev/null
>> +++ b/drivers/media/platform/qcom/vidc/core.c
>> @@ -0,0 +1,548 @@
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
>> +#include "resources.h"
>> +#include "vdec.h"
>> +#include "venc.h"
>> +
>> +static void vidc_add_inst(struct vidc_core *core, struct vidc_inst *inst)
>> +{
>> +	mutex_lock(&core->lock);
>> +	list_add_tail(&inst->list, &core->instances);
> 
> There are two different "instances" lists in this implementation, one
> keeping track of vidc instances and one keeping track of hfi instances,
> at the same time the vidc instances has a reference to its associated
> hfi instance.
> 
> It should be possible to drop one of those lists.

I agree with you. I have thought about this many times during driver
development and it should be possible.

> 
>> +	mutex_unlock(&core->lock);
>> +}
>> +
>> +static void vidc_del_inst(struct vidc_core *core, struct vidc_inst *inst)
>> +{
>> +	struct vidc_inst *pos, *n;
>> +
>> +	mutex_lock(&core->lock);
>> +	list_for_each_entry_safe(pos, n, &core->instances, list) {
>> +		if (pos == inst)
>> +			list_del(&inst->list);
>> +	}
>> +	mutex_unlock(&core->lock);
>> +}
>> +
>> +static int vidc_rproc_boot(struct vidc_core *core)
>> +{
>> +	int ret;
>> +
>> +	if (core->rproc_booted)
>> +		return 0;
> 
> rproc_boot()/rproc_shutdown() is reference counted, so there is no
> reason (other than this driver being buggy) to keep track of
> "rproc_boot". As such, you can drop vidc_rproc_boot() and
> vidc_rproc_shutdown() and just call the rproc functions directly.

You are right, this checks are redundant.

> 
>> +
>> +	ret = rproc_boot(core->rproc);
>> +	if (ret)
>> +		return ret;
>> +
>> +	core->rproc_booted = true;
>> +
>> +	return 0;
>> +}
>> +
>> +static void vidc_rproc_shutdown(struct vidc_core *core)
>> +{
>> +	if (!core->rproc_booted)
>> +		return;
>> +
>> +	rproc_shutdown(core->rproc);
>> +	core->rproc_booted = false;
>> +}
>> +
>> +struct vidc_sys_error {
>> +	struct vidc_core *core;
>> +	struct delayed_work work;
>> +};
> 
> This is cool, but during the 5 second delay we should be able to call
> remove on the driver and this will dereference a freed hfi instance.
> 
> Move the worker to hfi_core and you can cancel it on remove.

OK.

> 
>> +
>> +static void vidc_sys_error_handler(struct work_struct *work)
>> +{
>> +	struct vidc_sys_error *handler =
>> +		container_of(work, struct vidc_sys_error, work.work);
>> +	struct vidc_core *core = handler->core;
>> +	struct hfi_core *hfi = &core->hfi;
>> +	struct device *dev = core->dev;
>> +	int ret;
>> +
>> +	mutex_lock(&hfi->lock);
>> +	if (hfi->state != CORE_INVALID)
>> +		goto exit;
>> +
>> +	mutex_unlock(&hfi->lock);
>> +
>> +	ret = vidc_hfi_core_deinit(hfi);
>> +	if (ret)
>> +		dev_err(dev, "core: deinit failed (%d)\n", ret);
>> +
>> +	mutex_lock(&hfi->lock);
>> +
>> +	rproc_report_crash(core->rproc, RPROC_FATAL_ERROR);
> 
> This operation is async, as such I believe this to be fragile. To get
> the expected result you should be able to simply call
> rproc_shutdown()/rproc_boot() to restart the core...

OK will remove crash report for now.

> 
> However, if we at any point would like to be able to get memory dumps
> from this core (likely a requirement on the Qualcomm side) we need to
> call rproc_report_crash() and let it collect the resources and then
> power cycle the core.
> 
> 
> As the life cycle of the venus driver goes 1:1 with the rproc driver I
> think it would be more suitable to make the v4l driver a child of the
> rproc driver and have it probe/remove this driver as the rproc comes and
> goes. This would allow us to call rproc_report_crash() here, we will be
> removed and when the crash is handled (sometime in the future) we will
> be probed again.

What's the problem with Kconfig "depends on QCOM_VENUS_PIL", isn't that
enough?

> 
>> +
>> +	vidc_rproc_shutdown(core);
>> +
>> +	ret = vidc_rproc_boot(core);
>> +	if (ret)
>> +		goto exit;
>> +
>> +	hfi->state = CORE_INIT;
>> +
>> +exit:
>> +	mutex_unlock(&hfi->lock);
>> +	kfree(handler);
>> +}
>> +
>> +static int vidc_event_notify(struct hfi_core *hfi, u32 event)
>> +{
>> +	struct vidc_sys_error *handler;
>> +	struct hfi_inst *inst;
>> +
>> +	switch (event) {
>> +	case EVT_SYS_WATCHDOG_TIMEOUT:
>> +	case EVT_SYS_ERROR:
>> +		break;
>> +	default:
>> +		return -EINVAL;
>> +	}
>> +
>> +	mutex_lock(&hfi->lock);
>> +
>> +	hfi->state = CORE_INVALID;
>> +
>> +	list_for_each_entry(inst, &hfi->instances, list) {
>> +		mutex_lock(&inst->lock);
>> +		inst->state = INST_INVALID;
>> +		mutex_unlock(&inst->lock);
>> +	}
>> +
>> +	mutex_unlock(&hfi->lock);
>> +
>> +	handler = kzalloc(sizeof(*handler), GFP_KERNEL);
>> +	if (!handler)
>> +		return -ENOMEM;
>> +
>> +	handler->core = container_of(hfi, struct vidc_core, hfi);
>> +	INIT_DELAYED_WORK(&handler->work, vidc_sys_error_handler);
>> +
>> +	/*
>> +	 * Sleep for 5 sec to ensure venus has completed any
>> +	 * pending cache operations. Without this sleep, we see
>> +	 * device reset when firmware is unloaded after a sys
>> +	 * error.
>> +	 */
>> +	schedule_delayed_work(&handler->work, msecs_to_jiffies(5000));
>> +
>> +	return 0;
>> +}
>> +
>> +static const struct hfi_core_ops vidc_core_ops = {
>> +	.event_notify = vidc_event_notify,
>> +};
> 
> This is an overly generic way of calling vidc_sys_error_handler().
> There is no need for having the hfi_core_ops indirections for a single
> op that will only exist in 1 and only 1 variant.

The .event_notify operation is called by hfi part (in hfi_msgs.c) of the
driver and I don't want break the interface. My idea was to have HFI
part and v4l2 part, and each of these parts taking care of their
specifics. The interface between HFI <-> v4l2 should be immutable and
shoudn't be changed when every new version of the hardware IP rise up.

> 
> Just replace the two affected event_notify() calls with a direct call to
> this function (and clean it up a bit).
> 
>> +
>> +static int vidc_open(struct file *file)
>> +{
>> +	struct video_device *vdev = video_devdata(file);
>> +	struct vidc_core *core = video_drvdata(file);
>> +	struct vidc_inst *inst;
>> +	int ret = 0;
>> +
>> +	inst = kzalloc(sizeof(*inst), GFP_KERNEL);
>> +	if (!inst)
>> +		return -ENOMEM;
>> +
>> +	mutex_init(&inst->lock);
>> +
>> +	INIT_VIDC_LIST(&inst->scratchbufs);
> 
> Please inline the mutex_init() and INIT_LIST_HEAD() here and drop the
> custom INIT_VIDC_LIST() wrapper macro.

OK. I thought I made this already, but seems that I forgot it. Also I
think scratchbufs and persistbufs lists can be merged in one common list.

> 
>> +	INIT_VIDC_LIST(&inst->persistbufs);
>> +	INIT_VIDC_LIST(&inst->registeredbufs);
>> +
>> +	INIT_LIST_HEAD(&inst->bufqueue);
>> +	mutex_init(&inst->bufqueue_lock);
>> +
>> +	if (vdev == &core->vdev_dec)
>> +		inst->session_type = VIDC_SESSION_TYPE_DEC;
>> +	else
>> +		inst->session_type = VIDC_SESSION_TYPE_ENC;
>> +
>> +	inst->core = core;
>> +
>> +	if (inst->session_type == VIDC_SESSION_TYPE_DEC)
>> +		ret = vdec_open(inst);
>> +	else
>> +		ret = venc_open(inst);
>> +
>> +	if (ret)
>> +		goto err_free_inst;
>> +
>> +	if (inst->session_type == VIDC_SESSION_TYPE_DEC)
>> +		v4l2_fh_init(&inst->fh, &core->vdev_dec);
>> +	else
>> +		v4l2_fh_init(&inst->fh, &core->vdev_enc);
> 
> Here we have three sequential conditionals testing for the same thing,
> please join them into one.

OK.

> 
>> +
>> +	inst->fh.ctrl_handler = &inst->ctrl_handler;
>> +
>> +	v4l2_fh_add(&inst->fh);
>> +
>> +	file->private_data = &inst->fh;
>> +
>> +	vidc_add_inst(core, inst);
>> +
>> +	return 0;
>> +
>> +err_free_inst:
>> +	kfree(inst);
>> +	return ret;
>> +}
>> +
>> +static int vidc_close(struct file *file)
>> +{
>> +	struct vidc_inst *inst = to_inst(file);
>> +	struct vidc_core *core = inst->core;
>> +
>> +	if (inst->session_type == VIDC_SESSION_TYPE_DEC)
>> +		vdec_close(inst);
>> +	else
>> +		venc_close(inst);
>> +
>> +	vidc_del_inst(core, inst);
>> +
>> +	mutex_destroy(&inst->bufqueue_lock);
>> +	mutex_destroy(&inst->scratchbufs.lock);
>> +	mutex_destroy(&inst->persistbufs.lock);
>> +	mutex_destroy(&inst->registeredbufs.lock);
> 
> Here's a good reason for dropping the INIT_VIDC_LIST() macro

yes indeed :)

> 
>> +
>> +	v4l2_fh_del(&inst->fh);
>> +	v4l2_fh_exit(&inst->fh);
>> +
>> +	kfree(inst);
>> +	return 0;
>> +}
>> +
>> +static unsigned int vidc_poll(struct file *file, struct poll_table_struct *pt)
>> +{
>> +	struct vidc_inst *inst = to_inst(file);
>> +	struct vb2_queue *outq = &inst->bufq_out;
>> +	struct vb2_queue *capq = &inst->bufq_cap;
>> +	unsigned int ret;
>> +
>> +	ret = vb2_poll(outq, file, pt);
>> +	ret |= vb2_poll(capq, file, pt);
>> +
>> +	return ret;
>> +}
>> +
>> +static int vidc_mmap(struct file *file, struct vm_area_struct *vma)
>> +{
>> +	struct vidc_inst *inst = to_inst(file);
>> +	unsigned long offset = vma->vm_pgoff << PAGE_SHIFT;
>> +	int ret;
>> +
>> +	if (offset < DST_QUEUE_OFF_BASE) {
>> +		ret = vb2_mmap(&inst->bufq_out, vma);
>> +	} else {
>> +		vma->vm_pgoff -= DST_QUEUE_OFF_BASE >> PAGE_SHIFT;
>> +		ret = vb2_mmap(&inst->bufq_cap, vma);
>> +	}
> 
> This feels hackish, is this really the way to do this?

Yes it looks like a hack but there is no other way (to my knowledge),
there are plenty of v4l2 drivers doing like this.

> 
>> +
>> +	return ret;
>> +}
>> +
>> +const struct v4l2_file_operations vidc_fops = {
>> +	.owner = THIS_MODULE,
>> +	.open = vidc_open,
>> +	.release = vidc_close,
>> +	.unlocked_ioctl = video_ioctl2,
>> +	.poll = vidc_poll,
>> +	.mmap = vidc_mmap,
>> +#ifdef CONFIG_COMPAT
>> +	.compat_ioctl32 = v4l2_compat_ioctl32,
>> +#endif
>> +};
>> +
>> +static irqreturn_t vidc_isr_thread(int irq, void *dev_id)
>> +{
>> +	return vidc_hfi_isr_thread(irq, dev_id);
>> +}
>> +
>> +static irqreturn_t vidc_isr(int irq, void *dev)
>> +{
>> +	return vidc_hfi_isr(irq, dev);
>> +}
> 
> These two functions indicates that we're requesting the irq in the wrong
> layer.

IMO the proper place is platform driver .probe method.

> 
> Also, these two functions arrives in a later patchset, so I assume this
> doesn't compile...

That's why I'm adding Makefiles later on patchset. On the other hand I
have splitted the driver by files because I think it is easier for
review. But I might be wrong.

> 
>> +
>> +static int vidc_clks_get(struct vidc_core *core, unsigned int clks_num,
>> +			 const char * const *clks_id)
>> +{
>> +	struct device *dev = core->dev;
>> +	unsigned int i;
>> +
>> +	for (i = 0; i < clks_num; i++) {
>> +		core->clks[i] = devm_clk_get(dev, clks_id[i]);
>> +		if (IS_ERR(core->clks[i]))
>> +			return PTR_ERR(core->clks[i]);
>> +	}
>> +
>> +	return 0;
>> +}
>> +
>> +static int
>> +vidc_clks_enable(struct vidc_core *core, const struct vidc_resources *res)
>> +{
>> +	unsigned int i;
>> +	int ret;
>> +
>> +	for (i = 0; i < res->clks_num; i++) {
>> +		ret = clk_prepare_enable(core->clks[i]);
>> +		if (ret)
>> +			goto err;
>> +	}
>> +
>> +	return 0;
>> +err:
>> +	while (--i)
>> +		clk_disable_unprepare(core->clks[i]);
>> +
>> +	return ret;
>> +}
>> +
>> +static void
>> +vidc_clks_disable(struct vidc_core *core, const struct vidc_resources *res)
>> +{
>> +	unsigned int i;
>> +
>> +	for (i = 0; i < res->clks_num; i++)
>> +		clk_disable_unprepare(core->clks[i]);
>> +}
>> +
>> +static const struct of_device_id vidc_dt_match[] = {
>> +	{ .compatible = "qcom,vidc-msm8916", .data = &msm8916_res, },
>> +	{ }
>> +};
>> +
>> +MODULE_DEVICE_TABLE(of, vidc_dt_match);
> 
> As you're using of_device_get_match_data() you can move this table to
> the bottom of the file.

OK.

> 
>> +
>> +static int vidc_probe(struct platform_device *pdev)
>> +{
>> +	struct device *dev = &pdev->dev;
>> +	struct vidc_core *core;
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
> 
> FYI, We're hoping to land some patches shortly that will replace this
> with rproc_get(pdev->dev.of_node), looking up an rproc by the standard
> "rprocs" property...

OK, that looks good. But shoudn't be rproc_get(pdev->dev)?

> 
>> +	if (IS_ERR(core->rproc))
>> +		return PTR_ERR(core->rproc);
>> +	else if (!core->rproc)
>> +		return -EPROBE_DEFER;
> 
> We're cleaning up this in the core as well.
> 
> You need to rproc_put() the rproc pointer after this point.

OK, good. When those changes landed I will rework this part.

> 
> 
> My question still stands though, if this driver should be probed as the
> remoteproc is booted (or the apr service appearing). I will continue to
> look at that.

I might be misunderstood your point here. Is your concern related to
EPROBE_DEFFER or some sort of ordering issue in rproc?

Currently the vidc depends on QCOM_VENUS_PIL in Kconfig, so modprobe
vidc should modprobe remoteproc driver cause it depends on it.

> 
>> +
>> +	r = platform_get_resource(pdev, IORESOURCE_MEM, 0);
>> +	core->base = devm_ioremap_resource(dev, r);
>> +	if (IS_ERR(core->base))
>> +		return PTR_ERR(core->base);
>> +
>> +	core->irq = platform_get_irq(pdev, 0);
>> +	if (core->irq < 0)
>> +		return core->irq;
>> +
>> +	core->res = of_device_get_match_data(dev);
>> +	if (!core->res)
>> +		return -ENODEV;
>> +
>> +	ret = vidc_clks_get(core, core->res->clks_num, core->res->clks);
>> +	if (ret)
>> +		return ret;
>> +
>> +	ret = dma_set_mask_and_coherent(dev, core->res->dma_mask);
>> +	if (ret)
>> +		return ret;
>> +
>> +	INIT_LIST_HEAD(&core->instances);
>> +	mutex_init(&core->lock);
>> +
>> +	ret = devm_request_threaded_irq(dev, core->irq, vidc_isr,
>> +					vidc_isr_thread,
>> +					IRQF_TRIGGER_HIGH | IRQF_ONESHOT,
> 
> Drop this IRQF_TRIGGER_HIGH and have this be specified in devicetree.

OK can do that, but is there a convention about who is populating the
flag and what is the precedence dt against the driver?

> 
>> +					"vidc", &core->hfi);
>> +	if (ret)
>> +		return ret;
>> +
>> +	core->hfi.core_ops = &vidc_core_ops;
>> +	core->hfi.dev = dev;
>> +
>> +	ret = vidc_hfi_create(&core->hfi, core->res, core->base);
>> +	if (ret)
>> +		return ret;
>> +
>> +	ret = vidc_clks_enable(core, core->res);
>> +	if (ret)
>> +		goto err_hfi_destroy;
>> +
>> +	ret = vidc_rproc_boot(core);
>> +	if (ret) {
>> +		vidc_clks_disable(core, core->res);
>> +		goto err_hfi_destroy;
>> +	}
>> +
>> +	pm_runtime_enable(dev);
>> +
>> +	ret = pm_runtime_get_sync(dev);
>> +	if (ret < 0)
>> +		goto err_runtime_disable;
>> +
>> +	ret = vidc_hfi_core_init(&core->hfi);
>> +	if (ret)
>> +		goto err_rproc_shutdown;
>> +
>> +	ret = pm_runtime_put_sync(dev);
>> +	if (ret)
>> +		goto err_core_deinit;
>> +
>> +	vidc_clks_disable(core, core->res);
> 
> These operations follow the general pattern of booting other Qualcomm
> remoteprocs; acquire and enable some resources, boot the core and
> disable the resources. Therefor it looks quite likely that these
> operations are related to the life cycle of the venus core, rather than
> hfi.

So you saying that

> 
>> +
>> +	ret = v4l2_device_register(dev, &core->v4l2_dev);
>> +	if (ret)
>> +		goto err_core_deinit;
>> +
>> +	ret = vdec_init(core, &core->vdev_dec);
>> +	if (ret)
>> +		goto err_dev_unregister;
>> +
>> +	ret = venc_init(core, &core->vdev_enc);
>> +	if (ret)
>> +		goto err_vdec_deinit;
>> +
>> +	return 0;
>> +
>> +err_vdec_deinit:
>> +	vdec_deinit(core, &core->vdev_dec);
>> +err_dev_unregister:
>> +	v4l2_device_unregister(&core->v4l2_dev);
>> +err_core_deinit:
>> +	vidc_hfi_core_deinit(&core->hfi);
>> +err_rproc_shutdown:
>> +	vidc_rproc_shutdown(core);
>> +err_runtime_disable:
>> +	pm_runtime_set_suspended(dev);
>> +	pm_runtime_disable(dev);
>> +err_hfi_destroy:
>> +	vidc_hfi_destroy(&core->hfi);
>> +	return ret;
>> +}
>> +
>> +static int vidc_remove(struct platform_device *pdev)
>> +{
>> +	struct vidc_core *core = platform_get_drvdata(pdev);
>> +	int ret;
>> +
>> +	ret = pm_runtime_get_sync(&pdev->dev);
>> +	if (ret < 0)
>> +		return ret;
> 
> No-one cares about you returning an error here, so you better move
> forward and release as much of your resources as possible even though
> you didn't get your pm.

Hmm, I don't agree here. The runtime_resume will enable clocks (for
example venus iface clk) and if it fails the subsequent call to
vidc_rproc_shutdown can crash badly.

> 
>> +
>> +	ret = vidc_hfi_core_deinit(&core->hfi);
>> +	if (ret) {
>> +		pm_runtime_put_sync(&pdev->dev);
>> +		return ret;
>> +	}
>> +
>> +	vidc_rproc_shutdown(core);
>> +
>> +	ret = pm_runtime_put_sync(&pdev->dev);
>> +
>> +	vidc_hfi_destroy(&core->hfi);
>> +	vdec_deinit(core, &core->vdev_dec);
>> +	venc_deinit(core, &core->vdev_enc);
>> +	v4l2_device_unregister(&core->v4l2_dev);
>> +
>> +	pm_runtime_disable(core->dev);
>> +
>> +	return ret < 0 ? ret : 0;
>> +}
>> +
>> +static int vidc_runtime_suspend(struct device *dev)
>> +{
>> +	struct vidc_core *core = dev_get_drvdata(dev);
>> +	int ret;
>> +
>> +	ret = vidc_hfi_core_suspend(&core->hfi);
>> +
>> +	vidc_clks_disable(core, core->res);
>> +
>> +	return ret;
>> +}
>> +
>> +static int vidc_runtime_resume(struct device *dev)
>> +{
>> +	struct vidc_core *core = dev_get_drvdata(dev);
>> +	int ret;
>> +
>> +	ret = vidc_clks_enable(core, core->res);
>> +	if (ret)
>> +		return ret;
>> +
>> +	return vidc_hfi_core_resume(&core->hfi);
>> +}
>> +
>> +static int vidc_pm_suspend(struct device *dev)
>> +{
>> +	return vidc_runtime_suspend(dev);
>> +}
>> +
>> +static int vidc_pm_resume(struct device *dev)
>> +{
>> +	return vidc_runtime_resume(dev);
>> +}
>> +
>> +static const struct dev_pm_ops vidc_pm_ops = {
>> +	SET_SYSTEM_SLEEP_PM_OPS(vidc_pm_suspend, vidc_pm_resume)
>> +	SET_RUNTIME_PM_OPS(vidc_runtime_suspend, vidc_runtime_resume, NULL)
>> +};
>> +
>> +static struct platform_driver qcom_vidc_driver = {
>> +	.probe = vidc_probe,
>> +	.remove = vidc_remove,
>> +	.driver = {
>> +		.name = "qcom-vidc",
>> +		.of_match_table = vidc_dt_match,
>> +		.pm = &vidc_pm_ops,
>> +	},
>> +};
>> +
>> +module_platform_driver(qcom_vidc_driver);
>> +
>> +MODULE_ALIAS("platform:qcom-vidc");
>> +MODULE_DESCRIPTION("Qualcomm video encoder and decoder driver");
>> +MODULE_LICENSE("GPL v2");
>> diff --git a/drivers/media/platform/qcom/vidc/core.h b/drivers/media/platform/qcom/vidc/core.h
>> new file mode 100644
>> index 000000000000..5dc8e05f8c36
>> --- /dev/null
>> +++ b/drivers/media/platform/qcom/vidc/core.h
>> @@ -0,0 +1,196 @@
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
>> +
>> +#include <media/v4l2-device.h>
>> +#include <media/v4l2-ctrls.h>
>> +#include <media/videobuf2-core.h>
>> +
>> +#include "resources.h"
>> +#include "hfi.h"
>> +
>> +#define VIDC_DRV_NAME		"vidc"
> 
> Unused

used in vdec.c and enc.c. But I can delete this in next submission.

> 
>> +
>> +struct vidc_list {
>> +	struct list_head list;
>> +	struct mutex lock;
>> +};
> 
> Can't we get away without passing around lockable lists? Does these
> lists have to be locked independently and should we really pass around
> their lock with them?

I guess it is possible but didn't spent to much time on that (I had more
important problems to solve with downstream driver). So the answer is
yes and I have to re-consider it.

> 
>> +
>> +struct vidc_format {
>> +	u32 pixfmt;
>> +	int num_planes;
>> +	u32 type;
>> +};
>> +
>> +struct vidc_core {
>> +	struct list_head list;
> 
> This list_head seems unused.

Yes, it is.

> 
>> +	void __iomem *base;
> 
> base is acquired and passed by value to vidc_hfi_create(), so no need to
> keep track of it here.
> 
>> +	int irq;
> 
> This irq belongs to hfi, so it should probably be kept there.

Sure, will move those two.

> 
>> +	struct clk *clks[VIDC_CLKS_NUM_MAX];
>> +	struct mutex lock;
> 
> This "lock" seems to be only related the instances list, please name it
> more appropriately - and place it next to the instances member.

OK.

> 
>> +	struct hfi_core hfi;
>> +	struct video_device vdev_dec;
>> +	struct video_device vdev_enc;
>> +	struct v4l2_device v4l2_dev;
>> +	struct list_head instances;
>> +	const struct vidc_resources *res;
>> +	struct rproc *rproc;
>> +	bool rproc_booted;
>> +	struct device *dev;
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
>> +struct vidc_inst {
>> +	struct list_head list;
>> +	struct mutex lock;
>> +	struct vidc_core *core;
>> +
>> +	struct vidc_list scratchbufs;
>> +	struct vidc_list persistbufs;
>> +	struct vidc_list registeredbufs;
> 
> Just inline the list_head and mutex here, as it's done for bufqueue.

OK.

>> +
>> +	struct list_head bufqueue;
>> +	struct mutex bufqueue_lock;
>> +
>> +	int streamoff;
>> +	int streamon;
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
>> +	struct hfi_inst *hfi_inst;
>> +
>> +	/* session fields */
>> +	u32 session_type;
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
>> +	const struct vidc_format *fmt_out;
>> +	const struct vidc_format *fmt_cap;
>> +	unsigned int num_input_bufs;
>> +	unsigned int num_output_bufs;
>> +	bool in_reconfig;
>> +	u32 reconfig_width;
>> +	u32 reconfig_height;
>> +	u64 sequence;
>> +};
>> +
>> +#define ctrl_to_inst(ctrl)	\
>> +	container_of(ctrl->handler, struct vidc_inst, ctrl_handler)
>> +
>> +struct vidc_ctrl {
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
>> +
>> +/*
>> + * Offset base for buffers on the destination queue - used to distinguish
>> + * between source and destination buffers when mmapping - they receive the same
>> + * offsets but for different queues
>> + */
>> +#define DST_QUEUE_OFF_BASE	(1 << 30)
>> +
>> +extern const struct v4l2_file_operations vidc_fops;
> 
> Just pass this to v{dec,enc}_init() rather than back-referencing it
> through a global variable. But on the other hand this is unused in this
> patchset...

Very nice idea, thanks.

> 
>> +
>> +static inline void INIT_VIDC_LIST(struct vidc_list *mlist)
>> +{
>> +	mutex_init(&mlist->lock);
>> +	INIT_LIST_HEAD(&mlist->list);
>> +}
>> +
>> +static inline struct vidc_inst *to_inst(struct file *filp)
>> +{
>> +	return container_of(filp->private_data, struct vidc_inst, fh);
>> +}
>> +
>> +static inline struct hfi_inst *to_hfi_inst(struct file *filp)
> 
> Unused

Unsed in this patch, but used by vdec.c and enc.c in subsequent patches.

> 
>> +{
>> +	return to_inst(filp)->hfi_inst;
>> +}
>> +
>> +static inline struct vb2_queue *
>> +vidc_to_vb2q(struct file *file, enum v4l2_buf_type type)
> 
> Unused

Same as above comment.

> 
>> +{
>> +	struct vidc_inst *inst = to_inst(file);
>> +
>> +	if (type == V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE)
>> +		return &inst->bufq_cap;
>> +	else if (type == V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE)
>> +		return &inst->bufq_out;
>> +
>> +	return NULL;
>> +}
>> +
>> +#endif
>> diff --git a/drivers/media/platform/qcom/vidc/helpers.c b/drivers/media/platform/qcom/vidc/helpers.c
>> new file mode 100644
>> index 000000000000..81079f2b5ed1
>> --- /dev/null
>> +++ b/drivers/media/platform/qcom/vidc/helpers.c
>> @@ -0,0 +1,394 @@
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
>> +#include <linux/list.h>
>> +#include <linux/mutex.h>
>> +#include <linux/pm_runtime.h>
>> +#include <media/videobuf2-dma-sg.h>
>> +
>> +#include "helpers.h"
>> +#include "int_bufs.h"
>> +#include "load.h"
>> +#include "hfi_helper.h"
>> +
>> +static int session_set_buf(struct vb2_buffer *vb)
>> +{
>> +	struct vb2_v4l2_buffer *vbuf = to_vb2_v4l2_buffer(vb);
>> +	struct vb2_queue *q = vb->vb2_queue;
>> +	struct vidc_inst *inst = vb2_get_drv_priv(q);
>> +	struct vidc_core *core = inst->core;
>> +	struct device *dev = core->dev;
>> +	struct hfi_core *hfi = &core->hfi;
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
>> +		ret = vidc_hfi_session_etb(hfi, inst->hfi_inst, &fdata);
>> +	} else if (q->type == V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE) {
>> +		fdata.buffer_type = HFI_BUFFER_OUTPUT;
>> +		fdata.filled_len = 0;
>> +		fdata.offset = 0;
>> +
>> +		ret = vidc_hfi_session_ftb(hfi, inst->hfi_inst, &fdata);
>> +	} else {
>> +		ret = -EINVAL;
>> +	}
>> +
>> +	if (ret) {
>> +		dev_err(dev, "failed to set session buffer (%d)\n", ret);
>> +		return ret;
>> +	}
>> +
>> +	return 0;
>> +}
>> +
>> +static int session_unregister_bufs(struct vidc_inst *inst)
>> +{
>> +	struct device *dev = inst->core->dev;
>> +	struct hfi_core *hfi = &inst->core->hfi;
>> +	struct hfi_buffer_desc *bd;
>> +	struct vidc_buffer *buf, *tmp;
>> +	int ret = 0;
>> +
>> +	mutex_lock(&inst->registeredbufs.lock);
>> +	list_for_each_entry_safe(buf, tmp, &inst->registeredbufs.list,
>> +				 hfi_list) {
>> +		list_del(&buf->hfi_list);
> 
> So the hfi_list is the list_head for entries in the _vidc_ instance
> list?

yes, registeredbufs.list is used to keep track of the all buffers that
will be used during the life-cycle of the current session, i.e. the
firmware wants to know all buffer addresses before calling
session_start. On the other side bufqueue list is used for v4l2
queue/dequeue side.

> 
>> +		bd = &buf->bd;
>> +		bd->response_required = 1;
>> +		ret = vidc_hfi_session_unset_buffers(hfi, inst->hfi_inst, bd);
>> +		if (ret) {
>> +			dev_err(dev, "%s: session release buffers failed\n",
>> +				__func__);
>> +			break;
>> +		}
>> +	}
>> +	mutex_unlock(&inst->registeredbufs.lock);
>> +
>> +	return ret;
>> +}
>> +
>> +static int session_register_bufs(struct vidc_inst *inst)
>> +{
>> +	struct device *dev = inst->core->dev;
>> +	struct hfi_core *hfi = &inst->core->hfi;
>> +	struct hfi_buffer_desc *bd;
>> +	struct vidc_buffer *buf, *tmp;
>> +	int ret = 0;
>> +
>> +	mutex_lock(&inst->registeredbufs.lock);
>> +	list_for_each_entry_safe(buf, tmp, &inst->registeredbufs.list,
>> +				 hfi_list) {
>> +		bd = &buf->bd;
>> +		ret = vidc_hfi_session_set_buffers(hfi, inst->hfi_inst, bd);
>> +		if (ret) {
>> +			dev_err(dev, "%s: session: set buffer failed\n",
>> +				__func__);
>> +			break;
>> +		}
>> +	}
>> +	mutex_unlock(&inst->registeredbufs.lock);
>> +
>> +	return ret;
>> +}
>> +
>> +int vidc_buf_descs(struct vidc_inst *inst, u32 type,
>> +		   struct hfi_buffer_requirements *out)
> 
> If you call this vidc_get_buf_requirements() it would actually describe
> what's going on. But why is this hfi wrapper in the core, rather than

the original name of this function was similar to what you suggest but I
decided in last-minute cleanup to shorten its name.

> just have the internal buffer manager call it directly.

It is in the core cause I used it on few places to gather buffer count
needed depending on parameters (resolution, codec). Good example is
vb2_ops::queue_setup where I need to return num_buffers depending on
resolution, codec, bitrate, framerate and so on.

> 
> The call doesn't seem to depend on the parameters or state, can we
> cache the result?

No, we cannot. see above comment. Something more the scratch and
prersist buffer sizes can also be changed by the firmware depending on
above proparties.

> 
>> +{
>> +	struct hfi_core *hfi = &inst->core->hfi;
>> +	u32 ptype = HFI_PROPERTY_CONFIG_BUFFER_REQUIREMENTS;
>> +	union hfi_get_property hprop;
>> +	int ret, i;
>> +
>> +	if (out)
>> +		memset(out, 0, sizeof(*out));
>> +
>> +	ret = vidc_hfi_session_get_property(hfi, inst->hfi_inst, ptype, &hprop);
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
> [..]
>> +
>> +void vidc_vb2_stop_streaming(struct vb2_queue *q)
>> +{
>> +	struct vidc_inst *inst = vb2_get_drv_priv(q);
>> +	struct hfi_inst *hfi_inst = inst->hfi_inst;
>> +	struct vidc_core *core = inst->core;
>> +	struct device *dev = core->dev;
>> +	struct hfi_core *hfi = &core->hfi;
>> +	int ret, streamoff;
>> +
>> +	mutex_lock(&inst->lock);
>> +	streamoff = inst->streamoff;
>> +	mutex_unlock(&inst->lock);
>> +
>> +	if (streamoff)
>> +		return;
>> +
>> +	mutex_lock(&inst->lock);
>> +	if (inst->streamon == 0) {
>> +		mutex_unlock(&inst->lock);
>> +		return;
>> +	}
>> +	mutex_unlock(&inst->lock);
> 
> Why do we keep track of streamon and stream off, why isn't streamoff
> ever cleared? Why don't we check both conditions in one critical region?

Probably cause its buggy, I will sort it out.

> 
>> +
>> +	ret = vidc_hfi_session_stop(hfi, inst->hfi_inst);
>> +	if (ret) {
>> +		dev_err(dev, "session: stop failed (%d)\n", ret);
>> +		goto abort;
> 
> When are we going to relaim the buffers in these cases?

session_stop will instruct the firmware return buffers to the v4l2
driver through hfi_inst_ops empty_buf_done and fill_buf_done, those
operations will call vb2_buffer_done.

> 
>> +	}
>> +
>> +	ret = vidc_hfi_session_unload_res(hfi, inst->hfi_inst);
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
>> +	ret = internal_bufs_free(inst);
>> +
>> +	if (hfi_inst->state == INST_INVALID || hfi->state == CORE_INVALID) {
>> +		ret = -EINVAL;
>> +		goto abort;
>> +	}
>> +
>> +abort:
>> +	if (ret)
>> +		vidc_hfi_session_abort(hfi, inst->hfi_inst);
>> +
>> +	vidc_scale_clocks(inst->core);
>> +
>> +	ret = vidc_hfi_session_deinit(hfi, inst->hfi_inst);
>> +
>> +	mutex_lock(&inst->lock);
>> +	inst->streamoff = 1;
>> +	mutex_unlock(&inst->lock);
>> +
>> +	if (ret)
>> +		dev_err(dev, "stop streaming failed type: %d, ret: %d\n",
>> +			q->type, ret);
>> +
>> +	ret = pm_runtime_put_sync(dev);
>> +	if (ret < 0)
>> +		dev_err(dev, "%s: pm_runtime_put_sync (%d)\n", __func__, ret);
>> +}
>> +
>> +int vidc_vb2_start_streaming(struct vidc_inst *inst)
>> +{
>> +	struct device *dev = inst->core->dev;
>> +	struct hfi_core *hfi = &inst->core->hfi;
>> +	struct vidc_buffer *buf, *n;
>> +	int ret;
>> +
>> +	ret = session_register_bufs(inst);
>> +	if (ret)
>> +		return ret;
>> +
>> +	ret = internal_bufs_alloc(inst);
>> +	if (ret)
>> +		return ret;
>> +
>> +	vidc_scale_clocks(inst->core);
>> +
>> +	ret = vidc_hfi_session_load_res(hfi, inst->hfi_inst);
>> +	if (ret) {
>> +		dev_err(dev, "session: load resources (%d)\n", ret);
>> +		return ret;
>> +	}
>> +
>> +	ret = vidc_hfi_session_start(hfi, inst->hfi_inst);
>> +	if (ret) {
>> +		dev_err(dev, "session: start failed (%d)\n", ret);
>> +		return ret;
>> +	}
>> +
>> +	mutex_lock(&inst->bufqueue_lock);
>> +	list_for_each_entry_safe(buf, n, &inst->bufqueue, list) {
>> +		ret = session_set_buf(&buf->vb.vb2_buf);
>> +		if (ret)
>> +			break;
>> +	}
>> +	mutex_unlock(&inst->bufqueue_lock);
>> +
>> +	if (!ret) {
>> +		mutex_lock(&inst->lock);
>> +		inst->streamon = 1;
>> +		mutex_unlock(&inst->lock);
>> +	}
>> +
>> +	return ret;
>> +}
>> diff --git a/drivers/media/platform/qcom/vidc/helpers.h b/drivers/media/platform/qcom/vidc/helpers.h
>> new file mode 100644
>> index 000000000000..a151c96bf939
>> --- /dev/null
>> +++ b/drivers/media/platform/qcom/vidc/helpers.h
>> @@ -0,0 +1,43 @@
>> +/*
>> + * Copyright (c) 2012-2014, The Linux Foundation. All rights reserved.
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
>> +#ifndef __VIDC_COMMON_H__
>> +#define __VIDC_COMMON_H__
> 
> s/COMMON/HELPERS/
> 
>> +
>> +#include <linux/list.h>
>> +#include <media/videobuf2-v4l2.h>
>> +
>> +#include "core.h"
>> +
>> +struct vidc_buffer {
>> +	struct vb2_v4l2_buffer vb;
>> +	struct list_head list;
>> +	dma_addr_t dma_addr;
>> +	struct list_head hfi_list;
> 
> This seems to be the list_head used for associating buffers to the
> _vidc_ instances.
> 
>> +	struct hfi_buffer_desc bd;
>> +};
>> +
>> +#define to_vidc_buffer(buf)	container_of(buf, struct vidc_buffer, vb)
>> +
>> +struct vb2_v4l2_buffer *
>> +vidc_vb2_find_buf(struct vidc_inst *inst, dma_addr_t addr);
>> +int vidc_vb2_buf_init(struct vb2_buffer *vb);
>> +int vidc_vb2_buf_prepare(struct vb2_buffer *vb);
>> +void vidc_vb2_buf_queue(struct vb2_buffer *vb);
>> +void vidc_vb2_stop_streaming(struct vb2_queue *q);
>> +int vidc_vb2_start_streaming(struct vidc_inst *inst);
>> +int vidc_buf_descs(struct vidc_inst *inst, u32 type,
>> +		   struct hfi_buffer_requirements *out);
>> +int vidc_set_color_format(struct vidc_inst *inst, u32 type, u32 fmt);
>> +#endif
>> diff --git a/drivers/media/platform/qcom/vidc/int_bufs.c b/drivers/media/platform/qcom/vidc/int_bufs.c
> [..]
>> +
>> +static int internal_alloc_and_set(struct vidc_inst *inst,
>> +				  struct hfi_buffer_requirements *bufreq,
>> +				  struct vidc_list *buf_list)
>> +{
>> +	struct vidc_internal_buf *buf;
>> +	struct vidc_mem *mem;
>> +	unsigned int i;
>> +	int ret = 0;
>> +
>> +	if (!bufreq->size)
>> +		return 0;
>> +
>> +	for (i = 0; i < bufreq->count_actual; i++) {
>> +		mem = mem_alloc(inst->core->dev, bufreq->size, 0);
> 
> Inline mem_alloc here; might need to make sure bufreq->size is 4K
> aligned.

OK, I will give it a try.

> 
>> +		if (IS_ERR(mem)) {
>> +			ret = PTR_ERR(mem);
>> +			goto err_no_mem;
>> +		}
>> +
>> +		buf = kzalloc(sizeof(*buf), GFP_KERNEL);
>> +		if (!buf) {
>> +			ret = -ENOMEM;
>> +			goto fail_kzalloc;
>> +		}
>> +
>> +		buf->mem = mem;
>> +		buf->type = bufreq->type;
>> +
>> +		ret = internal_set_buf_on_fw(inst, bufreq->type, mem, false);
>> +		if (ret)
>> +			goto fail_set_buffers;
>> +
>> +		mutex_lock(&buf_list->lock);
>> +		list_add_tail(&buf->list, &buf_list->list);
>> +		mutex_unlock(&buf_list->lock);
>> +	}
>> +
>> +	return ret;
>> +
>> +fail_set_buffers:
>> +	kfree(buf);
>> +fail_kzalloc:
>> +	mem_free(mem);
>> +err_no_mem:
>> +	return ret;
>> +}
>> +
> [..]
>> +
>> +static int persist_set_buffer(struct vidc_inst *inst, u32 type)
>> +{
>> +	struct hfi_buffer_requirements bufreq;
>> +	int ret;
>> +
>> +	ret = vidc_buf_descs(inst, type, &bufreq);
>> +	if (ret)
>> +		return 0;
>> +
>> +	mutex_lock(&inst->persistbufs.lock);
>> +	if (!list_empty(&inst->persistbufs.list)) {
> 
> This function is called twice, with type HFI_BUFFER_INTERNAL_PERSIST and
> HFI_BUFFER_INTERNAL_PERSIST_1 respectively. Unless the buffer
> requirements are missing for HFI_BUFFER_INTERNAL_PERSIST persistbufs
> won't be empty and we will skip the later allocation.
> 
>> +		mutex_unlock(&inst->persistbufs.lock);
>> +		return 0;
>> +	}
>> +	mutex_unlock(&inst->persistbufs.lock);
>> +
>> +	return internal_alloc_and_set(inst, &bufreq, &inst->persistbufs);
>> +}
>> +
> [..]
>> +
>> +static int scratch_set_buffers(struct vidc_inst *inst)
>> +{
>> +	struct device *dev = inst->core->dev;
>> +	int ret;
>> +
>> +	ret = scratch_unset_buffers(inst, true);
>> +	if (ret)
>> +		dev_warn(dev, "Failed to release scratch buffers\n");
> 
> internal_bufs_free() calls scratch_unset_buffers(reuse=false) so we're
> coming here with an empty scratchbufs either way - meaning that this
> whole file can be greatly simplified.
> 
> So instead of trying to fix that I would suggest that you just let
> internal_bufs_alloc() acquire the buffer requirements and call
> internal_alloc_and_set() directly, storing the result in a single list.
> 
> And then inline a free method in internal_bufs_free() as well as drop
> all reuse-stuff and unused/dead code.
> 
> That would simplify this file quite a bit and if there actually is a
> need for the reusing of buffer that can be added at some later time.
> 

Actially I thought about droping the reuse stuff in the past, so I agree
on that cleanup. The thing which worries me is the size of those buffers
(the biggest is 10-15MB) and also the allocation time. Currently those
buffers are allocate on streamon time, but probably the right place is
on request_buf time.

>> +
>> +	ret = scratch_set_buffer(inst, HFI_BUFFER_INTERNAL_SCRATCH);
>> +	if (ret)
>> +		goto error;
>> +
>> +	ret = scratch_set_buffer(inst, HFI_BUFFER_INTERNAL_SCRATCH_1);
>> +	if (ret)
>> +		goto error;
>> +
>> +	ret = scratch_set_buffer(inst, HFI_BUFFER_INTERNAL_SCRATCH_2);
>> +	if (ret)
>> +		goto error;
>> +
>> +	return 0;
>> +error:
>> +	scratch_unset_buffers(inst, false);
>> +	return ret;
>> +}
>> +
>> +static int persist_set_buffers(struct vidc_inst *inst)
>> +{
>> +	int ret;
>> +
>> +	ret = persist_set_buffer(inst, HFI_BUFFER_INTERNAL_PERSIST);
>> +	if (ret)
>> +		goto error;
>> +
>> +	ret = persist_set_buffer(inst, HFI_BUFFER_INTERNAL_PERSIST_1);
>> +	if (ret)
>> +		goto error;
>> +
>> +	return 0;
>> +
>> +error:
>> +	persist_unset_buffers(inst);
>> +	return ret;
>> +}
>> +
>> +int internal_bufs_alloc(struct vidc_inst *inst)
>> +{
>> +	struct device *dev = inst->core->dev;
>> +	int ret;
>> +
>> +	ret = scratch_set_buffers(inst);
>> +	if (ret) {
>> +		dev_err(dev, "set scratch buffers (%d)\n", ret);
>> +		return ret;
>> +	}
>> +
>> +	ret = persist_set_buffers(inst);
>> +	if (ret) {
>> +		dev_err(dev, "set persist buffers (%d)\n", ret);
>> +		goto error;
>> +	}
>> +
>> +	return 0;
>> +
>> +error:
>> +	scratch_unset_buffers(inst, false);
>> +	return ret;
>> +}
>> +
>> +int internal_bufs_free(struct vidc_inst *inst)
>> +{
>> +	struct device *dev = inst->core->dev;
>> +	int ret;
>> +
>> +	ret = scratch_unset_buffers(inst, false);
>> +	if (ret)
>> +		dev_err(dev, "failed to release scratch buffers: %d\n", ret);
>> +
>> +	ret = persist_unset_buffers(inst);
>> +	if (ret)
>> +		dev_err(dev, "failed to release persist buffers: %d\n", ret);
>> +
>> +	return ret;
>> +}
>> diff --git a/drivers/media/platform/qcom/vidc/int_bufs.h b/drivers/media/platform/qcom/vidc/int_bufs.h
>> new file mode 100644
>> index 000000000000..5f8b2b85839f
>> --- /dev/null
>> +++ b/drivers/media/platform/qcom/vidc/int_bufs.h
>> @@ -0,0 +1,23 @@
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
>> +#ifndef __VIDC_INTERNAL_BUFFERS_H__
>> +#define __VIDC_INTERNAL_BUFFERS_H__
>> +
>> +struct vidc_inst;
>> +
>> +int internal_bufs_alloc(struct vidc_inst *inst);
>> +int internal_bufs_free(struct vidc_inst *inst);
>> +
>> +#endif
>> diff --git a/drivers/media/platform/qcom/vidc/load.c b/drivers/media/platform/qcom/vidc/load.c
>> new file mode 100644
>> index 000000000000..8ae25fc0e8a5
>> --- /dev/null
>> +++ b/drivers/media/platform/qcom/vidc/load.c
>> @@ -0,0 +1,104 @@
>> +/*
>> + * Copyright (c) 2013-2015, The Linux Foundation. All rights reserved.
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
>> +#include <linux/clk.h>
>> +
>> +#include "core.h"
>> +#include "load.h"
>> +
>> +static u32 get_inst_load(struct vidc_inst *inst)
>> +{
>> +	int mbs;
>> +	u32 w = inst->width;
>> +	u32 h = inst->height;
>> +
>> +	if (!inst->hfi_inst || !(inst->hfi_inst->state >= INST_INIT &&
>> +				 inst->hfi_inst->state < INST_STOP))
>> +		return 0;
>> +
>> +	mbs = (ALIGN(w, 16) / 16) * (ALIGN(h, 16) / 16);
>> +
>> +	return mbs * inst->fps;
>> +}
>> +
>> +static u32 get_load(struct vidc_core *core, u32 session_type)
>> +{
>> +	struct vidc_inst *inst = NULL;
>> +	u32 mbs_per_sec = 0;
>> +
>> +	mutex_lock(&core->lock);
>> +	list_for_each_entry(inst, &core->instances, list) {
>> +		if (inst->session_type != session_type)
>> +			continue;
>> +
>> +		mbs_per_sec += get_inst_load(inst);
>> +	}
>> +	mutex_unlock(&core->lock);
>> +
>> +	return mbs_per_sec;
>> +}
>> +
>> +static int scale_clocks_load(struct vidc_core *core, u32 mbs_per_sec)
>> +{
>> +	const struct freq_tbl *table = core->res->freq_tbl;
>> +	int num_rows = core->res->freq_tbl_size;
>> +	struct clk *clk = core->clks[0];
> 
> Using individual clk pointers instead of this array would make this
> "core_clk" easier to follow.

I have decided to use an array of struct clk pointers is that the number
of clocks depends on SoC, for example 8096 have 9 clks and I wanted to
avoid describing each of them as idividual one.

> 
>> +	struct device *dev = core->dev;
>> +	unsigned long freq = table[0].freq;
>> +	int ret, i;
>> +
>> +	if (!mbs_per_sec num_row&& s > 1) {
>> +		freq = table[num_rows - 1].freq;
>> +		goto set_freq;
>> +	}
> 
> Here we will set freq to the last entry in the freq table, potentially
> table[0] if num_rows == 1, so the second part of the conditional doesn't
> add any value and you can skip the early initialization above.

Ok I will reconsider this part.

> 
> And you can put the loop below in an else block instead of using a goto.
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
> 
> ret will be 0 here, so print the error message conditionally and then
> just return ret.
> 
>> +}
>> +
>> +int vidc_scale_clocks(struct vidc_core *core)
> 
> This is only called from helpers.c, drop this file and move the
> implementation there.

OK, agreed.

> 
>> +{
>> +	struct device *dev = core->dev;
>> +	u32 mbs_per_sec;
>> +	int ret;
>> +
>> +	mbs_per_sec = get_load(core, VIDC_SESSION_TYPE_ENC) +
>> +		      get_load(core, VIDC_SESSION_TYPE_DEC);
>> +
>> +	if (mbs_per_sec > core->res->max_load) {
>> +		dev_warn(dev, "HW is overloaded, needed: %d max: %d\n",
>> +			 mbs_per_sec, core->res->max_load);
>> +		return -EBUSY;
>> +	}
>> +
>> +	ret = scale_clocks_load(core, mbs_per_sec);
>> +	if (ret)
>> +		dev_warn(dev, "failed to scale clocks, performance might be impacted\n");
>> +
>> +	return 0;
>> +}
> [..]
>> diff --git a/drivers/media/platform/qcom/vidc/mem.c b/drivers/media/platform/qcom/vidc/mem.c
>> new file mode 100644
>> index 000000000000..6a83b5784410
>> --- /dev/null
>> +++ b/drivers/media/platform/qcom/vidc/mem.c
>> @@ -0,0 +1,64 @@
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
>> +#include <linux/device.h>
>> +#include <linux/dma-direction.h>
>> +#include <linux/dma-mapping.h>
>> +#include <linux/err.h>
>> +#include <linux/slab.h>
>> +
>> +#include "mem.h"
>> +
>> +struct vidc_mem *mem_alloc(struct device *dev, size_t size, int map_kernel)
> 
> This is a terrible name for a global function.
> 
> But I think you can favorably inline this into the two callers. They
> both have their own tracking objects. So just drop this entire file.

OK, I will delete it.

> 
>> +{
>> +	struct vidc_mem *mem;
>> +
>> +	if (!size)
>> +		return ERR_PTR(-EINVAL);
>> +
>> +	if (IS_ERR(dev))
>> +		return ERR_CAST(dev);
>> +
>> +	mem = kzalloc(sizeof(*mem), GFP_KERNEL);
>> +	if (!mem)
>> +		return ERR_PTR(-ENOMEM);
>> +
>> +	mem->size = ALIGN(size, SZ_4K);
>> +	mem->iommu_dev = dev;
>> +
>> +	mem->attrs = DMA_ATTR_WRITE_COMBINE;
>> +
>> +	if (!map_kernel)
>> +		mem->attrs |= DMA_ATTR_NO_KERNEL_MAPPING;
>> +
>> +	mem->kvaddr = dma_alloc_attrs(mem->iommu_dev, mem->size, &mem->da,
>> +				      GFP_KERNEL, mem->attrs);
>> +	if (!mem->kvaddr) {
>> +		kfree(mem);
>> +		return ERR_PTR(-ENOMEM);
>> +	}
>> +
>> +	return mem;
>> +}
>> +
>> +void mem_free(struct vidc_mem *mem)
>> +{
>> +	if (!mem)
>> +		return;
>> +
>> +	dma_free_attrs(mem->iommu_dev, mem->size, mem->kvaddr,
>> +	       mem->da, mem->attrs);
>> +	kfree(mem);
>> +};
> [..]
>> diff --git a/drivers/media/platform/qcom/vidc/resources.c b/drivers/media/platform/qcom/vidc/resources.c
>> new file mode 100644
>> index 000000000000..e00ed1caa824
>> --- /dev/null
>> +++ b/drivers/media/platform/qcom/vidc/resources.c
>> @@ -0,0 +1,46 @@
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
>> +#include <linux/bug.h>
>> +#include <linux/types.h>
>> +#include <linux/kernel.h>
>> +
>> +#include "hfi.h"
>> +
>> +static const struct freq_tbl msm8916_freq_table[] = {
>> +	{ 352800, 228570000 },	/* 1920x1088 @ 30 + 1280x720 @ 30 */
>> +	{ 244800, 160000000 },	/* 1920x1088 @ 30 */
>> +	{ 108000, 100000000 },	/* 1280x720 @ 30 */
>> +};
>> +
>> +static const struct reg_val msm8916_reg_preset[] = {
>> +	{ 0xe0020, 0x05555556 },
>> +	{ 0xe0024, 0x05555556 },
>> +	{ 0x80124, 0x00000003 },
>> +};
>> +
>> +const struct vidc_resources msm8916_res = {
>> +	.freq_tbl = msm8916_freq_table,
>> +	.freq_tbl_size = ARRAY_SIZE(msm8916_freq_table),
>> +	.reg_tbl = msm8916_reg_preset,
>> +	.reg_tbl_size = ARRAY_SIZE(msm8916_reg_preset),
>> +	.clks = {"core", "iface", "bus", },
>> +	.clks_num = 3,
>> +	.max_load = 352800, /* 720p@30 + 1080p@30 */
>> +	.hfi_version = 0,
> 
> Unused

hfi_version is used from vidc_hfi_create() to decide which packetization
type "3xx" or "legacy" to use. Currently msm8916 use "legacy" but I
guess msm8996 will use "3xx"

> 
>> +	.vmem_id = VIDC_RESOURCE_NONE,
> 
> Unused

Some of the planed SoCs to support with this driver has this fast  video
RAM memory, despite that msm8916 has not.

> 
>> +	.vmem_size = 0,
> 
> Unused

this is for next SoCs which we will support.

> 
>> +	.vmem_addr = 0,
> 
> Unused

same comment as above.

> 
>> +	.dma_mask = 0xddc00000 - 1,
>> +};
> 
> These tables could with favor be moved next to the of_table in vidc.c

yes, makes sense.

-- 
regards,
Stan
