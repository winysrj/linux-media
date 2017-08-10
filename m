Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud7.xs4all.net ([194.109.24.31]:49862 "EHLO
        lb3-smtp-cloud7.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752095AbdHJNCx (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 10 Aug 2017 09:02:53 -0400
Subject: Re: [PATCH v2 1/3] staging: greybus: light: fix memory leak in v4l2
 register
To: Sakari Ailus <sakari.ailus@linux.intel.com>,
        linux-media@vger.kernel.org
References: <20170809111555.30147-1-sakari.ailus@linux.intel.com>
 <20170809111555.30147-2-sakari.ailus@linux.intel.com>
Cc: linux-leds@vger.kernel.org, jacek.anaszewski@gmail.com,
        laurent.pinchart@ideasonboard.com, Johan Hovold <johan@kernel.org>,
        Alex Elder <elder@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        greybus-dev@lists.linaro.org, devel@driverdev.osuosl.org,
        viresh.kumar@linaro.org, Rui Miguel Silva <rmfrfs@gmail.com>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <cec7fc27-25eb-8769-6795-c377307c5f57@xs4all.nl>
Date: Thu, 10 Aug 2017 15:02:46 +0200
MIME-Version: 1.0
In-Reply-To: <20170809111555.30147-2-sakari.ailus@linux.intel.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 09/08/17 13:15, Sakari Ailus wrote:
> From: Rui Miguel Silva <rmfrfs@gmail.com>
> 
> We are allocating memory for the v4l2 flash configuration structure and
> leak it in the normal path. Just use the stack for this as we do not
> use it outside of this function.

I'm not sure why this is part of this patch series. This is a greybus
bug fix, right? And independent from the other two patches.

> 
> Fixes: 2870b52bae4c ("greybus: lights: add lights implementation")
> Reported-by: Sakari Ailus <sakari.ailus@linux.intel.com>
> Signed-off-by: Rui Miguel Silva <rmfrfs@gmail.com>
> Reviewed-by: Viresh Kumar <viresh.kumar@linaro.org>
> ---
>  drivers/staging/greybus/light.c | 29 +++++++++--------------------
>  1 file changed, 9 insertions(+), 20 deletions(-)
> 
> diff --git a/drivers/staging/greybus/light.c b/drivers/staging/greybus/light.c
> index 129ceed39829..0771db418f84 100644
> --- a/drivers/staging/greybus/light.c
> +++ b/drivers/staging/greybus/light.c
> @@ -534,25 +534,20 @@ static int gb_lights_light_v4l2_register(struct gb_light *light)
>  {
>  	struct gb_connection *connection = get_conn_from_light(light);
>  	struct device *dev = &connection->bundle->dev;
> -	struct v4l2_flash_config *sd_cfg;
> +	struct v4l2_flash_config sd_cfg = { {0} };

Just use '= {};'

>  	struct led_classdev_flash *fled;
>  	struct led_classdev *iled = NULL;
>  	struct gb_channel *channel_torch, *channel_ind, *channel_flash;
> -	int ret = 0;
> -
> -	sd_cfg = kcalloc(1, sizeof(*sd_cfg), GFP_KERNEL);
> -	if (!sd_cfg)
> -		return -ENOMEM;
>  
>  	channel_torch = get_channel_from_mode(light, GB_CHANNEL_MODE_TORCH);
>  	if (channel_torch)
>  		__gb_lights_channel_v4l2_config(&channel_torch->intensity_uA,
> -						&sd_cfg->torch_intensity);
> +						&sd_cfg.torch_intensity);
>  
>  	channel_ind = get_channel_from_mode(light, GB_CHANNEL_MODE_INDICATOR);
>  	if (channel_ind) {
>  		__gb_lights_channel_v4l2_config(&channel_ind->intensity_uA,
> -						&sd_cfg->indicator_intensity);
> +						&sd_cfg.indicator_intensity);
>  		iled = &channel_ind->fled.led_cdev;
>  	}
>  
> @@ -561,27 +556,21 @@ static int gb_lights_light_v4l2_register(struct gb_light *light)
>  
>  	fled = &channel_flash->fled;
>  
> -	snprintf(sd_cfg->dev_name, sizeof(sd_cfg->dev_name), "%s", light->name);
> +	snprintf(sd_cfg.dev_name, sizeof(sd_cfg.dev_name), "%s", light->name);
>  
>  	/* Set the possible values to faults, in our case all faults */
> -	sd_cfg->flash_faults = LED_FAULT_OVER_VOLTAGE | LED_FAULT_TIMEOUT |
> +	sd_cfg.flash_faults = LED_FAULT_OVER_VOLTAGE | LED_FAULT_TIMEOUT |
>  		LED_FAULT_OVER_TEMPERATURE | LED_FAULT_SHORT_CIRCUIT |
>  		LED_FAULT_OVER_CURRENT | LED_FAULT_INDICATOR |
>  		LED_FAULT_UNDER_VOLTAGE | LED_FAULT_INPUT_VOLTAGE |
>  		LED_FAULT_LED_OVER_TEMPERATURE;
>  
>  	light->v4l2_flash = v4l2_flash_init(dev, NULL, fled, iled,
> -					    &v4l2_flash_ops, sd_cfg);
> -	if (IS_ERR_OR_NULL(light->v4l2_flash)) {
> -		ret = PTR_ERR(light->v4l2_flash);
> -		goto out_free;
> -	}
> +					    &v4l2_flash_ops, &sd_cfg);
> +	if (IS_ERR_OR_NULL(light->v4l2_flash))

Just IS_ERR since v4l2_flash_init() never returns NULL.

> +		return PTR_ERR(light->v4l2_flash);
>  
> -	return ret;
> -
> -out_free:
> -	kfree(sd_cfg);
> -	return ret;
> +	return 0;
>  }
>  
>  static void gb_lights_light_v4l2_unregister(struct gb_light *light)
> 

After those two changes:

Acked-by: Hans Verkuil <hans.verkuil@cisco.com>

Regards,

	Hans
