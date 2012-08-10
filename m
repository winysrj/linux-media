Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:18994 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753621Ab2HJUPx (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 10 Aug 2012 16:15:53 -0400
Message-ID: <50256BF5.7090704@redhat.com>
Date: Fri, 10 Aug 2012 17:15:49 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Hans de Goede <hdegoede@redhat.com>
CC: Linux Media Mailing List <linux-media@vger.kernel.org>,
	David Rientjes <rientjes@google.com>,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] radio-shark: Only compile led support when CONFIG_LED_CLASS
 is set
References: <1344628686-10482-1-git-send-email-hdegoede@redhat.com>
In-Reply-To: <1344628686-10482-1-git-send-email-hdegoede@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em 10-08-2012 16:58, Hans de Goede escreveu:
> Reported-by: Dadiv Rientjes <rientjes@google.com>
> Signed-off-by: Hans de Goede <hdegoede@redhat.com>
> ---
>  drivers/media/radio/radio-shark.c | 26 ++++++++++++++++++++++++--
>  1 file changed, 24 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/media/radio/radio-shark.c b/drivers/media/radio/radio-shark.c
> index c2ead23..f746ed0 100644
> --- a/drivers/media/radio/radio-shark.c
> +++ b/drivers/media/radio/radio-shark.c
> @@ -27,7 +27,6 @@
>  
>  #include <linux/init.h>
>  #include <linux/kernel.h>
> -#include <linux/leds.h>
>  #include <linux/module.h>
>  #include <linux/slab.h>
>  #include <linux/usb.h>
> @@ -35,6 +34,12 @@
>  #include <media/v4l2-device.h>
>  #include <sound/tea575x-tuner.h>
>  
> +#if defined(CONFIG_LEDS_CLASS) || \
> +    (defined(CONFIG_LEDS_CLASS_MODULE) && defined(CONFIG_RADIO_SHARK_MODULE))
> +#include <linux/leds.h>

Conditionally including headers is not a good thing.

...
>  static void usb_shark_disconnect(struct usb_interface *intf)
>  {
>  	struct v4l2_device *v4l2_dev = usb_get_intfdata(intf);
>  	struct shark_device *shark = v4l2_dev_to_shark(v4l2_dev);
> +#ifdef SHARK_USE_LEDS
>  	int i;
> +#endif
>  
>  	mutex_lock(&shark->tea.mutex);
>  	v4l2_device_disconnect(&shark->v4l2_dev);
>  	snd_tea575x_exit(&shark->tea);
>  	mutex_unlock(&shark->tea.mutex);
>  
> +#ifdef SHARK_USE_LEDS
>  	for (i = 0; i < NO_LEDS; i++)
>  		led_classdev_unregister(&shark->leds[i]);
> +#endif
>  
>  	v4l2_device_put(&shark->v4l2_dev);
>  }

That looks ugly. Maybe you could code it on a different way.

You could be move all shark_use_leds together into the same place at
the code, like:

#if defined(CONFIG_LEDS_CLASS) || \
    (defined(CONFIG_LEDS_CLASS_MODULE) && defined(CONFIG_RADIO_SHARK_MODULE))

 static void shark_led_set_blue(struct led_classdev *led_cdev,
...
 		.brightness_set = shark_led_set_red,
 	},
 };

static void shark_led_disconnect(...)
{
...
}

static void shark_led_release(...)
{
...
}

static void shark_led_register(...)
{
...
}
#else
static inline void shark_led_disconnect(...) { };
static inline void shark_led_release(...) { };
static inline void shark_led_register(...)
{
	printk(KERN_WARN "radio-shark: CONFIG_LED_CLASS not enabled. LEDs won't work\n");
}
#endif

And let the rest of the code to call the shark_led functions, as if LEDS aren't enabled,
the function stubs won't produce any code (well, except for the above error notice).

The same comment also applies to patch 2.

Regards,
Mauro
