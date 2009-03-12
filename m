Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:50208 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751548AbZCLJVS (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 12 Mar 2009 05:21:18 -0400
Date: Thu, 12 Mar 2009 10:21:20 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Sascha Hauer <s.hauer@pengutronix.de>
cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PATCH 3/4] mt9m001: allow setting of bus width from board code
In-Reply-To: <1236765976-20581-4-git-send-email-s.hauer@pengutronix.de>
Message-ID: <Pine.LNX.4.64.0903120941050.4896@axis700.grange>
References: <1236765976-20581-1-git-send-email-s.hauer@pengutronix.de>
 <1236765976-20581-2-git-send-email-s.hauer@pengutronix.de>
 <1236765976-20581-3-git-send-email-s.hauer@pengutronix.de>
 <1236765976-20581-4-git-send-email-s.hauer@pengutronix.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, 11 Mar 2009, Sascha Hauer wrote:

> This patch removes the phytec specific setting of the bus width
> and switches to the more generic query_bus_param/set_bus_param
> hooks
> 
> Signed-off-by: Sascha Hauer <s.hauer@pengutronix.de>
> ---
>  drivers/media/video/Kconfig   |    7 --
>  drivers/media/video/mt9m001.c |  130 +++++++++-------------------------------
>  2 files changed, 30 insertions(+), 107 deletions(-)
> 
> diff --git a/drivers/media/video/Kconfig b/drivers/media/video/Kconfig
> index 19cf3b8..5fc1531 100644
> --- a/drivers/media/video/Kconfig
> +++ b/drivers/media/video/Kconfig
> @@ -728,13 +728,6 @@ config SOC_CAMERA_MT9M001
>  	  This driver supports MT9M001 cameras from Micron, monochrome
>  	  and colour models.
>  
> -config MT9M001_PCA9536_SWITCH
> -	bool "pca9536 datawidth switch for mt9m001"
> -	depends on SOC_CAMERA_MT9M001 && GENERIC_GPIO
> -	help
> -	  Select this if your MT9M001 camera uses a PCA9536 I2C GPIO
> -	  extender to switch between 8 and 10 bit datawidth modes
> -
>  config SOC_CAMERA_MT9M111
>  	tristate "mt9m111 and mt9m112 support"
>  	depends on SOC_CAMERA && I2C
> diff --git a/drivers/media/video/mt9m001.c b/drivers/media/video/mt9m001.c
> index c1bf75e..112c612 100644
> --- a/drivers/media/video/mt9m001.c
> +++ b/drivers/media/video/mt9m001.c
> @@ -75,7 +75,6 @@ struct mt9m001 {
>  	int model;	/* V4L2_IDENT_MT9M001* codes from v4l2-chip-ident.h */
>  	int switch_gpio;
>  	unsigned char autoexposure;
> -	unsigned char datawidth;
>  };
>  
>  static int reg_read(struct soc_camera_device *icd, const u8 reg)
> @@ -181,90 +180,17 @@ static int mt9m001_stop_capture(struct soc_camera_device *icd)
>  	return 0;
>  }
>  
> -static int bus_switch_request(struct mt9m001 *mt9m001,
> -			      struct soc_camera_link *icl)
> -{
> -#ifdef CONFIG_MT9M001_PCA9536_SWITCH
> -	int ret;
> -	unsigned int gpio = icl->gpio;
> -
> -	if (gpio_is_valid(gpio)) {
> -		/* We have a data bus switch. */
> -		ret = gpio_request(gpio, "mt9m001");
> -		if (ret < 0) {
> -			dev_err(&mt9m001->client->dev, "Cannot get GPIO %u\n",
> -				gpio);
> -			return ret;
> -		}
> -
> -		ret = gpio_direction_output(gpio, 0);
> -		if (ret < 0) {
> -			dev_err(&mt9m001->client->dev,
> -				"Cannot set GPIO %u to output\n", gpio);
> -			gpio_free(gpio);
> -			return ret;
> -		}
> -	}
> -
> -	mt9m001->switch_gpio = gpio;
> -#else
> -	mt9m001->switch_gpio = -EINVAL;
> -#endif
> -	return 0;
> -}
> -
> -static void bus_switch_release(struct mt9m001 *mt9m001)
> -{
> -#ifdef CONFIG_MT9M001_PCA9536_SWITCH
> -	if (gpio_is_valid(mt9m001->switch_gpio))
> -		gpio_free(mt9m001->switch_gpio);
> -#endif
> -}
> -
> -static int bus_switch_act(struct mt9m001 *mt9m001, int go8bit)
> -{
> -#ifdef CONFIG_MT9M001_PCA9536_SWITCH
> -	if (!gpio_is_valid(mt9m001->switch_gpio))
> -		return -ENODEV;
> -
> -	gpio_set_value_cansleep(mt9m001->switch_gpio, go8bit);
> -	return 0;
> -#else
> -	return -ENODEV;
> -#endif
> -}
> -
> -static int bus_switch_possible(struct mt9m001 *mt9m001)
> -{
> -#ifdef CONFIG_MT9M001_PCA9536_SWITCH
> -	return gpio_is_valid(mt9m001->switch_gpio);
> -#else
> -	return 0;
> -#endif
> -}
> -
>  static int mt9m001_set_bus_param(struct soc_camera_device *icd,
>  				 unsigned long flags)
>  {
>  	struct mt9m001 *mt9m001 = container_of(icd, struct mt9m001, icd);
> -	unsigned int width_flag = flags & SOCAM_DATAWIDTH_MASK;
> -	int ret;
> +	struct soc_camera_link *icl = mt9m001->client->dev.platform_data;
>  
>  	/* Flags validity verified in test_bus_param */
>  
> -	if ((mt9m001->datawidth != 10 && (width_flag == SOCAM_DATAWIDTH_10)) ||
> -	    (mt9m001->datawidth != 9  && (width_flag == SOCAM_DATAWIDTH_9)) ||
> -	    (mt9m001->datawidth != 8  && (width_flag == SOCAM_DATAWIDTH_8))) {
> -		/* Well, we actually only can do 10 or 8 bits... */
> -		if (width_flag == SOCAM_DATAWIDTH_9)
> -			return -EINVAL;
> -		ret = bus_switch_act(mt9m001,
> -				     width_flag == SOCAM_DATAWIDTH_8);
> -		if (ret < 0)
> -			return ret;
> -
> -		mt9m001->datawidth = width_flag == SOCAM_DATAWIDTH_8 ? 8 : 10;
> -	}
> +	if (icl->set_bus_param)
> +		return icl->set_bus_param(&mt9m001->client->dev,
> +				flags & SOCAM_DATAWIDTH_MASK);

Not quite. Look at the original code. If no change is requested - just 
return 0. If a change is requested, but switching is impossible - return 
an error - and this is not, what you are doing in 2/4, please fix. So, you 
might still want to preserve ".datawidth" for the verification.

Calls to camera-device ->query_bus_param() and ->set_bus_param() methods 
are currently internal to specific host drivers. So, it is better to be 
prepared to handle invalid or unexpected parameters.

>  
>  	return 0;
>  }
> @@ -274,12 +200,15 @@ static unsigned long mt9m001_query_bus_param(struct soc_camera_device *icd)
>  	struct mt9m001 *mt9m001 = container_of(icd, struct mt9m001, icd);
>  	struct soc_camera_link *icl = mt9m001->client->dev.platform_data;
>  	/* MT9M001 has all capture_format parameters fixed */
> -	unsigned long flags = SOCAM_DATAWIDTH_10 | SOCAM_PCLK_SAMPLE_RISING |
> +	unsigned long flags = SOCAM_PCLK_SAMPLE_RISING |
>  		SOCAM_HSYNC_ACTIVE_HIGH | SOCAM_VSYNC_ACTIVE_HIGH |
>  		SOCAM_MASTER;
>  
> -	if (bus_switch_possible(mt9m001))
> -		flags |= SOCAM_DATAWIDTH_8;
> +	if (icl->query_bus_param)
> +		flags |= icl->query_bus_param(&mt9m001->client->dev) &
> +			SOCAM_DATAWIDTH_MASK;
> +	else
> +		flags |= SOCAM_DATAWIDTH_10;
>  
>  	return soc_camera_apply_sensor_flags(icl, flags);
>  }
> @@ -583,6 +512,7 @@ static int mt9m001_video_probe(struct soc_camera_device *icd)
>  	struct soc_camera_link *icl = mt9m001->client->dev.platform_data;
>  	s32 data;
>  	int ret;
> +	unsigned long flags;
>  
>  	/* We must have a parent by now. And it cannot be a wrong one.
>  	 * So this entire test is completely redundant. */
> @@ -603,18 +533,10 @@ static int mt9m001_video_probe(struct soc_camera_device *icd)
>  	case 0x8421:
>  		mt9m001->model = V4L2_IDENT_MT9M001C12ST;
>  		icd->formats = mt9m001_colour_formats;
> -		if (gpio_is_valid(icl->gpio))
> -			icd->num_formats = ARRAY_SIZE(mt9m001_colour_formats);
> -		else
> -			icd->num_formats = 1;
>  		break;
>  	case 0x8431:
>  		mt9m001->model = V4L2_IDENT_MT9M001C12STM;
>  		icd->formats = mt9m001_monochrome_formats;
> -		if (gpio_is_valid(icl->gpio))
> -			icd->num_formats = ARRAY_SIZE(mt9m001_monochrome_formats);
> -		else
> -			icd->num_formats = 1;
>  		break;
>  	default:
>  		ret = -ENODEV;
> @@ -623,6 +545,25 @@ static int mt9m001_video_probe(struct soc_camera_device *icd)
>  		goto ei2c;
>  	}
>  
> +	icd->num_formats = 0;
> +
> +	/* This is a 10bit sensor, so by default we only allow 10bit.
> +	 * The platform may support different bus widths due to
> +	 * different routing of the data lines.
> +	 */
> +	if (icl->query_bus_param)
> +		flags = icl->query_bus_param(&mt9m001->client->dev);
> +	else
> +		flags = SOCAM_DATAWIDTH_10;
> +
> +	if (flags & SOCAM_DATAWIDTH_10)
> +		icd->num_formats++;
> +	else
> +		icd->formats++;
> +
> +	if (flags & SOCAM_DATAWIDTH_8)
> +		icd->num_formats++;
> +
>  	dev_info(&icd->dev, "Detected a MT9M001 chip ID %x (%s)\n", data,
>  		 data == 0x8431 ? "C12STM" : "C12ST");
>  
> @@ -688,18 +629,10 @@ static int mt9m001_probe(struct i2c_client *client,
>  	icd->height_max	= 1024;
>  	icd->y_skip_top	= 1;
>  	icd->iface	= icl->bus_id;
> -	/* Default datawidth - this is the only width this camera (normally)
> -	 * supports. It is only with extra logic that it can support
> -	 * other widths. Therefore it seems to be a sensible default. */
> -	mt9m001->datawidth = 10;
>  	/* Simulated autoexposure. If enabled, we calculate shutter width
>  	 * ourselves in the driver based on vertical blanking and frame width */
>  	mt9m001->autoexposure = 1;
>  
> -	ret = bus_switch_request(mt9m001, icl);
> -	if (ret)
> -		goto eswinit;
> -
>  	ret = soc_camera_device_register(icd);
>  	if (ret)
>  		goto eisdr;
> @@ -707,8 +640,6 @@ static int mt9m001_probe(struct i2c_client *client,
>  	return 0;
>  
>  eisdr:
> -	bus_switch_release(mt9m001);
> -eswinit:
>  	kfree(mt9m001);
>  	return ret;
>  }
> @@ -718,7 +649,6 @@ static int mt9m001_remove(struct i2c_client *client)
>  	struct mt9m001 *mt9m001 = i2c_get_clientdata(client);
>  
>  	soc_camera_device_unregister(&mt9m001->icd);
> -	bus_switch_release(mt9m001);
>  	kfree(mt9m001);
>  
>  	return 0;
> -- 
> 1.5.6.5
> 

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
