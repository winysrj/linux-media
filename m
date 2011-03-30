Return-path: <mchehab@pedra>
Received: from smtp.nokia.com ([147.243.128.26]:38151 "EHLO mgw-da02.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753234Ab1C3OSi (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 30 Mar 2011 10:18:38 -0400
Message-ID: <4D933B9A.1090002@maxwell.research.nokia.com>
Date: Wed, 30 Mar 2011 17:18:02 +0300
From: Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>
MIME-Version: 1.0
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
CC: Hans Verkuil <hverkuil@xs4all.nl>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	Nayden Kanchev <nkanchev@mm-sol.com>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Cohen David Abraham <david.cohen@nokia.com>
Subject: Re: [RFC] V4L2 API for flash devices
References: <4D90854C.2000802@maxwell.research.nokia.com> <201103301055.42521.laurent.pinchart@ideasonboard.com> <4D9325A9.4080200@maxwell.research.nokia.com> <201103301553.17220.laurent.pinchart@ideasonboard.com>
In-Reply-To: <201103301553.17220.laurent.pinchart@ideasonboard.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Laurent Pinchart wrote:
> Hi Sakari,

Heippa,

> On Wednesday 30 March 2011 14:44:25 Sakari Ailus wrote:
>> Laurent Pinchart wrote:
>>> On Tuesday 29 March 2011 11:35:19 Sakari Ailus wrote:
>>>> Hans Verkuil wrote:
>>>>> On Monday, March 28, 2011 14:55:40 Sakari Ailus wrote:
>>> [snip]
>>>
>>>>>> 	V4L2_CID_FLASH_TIMEOUT (integer; LED)
>>>>>>
>>>>>> The flash controller provides timeout functionality to shut down the
>>>>>> led in case the host fails to do that. For hardware strobe, this is
>>>>>> the maximum amount of time the flash should stay on, and the purpose
>>>>>> of the setting is to prevent the LED from catching fire.
>>>>>>
>>>>>> For software strobe, the setting may be used to limit the length of
>>>>>> the strobe in case a driver does not implement it itself. The
>>>>>> granularity of the timeout in [1, 2, 3] is very coarse. However, the
>>>>>> length of a driver-implemented LED strobe shutoff is very dependent
>>>>>> on host. Possibly V4L2_CID_FLASH_DURATION should be added, and
>>>>>> V4L2_CID_FLASH_TIMEOUT would be read-only so that the user would be
>>>>>> able to obtain the actual hardware implemented safety timeout.
>>>>>>
>>>>>> Likely a standard unit such as ms or µs should be used.
>>>>>
>>>>> It seems to me that this control should always be read-only. A setting
>>>>> like this is very much hardware specific and you don't want an attacker
>>>>> changing the timeout to the max value that might cause a LED catching
>>>>> fire.
>>>>
>>>> I'm not sure about that.
>>>>
>>>> The driver already must take care of protecting the hardware in my
>>>> opinion. Besides, at least one control is required to select the
>>>> duration for the flash if there's no hardware synchronisation.
>>>>
>>>> What about this:
>>>> 	V4L2_CID_FLASH_TIMEOUT
>>>>
>>>> Hardware timeout, read-only. Programmed to the maximum value allowed by
>>>> the hardware for the external strobe, greater or equal to
>>>> V4L2_CID_FLASH_DURATION for software strobe.
>>>>
>>>> 	V4L2_CID_FLASH_DURATION
>>>>
>>>> Software implemented timeout when V4L2_CID_FLASH_STROBE_MODE ==
>>>> V4L2_FLASH_STROBE_MODE_SOFTWARE.
>>>
>>> Why would we need two controls here ? My understanding is that the
>>> maximum strobe duration length can be limited by
>>>
>>> - the flash controller itself
>>> - platform-specific constraints to avoid over-heating the flash
>>>
>>> The platform-specific constraints come from board code, and the flash
>>> driver needs to ensure that the flash is never strobed for a duration
>>> longer than the limit. This requires implementing a software timer if
>>> the hardware has no timeout control, and programming the hardware with
>>> the correct timeout value otherwise. The limit can be queried with
>>> QUERYCTRL on the duration control.
>>
>> That's true.
>>
>> The alternative would be software timeout since the hardware timeout is
>> rather coarse. Its intention is to protect the hardware from catching
>> fire mostly.
> 
> A software timeout can always be implemented in the driver in addition to the 
> hardware timeout. I think this should be transparent for applications.
>  
>> But as I commented in the other e-mail, there likely isn't a need to be
>> able to control this very precisely. The user just shuts down the flash
>> whenever (s)he no longer needs it rather than knows beforehand how long
>> it needs to stay on.
> 
> What about hardware that needs to be pre-programmed with a duration ?

Same control?

I wonder if I could say we agree to have one timeout control which is
used to control the hardware timeout directly, or to implement a timeout
in software? :-)

>>>> I have to say I'm not entirely sure the duration control is required.
>>>> The timeout could be writable for software strobe in the case drivers do
>>>> not implement software timeout. The granularity isn't _that_ much
>>>> anyway. Also, a timeout fault should be produced whenever the duration
>>>> would expire.
>>>>
>>>> Perhaps it would be best to just leave that out for now.
>>>>
>>>>>> 	V4L2_CID_FLASH_LED_MODE (menu; LED)
>>>>>>
>>>>>> enum v4l2_flash_led_mode {
>>>>>>
>>>>>> 	V4L2_FLASH_LED_MODE_FLASH = 1,
>>>>>> 	V4L2_FLASH_LED_MODE_TORCH,
>>>
>>> "torch" mode can also be used for video, should we rename TORCH to
>>> something more generic ? Maybe a "manual" mode ?
>>
>> The controllers recognise a torch mode and I think it describes the
>> functionality quite well. Some appear to make a difference between torch
>> and video light --- but I can't imagine a purpose in which this could be
>> useful.
> 
> Torch mode is indeed a common name, but it sounds a bit specific to me.

Torch suggests it can be used over extended periods of time, unlike
manual which doesn't really say much. I'd keep it torch since what it
suggests is that it can stay on for long. No references outside the
flash controller itself.

-- 
Sakari Ailus
sakari.ailus@maxwell.research.nokia.com
