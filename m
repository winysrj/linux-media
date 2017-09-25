Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud7.xs4all.net ([194.109.24.24]:49679 "EHLO
        lb1-smtp-cloud7.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S933186AbdIYKLu (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 25 Sep 2017 06:11:50 -0400
Subject: Re: [PATCH v6 18/25] rcar-vin: prepare for media controller mode
 initialization
To: =?UTF-8?Q?Niklas_S=c3=b6derlund?=
        <niklas.soderlund+renesas@ragnatech.se>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>
References: <20170822232640.26147-1-niklas.soderlund+renesas@ragnatech.se>
 <20170822232640.26147-19-niklas.soderlund+renesas@ragnatech.se>
Cc: Kieran Bingham <kieran.bingham@ideasonboard.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        tomoharu.fukawa.eb@renesas.com, linux-media@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <5bd4faf5-a325-3cd3-8f3b-2e3ef6e99fc1@xs4all.nl>
Date: Mon, 25 Sep 2017 12:11:48 +0200
MIME-Version: 1.0
In-Reply-To: <20170822232640.26147-19-niklas.soderlund+renesas@ragnatech.se>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 23/08/17 01:26, Niklas Söderlund wrote:
> When running in media controller mode a media pad is needed, register
> one. Also set the media bus format to CSI-2.
> 
> Signed-off-by: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>


Reviewed-by: Hans Verkuil <hans.verkuil@cisco.com>

Regards,

	Hans


> ---
>  drivers/media/platform/rcar-vin/rcar-core.c | 23 ++++++++++++++++++++++-
>  drivers/media/platform/rcar-vin/rcar-vin.h  |  4 ++++
>  2 files changed, 26 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/media/platform/rcar-vin/rcar-core.c b/drivers/media/platform/rcar-vin/rcar-core.c
> index fbbb22924cf3a045..dd0525f2ba336bc2 100644
> --- a/drivers/media/platform/rcar-vin/rcar-core.c
> +++ b/drivers/media/platform/rcar-vin/rcar-core.c
> @@ -45,6 +45,10 @@ static int rvin_find_pad(struct v4l2_subdev *sd, int direction)
>  	return -EINVAL;
>  }
>  
> +/* -----------------------------------------------------------------------------
> + * Digital async notifier
> + */
> +
>  static bool rvin_mbus_supported(struct rvin_dev *vin)
>  {
>  	struct v4l2_subdev *sd = vin->digital.subdev;
> @@ -273,6 +277,20 @@ static int rvin_digital_graph_init(struct rvin_dev *vin)
>  	return 0;
>  }
>  
> +/* -----------------------------------------------------------------------------
> + * Group async notifier
> + */
> +
> +static int rvin_group_init(struct rvin_dev *vin)
> +{
> +	/* All our sources are CSI-2 */
> +	vin->mbus_cfg.type = V4L2_MBUS_CSI2;
> +	vin->mbus_cfg.flags = 0;
> +
> +	vin->pad.flags = MEDIA_PAD_FL_SINK;
> +	return media_entity_pads_init(&vin->vdev.entity, 1, &vin->pad);
> +}
> +
>  /* -----------------------------------------------------------------------------
>   * Platform Device Driver
>   */
> @@ -365,7 +383,10 @@ static int rcar_vin_probe(struct platform_device *pdev)
>  	if (ret)
>  		return ret;
>  
> -	ret = rvin_digital_graph_init(vin);
> +	if (vin->info->use_mc)
> +		ret = rvin_group_init(vin);
> +	else
> +		ret = rvin_digital_graph_init(vin);
>  	if (ret < 0)
>  		goto error;
>  
> diff --git a/drivers/media/platform/rcar-vin/rcar-vin.h b/drivers/media/platform/rcar-vin/rcar-vin.h
> index 12daff804bb6f77f..9c47669669c0469c 100644
> --- a/drivers/media/platform/rcar-vin/rcar-vin.h
> +++ b/drivers/media/platform/rcar-vin/rcar-vin.h
> @@ -103,6 +103,8 @@ struct rvin_info {
>   * @notifier:		V4L2 asynchronous subdevs notifier
>   * @digital:		entity in the DT for local digital subdevice
>   *
> + * @pad:		pad for media controller
> + *
>   * @lock:		protects @queue
>   * @queue:		vb2 buffers queue
>   *
> @@ -132,6 +134,8 @@ struct rvin_dev {
>  	struct v4l2_async_notifier notifier;
>  	struct rvin_graph_entity digital;
>  
> +	struct media_pad pad;
> +
>  	struct mutex lock;
>  	struct vb2_queue queue;
>  
> 
