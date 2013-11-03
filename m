Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:48212 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750764Ab3KCXnQ (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 3 Nov 2013 18:43:16 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Sakari Ailus <sakari.ailus@iki.fi>
Cc: devel@driverdev.osuosl.org, linux-media@vger.kernel.org,
	Sergio Aguirre <sergio.a.aguirre@gmail.com>
Subject: Re: [PATCH 1/6] v4l: omap4iss: Add support for OMAP4 camera interface - Core
Date: Mon, 04 Nov 2013 00:43:43 +0100
Message-ID: <8140877.kkhDdsEguL@avalon>
In-Reply-To: <20131005214928.GN3022@valkosipuli.retiisi.org.uk>
References: <1380758133-16866-1-git-send-email-laurent.pinchart@ideasonboard.com> <1380758133-16866-2-git-send-email-laurent.pinchart@ideasonboard.com> <20131005214928.GN3022@valkosipuli.retiisi.org.uk>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sakari,

Thank you for the review.

On Sunday 06 October 2013 00:49:28 Sakari Ailus wrote:
> Hi Laurent,
> 
> Thanks for the patch! Some comments below.
> 
> On Thu, Oct 03, 2013 at 01:55:28AM +0200, Laurent Pinchart wrote:
> ...
> 
> > +int omap4iss_get_external_info(struct iss_pipeline *pipe,
> > +			       struct media_link *link)
> > +{
> > +	struct iss_device *iss =
> > +		container_of(pipe, struct iss_video, pipe)->iss;
> > +	struct v4l2_subdev_format fmt;
> > +	struct v4l2_ext_controls ctrls;
> > +	struct v4l2_ext_control ctrl;
> > +	int ret;
> > +
> > +	if (!pipe->external)
> > +		return 0;
> > +
> > +	if (pipe->external_rate)
> > +		return 0;
> > +
> > +	memset(&fmt, 0, sizeof(fmt));
> > +
> > +	fmt.pad = link->source->index;
> > +	fmt.which = V4L2_SUBDEV_FORMAT_ACTIVE;
> > +	ret = v4l2_subdev_call(media_entity_to_v4l2_subdev(link->sink-
>entity),
> > +			       pad, get_fmt, NULL, &fmt);
> > +	if (ret < 0)
> > +		return -EPIPE;
> > +
> > +	pipe->external_bpp = omap4iss_video_format_info(fmt.format.code)-
>bpp;
> > +
> > +	memset(&ctrls, 0, sizeof(ctrls));
> > +	memset(&ctrl, 0, sizeof(ctrl));
> > +
> 
> As a general note, you can replace memsets of local structs and arrays by
> assingning them as {0}. No need to worry about size for instance.

Good point. That code is going away though :-)

> > +	ctrl.id = V4L2_CID_PIXEL_RATE;
> > +
> > +	ctrls.ctrl_class = V4L2_CTRL_ID2CLASS(ctrl.id);
> > +	ctrls.count = 1;
> > +	ctrls.controls = &ctrl;
> > +
> > +	ret = v4l2_g_ext_ctrls(pipe->external->ctrl_handler, &ctrls);
> > +	if (ret < 0) {
> > +		dev_warn(iss->dev, "no pixel rate control in subdev %s\n",
> > +			 pipe->external->name);
> > +		return ret;
> > +	}
> > +
> > +	pipe->external_rate = ctrl.value64;
> > +
> > +	return 0;
> > +}
> > +
> > +/*
> > + * Configure the bridge. Valid inputs are
> > + *
> > + * IPIPEIF_INPUT_CSI2A: CSI2a receiver
> > + * IPIPEIF_INPUT_CSI2B: CSI2b receiver
> > + *
> > + * The bridge and lane shifter are configured according to the selected
> > input + * and the ISP platform data.
> > + */
> > +void omap4iss_configure_bridge(struct iss_device *iss,
> > +			       enum ipipeif_input_entity input)
> > +{
> > +	u32 issctrl_val;
> > +	u32 isp5ctrl_val;
> > +
> > +	issctrl_val  = readl(iss->regs[OMAP4_ISS_MEM_TOP] + ISS_CTRL);
> > +	issctrl_val &= ~ISS_CTRL_INPUT_SEL_MASK;
> > +	issctrl_val &= ~ISS_CTRL_CLK_DIV_MASK;
> > +
> > +	isp5ctrl_val  = readl(iss->regs[OMAP4_ISS_MEM_ISP_SYS1] + ISP5_CTRL);
> > +
> > +	switch (input) {
> > +	case IPIPEIF_INPUT_CSI2A:
> > +		issctrl_val |= ISS_CTRL_INPUT_SEL_CSI2A;
> > +		isp5ctrl_val |= ISP5_CTRL_VD_PULSE_EXT;
> > +		break;
> > +
> > +	case IPIPEIF_INPUT_CSI2B:
> > +		issctrl_val |= ISS_CTRL_INPUT_SEL_CSI2B;
> > +		isp5ctrl_val |= ISP5_CTRL_VD_PULSE_EXT;
> 
> This assignment is independent of the case. You could do that a little later
> just once.

I'll fix that.

> > +		break;
> > +
> > +	default:
> > +		return;
> 
> Isn't this an error?

This should never happen, it would be a driver bug. If the input isn't 
configured the pipeline isn't valid, which should be caught when starting the 
stream before calling this function.

> > +	}
> > +
> > +	issctrl_val |= ISS_CTRL_SYNC_DETECT_VS_RAISING;
> > +
> > +	isp5ctrl_val |= ISP5_CTRL_PSYNC_CLK_SEL | ISP5_CTRL_SYNC_ENABLE;
> > +
> > +	writel(issctrl_val, iss->regs[OMAP4_ISS_MEM_TOP] + ISS_CTRL);
> > +	writel(isp5ctrl_val, iss->regs[OMAP4_ISS_MEM_ISP_SYS1] + ISP5_CTRL);
> > +}
> 
> ...
> 
> > +
> > +/*
> > + * iss_pipeline_enable - Enable streaming on a pipeline
> > + * @pipe: ISS pipeline
> > + * @mode: Stream mode (single shot or continuous)
> > + *
> > + * Walk the entities chain starting at the pipeline output video node and
> > start + * all modules in the chain in the given mode.
> > + *
> > + * Return 0 if successful, or the return value of the failed
> > video::s_stream + * operation otherwise.
> > + */
> > +static int iss_pipeline_enable(struct iss_pipeline *pipe,
> > +			       enum iss_pipeline_stream_state mode)
> > +{
> > +	struct media_entity *entity;
> > +	struct media_pad *pad;
> > +	struct v4l2_subdev *subdev;
> > +	unsigned long flags;
> > +	int ret;
> > +
> > +	spin_lock_irqsave(&pipe->lock, flags);
> > +	pipe->state &= ~(ISS_PIPELINE_IDLE_INPUT | ISS_PIPELINE_IDLE_OUTPUT);
> > +	spin_unlock_irqrestore(&pipe->lock, flags);
> > +
> > +	pipe->do_propagation = false;
> > +
> > +	entity = &pipe->output->video.entity;
> > +	while (1) {
> > +		pad = &entity->pads[0];
> > +		if (!(pad->flags & MEDIA_PAD_FL_SINK))
> > +			break;
> > +
> > +		pad = media_entity_remote_pad(pad);
> > +		if (pad == NULL ||
> > +		    media_entity_type(pad->entity) != MEDIA_ENT_T_V4L2_SUBDEV)
> > +			break;
> > +
> > +		entity = pad->entity;
> > +		subdev = media_entity_to_v4l2_subdev(entity);
> > +
> > +		ret = v4l2_subdev_call(subdev, video, s_stream, mode);
> > +		if (ret < 0 && ret != -ENOIOCTLCMD)
> > +			return ret;
> 
> This loop looks very similar to that in the omap3isp driver.
> 
> It'd be nice to do this in a generic way. Something to think about in the
> future perhaps. This is still queite easy; it gets somewhat more difficult
> once the pipeline isn't linear.

That's a good idea. I'll check whether we have other common needs.

> > +	}
> > +	iss_print_status(pipe->output->iss);
> > +	return 0;
> > +}
> > +
> > +/*
> > + * iss_pipeline_disable - Disable streaming on a pipeline
> > + * @pipe: ISS pipeline
> > + *
> > + * Walk the entities chain starting at the pipeline output video node and
> > stop + * all modules in the chain. Wait synchronously for the modules to
> > be stopped if + * necessary.
> > + */
> > +static int iss_pipeline_disable(struct iss_pipeline *pipe)
> > +{
> > +	struct media_entity *entity;
> > +	struct media_pad *pad;
> > +	struct v4l2_subdev *subdev;
> > +	int failure = 0;
> > +
> > +	entity = &pipe->output->video.entity;
> > +	while (1) {
> > +		pad = &entity->pads[0];
> > +		if (!(pad->flags & MEDIA_PAD_FL_SINK))
> > +			break;
> > +
> > +		pad = media_entity_remote_pad(pad);
> > +		if (pad == NULL ||
> > +		    media_entity_type(pad->entity) != MEDIA_ENT_T_V4L2_SUBDEV)
> > +			break;
> > +
> > +		entity = pad->entity;
> > +		subdev = media_entity_to_v4l2_subdev(entity);
> > +
> > +		v4l2_subdev_call(subdev, video, s_stream, 0);
> 
> What would you think about combining the loop with enabling the pipeline?
> The only difference is that you're disabling streaming here, not enabling
> it, and no error handling is done either. Just and idea.

I'll try this when factorizing common code between the omap3isp and omap4iss 
drivers.

> > +	}
> > +
> > +	return failure;
> 
> You always return zero here.

I'll fix that.

> > +}

[snip]

> > +/*
> > + * iss_pipeline_is_last - Verify if entity has an enabled link to the
> > output + *			  video node
> > + * @me: ISS module's media entity
> > + *
> > + * Returns 1 if the entity has an enabled link to the output video node
> > or 0 + * otherwise. It's true only while pipeline can have no more than
> > one output + * node.
> > + */
> > +static int iss_pipeline_is_last(struct media_entity *me)
> > +{
> > +	struct iss_pipeline *pipe;
> > +	struct media_pad *pad;
> > +
> > +	if (!me->pipe)
> > +		return 0;
> > +	pipe = to_iss_pipeline(me);
> > +	if (pipe->stream_state == ISS_PIPELINE_STREAM_STOPPED)
> > +		return 0;
> > +	pad = media_entity_remote_pad(&pipe->output->pad);
> > +	return pad->entity == me;
> > +}
> > +
> > +static int iss_reset(struct iss_device *iss)
> > +{
> > +	unsigned long timeout = 0;
> > +
> > +	writel(readl(iss->regs[OMAP4_ISS_MEM_TOP] + ISS_HL_SYSCONFIG) |
> > +		ISS_HL_SYSCONFIG_SOFTRESET,
> > +		iss->regs[OMAP4_ISS_MEM_TOP] + ISS_HL_SYSCONFIG);
> > +
> > +	while (readl(iss->regs[OMAP4_ISS_MEM_TOP] + ISS_HL_SYSCONFIG) &
> > +			ISS_HL_SYSCONFIG_SOFTRESET) {
> > +		if (timeout++ > 10000) {
> > +			dev_alert(iss->dev, "cannot reset ISS\n");
> > +			return -ETIMEDOUT;
> > +		}
> > +		udelay(1);
> 
> You only seem to do this in probe. How about e.g. usleep_range(10, 10) and
> timeout of 1000?

Good point, I'll fix that.
> 
> > +	}
> > +
> > +	return 0;
> > +}
> > +
> > +static int iss_isp_reset(struct iss_device *iss)
> > +{
> > +	unsigned long timeout = 0;
> > +
> > +	/* Fist, ensure that the ISP is IDLE (no transactions happening) */
> > +	writel((readl(iss->regs[OMAP4_ISS_MEM_ISP_SYS1] + ISP5_SYSCONFIG) &
> > +		~ISP5_SYSCONFIG_STANDBYMODE_MASK) |
> > +		ISP5_SYSCONFIG_STANDBYMODE_SMART,
> > +		iss->regs[OMAP4_ISS_MEM_ISP_SYS1] + ISP5_SYSCONFIG);
> > +
> > +	writel(readl(iss->regs[OMAP4_ISS_MEM_ISP_SYS1] + ISP5_CTRL) |
> > +		ISP5_CTRL_MSTANDBY,
> > +		iss->regs[OMAP4_ISS_MEM_ISP_SYS1] + ISP5_CTRL);
> > +
> > +	for (;;) {
> > +		if (readl(iss->regs[OMAP4_ISS_MEM_ISP_SYS1] + ISP5_CTRL) &
> > +				ISP5_CTRL_MSTANDBY_WAIT)
> > +			break;
> > +		if (timeout++ > 1000) {
> > +			dev_alert(iss->dev, "cannot set ISP5 to standby\n");
> > +			return -ETIMEDOUT;
> > +		}
> > +		msleep(1);
> 
> Is this time critical in any way? msleep(1) may end up sleeping quite a lot
> longer. I propose usleep_range().

I'll fix that.

> > +	}
> > +
> > +	/* Now finally, do the reset */
> > +	writel(readl(iss->regs[OMAP4_ISS_MEM_ISP_SYS1] + ISP5_SYSCONFIG) |
> > +		ISP5_SYSCONFIG_SOFTRESET,
> > +		iss->regs[OMAP4_ISS_MEM_ISP_SYS1] + ISP5_SYSCONFIG);
> > +
> > +	timeout = 0;
> > +	while (readl(iss->regs[OMAP4_ISS_MEM_ISP_SYS1] + ISP5_SYSCONFIG) &
> > +			ISP5_SYSCONFIG_SOFTRESET) {
> > +		if (timeout++ > 1000) {
> > +			dev_alert(iss->dev, "cannot reset ISP5\n");
> > +			return -ETIMEDOUT;
> > +		}
> > +		msleep(1);
> 
> Wow. :) Remember msleep() is usually notoriously imprecise, too. E.g.
> CONFIG_HZ at 100 could mean msleep(1) sleeps up to 20 ms, and 1000 that can
> be up to 20 seconds. Is this intended?

I doubt it :-)

> > +	}
> > +
> > +	return 0;
> > +}

[snip]

> > diff --git a/include/media/omap4iss.h b/include/media/omap4iss.h
> > new file mode 100644
> > index 0000000..0d7620d
> > --- /dev/null
> > +++ b/include/media/omap4iss.h
> > @@ -0,0 +1,65 @@
> 
> There's no copyright notice in this file. Is it intentional? I don't demand
> it; just wondering. :)

It's not my code so I don't know :-)

> > +#ifndef ARCH_ARM_PLAT_OMAP4_ISS_H
> > +#define ARCH_ARM_PLAT_OMAP4_ISS_H
> > +
> > +#include <linux/i2c.h>
> > +
> > +struct iss_device;
> > +
> > +enum iss_interface_type {
> > +	ISS_INTERFACE_CSI2A_PHY1,
> > +	ISS_INTERFACE_CSI2B_PHY2,
> > +};
> > +
> > +/**
> > + * struct iss_csiphy_lane: CSI2 lane position and polarity
> > + * @pos: position of the lane
> > + * @pol: polarity of the lane
> > + */
> > +struct iss_csiphy_lane {
> > +	u8 pos;
> > +	u8 pol;
> > +};
> > +
> > +#define ISS_CSIPHY1_NUM_DATA_LANES	4
> > +#define ISS_CSIPHY2_NUM_DATA_LANES	1
> > +
> > +/**
> > + * struct iss_csiphy_lanes_cfg - CSI2 lane configuration
> > + * @data: Configuration of one or two data lanes
> > + * @clk: Clock lane configuration
> > + */
> > +struct iss_csiphy_lanes_cfg {
> > +	struct iss_csiphy_lane data[ISS_CSIPHY1_NUM_DATA_LANES];
> > +	struct iss_csiphy_lane clk;
> > +};
> > +
> > +/**
> > + * struct iss_csi2_platform_data - CSI2 interface platform data
> > + * @crc: Enable the cyclic redundancy check
> > + * @vpclk_div: Video port output clock control
> > + */
> > +struct iss_csi2_platform_data {
> > +	unsigned crc:1;
> > +	unsigned vpclk_div:2;
> > +	struct iss_csiphy_lanes_cfg lanecfg;
> > +};
> > +
> > +struct iss_subdev_i2c_board_info {
> > +	struct i2c_board_info *board_info;
> > +	int i2c_adapter_id;
> > +};
> > +
> > +struct iss_v4l2_subdevs_group {
> > +	struct iss_subdev_i2c_board_info *subdevs;
> > +	enum iss_interface_type interface;
> > +	union {
> > +		struct iss_csi2_platform_data csi2;
> > +	} bus; /* gcc < 4.6.0 chokes on anonymous union initializers */
> > +};
> > +
> > +struct iss_platform_data {
> > +	struct iss_v4l2_subdevs_group *subdevs;
> > +	void (*set_constraints)(struct iss_device *iss, bool enable);
> > +};
> > +
> > +#endif
-- 
Regards,

Laurent Pinchart

