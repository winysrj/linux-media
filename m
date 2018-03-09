Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud9.xs4all.net ([194.109.24.26]:47373 "EHLO
        lb2-smtp-cloud9.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751231AbeCIPr1 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 9 Mar 2018 10:47:27 -0500
Subject: Re: [PATCH v12 30/33] rcar-vin: extend {start,stop}_streaming to work
 with media controller
To: =?UTF-8?Q?Niklas_S=c3=b6derlund?=
        <niklas.soderlund+renesas@ragnatech.se>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        linux-media@vger.kernel.org
Cc: linux-renesas-soc@vger.kernel.org, tomoharu.fukawa.eb@renesas.com,
        Kieran Bingham <kieran.bingham@ideasonboard.com>
References: <20180307220511.9826-1-niklas.soderlund+renesas@ragnatech.se>
 <20180307220511.9826-31-niklas.soderlund+renesas@ragnatech.se>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <4efe8cf1-3e58-290e-77f7-7b4c3432281c@xs4all.nl>
Date: Fri, 9 Mar 2018 16:47:25 +0100
MIME-Version: 1.0
In-Reply-To: <20180307220511.9826-31-niklas.soderlund+renesas@ragnatech.se>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 07/03/18 23:05, Niklas Söderlund wrote:
> The procedure to start or stop streaming using the non-MC single
> subdevice and the MC graph and multiple subdevices are quite different.
> Create a new function to abstract which method is used based on which
> mode the driver is running in and add logic to start the MC graph.
> 
> Signed-off-by: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>
> Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

Reviewed-by: Hans Verkuil <hans.verkuil@cisco.com>

Regards,

	Hans

> ---
>  drivers/media/platform/rcar-vin/rcar-dma.c | 133 +++++++++++++++++++++++++++--
>  1 file changed, 126 insertions(+), 7 deletions(-)
> 
> diff --git a/drivers/media/platform/rcar-vin/rcar-dma.c b/drivers/media/platform/rcar-vin/rcar-dma.c
> index da113531f0ce7dc0..580b286acbf2dab6 100644
> --- a/drivers/media/platform/rcar-vin/rcar-dma.c
> +++ b/drivers/media/platform/rcar-vin/rcar-dma.c
> @@ -1082,15 +1082,136 @@ static void rvin_buffer_queue(struct vb2_buffer *vb)
>  	spin_unlock_irqrestore(&vin->qlock, flags);
>  }
>  
> +static int rvin_mc_validate_format(struct rvin_dev *vin, struct v4l2_subdev *sd,
> +				   struct media_pad *pad)
> +{
> +	struct v4l2_subdev_format fmt = {
> +		.which = V4L2_SUBDEV_FORMAT_ACTIVE,
> +	};
> +
> +	fmt.pad = pad->index;
> +	if (v4l2_subdev_call(sd, pad, get_fmt, NULL, &fmt))
> +		return -EPIPE;
> +
> +	switch (fmt.format.code) {
> +	case MEDIA_BUS_FMT_YUYV8_1X16:
> +	case MEDIA_BUS_FMT_UYVY8_2X8:
> +	case MEDIA_BUS_FMT_UYVY10_2X10:
> +	case MEDIA_BUS_FMT_RGB888_1X24:
> +		vin->mbus_code = fmt.format.code;
> +		break;
> +	default:
> +		return -EPIPE;
> +	}
> +
> +	switch (fmt.format.field) {
> +	case V4L2_FIELD_TOP:
> +	case V4L2_FIELD_BOTTOM:
> +	case V4L2_FIELD_NONE:
> +	case V4L2_FIELD_INTERLACED_TB:
> +	case V4L2_FIELD_INTERLACED_BT:
> +	case V4L2_FIELD_INTERLACED:
> +	case V4L2_FIELD_SEQ_TB:
> +	case V4L2_FIELD_SEQ_BT:
> +		/* Supported natively */
> +		break;
> +	case V4L2_FIELD_ALTERNATE:
> +		switch (vin->format.field) {
> +		case V4L2_FIELD_TOP:
> +		case V4L2_FIELD_BOTTOM:
> +		case V4L2_FIELD_NONE:
> +			break;
> +		case V4L2_FIELD_INTERLACED_TB:
> +		case V4L2_FIELD_INTERLACED_BT:
> +		case V4L2_FIELD_INTERLACED:
> +		case V4L2_FIELD_SEQ_TB:
> +		case V4L2_FIELD_SEQ_BT:
> +			/* Use VIN hardware to combine the two fields */
> +			fmt.format.height *= 2;
> +			break;
> +		default:
> +			return -EPIPE;
> +		}
> +		break;
> +	default:
> +		return -EPIPE;
> +	}
> +
> +	if (fmt.format.width != vin->format.width ||
> +	    fmt.format.height != vin->format.height ||
> +	    fmt.format.code != vin->mbus_code)
> +		return -EPIPE;
> +
> +	return 0;
> +}
> +
> +static int rvin_set_stream(struct rvin_dev *vin, int on)
> +{
> +	struct media_pipeline *pipe;
> +	struct media_device *mdev;
> +	struct v4l2_subdev *sd;
> +	struct media_pad *pad;
> +	int ret;
> +
> +	/* No media controller used, simply pass operation to subdevice. */
> +	if (!vin->info->use_mc) {
> +		ret = v4l2_subdev_call(vin->digital->subdev, video, s_stream,
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
> +
> +	if (!on) {
> +		media_pipeline_stop(&vin->vdev.entity);
> +		return v4l2_subdev_call(sd, video, s_stream, 0);
> +	}
> +
> +	ret = rvin_mc_validate_format(vin, sd, pad);
> +	if (ret)
> +		return ret;
> +
> +	/*
> +	 * The graph lock needs to be taken to protect concurrent
> +	 * starts of multiple VIN instances as they might share
> +	 * a common subdevice down the line and then should use
> +	 * the same pipe.
> +	 */
> +	mdev = vin->vdev.entity.graph_obj.mdev;
> +	mutex_lock(&mdev->graph_mutex);
> +	pipe = sd->entity.pipe ? sd->entity.pipe : &vin->vdev.pipe;
> +	ret = __media_pipeline_start(&vin->vdev.entity, pipe);
> +	mutex_unlock(&mdev->graph_mutex);
> +	if (ret)
> +		return ret;
> +
> +	ret = v4l2_subdev_call(sd, video, s_stream, 1);
> +	if (ret == -ENOIOCTLCMD)
> +		ret = 0;
> +	if (ret)
> +		media_pipeline_stop(&vin->vdev.entity);
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
> @@ -1099,7 +1220,7 @@ static int rvin_start_streaming(struct vb2_queue *vq, unsigned int count)
>  	ret = rvin_capture_start(vin);
>  	if (ret) {
>  		return_all_buffers(vin, VB2_BUF_STATE_QUEUED);
> -		v4l2_subdev_call(sd, video, s_stream, 0);
> +		rvin_set_stream(vin, 0);
>  	}
>  
>  	spin_unlock_irqrestore(&vin->qlock, flags);
> @@ -1110,7 +1231,6 @@ static int rvin_start_streaming(struct vb2_queue *vq, unsigned int count)
>  static void rvin_stop_streaming(struct vb2_queue *vq)
>  {
>  	struct rvin_dev *vin = vb2_get_drv_priv(vq);
> -	struct v4l2_subdev *sd;
>  	unsigned long flags;
>  	int retries = 0;
>  
> @@ -1149,8 +1269,7 @@ static void rvin_stop_streaming(struct vb2_queue *vq)
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
