Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:5146 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751254Ab2HKHep (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 11 Aug 2012 03:34:45 -0400
Message-ID: <50260B4F.5000602@redhat.com>
Date: Sat, 11 Aug 2012 09:35:43 +0200
From: Hans de Goede <hdegoede@redhat.com>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@redhat.com>
CC: Linux Media Mailing List <linux-media@vger.kernel.org>,
	David Rientjes <rientjes@google.com>,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] radio-shark: Only compile led support when CONFIG_LED_CLASS
 is set
References: <1344628686-10482-1-git-send-email-hdegoede@redhat.com> <50256BF5.7090704@redhat.com>
In-Reply-To: <50256BF5.7090704@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

On 08/10/2012 10:15 PM, Mauro Carvalho Chehab wrote:
> Em 10-08-2012 16:58, Hans de Goede escreveu:
>> Reported-by: Dadiv Rientjes <rientjes@google.com>
>> Signed-off-by: Hans de Goede <hdegoede@redhat.com>
>> ---
>>   drivers/media/radio/radio-shark.c | 26 ++++++++++++++++++++++++--
>>   1 file changed, 24 insertions(+), 2 deletions(-)
>>
>> diff --git a/drivers/media/radio/radio-shark.c b/drivers/media/radio/radio-shark.c
>> index c2ead23..f746ed0 100644
>> --- a/drivers/media/radio/radio-shark.c
>> +++ b/drivers/media/radio/radio-shark.c
>> @@ -27,7 +27,6 @@
>>
>>   #include <linux/init.h>
>>   #include <linux/kernel.h>
>> -#include <linux/leds.h>
>>   #include <linux/module.h>
>>   #include <linux/slab.h>
>>   #include <linux/usb.h>
>> @@ -35,6 +34,12 @@
>>   #include <media/v4l2-device.h>
>>   #include <sound/tea575x-tuner.h>
>>
>> +#if defined(CONFIG_LEDS_CLASS) || \
>> +    (defined(CONFIG_LEDS_CLASS_MODULE) && defined(CONFIG_RADIO_SHARK_MODULE))
>> +#include <linux/leds.h>
>
> Conditionally including headers is not a good thing.
>

Ok, I will make it unconditional then.

> ...
>>   static void usb_shark_disconnect(struct usb_interface *intf)
>>   {
>>   	struct v4l2_device *v4l2_dev = usb_get_intfdata(intf);
>>   	struct shark_device *shark = v4l2_dev_to_shark(v4l2_dev);
>> +#ifdef SHARK_USE_LEDS
>>   	int i;
>> +#endif
>>
>>   	mutex_lock(&shark->tea.mutex);
>>   	v4l2_device_disconnect(&shark->v4l2_dev);
>>   	snd_tea575x_exit(&shark->tea);
>>   	mutex_unlock(&shark->tea.mutex);
>>
>> +#ifdef SHARK_USE_LEDS
>>   	for (i = 0; i < NO_LEDS; i++)
>>   		led_classdev_unregister(&shark->leds[i]);
>> +#endif
>>
>>   	v4l2_device_put(&shark->v4l2_dev);
>>   }
>
> That looks ugly.

Agreed.

> Maybe you could code it on a different way.
>
> You could be move all shark_use_leds together into the same place at
> the code, like:
>

Sounds good, although I will still need to set a SHARK_USE_LEDS define at
the top of the file, to avoid having unused members in struct shark_device, not
that the compiler will complain but having them there for no good reason seems
undesirable.


> #if defined(CONFIG_LEDS_CLASS) || \
>      (defined(CONFIG_LEDS_CLASS_MODULE) && defined(CONFIG_RADIO_SHARK_MODULE))
>
>   static void shark_led_set_blue(struct led_classdev *led_cdev,
> ...
>   		.brightness_set = shark_led_set_red,
>   	},
>   };
>
> static void shark_led_disconnect(...)
> {
> ...
> }
>
> static void shark_led_release(...)
> {
> ...
> }
>
> static void shark_led_register(...)
> {
> ...
> }
> #else
> static inline void shark_led_disconnect(...) { };
> static inline void shark_led_release(...) { };
> static inline void shark_led_register(...)
> {
> 	printk(KERN_WARN "radio-shark: CONFIG_LED_CLASS not enabled. LEDs won't work\n");
> }
> #endif
>
> And let the rest of the code to call the shark_led functions, as if LEDS aren't enabled,
> the function stubs won't produce any code (well, except for the above error notice).
>
> The same comment also applies to patch 2.

Ok new versions of the 2 patches coming up (should be there in 2 hours or so, I want
to both compile and run-time test them both with / without leds).

Regards,

Hans
