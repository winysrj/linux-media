Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud7.xs4all.net ([194.109.24.28]:44209 "EHLO
        lb2-smtp-cloud7.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S933162AbdIYKqh (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 25 Sep 2017 06:46:37 -0400
Subject: Re: [PATCH v6 23/25] rcar-vin: extend {start,stop}_streaming to work
 with media controller
To: =?UTF-8?Q?Niklas_S=c3=b6derlund?=
        <niklas.soderlund+renesas@ragnatech.se>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>
References: <20170822232640.26147-1-niklas.soderlund+renesas@ragnatech.se>
 <20170822232640.26147-24-niklas.soderlund+renesas@ragnatech.se>
Cc: Kieran Bingham <kieran.bingham@ideasonboard.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        tomoharu.fukawa.eb@renesas.com, linux-media@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <5c18e228-ac44-8b18-4ae5-0c6939b83201@xs4all.nl>
Date: Mon, 25 Sep 2017 12:46:34 +0200
MIME-Version: 1.0
In-Reply-To: <20170822232640.26147-24-niklas.soderlund+renesas@ragnatech.se>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 23/08/17 01:26, Niklas Söderlund wrote:
> The procedure to start or stop streaming using the none MC single

none MC -> non-MC

> subdevice and the MC graph and multiple subdevices are quiet different.

quiet -> quite

> Create a new function to abstract which method is used based on which
> mode the driver is running in and add logic to start the MC graph.
> 
> Signed-off-by: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>
> ---
>  drivers/media/platform/rcar-vin/rcar-dma.c | 112 +++++++++++++++++++++++++++--
>  1 file changed, 105 insertions(+), 7 deletions(-)
> 
> diff --git a/drivers/media/platform/rcar-vin/rcar-dma.c b/drivers/media/platform/rcar-vin/rcar-dma.c
> index de1486ee2786b499..499253f94390f43e 100644
> --- a/drivers/media/platform/rcar-vin/rcar-dma.c
> +++ b/drivers/media/platform/rcar-vin/rcar-dma.c
> @@ -1087,15 +1087,115 @@ static void rvin_buffer_queue(struct vb2_buffer *vb)
>  	spin_unlock_irqrestore(&vin->qlock, flags);
>  }
>  
> +static int rvin_set_stream(struct rvin_dev *vin, int on)
> +{
> +	struct v4l2_subdev_format fmt = {
> +		.which = V4L2_SUBDEV_FORMAT_ACTIVE,
> +	};
> +	struct media_pipeline *pipe;
> +	struct  v4l2_subdev *sd;
> +	struct media_pad *pad;
> +	int ret;
> +
> +	/* Not media controller used, simply pass operation to subdevice */
> +	if (!vin->info->use_mc) {
> +		ret = v4l2_subdev_call(vin->digital.subdev, video, s_stream,
> +				       on);
> +
> +		return ret == -ENOIOCTLCMD ? 0 : ret;
> +	}
> +
> +	pad = media_entity_remote_pad(&vin->pad);
> +	if (!pad)
> +		return -EPIPE;
> +
> +	sd = media_entity_to_v4l2_subdev(pad->entity);
> +	if (!sd)
> +		return -EPIPE;
> +
> +	if (on) {

Handle !on first and return.

The remaining code then has one indent level less.

> +		fmt.pad = pad->index;
> +		if (v4l2_subdev_call(sd, pad, get_fmt, NULL, &fmt))
> +			return -EPIPE;
> +
> +		switch (fmt.format.code) {
> +		case MEDIA_BUS_FMT_YUYV8_1X16:
> +		case MEDIA_BUS_FMT_UYVY8_2X8:
> +		case MEDIA_BUS_FMT_UYVY10_2X10:
> +		case MEDIA_BUS_FMT_RGB888_1X24:
> +			vin->code = fmt.format.code;
> +			break;
> +		default:
> +			return -EPIPE;
> +		}
> +
> +		switch (fmt.format.field) {
> +		case V4L2_FIELD_TOP:
> +		case V4L2_FIELD_BOTTOM:
> +		case V4L2_FIELD_NONE:
> +		case V4L2_FIELD_INTERLACED_TB:
> +		case V4L2_FIELD_INTERLACED_BT:
> +		case V4L2_FIELD_INTERLACED:
> +		case V4L2_FIELD_SEQ_TB:
> +		case V4L2_FIELD_SEQ_BT:
> +			/* Supported nativly */
> +			break;
> +		case V4L2_FIELD_ALTERNATE:
> +			switch (vin->format.field) {
> +			case V4L2_FIELD_TOP:
> +			case V4L2_FIELD_BOTTOM:
> +			case V4L2_FIELD_NONE:
> +				break;
> +			case V4L2_FIELD_INTERLACED_TB:
> +			case V4L2_FIELD_INTERLACED_BT:
> +			case V4L2_FIELD_INTERLACED:
> +			case V4L2_FIELD_SEQ_TB:
> +			case V4L2_FIELD_SEQ_BT:
> +				/* Use VIN hardware to combine the two fields */
> +				fmt.format.height *= 2;
> +				break;
> +			default:
> +				return -EPIPE;
> +			}
> +			break;
> +		default:
> +			return -EPIPE;
> +		}
> +
> +		if (fmt.format.width != vin->format.width ||
> +		    fmt.format.height != vin->format.height)
> +			return -EPIPE;
> +
> +		pipe = sd->entity.pipe ? sd->entity.pipe : &vin->vdev.pipe;
> +		if (media_pipeline_start(&vin->vdev.entity, pipe))
> +			return -EPIPE;
> +
> +		ret = v4l2_subdev_call(sd, video, s_stream, 1);
> +		if (ret == -ENOIOCTLCMD)
> +			ret = 0;
> +		if (ret)
> +			media_pipeline_stop(&vin->vdev.entity);
> +	} else {
> +		media_pipeline_stop(&vin->vdev.entity);
> +		ret = v4l2_subdev_call(sd, video, s_stream, 0);
> +	}
> +
> +	return ret;
> +}
> +
>  static int rvin_start_streaming(struct vb2_queue *vq, unsigned int count)
>  {
>  	struct rvin_dev *vin = vb2_get_drv_priv(vq);
> -	struct v4l2_subdev *sd;
>  	unsigned long flags;
>  	int ret;
>  
> -	sd = vin_to_source(vin);
> -	v4l2_subdev_call(sd, video, s_stream, 1);
> +	ret = rvin_set_stream(vin, 1);
> +	if (ret) {
> +		spin_lock_irqsave(&vin->qlock, flags);
> +		return_all_buffers(vin, VB2_BUF_STATE_QUEUED);
> +		spin_unlock_irqrestore(&vin->qlock, flags);
> +		return ret;
> +	}
>  
>  	spin_lock_irqsave(&vin->qlock, flags);
>  
> @@ -1104,7 +1204,7 @@ static int rvin_start_streaming(struct vb2_queue *vq, unsigned int count)
>  	ret = rvin_capture_start(vin);
>  	if (ret) {
>  		return_all_buffers(vin, VB2_BUF_STATE_QUEUED);
> -		v4l2_subdev_call(sd, video, s_stream, 0);
> +		rvin_set_stream(vin, 0);
>  	}
>  
>  	spin_unlock_irqrestore(&vin->qlock, flags);
> @@ -1115,7 +1215,6 @@ static int rvin_start_streaming(struct vb2_queue *vq, unsigned int count)
>  static void rvin_stop_streaming(struct vb2_queue *vq)
>  {
>  	struct rvin_dev *vin = vb2_get_drv_priv(vq);
> -	struct v4l2_subdev *sd;
>  	unsigned long flags;
>  	int retries = 0;
>  
> @@ -1154,8 +1253,7 @@ static void rvin_stop_streaming(struct vb2_queue *vq)
>  
>  	spin_unlock_irqrestore(&vin->qlock, flags);
>  
> -	sd = vin_to_source(vin);
> -	v4l2_subdev_call(sd, video, s_stream, 0);
> +	rvin_set_stream(vin, 0);
>  
>  	/* disable interrupts */
>  	rvin_disable_interrupts(vin);
> 

Regards,

	Hans
