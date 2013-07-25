Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:59576 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755647Ab3GYLqA (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 25 Jul 2013 07:46:00 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Sakari Ailus <sakari.ailus@iki.fi>
Cc: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
	linux-media@vger.kernel.org, linux-sh@vger.kernel.org,
	Hans Verkuil <hverkuil@xs4all.nl>
Subject: Re: [PATCH v2 5/5] v4l: Renesas R-Car VSP1 driver
Date: Thu, 25 Jul 2013 13:46:54 +0200
Message-ID: <1833071.CAa8KOE02B@avalon>
In-Reply-To: <20130724224858.GG12281@valkosipuli.retiisi.org.uk>
References: <1374072882-14598-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com> <1374072882-14598-6-git-send-email-laurent.pinchart+renesas@ideasonboard.com> <20130724224858.GG12281@valkosipuli.retiisi.org.uk>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sakari,

On Thursday 25 July 2013 01:48:58 Sakari Ailus wrote:
> Hi Laurent,
> 
> What a nice driver! A few minor comments below:

Thank you :-)

> On Wed, Jul 17, 2013 at 04:54:42PM +0200, Laurent Pinchart wrote:
> ...
> 
> > +static void vsp1_device_init(struct vsp1_device *vsp1)
> > +{
> > +	unsigned int i;
> > +	u32 status;
> > +
> > +	/* Reset any channel that might be running. */
> > +	status = vsp1_read(vsp1, VI6_STATUS);
> > +
> > +	for (i = 0; i < VPS1_MAX_WPF; ++i) {
> > +		unsigned int timeout;
> > +
> > +		if (!(status & VI6_STATUS_SYS_ACT(i)))
> > +			continue;
> > +
> > +		vsp1_write(vsp1, VI6_SRESET, VI6_SRESET_SRTS(i));
> > +		for (timeout = 10; timeout > 0; --timeout) {
> > +			status = vsp1_read(vsp1, VI6_STATUS);
> > +			if (!(status & VI6_STATUS_SYS_ACT(i)))
> > +				break;
> > +
> > +			usleep_range(1000, 2000);
> > +		}
> > +
> > +		if (timeout)
> > +			dev_err(vsp1->dev, "failed to reset wpf.%u\n", i);
> 
> Have you seen this happening in practice? Do you expect the device to
> function if resetting it fails?

I've seen this happening during development when I had messed up register 
values, but not otherwise. I don't expect the deviec to still function if 
resetting the WPF fails, but I need to make sure that the busy loop exits.

> > +	}
> > +
> > +	vsp1_write(vsp1, VI6_CLK_DCSWT, (8 << VI6_CLK_DCSWT_CSTPW_SHIFT) |
> > +		   (8 << VI6_CLK_DCSWT_CSTRW_SHIFT));
> > +
> > +	for (i = 0; i < VPS1_MAX_RPF; ++i)
> > +		vsp1_write(vsp1, VI6_DPR_RPF_ROUTE(i), VI6_DPR_NODE_UNUSED);
> > +
> > +	for (i = 0; i < VPS1_MAX_UDS; ++i)
> > +		vsp1_write(vsp1, VI6_DPR_UDS_ROUTE(i), VI6_DPR_NODE_UNUSED);
> > +
> > +	vsp1_write(vsp1, VI6_DPR_SRU_ROUTE, VI6_DPR_NODE_UNUSED);
> > +	vsp1_write(vsp1, VI6_DPR_LUT_ROUTE, VI6_DPR_NODE_UNUSED);
> > +	vsp1_write(vsp1, VI6_DPR_CLU_ROUTE, VI6_DPR_NODE_UNUSED);
> > +	vsp1_write(vsp1, VI6_DPR_HST_ROUTE, VI6_DPR_NODE_UNUSED);
> > +	vsp1_write(vsp1, VI6_DPR_HSI_ROUTE, VI6_DPR_NODE_UNUSED);
> > +	vsp1_write(vsp1, VI6_DPR_BRU_ROUTE, VI6_DPR_NODE_UNUSED);
> > +
> > +	vsp1_write(vsp1, VI6_DPR_HGO_SMPPT, (7 << VI6_DPR_SMPPT_TGW_SHIFT) |
> > +		   (VI6_DPR_NODE_UNUSED << VI6_DPR_SMPPT_PT_SHIFT));
> > +	vsp1_write(vsp1, VI6_DPR_HGT_SMPPT, (7 << VI6_DPR_SMPPT_TGW_SHIFT) |
> > +		   (VI6_DPR_NODE_UNUSED << VI6_DPR_SMPPT_PT_SHIFT));
> > +}
> 
> ...
> 
> > +int vsp1_entity_init(struct vsp1_device *vsp1, struct vsp1_entity
> > *entity,
> > +		     unsigned int num_pads)
> > +{
> > +	static const struct {
> > +		unsigned int id;
> > +		unsigned int reg;
> > +	} routes[] = {
> > +		{ VI6_DPR_NODE_LIF, 0 },
> > +		{ VI6_DPR_NODE_RPF(0), VI6_DPR_RPF_ROUTE(0) },
> > +		{ VI6_DPR_NODE_RPF(1), VI6_DPR_RPF_ROUTE(1) },
> > +		{ VI6_DPR_NODE_RPF(2), VI6_DPR_RPF_ROUTE(2) },
> > +		{ VI6_DPR_NODE_RPF(3), VI6_DPR_RPF_ROUTE(3) },
> > +		{ VI6_DPR_NODE_RPF(4), VI6_DPR_RPF_ROUTE(4) },
> > +		{ VI6_DPR_NODE_UDS(0), VI6_DPR_UDS_ROUTE(0) },
> > +		{ VI6_DPR_NODE_UDS(1), VI6_DPR_UDS_ROUTE(1) },
> > +		{ VI6_DPR_NODE_UDS(2), VI6_DPR_UDS_ROUTE(2) },
> > +		{ VI6_DPR_NODE_WPF(0), 0 },
> > +		{ VI6_DPR_NODE_WPF(1), 0 },
> > +		{ VI6_DPR_NODE_WPF(2), 0 },
> > +		{ VI6_DPR_NODE_WPF(3), 0 },
> > +	};
> > +
> > +	unsigned int i;
> > +	int ret;
> > +
> > +	for (i = 0; i < ARRAY_SIZE(routes); ++i) {
> > +		if (routes[i].id == entity->id) {
> > +			entity->route = routes[i].reg;
> > +			break;
> > +		}
> > +	}
> > +
> > +	if (i == ARRAY_SIZE(routes))
> > +		return -EINVAL;
> > +
> > +	entity->vsp1 = vsp1;
> > +	entity->source_pad = num_pads - 1;
> > +
> > +	/* Allocate formats and pads. */
> > +	entity->formats = devm_kzalloc(vsp1->dev,
> > +				       num_pads * sizeof(*entity->formats),
> > +				       GFP_KERNEL);
> > +	if (entity->formats == NULL)
> > +		return -ENOMEM;
> > +
> > +	entity->pads = devm_kzalloc(vsp1->dev, num_pads * sizeof(*entity-
>pads),
> > +				    GFP_KERNEL);
> > +	if (entity->pads == NULL)
> > +		return -ENOMEM;
> > +
> > +	/* Initialize pads. */
> > +	for (i = 0; i < num_pads - 1; ++i)
> > +		entity->pads[i].flags = MEDIA_PAD_FL_SINK;
> > +
> > +	entity->pads[num_pads - 1].flags = MEDIA_PAD_FL_SOURCE;
> > +
> > +	/* Initialize the media entity. */
> > +	ret = media_entity_init(&entity->subdev.entity, num_pads,
> > +				entity->pads, 0);
> 
> How about return media_entity_init(...) instead?

Will do.

> > +	if (ret < 0)
> > +		return ret;
> > +
> > +	return 0;
> > +}
> 
> ...
> 
> > +static int lif_enum_mbus_code(struct v4l2_subdev *subdev,
> > +			      struct v4l2_subdev_fh *fh,
> > +			      struct v4l2_subdev_mbus_code_enum *code)
> > +{
> > +	static const unsigned int codes[] = {
> > +		V4L2_MBUS_FMT_ARGB8888_1X32,
> > +		V4L2_MBUS_FMT_AYUV8_1X32,
> > +	};
> > +	struct v4l2_mbus_framefmt *format;
> > +
> > +	if (code->pad == LIF_PAD_SINK) {
> > +		if (code->index >= ARRAY_SIZE(codes))
> > +			return -EINVAL;
> > +
> > +		code->code = codes[code->index];
> > +	} else {
> > +		/* The LIF can't perform format conversion, the sink format is
> > +		 * always identical to the source format.
> > +		 */
> > +		if (code->index)
> > +			return -EINVAL;
> > +
> > +		format = v4l2_subdev_get_try_format(fh, LIF_PAD_SINK);
> > +		code->code = format->code;
> 
> You don't really need "format". If you want to use it however you could
> define it inside the parentheses.

Will do.

> > +	}
> > +
> > +	return 0;
> > +}
> 
> ...
> 
> > +static int uds_enum_mbus_code(struct v4l2_subdev *subdev,
> > +			      struct v4l2_subdev_fh *fh,
> > +			      struct v4l2_subdev_mbus_code_enum *code)
> > +{
> > +	static const unsigned int codes[] = {
> > +		V4L2_MBUS_FMT_ARGB8888_1X32,
> > +		V4L2_MBUS_FMT_AYUV8_1X32,
> > +	};
> > +	struct v4l2_mbus_framefmt *format;
> > +
> > +	if (code->pad == UDS_PAD_SINK) {
> > +		if (code->index >= ARRAY_SIZE(codes))
> > +			return -EINVAL;
> > +
> > +		code->code = codes[code->index];
> > +	} else {
> > +		/* The UDS can't perform format conversion, the sink format is
> > +		 * always identical to the source format.
> > +		 */
> > +		if (code->index)
> > +			return -EINVAL;
> > +
> > +		format = v4l2_subdev_get_try_format(fh, UDS_PAD_SINK);
> > +		code->code = format->code;
> 
> Same here.

Will do too.

> > +	}
> > +
> > +	return 0;
> > +}
> 
> ...
> 
> > +	/* Follow links downstream for each input and make sure the graph
> > +	 * contains no loop and that all branches end at the output WPF.
> > +	 */
> 
> I wonder if checking for loops should be done already in pipeline validation
> done by the framework. That's fine to do later on IMHO, too.

It would have to be performed by the core, as the callbacks are local to 
links. That's feasible (but should be optional, as some devices might support 
circular graphs), feel free to submit a patch :-)

> > +	for (i = 0; i < pipe->num_inputs; ++i) {
> > +		ret = vsp1_pipeline_validate_branch(pipe->inputs[i],
> > +						    pipe->output);
> > +		if (ret < 0)
> > +			goto error;
> > +	}
> > +
> > +	return 0;
> > +
> 
> ...
> 
> > +static void vsp1_video_buffer_queue(struct vb2_buffer *vb)
> > +{
> > +	struct vsp1_video *video = vb2_get_drv_priv(vb->vb2_queue);
> > +	struct vsp1_pipeline *pipe = to_vsp1_pipeline(&video->video.entity);
> > +	struct vsp1_video_buffer *buf = to_vsp1_video_buffer(vb);
> > +	unsigned long flags;
> > +	bool empty;
> > +
> > +	spin_lock_irqsave(&video->irqlock, flags);
> > +	empty = list_empty(&video->irqqueue);
> > +	list_add_tail(&buf->queue, &video->irqqueue);
> > +	spin_unlock_irqrestore(&video->irqlock, flags);
> > +
> > +	if (empty) {
> 
> if (!empty)
> 	return;
> 
> ?

Will do.

> Up to you.
> 
> > +		spin_lock_irqsave(&pipe->irqlock, flags);
> > +
> > +		video->ops->queue(video, buf);
> > +		pipe->buffers_ready |= 1 << video->pipe_index;
> > +
> > +		if (vb2_is_streaming(&video->queue) &&
> > +		    vsp1_pipeline_ready(pipe))
> > +			vsp1_pipeline_run(pipe);
> > +
> > +		spin_unlock_irqrestore(&pipe->irqlock, flags);
> > +	}
> > +}
-- 
Regards,

Laurent Pinchart

