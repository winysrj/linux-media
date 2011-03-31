Return-path: <mchehab@pedra>
Received: from smtp.nokia.com ([147.243.128.26]:51232 "EHLO mgw-da02.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757146Ab1CaIHp (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 31 Mar 2011 04:07:45 -0400
Message-ID: <4D9436B8.501@maxwell.research.nokia.com>
Date: Thu, 31 Mar 2011 11:09:28 +0300
From: Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>
MIME-Version: 1.0
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
CC: David Cohen <dacohen@gmail.com>, Hans Verkuil <hverkuil@xs4all.nl>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	Nayden Kanchev <nkanchev@mm-sol.com>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Cohen David Abraham <david.cohen@nokia.com>
Subject: Re: [RFC] V4L2 API for flash devices
References: <4D90854C.2000802@maxwell.research.nokia.com> <4D933B9A.1090002@maxwell.research.nokia.com> <BANLkTin_xvyL6Bfcao3Pobps8OkeR9eTSA@mail.gmail.com> <201103301700.47462.laurent.pinchart@ideasonboard.com>
In-Reply-To: <201103301700.47462.laurent.pinchart@ideasonboard.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Laurent Pinchart wrote:
> Hi David,

Salut,

> On Wednesday 30 March 2011 16:57:30 David Cohen wrote:
>> On Wed, Mar 30, 2011 at 5:18 PM, Sakari Ailus wrote:
>>>> On Wednesday 30 March 2011 14:44:25 Sakari Ailus wrote:
...
>>>>> But as I commented in the other e-mail, there likely isn't a need to be
>>>>> able to control this very precisely. The user just shuts down the flash
>>>>> whenever (s)he no longer needs it rather than knows beforehand how long
>>>>> it needs to stay on.
>>>>
>>>> What about hardware that needs to be pre-programmed with a duration ?
>>>
>>> Same control?
>>>
>>> I wonder if I could say we agree to have one timeout control which is
>>> used to control the hardware timeout directly, or to implement a timeout
>>> in software? :-)
>>
>> Correct if I'm wrong, but I guess we might be talking about 2 kind of
>> timeouts:
>> - One for the duration itself
>> - Another one to act like watchdog in addition to the hw timeout
> 
> Do we need a control for that, or should it just be a fixed value that comes 
> from platform data ?

I think it's good to set the hardware timeout as small as possible. This
makes the timeout behaviour more deterministic. I'm not sure if the
information _needs_ to be delivered to user space though.

On the other hand, if we now use the same control for both software and
hardware timeout we can't add a new one without changing the meaning for
the old one.

My proposal: let's postpone this and decide when we need to. Only
hardware timeouts are implemented for now. When someone wants a software
timeout then figure out what to do. We'd have exactly the same options
then: the same control or a new control.

>> IMO they should be different controls. We could even specify on the
>> control name when it's a watchdog case to make it more clear.
>>
>>>>>>> I have to say I'm not entirely sure the duration control is required.
>>>>>>> The timeout could be writable for software strobe in the case drivers
>>>>>>> do not implement software timeout. The granularity isn't _that_ much
>>>>>>> anyway. Also, a timeout fault should be produced whenever the
>>>>>>> duration would expire.
>>>>>>>
>>>>>>> Perhaps it would be best to just leave that out for now.
>>>>>>>
>>>>>>>>>  V4L2_CID_FLASH_LED_MODE (menu; LED)
>>>>>>>>>
>>>>>>>>> enum v4l2_flash_led_mode {
>>>>>>>>>
>>>>>>>>>  V4L2_FLASH_LED_MODE_FLASH = 1,
>>>>>>>>>  V4L2_FLASH_LED_MODE_TORCH,
>>>>>>
>>>>>> "torch" mode can also be used for video, should we rename TORCH to
>>>>>> something more generic ? Maybe a "manual" mode ?
>>>>>
>>>>> The controllers recognise a torch mode and I think it describes the
>>>>> functionality quite well. Some appear to make a difference between
>>>>> torch and video light --- but I can't imagine a purpose in which this
>>>>> could be useful.
>>>>
>>>> Torch mode is indeed a common name, but it sounds a bit specific to me.
>>>
>>> Torch suggests it can be used over extended periods of time, unlike
>>> manual which doesn't really say much. I'd keep it torch since what it
>>> suggests is that it can stay on for long. No references outside the
>>> flash controller itself.
>>
>> I'd keep with torch also as it seems to be more clear.
> 
> OK, I'll give up then :-)

Torch, then. :-)

-- 
Sakari Ailus
sakari.ailus@maxwell.research.nokia.com
