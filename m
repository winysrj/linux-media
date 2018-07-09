Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([213.167.242.64]:34914 "EHLO
        perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932674AbeGINEH (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Mon, 9 Jul 2018 09:04:07 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org, Hans Verkuil <hans.verkuil@cisco.com>
Subject: Re: [PATCHv5 09/12] adv7180/tvp514x/tvp7002: fix entity function
Date: Mon, 09 Jul 2018 16:04:40 +0300
Message-ID: <2172427.hsFcQPoQVr@avalon>
In-Reply-To: <20180629114331.7617-10-hverkuil@xs4all.nl>
References: <20180629114331.7617-1-hverkuil@xs4all.nl> <20180629114331.7617-10-hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

Thank you for the patch.

On Friday, 29 June 2018 14:43:28 EEST Hans Verkuil wrote:
> From: Hans Verkuil <hans.verkuil@cisco.com>
> 
> The entity function was ORed with the flags field instead of
> assigned to the function field. Correct this.
> 
> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
> Acked-by: Sakari Ailus <sakari.ailus@linux.intel.com>

Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

> ---
>  drivers/media/i2c/adv7180.c | 2 +-
>  drivers/media/i2c/tvp514x.c | 2 +-
>  drivers/media/i2c/tvp7002.c | 2 +-
>  3 files changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/media/i2c/adv7180.c b/drivers/media/i2c/adv7180.c
> index 25d24a3f10a7..a727d7f806a1 100644
> --- a/drivers/media/i2c/adv7180.c
> +++ b/drivers/media/i2c/adv7180.c
> @@ -1335,7 +1335,7 @@ static int adv7180_probe(struct i2c_client *client,
>  		goto err_unregister_vpp_client;
> 
>  	state->pad.flags = MEDIA_PAD_FL_SOURCE;
> -	sd->entity.flags |= MEDIA_ENT_F_ATV_DECODER;
> +	sd->entity.function = MEDIA_ENT_F_ATV_DECODER;
>  	ret = media_entity_pads_init(&sd->entity, 1, &state->pad);
>  	if (ret)
>  		goto err_free_ctrl;
> diff --git a/drivers/media/i2c/tvp514x.c b/drivers/media/i2c/tvp514x.c
> index 6a9890531d01..675b9ae212ab 100644
> --- a/drivers/media/i2c/tvp514x.c
> +++ b/drivers/media/i2c/tvp514x.c
> @@ -1084,7 +1084,7 @@ tvp514x_probe(struct i2c_client *client, const struct
> i2c_device_id *id) #if defined(CONFIG_MEDIA_CONTROLLER)
>  	decoder->pad.flags = MEDIA_PAD_FL_SOURCE;
>  	decoder->sd.flags |= V4L2_SUBDEV_FL_HAS_DEVNODE;
> -	decoder->sd.entity.flags |= MEDIA_ENT_F_ATV_DECODER;
> +	decoder->sd.entity.function = MEDIA_ENT_F_ATV_DECODER;
> 
>  	ret = media_entity_pads_init(&decoder->sd.entity, 1, &decoder->pad);
>  	if (ret < 0) {
> diff --git a/drivers/media/i2c/tvp7002.c b/drivers/media/i2c/tvp7002.c
> index 4599b7e28a8d..4f5c627579c7 100644
> --- a/drivers/media/i2c/tvp7002.c
> +++ b/drivers/media/i2c/tvp7002.c
> @@ -1010,7 +1010,7 @@ static int tvp7002_probe(struct i2c_client *c, const
> struct i2c_device_id *id) #if defined(CONFIG_MEDIA_CONTROLLER)
>  	device->pad.flags = MEDIA_PAD_FL_SOURCE;
>  	device->sd.flags |= V4L2_SUBDEV_FL_HAS_DEVNODE;
> -	device->sd.entity.flags |= MEDIA_ENT_F_ATV_DECODER;
> +	device->sd.entity.function = MEDIA_ENT_F_ATV_DECODER;
> 
>  	error = media_entity_pads_init(&device->sd.entity, 1, &device->pad);
>  	if (error < 0)


-- 
Regards,

Laurent Pinchart
