Return-path: <mchehab@pedra>
Received: from smtp.nokia.com ([147.243.1.48]:35942 "EHLO mgw-sa02.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750930Ab1DENg0 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 5 Apr 2011 09:36:26 -0400
Message-ID: <4D9B1AB6.8010202@nokia.com>
Date: Tue, 05 Apr 2011 16:35:50 +0300
From: Sakari Ailus <sakari.ailus@nokia.com>
MIME-Version: 1.0
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
CC: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	Nayden Kanchev <nkanchev@mm-sol.com>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Cohen David Abraham <david.cohen@nokia.com>
Subject: Re: [RFC] V4L2 API for flash devices
References: <4D90854C.2000802@maxwell.research.nokia.com> <201104051239.05167.laurent.pinchart@ideasonboard.com> <4D9AFB1F.7020107@nokia.com> <201104051328.34774.laurent.pinchart@ideasonboard.com>
In-Reply-To: <201104051328.34774.laurent.pinchart@ideasonboard.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Laurent Pinchart wrote:
> Hi Sakari,

Hi,

> On Tuesday 05 April 2011 13:21:03 Sakari Ailus wrote:
>> Laurent Pinchart wrote:
>>> On Tuesday 05 April 2011 12:23:51 Sakari Ailus wrote:
>>>> Sakari Ailus wrote:
>>>>> Laurent Pinchart wrote:
>>>>>> On Wednesday 30 March 2011 13:05:54 Sakari Ailus wrote:
>>>>>>> Laurent Pinchart wrote:
>>>>>>>> On Monday 28 March 2011 14:55:40 Sakari Ailus wrote:
>>>>>>>>
>>>>>>>> [snip]
>>>>>>>>
>>>>>>>>> 	V4L2_CID_FLASH_STROBE_MODE (menu; LED)
>>>>>>>>>
>>>>>>>>> Use hardware or software strobe. If hardware strobe is selected,
>>>>>>>>> the flash controller is a slave in the system where the sensor
>>>>>>>>> produces the strobe signal to the flash.
>>>>>>>>>
>>>>>>>>> In this case the flash controller setup is limited to programming
>>>>>>>>> strobe timeout and power (LED flash) and the sensor controls the
>>>>>>>>> timing and length of the strobe.
>>>>>>>>>
>>>>>>>>> enum v4l2_flash_strobe_mode {
>>>>>>>>>
>>>>>>>>> 	V4L2_FLASH_STROBE_MODE_SOFTWARE,
>>>>>>>>> 	V4L2_FLASH_STROBE_MODE_EXT_STROBE,
>>>>>>>>>
>>>>>>>>> };
>>>>>>>>
>>>>>>>> [snip]
>>>>>>>>
>>>>>>>>> 	V4L2_CID_FLASH_LED_MODE (menu; LED)
>>>>>>>>>
>>>>>>>>> enum v4l2_flash_led_mode {
>>>>>>>>>
>>>>>>>>> 	V4L2_FLASH_LED_MODE_FLASH = 1,
>>>>>>>>> 	V4L2_FLASH_LED_MODE_TORCH,
>>>>>>>>>
>>>>>>>>> };
>>>>>>>>
>>>>>>>> Thinking about this some more, shouldn't we combine the two controls
>>>>>>>> ? They are basically used to configure how the flash LED is
>>>>>>>> controlled: manually (torch mode), automatically by the flash
>>>>>>>> controller (software strobe mode) or automatically by an external
>>>>>>>> component (external strobe mode).
>>>>>>>
>>>>>>> That's a good question.
>>>>>>>
>>>>>>> The adp1653 supports also additional control (not implemented in the
>>>>>>> driver, though) that affect hardware strobe length. Based on register
>>>>>>> setting, the led will be on after strobe either until the timeout
>>>>>>> expires, or until the strobe signal is high.
>>>>>>>
>>>>>>> Should this be also part of the same control, or a different one?
>>>>>>
>>>>>> That can be controlled by a duration control. If the duration is 0,
>>>>>> the flash is lit for the duration of the external strobe, otherwise
>>>>>> it's lit for the programmed duration.
>>>>>
>>>>> Sounds good to me.
>>>>
>>>> Thinking about this again; there won't be a separate duration control
>>>
>>> Why not ? I think we need two timeouts, a watchdog timeout to prevent
>>> flash fire or meltdown, and a normal timeout to lit the flash for a
>>> user-selected duration.
>>
>> Let's assume that an application wants to expose a frame using flash
>> with software strobe.
>>
>> 1. strobe flash
>> 2. qbuf
>> 3. streamon
>> 4. dqbuf
>> 5. streamoff
>> 6. ...
>>
>> How does an application know how long is the time between 1 -- 4? I'd
>> guess that in 6 the application would like to switch off the flash
>> instead of specifying a timeout for it.
> 
> That's a valid use case, and we need to support it. It requires a way to lit 
> the flash with no timeout other than the watchdog timeout, and a way to turn 
> it off.
> 
> However, I'm not sure we should rule out the usefulness of a duration-based 
> software flash strobe. Can't the two APIs coexist ? Or do you think a 
> duration-based API is useless ?

I don't want to rule it out, but I don't see use for it either for the
time being and thus don't see a reason to specify an API for it. The
adp1653 driver does not implement a software based shutdown timeout and
I'm not aware of others implementing it either. It was just an idea to
overcome the coarse hardware watchdog timeout.

If there is use for it then I think we could bring up the question
again: use V4L2_CID_FLASH_TIMEOUT or create V4L2_CID_FLASH_DURATION for it.

What do you think?

-- 
Sakari Ailus
sakari.ailus@maxwell.research.nokia.com
