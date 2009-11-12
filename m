Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:43960 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1753739AbZKLUtd (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 12 Nov 2009 15:49:33 -0500
Date: Thu, 12 Nov 2009 21:49:33 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Antonio Ospite <ospite@studenti.unina.it>
cc: linux-arm-kernel@lists.infradead.org,
	linux-arm-kernel@lists.infradead.org,
	Eric Miao <eric.y.miao@gmail.com>,
	openezx-devel@lists.openezx.org, Bart Visscher <bartv@thisnet.nl>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PATCH 1/3 v4] Add camera support for A780 and A910 EZX phones
In-Reply-To: <1258037224-6290-1-git-send-email-ospite@studenti.unina.it>
Message-ID: <Pine.LNX.4.64.0911122144380.15708@axis700.grange>
References: <Pine.LNX.4.64.0911111857430.4072@axis700.grange>
 <1258037224-6290-1-git-send-email-ospite@studenti.unina.it>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, 12 Nov 2009, Antonio Ospite wrote:

> Signed-off-by: Bart Visscher <bartv@thisnet.nl>
> Signed-off-by: Antonio Ospite <ospite@studenti.unina.it>

Acked-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>

Thanks
Guennadi

> ---
> Changes since v3:
>  - Check {a780,a910}_camera_init() return value, and register camera
>    conditionally.
> 
>  arch/arm/mach-pxa/ezx.c |  174 +++++++++++++++++++++++++++++++++++++++++++++-
>  1 files changed, 170 insertions(+), 4 deletions(-)
> 
> diff --git a/arch/arm/mach-pxa/ezx.c b/arch/arm/mach-pxa/ezx.c
> index 588b265..46c32cf 100644
> --- a/arch/arm/mach-pxa/ezx.c
> +++ b/arch/arm/mach-pxa/ezx.c
> @@ -17,8 +17,11 @@
>  #include <linux/delay.h>
>  #include <linux/pwm_backlight.h>
>  #include <linux/input.h>
> +#include <linux/gpio.h>
>  #include <linux/gpio_keys.h>
>  
> +#include <media/soc_camera.h>
> +
>  #include <asm/setup.h>
>  #include <asm/mach-types.h>
>  #include <asm/mach/arch.h>
> @@ -29,6 +32,7 @@
>  #include <plat/i2c.h>
>  #include <mach/hardware.h>
>  #include <mach/pxa27x_keypad.h>
> +#include <mach/camera.h>
>  
>  #include "devices.h"
>  #include "generic.h"
> @@ -38,6 +42,9 @@
>  #define GPIO15_A910_FLIP_LID 		15
>  #define GPIO12_E680_LOCK_SWITCH 	12
>  #define GPIO15_E6_LOCK_SWITCH 		15
> +#define GPIO50_nCAM_EN			50
> +#define GPIO19_GEN1_CAM_RST		19
> +#define GPIO28_GEN2_CAM_RST		28
>  
>  static struct platform_pwm_backlight_data ezx_backlight_data = {
>  	.pwm_id		= 0,
> @@ -191,8 +198,8 @@ static unsigned long gen1_pin_config[] __initdata = {
>  	GPIO94_CIF_DD_5,
>  	GPIO17_CIF_DD_6,
>  	GPIO108_CIF_DD_7,
> -	GPIO50_GPIO,				/* CAM_EN */
> -	GPIO19_GPIO,				/* CAM_RST */
> +	GPIO50_GPIO | MFP_LPM_DRIVE_HIGH,	/* CAM_EN */
> +	GPIO19_GPIO | MFP_LPM_DRIVE_HIGH,	/* CAM_RST */
>  
>  	/* EMU */
>  	GPIO120_GPIO,				/* EMU_MUX1 */
> @@ -248,8 +255,8 @@ static unsigned long gen2_pin_config[] __initdata = {
>  	GPIO48_CIF_DD_5,
>  	GPIO93_CIF_DD_6,
>  	GPIO12_CIF_DD_7,
> -	GPIO50_GPIO,				/* CAM_EN */
> -	GPIO28_GPIO,				/* CAM_RST */
> +	GPIO50_GPIO | MFP_LPM_DRIVE_HIGH,	/* CAM_EN */
> +	GPIO28_GPIO | MFP_LPM_DRIVE_HIGH,	/* CAM_RST */
>  	GPIO17_GPIO,				/* CAM_FLASH */
>  };
>  #endif
> @@ -683,6 +690,81 @@ static struct platform_device a780_gpio_keys = {
>  	},
>  };
>  
> +/* camera */
> +static int a780_camera_init(void)
> +{
> +	int err;
> +
> +	/*
> +	 * GPIO50_nCAM_EN is active low
> +	 * GPIO19_GEN1_CAM_RST is active on rising edge
> +	 */
> +	err = gpio_request(GPIO50_nCAM_EN, "nCAM_EN");
> +	if (err) {
> +		pr_err("%s: Failed to request nCAM_EN\n", __func__);
> +		goto fail;
> +	}
> +
> +	err = gpio_request(GPIO19_GEN1_CAM_RST, "CAM_RST");
> +	if (err) {
> +		pr_err("%s: Failed to request CAM_RST\n", __func__);
> +		goto fail_gpio_cam_rst;
> +	}
> +
> +	gpio_direction_output(GPIO50_nCAM_EN, 1);
> +	gpio_direction_output(GPIO19_GEN1_CAM_RST, 0);
> +
> +	return 0;
> +
> +fail_gpio_cam_rst:
> +	gpio_free(GPIO50_nCAM_EN);
> +fail:
> +	return err;
> +}
> +
> +static int a780_camera_power(struct device *dev, int on)
> +{
> +	gpio_set_value(GPIO50_nCAM_EN, !on);
> +	return 0;
> +}
> +
> +static int a780_camera_reset(struct device *dev)
> +{
> +	gpio_set_value(GPIO19_GEN1_CAM_RST, 0);
> +	msleep(10);
> +	gpio_set_value(GPIO19_GEN1_CAM_RST, 1);
> +
> +	return 0;
> +}
> +
> +struct pxacamera_platform_data a780_pxacamera_platform_data = {
> +	.flags  = PXA_CAMERA_MASTER | PXA_CAMERA_DATAWIDTH_8 |
> +		PXA_CAMERA_PCLK_EN | PXA_CAMERA_MCLK_EN,
> +	.mclk_10khz = 5000,
> +};
> +
> +static struct i2c_board_info a780_camera_i2c_board_info = {
> +	I2C_BOARD_INFO("mt9m111", 0x5d),
> +};
> +
> +static struct soc_camera_link a780_iclink = {
> +	.bus_id         = 0,
> +	.flags          = SOCAM_SENSOR_INVERT_PCLK,
> +	.i2c_adapter_id = 0,
> +	.board_info     = &a780_camera_i2c_board_info,
> +	.module_name    = "mt9m111",
> +	.power          = a780_camera_power,
> +	.reset          = a780_camera_reset,
> +};
> +
> +static struct platform_device a780_camera = {
> +	.name   = "soc-camera-pdrv",
> +	.id     = 0,
> +	.dev    = {
> +		.platform_data = &a780_iclink,
> +	},
> +};
> +
>  static struct platform_device *a780_devices[] __initdata = {
>  	&a780_gpio_keys,
>  };
> @@ -699,6 +781,11 @@ static void __init a780_init(void)
>  
>  	pxa_set_keypad_info(&a780_keypad_platform_data);
>  
> +	if (a780_camera_init() == 0) {
> +		pxa_set_camera_info(&a780_pxacamera_platform_data);
> +		platform_device_register(&a780_camera);
> +	}
> +
>  	platform_add_devices(ARRAY_AND_SIZE(ezx_devices));
>  	platform_add_devices(ARRAY_AND_SIZE(a780_devices));
>  }
> @@ -864,6 +951,80 @@ static struct platform_device a910_gpio_keys = {
>  	},
>  };
>  
> +/* camera */
> +static int a910_camera_init(void)
> +{
> +	int err;
> +
> +	/*
> +	 * GPIO50_nCAM_EN is active low
> +	 * GPIO28_GEN2_CAM_RST is active on rising edge
> +	 */
> +	err = gpio_request(GPIO50_nCAM_EN, "nCAM_EN");
> +	if (err) {
> +		pr_err("%s: Failed to request nCAM_EN\n", __func__);
> +		goto fail;
> +	}
> +
> +	err = gpio_request(GPIO28_GEN2_CAM_RST, "CAM_RST");
> +	if (err) {
> +		pr_err("%s: Failed to request CAM_RST\n", __func__);
> +		goto fail_gpio_cam_rst;
> +	}
> +
> +	gpio_direction_output(GPIO50_nCAM_EN, 1);
> +	gpio_direction_output(GPIO28_GEN2_CAM_RST, 0);
> +
> +	return 0;
> +
> +fail_gpio_cam_rst:
> +	gpio_free(GPIO50_nCAM_EN);
> +fail:
> +	return err;
> +}
> +
> +static int a910_camera_power(struct device *dev, int on)
> +{
> +	gpio_set_value(GPIO50_nCAM_EN, !on);
> +	return 0;
> +}
> +
> +static int a910_camera_reset(struct device *dev)
> +{
> +	gpio_set_value(GPIO28_GEN2_CAM_RST, 0);
> +	msleep(10);
> +	gpio_set_value(GPIO28_GEN2_CAM_RST, 1);
> +
> +	return 0;
> +}
> +
> +struct pxacamera_platform_data a910_pxacamera_platform_data = {
> +	.flags  = PXA_CAMERA_MASTER | PXA_CAMERA_DATAWIDTH_8 |
> +		PXA_CAMERA_PCLK_EN | PXA_CAMERA_MCLK_EN,
> +	.mclk_10khz = 5000,
> +};
> +
> +static struct i2c_board_info a910_camera_i2c_board_info = {
> +	I2C_BOARD_INFO("mt9m111", 0x5d),
> +};
> +
> +static struct soc_camera_link a910_iclink = {
> +	.bus_id         = 0,
> +	.i2c_adapter_id = 0,
> +	.board_info     = &a910_camera_i2c_board_info,
> +	.module_name    = "mt9m111",
> +	.power          = a910_camera_power,
> +	.reset          = a910_camera_reset,
> +};
> +
> +static struct platform_device a910_camera = {
> +	.name   = "soc-camera-pdrv",
> +	.id     = 0,
> +	.dev    = {
> +		.platform_data = &a910_iclink,
> +	},
> +};
> +
>  static struct platform_device *a910_devices[] __initdata = {
>  	&a910_gpio_keys,
>  };
> @@ -880,6 +1041,11 @@ static void __init a910_init(void)
>  
>  	pxa_set_keypad_info(&a910_keypad_platform_data);
>  
> +	if (a910_camera_init() == 0) {
> +		pxa_set_camera_info(&a910_pxacamera_platform_data);
> +		platform_device_register(&a910_camera);
> +	}
> +
>  	platform_add_devices(ARRAY_AND_SIZE(ezx_devices));
>  	platform_add_devices(ARRAY_AND_SIZE(a910_devices));
>  }
> -- 
> tg: (639a58f..) ezx/mach/camera_new (depends on: master)
> 

---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
