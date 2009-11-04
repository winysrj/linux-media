Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qy0-f174.google.com ([209.85.221.174]:54360 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751486AbZKDGiz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 4 Nov 2009 01:38:55 -0500
Received: by qyk4 with SMTP id 4so3273203qyk.33
        for <linux-media@vger.kernel.org>; Tue, 03 Nov 2009 22:39:00 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1257266734-28673-2-git-send-email-ospite@studenti.unina.it>
References: <1257266734-28673-1-git-send-email-ospite@studenti.unina.it>
	<1257266734-28673-2-git-send-email-ospite@studenti.unina.it>
From: Eric Miao <eric.y.miao@gmail.com>
Date: Wed, 4 Nov 2009 14:38:40 +0800
Message-ID: <f17812d70911032238i3ae6fa19g24720662b9079f24@mail.gmail.com>
Subject: Re: [PATCH 1/3] ezx: Add camera support for A780 and A910 EZX phones
To: Antonio Ospite <ospite@studenti.unina.it>
Cc: linux-arm-kernel@lists.infradead.org,
	openezx-devel@lists.openezx.org, Bart Visscher <bartv@thisnet.nl>,
	linux-media@vger.kernel.org,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Antonio,

Patch looks generally OK except for the MFP/GPIO usage, check my
comments below, thanks.

> +/* camera */
> +static int a780_pxacamera_init(struct device *dev)
> +{
> +       int err;
> +
> +       /*
> +        * GPIO50_GPIO is CAM_EN: active low
> +        * GPIO19_GPIO is CAM_RST: active high
> +        */
> +       err = gpio_request(MFP_PIN_GPIO50, "nCAM_EN");

Mmm... MFP != GPIO, so this probably should be written simply as:

#define GPIO_nCAM_EN	(50)

or (which tends to be more accurate but not necessary)

#define GPIO_nCAM_EN	mfp_to_gpio(MFP_PIN_GPIO50)

If platform matters, I suggest something like:

#define GPIO_A780_nCAM_EN	(50)
#define GPIO_A910_nCAM_EN	(<something else>)

...

	err = gpio_request(GPIO_nCAM_EN, "nCAM_EN");

> +       if (err) {
> +               pr_err("%s: Failed to request nCAM_EN\n", __func__);
> +               goto fail;
> +       }
> +
> +       err = gpio_request(MFP_PIN_GPIO19, "CAM_RST");

ditto

> +       if (err) {
> +               pr_err("%s: Failed to request CAM_RST\n", __func__);
> +               goto fail_gpio_cam_rst;
> +       }
> +
> +       gpio_direction_output(MFP_PIN_GPIO50, 0);
> +       gpio_direction_output(MFP_PIN_GPIO19, 1);
> +
> +       return 0;
> +
> +fail_gpio_cam_rst:
> +       gpio_free(MFP_PIN_GPIO50);
> +fail:
> +       return err;
> +}
> +
> +static int a780_pxacamera_power(struct device *dev, int on)
> +{
> +       gpio_set_value(MFP_PIN_GPIO50, on ? 0 : 1);

	gpio_set_value(GPIO_nCAM_EN, on ? 0 : 1);

> +
> +#if 0
> +       /*
> +        * This is reported to resolve the "vertical line in view finder"
> +        * issue (LIBff11930), in the original source code released by
> +        * Motorola, but we never experienced the problem, so we don't use
> +        * this for now.
> +        *
> +        * AP Kernel camera driver: set TC_MM_EN to low when camera is running
> +        * and TC_MM_EN to high when camera stops.
> +        *
> +        * BP Software: if TC_MM_EN is low, BP do not shut off 26M clock, but
> +        * BP can sleep itself.
> +        */
> +       gpio_set_value(MFP_PIN_GPIO99, on ? 0 : 1);
> +#endif

This is a little bit confusing - can we remove this for this stage?

> +
> +       return 0;
> +}
> +
> +static int a780_pxacamera_reset(struct device *dev)
> +{
> +       gpio_set_value(MFP_PIN_GPIO19, 0);
> +       msleep(10);
> +       gpio_set_value(MFP_PIN_GPIO19, 1);

better to define something like above:

#define GPIO_CAM_RESET	(19)

...

	gpio_set_value(GPIO_CAM_RESET, ...);

> +
> +       return 0;
> +}
> +
> +struct pxacamera_platform_data a780_pxacamera_platform_data = {
> +       .init   = a780_pxacamera_init,
> +       .flags  = PXA_CAMERA_MASTER | PXA_CAMERA_DATAWIDTH_8 |
> +               PXA_CAMERA_PCLK_EN | PXA_CAMERA_MCLK_EN,
> +       .mclk_10khz = 5000,
> +};
> +
> +static struct i2c_board_info a780_camera_i2c_board_info = {
> +       I2C_BOARD_INFO("mt9m111", 0x5d),
> +};
> +
> +static struct soc_camera_link a780_iclink = {
> +       .bus_id         = 0,
> +       .flags          = SOCAM_SENSOR_INVERT_PCLK,
> +       .i2c_adapter_id = 0,
> +       .board_info     = &a780_camera_i2c_board_info,
> +       .module_name    = "mt9m111",
> +       .power          = a780_pxacamera_power,
> +       .reset          = a780_pxacamera_reset,
> +};
> +
> +static struct platform_device a780_camera = {
> +       .name   = "soc-camera-pdrv",
> +       .id     = 0,
> +       .dev    = {
> +               .platform_data = &a780_iclink,
> +       },
> +};
> +
>  static struct platform_device *a780_devices[] __initdata = {
>        &a780_gpio_keys,
> +       &a780_camera,
>  };
>
>  static void __init a780_init(void)
> @@ -699,6 +797,8 @@ static void __init a780_init(void)
>
>        pxa_set_keypad_info(&a780_keypad_platform_data);
>
> +       pxa_set_camera_info(&a780_pxacamera_platform_data);
> +
>        platform_add_devices(ARRAY_AND_SIZE(ezx_devices));
>        platform_add_devices(ARRAY_AND_SIZE(a780_devices));
>  }
> @@ -864,8 +964,84 @@ static struct platform_device a910_gpio_keys = {
>        },
>  };
>
> +/* camera */
> +static int a910_pxacamera_init(struct device *dev)
> +{
> +       int err;
> +
> +       /*
> +        * GPIO50_GPIO is CAM_EN: active low
> +        * GPIO28_GPIO is CAM_RST: active high
> +        */
> +       err = gpio_request(MFP_PIN_GPIO50, "nCAM_EN");
> +       if (err) {
> +               pr_err("%s: Failed to request nCAM_EN\n", __func__);
> +               goto fail;
> +       }
> +
> +       err = gpio_request(MFP_PIN_GPIO28, "CAM_RST");
> +       if (err) {
> +               pr_err("%s: Failed to request CAM_RST\n", __func__);
> +               goto fail_gpio_cam_rst;
> +       }
> +
> +       gpio_direction_output(MFP_PIN_GPIO50, 0);
> +       gpio_direction_output(MFP_PIN_GPIO28, 1);
> +
> +       return 0;
> +
> +fail_gpio_cam_rst:
> +       gpio_free(MFP_PIN_GPIO50);
> +fail:
> +       return err;
> +}
> +
> +static int a910_pxacamera_power(struct device *dev, int on)
> +{
> +       gpio_set_value(MFP_PIN_GPIO50, on ? 0 : 1);
> +       return 0;
> +}
> +
> +static int a910_pxacamera_reset(struct device *dev)
> +{
> +       gpio_set_value(MFP_PIN_GPIO28, 0);
> +       msleep(10);
> +       gpio_set_value(MFP_PIN_GPIO28, 1);
> +
> +       return 0;
> +}
> +
> +struct pxacamera_platform_data a910_pxacamera_platform_data = {
> +       .init   = a910_pxacamera_init,
> +       .flags  = PXA_CAMERA_MASTER | PXA_CAMERA_DATAWIDTH_8 |
> +               PXA_CAMERA_PCLK_EN | PXA_CAMERA_MCLK_EN,
> +       .mclk_10khz = 5000,
> +};
> +
> +static struct i2c_board_info a910_camera_i2c_board_info = {
> +       I2C_BOARD_INFO("mt9m111", 0x5d),
> +};
> +
> +static struct soc_camera_link a910_iclink = {
> +       .bus_id         = 0,
> +       .i2c_adapter_id = 0,
> +       .board_info     = &a910_camera_i2c_board_info,
> +       .module_name    = "mt9m111",
> +       .power          = a910_pxacamera_power,
> +       .reset          = a910_pxacamera_reset,
> +};
> +
> +static struct platform_device a910_camera = {
> +       .name   = "soc-camera-pdrv",
> +       .id     = 0,
> +       .dev    = {
> +               .platform_data = &a910_iclink,
> +       },
> +};
> +
>  static struct platform_device *a910_devices[] __initdata = {
>        &a910_gpio_keys,
> +       &a910_camera,
>  };
>
>  static void __init a910_init(void)
> @@ -880,6 +1056,8 @@ static void __init a910_init(void)
>
>        pxa_set_keypad_info(&a910_keypad_platform_data);
>
> +       pxa_set_camera_info(&a910_pxacamera_platform_data);
> +
>        platform_add_devices(ARRAY_AND_SIZE(ezx_devices));
>        platform_add_devices(ARRAY_AND_SIZE(a910_devices));
>  }
> --
> 1.6.5.2
>
>
