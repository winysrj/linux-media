Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ie0-f172.google.com ([209.85.223.172]:44767 "EHLO
	mail-ie0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933492AbaKMSoU (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 13 Nov 2014 13:44:20 -0500
MIME-Version: 1.0
In-Reply-To: <1415808557-29557-2-git-send-email-j.anaszewski@samsung.com>
References: <1415808557-29557-1-git-send-email-j.anaszewski@samsung.com> <1415808557-29557-2-git-send-email-j.anaszewski@samsung.com>
From: Bryan Wu <cooloney@gmail.com>
Date: Thu, 13 Nov 2014 10:43:58 -0800
Message-ID: <CAK5ve-JageqCh0SfDv46W-ffWNwf=su_Z6ZZCAH0QeMq2vM5rg@mail.gmail.com>
Subject: Re: [PATCH/RFC v7 1/3] leds: Add support for setting brightness in a
 synchronous way
To: Jacek Anaszewski <j.anaszewski@samsung.com>
Cc: Linux LED Subsystem <linux-leds@vger.kernel.org>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	sakari.ailus@linux.intel.com,
	Kyungmin Park <kyungmin.park@samsung.com>,
	b.zolnierkie@samsung.com, Richard Purdie <rpurdie@rpsys.net>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, Nov 12, 2014 at 8:09 AM, Jacek Anaszewski
<j.anaszewski@samsung.com> wrote:
> There are use cases when setting a LED brightness has to
> have immediate effect (e.g. setting a torch LED brightness).
> This patch extends LED subsystem to support such operations.
> The LED subsystem internal API __led_set_brightness is changed
> to led_set_brightness_async and new led_set_brightness_sync API
> is added.
>

Great, I do like this patch and just one pick coding style as below.

Thanks,
-Bryan

> Signed-off-by: Jacek Anaszewski <j.anaszewski@samsung.com>
> Acked-by: Kyungmin Park <kyungmin.park@samsung.com>
> Cc: Bryan Wu <cooloney@gmail.com>
> Cc: Richard Purdie <rpurdie@rpsys.net>
> ---
>  drivers/leds/led-class.c                  |   10 ++++++----
>  drivers/leds/led-core.c                   |   19 ++++++++++++++++---
>  drivers/leds/leds.h                       |   20 ++++++++++++++++----
>  drivers/leds/trigger/ledtrig-backlight.c  |    8 ++++----
>  drivers/leds/trigger/ledtrig-default-on.c |    2 +-
>  drivers/leds/trigger/ledtrig-gpio.c       |    6 +++---
>  drivers/leds/trigger/ledtrig-heartbeat.c  |    2 +-
>  drivers/leds/trigger/ledtrig-oneshot.c    |    4 ++--
>  drivers/leds/trigger/ledtrig-transient.c  |   10 ++++++----
>  include/linux/leds.h                      |    8 ++++++++
>  10 files changed, 63 insertions(+), 26 deletions(-)
>
> diff --git a/drivers/leds/led-class.c b/drivers/leds/led-class.c
> index 65722de..dbeebac 100644
> --- a/drivers/leds/led-class.c
> +++ b/drivers/leds/led-class.c
> @@ -55,7 +55,7 @@ static ssize_t brightness_store(struct device *dev,
>
>         if (state == LED_OFF)
>                 led_trigger_remove(led_cdev);
> -       __led_set_brightness(led_cdev, state);
> +       led_set_brightness(led_cdev, state);
>
>         ret = size;
>  unlock:
> @@ -109,7 +109,7 @@ static void led_timer_function(unsigned long data)
>         unsigned long delay;
>
>         if (!led_cdev->blink_delay_on || !led_cdev->blink_delay_off) {
> -               __led_set_brightness(led_cdev, LED_OFF);
> +               led_set_brightness_async(led_cdev, LED_OFF);
>                 return;
>         }
>
> @@ -132,7 +132,7 @@ static void led_timer_function(unsigned long data)
>                 delay = led_cdev->blink_delay_off;
>         }
>
> -       __led_set_brightness(led_cdev, brightness);
> +       led_set_brightness_async(led_cdev, brightness);
>
>         /* Return in next iteration if led is in one-shot mode and we are in
>          * the final blink state so that the led is toggled each delay_on +
> @@ -158,7 +158,7 @@ static void set_brightness_delayed(struct work_struct *ws)
>
>         led_stop_software_blink(led_cdev);
>
> -       __led_set_brightness(led_cdev, led_cdev->delayed_set_value);
> +       led_set_brightness_async(led_cdev, led_cdev->delayed_set_value);
>  }
>
>  /**
> @@ -233,6 +233,8 @@ int led_classdev_register(struct device *parent, struct led_classdev *led_cdev)
>         if (!led_cdev->max_brightness)
>                 led_cdev->max_brightness = LED_FULL;
>
> +       led_cdev->flags |= SET_BRIGHTNESS_ASYNC;
> +
>         led_update_brightness(led_cdev);
>
>         INIT_WORK(&led_cdev->set_brightness_work, set_brightness_delayed);
> diff --git a/drivers/leds/led-core.c b/drivers/leds/led-core.c
> index be6d9fa..a745e32 100644
> --- a/drivers/leds/led-core.c
> +++ b/drivers/leds/led-core.c
> @@ -42,13 +42,13 @@ static void led_set_software_blink(struct led_classdev *led_cdev,
>
>         /* never on - just set to off */
>         if (!delay_on) {
> -               __led_set_brightness(led_cdev, LED_OFF);
> +               led_set_brightness_async(led_cdev, LED_OFF);
>                 return;
>         }
>
>         /* never off - just set to brightness */
>         if (!delay_off) {
> -               __led_set_brightness(led_cdev, led_cdev->blink_brightness);
> +               led_set_brightness_async(led_cdev, led_cdev->blink_brightness);
>                 return;
>         }
>
> @@ -117,6 +117,8 @@ EXPORT_SYMBOL_GPL(led_stop_software_blink);
>  void led_set_brightness(struct led_classdev *led_cdev,
>                         enum led_brightness brightness)
>  {
> +       int ret = 0;
> +
>         /* delay brightness setting if need to stop soft-blink timer */
>         if (led_cdev->blink_delay_on || led_cdev->blink_delay_off) {
>                 led_cdev->delayed_set_value = brightness;
> @@ -124,7 +126,18 @@ void led_set_brightness(struct led_classdev *led_cdev,
>                 return;
>         }
>
> -       __led_set_brightness(led_cdev, brightness);
> +       if (led_cdev->flags & SET_BRIGHTNESS_ASYNC) {
> +               led_set_brightness_async(led_cdev, brightness);
> +               return;
> +       } else if (led_cdev->flags & SET_BRIGHTNESS_SYNC) {
> +               ret = led_set_brightness_sync(led_cdev, brightness);
> +       } else {
> +               ret = -EINVAL;
> +       }
> +

Since there is only one line in the {}, we don't need {} here:

+       if (led_cdev->flags & SET_BRIGHTNESS_ASYNC) {
+               led_set_brightness_async(led_cdev, brightness);
+               return;
+       } else if (led_cdev->flags & SET_BRIGHTNESS_SYNC)
+               ret = led_set_brightness_sync(led_cdev, brightness);
+       else
+               ret = -EINVAL;
+



> +       if (ret < 0)
> +               dev_dbg(led_cdev->dev, "Setting LED brightness failed (%d)\n",
> +                       ret);
>  }
>  EXPORT_SYMBOL(led_set_brightness);
>
> diff --git a/drivers/leds/leds.h b/drivers/leds/leds.h
> index 4c50365..2348dbd 100644
> --- a/drivers/leds/leds.h
> +++ b/drivers/leds/leds.h
> @@ -17,16 +17,28 @@
>  #include <linux/rwsem.h>
>  #include <linux/leds.h>
>
> -static inline void __led_set_brightness(struct led_classdev *led_cdev,
> +static inline void led_set_brightness_async(struct led_classdev *led_cdev,
>                                         enum led_brightness value)
>  {
> -       if (value > led_cdev->max_brightness)
> -               value = led_cdev->max_brightness;
> -       led_cdev->brightness = value;
> +       led_cdev->brightness = min(value, led_cdev->max_brightness);
> +
>         if (!(led_cdev->flags & LED_SUSPENDED))
>                 led_cdev->brightness_set(led_cdev, value);
>  }
>
> +static inline int led_set_brightness_sync(struct led_classdev *led_cdev,
> +                                       enum led_brightness value)
> +{
> +       int ret = 0;
> +
> +       led_cdev->brightness = min(value, led_cdev->max_brightness);
> +
> +       if (!(led_cdev->flags & LED_SUSPENDED))
> +               ret = led_cdev->brightness_set_sync(led_cdev,
> +                                               led_cdev->brightness);
> +       return ret;
> +}
> +
>  static inline int led_get_brightness(struct led_classdev *led_cdev)
>  {
>         return led_cdev->brightness;
> diff --git a/drivers/leds/trigger/ledtrig-backlight.c b/drivers/leds/trigger/ledtrig-backlight.c
> index 47e55aa..59eca17 100644
> --- a/drivers/leds/trigger/ledtrig-backlight.c
> +++ b/drivers/leds/trigger/ledtrig-backlight.c
> @@ -51,9 +51,9 @@ static int fb_notifier_callback(struct notifier_block *p,
>
>         if ((n->old_status == UNBLANK) ^ n->invert) {
>                 n->brightness = led->brightness;
> -               __led_set_brightness(led, LED_OFF);
> +               led_set_brightness_async(led, LED_OFF);
>         } else {
> -               __led_set_brightness(led, n->brightness);
> +               led_set_brightness_async(led, n->brightness);
>         }
>
>         n->old_status = new_status;
> @@ -89,9 +89,9 @@ static ssize_t bl_trig_invert_store(struct device *dev,
>
>         /* After inverting, we need to update the LED. */
>         if ((n->old_status == BLANK) ^ n->invert)
> -               __led_set_brightness(led, LED_OFF);
> +               led_set_brightness_async(led, LED_OFF);
>         else
> -               __led_set_brightness(led, n->brightness);
> +               led_set_brightness_async(led, n->brightness);
>
>         return num;
>  }
> diff --git a/drivers/leds/trigger/ledtrig-default-on.c b/drivers/leds/trigger/ledtrig-default-on.c
> index 81a91be..6f38f88 100644
> --- a/drivers/leds/trigger/ledtrig-default-on.c
> +++ b/drivers/leds/trigger/ledtrig-default-on.c
> @@ -19,7 +19,7 @@
>
>  static void defon_trig_activate(struct led_classdev *led_cdev)
>  {
> -       __led_set_brightness(led_cdev, led_cdev->max_brightness);
> +       led_set_brightness_async(led_cdev, led_cdev->max_brightness);
>  }
>
>  static struct led_trigger defon_led_trigger = {
> diff --git a/drivers/leds/trigger/ledtrig-gpio.c b/drivers/leds/trigger/ledtrig-gpio.c
> index c86c418..4cc7040 100644
> --- a/drivers/leds/trigger/ledtrig-gpio.c
> +++ b/drivers/leds/trigger/ledtrig-gpio.c
> @@ -54,12 +54,12 @@ static void gpio_trig_work(struct work_struct *work)
>
>         if (tmp) {
>                 if (gpio_data->desired_brightness)
> -                       __led_set_brightness(gpio_data->led,
> +                       led_set_brightness_async(gpio_data->led,
>                                            gpio_data->desired_brightness);
>                 else
> -                       __led_set_brightness(gpio_data->led, LED_FULL);
> +                       led_set_brightness_async(gpio_data->led, LED_FULL);
>         } else {
> -               __led_set_brightness(gpio_data->led, LED_OFF);
> +               led_set_brightness_async(gpio_data->led, LED_OFF);
>         }
>  }
>
> diff --git a/drivers/leds/trigger/ledtrig-heartbeat.c b/drivers/leds/trigger/ledtrig-heartbeat.c
> index 5c8464a..fea6871 100644
> --- a/drivers/leds/trigger/ledtrig-heartbeat.c
> +++ b/drivers/leds/trigger/ledtrig-heartbeat.c
> @@ -74,7 +74,7 @@ static void led_heartbeat_function(unsigned long data)
>                 break;
>         }
>
> -       __led_set_brightness(led_cdev, brightness);
> +       led_set_brightness_async(led_cdev, brightness);
>         mod_timer(&heartbeat_data->timer, jiffies + delay);
>  }
>
> diff --git a/drivers/leds/trigger/ledtrig-oneshot.c b/drivers/leds/trigger/ledtrig-oneshot.c
> index cb4c746..fbd02cd 100644
> --- a/drivers/leds/trigger/ledtrig-oneshot.c
> +++ b/drivers/leds/trigger/ledtrig-oneshot.c
> @@ -63,9 +63,9 @@ static ssize_t led_invert_store(struct device *dev,
>         oneshot_data->invert = !!state;
>
>         if (oneshot_data->invert)
> -               __led_set_brightness(led_cdev, LED_FULL);
> +               led_set_brightness_async(led_cdev, LED_FULL);
>         else
> -               __led_set_brightness(led_cdev, LED_OFF);
> +               led_set_brightness_async(led_cdev, LED_OFF);
>
>         return size;
>  }
> diff --git a/drivers/leds/trigger/ledtrig-transient.c b/drivers/leds/trigger/ledtrig-transient.c
> index e5abc00..3c34de4 100644
> --- a/drivers/leds/trigger/ledtrig-transient.c
> +++ b/drivers/leds/trigger/ledtrig-transient.c
> @@ -41,7 +41,7 @@ static void transient_timer_function(unsigned long data)
>         struct transient_trig_data *transient_data = led_cdev->trigger_data;
>
>         transient_data->activate = 0;
> -       __led_set_brightness(led_cdev, transient_data->restore_state);
> +       led_set_brightness_async(led_cdev, transient_data->restore_state);
>  }
>
>  static ssize_t transient_activate_show(struct device *dev,
> @@ -72,7 +72,8 @@ static ssize_t transient_activate_store(struct device *dev,
>         if (state == 0 && transient_data->activate == 1) {
>                 del_timer(&transient_data->timer);
>                 transient_data->activate = state;
> -               __led_set_brightness(led_cdev, transient_data->restore_state);
> +               led_set_brightness_async(led_cdev,
> +                                       transient_data->restore_state);
>                 return size;
>         }
>
> @@ -80,7 +81,7 @@ static ssize_t transient_activate_store(struct device *dev,
>         if (state == 1 && transient_data->activate == 0 &&
>             transient_data->duration != 0) {
>                 transient_data->activate = state;
> -               __led_set_brightness(led_cdev, transient_data->state);
> +               led_set_brightness_async(led_cdev, transient_data->state);
>                 transient_data->restore_state =
>                     (transient_data->state == LED_FULL) ? LED_OFF : LED_FULL;
>                 mod_timer(&transient_data->timer,
> @@ -203,7 +204,8 @@ static void transient_trig_deactivate(struct led_classdev *led_cdev)
>
>         if (led_cdev->activated) {
>                 del_timer_sync(&transient_data->timer);
> -               __led_set_brightness(led_cdev, transient_data->restore_state);
> +               led_set_brightness_async(led_cdev,
> +                                       transient_data->restore_state);
>                 device_remove_file(led_cdev->dev, &dev_attr_activate);
>                 device_remove_file(led_cdev->dev, &dev_attr_duration);
>                 device_remove_file(led_cdev->dev, &dev_attr_state);
> diff --git a/include/linux/leds.h b/include/linux/leds.h
> index 3737a5a..cfceef3 100644
> --- a/include/linux/leds.h
> +++ b/include/linux/leds.h
> @@ -44,11 +44,19 @@ struct led_classdev {
>  #define LED_BLINK_ONESHOT_STOP (1 << 18)
>  #define LED_BLINK_INVERT       (1 << 19)
>  #define LED_SYSFS_DISABLE      (1 << 20)
> +#define SET_BRIGHTNESS_ASYNC   (1 << 21)
> +#define SET_BRIGHTNESS_SYNC    (1 << 22)
>
>         /* Set LED brightness level */
>         /* Must not sleep, use a workqueue if needed */
>         void            (*brightness_set)(struct led_classdev *led_cdev,
>                                           enum led_brightness brightness);
> +       /*
> +        * Set LED brightness level immediately - it can block the caller for
> +        * the time required for accessing a LED device register.
> +        */
> +       int             (*brightness_set_sync)(struct led_classdev *led_cdev,
> +                                       enum led_brightness brightness);
>         /* Get LED brightness level */
>         enum led_brightness (*brightness_get)(struct led_classdev *led_cdev);
>
> --
> 1.7.9.5
>
