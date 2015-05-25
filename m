Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.22]:62007 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751069AbbEYPMm (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 25 May 2015 11:12:42 -0400
Date: Mon, 25 May 2015 17:12:34 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: William Towle <william.towle@codethink.co.uk>
cc: linux-kernel@lists.codethink.co.uk, linux-media@vger.kernel.org,
	sergei.shtylyov@cogentembedded.com, hverkuil@xs4all.nl,
	rob.taylor@codethink.co.uk
Subject: Re: [PATCH 16/20] media: adv7180: Fix set_pad_format() passing wrong
 format
In-Reply-To: <1432139980-12619-17-git-send-email-william.towle@codethink.co.uk>
Message-ID: <Pine.LNX.4.64.1505251711050.26358@axis700.grange>
References: <1432139980-12619-1-git-send-email-william.towle@codethink.co.uk>
 <1432139980-12619-17-git-send-email-william.towle@codethink.co.uk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, 20 May 2015, William Towle wrote:

> Return a usable format (and resolution) from adv7180_set_pad_format()
> in the TRY_FORMAT case
> 
> Signed-off-by: Rob Taylor <rob.taylor@codethink.co.uk>
> Tested-by: William Towle <william.towle@codethink.co.uk>

Author?

> ---
>  drivers/media/i2c/adv7180.c |    6 ++++--
>  1 file changed, 4 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/media/i2c/adv7180.c b/drivers/media/i2c/adv7180.c
> index 09a96df..ba0b92d5 100644
> --- a/drivers/media/i2c/adv7180.c
> +++ b/drivers/media/i2c/adv7180.c
> @@ -686,12 +686,14 @@ static int adv7180_set_pad_format(struct v4l2_subdev *sd,
>  			adv7180_set_field_mode(state);
>  			adv7180_set_power(state, true);
>  		}
> +		adv7180_mbus_fmt(sd, framefmt);
>  	} else {
>  		framefmt = v4l2_subdev_get_try_format(sd, cfg, 0);
>  		*framefmt = format->format;
> +		adv7180_mbus_fmt(sd, framefmt);
> +		format->format = *framefmt;

Wouldn't it be easier to:

+		adv7180_mbus_fmt(sd, &format->format);
 		framefmt = v4l2_subdev_get_try_format(sd, cfg, 0);
 		*framefmt = format->format;

and also make adv7180_mbus_fmt() return void?

Thanks
Guennadi

>  	}
> -
> -	return adv7180_mbus_fmt(sd, framefmt);
> +	return 0;
>  }
>  
>  static int adv7180_g_mbus_config(struct v4l2_subdev *sd,
> -- 
> 1.7.10.4
> 
