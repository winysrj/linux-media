Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ie0-f171.google.com ([209.85.223.171]:41096 "EHLO
	mail-ie0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754040AbaJUBFz (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 20 Oct 2014 21:05:55 -0400
MIME-Version: 1.0
In-Reply-To: <1411399266-16375-3-git-send-email-j.anaszewski@samsung.com>
References: <1411399266-16375-1-git-send-email-j.anaszewski@samsung.com> <1411399266-16375-3-git-send-email-j.anaszewski@samsung.com>
From: Bryan Wu <cooloney@gmail.com>
Date: Mon, 20 Oct 2014 18:05:34 -0700
Message-ID: <CAK5ve-JH6fSZHaUUQUTu-uwpD2aSsB6Ppo0VdaS3FhdAj1qk=A@mail.gmail.com>
Subject: Re: [PATCH/RFC v6 2/3] leds: add API for setting torch brightness
To: Jacek Anaszewski <j.anaszewski@samsung.com>
Cc: Linux LED Subsystem <linux-leds@vger.kernel.org>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	Kyungmin Park <kyungmin.park@samsung.com>,
	b.zolnierkie@samsung.com, Richard Purdie <rpurdie@rpsys.net>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Sep 22, 2014 at 8:21 AM, Jacek Anaszewski
<j.anaszewski@samsung.com> wrote:
> This patch prepares ground for addition of LED Flash Class extension to
> the LED subsystem. Since turning the torch on must have guaranteed
> immediate effect the brightness_set op can't be used for it. Drivers must
> schedule a work queue task in this op to be compatible with led-triggers,
> which call brightess_set from timer irqs. In order to address this
> limitation a torch_brightness_set op and led_set_torch_brightness API
> is introduced. Setting brightness sysfs attribute will result in calling
> brightness_set op for LED Class devices and torch_brightness_set op for
> LED Flash Class devices, whereas triggers will still call brightness
> op in both cases.
>

Although this torch API is for torch, but I think we can make it more
generic and other use case can benefit from this change.

What about this?

Add 2 flags:
1. SET_BRIGHTNESS_ASYNC
2. SET_BRIGHTNESS_SYNC

Then move old API to
__led_set_brightness(led_cdev, state);
led_set_brightness_async();

And add a new API like
led_set_bightness_sync();

Then for torch use case, we use led_set_brightness_sync() API.

-Bryan

> Signed-off-by: Jacek Anaszewski <j.anaszewski@samsung.com>
> Acked-by: Kyungmin Park <kyungmin.park@samsung.com>
> Cc: Bryan Wu <cooloney@gmail.com>
> Cc: Richard Purdie <rpurdie@rpsys.net>
> ---
>  drivers/leds/led-class.c |    9 +++++++--
>  drivers/leds/led-core.c  |   14 ++++++++++++++
>  include/linux/leds.h     |   21 +++++++++++++++++++++
>  3 files changed, 42 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/leds/led-class.c b/drivers/leds/led-class.c
> index a39ca8f..5a11a07 100644
> --- a/drivers/leds/led-class.c
> +++ b/drivers/leds/led-class.c
> @@ -54,9 +54,14 @@ static ssize_t brightness_store(struct device *dev,
>
>         if (state == LED_OFF)
>                 led_trigger_remove(led_cdev);
> -       __led_set_brightness(led_cdev, state);
>
> -       ret = size;
> +       if (led_cdev->flags & LED_DEV_CAP_TORCH)
> +               ret = led_set_torch_brightness(led_cdev, state);
> +       else
> +               __led_set_brightness(led_cdev, state);
> +
> +       if (!ret)
> +               ret = size;
>  unlock:
>         mutex_unlock(&led_cdev->led_access);
>         return ret;
> diff --git a/drivers/leds/led-core.c b/drivers/leds/led-core.c
> index cca86ab..c6d8288 100644
> --- a/drivers/leds/led-core.c
> +++ b/drivers/leds/led-core.c
> @@ -143,6 +143,20 @@ int led_update_brightness(struct led_classdev *led_cdev)
>  }
>  EXPORT_SYMBOL(led_update_brightness);
>
> +int led_set_torch_brightness(struct led_classdev *led_cdev,
> +                               enum led_brightness brightness)
> +{
> +       int ret = 0;
> +
> +       led_cdev->brightness = min(brightness, led_cdev->max_brightness);
> +
> +       if (!(led_cdev->flags & LED_SUSPENDED))
> +               ret = led_cdev->torch_brightness_set(led_cdev,
> +                                                    led_cdev->brightness);
> +       return ret;
> +}
> +EXPORT_SYMBOL_GPL(led_set_torch_brightness);
> +
>  /* Caller must ensure led_cdev->led_access held */
>  void led_sysfs_disable(struct led_classdev *led_cdev)
>  {
> diff --git a/include/linux/leds.h b/include/linux/leds.h
> index 44c8a98..bc2a570 100644
> --- a/include/linux/leds.h
> +++ b/include/linux/leds.h
> @@ -44,11 +44,21 @@ struct led_classdev {
>  #define LED_BLINK_ONESHOT_STOP (1 << 18)
>  #define LED_BLINK_INVERT       (1 << 19)
>  #define LED_SYSFS_DISABLE      (1 << 20)
> +#define LED_DEV_CAP_TORCH      (1 << 21)
>
>         /* Set LED brightness level */
>         /* Must not sleep, use a workqueue if needed */
>         void            (*brightness_set)(struct led_classdev *led_cdev,
>                                           enum led_brightness brightness);
> +       /*
> +        * Set LED brightness immediately - it is required for flash led
> +        * devices as they require setting torch brightness to have immediate
> +        * effect. brightness_set op cannot be used for this purpose because
> +        * the led drivers schedule a work queue task in it to allow for
> +        * being called from led-triggers, i.e. from the timer irq context.
> +        */
> +       int             (*torch_brightness_set)(struct led_classdev *led_cdev,
> +                                       enum led_brightness brightness);
>         /* Get LED brightness level */
>         enum led_brightness (*brightness_get)(struct led_classdev *led_cdev);
>
> @@ -157,6 +167,17 @@ extern void led_set_brightness(struct led_classdev *led_cdev,
>  extern int led_update_brightness(struct led_classdev *led_cdev);
>
>  /**
> + * led_set_torch_brightness - set torch LED brightness
> + * @led_cdev: the LED to set
> + * @brightness: the brightness to set it to
> + *
> + * Returns: 0 on success or negative error value on failure
> + *
> + * Set a torch LED's brightness.
> + */
> +extern int led_set_torch_brightness(struct led_classdev *led_cdev,
> +                                       enum led_brightness brightness);
> +/**
>   * led_sysfs_disable - disable LED sysfs interface
>   * @led_cdev: the LED to set
>   *
> --
> 1.7.9.5
>
