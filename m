Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:42975 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752918AbZCLNMD (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 12 Mar 2009 09:12:03 -0400
Date: Thu, 12 Mar 2009 14:12:09 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Sascha Hauer <s.hauer@pengutronix.de>
cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PATCH 2/5] pcm990 baseboard: add camera bus width switch setting
In-Reply-To: <1236857239-2146-3-git-send-email-s.hauer@pengutronix.de>
Message-ID: <Pine.LNX.4.64.0903121405150.4896@axis700.grange>
References: <1236857239-2146-1-git-send-email-s.hauer@pengutronix.de>
 <1236857239-2146-2-git-send-email-s.hauer@pengutronix.de>
 <1236857239-2146-3-git-send-email-s.hauer@pengutronix.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, 12 Mar 2009, Sascha Hauer wrote:

> Some Phytec cameras have a I2C GPIO expander which allows it to
> switch between different sensor bus widths. This was previously
> handled in the camera driver. Since handling of this switch
> varies on several boards the cameras are used on, the board
> support seems a better place to handle the switch
> 
> Signed-off-by: Sascha Hauer <s.hauer@pengutronix.de>
> ---
>  arch/arm/mach-pxa/pcm990-baseboard.c |   49 +++++++++++++++++++++++++++------
>  1 files changed, 40 insertions(+), 9 deletions(-)
> 
> diff --git a/arch/arm/mach-pxa/pcm990-baseboard.c b/arch/arm/mach-pxa/pcm990-baseboard.c
> index 34841c7..8b01565 100644
> --- a/arch/arm/mach-pxa/pcm990-baseboard.c
> +++ b/arch/arm/mach-pxa/pcm990-baseboard.c
> @@ -381,14 +381,45 @@ static struct pca953x_platform_data pca9536_data = {
>  	.gpio_base	= NR_BUILTIN_GPIO + 1,
>  };
>  
> -static struct soc_camera_link iclink[] = {
> -	{
> -		.bus_id	= 0, /* Must match with the camera ID above */
> -		.gpio	= NR_BUILTIN_GPIO + 1,
> -	}, {
> -		.bus_id	= 0, /* Must match with the camera ID above */
> -		.gpio	= -ENXIO,
> +static int gpio_bus_switch;
> +
> +static int pcm990_camera_set_bus_param(struct soc_camera_link *link,
> +		unsigned long flags)
> +{
> +	if (gpio_bus_switch <= 0)
> +		return 0;

Are you really sure you don't want to return an error here? In 
query_bus_param() below, if you fail to get the GPIO, you set 
gpio_bus_switch to -EINVAL and return only 10 bit. Now if a buggy host 
driver still requests 8 bits, mt9m001 will call ->set_bus_param and you 
will happily return 0...

> +
> +	if (flags & SOCAM_DATAWIDTH_8)
> +		gpio_set_value(gpio_bus_switch, 1);
> +	else
> +		gpio_set_value(gpio_bus_switch, 0);
> +
> +	return 0;
> +}
> +
> +static unsigned long pcm990_camera_query_bus_param(struct soc_camera_link *link)
> +{
> +	int ret;
> +
> +	if (!gpio_bus_switch) {
> +		ret = gpio_request(NR_BUILTIN_GPIO + 1, "camera");
> +		if (!ret) {
> +			gpio_bus_switch = NR_BUILTIN_GPIO + 1;
> +			gpio_direction_output(gpio_bus_switch, 0);
> +		} else
> +			gpio_bus_switch = -EINVAL;
>  	}
> +
> +	if (gpio_bus_switch > 0)
> +		return SOCAM_DATAWIDTH_8 | SOCAM_DATAWIDTH_10;
> +	else
> +		return SOCAM_DATAWIDTH_10;
> +}
> +
> +static struct soc_camera_link iclink = {
> +	.bus_id	= 0, /* Must match with the camera ID above */
> +	.query_bus_param = pcm990_camera_query_bus_param,
> +	.set_bus_param = pcm990_camera_set_bus_param,
>  };
>  
>  /* Board I2C devices. */
> @@ -399,10 +430,10 @@ static struct i2c_board_info __initdata pcm990_i2c_devices[] = {
>  		.platform_data = &pca9536_data,
>  	}, {
>  		I2C_BOARD_INFO("mt9v022", 0x48),
> -		.platform_data = &iclink[0], /* With extender */
> +		.platform_data = &iclink, /* With extender */
>  	}, {
>  		I2C_BOARD_INFO("mt9m001", 0x5d),
> -		.platform_data = &iclink[0], /* With extender */
> +		.platform_data = &iclink, /* With extender */
>  	},
>  };
>  #endif /* CONFIG_VIDEO_PXA27x ||CONFIG_VIDEO_PXA27x_MODULE */
> -- 
> 1.5.6.5
> 

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
