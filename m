Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.w1.samsung.com ([210.118.77.12]:23916 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753119AbaLALkP (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 1 Dec 2014 06:40:15 -0500
Message-id: <547C539A.4010500@samsung.com>
Date: Mon, 01 Dec 2014 12:40:10 +0100
From: Jacek Anaszewski <j.anaszewski@samsung.com>
MIME-version: 1.0
To: Pavel Machek <pavel@ucw.cz>
Cc: linux-leds@vger.kernel.org, linux-media@vger.kernel.org,
	linux-kernel@vger.kernel.org, kyungmin.park@samsung.com,
	b.zolnierkie@samsung.com, cooloney@gmail.com, rpurdie@rpsys.net,
	sakari.ailus@iki.fi, s.nawrocki@samsung.com
Subject: Re: [PATCH/RFC v8 02/14] Documentation: leds: Add description of LED
 Flash class extension
References: <1417166286-27685-1-git-send-email-j.anaszewski@samsung.com>
 <1417166286-27685-3-git-send-email-j.anaszewski@samsung.com>
 <20141129125832.GA315@amd>
In-reply-to: <20141129125832.GA315@amd>
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Pavel,

Thanks for a review.

On 11/29/2014 01:58 PM, Pavel Machek wrote:
> Hi!
>
>> +Flash LED handling under Linux
>> +==============================
>> +
>> +Some LED devices support two modes - torch and flash. The modes are
>> +supported by the LED class (see Documentation/leds/leds-class.txt)
>> +and LED Flash class respectively.
>> +
>> +In order to enable support for flash LEDs CONFIG_LEDS_CLASS_FLASH symbol
>> +must be defined in the kernel config. A flash LED driver must register
>> +in the LED subsystem with led_classdev_flash_register to gain flash
>> +capabilities.
>> +
>> +Following sysfs attributes are exposed for controlling flash led devices:
>> +
>> +	- flash_brightness - flash LED brightness in microamperes (RW)
>> +	- max_flash_brightness - maximum available flash LED brightness (RO)
>> +	- indicator_brightness - privacy LED brightness in microamperes (RW)
>> +	- max_indicator_brightness - maximum privacy LED brightness in
>> +				     microamperes (RO)
>> +	- flash_timeout - flash strobe duration in microseconds (RW)
>> +	- max_flash_timeout - maximum available flash strobe duration (RO)
>> +	- flash_strobe - flash strobe state (RW)
>> +	- flash_sync_strobe - one flash device can control more than one
>> +			      sub-led; when this atrribute is set to 1
>> +			      the flash led will be strobed synchronously
>> +			      with the other ones controlled by the same
>> +			      device (RW)
>
> This is not really clear. Does flash_timeout or flash_brightness need
> to be set, first?

I would go for inheriting the settings from the led that is strobed
explicitly. Limits regarding current, the ones from device tree node,
would have to however be preserved in my opinion.
A consensus is needed here.

> Do we really want to have separate indicator brightnesses in uA?
> Should we maybe reuse existing "brightness" parameter for torch and
> indication, maybe adding single (RO) indicator_brightness attribute?

I forgot to remove the indicator related positions. It has been
definitely removed from the LED subsystem related patches.

>> +	- flash_fault - bitmask of flash faults that may have occurred,
>> +			possible flags are:
>> +		* 0x01 - flash controller voltage to the flash LED has exceeded
>> +			 the limit specific to the flash controller
>> +		* 0x02 - the flash strobe was still on when the timeout set by
>> +			 the user has expired; not all flash controllers may
>> +			 set this in all such conditions
>> +		* 0x04 - the flash controller has overheated
>> +		* 0x08 - the short circuit protection of the flash controller
>> +			 has been triggered
>> +		* 0x10 - current in the LED power supply has exceeded the limit
>> +			 specific to the flash controller
>> +		* 0x40 - flash controller voltage to the flash LED has been
>> +			 below the minimum limit specific to the flash
>> +		* 0x80 - the input voltage of the flash controller is below
>> +			 the limit under which strobing the flash at full
>> +			 current will not be possible. The condition persists
>> +			 until this flag is no longer set
>> +		* 0x100 - the temperature of the LED has exceeded its allowed
>> +			  upper limit
>
> How are faults cleared? Should it be list of strings, instead of
> bitmask? We may want to add new fault modes in future...

Faults are cleared by reading the attribute. I will add this note.
There can be more than one fault at a time. I think that the bitmask
is a flexible solution. I don't see any troubles related to adding
new fault modes in the future, do you?

Best Regards,
Jacek Anaszewski

