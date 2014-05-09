Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:55902 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750744AbaEIMSY (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 9 May 2014 08:18:24 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Sakari Ailus <sakari.ailus@iki.fi>
Cc: linux-media@vger.kernel.org
Subject: Re: [PATCH 2/3] smiapp: Check for GPIO validity using gpio_is_valid()
Date: Fri, 09 May 2014 14:18:24 +0200
Message-ID: <5427082.Dc0ESfsmo0@avalon>
In-Reply-To: <1399163517-5220-3-git-send-email-sakari.ailus@iki.fi>
References: <1399163517-5220-1-git-send-email-sakari.ailus@iki.fi> <1399163517-5220-3-git-send-email-sakari.ailus@iki.fi>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sakari,

Thank you for the patch.

On Sunday 04 May 2014 03:31:56 Sakari Ailus wrote:
> Do not use our special value, SMIAPP_NO_XSHUTDOWN.
> 
> Signed-off-by: Sakari Ailus <sakari.ailus@iki.fi>

Wouldn't it make sense to switch to the gpiod API ? That change could then 
replace this patch. If you would like to do so in an incremental patch 
instead,

Acked-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

> ---
>  drivers/media/i2c/smiapp/smiapp-core.c |   10 +++++-----
>  1 file changed, 5 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/media/i2c/smiapp/smiapp-core.c
> b/drivers/media/i2c/smiapp/smiapp-core.c index c1d6d1d..e4037c8 100644
> --- a/drivers/media/i2c/smiapp/smiapp-core.c
> +++ b/drivers/media/i2c/smiapp/smiapp-core.c
> @@ -1128,7 +1128,7 @@ static int smiapp_power_on(struct smiapp_sensor
> *sensor) }
>  	usleep_range(1000, 1000);
> 
> -	if (sensor->platform_data->xshutdown != SMIAPP_NO_XSHUTDOWN)
> +	if (gpio_is_valid(sensor->platform_data->xshutdown))
>  		gpio_set_value(sensor->platform_data->xshutdown, 1);
> 
>  	sleep = SMIAPP_RESET_DELAY(sensor->platform_data->ext_clk);
> @@ -1238,7 +1238,7 @@ static int smiapp_power_on(struct smiapp_sensor
> *sensor) return 0;
> 
>  out_cci_addr_fail:
> -	if (sensor->platform_data->xshutdown != SMIAPP_NO_XSHUTDOWN)
> +	if (gpio_is_valid(sensor->platform_data->xshutdown))
>  		gpio_set_value(sensor->platform_data->xshutdown, 0);
>  	if (sensor->platform_data->set_xclk)
>  		sensor->platform_data->set_xclk(&sensor->src->sd, 0);
> @@ -1264,7 +1264,7 @@ static void smiapp_power_off(struct smiapp_sensor
> *sensor) SMIAPP_REG_U8_SOFTWARE_RESET,
>  			     SMIAPP_SOFTWARE_RESET);
> 
> -	if (sensor->platform_data->xshutdown != SMIAPP_NO_XSHUTDOWN)
> +	if (gpio_is_valid(sensor->platform_data->xshutdown))
>  		gpio_set_value(sensor->platform_data->xshutdown, 0);
>  	if (sensor->platform_data->set_xclk)
>  		sensor->platform_data->set_xclk(&sensor->src->sd, 0);
> @@ -2378,7 +2378,7 @@ static int smiapp_registered(struct v4l2_subdev
> *subdev) }
>  	}
> 
> -	if (sensor->platform_data->xshutdown != SMIAPP_NO_XSHUTDOWN) {
> +	if (gpio_is_valid(sensor->platform_data->xshutdown)) {
>  		if (devm_gpio_request_one(&client->dev,
>  					  sensor->platform_data->xshutdown, 0,
>  					  "SMIA++ xshutdown") != 0) {
> @@ -2830,7 +2830,7 @@ static int smiapp_remove(struct i2c_client *client)
>  	unsigned int i;
> 
>  	if (sensor->power_count) {
> -		if (sensor->platform_data->xshutdown != SMIAPP_NO_XSHUTDOWN)
> +		if (gpio_is_valid(sensor->platform_data->xshutdown))
>  			gpio_set_value(sensor->platform_data->xshutdown, 0);
>  		if (sensor->platform_data->set_xclk)
>  			sensor->platform_data->set_xclk(&sensor->src->sd, 0);

-- 
Regards,

Laurent Pinchart

