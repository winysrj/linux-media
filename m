Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr8.xs4all.nl ([194.109.24.28]:2109 "EHLO
	smtp-vbr8.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751723AbZF0MTt (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 27 Jun 2009 08:19:49 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: m-karicheri2@ti.com
Subject: Re: [PATCH 3/3 - v0] davinci: platform changes to support vpfe camera capture
Date: Sat, 27 Jun 2009 14:19:43 +0200
Cc: davinci-linux-open-source@linux.davincidsp.com,
	linux-media@vger.kernel.org, khilman@deeprootsystems.com
References: <1246053948-8371-1-git-send-email-m-karicheri2@ti.com>
In-Reply-To: <1246053948-8371-1-git-send-email-m-karicheri2@ti.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200906271419.43942.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Saturday 27 June 2009 00:05:48 m-karicheri2@ti.com wrote:
> From: Muralidharan Karicheri <m-karicheri2@ti.com>
> 
> Following are the changes:-
> 	1) moved i2c board specific part to sub device configuration
> 	structure so that sub device can be loaded from vpfe capture
> 	using the new v4l2_i2c_new_subdev_board() api
> 	2) adding mt9t031 sub device configuration information for
> 	DM355 as part of camera capture support to vpfe capture
> 	3) adding support to setup raw data path and i2c switch
> 	when capturing from mt9t031
> 
> NOTE: Depends on v3 version of vpfe capture driver patch
> 
> Mandatory Reviewers: Kevin Hilman <khilman@deeprootsystems.com>
> Mandatory Reviewers: Hans Verkuil <hverkuil@xs4all.nl>
> 
> Signed-off-by: Muralidharan Karicheri <m-karicheri2@ti.com>
> ---
> Applies to DaVinci GIT Tree
> 
>  arch/arm/mach-davinci/board-dm355-evm.c  |  208 ++++++++++++++++++++++++++++--
>  arch/arm/mach-davinci/board-dm644x-evm.c |   24 ++--
>  2 files changed, 210 insertions(+), 22 deletions(-)
> 
> diff --git a/arch/arm/mach-davinci/board-dm355-evm.c b/arch/arm/mach-davinci/board-dm355-evm.c
> index 513be53..a781ca2 100644
> --- a/arch/arm/mach-davinci/board-dm355-evm.c
> +++ b/arch/arm/mach-davinci/board-dm355-evm.c
> @@ -136,10 +136,66 @@ static void dm355evm_mmcsd_gpios(unsigned gpio)
>  	dm355evm_mmc_gpios = gpio;
>  }
>  
> -static struct tvp514x_platform_data tvp5146_pdata = {
> -	.clk_polarity = 0,
> -	.hs_polarity = 1,
> -	.vs_polarity = 1
> +/*
> + * MSP430 supports RTC, card detection, input from IR remote, and
> + * a bit more.  It triggers interrupts on GPIO(7) from pressing
> + * buttons on the IR remote, and for card detect switches.
> + */
> +static struct i2c_client *dm355evm_msp;
> +
> +static int dm355evm_msp_probe(struct i2c_client *client,
> +		const struct i2c_device_id *id)
> +{
> +	dm355evm_msp = client;
> +	return 0;
> +}
> +
> +static int dm355evm_msp_remove(struct i2c_client *client)
> +{
> +	dm355evm_msp = NULL;
> +	return 0;
> +}
> +
> +static const struct i2c_device_id dm355evm_msp_ids[] = {
> +	{ "dm355evm_msp", 0, },
> +	{ /* end of list */ },
> +};
> +
> +static struct i2c_driver dm355evm_msp_driver = {
> +	.driver.name	= "dm355evm_msp",
> +	.id_table	= dm355evm_msp_ids,
> +	.probe		= dm355evm_msp_probe,
> +	.remove		= dm355evm_msp_remove,
> +};
> +
> +#define PCA9543A_I2C_ADDR       (0x73)
> +
> +static struct i2c_client *pca9543a;
> +
> +static int pca9543a_probe(struct i2c_client *client,
> +		const struct i2c_device_id *id)
> +{
> +	pca9543a = client;
> +	return 0;
> +}
> +
> +static int pca9543a_remove(struct i2c_client *client)
> +{
> +	pca9543a = NULL;
> +	return 0;
> +}
> +
> +static const struct i2c_device_id pca9543a_ids[] = {
> +	{ "PCA9543A", 0, },
> +	{ /* end of list */ },
> +};
> +
> +/* This is for i2c driver for the MT9T031 header i2c switch */
> +static struct i2c_driver pca9543a_driver = {
> +	.driver.name	= "PCA9543A",
> +	.id_table	= pca9543a_ids,
> +	.probe		= pca9543a_probe,
> +	.remove		= pca9543a_remove,
>  };
>  
>  static struct i2c_board_info dm355evm_i2c_info[] = {
> @@ -147,13 +203,22 @@ static struct i2c_board_info dm355evm_i2c_info[] = {
>  		.platform_data = dm355evm_mmcsd_gpios,
>  	},
>  	{
> -		I2C_BOARD_INFO("tvp5146", 0x5d),
> -		.platform_data = &tvp5146_pdata,
> +		I2C_BOARD_INFO("PCA9543A", 0x73),
>  	},
>  	/* { plus irq  }, */
>  	/* { I2C_BOARD_INFO("tlv320aic3x", 0x1b), }, */
>  };
>  
> +/* have_sensor() - Check if we have support for sensor interface */
> +static inline int have_sensor(void)
> +{
> +#ifdef CONFIG_SOC_CAMERA_MT9T031
> +	return 1;
> +#else
> +	return 0;
> +#endif
> +}
> +
>  static void __init evm_init_i2c(void)
>  {
>  	davinci_init_i2c(&i2c_pdata);
> @@ -161,9 +226,12 @@ static void __init evm_init_i2c(void)
>  	gpio_request(5, "dm355evm_msp");
>  	gpio_direction_input(5);
>  	dm355evm_i2c_info[0].irq = gpio_to_irq(5);
> -
> +	i2c_add_driver(&dm355evm_msp_driver);
> +	if (have_sensor())
> +		i2c_add_driver(&pca9543a_driver);
>  	i2c_register_board_info(1, dm355evm_i2c_info,
>  			ARRAY_SIZE(dm355evm_i2c_info));
> +
>  }
>  
>  static struct resource dm355evm_dm9000_rsrc[] = {
> @@ -190,6 +258,104 @@ static struct platform_device dm355evm_dm9000 = {
>  	.num_resources	= ARRAY_SIZE(dm355evm_dm9000_rsrc),
>  };
>  
> +/**
> + * dm355evm_enable_raw_data_path() - Enable/Disable raw data path
> + * @en: enable/disbale flag
> + */
> +static int dm355evm_enable_raw_data_path(int en)
> +{
> +	static char txbuf[2] = { 8, 0x80 };
> +	int status;
> +	struct i2c_msg msg = {
> +			.flags = 0,
> +			.len = 2,
> +			.buf = (void __force *)txbuf,
> +		};
> +
> +	if (!en)
> +		txbuf[1] = 0;
> +
> +	if (!dm355evm_msp)
> +		return -ENXIO;
> +
> +	msg.addr = dm355evm_msp->addr,
> +	/* turn on/off the raw data path through msp430 */
> +	status = i2c_transfer(dm355evm_msp->adapter, &msg, 1);
> +	return status;
> +}
> +
> +
> +/**
> + * dm355_enable_i2c_switch() - Enable/Disable I2C switch PCA9543A for sensor
> + * @en: enable/disbale flag
> + */
> +static int dm355evm_enable_i2c_switch(int en)
> +{
> +	static char val = 1;
> +	int status;
> +	struct i2c_msg msg = {
> +			.flags = 0,
> +			.len = 1,
> +			.buf = &val,
> +		};
> +
> +	if (!en)
> +		val = 0;
> +
> +	if (!pca9543a)
> +		return -ENXIO;
> +
> +	msg.addr = pca9543a->addr;
> +	/* turn i2 switch, pca9543a, on/off */

Typo: i2 -> i2c

> +	status = i2c_transfer(pca9543a->adapter, &msg, 1);
> +	return status;
> +}
> +
> +/**
> + * dm355evm_setup_video_input() - setup video data path and i2c
> + * @id: sub device id
> + */
> +static int dm355evm_setup_video_input(enum vpfe_subdev_id id)
> +{
> +	int ret;
> +
> +	switch (id) {
> +	case VPFE_SUBDEV_MT9T031:
> +	{
> +		ret = dm355evm_enable_raw_data_path(1);
> +		if (ret >= 0)
> +			ret = dm355evm_enable_i2c_switch(1);
> +		else
> +			/* switch off i2c switch since we failed */
> +			ret = dm355evm_enable_i2c_switch(0);
> +		break;
> +	}
> +	case VPFE_SUBDEV_TVP5146:
> +	{
> +		ret = dm355evm_enable_raw_data_path(0);
> +		break;
> +	}
> +	default:
> +		return -1;
> +	}
> +	return (ret >= 0 ? 0 : -1);

Why not return proper return codes?

> +}
> +
> +/* Inputs available at the TVP5146 */

Comment out of date: this array refers to the mt9t031.

> +static struct v4l2_input mt9t031_inputs[] = {
> +	{
> +		.index = 0,
> +		.name = "Camera",
> +		.type = V4L2_INPUT_TYPE_CAMERA,
> +	}
> +};
> +
> +static struct tvp514x_platform_data tvp5146_pdata = {
> +	.clk_polarity = 0,
> +	.hs_polarity = 1,
> +	.vs_polarity = 1
> +};
> +
>  #define TVP514X_STD_ALL	(V4L2_STD_NTSC | V4L2_STD_PAL)
>  /* Inputs available at the TVP5146 */
>  static struct v4l2_input tvp5146_inputs[] = {
> @@ -207,7 +373,7 @@ static struct v4l2_input tvp5146_inputs[] = {
>  	},
>  };
>  
> -/*
> +/**
>   * this is the route info for connecting each input to decoder
>   * ouput that goes to vpfe. There is a one to one correspondence
>   * with tvp5146_inputs
> @@ -225,8 +391,8 @@ static struct vpfe_route tvp5146_routes[] = {
>  
>  static struct vpfe_subdev_info vpfe_sub_devs[] = {
>  	{
> -		.name = "tvp5146",
> -		.grp_id = 0,
> +		.name = TVP514X_MODULE_NAME,
> +		.grp_id = VPFE_SUBDEV_TVP5146,
>  		.num_inputs = ARRAY_SIZE(tvp5146_inputs),
>  		.inputs = tvp5146_inputs,
>  		.routes = tvp5146_routes,
> @@ -236,6 +402,27 @@ static struct vpfe_subdev_info vpfe_sub_devs[] = {
>  			.hdpol = VPFE_PINPOL_POSITIVE,
>  			.vdpol = VPFE_PINPOL_POSITIVE,
>  		},
> +		.board_info = {
> +			I2C_BOARD_INFO("tvp5146", 0x5d),
> +			.platform_data = &tvp5146_pdata,
> +		},
> +	},
> +	{
> +		.name = "mt9t031",
> +		.camera = 1,
> +		.grp_id = VPFE_SUBDEV_MT9T031,
> +		.num_inputs = ARRAY_SIZE(mt9t031_inputs),
> +		.inputs = mt9t031_inputs,
> +		.ccdc_if_params = {
> +			.if_type = VPFE_RAW_BAYER,
> +			.hdpol = VPFE_PINPOL_POSITIVE,
> +			.vdpol = VPFE_PINPOL_POSITIVE,
> +		},
> +		.board_info = {
> +			I2C_BOARD_INFO("mt9t031", 0x5d),
> +			/* this is for PCLK rising edge */
> +			.platform_data = (void *)1,
> +		},
>  	}
>  };
>  
> @@ -244,6 +431,7 @@ static struct vpfe_config vpfe_cfg = {
>  	.sub_devs = vpfe_sub_devs,
>  	.card_name = "DM355 EVM",
>  	.ccdc = "DM355 CCDC",
> +	.setup_input = dm355evm_setup_video_input,
>  };
>  
>  static struct platform_device *davinci_evm_devices[] __initdata = {
> diff --git a/arch/arm/mach-davinci/board-dm644x-evm.c b/arch/arm/mach-davinci/board-dm644x-evm.c
> index 54f084b..310cd75 100644
> --- a/arch/arm/mach-davinci/board-dm644x-evm.c
> +++ b/arch/arm/mach-davinci/board-dm644x-evm.c
> @@ -196,6 +196,12 @@ static struct platform_device davinci_fb_device = {
>  	.num_resources = 0,
>  };
>  
> +static struct tvp514x_platform_data tvp5146_pdata = {
> +	.clk_polarity = 0,
> +	.hs_polarity = 1,
> +	.vs_polarity = 1
> +};
> +
>  #define TVP514X_STD_ALL	(V4L2_STD_NTSC | V4L2_STD_PAL)
>  /* Inputs available at the TVP5146 */
>  static struct v4l2_input tvp5146_inputs[] = {
> @@ -231,8 +237,8 @@ static struct vpfe_route tvp5146_routes[] = {
>  
>  static struct vpfe_subdev_info vpfe_sub_devs[] = {
>  	{
> -		.name = "tvp5146",
> -		.grp_id = 0,
> +		.name = TVP514X_MODULE_NAME,
> +		.grp_id = VPFE_SUBDEV_TVP5146,
>  		.num_inputs = ARRAY_SIZE(tvp5146_inputs),
>  		.inputs = tvp5146_inputs,
>  		.routes = tvp5146_routes,
> @@ -242,6 +248,10 @@ static struct vpfe_subdev_info vpfe_sub_devs[] = {
>  			.hdpol = VPFE_PINPOL_POSITIVE,
>  			.vdpol = VPFE_PINPOL_POSITIVE,
>  		},
> +		.board_info = {
> +			I2C_BOARD_INFO("tvp5146", 0x5d),
> +			.platform_data = &tvp5146_pdata,
> +		},
>  	},
>  };
>  
> @@ -504,12 +514,6 @@ static struct at24_platform_data eeprom_info = {
>  	.context	= (void *)0x7f00,
>  };
>  
> -static struct tvp514x_platform_data tvp5146_pdata = {
> -	.clk_polarity = 0,
> -	.hs_polarity = 1,
> -	.vs_polarity = 1
> -};
> -
>  /*
>   * MSP430 supports RTC, card detection, input from IR remote, and
>   * a bit more.  It triggers interrupts on GPIO(7) from pressing
> @@ -621,10 +625,6 @@ static struct i2c_board_info __initdata i2c_info[] =  {
>  		I2C_BOARD_INFO("24c256", 0x50),
>  		.platform_data	= &eeprom_info,
>  	},
> -	{
> -		I2C_BOARD_INFO("tvp5146", 0x5d),
> -		.platform_data = &tvp5146_pdata,
> -	},
>  	/* ALSO:
>  	 * - tvl320aic33 audio codec (0x1b)
>  	 */

Regards,

        Hans

-- 
Hans Verkuil - video4linux developer - sponsored by TANDBERG Telecom
