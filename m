Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout4.w1.samsung.com ([210.118.77.14]:62741 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965115AbaKNKVk (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 14 Nov 2014 05:21:40 -0500
Message-id: <5465D7AF.9010903@samsung.com>
Date: Fri, 14 Nov 2014 11:21:35 +0100
From: Jacek Anaszewski <j.anaszewski@samsung.com>
MIME-version: 1.0
To: Bryan Wu <cooloney@gmail.com>
Cc: Linux LED Subsystem <linux-leds@vger.kernel.org>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	sakari.ailus@linux.intel.com,
	Kyungmin Park <kyungmin.park@samsung.com>,
	b.zolnierkie@samsung.com, Richard Purdie <rpurdie@rpsys.net>
Subject: Re: [PATCH/RFC v7 3/3] Documentation: leds: Add description of LED
 Flash Class extension
References: <1415808557-29557-1-git-send-email-j.anaszewski@samsung.com>
 <1415808557-29557-4-git-send-email-j.anaszewski@samsung.com>
 <CAK5ve-JH0KQs1Q4TcgaxmfAhOP9kDc-9r7HnbfOKECRPWQ2aXQ@mail.gmail.com>
In-reply-to: <CAK5ve-JH0KQs1Q4TcgaxmfAhOP9kDc-9r7HnbfOKECRPWQ2aXQ@mail.gmail.com>
Content-type: text/plain; charset=UTF-8; format=flowed
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Bryan,

Thanks for a review.

On 11/13/2014 07:58 PM, Bryan Wu wrote:
> On Wed, Nov 12, 2014 at 8:09 AM, Jacek Anaszewski
> <j.anaszewski@samsung.com> wrote:
>> The documentation being added contains overall description of the
>> LED Flash Class and the related sysfs attributes.
>>
>> Signed-off-by: Jacek Anaszewski <j.anaszewski@samsung.com>
>> Acked-by: Kyungmin Park <kyungmin.park@samsung.com>
>> Cc: Bryan Wu <cooloney@gmail.com>
>> Cc: Richard Purdie <rpurdie@rpsys.net>
>> ---
>>   Documentation/leds/leds-class-flash.txt |   39 +++++++++++++++++++++++++++++++
>>   1 file changed, 39 insertions(+)
>>   create mode 100644 Documentation/leds/leds-class-flash.txt
>>
>> diff --git a/Documentation/leds/leds-class-flash.txt b/Documentation/leds/leds-class-flash.txt
>> new file mode 100644
>> index 0000000..0164329
>> --- /dev/null
>> +++ b/Documentation/leds/leds-class-flash.txt
>> @@ -0,0 +1,39 @@
>> +
>> +Flash LED handling under Linux
>> +==============================
>> +
>> +Some LED devices support two modes - torch and flash. In order to enable
>
> I think I asked this question before, Torch, Flash and Indicator. As
> you answered torch is implemented by sync led brightness set operation
> in our LEDS_CLASS and Flash is implemented in this LEDS_CLASS_FLASH.
>
> I suggest put this information in document or code comments. Then
> people know how to use torch and flash.

Good point.

> For indicator I still don't know why we need this since indicator is
> like blinking and it should be support by LEDS_CLASS right?

Indicator led is strictly related to flash devices. It is also called a
"privacy led" because of its purpose - protecting a privacy of a person
being recorded by providing a light signal signifying that a camera is
on. It is a low current led, but some devices use the same led as
for torch and flash and only apply reduced current in the indicator
mode.

In the V4L2 subsystem I see only one driver supporting indicator
leds: /drivers/media/i2c/as3645a.c. It looks like indicator intensity
can be set only when flash mode is V4L2_FLASH_LED_MODE_NONE, i.e. torch
and flash leds cannot be active simultaneously with indicator led.
It is reasonable, as active torch led is a sufficient signalization
of recording.

In the LED subsystem I also see indicators in some drivers,
e.g. leds-lm355x.c, but they are registered as a separate LED class
devices. Moreover the driver adds also a "pattern" sysfs attribute
for choosing indicator blinking pattern so that is something to be
added to the LED Flash class.
I think that similar improvement to the V4L2 Flash API should be made.

Sakari, what is your opinion?

> Flash is for some camera capture, right?
>
>> +support for flash LEDs CONFIG_LEDS_CLASS_FLASH symbol must be defined
>> +in the kernel config. A flash LED driver must register in the LED subsystem
>> +with led_classdev_flash_register to gain flash capabilities.
>> +
>> +Following sysfs attributes are exposed for controlling flash led devices:
>> +
>> +       - flash_brightness - flash LED brightness in microamperes (RW)
>> +       - max_flash_brightness - maximum available flash LED brightness (RO)
>> +       - indicator_brightness - privacy LED brightness in microamperes (RW)
>> +       - max_indicator_brightness - maximum privacy LED brightness in
>> +                                    microamperes (RO)
>
> What's the privacy mean here?

Indeed, consistent naming should be applied, so I will modify it to:

"maximum indicator LED brightness in microaperes (RO)"

>> +       - flash_timeout - flash strobe duration in microseconds (RW)
>> +       - max_flash_timeout - maximum available flash strobe duration (RO)
>> +       - flash_strobe - flash strobe state (RW)
>> +       - flash_fault - bitmask of flash faults that may have occurred,
>> +                       possible flags are:
>> +               * 0x01 - flash controller voltage to the flash LED has exceeded
>> +                        the limit specific to the flash controller
>> +               * 0x02 - the flash strobe was still on when the timeout set by
>> +                        the user has expired; not all flash controllers may
>> +                        set this in all such conditions
>> +               * 0x04 - the flash controller has overheated
>> +               * 0x08 - the short circuit protection of the flash controller
>> +                        has been triggered
>> +               * 0x10 - current in the LED power supply has exceeded the limit
>> +                        specific to the flash controller
>> +               * 0x40 - flash controller voltage to the flash LED has been
>> +                        below the minimum limit specific to the flash
>> +               * 0x80 - the input voltage of the flash controller is below
>> +                        the limit under which strobing the flash at full
>> +                        current will not be possible. The condition persists
>> +                        until this flag is no longer set
>> +               * 0x100 - the temperature of the LED has exceeded its allowed
>> +                         upper limit
>
> Are these error code the same for all the LED controller? Or just for
> some specific chip?

They are generic error codes, and map directly to V4L2 Flash errors.
Error descriptions were copied from the V4L2 Flash documentation.

Best Regards,
Jacek Anaszewski
