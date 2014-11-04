Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ie0-f178.google.com ([209.85.223.178]:63570 "EHLO
	mail-ie0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750877AbaKDBha (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 3 Nov 2014 20:37:30 -0500
MIME-Version: 1.0
In-Reply-To: <CAK5ve-LMvocfZv+HYvYUjKPk-O+1u+JU2FUm-Ot9XB8SH9daWg@mail.gmail.com>
References: <1411399266-16375-1-git-send-email-j.anaszewski@samsung.com>
 <1411399266-16375-2-git-send-email-j.anaszewski@samsung.com> <CAK5ve-LMvocfZv+HYvYUjKPk-O+1u+JU2FUm-Ot9XB8SH9daWg@mail.gmail.com>
From: Bryan Wu <cooloney@gmail.com>
Date: Mon, 3 Nov 2014 17:37:09 -0800
Message-ID: <CAK5ve-+Qp-T-y9bce2p_+xG+V7kV=feWR_XRDVsbhCv9Ty_53w@mail.gmail.com>
Subject: Re: [PATCH/RFC v6 1/3] leds: implement sysfs interface locking mechanism
To: Jacek Anaszewski <j.anaszewski@samsung.com>
Cc: Linux LED Subsystem <linux-leds@vger.kernel.org>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	Kyungmin Park <kyungmin.park@samsung.com>,
	b.zolnierkie@samsung.com, Richard Purdie <rpurdie@rpsys.net>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Oct 20, 2014 at 6:01 PM, Bryan Wu <cooloney@gmail.com> wrote:
> On Mon, Sep 22, 2014 at 8:21 AM, Jacek Anaszewski
> <j.anaszewski@samsung.com> wrote:
>> Add a mechanism for locking LED subsystem sysfs interface.
>> This patch prepares ground for addition of LED Flash Class
>> extension, whose API will be integrated with V4L2 Flash API.
>> Such a fusion enforces introducing a locking scheme, which
>> will secure consistent access to the LED Flash Class device.
>>
>> The mechanism being introduced allows for disabling LED
>> subsystem sysfs interface by calling led_sysfs_disable function
>> and enabling it by calling led_sysfs_enable. The functions
>> alter the LED_SYSFS_DISABLE flag state and must be called
>> under mutex lock. The state of the lock is checked with use
>> of led_sysfs_is_disabled function. Such a design allows for
>> providing immediate feedback to the user space on whether
>> the LED Flash Class device is available or is under V4L2 Flash
>> sub-device control.
>>
>
> I'm good with this and will merge it soon.
>

Just merged it into my tree.

Thanks,
-Bryan


>> Signed-off-by: Jacek Anaszewski <j.anaszewski@samsung.com>
>> Acked-by: Kyungmin Park <kyungmin.park@samsung.com>
>> Cc: Bryan Wu <cooloney@gmail.com>
>> Cc: Richard Purdie <rpurdie@rpsys.net>
>> ---
>>  drivers/leds/led-class.c    |   19 ++++++++++++++++---
>>  drivers/leds/led-core.c     |   18 ++++++++++++++++++
>>  drivers/leds/led-triggers.c |   16 +++++++++++++---
>>  include/linux/leds.h        |   32 ++++++++++++++++++++++++++++++++
>>  4 files changed, 79 insertions(+), 6 deletions(-)
>>
>> diff --git a/drivers/leds/led-class.c b/drivers/leds/led-class.c
>> index 2e124aa2..a39ca8f 100644
>> --- a/drivers/leds/led-class.c
>> +++ b/drivers/leds/led-class.c
>> @@ -39,17 +39,27 @@ static ssize_t brightness_store(struct device *dev,
>>  {
>>         struct led_classdev *led_cdev = dev_get_drvdata(dev);
>>         unsigned long state;
>> -       ssize_t ret = -EINVAL;
>> +       ssize_t ret;
>> +
>> +       mutex_lock(&led_cdev->led_access);
>> +
>> +       if (led_sysfs_is_disabled(led_cdev)) {
>> +               ret = -EBUSY;
>> +               goto unlock;
>> +       }
>>
>>         ret = kstrtoul(buf, 10, &state);
>>         if (ret)
>> -               return ret;
>> +               goto unlock;
>>
>>         if (state == LED_OFF)
>>                 led_trigger_remove(led_cdev);
>>         __led_set_brightness(led_cdev, state);
>>
>> -       return size;
>> +       ret = size;
>> +unlock:
>> +       mutex_unlock(&led_cdev->led_access);
>> +       return ret;
>>  }
>>  static DEVICE_ATTR_RW(brightness);
>>
>> @@ -213,6 +223,7 @@ int led_classdev_register(struct device *parent, struct led_classdev *led_cdev)
>>  #ifdef CONFIG_LEDS_TRIGGERS
>>         init_rwsem(&led_cdev->trigger_lock);
>>  #endif
>> +       mutex_init(&led_cdev->led_access);
>>         /* add to the list of leds */
>>         down_write(&leds_list_lock);
>>         list_add_tail(&led_cdev->node, &leds_list);
>> @@ -266,6 +277,8 @@ void led_classdev_unregister(struct led_classdev *led_cdev)
>>         down_write(&leds_list_lock);
>>         list_del(&led_cdev->node);
>>         up_write(&leds_list_lock);
>> +
>> +       mutex_destroy(&led_cdev->led_access);
>>  }
>>  EXPORT_SYMBOL_GPL(led_classdev_unregister);
>>
>> diff --git a/drivers/leds/led-core.c b/drivers/leds/led-core.c
>> index 0d15aa9..cca86ab 100644
>> --- a/drivers/leds/led-core.c
>> +++ b/drivers/leds/led-core.c
>> @@ -142,3 +142,21 @@ int led_update_brightness(struct led_classdev *led_cdev)
>>         return ret;
>>  }
>>  EXPORT_SYMBOL(led_update_brightness);
>> +
>> +/* Caller must ensure led_cdev->led_access held */
>> +void led_sysfs_disable(struct led_classdev *led_cdev)
>> +{
>> +       lockdep_assert_held(&led_cdev->led_access);
>> +
>> +       led_cdev->flags |= LED_SYSFS_DISABLE;
>> +}
>> +EXPORT_SYMBOL_GPL(led_sysfs_disable);
>> +
>> +/* Caller must ensure led_cdev->led_access held */
>> +void led_sysfs_enable(struct led_classdev *led_cdev)
>> +{
>> +       lockdep_assert_held(&led_cdev->led_access);
>> +
>> +       led_cdev->flags &= ~LED_SYSFS_DISABLE;
>> +}
>> +EXPORT_SYMBOL_GPL(led_sysfs_enable);
>> diff --git a/drivers/leds/led-triggers.c b/drivers/leds/led-triggers.c
>> index c3734f1..e8b1120 100644
>> --- a/drivers/leds/led-triggers.c
>> +++ b/drivers/leds/led-triggers.c
>> @@ -37,6 +37,14 @@ ssize_t led_trigger_store(struct device *dev, struct device_attribute *attr,
>>         char trigger_name[TRIG_NAME_MAX];
>>         struct led_trigger *trig;
>>         size_t len;
>> +       int ret = count;
>> +
>> +       mutex_lock(&led_cdev->led_access);
>> +
>> +       if (led_sysfs_is_disabled(led_cdev)) {
>> +               ret = -EBUSY;
>> +               goto unlock;
>> +       }
>>
>>         trigger_name[sizeof(trigger_name) - 1] = '\0';
>>         strncpy(trigger_name, buf, sizeof(trigger_name) - 1);
>> @@ -47,7 +55,7 @@ ssize_t led_trigger_store(struct device *dev, struct device_attribute *attr,
>>
>>         if (!strcmp(trigger_name, "none")) {
>>                 led_trigger_remove(led_cdev);
>> -               return count;
>> +               goto unlock;
>>         }
>>
>>         down_read(&triggers_list_lock);
>> @@ -58,12 +66,14 @@ ssize_t led_trigger_store(struct device *dev, struct device_attribute *attr,
>>                         up_write(&led_cdev->trigger_lock);
>>
>>                         up_read(&triggers_list_lock);
>> -                       return count;
>> +                       goto unlock;
>>                 }
>>         }
>>         up_read(&triggers_list_lock);
>>
>> -       return -EINVAL;
>> +unlock:
>> +       mutex_unlock(&led_cdev->led_access);
>> +       return ret;
>>  }
>>  EXPORT_SYMBOL_GPL(led_trigger_store);
>>
>> diff --git a/include/linux/leds.h b/include/linux/leds.h
>> index f8b2f58..44c8a98 100644
>> --- a/include/linux/leds.h
>> +++ b/include/linux/leds.h
>> @@ -13,6 +13,7 @@
>>  #define __LINUX_LEDS_H_INCLUDED
>>
>>  #include <linux/list.h>
>> +#include <linux/mutex.h>
>>  #include <linux/rwsem.h>
>>  #include <linux/spinlock.h>
>>  #include <linux/timer.h>
>> @@ -42,6 +43,7 @@ struct led_classdev {
>>  #define LED_BLINK_ONESHOT      (1 << 17)
>>  #define LED_BLINK_ONESHOT_STOP (1 << 18)
>>  #define LED_BLINK_INVERT       (1 << 19)
>> +#define LED_SYSFS_DISABLE      (1 << 20)
>>
>>         /* Set LED brightness level */
>>         /* Must not sleep, use a workqueue if needed */
>> @@ -85,6 +87,9 @@ struct led_classdev {
>>         /* true if activated - deactivate routine uses it to do cleanup */
>>         bool                    activated;
>>  #endif
>> +
>> +       /* Ensures consistent access to the LED Flash Class device */
>> +       struct mutex            led_access;
>>  };
>>
>>  extern int led_classdev_register(struct device *parent,
>> @@ -151,6 +156,33 @@ extern void led_set_brightness(struct led_classdev *led_cdev,
>>   */
>>  extern int led_update_brightness(struct led_classdev *led_cdev);
>>
>> +/**
>> + * led_sysfs_disable - disable LED sysfs interface
>> + * @led_cdev: the LED to set
>> + *
>> + * Disable the led_cdev's sysfs interface.
>> + */
>> +extern void led_sysfs_disable(struct led_classdev *led_cdev);
>> +
>> +/**
>> + * led_sysfs_enable - enable LED sysfs interface
>> + * @led_cdev: the LED to set
>> + *
>> + * Enable the led_cdev's sysfs interface.
>> + */
>> +extern void led_sysfs_enable(struct led_classdev *led_cdev);
>> +
>> +/**
>> + * led_sysfs_is_disabled - check if LED sysfs interface is disabled
>> + * @led_cdev: the LED to query
>> + *
>> + * Returns: true if the led_cdev's sysfs interface is disabled.
>> + */
>> +static inline bool led_sysfs_is_disabled(struct led_classdev *led_cdev)
>> +{
>> +       return led_cdev->flags & LED_SYSFS_DISABLE;
>> +}
>> +
>>  /*
>>   * LED Triggers
>>   */
>> --
>> 1.7.9.5
>>
