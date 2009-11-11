Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qy0-f194.google.com ([209.85.221.194]:44813 "EHLO
	mail-qy0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751371AbZKKNze convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 11 Nov 2009 08:55:34 -0500
Received: by qyk32 with SMTP id 32so482735qyk.4
        for <linux-media@vger.kernel.org>; Wed, 11 Nov 2009 05:55:39 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1257937317-16655-1-git-send-email-ospite@studenti.unina.it>
References: <Pine.LNX.4.64.0911101037280.5074@axis700.grange>
	<1257937317-16655-1-git-send-email-ospite@studenti.unina.it>
From: Eric Miao <eric.y.miao@gmail.com>
Date: Wed, 11 Nov 2009 21:55:19 +0800
Message-ID: <f17812d70911110555t393353fbk184ad9db3af42ad4@mail.gmail.com>
Subject: Re: [PATCH 1/3 v3] Add camera support for A780 and A910 EZX phones
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Antonio Ospite <ospite@studenti.unina.it>
Cc: linux-arm-kernel@lists.infradead.org,
	openezx-devel@lists.openezx.org, Bart Visscher <bartv@thisnet.nl>,
	linux-media@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, Nov 11, 2009 at 7:01 PM, Antonio Ospite
<ospite@studenti.unina.it> wrote:
> Signed-off-by: Bart Visscher <bartv@thisnet.nl>
> Signed-off-by: Antonio Ospite <ospite@studenti.unina.it>
>
> ---
> Changes since v2:
>
>  - Bart's SOB goes first, as he is the original author.
>  - Add MFP_LPM_DRIVE_HIGH to camera gpios, as per Motorola original
>   code.
>  - s/pxacamera/camera/ in function names, as they are not used in
>   pxacamera_platform_data
>  - Adjust comments about CAM_RST which is active on rising edge
>  - Saner default values for nCAM_EN and CAM_RST gpios
>  - Setup gpios statically at board init.
>
> Eric, if it is easier for you I can send the three patches together again.
>

That's OK, I can find the rest two :)

Guennadi,

I need your Acked-by or Reviewed-by please.

> Thanks,
>   Antonio
>
>  arch/arm/mach-pxa/ezx.c |  172 +++++++++++++++++++++++++++++++++++++++++++++-
>  1 files changed, 168 insertions(+), 4 deletions(-)
>
> diff --git a/arch/arm/mach-pxa/ezx.c b/arch/arm/mach-pxa/ezx.c
> index 588b265..74423a6 100644
> --- a/arch/arm/mach-pxa/ezx.c
> +++ b/arch/arm/mach-pxa/ezx.c
> @@ -17,8 +17,11 @@
>  #include <linux/delay.h>
>  #include <linux/pwm_backlight.h>
>  #include <linux/input.h>
> +#include <linux/gpio.h>
>  #include <linux/gpio_keys.h>
>
> +#include <media/soc_camera.h>
> +
>  #include <asm/setup.h>
>  #include <asm/mach-types.h>
>  #include <asm/mach/arch.h>
> @@ -29,6 +32,7 @@
>  #include <plat/i2c.h>
>  #include <mach/hardware.h>
>  #include <mach/pxa27x_keypad.h>
> +#include <mach/camera.h>
>
>  #include "devices.h"
>  #include "generic.h"
> @@ -38,6 +42,9 @@
>  #define GPIO15_A910_FLIP_LID           15
>  #define GPIO12_E680_LOCK_SWITCH        12
>  #define GPIO15_E6_LOCK_SWITCH          15
> +#define GPIO50_nCAM_EN                 50
> +#define GPIO19_GEN1_CAM_RST            19
> +#define GPIO28_GEN2_CAM_RST            28
>
>  static struct platform_pwm_backlight_data ezx_backlight_data = {
>        .pwm_id         = 0,
> @@ -191,8 +198,8 @@ static unsigned long gen1_pin_config[] __initdata = {
>        GPIO94_CIF_DD_5,
>        GPIO17_CIF_DD_6,
>        GPIO108_CIF_DD_7,
> -       GPIO50_GPIO,                            /* CAM_EN */
> -       GPIO19_GPIO,                            /* CAM_RST */
> +       GPIO50_GPIO | MFP_LPM_DRIVE_HIGH,       /* CAM_EN */
> +       GPIO19_GPIO | MFP_LPM_DRIVE_HIGH,       /* CAM_RST */
>
>        /* EMU */
>        GPIO120_GPIO,                           /* EMU_MUX1 */
> @@ -248,8 +255,8 @@ static unsigned long gen2_pin_config[] __initdata = {
>        GPIO48_CIF_DD_5,
>        GPIO93_CIF_DD_6,
>        GPIO12_CIF_DD_7,
> -       GPIO50_GPIO,                            /* CAM_EN */
> -       GPIO28_GPIO,                            /* CAM_RST */
> +       GPIO50_GPIO | MFP_LPM_DRIVE_HIGH,       /* CAM_EN */
> +       GPIO28_GPIO | MFP_LPM_DRIVE_HIGH,       /* CAM_RST */
>        GPIO17_GPIO,                            /* CAM_FLASH */
>  };
>  #endif
> @@ -683,8 +690,84 @@ static struct platform_device a780_gpio_keys = {
>        },
>  };
>
> +/* camera */
> +static int a780_camera_init(void)
> +{
> +       int err;
> +
> +       /*
> +        * GPIO50_nCAM_EN is active low
> +        * GPIO19_GEN1_CAM_RST is active on rising edge
> +        */
> +       err = gpio_request(GPIO50_nCAM_EN, "nCAM_EN");
> +       if (err) {
> +               pr_err("%s: Failed to request nCAM_EN\n", __func__);
> +               goto fail;
> +       }
> +
> +       err = gpio_request(GPIO19_GEN1_CAM_RST, "CAM_RST");
> +       if (err) {
> +               pr_err("%s: Failed to request CAM_RST\n", __func__);
> +               goto fail_gpio_cam_rst;
> +       }
> +
> +       gpio_direction_output(GPIO50_nCAM_EN, 1);
> +       gpio_direction_output(GPIO19_GEN1_CAM_RST, 0);
> +
> +       return 0;
> +
> +fail_gpio_cam_rst:
> +       gpio_free(GPIO50_nCAM_EN);
> +fail:
> +       return err;
> +}
> +
> +static int a780_camera_power(struct device *dev, int on)
> +{
> +       gpio_set_value(GPIO50_nCAM_EN, !on);
> +       return 0;
> +}
> +
> +static int a780_camera_reset(struct device *dev)
> +{
> +       gpio_set_value(GPIO19_GEN1_CAM_RST, 0);
> +       msleep(10);
> +       gpio_set_value(GPIO19_GEN1_CAM_RST, 1);
> +
> +       return 0;
> +}
> +
> +struct pxacamera_platform_data a780_pxacamera_platform_data = {
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
> +       .power          = a780_camera_power,
> +       .reset          = a780_camera_reset,
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
> @@ -699,6 +782,9 @@ static void __init a780_init(void)
>
>        pxa_set_keypad_info(&a780_keypad_platform_data);
>
> +       a780_camera_init();
> +       pxa_set_camera_info(&a780_pxacamera_platform_data);
> +
>        platform_add_devices(ARRAY_AND_SIZE(ezx_devices));
>        platform_add_devices(ARRAY_AND_SIZE(a780_devices));
>  }
> @@ -864,8 +950,83 @@ static struct platform_device a910_gpio_keys = {
>        },
>  };
>
> +/* camera */
> +static int a910_camera_init(void)
> +{
> +       int err;
> +
> +       /*
> +        * GPIO50_nCAM_EN is active low
> +        * GPIO28_GEN2_CAM_RST is active on rising edge
> +        */
> +       err = gpio_request(GPIO50_nCAM_EN, "nCAM_EN");
> +       if (err) {
> +               pr_err("%s: Failed to request nCAM_EN\n", __func__);
> +               goto fail;
> +       }
> +
> +       err = gpio_request(GPIO28_GEN2_CAM_RST, "CAM_RST");
> +       if (err) {
> +               pr_err("%s: Failed to request CAM_RST\n", __func__);
> +               goto fail_gpio_cam_rst;
> +       }
> +
> +       gpio_direction_output(GPIO50_nCAM_EN, 1);
> +       gpio_direction_output(GPIO28_GEN2_CAM_RST, 0);
> +
> +       return 0;
> +
> +fail_gpio_cam_rst:
> +       gpio_free(GPIO50_nCAM_EN);
> +fail:
> +       return err;
> +}
> +
> +static int a910_camera_power(struct device *dev, int on)
> +{
> +       gpio_set_value(GPIO50_nCAM_EN, !on);
> +       return 0;
> +}
> +
> +static int a910_camera_reset(struct device *dev)
> +{
> +       gpio_set_value(GPIO28_GEN2_CAM_RST, 0);
> +       msleep(10);
> +       gpio_set_value(GPIO28_GEN2_CAM_RST, 1);
> +
> +       return 0;
> +}
> +
> +struct pxacamera_platform_data a910_pxacamera_platform_data = {
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
> +       .power          = a910_camera_power,
> +       .reset          = a910_camera_reset,
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
> @@ -880,6 +1041,9 @@ static void __init a910_init(void)
>
>        pxa_set_keypad_info(&a910_keypad_platform_data);
>
> +       a910_camera_init();
> +       pxa_set_camera_info(&a910_pxacamera_platform_data);
> +
>        platform_add_devices(ARRAY_AND_SIZE(ezx_devices));
>        platform_add_devices(ARRAY_AND_SIZE(a910_devices));
>  }
> --
> tg: (639a58f..) ezx/mach/camera_new (depends on: master)
>
