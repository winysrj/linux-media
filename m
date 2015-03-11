Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:39335 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750779AbbCKSkY (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 11 Mar 2015 14:40:24 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Sakari Ailus <sakari.ailus@iki.fi>
Cc: linux-media@vger.kernel.org, prabhakar.csengg@gmail.com
Subject: Re: [PATCH 1/3] smiapp: Clean up smiapp_get_pdata()
Date: Wed, 11 Mar 2015 20:40:25 +0200
Message-ID: <2399074.CESEE9G7DY@avalon>
In-Reply-To: <1425950282-30548-2-git-send-email-sakari.ailus@iki.fi>
References: <1425950282-30548-1-git-send-email-sakari.ailus@iki.fi> <1425950282-30548-2-git-send-email-sakari.ailus@iki.fi>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sakari,

Thank you for the patch.

On Tuesday 10 March 2015 03:18:00 Sakari Ailus wrote:
> Don't set rval when it's not used (the function returns a pointer to struct
> smiapp_platform_data).
> 
> Signed-off-by: Sakari Ailus <sakari.ailus@iki.fi>

Acked-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

> ---
>  drivers/media/i2c/smiapp/smiapp-core.c |    5 +----
>  1 file changed, 1 insertion(+), 4 deletions(-)
> 
> diff --git a/drivers/media/i2c/smiapp/smiapp-core.c
> b/drivers/media/i2c/smiapp/smiapp-core.c index b1f566b..565a00c 100644
> --- a/drivers/media/i2c/smiapp/smiapp-core.c
> +++ b/drivers/media/i2c/smiapp/smiapp-core.c
> @@ -2988,10 +2988,8 @@ static struct smiapp_platform_data
> *smiapp_get_pdata(struct device *dev) return NULL;
> 
>  	pdata = devm_kzalloc(dev, sizeof(*pdata), GFP_KERNEL);
> -	if (!pdata) {
> -		rval = -ENOMEM;
> +	if (!pdata)
>  		goto out_err;
> -	}
> 
>  	v4l2_of_parse_endpoint(ep, &bus_cfg);
> 
> @@ -3001,7 +2999,6 @@ static struct smiapp_platform_data
> *smiapp_get_pdata(struct device *dev) break;
>  		/* FIXME: add CCP2 support. */
>  	default:
> -		rval = -EINVAL;
>  		goto out_err;
>  	}

-- 
Regards,

Laurent Pinchart

