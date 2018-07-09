Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([213.167.242.64]:34928 "EHLO
        perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932595AbeGINE5 (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Mon, 9 Jul 2018 09:04:57 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org, Hans Verkuil <hans.verkuil@cisco.com>
Subject: Re: [PATCHv5 10/12] media/i2c: add missing entity functions
Date: Mon, 09 Jul 2018 16:05:30 +0300
Message-ID: <4671786.nOIRK6uOON@avalon>
In-Reply-To: <20180629114331.7617-11-hverkuil@xs4all.nl>
References: <20180629114331.7617-1-hverkuil@xs4all.nl> <20180629114331.7617-11-hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

Thank you for the patch.

On Friday, 29 June 2018 14:43:29 EEST Hans Verkuil wrote:
> From: Hans Verkuil <hans.verkuil@cisco.com>
> 
> Several drivers in media/i2c do not set the entity function.
> Correct this.
> 
> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
> Acked-by: Sakari Ailus <sakari.ailus@linux.intel.com>

Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

> ---
>  drivers/media/i2c/et8ek8/et8ek8_driver.c | 1 +
>  drivers/media/i2c/mt9m032.c              | 1 +
>  drivers/media/i2c/mt9p031.c              | 1 +
>  drivers/media/i2c/mt9t001.c              | 1 +
>  drivers/media/i2c/mt9v032.c              | 1 +
>  5 files changed, 5 insertions(+)
> 
> diff --git a/drivers/media/i2c/et8ek8/et8ek8_driver.c
> b/drivers/media/i2c/et8ek8/et8ek8_driver.c index e9eff9039ef5..37ef38947e01
> 100644
> --- a/drivers/media/i2c/et8ek8/et8ek8_driver.c
> +++ b/drivers/media/i2c/et8ek8/et8ek8_driver.c
> @@ -1446,6 +1446,7 @@ static int et8ek8_probe(struct i2c_client *client,
>  	sensor->subdev.flags |= V4L2_SUBDEV_FL_HAS_DEVNODE;
>  	sensor->subdev.internal_ops = &et8ek8_internal_ops;
> 
> +	sensor->subdev.entity.function = MEDIA_ENT_F_CAM_SENSOR;
>  	sensor->pad.flags = MEDIA_PAD_FL_SOURCE;
>  	ret = media_entity_pads_init(&sensor->subdev.entity, 1, &sensor->pad);
>  	if (ret < 0) {
> diff --git a/drivers/media/i2c/mt9m032.c b/drivers/media/i2c/mt9m032.c
> index 6a9e068462fd..b385f2b632ad 100644
> --- a/drivers/media/i2c/mt9m032.c
> +++ b/drivers/media/i2c/mt9m032.c
> @@ -793,6 +793,7 @@ static int mt9m032_probe(struct i2c_client *client,
>  	v4l2_ctrl_cluster(2, &sensor->hflip);
> 
>  	sensor->subdev.ctrl_handler = &sensor->ctrls;
> +	sensor->subdev.entity.function = MEDIA_ENT_F_CAM_SENSOR;
>  	sensor->pad.flags = MEDIA_PAD_FL_SOURCE;
>  	ret = media_entity_pads_init(&sensor->subdev.entity, 1, &sensor->pad);
>  	if (ret < 0)
> diff --git a/drivers/media/i2c/mt9p031.c b/drivers/media/i2c/mt9p031.c
> index 91d822fc4443..715be3632b01 100644
> --- a/drivers/media/i2c/mt9p031.c
> +++ b/drivers/media/i2c/mt9p031.c
> @@ -1111,6 +1111,7 @@ static int mt9p031_probe(struct i2c_client *client,
>  	v4l2_i2c_subdev_init(&mt9p031->subdev, client, &mt9p031_subdev_ops);
>  	mt9p031->subdev.internal_ops = &mt9p031_subdev_internal_ops;
> 
> +	mt9p031->subdev.entity.function = MEDIA_ENT_F_CAM_SENSOR;
>  	mt9p031->pad.flags = MEDIA_PAD_FL_SOURCE;
>  	ret = media_entity_pads_init(&mt9p031->subdev.entity, 1, &mt9p031->pad);
>  	if (ret < 0)
> diff --git a/drivers/media/i2c/mt9t001.c b/drivers/media/i2c/mt9t001.c
> index 9d981d9f5686..f683d2cb0486 100644
> --- a/drivers/media/i2c/mt9t001.c
> +++ b/drivers/media/i2c/mt9t001.c
> @@ -943,6 +943,7 @@ static int mt9t001_probe(struct i2c_client *client,
>  	mt9t001->subdev.internal_ops = &mt9t001_subdev_internal_ops;
>  	mt9t001->subdev.flags |= V4L2_SUBDEV_FL_HAS_DEVNODE;
> 
> +	mt9t001->subdev.entity.function = MEDIA_ENT_F_CAM_SENSOR;
>  	mt9t001->pad.flags = MEDIA_PAD_FL_SOURCE;
>  	ret = media_entity_pads_init(&mt9t001->subdev.entity, 1, &mt9t001->pad);
> 
> diff --git a/drivers/media/i2c/mt9v032.c b/drivers/media/i2c/mt9v032.c
> index 4de63b2df334..f74730d24d8f 100644
> --- a/drivers/media/i2c/mt9v032.c
> +++ b/drivers/media/i2c/mt9v032.c
> @@ -1162,6 +1162,7 @@ static int mt9v032_probe(struct i2c_client *client,
>  	mt9v032->subdev.internal_ops = &mt9v032_subdev_internal_ops;
>  	mt9v032->subdev.flags |= V4L2_SUBDEV_FL_HAS_DEVNODE;
> 
> +	mt9v032->subdev.entity.function = MEDIA_ENT_F_CAM_SENSOR;
>  	mt9v032->pad.flags = MEDIA_PAD_FL_SOURCE;
>  	ret = media_entity_pads_init(&mt9v032->subdev.entity, 1, &mt9v032->pad);
>  	if (ret < 0)


-- 
Regards,

Laurent Pinchart
