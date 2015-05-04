Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pd0-f172.google.com ([209.85.192.172]:34006 "EHLO
	mail-pd0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750779AbbEDSWI (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 4 May 2015 14:22:08 -0400
MIME-Version: 1.0
In-Reply-To: <1430390097-7157-1-git-send-email-j.anaszewski@samsung.com>
References: <1430390097-7157-1-git-send-email-j.anaszewski@samsung.com>
From: Bryan Wu <cooloney@gmail.com>
Date: Mon, 4 May 2015 11:21:47 -0700
Message-ID: <CAK5ve-Lui1tysUt4MCYc2a8+CdP93XnQneRSSZ=kCUHm2jwU+g@mail.gmail.com>
Subject: Re: [PATCH v7] leds: Add driver for AAT1290 flash LED controller
To: Jacek Anaszewski <j.anaszewski@samsung.com>
Cc: Linux LED Subsystem <linux-leds@vger.kernel.org>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	Kyungmin Park <kyungmin.park@samsung.com>,
	Pavel Machek <pavel@ucw.cz>,
	"rpurdie@rpsys.net" <rpurdie@rpsys.net>,
	Sakari Ailus <sakari.ailus@iki.fi>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, Apr 30, 2015 at 3:34 AM, Jacek Anaszewski
<j.anaszewski@samsung.com> wrote:
> This patch adds a driver for the 1.5A Step-Up Current Regulator
> for Flash LEDs. The device is programmed through a Skyworks proprietary
> AS2Cwire serial digital interface.
>

Reapplied. Thanks,
-Bryan

> Signed-off-by: Jacek Anaszewski <j.anaszewski@samsung.com>
> Acked-by: Kyungmin Park <kyungmin.park@samsung.com>
> Acked-by: Sakari Ailus <sakari.ailus@linux.intel.com>
> Cc: Bryan Wu <cooloney@gmail.com>
> Cc: Richard Purdie <rpurdie@rpsys.net>
> ---
> Fixed issue reported by 0-DAY kernel test infrastructure:
> drivers/leds/leds-aat1290.c:443:3-8: No need to set .owner here. The core will do it
> Fixed issue reported by Coccinelle:
> drivers/leds/leds-aat1290.c:204:5-10: WARNING: Comparison of bool to 0/1
>
>  drivers/leds/Kconfig        |    8 +
>  drivers/leds/Makefile       |    1 +
>  drivers/leds/leds-aat1290.c |  451 +++++++++++++++++++++++++++++++++++++++++++
>  3 files changed, 460 insertions(+)
>  create mode 100644 drivers/leds/leds-aat1290.c
>
> diff --git a/drivers/leds/Kconfig b/drivers/leds/Kconfig
> index 62be033..dd7834c 100644
> --- a/drivers/leds/Kconfig
> +++ b/drivers/leds/Kconfig
> @@ -42,6 +42,14 @@ config LEDS_88PM860X
>           This option enables support for on-chip LED drivers found on Marvell
>           Semiconductor 88PM8606 PMIC.
>
> +config LEDS_AAT1290
> +       tristate "LED support for the AAT1290"
> +       depends on LEDS_CLASS_FLASH
> +       depends on GPIOLIB
> +       depends on OF
> +       help
> +        This option enables support for the LEDs on the AAT1290.
> +
>  config LEDS_LM3530
>         tristate "LCD Backlight driver for LM3530"
>         depends on LEDS_CLASS
> diff --git a/drivers/leds/Makefile b/drivers/leds/Makefile
> index 8bddae6..71f7c9a 100644
> --- a/drivers/leds/Makefile
> +++ b/drivers/leds/Makefile
> @@ -7,6 +7,7 @@ obj-$(CONFIG_LEDS_TRIGGERS)             += led-triggers.o
>
>  # LED Platform Drivers
>  obj-$(CONFIG_LEDS_88PM860X)            += leds-88pm860x.o
> +obj-$(CONFIG_LEDS_AAT1290)             += leds-aat1290.o
>  obj-$(CONFIG_LEDS_BD2802)              += leds-bd2802.o
>  obj-$(CONFIG_LEDS_LOCOMO)              += leds-locomo.o
>  obj-$(CONFIG_LEDS_LM3530)              += leds-lm3530.o
> diff --git a/drivers/leds/leds-aat1290.c b/drivers/leds/leds-aat1290.c
> new file mode 100644
> index 0000000..6ea1d54
> --- /dev/null
> +++ b/drivers/leds/leds-aat1290.c
> @@ -0,0 +1,451 @@
> +/*
> + *     LED Flash class driver for the AAT1290
> + *     1.5A Step-Up Current Regulator for Flash LEDs
> + *
> + *     Copyright (C) 2015, Samsung Electronics Co., Ltd.
> + *     Author: Jacek Anaszewski <j.anaszewski@samsung.com>
> + *
> + * This program is free software; you can redistribute it and/or
> + * modify it under the terms of the GNU General Public License
> + * version 2 as published by the Free Software Foundation.
> + */
> +
> +#include <linux/delay.h>
> +#include <linux/gpio/consumer.h>
> +#include <linux/led-class-flash.h>
> +#include <linux/leds.h>
> +#include <linux/module.h>
> +#include <linux/mutex.h>
> +#include <linux/of.h>
> +#include <linux/platform_device.h>
> +#include <linux/slab.h>
> +#include <linux/workqueue.h>
> +
> +#define AAT1290_MOVIE_MODE_CURRENT_ADDR        17
> +#define AAT1290_MAX_MM_CURR_PERCENT_0  16
> +#define AAT1290_MAX_MM_CURR_PERCENT_100        1
> +
> +#define AAT1290_FLASH_SAFETY_TIMER_ADDR        18
> +
> +#define AAT1290_MOVIE_MODE_CONFIG_ADDR 19
> +#define AAT1290_MOVIE_MODE_OFF         1
> +#define AAT1290_MOVIE_MODE_ON          3
> +
> +#define AAT1290_MM_CURRENT_RATIO_ADDR  20
> +#define AAT1290_MM_TO_FL_1_92          1
> +
> +#define AAT1290_MM_TO_FL_RATIO         1000 / 1920
> +#define AAT1290_MAX_MM_CURRENT(fl_max) (fl_max * AAT1290_MM_TO_FL_RATIO)
> +
> +#define AAT1290_LATCH_TIME_MIN_US      500
> +#define AAT1290_LATCH_TIME_MAX_US      1000
> +#define AAT1290_EN_SET_TICK_TIME_US    1
> +#define AAT1290_FLEN_OFF_DELAY_TIME_US 10
> +#define AAT1290_FLASH_TM_NUM_LEVELS    16
> +#define AAT1290_MM_CURRENT_SCALE_SIZE  15
> +
> +
> +struct aat1290_led_config_data {
> +       /* maximum LED current in movie mode */
> +       u32 max_mm_current;
> +       /* maximum LED current in flash mode */
> +       u32 max_flash_current;
> +       /* maximum flash timeout */
> +       u32 max_flash_tm;
> +       /* max LED brightness level */
> +       enum led_brightness max_brightness;
> +};
> +
> +struct aat1290_led {
> +       /* platform device data */
> +       struct platform_device *pdev;
> +       /* secures access to the device */
> +       struct mutex lock;
> +
> +       /* corresponding LED Flash class device */
> +       struct led_classdev_flash fled_cdev;
> +
> +       /* FLEN pin */
> +       struct gpio_desc *gpio_fl_en;
> +       /* EN|SET pin  */
> +       struct gpio_desc *gpio_en_set;
> +       /* movie mode current scale */
> +       int *mm_current_scale;
> +       /* device mode */
> +       bool movie_mode;
> +
> +       /* brightness cache */
> +       unsigned int torch_brightness;
> +       /* assures led-triggers compatibility */
> +       struct work_struct work_brightness_set;
> +};
> +
> +static struct aat1290_led *fled_cdev_to_led(
> +                               struct led_classdev_flash *fled_cdev)
> +{
> +       return container_of(fled_cdev, struct aat1290_led, fled_cdev);
> +}
> +
> +static void aat1290_as2cwire_write(struct aat1290_led *led, int addr, int value)
> +{
> +       int i;
> +
> +       gpiod_direction_output(led->gpio_fl_en, 0);
> +       gpiod_direction_output(led->gpio_en_set, 0);
> +
> +       udelay(AAT1290_FLEN_OFF_DELAY_TIME_US);
> +
> +       /* write address */
> +       for (i = 0; i < addr; ++i) {
> +               udelay(AAT1290_EN_SET_TICK_TIME_US);
> +               gpiod_direction_output(led->gpio_en_set, 0);
> +               udelay(AAT1290_EN_SET_TICK_TIME_US);
> +               gpiod_direction_output(led->gpio_en_set, 1);
> +       }
> +
> +       usleep_range(AAT1290_LATCH_TIME_MIN_US, AAT1290_LATCH_TIME_MAX_US);
> +
> +       /* write data */
> +       for (i = 0; i < value; ++i) {
> +               udelay(AAT1290_EN_SET_TICK_TIME_US);
> +               gpiod_direction_output(led->gpio_en_set, 0);
> +               udelay(AAT1290_EN_SET_TICK_TIME_US);
> +               gpiod_direction_output(led->gpio_en_set, 1);
> +       }
> +
> +       usleep_range(AAT1290_LATCH_TIME_MIN_US, AAT1290_LATCH_TIME_MAX_US);
> +}
> +
> +static void aat1290_set_flash_safety_timer(struct aat1290_led *led,
> +                                       unsigned int micro_sec)
> +{
> +       struct led_classdev_flash *fled_cdev = &led->fled_cdev;
> +       struct led_flash_setting *flash_tm = &fled_cdev->timeout;
> +       int flash_tm_reg = AAT1290_FLASH_TM_NUM_LEVELS -
> +                               (micro_sec / flash_tm->step) + 1;
> +
> +       aat1290_as2cwire_write(led, AAT1290_FLASH_SAFETY_TIMER_ADDR,
> +                                                       flash_tm_reg);
> +}
> +
> +static void aat1290_brightness_set(struct aat1290_led *led,
> +                                       enum led_brightness brightness)
> +{
> +       mutex_lock(&led->lock);
> +
> +       if (brightness == 0) {
> +               gpiod_direction_output(led->gpio_fl_en, 0);
> +               gpiod_direction_output(led->gpio_en_set, 0);
> +               led->movie_mode = false;
> +       } else {
> +               if (!led->movie_mode) {
> +                       aat1290_as2cwire_write(led,
> +                               AAT1290_MM_CURRENT_RATIO_ADDR,
> +                               AAT1290_MM_TO_FL_1_92);
> +                       led->movie_mode = true;
> +               }
> +
> +               aat1290_as2cwire_write(led, AAT1290_MOVIE_MODE_CURRENT_ADDR,
> +                               AAT1290_MAX_MM_CURR_PERCENT_0 - brightness);
> +               aat1290_as2cwire_write(led, AAT1290_MOVIE_MODE_CONFIG_ADDR,
> +                               AAT1290_MOVIE_MODE_ON);
> +       }
> +
> +       mutex_unlock(&led->lock);
> +}
> +
> +/* LED subsystem callbacks */
> +
> +static void aat1290_brightness_set_work(struct work_struct *work)
> +{
> +       struct aat1290_led *led =
> +               container_of(work, struct aat1290_led, work_brightness_set);
> +
> +       aat1290_brightness_set(led, led->torch_brightness);
> +}
> +
> +static void aat1290_led_brightness_set(struct led_classdev *led_cdev,
> +                                       enum led_brightness brightness)
> +{
> +       struct led_classdev_flash *fled_cdev = lcdev_to_flcdev(led_cdev);
> +       struct aat1290_led *led = fled_cdev_to_led(fled_cdev);
> +
> +       led->torch_brightness = brightness;
> +       schedule_work(&led->work_brightness_set);
> +}
> +
> +static int aat1290_led_brightness_set_sync(struct led_classdev *led_cdev,
> +                                       enum led_brightness brightness)
> +{
> +       struct led_classdev_flash *fled_cdev = lcdev_to_flcdev(led_cdev);
> +       struct aat1290_led *led = fled_cdev_to_led(fled_cdev);
> +
> +       aat1290_brightness_set(led, brightness);
> +
> +       return 0;
> +}
> +
> +static int aat1290_led_flash_strobe_set(struct led_classdev_flash *fled_cdev,
> +                                        bool state)
> +
> +{
> +       struct aat1290_led *led = fled_cdev_to_led(fled_cdev);
> +       struct led_classdev *led_cdev = &fled_cdev->led_cdev;
> +       struct led_flash_setting *timeout = &fled_cdev->timeout;
> +
> +       mutex_lock(&led->lock);
> +
> +       if (state) {
> +               aat1290_set_flash_safety_timer(led, timeout->val);
> +               gpiod_direction_output(led->gpio_fl_en, 1);
> +       } else {
> +               gpiod_direction_output(led->gpio_fl_en, 0);
> +               gpiod_direction_output(led->gpio_en_set, 0);
> +       }
> +
> +       /*
> +        * To reenter movie mode after a flash event the part must be cycled
> +        * off and back on to reset the movie mode and reprogrammed via the
> +        * AS2Cwire. Therefore the brightness and movie_mode properties needs
> +        * to be updated here to reflect the actual state.
> +        */
> +       led_cdev->brightness = 0;
> +       led->movie_mode = false;
> +
> +       mutex_unlock(&led->lock);
> +
> +       return 0;
> +}
> +
> +static int aat1290_led_flash_timeout_set(struct led_classdev_flash *fled_cdev,
> +                                               u32 timeout)
> +{
> +       /*
> +        * Don't do anything - flash timeout is cached in the led-class-flash
> +        * core and will be applied in the strobe_set op, as writing the
> +        * safety timer register spuriously turns the torch mode on.
> +        */
> +
> +       return 0;
> +}
> +
> +static int aat1290_led_parse_dt(struct aat1290_led *led,
> +                       struct aat1290_led_config_data *cfg)
> +{
> +       struct led_classdev *led_cdev = &led->fled_cdev.led_cdev;
> +       struct device *dev = &led->pdev->dev;
> +       struct device_node *child_node;
> +       int ret = 0;
> +
> +       led->gpio_fl_en = devm_gpiod_get(dev, "flen");
> +       if (IS_ERR(led->gpio_fl_en)) {
> +               ret = PTR_ERR(led->gpio_fl_en);
> +               dev_err(dev, "Unable to claim gpio \"flen\".\n");
> +               return ret;
> +       }
> +
> +       led->gpio_en_set = devm_gpiod_get(dev, "enset");
> +       if (IS_ERR(led->gpio_en_set)) {
> +               ret = PTR_ERR(led->gpio_en_set);
> +               dev_err(dev, "Unable to claim gpio \"enset\".\n");
> +               return ret;
> +       }
> +
> +       child_node = of_get_next_available_child(dev->of_node, NULL);
> +       if (!child_node) {
> +               dev_err(dev, "No DT child node found for connected LED.\n");
> +               return -EINVAL;
> +       }
> +
> +       led_cdev->name = of_get_property(child_node, "label", NULL) ? :
> +                                               child_node->name;
> +
> +       ret = of_property_read_u32(child_node, "led-max-microamp",
> +                               &cfg->max_mm_current);
> +       /*
> +        * led-max-microamp will default to 1/20 of flash-max-microamp
> +        * in case it is missing.
> +        */
> +       if (ret < 0)
> +               dev_warn(dev,
> +                       "led-max-microamp DT property missing\n");
> +
> +       ret = of_property_read_u32(child_node, "flash-max-microamp",
> +                               &cfg->max_flash_current);
> +       if (ret < 0) {
> +               dev_err(dev,
> +                       "flash-max-microamp DT property missing\n");
> +               return ret;
> +       }
> +
> +       ret = of_property_read_u32(child_node, "flash-max-timeout-us",
> +                               &cfg->max_flash_tm);
> +       if (ret < 0) {
> +               dev_err(dev,
> +                       "flash-max-timeout-us DT property missing\n");
> +               return ret;
> +       }
> +
> +       of_node_put(child_node);
> +
> +       return ret;
> +}
> +
> +static void aat1290_led_validate_mm_current(struct aat1290_led *led,
> +                                       struct aat1290_led_config_data *cfg)
> +{
> +       int i, b = 0, e = AAT1290_MM_CURRENT_SCALE_SIZE;
> +
> +       while (e - b > 1) {
> +               i = b + (e - b) / 2;
> +               if (cfg->max_mm_current < led->mm_current_scale[i])
> +                       e = i;
> +               else
> +                       b = i;
> +       }
> +
> +       cfg->max_mm_current = led->mm_current_scale[b];
> +       cfg->max_brightness = b + 1;
> +}
> +
> +int init_mm_current_scale(struct aat1290_led *led,
> +                       struct aat1290_led_config_data *cfg)
> +{
> +       int max_mm_current_percent[] = { 20, 22, 25, 28, 32, 36, 40, 45, 50, 56,
> +                                               63, 71, 79, 89, 100 };
> +       int i, max_mm_current =
> +                       AAT1290_MAX_MM_CURRENT(cfg->max_flash_current);
> +
> +       led->mm_current_scale = kzalloc(sizeof(max_mm_current_percent),
> +                                       GFP_KERNEL);
> +       if (!led->mm_current_scale)
> +               return -ENOMEM;
> +
> +       for (i = 0; i < AAT1290_MM_CURRENT_SCALE_SIZE; ++i)
> +               led->mm_current_scale[i] = max_mm_current *
> +                                         max_mm_current_percent[i] / 100;
> +
> +       return 0;
> +}
> +
> +static int aat1290_led_get_configuration(struct aat1290_led *led,
> +                                       struct aat1290_led_config_data *cfg)
> +{
> +       int ret;
> +
> +       ret = aat1290_led_parse_dt(led, cfg);
> +       if (ret < 0)
> +               return ret;
> +       /*
> +        * Init non-linear movie mode current scale basing
> +        * on the max flash current from led configuration.
> +        */
> +       ret = init_mm_current_scale(led, cfg);
> +       if (ret < 0)
> +               return ret;
> +
> +       aat1290_led_validate_mm_current(led, cfg);
> +
> +       kfree(led->mm_current_scale);
> +
> +       return 0;
> +}
> +
> +static void aat1290_init_flash_timeout(struct aat1290_led *led,
> +                               struct aat1290_led_config_data *cfg)
> +{
> +       struct led_classdev_flash *fled_cdev = &led->fled_cdev;
> +       struct led_flash_setting *setting;
> +
> +       /* Init flash timeout setting */
> +       setting = &fled_cdev->timeout;
> +       setting->min = cfg->max_flash_tm / AAT1290_FLASH_TM_NUM_LEVELS;
> +       setting->max = cfg->max_flash_tm;
> +       setting->step = setting->min;
> +       setting->val = setting->max;
> +}
> +
> +static const struct led_flash_ops flash_ops = {
> +       .strobe_set = aat1290_led_flash_strobe_set,
> +       .timeout_set = aat1290_led_flash_timeout_set,
> +};
> +
> +static int aat1290_led_probe(struct platform_device *pdev)
> +{
> +       struct device *dev = &pdev->dev;
> +       struct aat1290_led *led;
> +       struct led_classdev *led_cdev;
> +       struct led_classdev_flash *fled_cdev;
> +       struct aat1290_led_config_data led_cfg = {};
> +       int ret;
> +
> +       led = devm_kzalloc(dev, sizeof(*led), GFP_KERNEL);
> +       if (!led)
> +               return -ENOMEM;
> +
> +       led->pdev = pdev;
> +       platform_set_drvdata(pdev, led);
> +
> +       fled_cdev = &led->fled_cdev;
> +       fled_cdev->ops = &flash_ops;
> +       led_cdev = &fled_cdev->led_cdev;
> +
> +       ret = aat1290_led_get_configuration(led, &led_cfg);
> +       if (ret < 0)
> +               return ret;
> +
> +       mutex_init(&led->lock);
> +
> +       /* Initialize LED Flash class device */
> +       led_cdev->brightness_set = aat1290_led_brightness_set;
> +       led_cdev->brightness_set_sync = aat1290_led_brightness_set_sync;
> +       led_cdev->max_brightness = led_cfg.max_brightness;
> +       led_cdev->flags |= LED_DEV_CAP_FLASH;
> +       INIT_WORK(&led->work_brightness_set, aat1290_brightness_set_work);
> +
> +       aat1290_init_flash_timeout(led, &led_cfg);
> +
> +       /* Register LED Flash class device */
> +       ret = led_classdev_flash_register(&pdev->dev, fled_cdev);
> +       if (ret < 0)
> +               goto err_flash_register;
> +
> +       return 0;
> +
> +err_flash_register:
> +       mutex_destroy(&led->lock);
> +
> +       return ret;
> +}
> +
> +static int aat1290_led_remove(struct platform_device *pdev)
> +{
> +       struct aat1290_led *led = platform_get_drvdata(pdev);
> +
> +       led_classdev_flash_unregister(&led->fled_cdev);
> +       cancel_work_sync(&led->work_brightness_set);
> +
> +       mutex_destroy(&led->lock);
> +
> +       return 0;
> +}
> +
> +static const struct of_device_id aat1290_led_dt_match[] = {
> +       { .compatible = "skyworks,aat1290" },
> +       {},
> +};
> +
> +static struct platform_driver aat1290_led_driver = {
> +       .probe          = aat1290_led_probe,
> +       .remove         = aat1290_led_remove,
> +       .driver         = {
> +               .name   = "aat1290",
> +               .of_match_table = aat1290_led_dt_match,
> +       },
> +};
> +
> +module_platform_driver(aat1290_led_driver);
> +
> +MODULE_AUTHOR("Jacek Anaszewski <j.anaszewski@samsung.com>");
> +MODULE_DESCRIPTION("Skyworks Current Regulator for Flash LEDs");
> +MODULE_LICENSE("GPL v2");
> --
> 1.7.9.5
>
