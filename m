Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:56326 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753803AbbLFCdo (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 5 Dec 2015 21:33:44 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Javier Martinez Canillas <javier@osg.samsung.com>
Cc: linux-kernel@vger.kernel.org,
	Hans Verkuil <hans.verkuil@cisco.com>,
	Sakari Ailus <sakari.ailus@iki.fi>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	linux-media@vger.kernel.org
Subject: Re: [PATCH 5/5] [media] smiapp: create pad links after subdev registration
Date: Sun, 06 Dec 2015 04:33:57 +0200
Message-ID: <1752289.9imvS5bF0M@avalon>
In-Reply-To: <1441296036-20727-6-git-send-email-javier@osg.samsung.com>
References: <1441296036-20727-1-git-send-email-javier@osg.samsung.com> <1441296036-20727-6-git-send-email-javier@osg.samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Javier,

Thank you for the patch.

On Thursday 03 September 2015 18:00:36 Javier Martinez Canillas wrote:
> The smiapp driver creates the pads links before the media entity is
> registered with the media device. This doesn't work now that object
> IDs are used to create links so the media_device has to be set.
> 
> Move entity registration logic before pads links creation.
> 
> Signed-off-by: Javier Martinez Canillas <javier@osg.samsung.com>

Acked-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

> ---
> 
>  drivers/media/i2c/smiapp/smiapp-core.c | 20 ++++++++++----------
>  1 file changed, 10 insertions(+), 10 deletions(-)
> 
> diff --git a/drivers/media/i2c/smiapp/smiapp-core.c
> b/drivers/media/i2c/smiapp/smiapp-core.c index 5aa49eb393a9..938201789ebc
> 100644
> --- a/drivers/media/i2c/smiapp/smiapp-core.c
> +++ b/drivers/media/i2c/smiapp/smiapp-core.c
> @@ -2495,23 +2495,23 @@ static int smiapp_register_subdevs(struct
> smiapp_sensor *sensor) return rval;
>  		}
> 
> -		rval = media_create_pad_link(&this->sd.entity,
> -						this->source_pad,
> -						&last->sd.entity,
> -						last->sink_pad,
> -						MEDIA_LNK_FL_ENABLED |
> -						MEDIA_LNK_FL_IMMUTABLE);
> +		rval = v4l2_device_register_subdev(sensor->src->sd.v4l2_dev,
> +						   &this->sd);
>  		if (rval) {
>  			dev_err(&client->dev,
> -				"media_create_pad_link failed\n");
> +				"v4l2_device_register_subdev failed\n");
>  			return rval;
>  		}
> 
> -		rval = v4l2_device_register_subdev(sensor->src->sd.v4l2_dev,
> -						   &this->sd);
> +		rval = media_create_pad_link(&this->sd.entity,
> +					     this->source_pad,
> +					     &last->sd.entity,
> +					     last->sink_pad,
> +					     MEDIA_LNK_FL_ENABLED |
> +					     MEDIA_LNK_FL_IMMUTABLE);
>  		if (rval) {
>  			dev_err(&client->dev,
> -				"v4l2_device_register_subdev failed\n");
> +				"media_create_pad_link failed\n");
>  			return rval;
>  		}
>  	}

-- 
Regards,

Laurent Pinchart

