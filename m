Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:50087 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751275AbcFPO4c convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 16 Jun 2016 10:56:32 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Niklas =?ISO-8859-1?Q?S=F6derlund?=
	<niklas.soderlund@ragnatech.se>
Cc: linux-media@vger.kernel.org, ulrich.hecht@gmail.com,
	hverkuil@xs4all.nl, linux-renesas-soc@vger.kernel.org,
	Ulrich Hecht <ulrich.hecht+renesas@gmail.com>,
	William Towle <william.towle@codethink.co.uk>,
	Rob Taylor <rob.taylor@codethink.co.uk>,
	Niklas =?ISO-8859-1?Q?S=F6derlund?=
	<niklas.soderlund+renesas@ragnatech.se>
Subject: Re: [PATCH 1/8] media: rcar-vin: pad-aware driver initialisation
Date: Thu, 16 Jun 2016 17:56:41 +0300
Message-ID: <1642916.YUlojpEMv4@avalon>
In-Reply-To: <1464203409-1279-2-git-send-email-niklas.soderlund@ragnatech.se>
References: <1464203409-1279-1-git-send-email-niklas.soderlund@ragnatech.se> <1464203409-1279-2-git-send-email-niklas.soderlund@ragnatech.se>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset="iso-8859-1"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello Niklas,

Thank you for the patch.

On Wednesday 25 May 2016 21:10:02 Niklas S�derlund wrote:
> From: Ulrich Hecht <ulrich.hecht+renesas@gmail.com>
> 
> Add detection of source pad number for drivers aware of the media controller
> API, so that rcar-vin can create device nodes to support modern drivers
> such as adv7604.c (for HDMI on Lager) and the converted adv7180.c (for
> composite) underneath.
> 
> Building rcar_vin gains a dependency on CONFIG_MEDIA_CONTROLLER, in
> line with requirements for building the drivers associated with it.
> 
> Signed-off-by: William Towle <william.towle@codethink.co.uk>
> Signed-off-by: Rob Taylor <rob.taylor@codethink.co.uk>
> [uli: adapted to rcar-vin rewrite]
> Signed-off-by: Ulrich Hecht <ulrich.hecht+renesas@gmail.com>
> Signed-off-by: Niklas S�derlund <niklas.soderlund+renesas@ragnatech.se>
> ---
>  drivers/media/platform/rcar-vin/rcar-v4l2.c | 16 ++++++++++++++++
>  drivers/media/platform/rcar-vin/rcar-vin.h  |  2 ++
>  2 files changed, 18 insertions(+)
> 
> diff --git a/drivers/media/platform/rcar-vin/rcar-v4l2.c
> b/drivers/media/platform/rcar-vin/rcar-v4l2.c index 0bc4487..929816b 100644
> --- a/drivers/media/platform/rcar-vin/rcar-v4l2.c
> +++ b/drivers/media/platform/rcar-vin/rcar-v4l2.c
> @@ -683,6 +683,9 @@ int rvin_v4l2_probe(struct rvin_dev *vin)
>  	struct v4l2_mbus_framefmt *mf = &fmt.format;
>  	struct video_device *vdev = &vin->vdev;
>  	struct v4l2_subdev *sd = vin_to_source(vin);
> +#if defined(CONFIG_MEDIA_CONTROLLER)

I think you can get rid of conditional compilation here and below. Patch 2/8 
calls v4l2_subdev_alloc_pad_config() unconditionally, which depends on 
CONFIG_MEDIA_CONTROLLER.

> +	int pad_idx;
> +#endif
>  	int ret;
> 
>  	v4l2_set_subdev_hostdata(sd, vin);
> @@ -729,6 +732,19 @@ int rvin_v4l2_probe(struct rvin_dev *vin)
>  	vdev->device_caps = V4L2_CAP_VIDEO_CAPTURE | V4L2_CAP_STREAMING |
>  		V4L2_CAP_READWRITE;
> 
> +	vin->src_pad_idx = 0;
> +#if defined(CONFIG_MEDIA_CONTROLLER)
> +	for (pad_idx = 0; pad_idx < sd->entity.num_pads; pad_idx++)
> +		if (sd->entity.pads[pad_idx].flags
> +				== MEDIA_PAD_FL_SOURCE)

No need for a line break.

> +			break;
> +	if (pad_idx >= sd->entity.num_pads)
> +		return -EINVAL;
> +
> +	vin->src_pad_idx = pad_idx;
> +#endif
> +	fmt.pad = vin->src_pad_idx;
> +
>  	/* Try to improve our guess of a reasonable window format */
>  	ret = v4l2_subdev_call(sd, pad, get_fmt, NULL, &fmt);
>  	if (ret) {
> diff --git a/drivers/media/platform/rcar-vin/rcar-vin.h
> b/drivers/media/platform/rcar-vin/rcar-vin.h index 544a3b3..a6dd6db 100644
> --- a/drivers/media/platform/rcar-vin/rcar-vin.h
> +++ b/drivers/media/platform/rcar-vin/rcar-vin.h
> @@ -87,6 +87,7 @@ struct rvin_graph_entity {
>   *
>   * @vdev:		V4L2 video device associated with VIN
>   * @v4l2_dev:		V4L2 device
> + * @src_pad_idx:	source pad index for media controller drivers
>   * @ctrl_handler:	V4L2 control handler
>   * @notifier:		V4L2 asynchronous subdevs notifier
>   * @entity:		entity in the DT for subdevice
> @@ -117,6 +118,7 @@ struct rvin_dev {
> 
>  	struct video_device vdev;
>  	struct v4l2_device v4l2_dev;
> +	int src_pad_idx;
>  	struct v4l2_ctrl_handler ctrl_handler;
>  	struct v4l2_async_notifier notifier;
>  	struct rvin_graph_entity entity;

-- 
Regards,

Laurent Pinchart

