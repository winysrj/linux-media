Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.w1.samsung.com ([210.118.77.13]:22633 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751891AbbALIEf (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 12 Jan 2015 03:04:35 -0500
Message-id: <54B3800C.2000704@samsung.com>
Date: Mon, 12 Jan 2015 09:04:28 +0100
From: Jacek Anaszewski <j.anaszewski@samsung.com>
MIME-version: 1.0
To: Pavel Machek <pavel@ucw.cz>
Cc: linux-leds@vger.kernel.org, linux-media@vger.kernel.org,
	linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
	kyungmin.park@samsung.com, b.zolnierkie@samsung.com,
	cooloney@gmail.com, rpurdie@rpsys.net, sakari.ailus@iki.fi,
	s.nawrocki@samsung.com
Subject: Re: [PATCH/RFC v10 02/19] Documentation: leds: Add description of LED
 Flash class extension
References: <1420816989-1808-1-git-send-email-j.anaszewski@samsung.com>
 <1420816989-1808-3-git-send-email-j.anaszewski@samsung.com>
 <20150109174058.GC18076@amd>
In-reply-to: <20150109174058.GC18076@amd>
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Pavel,

Thanks for the review.

On 01/09/2015 06:40 PM, Pavel Machek wrote:
> Hi!
>
>> The documentation being added contains overall description of the
>> LED Flash Class and the related sysfs attributes.
>>
>> Signed-off-by: Jacek Anaszewski <j.anaszewski@samsung.com>
>> Acked-by: Kyungmin Park <kyungmin.park@samsung.com>
>> Cc: Bryan Wu <cooloney@gmail.com>
>> Cc: Richard Purdie <rpurdie@rpsys.net>
>
>> +In order to enable support for flash LEDs CONFIG_LEDS_CLASS_FLASH symbol
>> +must be defined in the kernel config. A flash LED driver must register
>> +in the LED subsystem with led_classdev_flash_register function to gain flash
>> +related capabilities.
>> +
>> +There are flash LED devices which can control more than one LED and allow for
>> +strobing the sub-leds synchronously. A LED will be strobed synchronously with
>> +the one whose identifier is written to the flash_sync_strobe sysfs attribute.
>> +The list of available sub-led identifiers can be read from the
>
> sub-LED?

Indeed, this naming will be more consistent.

>> +	- flash_fault - bitmask of flash faults that may have occurred
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
>> +		* 0x20 - the flash controller has detected a short or open
>> +			 circuit condition on the indicator LED
>> +		* 0x40 - flash controller voltage to the flash LED has been
>> +			 below the minimum limit specific to the flash
>> +		* 0x80 - the input voltage of the flash controller is below
>> +			 the limit under which strobing the flash at full
>> +			 current will not be possible. The condition persists
>> +			 until this flag is no longer set
>> +		* 0x100 - the temperature of the LED has exceeded its allowed
>> +			  upper limit
>
> Did not everyone agree that text strings are preferable to bitmasks?
>
> 									Pavel
>

I just forgot to update the flash_fault documentation. Will fix in the
next version.

-- 
Best Regards,
Jacek Anaszewski
