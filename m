Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pd0-f179.google.com ([209.85.192.179]:35383 "EHLO
	mail-pd0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753490AbbDHBZ4 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 7 Apr 2015 21:25:56 -0400
MIME-Version: 1.0
In-Reply-To: <1427809965-25540-3-git-send-email-j.anaszewski@samsung.com>
References: <1427809965-25540-1-git-send-email-j.anaszewski@samsung.com> <1427809965-25540-3-git-send-email-j.anaszewski@samsung.com>
From: Bryan Wu <cooloney@gmail.com>
Date: Tue, 7 Apr 2015 18:25:35 -0700
Message-ID: <CAK5ve-Jw5v5toKx4fJt-5wqT2OJrJFwCaq_gxsuqBUaPAWed3g@mail.gmail.com>
Subject: Re: [PATCH v4 02/12] leds: unify the location of led-trigger API
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

On Tue, Mar 31, 2015 at 6:52 AM, Jacek Anaszewski
<j.anaszewski@samsung.com> wrote:
> Part of led-trigger API was in the private drivers/leds/leds.h header.
> Move it to the include/linux/leds.h header to unify the API location
> and announce it as public. It has been already exported from
> led-triggers.c with EXPORT_SYMBOL_GPL macro.
>

Applied, thanks.

-Bryan

> Signed-off-by: Jacek Anaszewski <j.anaszewski@samsung.com>
> Acked-by: Kyungmin Park <kyungmin.park@samsung.com>
> Acked-by: Sakari Ailus <sakari.ailus@linux.intel.com>
> Cc: Bryan Wu <cooloney@gmail.com>
> Cc: Richard Purdie <rpurdie@rpsys.net>
> ---
>  drivers/leds/leds.h  |   24 ------------------------
>  include/linux/leds.h |   24 ++++++++++++++++++++++++
>  2 files changed, 24 insertions(+), 24 deletions(-)
>
> diff --git a/drivers/leds/leds.h b/drivers/leds/leds.h
> index 79efe57..bc89d7a 100644
> --- a/drivers/leds/leds.h
> +++ b/drivers/leds/leds.h
> @@ -13,7 +13,6 @@
>  #ifndef __LEDS_H_INCLUDED
>  #define __LEDS_H_INCLUDED
>
> -#include <linux/device.h>
>  #include <linux/rwsem.h>
>  #include <linux/leds.h>
>
> @@ -50,27 +49,4 @@ void led_stop_software_blink(struct led_classdev *led_cdev);
>  extern struct rw_semaphore leds_list_lock;
>  extern struct list_head leds_list;
>
> -#ifdef CONFIG_LEDS_TRIGGERS
> -void led_trigger_set_default(struct led_classdev *led_cdev);
> -void led_trigger_set(struct led_classdev *led_cdev,
> -                       struct led_trigger *trigger);
> -void led_trigger_remove(struct led_classdev *led_cdev);
> -
> -static inline void *led_get_trigger_data(struct led_classdev *led_cdev)
> -{
> -       return led_cdev->trigger_data;
> -}
> -
> -#else
> -#define led_trigger_set_default(x) do {} while (0)
> -#define led_trigger_set(x, y) do {} while (0)
> -#define led_trigger_remove(x) do {} while (0)
> -#define led_get_trigger_data(x) (NULL)
> -#endif
> -
> -ssize_t led_trigger_store(struct device *dev, struct device_attribute *attr,
> -                       const char *buf, size_t count);
> -ssize_t led_trigger_show(struct device *dev, struct device_attribute *attr,
> -                       char *buf);
> -
>  #endif /* __LEDS_H_INCLUDED */
> diff --git a/include/linux/leds.h b/include/linux/leds.h
> index 9a2b000..0579708 100644
> --- a/include/linux/leds.h
> +++ b/include/linux/leds.h
> @@ -12,6 +12,7 @@
>  #ifndef __LINUX_LEDS_H_INCLUDED
>  #define __LINUX_LEDS_H_INCLUDED
>
> +#include <linux/device.h>
>  #include <linux/list.h>
>  #include <linux/mutex.h>
>  #include <linux/rwsem.h>
> @@ -222,6 +223,29 @@ struct led_trigger {
>         struct list_head  next_trig;
>  };
>
> +#ifdef CONFIG_LEDS_TRIGGERS
> +void led_trigger_set_default(struct led_classdev *led_cdev);
> +void led_trigger_set(struct led_classdev *led_cdev,
> +                       struct led_trigger *trigger);
> +void led_trigger_remove(struct led_classdev *led_cdev);
> +
> +static inline void *led_get_trigger_data(struct led_classdev *led_cdev)
> +{
> +       return led_cdev->trigger_data;
> +}
> +
> +#else
> +#define led_trigger_set_default(x) do {} while (0)
> +#define led_trigger_set(x, y) do {} while (0)
> +#define led_trigger_remove(x) do {} while (0)
> +#define led_get_trigger_data(x) (NULL)
> +#endif
> +
> +ssize_t led_trigger_store(struct device *dev, struct device_attribute *attr,
> +                       const char *buf, size_t count);
> +ssize_t led_trigger_show(struct device *dev, struct device_attribute *attr,
> +                       char *buf);
> +
>  /* Registration functions for complex triggers */
>  extern int led_trigger_register(struct led_trigger *trigger);
>  extern void led_trigger_unregister(struct led_trigger *trigger);
> --
> 1.7.9.5
>
