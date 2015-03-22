Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:47664 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751432AbbCVA23 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 21 Mar 2015 20:28:29 -0400
Date: Sun, 22 Mar 2015 02:28:23 +0200
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Jacek Anaszewski <j.anaszewski@samsung.com>
Cc: linux-leds@vger.kernel.org, linux-media@vger.kernel.org,
	devicetree@vger.kernel.org, kyungmin.park@samsung.com,
	pavel@ucw.cz, cooloney@gmail.com, rpurdie@rpsys.net,
	s.nawrocki@samsung.com
Subject: Re: [PATCH v1 10/11] leds: max77693: add support for V4L2 Flash
 sub-device
Message-ID: <20150322002823.GH16613@valkosipuli.retiisi.org.uk>
References: <1426863811-12516-1-git-send-email-j.anaszewski@samsung.com>
 <1426863811-12516-11-git-send-email-j.anaszewski@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1426863811-12516-11-git-send-email-j.anaszewski@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Jacek,

On Fri, Mar 20, 2015 at 04:03:30PM +0100, Jacek Anaszewski wrote:
> Add support for V4L2 Flash sub-device to the max77693 LED Flash class
> driver. The support allows for V4L2 Flash sub-device to take the control
> of the LED Flash class device.
> 
> Signed-off-by: Jacek Anaszewski <j.anaszewski@samsung.com>
> Acked-by: Kyungmin Park <kyungmin.park@samsung.com>
> Cc: Bryan Wu <cooloney@gmail.com>
> Cc: Richard Purdie <rpurdie@rpsys.net>
> Cc: Sakari Ailus <sakari.ailus@iki.fi>
> ---
>  drivers/leds/leds-max77693.c |  149 +++++++++++++++++++++++++++++++++++++++---
>  1 file changed, 141 insertions(+), 8 deletions(-)
> 
> diff --git a/drivers/leds/leds-max77693.c b/drivers/leds/leds-max77693.c
> index 7386d69..a12bd8c 100644
> --- a/drivers/leds/leds-max77693.c
> +++ b/drivers/leds/leds-max77693.c
> @@ -21,6 +21,7 @@
>  #include <linux/regmap.h>
>  #include <linux/slab.h>
>  #include <linux/workqueue.h>
> +#include <media/v4l2-flash.h>
>  
>  #define MODE_OFF		0
>  #define MODE_FLASH(a)		(1 << (a))
> @@ -68,6 +69,8 @@ struct max77693_sub_led {
>  	struct led_classdev_flash fled_cdev;
>  	/* assures led-triggers compatibility */
>  	struct work_struct work_brightness_set;
> +	/* V4L2 Flash device */
> +	struct v4l2_flash *v4l2_flash;
>  
>  	/* brightness cache */
>  	unsigned int torch_brightness;
> @@ -651,7 +654,8 @@ static int max77693_led_flash_timeout_set(
>  }
>  
>  static int max77693_led_parse_dt(struct max77693_led_device *led,
> -				struct max77693_led_config_data *cfg)
> +				struct max77693_led_config_data *cfg,
> +				struct device_node **sub_nodes)
>  {
>  	struct device *dev = &led->pdev->dev;
>  	struct max77693_sub_led *sub_leds = led->sub_leds;
> @@ -697,6 +701,13 @@ static int max77693_led_parse_dt(struct max77693_led_device *led,
>  			return -EINVAL;
>  		}
>  
> +		if (sub_nodes[fled_id]) {
> +			dev_err(dev,
> +				"Conflicting \"led-sources\" DT properties\n");
> +			return -EINVAL;
> +		}
> +
> +		sub_nodes[fled_id] = child_node;
>  		sub_leds[fled_id].fled_id = fled_id;
>  
>  		of_property_read_string(child_node, "label",
> @@ -784,11 +795,12 @@ static void max77693_led_validate_configuration(struct max77693_led_device *led,
>  }
>  
>  static int max77693_led_get_configuration(struct max77693_led_device *led,
> -				struct max77693_led_config_data *cfg)
> +				struct max77693_led_config_data *cfg,
> +				struct device_node **sub_nodes)
>  {
>  	int ret;
>  
> -	ret = max77693_led_parse_dt(led, cfg);
> +	ret = max77693_led_parse_dt(led, cfg, sub_nodes);
>  	if (ret < 0)
>  		return ret;
>  
> @@ -855,9 +867,86 @@ static const char *max77693_get_led_name(struct max77693_led_device *led,
>  					     MAX77693_LED2_NAME;
>  }
>  
> +#if IS_ENABLED(CONFIG_V4L2_FLASH_LED_CLASS)
> +
> +static int max77693_led_external_strobe_set(
> +				struct v4l2_flash *v4l2_flash,
> +				bool enable)
> +{
> +	struct max77693_sub_led *sub_led =
> +				flcdev_to_sub_led(v4l2_flash->fled_cdev);
> +	struct max77693_led_device *led = sub_led_to_led(sub_led);
> +	int fled_id = sub_led->fled_id;
> +	int ret;
> +
> +	mutex_lock(&led->lock);
> +
> +	if (enable)
> +		ret = max77693_add_mode(led, MODE_FLASH_EXTERNAL(fled_id));
> +	else
> +		ret = max77693_clear_mode(led, MODE_FLASH_EXTERNAL(fled_id));
> +
> +	mutex_unlock(&led->lock);
> +
> +	return ret;
> +}
> +
> +static void max77693_init_v4l2_ctrl_config(struct max77693_led_device *led,
> +					int fled_id,
> +					struct max77693_led_settings *s,
> +					struct v4l2_flash_ctrl_config *config)
> +{
> +	struct device *dev = &led->pdev->dev;
> +	struct max77693_dev *iodev = dev_get_drvdata(dev->parent);
> +	struct i2c_client *i2c = iodev->i2c;
> +	struct led_flash_setting *setting;
> +	struct v4l2_ctrl_config *c;
> +
> +	snprintf(config->dev_name, sizeof(config->dev_name),
> +		 "%s %d-%04x", max77693_get_led_name(led, fled_id),
> +		 i2c_adapter_id(i2c->adapter), i2c->addr);

Looks good!

> +
> +	c = &config->intensity;
> +	setting = &s->torch_brightness;
> +	c->min = setting->min;
> +	c->max = setting->max;
> +	c->step = setting->step;
> +	c->def = setting->val;
> +
> +	c = &config->flash_intensity;
> +	setting = &s->flash_brightness;
> +	c->min = setting->min;
> +	c->max = setting->max;
> +	c->step = setting->step;
> +	c->def = setting->val;
> +
> +	c = &config->flash_timeout;
> +	setting = &s->flash_timeout;
> +	c->min = setting->min;
> +	c->max = setting->max;
> +	c->step = setting->step;
> +	c->def = setting->val;

You could create a function for this. Up to you. But more importantly,
please see my comment on patch 7 regarding the use of v4l2_ctrl_config
first.

> +	/* Init flash faults config */
> +	config->flash_faults =	V4L2_FLASH_FAULT_OVER_VOLTAGE |
> +				V4L2_FLASH_FAULT_SHORT_CIRCUIT |
> +				V4L2_FLASH_FAULT_OVER_CURRENT;
> +
> +	config->has_external_strobe = true;
> +}
> +
> +static const struct v4l2_flash_ops v4l2_flash_ops = {
> +	.external_strobe_set = max77693_led_external_strobe_set,
> +};
> +
> +#else
> +#define max77693_init_v4l2_ctrl_config(led, fled_id, s, config)
> +#endif
> +
>  static void max77693_init_fled_cdev(struct max77693_led_device *led,
>  				int fled_id,
> -				struct max77693_led_config_data *cfg)
> +				struct max77693_led_config_data *cfg,
> +				struct v4l2_flash_ctrl_config *v4l2_flash_cfg)
>  {
>  	struct led_classdev_flash *fled_cdev;
>  	struct led_classdev *led_cdev;
> @@ -866,6 +955,8 @@ static void max77693_init_fled_cdev(struct max77693_led_device *led,
>  
>  	/* Initialize flash settings */
>  	max77693_init_flash_settings(led, fled_id, cfg, &settings);
> +	/* Initialize V4L2 Flash config basing on initialized settings */
> +	max77693_init_v4l2_ctrl_config(led, fled_id, &settings, v4l2_flash_cfg);
>  
>  	/* Initialize LED Flash class device */
>  	fled_cdev = &sub_led->fled_cdev;
> @@ -891,15 +982,51 @@ static void max77693_init_fled_cdev(struct max77693_led_device *led,
>  	sub_led->flash_timeout = fled_cdev->timeout.val;
>  }
>  
> +static int max77693_register_led(struct max77693_sub_led *sub_led,
> +				 struct v4l2_flash_ctrl_config *v4l2_flash_cfg,
> +				 struct device_node *sub_node)
> +{
> +	struct max77693_led_device *led = sub_led_to_led(sub_led);
> +	struct led_classdev_flash *fled_cdev = &sub_led->fled_cdev;
> +	struct device *dev = &led->pdev->dev;
> +	int ret;
> +
> +	/* Register in the LED subsystem */
> +	ret = led_classdev_flash_register(dev, fled_cdev);
> +	if (ret < 0)
> +		return ret;
> +
> +	fled_cdev->led_cdev.dev->of_node = sub_node;
> +
> +	/* Register in the V4L2 subsystem. */
> +	sub_led->v4l2_flash = v4l2_flash_init(fled_cdev, &v4l2_flash_ops,
> +						v4l2_flash_cfg);
> +	if (IS_ERR(sub_led->v4l2_flash)) {
> +		ret = PTR_ERR(sub_led->v4l2_flash);
> +		goto err_v4l2_flash_init;
> +	}
> +
> +	return 0;
> +
> +err_v4l2_flash_init:
> +	of_node_put(sub_node);

I wonder if this is where it belongs or if I miss something here.

> +	led_classdev_flash_unregister(fled_cdev);
> +	return ret;
> +}
> +
>  static int max77693_led_probe(struct platform_device *pdev)
>  {
>  	struct device *dev = &pdev->dev;
>  	struct max77693_dev *iodev = dev_get_drvdata(dev->parent);
>  	struct max77693_led_device *led;
>  	struct max77693_sub_led *sub_leds;
> +	struct device_node *sub_nodes[2] = { NULL, NULL };

{} would do. { 0 } is actually what you should use, but gcc sometimes choces
on that (it's a gcc bug).

>  	struct max77693_led_config_data cfg = {};
> +	struct v4l2_flash_ctrl_config v4l2_flash_config[2];
>  	int init_fled_cdev[2], i, ret;
>  
> +	memset(v4l2_flash_config, 0, sizeof(v4l2_flash_config));

You could initialise v4l2_flash_config to zero by assigning { 0 } to it in
the initialiser, as you do with other variables already.

> +
>  	led = devm_kzalloc(dev, sizeof(*led), GFP_KERNEL);
>  	if (!led)
>  		return -ENOMEM;
> @@ -910,7 +1037,7 @@ static int max77693_led_probe(struct platform_device *pdev)
>  	sub_leds = led->sub_leds;
>  
>  	platform_set_drvdata(pdev, led);
> -	ret = max77693_led_get_configuration(led, &cfg);
> +	ret = max77693_led_get_configuration(led, &cfg, sub_nodes);
>  	if (ret < 0)
>  		return ret;
>  
> @@ -926,15 +1053,18 @@ static int max77693_led_probe(struct platform_device *pdev)
>  	/* Initialize LED Flash class device(s) */
>  	for (i = FLED1; i <= FLED2; ++i)
>  		if (init_fled_cdev[i])
> -			max77693_init_fled_cdev(led, i, &cfg);
> +			max77693_init_fled_cdev(led, i, &cfg,
> +						&v4l2_flash_config[i]);
>  	mutex_init(&led->lock);
>  
> -	/* Register LED Flash class device(s) */
> +	/* Register LED Flash class and related V4L2 Flash device(s) */
>  	for (i = FLED1; i <= FLED2; ++i) {
>  		if (!init_fled_cdev[i])
>  			continue;
>  
> -		ret = led_classdev_flash_register(dev, &sub_leds[i].fled_cdev);
> +		ret = max77693_register_led(&sub_leds[i],
> +					    &v4l2_flash_config[i],
> +					    sub_nodes[i]);
>  		if (ret < 0) {
>  			/*
>  			 * At this moment FLED1 might have been already
> @@ -953,6 +1083,7 @@ err_register_led2:
>  	/* It is possible than only FLED2 was to be registered */
>  	if (!init_fled_cdev[FLED1])
>  		goto err_register_led1;
> +	v4l2_flash_release(sub_leds[FLED1].v4l2_flash);
>  	led_classdev_flash_unregister(&sub_leds[FLED1].fled_cdev);
>  err_register_led1:
>  	mutex_destroy(&led->lock);
> @@ -966,11 +1097,13 @@ static int max77693_led_remove(struct platform_device *pdev)
>  	struct max77693_sub_led *sub_leds = led->sub_leds;
>  
>  	if (led->iout_joint || max77693_fled_used(led, FLED1)) {
> +		v4l2_flash_release(sub_leds[FLED1].v4l2_flash);
>  		led_classdev_flash_unregister(&sub_leds[FLED1].fled_cdev);
>  		cancel_work_sync(&sub_leds[FLED1].work_brightness_set);
>  	}
>  
>  	if (!led->iout_joint && max77693_fled_used(led, FLED2)) {
> +		v4l2_flash_release(sub_leds[FLED2].v4l2_flash);
>  		led_classdev_flash_unregister(&sub_leds[FLED2].fled_cdev);
>  		cancel_work_sync(&sub_leds[FLED2].work_brightness_set);
>  	}

-- 
Kind regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
