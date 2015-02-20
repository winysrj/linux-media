Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.w1.samsung.com ([210.118.77.13]:41950 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753431AbbBTIzR (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 20 Feb 2015 03:55:17 -0500
Message-id: <54E6F671.7070500@samsung.com>
Date: Fri, 20 Feb 2015 09:55:13 +0100
From: Jacek Anaszewski <j.anaszewski@samsung.com>
MIME-version: 1.0
To: Pavel Machek <pavel@ucw.cz>
Cc: Greg KH <greg@kroah.com>, Sakari Ailus <sakari.ailus@iki.fi>,
	linux-leds@vger.kernel.org, linux-media@vger.kernel.org,
	devicetree@vger.kernel.org, kyungmin.park@samsung.com,
	cooloney@gmail.com, rpurdie@rpsys.net, s.nawrocki@samsung.com
Subject: Re: 0.led_name 2.other.led.name in /sysfs Re: [PATCH/RFC v11 01/20]
 leds: flash: document sysfs interface
References: <1424276441-3969-1-git-send-email-j.anaszewski@samsung.com>
 <1424276441-3969-2-git-send-email-j.anaszewski@samsung.com>
 <20150218224747.GA3999@amd> <20150219090204.GI3915@valkosipuli.retiisi.org.uk>
 <20150219214043.GB29875@kroah.com> <54E6E89B.4050404@samsung.com>
 <20150220081617.GA14057@amd>
In-reply-to: <20150220081617.GA14057@amd>
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Pavel,

On 02/20/2015 09:16 AM, Pavel Machek wrote:
> Hi!
>
>>>>>> +What:		/sys/class/leds/<led>/available_sync_leds
>>>>>> +Date:		February 2015
>>>>>> +KernelVersion:	3.20
>>>>>> +Contact:	Jacek Anaszewski <j.anaszewski@samsung.com>
>>>>>> +Description:	read/write
>>>>>> +		Space separated list of LEDs available for flash strobe
>>>>>> +		synchronization, displayed in the format:
>>>>>> +
>>>>>> +		led1_id.led1_name led2_id.led2_name led3_id.led3_name etc.
>>>>>
>>>>> Multiple values per file, with all the problems we had in /proc. I
>>>>> assume led_id is an integer? What prevents space or dot in led name?
>>>>
>>>> Very good point. How about using a newline instead? That'd be a little bit
>>>> easier to parse, too.
>>>
>>> No, please make it one value per-file, which is what sysfs requires.
>>
>> The purpose of this attribute is only to provide an information about
>> the range of valid identifiers that can be written to the
>> flash_sync_strobe attribute. Wouldn't splitting this to many attributes
>> be an unnecessary inflation of sysfs files?
>
> No, it would not. It is required so that we don't end up with broken
> parsers.

Let's discuss the acceptable approach then. I propose a directory
named synchronized_strobe and containing the files as you proposed
in one of the previous messages: led_id.active and led_id.name.
The attribute flash_sync_strobe would be redundant then and should
be removed.

Use cases for two LEDs:

- max77693-led1
- max77693-led2

#cd synchronized_strobe
#ls
#0.active 0.name 1.active 1.name
#cat 0.name
#max77693-led1
#cat 0.active
#0
#cat 1.name
#max77693-led2
#cat 1.active
#0
#echo 1 > 0.active
#cat 0.active
#1
#echo 1 > 1.active
#cat 0.active
#0
#cat 1.active
#1


>> Apart from it, we have also flash_faults attribute, that currently
>> provides a space separated list of flash faults that have occurred.
>> If we are to stick tightly to the one-value-per-file rule, then how
>> we should approach flash_faults case? Should the separate file be
>> dynamically created for each reported fault?
>
> I think you can get away with flash_faults attribute (since the
> strings are hardcoded).

If so, the attribute will be left as is.

> Dynamically created files would be extremely ugly interface, but you
> could also have files such as "overvoltage_fault" containing either 0
> or 1 ...

-- 
Best Regards,
Jacek Anaszewski
