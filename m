Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([213.167.242.64]:36292 "EHLO
        perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727229AbeIUCH5 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 20 Sep 2018 22:07:57 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
Cc: Pavel Machek <pavel@ucw.cz>, Sakari Ailus <sakari.ailus@iki.fi>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        Hans Verkuil <hans.verkuil@cisco.com>
Subject: Re: [PATCH 1/4] [media] ad5820: Define entity function
Date: Thu, 20 Sep 2018 23:22:55 +0300
Message-ID: <512495074.bF91m146Of@avalon>
In-Reply-To: <20180920161912.17063-1-ricardo.ribalda@gmail.com>
References: <20180920161912.17063-1-ricardo.ribalda@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Ricardo,

Thank you for the patch.

On Thursday, 20 September 2018 19:19:09 EEST Ricardo Ribalda Delgado wrote:
> Without this patch, media_device_register_entity throws a warning:
> 
> dev_warn(mdev->dev,
> 	 "Entity type for entity %s was not initialized!\n",
> 	 entity->name);
> 
> Signed-off-by: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>

Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

> ---
>  drivers/media/i2c/ad5820.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/media/i2c/ad5820.c b/drivers/media/i2c/ad5820.c
> index 907323f0ca3b..22759aaa2dba 100644
> --- a/drivers/media/i2c/ad5820.c
> +++ b/drivers/media/i2c/ad5820.c
> @@ -317,6 +317,7 @@ static int ad5820_probe(struct i2c_client *client,
>  	v4l2_i2c_subdev_init(&coil->subdev, client, &ad5820_ops);
>  	coil->subdev.flags |= V4L2_SUBDEV_FL_HAS_DEVNODE;
>  	coil->subdev.internal_ops = &ad5820_internal_ops;
> +	coil->subdev.entity.function = MEDIA_ENT_F_LENS;
>  	strscpy(coil->subdev.name, "ad5820 focus", sizeof(coil->subdev.name));
> 
>  	ret = media_entity_pads_init(&coil->subdev.entity, 0, NULL);


-- 
Regards,

Laurent Pinchart
