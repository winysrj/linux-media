Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pa0-f54.google.com ([209.85.220.54]:32867 "EHLO
        mail-pa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753174AbcHYS1Z (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 25 Aug 2016 14:27:25 -0400
Received: by mail-pa0-f54.google.com with SMTP id ti13so19129821pac.0
        for <linux-media@vger.kernel.org>; Thu, 25 Aug 2016 11:26:46 -0700 (PDT)
Date: Thu, 25 Aug 2016 11:26:42 -0700
From: Bjorn Andersson <bjorn.andersson@linaro.org>
To: Stanimir Varbanov <stanimir.varbanov@linaro.org>
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Andy Gross <andy.gross@linaro.org>,
        Stephen Boyd <sboyd@codeaurora.org>,
        Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org
Subject: Re: [PATCH 2/8] media: vidc: adding core part and helper functions
Message-ID: <20160825182641.GJ15161@tuxbot>
References: <1471871619-25873-1-git-send-email-stanimir.varbanov@linaro.org>
 <1471871619-25873-3-git-send-email-stanimir.varbanov@linaro.org>
 <20160823025026.GZ26240@tuxbot>
 <79bd3757-fa35-d28d-7eda-9d57c6fdb619@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <79bd3757-fa35-d28d-7eda-9d57c6fdb619@linaro.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu 25 Aug 05:59 PDT 2016, Stanimir Varbanov wrote:

> Hi Bjorn,
> 
> Thanks for the review and comments!
> 
> On 08/23/2016 05:50 AM, Bjorn Andersson wrote:
> > On Mon 22 Aug 06:13 PDT 2016, Stanimir Varbanov wrote:
> > 
> > Hi Stan,
> > 
> >> This adds core part of the vidc driver common helper functions
> >> used by encoder and decoder specific files.
> > 
> > I believe "vidc" is short for "video core" and this is not the only
> > "video core" from Qualcomm. This driver is the v4l2 <-> hfi interface and
> 
> What other "video core"s do you know?
> 

The blackbird, or "vidc" as we know it in 8064. That one should likely
be named "mfc" though.

> > uses either two ram based fifos _or_ apr tal for communication with the
> > implementation.
> > 
> > In the case of apr, the other side is not the venus core but rather the
> > "VIDC" apr service on the Hexagon DSP. In this case the hfi packets are
> > encapsulated in apr packets. Although this is not used in 8916 it would
> > be nice to be able to add this later...
> 
> OK, you are talking about q6_hfi.c which file is found in msm-3.10 and
> maybe older kernel versions.
> 

That's the one.

> There is a function vidc_hfi_create() which currently creates venus hfi
> interface but it aways could be extended to call q6 DSP specific function.
> 

As the ADSP comes up with a VIDC service (on the applicable platform(s))
we get an APR channel, the concept is similar from then on but rather
than putting the messages directly into the venus hfi tx/rx fifos a
header is prepended to each hfi message and it's passed to the APR.

In the Qualcomm code the hfi ops are picked as vidc_hfi_create() is
called, but I think flipping that upside down to have the venus_hfi or
q6_hfi be the probe point and then calling the common probe part with an
ops struct associated would be more natural.

I do however not see a problem with doing such refactoring in the
future, I just wanted to bring it up.

> > 
> > 
> > But I think we should call this driver "hfi" - or at least venus, as
> > it's not compatible with e.g the "blackbird" found in 8064, which is
> > also called "vidc".
> 
> Do you think that vidc driver for 8064 will ever reach the mainline kernel?
> 

There are strong wishes for it to be supported, so we should take
reasonable measures to make sure its possible.

> I personally don't like hfi nor venus other suggestions? Does "vidcore"
> or "vcore" makes sense?
> 

These names would imply that we intend to have a single driver for all Qualcomm
video encoder/decoders.

As it's really hard to envision the future, or to argue about 8064 vidc,
I would rather see a driver for the hfi based video encoder/decoders.

If we in 8996+1 see a non-hfi chip benefit greatly from reusing
something from this implementation then those better go into the v4l
core or some other common entity.

[..]
> >> diff --git a/drivers/media/platform/qcom/vidc/core.c b/drivers/media/platform/qcom/vidc/core.c
[..]
> >> +static void vidc_sys_error_handler(struct work_struct *work)
> >> +{
> >> +	struct vidc_sys_error *handler =
> >> +		container_of(work, struct vidc_sys_error, work.work);
> >> +	struct vidc_core *core = handler->core;
> >> +	struct hfi_core *hfi = &core->hfi;
> >> +	struct device *dev = core->dev;
> >> +	int ret;
> >> +
> >> +	mutex_lock(&hfi->lock);
> >> +	if (hfi->state != CORE_INVALID)
> >> +		goto exit;
> >> +
> >> +	mutex_unlock(&hfi->lock);
> >> +
> >> +	ret = vidc_hfi_core_deinit(hfi);
> >> +	if (ret)
> >> +		dev_err(dev, "core: deinit failed (%d)\n", ret);
> >> +
> >> +	mutex_lock(&hfi->lock);
> >> +
> >> +	rproc_report_crash(core->rproc, RPROC_FATAL_ERROR);
> > 
> > This operation is async, as such I believe this to be fragile. To get
> > the expected result you should be able to simply call
> > rproc_shutdown()/rproc_boot() to restart the core...
> 
> OK will remove crash report for now.
> 
> > 
> > However, if we at any point would like to be able to get memory dumps
> > from this core (likely a requirement on the Qualcomm side) we need to
> > call rproc_report_crash() and let it collect the resources and then
> > power cycle the core.
> > 
> > 
> > As the life cycle of the venus driver goes 1:1 with the rproc driver I
> > think it would be more suitable to make the v4l driver a child of the
> > rproc driver and have it probe/remove this driver as the rproc comes and
> > goes. This would allow us to call rproc_report_crash() here, we will be
> > removed and when the crash is handled (sometime in the future) we will
> > be probed again.
> 
> What's the problem with Kconfig "depends on QCOM_VENUS_PIL", isn't that
> enough?
> 

I mean in runtime, not compile time.

Devices instantiated from this driver does not serve a purpose without
either the venus rproc running or the adsp running. Further more as we
detect an issue with the remote core these resources (the venus or adsp)
will be stopped and restarted - potentially with a long delay inbetween
for ramdumping.

So either the venus driver must be resilient towards the remote being
gone or we should tie the venus driver to the running state of the
remoteproc driver.

One way to do that would be to add a of_platform_populate() in
venus_start() and a of_platform_depopulate() in venus_stop() and
represent the hfi-venus driver as a child of the remoteproc driver.

> > 
> >> +
> >> +	vidc_rproc_shutdown(core);
> >> +
> >> +	ret = vidc_rproc_boot(core);
> >> +	if (ret)
> >> +		goto exit;
> >> +
> >> +	hfi->state = CORE_INIT;
> >> +
> >> +exit:
> >> +	mutex_unlock(&hfi->lock);
> >> +	kfree(handler);
> >> +}
> >> +
> >> +static int vidc_event_notify(struct hfi_core *hfi, u32 event)
> >> +{
> >> +	struct vidc_sys_error *handler;
> >> +	struct hfi_inst *inst;
> >> +
> >> +	switch (event) {
> >> +	case EVT_SYS_WATCHDOG_TIMEOUT:
> >> +	case EVT_SYS_ERROR:
> >> +		break;
> >> +	default:
> >> +		return -EINVAL;
> >> +	}
> >> +
> >> +	mutex_lock(&hfi->lock);
> >> +
> >> +	hfi->state = CORE_INVALID;
> >> +
> >> +	list_for_each_entry(inst, &hfi->instances, list) {
> >> +		mutex_lock(&inst->lock);
> >> +		inst->state = INST_INVALID;
> >> +		mutex_unlock(&inst->lock);
> >> +	}
> >> +
> >> +	mutex_unlock(&hfi->lock);
> >> +
> >> +	handler = kzalloc(sizeof(*handler), GFP_KERNEL);
> >> +	if (!handler)
> >> +		return -ENOMEM;
> >> +
> >> +	handler->core = container_of(hfi, struct vidc_core, hfi);
> >> +	INIT_DELAYED_WORK(&handler->work, vidc_sys_error_handler);
> >> +
> >> +	/*
> >> +	 * Sleep for 5 sec to ensure venus has completed any
> >> +	 * pending cache operations. Without this sleep, we see
> >> +	 * device reset when firmware is unloaded after a sys
> >> +	 * error.
> >> +	 */
> >> +	schedule_delayed_work(&handler->work, msecs_to_jiffies(5000));
> >> +
> >> +	return 0;
> >> +}
> >> +
> >> +static const struct hfi_core_ops vidc_core_ops = {
> >> +	.event_notify = vidc_event_notify,
> >> +};
> > 
> > This is an overly generic way of calling vidc_sys_error_handler().
> > There is no need for having the hfi_core_ops indirections for a single
> > op that will only exist in 1 and only 1 variant.
> 
> The .event_notify operation is called by hfi part (in hfi_msgs.c) of the
> driver and I don't want break the interface. My idea was to have HFI
> part and v4l2 part, and each of these parts taking care of their
> specifics. The interface between HFI <-> v4l2 should be immutable and
> shoudn't be changed when every new version of the hardware IP rise up.
> 

I'm fine with having the structural split between the two pieces
(although I see it serving little purpose), but I don't think it's
necessary to use a function pointer interface for something that always
only will have a single possible value.

> > 
> > Just replace the two affected event_notify() calls with a direct call to
> > this function (and clean it up a bit).
> > 
> >> +
[..]
> >> +
> >> +static irqreturn_t vidc_isr_thread(int irq, void *dev_id)
> >> +{
> >> +	return vidc_hfi_isr_thread(irq, dev_id);
> >> +}
> >> +
> >> +static irqreturn_t vidc_isr(int irq, void *dev)
> >> +{
> >> +	return vidc_hfi_isr(irq, dev);
> >> +}
> > 
> > These two functions indicates that we're requesting the irq in the wrong
> > layer.
> 
> IMO the proper place is platform driver .probe method.
> 

If we squash the vidc-core and hfi-core into one this oddness should go
away, right?

> > 
> > Also, these two functions arrives in a later patchset, so I assume this
> > doesn't compile...
> 
> That's why I'm adding Makefiles later on patchset. On the other hand I
> have splitted the driver by files because I think it is easier for
> review. But I might be wrong.
> 

Ok, I'm afraid I don't have any good suggestion to counter this. It's
hard to introduce a minimal functional driver for this and then add
features - as any "minimal" version is large.


Sorry for all the "unused" comments for later patches, I didn't double
check those with the end result.

> > 
> >> +
[..]
> >> +
> >> +static int vidc_probe(struct platform_device *pdev)
> >> +{
> >> +	struct device *dev = &pdev->dev;
> >> +	struct vidc_core *core;
> >> +	struct device_node *rproc;
> >> +	struct resource *r;
> >> +	int ret;
> >> +
> >> +	core = devm_kzalloc(dev, sizeof(*core), GFP_KERNEL);
> >> +	if (!core)
> >> +		return -ENOMEM;
> >> +
> >> +	core->dev = dev;
> >> +	platform_set_drvdata(pdev, core);
> >> +
> >> +	rproc = of_parse_phandle(dev->of_node, "rproc", 0);
> >> +	if (IS_ERR(rproc))
> >> +		return PTR_ERR(rproc);
> >> +
> >> +	core->rproc = rproc_get_by_phandle(rproc->phandle);
> > 
> > FYI, We're hoping to land some patches shortly that will replace this
> > with rproc_get(pdev->dev.of_node), looking up an rproc by the standard
> > "rprocs" property...
> 
> OK, that looks good. But shoudn't be rproc_get(pdev->dev)?
> 

Sorry, the patches in flight introduces of_rproc_get() - not
rproc_get(), which takes a device_node. But it's still pending some DT
discussions.

> > 
> >> +	if (IS_ERR(core->rproc))
> >> +		return PTR_ERR(core->rproc);
> >> +	else if (!core->rproc)
> >> +		return -EPROBE_DEFER;
> > 
> > We're cleaning up this in the core as well.
> > 
> > You need to rproc_put() the rproc pointer after this point.
> 
> OK, good. When those changes landed I will rework this part.
> 
> > 
> > 
> > My question still stands though, if this driver should be probed as the
> > remoteproc is booted (or the apr service appearing). I will continue to
> > look at that.
> 
> I might be misunderstood your point here. Is your concern related to
> EPROBE_DEFFER or some sort of ordering issue in rproc?
> 
> Currently the vidc depends on QCOM_VENUS_PIL in Kconfig, so modprobe
> vidc should modprobe remoteproc driver cause it depends on it.
> 

If we probe the two drivers independently, then you're good. I just
don't see how we (sanely) will communicate the information about when
the remote goes down and comes up related to a crash.

> > 
> >> +
> >> +	r = platform_get_resource(pdev, IORESOURCE_MEM, 0);
> >> +	core->base = devm_ioremap_resource(dev, r);
> >> +	if (IS_ERR(core->base))
> >> +		return PTR_ERR(core->base);
> >> +
> >> +	core->irq = platform_get_irq(pdev, 0);
> >> +	if (core->irq < 0)
> >> +		return core->irq;
> >> +
> >> +	core->res = of_device_get_match_data(dev);
> >> +	if (!core->res)
> >> +		return -ENODEV;
> >> +
> >> +	ret = vidc_clks_get(core, core->res->clks_num, core->res->clks);
> >> +	if (ret)
> >> +		return ret;
> >> +
> >> +	ret = dma_set_mask_and_coherent(dev, core->res->dma_mask);
> >> +	if (ret)
> >> +		return ret;
> >> +
> >> +	INIT_LIST_HEAD(&core->instances);
> >> +	mutex_init(&core->lock);
> >> +
> >> +	ret = devm_request_threaded_irq(dev, core->irq, vidc_isr,
> >> +					vidc_isr_thread,
> >> +					IRQF_TRIGGER_HIGH | IRQF_ONESHOT,
> > 
> > Drop this IRQF_TRIGGER_HIGH and have this be specified in devicetree.
> 
> OK can do that, but is there a convention about who is populating the
> flag and what is the precedence dt against the driver?
> 

It seems there's a push lately for moving to getting the trigger from
DT. But I haven't not studied the details or reasoning behind it.

> > 
> >> +					"vidc", &core->hfi);
> >> +	if (ret)
> >> +		return ret;
> >> +
> >> +	core->hfi.core_ops = &vidc_core_ops;
> >> +	core->hfi.dev = dev;
> >> +
> >> +	ret = vidc_hfi_create(&core->hfi, core->res, core->base);
> >> +	if (ret)
> >> +		return ret;
> >> +
> >> +	ret = vidc_clks_enable(core, core->res);
> >> +	if (ret)
> >> +		goto err_hfi_destroy;
> >> +
> >> +	ret = vidc_rproc_boot(core);
> >> +	if (ret) {
> >> +		vidc_clks_disable(core, core->res);
> >> +		goto err_hfi_destroy;
> >> +	}
> >> +
> >> +	pm_runtime_enable(dev);
> >> +
> >> +	ret = pm_runtime_get_sync(dev);
> >> +	if (ret < 0)
> >> +		goto err_runtime_disable;
> >> +
> >> +	ret = vidc_hfi_core_init(&core->hfi);
> >> +	if (ret)
> >> +		goto err_rproc_shutdown;
> >> +
> >> +	ret = pm_runtime_put_sync(dev);
> >> +	if (ret)
> >> +		goto err_core_deinit;
> >> +
> >> +	vidc_clks_disable(core, core->res);
> > 
> > These operations follow the general pattern of booting other Qualcomm
> > remoteprocs; acquire and enable some resources, boot the core and
> > disable the resources. Therefor it looks quite likely that these
> > operations are related to the life cycle of the venus core, rather than
> > hfi.
> 
> So you saying that
> 

I'm saying that I would like for the rproc driver to be able to boot,
shutdown and handle a crash (not trigger) without having to depend on
the venus driver setting up a bunch of resources for it.

Either that or the venus rproc driver should not be a standalone rproc
driver - with its own probe function.

> > 
> >> +
> >> +	ret = v4l2_device_register(dev, &core->v4l2_dev);
> >> +	if (ret)
> >> +		goto err_core_deinit;
> >> +
> >> +	ret = vdec_init(core, &core->vdev_dec);
> >> +	if (ret)
> >> +		goto err_dev_unregister;
> >> +
> >> +	ret = venc_init(core, &core->vdev_enc);
> >> +	if (ret)
> >> +		goto err_vdec_deinit;
> >> +
> >> +	return 0;
> >> +
> >> +err_vdec_deinit:
> >> +	vdec_deinit(core, &core->vdev_dec);
> >> +err_dev_unregister:
> >> +	v4l2_device_unregister(&core->v4l2_dev);
> >> +err_core_deinit:
> >> +	vidc_hfi_core_deinit(&core->hfi);
> >> +err_rproc_shutdown:
> >> +	vidc_rproc_shutdown(core);
> >> +err_runtime_disable:
> >> +	pm_runtime_set_suspended(dev);
> >> +	pm_runtime_disable(dev);
> >> +err_hfi_destroy:
> >> +	vidc_hfi_destroy(&core->hfi);
> >> +	return ret;
> >> +}
> >> +
> >> +static int vidc_remove(struct platform_device *pdev)
> >> +{
> >> +	struct vidc_core *core = platform_get_drvdata(pdev);
> >> +	int ret;
> >> +
> >> +	ret = pm_runtime_get_sync(&pdev->dev);
> >> +	if (ret < 0)
> >> +		return ret;
> > 
> > No-one cares about you returning an error here, so you better move
> > forward and release as much of your resources as possible even though
> > you didn't get your pm.
> 
> Hmm, I don't agree here. The runtime_resume will enable clocks (for
> example venus iface clk) and if it fails the subsequent call to
> vidc_rproc_shutdown can crash badly.
> 

Sorry for not being clear, that part we care about. What I meant was
that in the device core will dismantle your driver regardless of you
returning an error here. So you will leak the resources not freed below.

> > 
> >> +
> >> +	ret = vidc_hfi_core_deinit(&core->hfi);
> >> +	if (ret) {
> >> +		pm_runtime_put_sync(&pdev->dev);
> >> +		return ret;
> >> +	}
> >> +
> >> +	vidc_rproc_shutdown(core);
> >> +
> >> +	ret = pm_runtime_put_sync(&pdev->dev);
> >> +
> >> +	vidc_hfi_destroy(&core->hfi);
> >> +	vdec_deinit(core, &core->vdev_dec);
> >> +	venc_deinit(core, &core->vdev_enc);
> >> +	v4l2_device_unregister(&core->v4l2_dev);
> >> +
> >> +	pm_runtime_disable(core->dev);
> >> +
> >> +	return ret < 0 ? ret : 0;
> >> +}
> >> +
[..]
> >> diff --git a/drivers/media/platform/qcom/vidc/core.h b/drivers/media/platform/qcom/vidc/core.h
[..]
> 
> > 
> >> +
> >> +struct vidc_list {
> >> +	struct list_head list;
> >> +	struct mutex lock;
> >> +};
> > 
> > Can't we get away without passing around lockable lists? Does these
> > lists have to be locked independently and should we really pass around
> > their lock with them?
> 
> I guess it is possible but didn't spent to much time on that (I had more
> important problems to solve with downstream driver). So the answer is
> yes and I have to re-consider it.
> 

We with rework of internal buffers this should be less of a problem, you
could with favor grab the one lock, allocate all internal buffers and
then unlock the lock again.

[..]
> >> diff --git a/drivers/media/platform/qcom/vidc/helpers.c b/drivers/media/platform/qcom/vidc/helpers.c
[..]
> >> +int vidc_buf_descs(struct vidc_inst *inst, u32 type,
> >> +		   struct hfi_buffer_requirements *out)
> > 
> > If you call this vidc_get_buf_requirements() it would actually describe
> > what's going on. But why is this hfi wrapper in the core, rather than
> 
> the original name of this function was similar to what you suggest but I
> decided in last-minute cleanup to shorten its name.
> 

vidc_get_bufreq() should be short enough :)

> > just have the internal buffer manager call it directly.
> 
> It is in the core cause I used it on few places to gather buffer count
> needed depending on parameters (resolution, codec). Good example is
> vb2_ops::queue_setup where I need to return num_buffers depending on
> resolution, codec, bitrate, framerate and so on.
> 

Ok, that makes sense.

> > 
> > The call doesn't seem to depend on the parameters or state, can we
> > cache the result?
> 
> No, we cannot. see above comment. Something more the scratch and
> prersist buffer sizes can also be changed by the firmware depending on
> above proparties.
> 

Okay, I figured that might be the case.

> > 
> >> +{
> >> +	struct hfi_core *hfi = &inst->core->hfi;
> >> +	u32 ptype = HFI_PROPERTY_CONFIG_BUFFER_REQUIREMENTS;
> >> +	union hfi_get_property hprop;
> >> +	int ret, i;
> >> +
> >> +	if (out)
> >> +		memset(out, 0, sizeof(*out));
> >> +
> >> +	ret = vidc_hfi_session_get_property(hfi, inst->hfi_inst, ptype, &hprop);
> >> +	if (ret)
> >> +		return ret;
> >> +
> >> +	ret = -EINVAL;
> >> +
> >> +	for (i = 0; i < HFI_BUFFER_TYPE_MAX; i++) {
> >> +		if (hprop.bufreq[i].type != type)
> >> +			continue;
> >> +
> >> +		if (out)
> >> +			memcpy(out, &hprop.bufreq[i], sizeof(*out));
> >> +		ret = 0;
> >> +		break;
> >> +	}
> >> +
> >> +	return ret;
> >> +}
> >> +
> > [..]
> >> +
> >> +void vidc_vb2_stop_streaming(struct vb2_queue *q)
> >> +{
> >> +	struct vidc_inst *inst = vb2_get_drv_priv(q);
> >> +	struct hfi_inst *hfi_inst = inst->hfi_inst;
> >> +	struct vidc_core *core = inst->core;
> >> +	struct device *dev = core->dev;
> >> +	struct hfi_core *hfi = &core->hfi;
> >> +	int ret, streamoff;
> >> +
> >> +	mutex_lock(&inst->lock);
> >> +	streamoff = inst->streamoff;
> >> +	mutex_unlock(&inst->lock);
> >> +
> >> +	if (streamoff)
> >> +		return;
> >> +
> >> +	mutex_lock(&inst->lock);
> >> +	if (inst->streamon == 0) {
> >> +		mutex_unlock(&inst->lock);
> >> +		return;
> >> +	}
> >> +	mutex_unlock(&inst->lock);
> > 
> > Why do we keep track of streamon and stream off, why isn't streamoff
> > ever cleared? Why don't we check both conditions in one critical region?
> 
> Probably cause its buggy, I will sort it out.
> 
> > 
> >> +
> >> +	ret = vidc_hfi_session_stop(hfi, inst->hfi_inst);
> >> +	if (ret) {
> >> +		dev_err(dev, "session: stop failed (%d)\n", ret);
> >> +		goto abort;
> > 
> > When are we going to relaim the buffers in these cases?
> 
> session_stop will instruct the firmware return buffers to the v4l2
> driver through hfi_inst_ops empty_buf_done and fill_buf_done, those
> operations will call vb2_buffer_done.
> 

Okay, but does that include the internal buffers as well?

> > 
> >> +	}
> >> +
> >> +	ret = vidc_hfi_session_unload_res(hfi, inst->hfi_inst);
> >> +	if (ret) {
> >> +		dev_err(dev, "session: release resources failed (%d)\n", ret);
> >> +		goto abort;
> >> +	}
> >> +
> >> +	ret = session_unregister_bufs(inst);
> >> +	if (ret) {
> >> +		dev_err(dev, "failed to release capture buffers: %d\n", ret);
> >> +		goto abort;
> >> +	}
> >> +
> >> +	ret = internal_bufs_free(inst);
> >> +
> >> +	if (hfi_inst->state == INST_INVALID || hfi->state == CORE_INVALID) {
> >> +		ret = -EINVAL;
> >> +		goto abort;
> >> +	}
> >> +
> >> +abort:
> >> +	if (ret)
> >> +		vidc_hfi_session_abort(hfi, inst->hfi_inst);
> >> +
> >> +	vidc_scale_clocks(inst->core);
> >> +
> >> +	ret = vidc_hfi_session_deinit(hfi, inst->hfi_inst);
> >> +
> >> +	mutex_lock(&inst->lock);
> >> +	inst->streamoff = 1;
> >> +	mutex_unlock(&inst->lock);
> >> +
> >> +	if (ret)
> >> +		dev_err(dev, "stop streaming failed type: %d, ret: %d\n",
> >> +			q->type, ret);
> >> +
> >> +	ret = pm_runtime_put_sync(dev);
> >> +	if (ret < 0)
> >> +		dev_err(dev, "%s: pm_runtime_put_sync (%d)\n", __func__, ret);
> >> +}
> >> +
[..]
> >> diff --git a/drivers/media/platform/qcom/vidc/helpers.h b/drivers/media/platform/qcom/vidc/helpers.h
[..]
> >> +static int scratch_set_buffers(struct vidc_inst *inst)
> >> +{
> >> +	struct device *dev = inst->core->dev;
> >> +	int ret;
> >> +
> >> +	ret = scratch_unset_buffers(inst, true);
> >> +	if (ret)
> >> +		dev_warn(dev, "Failed to release scratch buffers\n");
> > 
> > internal_bufs_free() calls scratch_unset_buffers(reuse=false) so we're
> > coming here with an empty scratchbufs either way - meaning that this
> > whole file can be greatly simplified.
> > 
> > So instead of trying to fix that I would suggest that you just let
> > internal_bufs_alloc() acquire the buffer requirements and call
> > internal_alloc_and_set() directly, storing the result in a single list.
> > 
> > And then inline a free method in internal_bufs_free() as well as drop
> > all reuse-stuff and unused/dead code.
> > 
> > That would simplify this file quite a bit and if there actually is a
> > need for the reusing of buffer that can be added at some later time.
> > 
> 
> Actially I thought about droping the reuse stuff in the past, so I agree
> on that cleanup. The thing which worries me is the size of those buffers
> (the biggest is 10-15MB) and also the allocation time. Currently those
> buffers are allocate on streamon time, but probably the right place is
> on request_buf time.
> 

I think this is definitely worth investigating and should be possible to
add incrementally once the driver has landed. As far as I can see the
code doesn't really work as it is now, so rather than fixing that make
it dead-simple and then add to it later.

> >> +
> >> +	ret = scratch_set_buffer(inst, HFI_BUFFER_INTERNAL_SCRATCH);
> >> +	if (ret)
> >> +		goto error;
> >> +
> >> +	ret = scratch_set_buffer(inst, HFI_BUFFER_INTERNAL_SCRATCH_1);
> >> +	if (ret)
> >> +		goto error;
> >> +
> >> +	ret = scratch_set_buffer(inst, HFI_BUFFER_INTERNAL_SCRATCH_2);
> >> +	if (ret)
> >> +		goto error;
> >> +
> >> +	return 0;
> >> +error:
> >> +	scratch_unset_buffers(inst, false);
> >> +	return ret;
> >> +}
> >> +

Regards,
Bjorn
