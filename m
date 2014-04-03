Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout4.w1.samsung.com ([210.118.77.14]:47230 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752255AbaDCOyd (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 3 Apr 2014 10:54:33 -0400
Message-id: <533D7624.3010407@samsung.com>
Date: Thu, 03 Apr 2014 16:54:28 +0200
From: Jacek Anaszewski <j.anaszewski@samsung.com>
MIME-version: 1.0
To: Sakari Ailus <sakari.ailus@iki.fi>
Cc: Bryan Wu <cooloney@gmail.com>, milo kim <milo.kim@ti.com>,
	Linux LED Subsystem <linux-leds@vger.kernel.org>,
	Richard Purdie <rpurdie@rpsys.net>, linux-media@vger.kernel.org
Subject: Re: brightness units
References: <533A6905.3010600@samsung.com>
 <CAK5ve-LNU_BGUB_HxsbgiO4baM-39C7PWHRVx0DL=JTYfJGSuA@mail.gmail.com>
 <20140402151754.GG4522@valkosipuli.retiisi.org.uk>
In-reply-to: <20140402151754.GG4522@valkosipuli.retiisi.org.uk>
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Bryan, Milo and Sakari,

Thanks for the replies.

On 04/02/2014 05:17 PM, Sakari Ailus wrote:
> Hi Bryan,
>
> On Tue, Apr 01, 2014 at 03:09:55PM -0700, Bryan Wu wrote:
>> On Tue, Apr 1, 2014 at 12:21 AM, Jacek Anaszewski
>> <j.anaszewski@samsung.com> wrote:
>>> I am currently integrating LED subsystem and V4L2 Flash API.
>>> V4L2 Flash API defines units of torch and flash intensity
>>> in milliampers. In the LED subsystem documentation I can't
>>> find any reference to the brightness units. On the other
>>> hand there is led_brightness enum defined in the <linux/leds.h>
>>> header, with LED_FULL = 255, but not all leds drivers use it.
>>> I am aware that there are LEDs that can be only turned on/off
>>> without any possibility to set the current and in such cases
>>> LED_FULL doesn't reflect the current set.
>>>
>>
>> Actually led_brightness is an logic concept not like milliampers,
>> since different led drivers has different implementation which is
>> hardware related. Like PWM led driver, it will be converted to duty
>> cycles.
>>
>> For current control I do see some specific driver like LP55xx have it
>> but not for every one.
>>
>>> So far I've assumed that brightness is expressed in milliampers
>>> and I don't stick to the LED_FULL limit. It allows for passing
>>> flash/torch intensity from V4L2 controls to the leds API
>>> without conversion. I am not sure if the units should be
>>> fixed to milliampers in the LED subsystem or not. It would
>>> clarify the situation, but if the existing LED drivers don't
>>> stick to this unit then it would make a confusion.
>>>
>>
>> We probably need to convert those intensity to brightness numbers, for
>> example mapping the intensity value to 0 ~ 255 brightness level and
>> pass it to LED subsystem.
>
> I think for some devices it wouldn't matter much, but on those that
> generally are used as flash the current is known, and thus it should also be
> visible in the interface. The conversion from mA to native units could be
> done directly, or indirectly through the LED API.
>
> There are a few things to consider though: besides minimum and maximum
> values for the current, the V4L2 controls have a step parameter that would
> still need to be passed to the control handler when creating the control.
> That essentially tells the user space how many levels does the control have.
>
> Care must be taken if converting to LED API units in between mA and native
> units so that the values will get through unchanged. On the other hand, I
> don't expect to get more levels than 256 either. But even this assumes that
> the current selection would be linear.
>

After analyzing the problem I decided to implement it this way:

1. V4L2 Flash control will use existing LED API for setting/getting
    torch brightness
	- V4L2 Flash control handler will take care of
	  mA <-> enum led_brightness conversion
2. New API for flash leds will use mA with int primitive
    as its type
	- min, max and step parameters will not be used on the
	  LED subsystem level to keep it as simple as possible -
	  instead each flash driver will align the brightness
	  according to the device constraints; the adjusted value
	  will be made available for the LED subsystem after calling
	  led_update_flash_brightness function
	- min, max and step parameters will be passed to the
	  v4l2-flash in the v4l2_flash_ctrl_config structure -
	  it was introduced in my RFC.
3. New API for indicator LEDs will be introduced in the led_flash
    module - it will define its units as uA with int primitive
    as the type

If you have any comments please let me know.

Thanks,
Jacek Anaszewski
