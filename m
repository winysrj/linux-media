Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.w1.samsung.com ([210.118.77.12]:10537 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751605AbbB0OeZ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 27 Feb 2015 09:34:25 -0500
Message-id: <54F0806E.2040309@samsung.com>
Date: Fri, 27 Feb 2015 15:34:22 +0100
From: Jacek Anaszewski <j.anaszewski@samsung.com>
MIME-version: 1.0
To: Sakari Ailus <sakari.ailus@iki.fi>
Cc: Pavel Machek <pavel@ucw.cz>, Greg KH <greg@kroah.com>,
	linux-leds@vger.kernel.org, linux-media@vger.kernel.org,
	devicetree@vger.kernel.org, kyungmin.park@samsung.com,
	cooloney@gmail.com, rpurdie@rpsys.net, s.nawrocki@samsung.com
Subject: Re: 0.led_name 2.other.led.name in /sysfs Re: [PATCH/RFC v11 01/20]
 leds: flash: document sysfs interface
References: <1424276441-3969-1-git-send-email-j.anaszewski@samsung.com>
 <1424276441-3969-2-git-send-email-j.anaszewski@samsung.com>
 <20150218224747.GA3999@amd> <20150219090204.GI3915@valkosipuli.retiisi.org.uk>
 <20150219214043.GB29875@kroah.com> <54E6E89B.4050404@samsung.com>
 <20150220153616.GB18111@kroah.com> <20150220205738.GA28995@amd>
 <20150221105733.GO3915@valkosipuli.retiisi.org.uk>
In-reply-to: <20150221105733.GO3915@valkosipuli.retiisi.org.uk>
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sakari,

On 02/21/2015 11:57 AM, Sakari Ailus wrote:
> Hi Pavel and Greg,
>
> On Fri, Feb 20, 2015 at 09:57:38PM +0100, Pavel Machek wrote:
>> On Fri 2015-02-20 07:36:16, Greg KH wrote:
>>> On Fri, Feb 20, 2015 at 08:56:11AM +0100, Jacek Anaszewski wrote:
>>>> On 02/19/2015 10:40 PM, Greg KH wrote:
>>>>> On Thu, Feb 19, 2015 at 11:02:04AM +0200, Sakari Ailus wrote:
>>>>>> On Wed, Feb 18, 2015 at 11:47:47PM +0100, Pavel Machek wrote:
>>>>>>>
>>>>>>> On Wed 2015-02-18 17:20:22, Jacek Anaszewski wrote:
>>>>>>>> Add a documentation of LED Flash class specific sysfs attributes.
>>>>>>>>
>>>>>>>> Signed-off-by: Jacek Anaszewski <j.anaszewski@samsung.com>
>>>>>>>> Acked-by: Kyungmin Park <kyungmin.park@samsung.com>
>>>>>>>> Cc: Bryan Wu <cooloney@gmail.com>
>>>>>>>> Cc: Richard Purdie <rpurdie@rpsys.net>
>>>>>>>
>>>>>>> NAK-ed-by: Pavel Machek
>>>>>>>
>>>>>>>> +What:		/sys/class/leds/<led>/available_sync_leds
>>>>>>>> +Date:		February 2015
>>>>>>>> +KernelVersion:	3.20
>>>>>>>> +Contact:	Jacek Anaszewski <j.anaszewski@samsung.com>
>>>>>>>> +Description:	read/write
>>>>>>>> +		Space separated list of LEDs available for flash strobe
>>>>>>>> +		synchronization, displayed in the format:
>>>>>>>> +
>>>>>>>> +		led1_id.led1_name led2_id.led2_name led3_id.led3_name etc.
>>>>>>>
>>>>>>> Multiple values per file, with all the problems we had in /proc. I
>>>>>>> assume led_id is an integer? What prevents space or dot in led name?
>>>>>>
>>>>>> Very good point. How about using a newline instead? That'd be a little bit
>>>>>> easier to parse, too.
>>>>>
>>>>> No, please make it one value per-file, which is what sysfs requires.
>>>>
>>>> The purpose of this attribute is only to provide an information about
>>>> the range of valid identifiers that can be written to the
>>>> flash_sync_strobe attribute. Wouldn't splitting this to many attributes
>>>> be an unnecessary inflation of sysfs files?
>>>
>>> Ok a list of allowed values to write is acceptable, as long as it is not
>>> hard to parse and always is space separated.
>>
>> Well, this one is list of LED numbers and LED names.
>
> It'd be nice if these names would match the V4L2 sub-device names. We don't

 From the discussion on IRC it turned out that one of components of the
V4L2 sub-device name will be a media controller identifier.

This implies that if support for V4L2 Flash devices will be turned off
in the kernel config the LED name will have to differ from the case
when the support is on. I think that this is undesired.

> have any rules for them other than they must be unique, and there's the
> established practice that an I2C address follows the component name. We're
> about to discuss the matter on Monday on #v4l (11:00 Finnish time), but I
> don't think we can generally guarantee any of the names won't have spaces.

> Separate files, then?

I tried to split this to separate files but it turned out to be awkward.
Since the number of LEDs to synchronize can vary from device to device,
the number of the related sysfs attributes cannot be fixed.

As far as I know allocating the sysfs attributes dynamically is unsafe,
and thus the maximum allowed number of synchronized LEDs would have to
be agreed on for the whole led-class-flash and the relevant number of
similar struct attribute instances and related callbacks would have to
be created statically for every LED Flash class device, no matter if
a device would need them.

Of course the relevant sysfs group could be initialized only with
the needed number of sync leds attributes, but still this is less
than optimal design.

It looks like this interface indeed doesn't fit for sysfs.

I am leaning towards removing the support for synchronized flash LEDs
from the LED subsystem entirely and leave it only to V4L2.

-- 
Best Regards,
Jacek Anaszewski
