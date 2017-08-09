Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wr0-f196.google.com ([209.85.128.196]:32918 "EHLO
        mail-wr0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752187AbdHINUH (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Wed, 9 Aug 2017 09:20:07 -0400
Date: Wed, 9 Aug 2017 14:20:02 +0100
From: Rui Miguel Silva <rmfrfs@gmail.com>
To: Sakari Ailus <sakari.ailus@linux.intel.com>
Cc: linux-media@vger.kernel.org, linux-leds@vger.kernel.org,
        jacek.anaszewski@gmail.com, laurent.pinchart@ideasonboard.com,
        Johan Hovold <johan@kernel.org>, Alex Elder <elder@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        greybus-dev@lists.linaro.org, devel@driverdev.osuosl.org,
        viresh.kumar@linaro.org
Subject: Re: [PATCH v2 1/3] staging: greybus: light: fix memory leak in v4l2
 register
Message-ID: <20170809132002.GA10002@arch-late.localdomain>
References: <20170809111555.30147-1-sakari.ailus@linux.intel.com>
 <20170809111555.30147-2-sakari.ailus@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170809111555.30147-2-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sakari,
On Wed, Aug 09, 2017 at 02:15:53PM +0300, Sakari Ailus wrote:
> From: Rui Miguel Silva <rmfrfs@gmail.com>
> 
> We are allocating memory for the v4l2 flash configuration structure and
> leak it in the normal path. Just use the stack for this as we do not
> use it outside of this function.
> 
> Fixes: 2870b52bae4c ("greybus: lights: add lights implementation")
> Reported-by: Sakari Ailus <sakari.ailus@linux.intel.com>
> Signed-off-by: Rui Miguel Silva <rmfrfs@gmail.com>
> Reviewed-by: Viresh Kumar <viresh.kumar@linaro.org>
> ---

This patch is *not* the patch that I have send, here are the code
differences from my patch to the one in this series:

<  	struct led_classdev_flash *iled = NULL;
---
>  	struct led_classdev *iled = NULL;
51c57
<  		iled = &channel_ind->fled;
---
>  		iled = &channel_ind->fled.led_cdev;
89c95

So, this do not apply at all.
Maybe you change something in your side.

---
Cheers,
	Rui


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
> -- 
> 2.11.0
> 
