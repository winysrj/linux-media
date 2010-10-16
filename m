Return-path: <mchehab@pedra>
Received: from casper.infradead.org ([85.118.1.10]:42075 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750979Ab0JPEXt (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 16 Oct 2010 00:23:49 -0400
Message-ID: <4CB928B9.6010904@infradead.org>
Date: Sat, 16 Oct 2010 01:23:21 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
MIME-Version: 1.0
To: Daniel Drake <dsd@laptop.org>
CC: corbet@lwn.net, linux-media@vger.kernel.org
Subject: Re: [PATCH 3/3] ov7670: Support customization of clock speed
References: <20101008210433.126649D401B@zog.reactivated.net>
In-Reply-To: <20101008210433.126649D401B@zog.reactivated.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Em 08-10-2010 18:04, Daniel Drake escreveu:
> For accurate frame rate limiting, we need to know the speed of the external
> clock wired into the ov7670 chip.
> 
> Add a module parameter so that the user can specify this information.
> And add DMI detection for appropriate clock speeds on the OLPC XO-1 and
> XO-1.5 laptops. If specified, the module parameter wins over whatever we
> might have set through the DMI table.
> 
> Based on earlier work by Jonathan Corbet.

There's just one small checkpatch error:

ERROR: do not initialise statics to 0 or NULL
#51: FILE: drivers/media/video/ov7670.c:40:
+static bool clock_speed_from_param = false;

Instead of fixing the warning, I would just try to avoid the extra static
symbol, by simply not initializing clock_speed.

Btw, what happens if a machine have two ov7670 sensors, maybe connected
to two different bridges, at different clock speeds? The better would be have
the clock_speed parameter on a per-device struct, instead of using it 
on one global static var. 

At m9v011, I had to do something like that, specifying the xtal connected 
to the device. I suspect that this is basically the same thing you're
trying to do at ov7670, but adding another XO-specific hack.

There, I used .s_config callback to set a per-device config, and added
the logic to adjust the xtal clock at the bridge driver. The bridge driver
(in this case, em28xx) just does:

	if (dev->em28xx_sensor == EM28XX_MT9V011) {
		struct v4l2_subdev *sd;

		sd = v4l2_i2c_new_subdev(&dev->v4l2_dev,
			 &dev->i2c_adap, "mt9v011", "mt9v011", 0, mt9v011_addrs);
		v4l2_subdev_call(sd, core, s_config, 0, &dev->sensor_xtal);
	}

The better would be to do the same for ov7670: move the DMI check code to 
the cafe-ccic, where you should add the OLPC specific bits, and pass a 
s_config call specifying the xtal speed to the sensor driver.

This removes completely the need of passing extra parameters to the driver.




> 
> Signed-off-by: Daniel Drake <dsd@laptop.org>
> ---
>  drivers/media/video/ov7670.c |   71 ++++++++++++++++++++++++++++++++++++-----
>  1 files changed, 62 insertions(+), 9 deletions(-)
> 
> diff --git a/drivers/media/video/ov7670.c b/drivers/media/video/ov7670.c
> index 9fffcdd..c4d9ed0 100644
> --- a/drivers/media/video/ov7670.c
> +++ b/drivers/media/video/ov7670.c
> @@ -16,6 +16,7 @@
>  #include <linux/i2c.h>
>  #include <linux/delay.h>
>  #include <linux/videodev2.h>
> +#include <linux/dmi.h>
>  #include <media/v4l2-device.h>
>  #include <media/v4l2-chip-ident.h>
>  #include <media/v4l2-mediabus.h>
> @@ -30,6 +31,19 @@ module_param(debug, bool, 0644);
>  MODULE_PARM_DESC(debug, "Debug level (0-1)");
>  
>  /*
> + * What is our fastest frame rate?  It's a function of how the chip
> + * is clocked, and this is an external clock, so we don't know. If we have
> + * a DMI entry describing the platform, use it. If not, assume 30. In both
> + * cases, accept override from a module parameter.
> + */
> +static int clock_speed = 30;
> +static bool clock_speed_from_param = false;
> +static int set_clock_speed_from_param(const char *val, struct kernel_param *kp);
> +module_param_call(clock_speed, set_clock_speed_from_param, param_get_int,
> +		  &clock_speed, 0440);
> +MODULE_PARM_DESC(clock_speed, "External clock speed (Hz)");
> +
> +/*
>   * Basic window sizes.  These probably belong somewhere more globally
>   * useful.
>   */
> @@ -43,11 +57,6 @@ MODULE_PARM_DESC(debug, "Debug level (0-1)");
>  #define	QCIF_HEIGHT	144
>  
>  /*
> - * Our nominal (default) frame rate.
> - */
> -#define OV7670_FRAME_RATE 30
> -
> -/*
>   * The 7670 sits on i2c with ID 0x42
>   */
>  #define OV7670_I2C_ADDR 0x42
> @@ -188,6 +197,44 @@ MODULE_PARM_DESC(debug, "Debug level (0-1)");
>  #define REG_HAECC7	0xaa	/* Hist AEC/AGC control 7 */
>  #define REG_BD60MAX	0xab	/* 60hz banding step limit */
>  
> +static int set_clock_speed_from_param(const char *val, struct kernel_param *kp)
> +{
> +	int ret = param_set_int(val, kp);
> +	if (ret == 0)
> +		clock_speed_from_param = true;
> +	return ret;
> +}
> +
> +static int __init set_clock_speed_from_dmi(const struct dmi_system_id *dmi)
> +{
> +	if (clock_speed_from_param)
> +		return 0; /* module param beats DMI */
> +
> +	clock_speed = (int) dmi->driver_data;
> +	return 0;
> +}
> +
> +static const struct dmi_system_id __initconst dmi_clock_speeds[] = {
> +	{
> +		.callback = set_clock_speed_from_dmi,
> +		.driver_data = (void *) 45,
> +		.matches = {
> +			DMI_MATCH(DMI_SYS_VENDOR, "OLPC"),
> +			DMI_MATCH(DMI_PRODUCT_NAME, "XO"),
> +			DMI_MATCH(DMI_PRODUCT_VERSION, "1"),
> +		},
> +	},
> +	{
> +		.callback = set_clock_speed_from_dmi,
> +		.driver_data = (void *) 90,
> +		.matches = {
> +			DMI_MATCH(DMI_SYS_VENDOR, "OLPC"),
> +			DMI_MATCH(DMI_PRODUCT_NAME, "XO"),
> +			DMI_MATCH(DMI_PRODUCT_VERSION, "1.5"),
> +		},
> +	},
> +	{ }
> +};
>  
>  /*
>   * Information we maintain about a known sensor.
> @@ -861,7 +908,7 @@ static int ov7670_g_parm(struct v4l2_subdev *sd, struct v4l2_streamparm *parms)
>  	memset(cp, 0, sizeof(struct v4l2_captureparm));
>  	cp->capability = V4L2_CAP_TIMEPERFRAME;
>  	cp->timeperframe.numerator = 1;
> -	cp->timeperframe.denominator = OV7670_FRAME_RATE;
> +	cp->timeperframe.denominator = clock_speed;
>  	if ((info->clkrc & CLK_EXT) == 0 && (info->clkrc & CLK_SCALE) > 1)
>  		cp->timeperframe.denominator /= (info->clkrc & CLK_SCALE);
>  	return 0;
> @@ -882,14 +929,14 @@ static int ov7670_s_parm(struct v4l2_subdev *sd, struct v4l2_streamparm *parms)
>  	if (tpf->numerator == 0 || tpf->denominator == 0)
>  		div = 1;  /* Reset to full rate */
>  	else
> -		div = (tpf->numerator*OV7670_FRAME_RATE)/tpf->denominator;
> +		div = (tpf->numerator*clock_speed)/tpf->denominator;
>  	if (div == 0)
>  		div = 1;
>  	else if (div > CLK_SCALE)
>  		div = CLK_SCALE;
>  	info->clkrc = (info->clkrc & 0x80) | div;
>  	tpf->numerator = 1;
> -	tpf->denominator = OV7670_FRAME_RATE/div;
> +	tpf->denominator = clock_speed/div;
>  	return ov7670_write(sd, REG_CLKRC, info->clkrc);
>  }
>  
> @@ -1510,10 +1557,15 @@ static int ov7670_probe(struct i2c_client *client,
>  	}
>  	v4l_info(client, "chip found @ 0x%02x (%s)\n",
>  			client->addr << 1, client->adapter->name);
> +	/*
> +	 * Make sure the clock speed is rational.
> +	 */
> +	if (clock_speed < 1 || clock_speed > 100)
> +		clock_speed = 30;
>  
>  	info->fmt = &ov7670_formats[0];
>  	info->sat = 128;	/* Review this */
> -	info->clkrc = 1;	/* 30fps */
> +	info->clkrc = clock_speed / 30;
>  
>  	return 0;
>  }
> @@ -1546,6 +1598,7 @@ static struct i2c_driver ov7670_driver = {
>  
>  static __init int init_ov7670(void)
>  {
> +	dmi_check_system(dmi_clock_speeds);
>  	return i2c_add_driver(&ov7670_driver);
>  }
>  

