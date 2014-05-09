Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:55893 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750712AbaEIMRY (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 9 May 2014 08:17:24 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Sakari Ailus <sakari.ailus@iki.fi>
Cc: linux-media@vger.kernel.org
Subject: Re: [PATCH 3/3] smiapp: Return correct return value in smiapp_registered()
Date: Fri, 09 May 2014 14:17:24 +0200
Message-ID: <6542492.1vSdmarlZg@avalon>
In-Reply-To: <1399163517-5220-4-git-send-email-sakari.ailus@iki.fi>
References: <1399163517-5220-1-git-send-email-sakari.ailus@iki.fi> <1399163517-5220-4-git-send-email-sakari.ailus@iki.fi>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sakari,

Thank you for the patch.

On Sunday 04 May 2014 03:31:57 Sakari Ailus wrote:
> Prepare for supporting systems using the Device tree. Should the resources
> not be available at the time of driver probe(), the EPROBE_DEFER error code
> must be also returned from its probe function.
> 
> Signed-off-by: Sakari Ailus <sakari.ailus@iki.fi>

Acked-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

> ---
>  drivers/media/i2c/smiapp/smiapp-core.c |   15 ++++++++-------
>  1 file changed, 8 insertions(+), 7 deletions(-)
> 
> diff --git a/drivers/media/i2c/smiapp/smiapp-core.c
> b/drivers/media/i2c/smiapp/smiapp-core.c index e4037c8..3c7be76 100644
> --- a/drivers/media/i2c/smiapp/smiapp-core.c
> +++ b/drivers/media/i2c/smiapp/smiapp-core.c
> @@ -2358,14 +2358,14 @@ static int smiapp_registered(struct v4l2_subdev
> *subdev) sensor->vana = devm_regulator_get(&client->dev, "vana");
>  	if (IS_ERR(sensor->vana)) {
>  		dev_err(&client->dev, "could not get regulator for vana\n");
> -		return -ENODEV;
> +		return PTR_ERR(sensor->vana);
>  	}
> 
>  	if (!sensor->platform_data->set_xclk) {
>  		sensor->ext_clk = devm_clk_get(&client->dev, "ext_clk");
>  		if (IS_ERR(sensor->ext_clk)) {
>  			dev_err(&client->dev, "could not get clock\n");
> -			return -ENODEV;
> +			return PTR_ERR(sensor->ext_clk);
>  		}
> 
>  		rval = clk_set_rate(sensor->ext_clk,
> @@ -2374,18 +2374,19 @@ static int smiapp_registered(struct v4l2_subdev
> *subdev) dev_err(&client->dev,
>  				"unable to set clock freq to %u\n",
>  				sensor->platform_data->ext_clk);
> -			return -ENODEV;
> +			return rval;
>  		}
>  	}
> 
>  	if (gpio_is_valid(sensor->platform_data->xshutdown)) {
> -		if (devm_gpio_request_one(&client->dev,
> -					  sensor->platform_data->xshutdown, 0,
> -					  "SMIA++ xshutdown") != 0) {
> +		rval = devm_gpio_request_one(
> +			&client->dev, sensor->platform_data->xshutdown, 0,
> +			"SMIA++ xshutdown");
> +		if (rval < 0) {
>  			dev_err(&client->dev,
>  				"unable to acquire reset gpio %d\n",
>  				sensor->platform_data->xshutdown);
> -			return -ENODEV;
> +			return rval;
>  		}
>  	}

-- 
Regards,

Laurent Pinchart

