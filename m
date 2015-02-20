Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.w1.samsung.com ([210.118.77.11]:40364 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752804AbbBTH4P (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 20 Feb 2015 02:56:15 -0500
Message-id: <54E6E89B.4050404@samsung.com>
Date: Fri, 20 Feb 2015 08:56:11 +0100
From: Jacek Anaszewski <j.anaszewski@samsung.com>
MIME-version: 1.0
To: Greg KH <greg@kroah.com>
Cc: Sakari Ailus <sakari.ailus@iki.fi>, Pavel Machek <pavel@ucw.cz>,
	linux-leds@vger.kernel.org, linux-media@vger.kernel.org,
	devicetree@vger.kernel.org, kyungmin.park@samsung.com,
	cooloney@gmail.com, rpurdie@rpsys.net, s.nawrocki@samsung.com
Subject: Re: 0.led_name 2.other.led.name in /sysfs Re: [PATCH/RFC v11 01/20]
 leds: flash: document sysfs interface
References: <1424276441-3969-1-git-send-email-j.anaszewski@samsung.com>
 <1424276441-3969-2-git-send-email-j.anaszewski@samsung.com>
 <20150218224747.GA3999@amd> <20150219090204.GI3915@valkosipuli.retiisi.org.uk>
 <20150219214043.GB29875@kroah.com>
In-reply-to: <20150219214043.GB29875@kroah.com>
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 02/19/2015 10:40 PM, Greg KH wrote:
> On Thu, Feb 19, 2015 at 11:02:04AM +0200, Sakari Ailus wrote:
>> On Wed, Feb 18, 2015 at 11:47:47PM +0100, Pavel Machek wrote:
>>>
>>> On Wed 2015-02-18 17:20:22, Jacek Anaszewski wrote:
>>>> Add a documentation of LED Flash class specific sysfs attributes.
>>>>
>>>> Signed-off-by: Jacek Anaszewski <j.anaszewski@samsung.com>
>>>> Acked-by: Kyungmin Park <kyungmin.park@samsung.com>
>>>> Cc: Bryan Wu <cooloney@gmail.com>
>>>> Cc: Richard Purdie <rpurdie@rpsys.net>
>>>
>>> NAK-ed-by: Pavel Machek
>>>
>>>> +What:		/sys/class/leds/<led>/available_sync_leds
>>>> +Date:		February 2015
>>>> +KernelVersion:	3.20
>>>> +Contact:	Jacek Anaszewski <j.anaszewski@samsung.com>
>>>> +Description:	read/write
>>>> +		Space separated list of LEDs available for flash strobe
>>>> +		synchronization, displayed in the format:
>>>> +
>>>> +		led1_id.led1_name led2_id.led2_name led3_id.led3_name etc.
>>>
>>> Multiple values per file, with all the problems we had in /proc. I
>>> assume led_id is an integer? What prevents space or dot in led name?
>>
>> Very good point. How about using a newline instead? That'd be a little bit
>> easier to parse, too.
>
> No, please make it one value per-file, which is what sysfs requires.

The purpose of this attribute is only to provide an information about
the range of valid identifiers that can be written to the
flash_sync_strobe attribute. Wouldn't splitting this to many attributes
be an unnecessary inflation of sysfs files?

Apart from it, we have also flash_faults attribute, that currently
provides a space separated list of flash faults that have occurred.
If we are to stick tightly to the one-value-per-file rule, then how
we should approach flash_faults case? Should the separate file be
dynamically created for each reported fault?

-- 
Best Regards,
Jacek Anaszewski
