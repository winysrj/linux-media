Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp4-g21.free.fr ([212.27.42.4]:51027 "EHLO smtp4-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755667AbZDOUgZ (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 15 Apr 2009 16:36:25 -0400
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PATCH 5/5] soc-camera: Convert to a platform driver
References: <Pine.LNX.4.64.0904151356480.4729@axis700.grange>
	<Pine.LNX.4.64.0904151403500.4729@axis700.grange>
From: Robert Jarzmik <robert.jarzmik@free.fr>
Date: Wed, 15 Apr 2009 22:36:14 +0200
Message-ID: <87r5ztmz7l.fsf@free.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Guennadi Liakhovetski <g.liakhovetski@gmx.de> writes:

> Convert soc-camera core to a platform driver. With this approach I2C
> devices are no longer statically registered in platform code, instead they
> are registered dynamically by the soc-camera core, when a match with a
> host driver is found. With this patch all platforms and all soc-camera
> device drivers are converted too. This is a preparatory step for the
> v4l-subdev conversion.
>
> Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
> ---
>
> Ok, here goes the bad guy. Hit it hard, hit it as hard as you can.
>

> Robert, I addressed your wishes from your previous comments, but kept the 
> semicolon rearrangement hunk. I think, it is better not to terminate a 
> define with a semicolon, if you like, we can make this a separate patch.
Yep, I'd like to. That's because of merge conflict with current patches through
arm tree. It will be easier for Eric or me to handle that other patch conflict,
thus letting the true v4l patch through.

> @@ -754,20 +756,21 @@ static struct platform_device var = {			\
>  		.platform_data = pdata,			\
>  		.parent	= tparent,			\
>  	},						\
> -};
> +}
>  #define MIO_SIMPLE_DEV(var, strname, pdata)	\
>  	MIO_PARENT_DEV(var, strname, NULL, pdata)
>  
> -MIO_SIMPLE_DEV(mioa701_gpio_keys, "gpio-keys",	    &mioa701_gpio_keys_data)
> +MIO_SIMPLE_DEV(mioa701_gpio_keys, "gpio-keys",	    &mioa701_gpio_keys_data);
>  MIO_PARENT_DEV(mioa701_backlight, "pwm-backlight",  &pxa27x_device_pwm0.dev,
>  		&mioa701_backlight_data);
> -MIO_SIMPLE_DEV(mioa701_led,	  "leds-gpio",	    &gpio_led_info)
> -MIO_SIMPLE_DEV(pxa2xx_pcm,	  "pxa2xx-pcm",	    NULL)
> -MIO_SIMPLE_DEV(pxa2xx_ac97,	  "pxa2xx-ac97",    NULL)
> -MIO_PARENT_DEV(mio_wm9713_codec,  "wm9713-codec",   &pxa2xx_ac97.dev, NULL)
> -MIO_SIMPLE_DEV(mioa701_sound,	  "mioa701-wm9713", NULL)
> -MIO_SIMPLE_DEV(mioa701_board,	  "mioa701-board",  NULL)
> +MIO_SIMPLE_DEV(mioa701_led,	  "leds-gpio",	    &gpio_led_info);
> +MIO_SIMPLE_DEV(pxa2xx_pcm,	  "pxa2xx-pcm",	    NULL);
> +MIO_SIMPLE_DEV(pxa2xx_ac97,	  "pxa2xx-ac97",    NULL);
> +MIO_PARENT_DEV(mio_wm9713_codec,  "wm9713-codec",   &pxa2xx_ac97.dev, NULL);
> +MIO_SIMPLE_DEV(mioa701_sound,	  "mioa701-wm9713", NULL);
> +MIO_SIMPLE_DEV(mioa701_board,	  "mioa701-board",  NULL);

>  MIO_SIMPLE_DEV(gpio_vbus,	  "gpio-vbus",      &gpio_vbus_data);
> +MIO_SIMPLE_DEV(mioa701_camera,	  "soc-camera-pdrv",&iclink[0]);
                                                              \
                                                               -> still broken
                                                          (should be &iclink)
> diff --git a/drivers/media/video/mt9m111.c b/drivers/media/video/mt9m111.c
> @@ -917,6 +921,11 @@ static int mt9m111_video_probe(struct soc_camera_device *icd)
>  	    to_soc_camera_host(icd->dev.parent)->nr != icd->iface)
>  		return -ENODEV;
>  
> +	/* Switch master clock on */
> +	ret = soc_camera_video_start(icd, &client->dev);
> +	if (ret)
> +		return ret;
> +
Well, I'd wish to keep only out "return" point where return value is given back
by another function (ie. have goto evid).
The reason behind is when debuggin, it's easier to put one printk("%d", ret),
and see what happened.

As the legacy mt9m111 style is :
 - either return <immediate value>
 - or if single occurence return func(foo)
 - or error path with gotos
I'd like that "return ret" to be transformed into "goto evid" or the like.

> diff --git a/drivers/media/video/soc_camera.c b/drivers/media/video/soc_camera.c
> @@ -794,103 +791,70 @@ static void scan_add_host(struct soc_camera_host *ici)
>  
>  	list_for_each_entry(icd, &devices, list) {
>  		if (icd->iface == ici->nr) {
> +			int ret;
>  			icd->dev.parent = ici->dev;
> -			device_register_link(icd);
> -		}
> -	}
> -
> -	mutex_unlock(&list_lock);
> -}
> -
> -/* return: 0 if no match found or a match found and
> - * device_register() successful, error code otherwise */
> -static int scan_add_device(struct soc_camera_device *icd)
> -{
> -	struct soc_camera_host *ici;
> -	int ret = 0;
> -
> -	mutex_lock(&list_lock);
> -
> -	list_add_tail(&icd->list, &devices);
> -
> -	/* Watch out for class_for_each_device / class_find_device API by
> -	 * Dave Young <hidave.darkstar@gmail.com> */
> -	list_for_each_entry(ici, &hosts, list) {
> -		if (icd->iface == ici->nr) {
> -			ret = 1;
> -			icd->dev.parent = ici->dev;
> -			break;
> +			dev_set_name(&icd->dev, "%u-%u", icd->iface,
> +				     icd->devnum);
> +			ret = device_register(&icd->dev);
> +			if (ret < 0) {
> +				icd->dev.parent = NULL;
> +				dev_err(&icd->dev,
> +					"Cannot register device: %d\n", ret);
> +			}
>  		}
>  	}
>  
>  	mutex_unlock(&list_lock);
> -
> -	if (ret)
> -		ret = device_register_link(icd);
> -
> -	return ret;
>  }
>  
> +static int video_dev_create(struct soc_camera_device *icd);
> +/* Called during host-driver probe */
>  static int soc_camera_probe(struct device *dev)
>  {
>  	struct soc_camera_device *icd = to_soc_camera_dev(dev);
> -	struct soc_camera_host *ici = to_soc_camera_host(icd->dev.parent);
> +	struct soc_camera_link *icl = to_soc_camera_link(icd);
>  	int ret;
> +	struct i2c_client *client;
> +	struct i2c_adapter *adap = i2c_get_adapter(icl->i2c_adapter_id);
>  
> -	/*
> -	 * Possible race scenario:
> -	 * modprobe <camera-host-driver> triggers __func__
> -	 * at this moment respective <camera-sensor-driver> gets rmmod'ed
> -	 * to protect take module references.
> -	 */
> -
> -	if (!try_module_get(icd->ops->owner)) {
> -		dev_err(&icd->dev, "Couldn't lock sensor driver.\n");
> -		ret = -EINVAL;
> -		goto emgd;
> -	}
> -
> -	if (!try_module_get(ici->ops->owner)) {
> -		dev_err(&icd->dev, "Couldn't lock capture bus driver.\n");
> -		ret = -EINVAL;
> -		goto emgi;
> +	if (!adap) {
> +		ret = -ENODEV;
> +		dev_err(dev, "Cannot get I2C adapter %d\n", icl->i2c_adapter_id);
> +		goto ei2cga;
>  	}
>  
> -	mutex_lock(&icd->video_lock);
> +	dev_info(dev, "Probing %s\n", dev_name(dev));
>  
> -	/* We only call ->add() here to activate and probe the camera.
> -	 * We shall ->remove() and deactivate it immediately afterwards. */
> -	ret = ici->ops->add(icd);
> -	if (ret < 0)
> -		goto eiadd;
> +	client = i2c_new_device(adap, icl->board_info);
> +	if (!client) {
> +		ret = -ENOMEM;
> +		goto ei2cnd;
> +	}
>  
> -	ret = icd->ops->probe(icd);
> -	if (ret >= 0) {
> -		const struct v4l2_queryctrl *qctrl;
> +	/*
> +	 * We set icd drvdata at two locations - here and in
> +	 * soc_camera_video_start(). Depending on the module loading /
> +	 * initialisation order one of these locations will be entered first
> +	 */
> +	/* Use to_i2c_client(dev) to recover the i2c client */
> +	dev_set_drvdata(&icd->dev, &client->dev);
I didn't find any reference to unsetting the driver data. Is it normal ?

I must admit I didn't go fully through soc_camera* ... I'll try harder in the
next days.

Cheers.

--
Robert
