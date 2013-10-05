Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:60677 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750983Ab3JEVtd (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 5 Oct 2013 17:49:33 -0400
Date: Sun, 6 Oct 2013 00:49:28 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: devel@driverdev.osuosl.org, linux-media@vger.kernel.org,
	Sergio Aguirre <sergio.a.aguirre@gmail.com>
Subject: Re: [PATCH 1/6] v4l: omap4iss: Add support for OMAP4 camera
 interface - Core
Message-ID: <20131005214928.GN3022@valkosipuli.retiisi.org.uk>
References: <1380758133-16866-1-git-send-email-laurent.pinchart@ideasonboard.com>
 <1380758133-16866-2-git-send-email-laurent.pinchart@ideasonboard.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1380758133-16866-2-git-send-email-laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Laurent,

Thanks for the patch! Some comments below.

On Thu, Oct 03, 2013 at 01:55:28AM +0200, Laurent Pinchart wrote:
...
> +int omap4iss_get_external_info(struct iss_pipeline *pipe,
> +			       struct media_link *link)
> +{
> +	struct iss_device *iss =
> +		container_of(pipe, struct iss_video, pipe)->iss;
> +	struct v4l2_subdev_format fmt;
> +	struct v4l2_ext_controls ctrls;
> +	struct v4l2_ext_control ctrl;
> +	int ret;
> +
> +	if (!pipe->external)
> +		return 0;
> +
> +	if (pipe->external_rate)
> +		return 0;
> +
> +	memset(&fmt, 0, sizeof(fmt));
> +
> +	fmt.pad = link->source->index;
> +	fmt.which = V4L2_SUBDEV_FORMAT_ACTIVE;
> +	ret = v4l2_subdev_call(media_entity_to_v4l2_subdev(link->sink->entity),
> +			       pad, get_fmt, NULL, &fmt);
> +	if (ret < 0)
> +		return -EPIPE;
> +
> +	pipe->external_bpp = omap4iss_video_format_info(fmt.format.code)->bpp;
> +
> +	memset(&ctrls, 0, sizeof(ctrls));
> +	memset(&ctrl, 0, sizeof(ctrl));
> +

As a general note, you can replace memsets of local structs and arrays by
assingning them as {0}. No need to worry about size for instance.

> +	ctrl.id = V4L2_CID_PIXEL_RATE;
> +
> +	ctrls.ctrl_class = V4L2_CTRL_ID2CLASS(ctrl.id);
> +	ctrls.count = 1;
> +	ctrls.controls = &ctrl;
> +
> +	ret = v4l2_g_ext_ctrls(pipe->external->ctrl_handler, &ctrls);
> +	if (ret < 0) {
> +		dev_warn(iss->dev, "no pixel rate control in subdev %s\n",
> +			 pipe->external->name);
> +		return ret;
> +	}
> +
> +	pipe->external_rate = ctrl.value64;
> +
> +	return 0;
> +}
> +
> +/*
> + * Configure the bridge. Valid inputs are
> + *
> + * IPIPEIF_INPUT_CSI2A: CSI2a receiver
> + * IPIPEIF_INPUT_CSI2B: CSI2b receiver
> + *
> + * The bridge and lane shifter are configured according to the selected input
> + * and the ISP platform data.
> + */
> +void omap4iss_configure_bridge(struct iss_device *iss,
> +			       enum ipipeif_input_entity input)
> +{
> +	u32 issctrl_val;
> +	u32 isp5ctrl_val;
> +
> +	issctrl_val  = readl(iss->regs[OMAP4_ISS_MEM_TOP] + ISS_CTRL);
> +	issctrl_val &= ~ISS_CTRL_INPUT_SEL_MASK;
> +	issctrl_val &= ~ISS_CTRL_CLK_DIV_MASK;
> +
> +	isp5ctrl_val  = readl(iss->regs[OMAP4_ISS_MEM_ISP_SYS1] + ISP5_CTRL);
> +
> +	switch (input) {
> +	case IPIPEIF_INPUT_CSI2A:
> +		issctrl_val |= ISS_CTRL_INPUT_SEL_CSI2A;
> +		isp5ctrl_val |= ISP5_CTRL_VD_PULSE_EXT;
> +		break;
> +
> +	case IPIPEIF_INPUT_CSI2B:
> +		issctrl_val |= ISS_CTRL_INPUT_SEL_CSI2B;
> +		isp5ctrl_val |= ISP5_CTRL_VD_PULSE_EXT;

This assignment is independent of the case. You could do that a little later
just once.

> +		break;
> +
> +	default:
> +		return;

Isn't this an error?

> +	}
> +
> +	issctrl_val |= ISS_CTRL_SYNC_DETECT_VS_RAISING;
> +
> +	isp5ctrl_val |= ISP5_CTRL_PSYNC_CLK_SEL | ISP5_CTRL_SYNC_ENABLE;
> +
> +	writel(issctrl_val, iss->regs[OMAP4_ISS_MEM_TOP] + ISS_CTRL);
> +	writel(isp5ctrl_val, iss->regs[OMAP4_ISS_MEM_ISP_SYS1] + ISP5_CTRL);
> +}

...

> +
> +/*
> + * iss_pipeline_enable - Enable streaming on a pipeline
> + * @pipe: ISS pipeline
> + * @mode: Stream mode (single shot or continuous)
> + *
> + * Walk the entities chain starting at the pipeline output video node and start
> + * all modules in the chain in the given mode.
> + *
> + * Return 0 if successful, or the return value of the failed video::s_stream
> + * operation otherwise.
> + */
> +static int iss_pipeline_enable(struct iss_pipeline *pipe,
> +			       enum iss_pipeline_stream_state mode)
> +{
> +	struct media_entity *entity;
> +	struct media_pad *pad;
> +	struct v4l2_subdev *subdev;
> +	unsigned long flags;
> +	int ret;
> +
> +	spin_lock_irqsave(&pipe->lock, flags);
> +	pipe->state &= ~(ISS_PIPELINE_IDLE_INPUT | ISS_PIPELINE_IDLE_OUTPUT);
> +	spin_unlock_irqrestore(&pipe->lock, flags);
> +
> +	pipe->do_propagation = false;
> +
> +	entity = &pipe->output->video.entity;
> +	while (1) {
> +		pad = &entity->pads[0];
> +		if (!(pad->flags & MEDIA_PAD_FL_SINK))
> +			break;
> +
> +		pad = media_entity_remote_pad(pad);
> +		if (pad == NULL ||
> +		    media_entity_type(pad->entity) != MEDIA_ENT_T_V4L2_SUBDEV)
> +			break;
> +
> +		entity = pad->entity;
> +		subdev = media_entity_to_v4l2_subdev(entity);
> +
> +		ret = v4l2_subdev_call(subdev, video, s_stream, mode);
> +		if (ret < 0 && ret != -ENOIOCTLCMD)
> +			return ret;

This loop looks very similar to that in the omap3isp driver.

It'd be nice to do this in a generic way. Something to think about in the
future perhaps. This is still queite easy; it gets somewhat more difficult
once the pipeline isn't linear.

> +	}
> +	iss_print_status(pipe->output->iss);
> +	return 0;
> +}
> +
> +/*
> + * iss_pipeline_disable - Disable streaming on a pipeline
> + * @pipe: ISS pipeline
> + *
> + * Walk the entities chain starting at the pipeline output video node and stop
> + * all modules in the chain. Wait synchronously for the modules to be stopped if
> + * necessary.
> + */
> +static int iss_pipeline_disable(struct iss_pipeline *pipe)
> +{
> +	struct media_entity *entity;
> +	struct media_pad *pad;
> +	struct v4l2_subdev *subdev;
> +	int failure = 0;
> +
> +	entity = &pipe->output->video.entity;
> +	while (1) {
> +		pad = &entity->pads[0];
> +		if (!(pad->flags & MEDIA_PAD_FL_SINK))
> +			break;
> +
> +		pad = media_entity_remote_pad(pad);
> +		if (pad == NULL ||
> +		    media_entity_type(pad->entity) != MEDIA_ENT_T_V4L2_SUBDEV)
> +			break;
> +
> +		entity = pad->entity;
> +		subdev = media_entity_to_v4l2_subdev(entity);
> +
> +		v4l2_subdev_call(subdev, video, s_stream, 0);

What would you think about combining the loop with enabling the pipeline?
The only difference is that you're disabling streaming here, not enabling
it, and no error handling is done either. Just and idea.

> +	}
> +
> +	return failure;

You always return zero here.

> +}
> +
> +/*
> + * omap4iss_pipeline_set_stream - Enable/disable streaming on a pipeline
> + * @pipe: ISS pipeline
> + * @state: Stream state (stopped, single shot or continuous)
> + *
> + * Set the pipeline to the given stream state. Pipelines can be started in
> + * single-shot or continuous mode.
> + *
> + * Return 0 if successful, or the return value of the failed video::s_stream
> + * operation otherwise. The pipeline state is not updated when the operation
> + * fails, except when stopping the pipeline.
> + */
> +int omap4iss_pipeline_set_stream(struct iss_pipeline *pipe,
> +				 enum iss_pipeline_stream_state state)
> +{
> +	int ret;
> +
> +	if (state == ISS_PIPELINE_STREAM_STOPPED)
> +		ret = iss_pipeline_disable(pipe);
> +	else
> +		ret = iss_pipeline_enable(pipe, state);
> +
> +	if (ret == 0 || state == ISS_PIPELINE_STREAM_STOPPED)
> +		pipe->stream_state = state;
> +
> +	return ret;
> +}
> +
> +/*
> + * iss_pipeline_is_last - Verify if entity has an enabled link to the output
> + *			  video node
> + * @me: ISS module's media entity
> + *
> + * Returns 1 if the entity has an enabled link to the output video node or 0
> + * otherwise. It's true only while pipeline can have no more than one output
> + * node.
> + */
> +static int iss_pipeline_is_last(struct media_entity *me)
> +{
> +	struct iss_pipeline *pipe;
> +	struct media_pad *pad;
> +
> +	if (!me->pipe)
> +		return 0;
> +	pipe = to_iss_pipeline(me);
> +	if (pipe->stream_state == ISS_PIPELINE_STREAM_STOPPED)
> +		return 0;
> +	pad = media_entity_remote_pad(&pipe->output->pad);
> +	return pad->entity == me;
> +}
> +
> +static int iss_reset(struct iss_device *iss)
> +{
> +	unsigned long timeout = 0;
> +
> +	writel(readl(iss->regs[OMAP4_ISS_MEM_TOP] + ISS_HL_SYSCONFIG) |
> +		ISS_HL_SYSCONFIG_SOFTRESET,
> +		iss->regs[OMAP4_ISS_MEM_TOP] + ISS_HL_SYSCONFIG);
> +
> +	while (readl(iss->regs[OMAP4_ISS_MEM_TOP] + ISS_HL_SYSCONFIG) &
> +			ISS_HL_SYSCONFIG_SOFTRESET) {
> +		if (timeout++ > 10000) {
> +			dev_alert(iss->dev, "cannot reset ISS\n");
> +			return -ETIMEDOUT;
> +		}
> +		udelay(1);

You only seem to do this in probe. How about e.g. usleep_range(10, 10) and
timeout of 1000?

> +	}
> +
> +	return 0;
> +}
> +
> +static int iss_isp_reset(struct iss_device *iss)
> +{
> +	unsigned long timeout = 0;
> +
> +	/* Fist, ensure that the ISP is IDLE (no transactions happening) */
> +	writel((readl(iss->regs[OMAP4_ISS_MEM_ISP_SYS1] + ISP5_SYSCONFIG) &
> +		~ISP5_SYSCONFIG_STANDBYMODE_MASK) |
> +		ISP5_SYSCONFIG_STANDBYMODE_SMART,
> +		iss->regs[OMAP4_ISS_MEM_ISP_SYS1] + ISP5_SYSCONFIG);
> +
> +	writel(readl(iss->regs[OMAP4_ISS_MEM_ISP_SYS1] + ISP5_CTRL) |
> +		ISP5_CTRL_MSTANDBY,
> +		iss->regs[OMAP4_ISS_MEM_ISP_SYS1] + ISP5_CTRL);
> +
> +	for (;;) {
> +		if (readl(iss->regs[OMAP4_ISS_MEM_ISP_SYS1] + ISP5_CTRL) &
> +				ISP5_CTRL_MSTANDBY_WAIT)
> +			break;
> +		if (timeout++ > 1000) {
> +			dev_alert(iss->dev, "cannot set ISP5 to standby\n");
> +			return -ETIMEDOUT;
> +		}
> +		msleep(1);

Is this time critical in any way? msleep(1) may end up sleeping quite a lot
longer. I propose usleep_range().

> +	}
> +
> +	/* Now finally, do the reset */
> +	writel(readl(iss->regs[OMAP4_ISS_MEM_ISP_SYS1] + ISP5_SYSCONFIG) |
> +		ISP5_SYSCONFIG_SOFTRESET,
> +		iss->regs[OMAP4_ISS_MEM_ISP_SYS1] + ISP5_SYSCONFIG);
> +
> +	timeout = 0;
> +	while (readl(iss->regs[OMAP4_ISS_MEM_ISP_SYS1] + ISP5_SYSCONFIG) &
> +			ISP5_SYSCONFIG_SOFTRESET) {
> +		if (timeout++ > 1000) {
> +			dev_alert(iss->dev, "cannot reset ISP5\n");
> +			return -ETIMEDOUT;
> +		}
> +		msleep(1);

Wow. :) Remember msleep() is usually notoriously imprecise, too. E.g.
CONFIG_HZ at 100 could mean msleep(1) sleeps up to 20 ms, and 1000 that can
be up to 20 seconds. Is this intended?

> +	}
> +
> +	return 0;
> +}
> +
> +/*
> + * iss_module_sync_idle - Helper to sync module with its idle state
> + * @me: ISS submodule's media entity
> + * @wait: ISS submodule's wait queue for streamoff/interrupt synchronization
> + * @stopping: flag which tells module wants to stop
> + *
> + * This function checks if ISS submodule needs to wait for next interrupt. If
> + * yes, makes the caller to sleep while waiting for such event.
> + */
> +int omap4iss_module_sync_idle(struct media_entity *me, wait_queue_head_t *wait,
> +			      atomic_t *stopping)
> +{
> +	struct iss_pipeline *pipe = to_iss_pipeline(me);
> +	struct iss_video *video = pipe->output;
> +	unsigned long flags;
> +
> +	if (pipe->stream_state == ISS_PIPELINE_STREAM_STOPPED ||
> +	    (pipe->stream_state == ISS_PIPELINE_STREAM_SINGLESHOT &&
> +	     !iss_pipeline_ready(pipe)))
> +		return 0;
> +
> +	/*
> +	 * atomic_set() doesn't include memory barrier on ARM platform for SMP
> +	 * scenario. We'll call it here to avoid race conditions.
> +	 */
> +	atomic_set(stopping, 1);
> +	smp_wmb();
> +
> +	/*
> +	 * If module is the last one, it's writing to memory. In this case,
> +	 * it's necessary to check if the module is already paused due to
> +	 * DMA queue underrun or if it has to wait for next interrupt to be
> +	 * idle.
> +	 * If it isn't the last one, the function won't sleep but *stopping
> +	 * will still be set to warn next submodule caller's interrupt the
> +	 * module wants to be idle.
> +	 */
> +	if (!iss_pipeline_is_last(me))
> +		return 0;
> +
> +	spin_lock_irqsave(&video->qlock, flags);
> +	if (video->dmaqueue_flags & ISS_VIDEO_DMAQUEUE_UNDERRUN) {
> +		spin_unlock_irqrestore(&video->qlock, flags);
> +		atomic_set(stopping, 0);
> +		smp_wmb();
> +		return 0;
> +	}
> +	spin_unlock_irqrestore(&video->qlock, flags);
> +	if (!wait_event_timeout(*wait, !atomic_read(stopping),
> +				msecs_to_jiffies(1000))) {
> +		atomic_set(stopping, 0);
> +		smp_wmb();
> +		return -ETIMEDOUT;
> +	}
> +
> +	return 0;
> +}
> +
> +/*
> + * omap4iss_module_sync_is_stopped - Helper to verify if module was stopping
> + * @wait: ISS submodule's wait queue for streamoff/interrupt synchronization
> + * @stopping: flag which tells module wants to stop
> + *
> + * This function checks if ISS submodule was stopping. In case of yes, it
> + * notices the caller by setting stopping to 0 and waking up the wait queue.
> + * Returns 1 if it was stopping or 0 otherwise.
> + */
> +int omap4iss_module_sync_is_stopping(wait_queue_head_t *wait,
> +				     atomic_t *stopping)
> +{
> +	if (atomic_cmpxchg(stopping, 1, 0)) {
> +		wake_up(wait);
> +		return 1;
> +	}
> +
> +	return 0;
> +}
> +
> +/* --------------------------------------------------------------------------
> + * Clock management
> + */
> +
> +#define ISS_CLKCTRL_MASK	(ISS_CLKCTRL_CSI2_A |\
> +				 ISS_CLKCTRL_CSI2_B |\
> +				 ISS_CLKCTRL_ISP)
> +
> +static int __iss_subclk_update(struct iss_device *iss)
> +{
> +	u32 clk = 0;
> +	int ret = 0, timeout = 1000;
> +
> +	if (iss->subclk_resources & OMAP4_ISS_SUBCLK_CSI2_A)
> +		clk |= ISS_CLKCTRL_CSI2_A;
> +
> +	if (iss->subclk_resources & OMAP4_ISS_SUBCLK_CSI2_B)
> +		clk |= ISS_CLKCTRL_CSI2_B;
> +
> +	if (iss->subclk_resources & OMAP4_ISS_SUBCLK_ISP)
> +		clk |= ISS_CLKCTRL_ISP;
> +
> +	writel((readl(iss->regs[OMAP4_ISS_MEM_TOP] + ISS_CLKCTRL) &
> +		~ISS_CLKCTRL_MASK) | clk,
> +		iss->regs[OMAP4_ISS_MEM_TOP] + ISS_CLKCTRL);
> +
> +	/* Wait for HW assertion */
> +	while (--timeout > 0) {
> +		udelay(1);
> +		if ((readl(iss->regs[OMAP4_ISS_MEM_TOP] + ISS_CLKSTAT) &
> +		     ISS_CLKCTRL_MASK) == clk)
> +			break;
> +	}
> +
> +	if (!timeout)
> +		ret = -EBUSY;
> +
> +	return ret;
> +}
> +
> +int omap4iss_subclk_enable(struct iss_device *iss,
> +			    enum iss_subclk_resource res)
> +{
> +	iss->subclk_resources |= res;
> +
> +	return __iss_subclk_update(iss);
> +}
> +
> +int omap4iss_subclk_disable(struct iss_device *iss,
> +			     enum iss_subclk_resource res)
> +{
> +	iss->subclk_resources &= ~res;
> +
> +	return __iss_subclk_update(iss);
> +}
> +
> +#define ISS_ISP5_CLKCTRL_MASK	(ISP5_CTRL_BL_CLK_ENABLE |\
> +				 ISP5_CTRL_ISIF_CLK_ENABLE |\
> +				 ISP5_CTRL_H3A_CLK_ENABLE |\
> +				 ISP5_CTRL_RSZ_CLK_ENABLE |\
> +				 ISP5_CTRL_IPIPE_CLK_ENABLE |\
> +				 ISP5_CTRL_IPIPEIF_CLK_ENABLE)
> +
> +static int __iss_isp_subclk_update(struct iss_device *iss)
> +{
> +	u32 clk = 0;
> +
> +	if (iss->isp_subclk_resources & OMAP4_ISS_ISP_SUBCLK_ISIF)
> +		clk |= ISP5_CTRL_ISIF_CLK_ENABLE;
> +
> +	if (iss->isp_subclk_resources & OMAP4_ISS_ISP_SUBCLK_H3A)
> +		clk |= ISP5_CTRL_H3A_CLK_ENABLE;
> +
> +	if (iss->isp_subclk_resources & OMAP4_ISS_ISP_SUBCLK_RSZ)
> +		clk |= ISP5_CTRL_RSZ_CLK_ENABLE;
> +
> +	if (iss->isp_subclk_resources & OMAP4_ISS_ISP_SUBCLK_IPIPE)
> +		clk |= ISP5_CTRL_IPIPE_CLK_ENABLE;
> +
> +	if (iss->isp_subclk_resources & OMAP4_ISS_ISP_SUBCLK_IPIPEIF)
> +		clk |= ISP5_CTRL_IPIPEIF_CLK_ENABLE;
> +
> +	if (clk)
> +		clk |= ISP5_CTRL_BL_CLK_ENABLE;
> +
> +	writel((readl(iss->regs[OMAP4_ISS_MEM_ISP_SYS1] + ISP5_CTRL) &
> +		~ISS_ISP5_CLKCTRL_MASK) | clk,
> +		iss->regs[OMAP4_ISS_MEM_ISP_SYS1] + ISP5_CTRL);
> +
> +	return 0;

You could use void return type. this function will always return void.

> +}
> +
> +int omap4iss_isp_subclk_enable(struct iss_device *iss,
> +				enum iss_isp_subclk_resource res)
> +{
> +	iss->isp_subclk_resources |= res;
> +
> +	return __iss_isp_subclk_update(iss);
> +}
> +
> +int omap4iss_isp_subclk_disable(struct iss_device *iss,
> +				enum iss_isp_subclk_resource res)
> +{
> +	iss->isp_subclk_resources &= ~res;
> +
> +	return __iss_isp_subclk_update(iss);

Same goes for these two.

> +}
> +
> +/*
> + * iss_enable_clocks - Enable ISS clocks
> + * @iss: OMAP4 ISS device
> + *
> + * Return 0 if successful, or clk_enable return value if any of tthem fails.
> + */
> +static int iss_enable_clocks(struct iss_device *iss)
> +{
> +	int r;
> +
> +	r = clk_enable(iss->iss_fck);
> +	if (r) {
> +		dev_err(iss->dev, "clk_enable iss_fck failed\n");
> +		return r;
> +	}
> +
> +	r = clk_enable(iss->iss_ctrlclk);
> +	if (r) {
> +		dev_err(iss->dev, "clk_enable iss_ctrlclk failed\n");
> +		goto out_clk_enable_ctrlclk;
> +	}
> +	return 0;
> +
> +out_clk_enable_ctrlclk:

There's a single goto above. I'd just handle the error where it happens. Up
to you.

> +	clk_disable(iss->iss_fck);
> +	return r;
> +}

...

> +static int iss_probe(struct platform_device *pdev)
> +{
> +	struct iss_platform_data *pdata = pdev->dev.platform_data;
> +	struct iss_device *iss;
> +	int i, ret;

unsigned int i?

> +	if (pdata == NULL)
> +		return -EINVAL;
> +
> +	iss = kzalloc(sizeof(*iss), GFP_KERNEL);
> +	if (!iss) {
> +		dev_err(&pdev->dev, "Could not allocate memory\n");
> +		return -ENOMEM;
> +	}
> +
> +	mutex_init(&iss->iss_mutex);
> +
> +	iss->dev = &pdev->dev;
> +	iss->pdata = pdata;
> +	iss->ref_count = 0;

ref_count was already zero before this.

> +	iss->raw_dmamask = DMA_BIT_MASK(32);
> +	iss->dev->dma_mask = &iss->raw_dmamask;
> +	iss->dev->coherent_dma_mask = DMA_BIT_MASK(32);
> +
> +	platform_set_drvdata(pdev, iss);
> +
> +	/* Clocks */
> +	ret = iss_map_mem_resource(pdev, iss, OMAP4_ISS_MEM_TOP);
> +	if (ret < 0)
> +		goto error;
> +
> +	ret = iss_get_clocks(iss);
> +	if (ret < 0)
> +		goto error;
> +
> +	if (omap4iss_get(iss) == NULL)
> +		goto error;
> +
> +	ret = iss_reset(iss);
> +	if (ret < 0)
> +		goto error_iss;
> +
> +	iss->revision = readl(iss->regs[OMAP4_ISS_MEM_TOP] + ISS_HL_REVISION);
> +	dev_info(iss->dev, "Revision %08x found\n", iss->revision);
> +
> +	for (i = 1; i < OMAP4_ISS_MEM_LAST; i++) {
> +		ret = iss_map_mem_resource(pdev, iss, i);
> +		if (ret)
> +			goto error_iss;
> +	}
> +
> +	/* Configure BTE BW_LIMITER field to max recommended value (1 GB) */
> +	writel((readl(iss->regs[OMAP4_ISS_MEM_BTE] + BTE_CTRL) & ~BTE_CTRL_BW_LIMITER_MASK) |
> +		(18 << BTE_CTRL_BW_LIMITER_SHIFT),
> +		iss->regs[OMAP4_ISS_MEM_BTE] + BTE_CTRL);
> +
> +	/* Perform ISP reset */
> +	ret = omap4iss_subclk_enable(iss, OMAP4_ISS_SUBCLK_ISP);
> +	if (ret < 0)
> +		goto error_iss;
> +
> +	ret = iss_isp_reset(iss);
> +	if (ret < 0)
> +		goto error_iss;
> +
> +	dev_info(iss->dev, "ISP Revision %08x found\n",
> +		 readl(iss->regs[OMAP4_ISS_MEM_ISP_SYS1] + ISP5_REVISION));
> +
> +	/* Interrupt */
> +	iss->irq_num = platform_get_irq(pdev, 0);
> +	if (iss->irq_num <= 0) {
> +		dev_err(iss->dev, "No IRQ resource\n");
> +		ret = -ENODEV;
> +		goto error_iss;
> +	}
> +
> +	if (request_irq(iss->irq_num, iss_isr, IRQF_SHARED, "OMAP4 ISS", iss)) {
> +		dev_err(iss->dev, "Unable to request IRQ\n");
> +		ret = -EINVAL;
> +		goto error_iss;
> +	}
> +
> +	/* Entities */
> +	ret = iss_initialize_modules(iss);
> +	if (ret < 0)
> +		goto error_irq;
> +
> +	ret = iss_register_entities(iss);
> +	if (ret < 0)
> +		goto error_modules;
> +
> +	omap4iss_put(iss);
> +
> +	return 0;
> +
> +error_modules:
> +	iss_cleanup_modules(iss);
> +error_irq:
> +	free_irq(iss->irq_num, iss);
> +error_iss:
> +	omap4iss_put(iss);
> +error:
> +	iss_put_clocks(iss);
> +
> +	for (i = 0; i < OMAP4_ISS_MEM_LAST; i++) {
> +		if (iss->regs[i]) {
> +			iounmap(iss->regs[i]);
> +			iss->regs[i] = NULL;
> +		}
> +
> +		if (iss->res[i]) {
> +			release_mem_region(iss->res[i]->start,
> +					   resource_size(iss->res[i]));
> +			iss->res[i] = NULL;
> +		}
> +	}
> +	platform_set_drvdata(pdev, NULL);
> +
> +	mutex_destroy(&iss->iss_mutex);
> +	kfree(iss);
> +
> +	return ret;
> +}
> +
> +static int iss_remove(struct platform_device *pdev)
> +{
> +	struct iss_device *iss = platform_get_drvdata(pdev);
> +	int i;

unsigned int? :)

> +	iss_unregister_entities(iss);
> +	iss_cleanup_modules(iss);
> +
> +	free_irq(iss->irq_num, iss);
> +	iss_put_clocks(iss);
> +
> +	for (i = 0; i < OMAP4_ISS_MEM_LAST; i++) {
> +		if (iss->regs[i]) {
> +			iounmap(iss->regs[i]);
> +			iss->regs[i] = NULL;
> +		}
> +
> +		if (iss->res[i]) {
> +			release_mem_region(iss->res[i]->start,
> +					   resource_size(iss->res[i]));
> +			iss->res[i] = NULL;
> +		}
> +	}
> +
> +	kfree(iss);
> +
> +	return 0;
> +}
> +
> +static struct platform_device_id omap4iss_id_table[] = {
> +	{ "omap4iss", 0 },
> +	{ },
> +};
> +MODULE_DEVICE_TABLE(platform, omap4iss_id_table);
> +
> +static struct platform_driver iss_driver = {
> +	.probe		= iss_probe,
> +	.remove		= iss_remove,
> +	.id_table	= omap4iss_id_table,
> +	.driver = {
> +		.owner	= THIS_MODULE,
> +		.name	= "omap4iss",
> +	},
> +};
> +
> +module_platform_driver(iss_driver);
> +
> +MODULE_DESCRIPTION("TI OMAP4 ISS driver");
> +MODULE_AUTHOR("Sergio Aguirre <sergio.a.aguirre@gmail.com>");
> +MODULE_LICENSE("GPL");
> +MODULE_VERSION(ISS_VIDEO_DRIVER_VERSION);

...

> diff --git a/include/media/omap4iss.h b/include/media/omap4iss.h
> new file mode 100644
> index 0000000..0d7620d
> --- /dev/null
> +++ b/include/media/omap4iss.h
> @@ -0,0 +1,65 @@

There's no copyright notice in this file. Is it intentional? I don't demand
it; just wondering. :)

> +#ifndef ARCH_ARM_PLAT_OMAP4_ISS_H
> +#define ARCH_ARM_PLAT_OMAP4_ISS_H
> +
> +#include <linux/i2c.h>
> +
> +struct iss_device;
> +
> +enum iss_interface_type {
> +	ISS_INTERFACE_CSI2A_PHY1,
> +	ISS_INTERFACE_CSI2B_PHY2,
> +};
> +
> +/**
> + * struct iss_csiphy_lane: CSI2 lane position and polarity
> + * @pos: position of the lane
> + * @pol: polarity of the lane
> + */
> +struct iss_csiphy_lane {
> +	u8 pos;
> +	u8 pol;
> +};
> +
> +#define ISS_CSIPHY1_NUM_DATA_LANES	4
> +#define ISS_CSIPHY2_NUM_DATA_LANES	1
> +
> +/**
> + * struct iss_csiphy_lanes_cfg - CSI2 lane configuration
> + * @data: Configuration of one or two data lanes
> + * @clk: Clock lane configuration
> + */
> +struct iss_csiphy_lanes_cfg {
> +	struct iss_csiphy_lane data[ISS_CSIPHY1_NUM_DATA_LANES];
> +	struct iss_csiphy_lane clk;
> +};
> +
> +/**
> + * struct iss_csi2_platform_data - CSI2 interface platform data
> + * @crc: Enable the cyclic redundancy check
> + * @vpclk_div: Video port output clock control
> + */
> +struct iss_csi2_platform_data {
> +	unsigned crc:1;
> +	unsigned vpclk_div:2;
> +	struct iss_csiphy_lanes_cfg lanecfg;
> +};
> +
> +struct iss_subdev_i2c_board_info {
> +	struct i2c_board_info *board_info;
> +	int i2c_adapter_id;
> +};
> +
> +struct iss_v4l2_subdevs_group {
> +	struct iss_subdev_i2c_board_info *subdevs;
> +	enum iss_interface_type interface;
> +	union {
> +		struct iss_csi2_platform_data csi2;
> +	} bus; /* gcc < 4.6.0 chokes on anonymous union initializers */
> +};
> +
> +struct iss_platform_data {
> +	struct iss_v4l2_subdevs_group *subdevs;
> +	void (*set_constraints)(struct iss_device *iss, bool enable);
> +};
> +
> +#endif
> -- 
> 1.8.1.5
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

-- 
Kind regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
