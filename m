Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:46637 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1758032AbZKDXxj (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 4 Nov 2009 18:53:39 -0500
Date: Thu, 5 Nov 2009 00:53:46 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Antonio Ospite <ospite@studenti.unina.it>
cc: linux-arm-kernel@lists.infradead.org,
	Eric Miao <eric.y.miao@gmail.com>,
	openezx-devel@lists.openezx.org, Bart Visscher <bartv@thisnet.nl>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PATCH 1/3 v2] ezx: Add camera support for A780 and A910 EZX
 phones
In-Reply-To: <1257367650-15056-1-git-send-email-ospite@studenti.unina.it>
Message-ID: <Pine.LNX.4.64.0911050040160.4837@axis700.grange>
References: <f17812d70911040119g6eb1f254pa78dd8519afef61d@mail.gmail.com>
 <1257367650-15056-1-git-send-email-ospite@studenti.unina.it>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, 4 Nov 2009, Antonio Ospite wrote:

> Signed-off-by: Antonio Ospite <ospite@studenti.unina.it>
> Signed-off-by: Bart Visscher <bartv@thisnet.nl>

Is this patch going via Bart? Or should this be an Acked-by?

> ---
> 
> Changes since previous version:
>   Addressed all the comments from Eric and Guennadi.

I said I still wanted to have a better look at it, so, basically, I just 
think you have a typo in two comments:

> 
> CAM_RST gpios are different for different platform generations, as also
> shown in current MFP pins setup.
> 
> 
>  arch/arm/mach-pxa/ezx.c |  164 +++++++++++++++++++++++++++++++++++++++++++++++
>  1 files changed, 164 insertions(+), 0 deletions(-)
> 
> diff --git a/arch/arm/mach-pxa/ezx.c b/arch/arm/mach-pxa/ezx.c
> index 588b265..7cfd633 100644
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
> @@ -683,8 +690,85 @@ static struct platform_device a780_gpio_keys = {
>  	},
>  };
>  
> +/* camera */
> +static int a780_pxacamera_init(struct device *dev)
> +{
> +	int err;
> +
> +	/*
> +	 * GPIO50_nCAM_EN is active low
> +	 * GPIO19_GEN1_CAM_RST is active high
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
> +	gpio_direction_output(GPIO50_nCAM_EN, 0);
> +	gpio_direction_output(GPIO19_GEN1_CAM_RST, 1);

Don't understand this, are you sure your comments are correct? This would 
mean, that in init() you enable the camera and hold it in reset.

> +
> +	return 0;
> +
> +fail_gpio_cam_rst:
> +	gpio_free(GPIO50_nCAM_EN);
> +fail:
> +	return err;
> +}
> +
> +static int a780_pxacamera_power(struct device *dev, int on)
> +{
> +	gpio_set_value(GPIO50_nCAM_EN, !on);

This agrees with the comment above, but then why do you enable it 
immediately in init?

> +	return 0;
> +}
> +
> +static int a780_pxacamera_reset(struct device *dev)
> +{
> +	gpio_set_value(GPIO19_GEN1_CAM_RST, 0);
> +	msleep(10);
> +	gpio_set_value(GPIO19_GEN1_CAM_RST, 1);

This, however, seems to contradict the comment and confirm the code above 
- looks like your reset pin is active low too?

> +
> +	return 0;
> +}
> +
> +struct pxacamera_platform_data a780_pxacamera_platform_data = {
> +	.init	= a780_pxacamera_init,
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

Do you have schematics or have you found this out experimentally? What 
happens if you don't invert pclk?

> +	.i2c_adapter_id = 0,
> +	.board_info     = &a780_camera_i2c_board_info,
> +	.module_name    = "mt9m111",
> +	.power          = a780_pxacamera_power,
> +	.reset          = a780_pxacamera_reset,
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
> +	&a780_camera,
>  };
>  
>  static void __init a780_init(void)
> @@ -699,6 +783,8 @@ static void __init a780_init(void)
>  
>  	pxa_set_keypad_info(&a780_keypad_platform_data);
>  
> +	pxa_set_camera_info(&a780_pxacamera_platform_data);
> +
>  	platform_add_devices(ARRAY_AND_SIZE(ezx_devices));
>  	platform_add_devices(ARRAY_AND_SIZE(a780_devices));
>  }
> @@ -864,8 +950,84 @@ static struct platform_device a910_gpio_keys = {
>  	},
>  };
>  
> +/* camera */
> +static int a910_pxacamera_init(struct device *dev)
> +{
> +	int err;
> +
> +	/*
> +	 * GPIO50_nCAM_EN is active low
> +	 * GPIO28_GEN2_CAM_RST is active high
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
> +	gpio_direction_output(GPIO50_nCAM_EN, 0);
> +	gpio_direction_output(GPIO28_GEN2_CAM_RST, 1);

ditto

> +
> +	return 0;
> +
> +fail_gpio_cam_rst:
> +	gpio_free(GPIO50_nCAM_EN);
> +fail:
> +	return err;
> +}
> +
> +static int a910_pxacamera_power(struct device *dev, int on)
> +{
> +	gpio_set_value(GPIO50_nCAM_EN, !on);
> +	return 0;
> +}
> +
> +static int a910_pxacamera_reset(struct device *dev)
> +{
> +	gpio_set_value(GPIO28_GEN2_CAM_RST, 0);
> +	msleep(10);
> +	gpio_set_value(GPIO28_GEN2_CAM_RST, 1);
> +
> +	return 0;
> +}
> +
> +struct pxacamera_platform_data a910_pxacamera_platform_data = {
> +	.init	= a910_pxacamera_init,
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
> +	.power          = a910_pxacamera_power,
> +	.reset          = a910_pxacamera_reset,
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
> +	&a910_camera,
>  };
>  
>  static void __init a910_init(void)
> @@ -880,6 +1042,8 @@ static void __init a910_init(void)
>  
>  	pxa_set_keypad_info(&a910_keypad_platform_data);
>  
> +	pxa_set_camera_info(&a910_pxacamera_platform_data);
> +
>  	platform_add_devices(ARRAY_AND_SIZE(ezx_devices));
>  	platform_add_devices(ARRAY_AND_SIZE(a910_devices));
>  }
> -- 
> 1.6.5.2
> 

A general question for the ezx.c: wouldn't it be better to convert that 
full-of-ifdef's file to a mach-pxa/ezx/ directory?

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
