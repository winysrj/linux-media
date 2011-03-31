Return-path: <mchehab@pedra>
Received: from smtp.nokia.com ([147.243.128.24]:29678 "EHLO mgw-da01.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757146Ab1CaIQC (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 31 Mar 2011 04:16:02 -0400
Message-ID: <4D9438AD.7040405@maxwell.research.nokia.com>
Date: Thu, 31 Mar 2011 11:17:49 +0300
From: Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>
MIME-Version: 1.0
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
CC: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	Nayden Kanchev <nkanchev@mm-sol.com>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Cohen David Abraham <david.cohen@nokia.com>
Subject: Re: [RFC] V4L2 API for flash devices
References: <4D90854C.2000802@maxwell.research.nokia.com> <201103301134.14798.laurent.pinchart@ideasonboard.com> <4D930E92.70302@maxwell.research.nokia.com> <201103301554.47092.laurent.pinchart@ideasonboard.com>
In-Reply-To: <201103301554.47092.laurent.pinchart@ideasonboard.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Laurent Pinchart wrote:
> On Wednesday 30 March 2011 13:05:54 Sakari Ailus wrote:
>> Laurent Pinchart wrote:
>>> Hi Sakari,
>>
>> Hi Laurent,
>>
>> Thanks for the comments!
>>
>>> On Monday 28 March 2011 14:55:40 Sakari Ailus wrote:
>>>
>>> [snip]
>>>
>>>> 	V4L2_CID_FLASH_STROBE_MODE (menu; LED)
>>>>
>>>> Use hardware or software strobe. If hardware strobe is selected, the
>>>> flash controller is a slave in the system where the sensor produces the
>>>> strobe signal to the flash.
>>>>
>>>> In this case the flash controller setup is limited to programming strobe
>>>> timeout and power (LED flash) and the sensor controls the timing and
>>>> length of the strobe.
>>>>
>>>> enum v4l2_flash_strobe_mode {
>>>>
>>>> 	V4L2_FLASH_STROBE_MODE_SOFTWARE,
>>>> 	V4L2_FLASH_STROBE_MODE_EXT_STROBE,
>>>>
>>>> };
>>>
>>> [snip]
>>>
>>>> 	V4L2_CID_FLASH_LED_MODE (menu; LED)
>>>>
>>>> enum v4l2_flash_led_mode {
>>>>
>>>> 	V4L2_FLASH_LED_MODE_FLASH = 1,
>>>> 	V4L2_FLASH_LED_MODE_TORCH,
>>>>
>>>> };
>>>
>>> Thinking about this some more, shouldn't we combine the two controls ?
>>> They are basically used to configure how the flash LED is controlled:
>>> manually (torch mode), automatically by the flash controller (software
>>> strobe mode) or automatically by an external component (external strobe
>>> mode).
>>
>> That's a good question.
>>
>> The adp1653 supports also additional control (not implemented in the
>> driver, though) that affect hardware strobe length. Based on register
>> setting, the led will be on after strobe either until the timeout
>> expires, or until the strobe signal is high.
>>
>> Should this be also part of the same control, or a different one?
> 
> That can be controlled by a duration control. If the duration is 0, the flash 
> is lit for the duration of the external strobe, otherwise it's lit for the 
> programmed duration.

Sounds good to me.

>> Even without this, we'd have:
>>
>> V4L2_FLASH_MODE_OFF
>> V4L2_FLASH_MODE_TORCH
>> V4L2_FLASH_MODE_SOFTWARE_STROBE
>> V4L2_FLASH_MODE_EXTERNAL_STROBE
>>
>> Additionally, this might be
>>
>> V4L2_FLASH_MODE_EXTERNAL_STROBE_EDGE
>>
>> It's true that these are mutually exclusive.
>>
>> I think this is about whether we want to specify the operation of the
>> flash explicitly here or allow extending the interface later on when new
>> hardware is available by adding new controls. There are upsides and
>> downsides in each approach.
>>
>> There could be additional differentiating factors to the functionalty
>> later on, like the torch/video light differentiation that some hardware
>> does --- who knows based on what?
>>
>> I perhaps wouldn't combine the controls. What do you think?
> 
> I'm not sure yet :-)

I have a vague feeling that as we don't know about the future hardware
I'd prefer to keep this as extensible as possible, meaning that I'd
rather add new controls than define menu controls with use case specific
items in them. This would translate to two controls: flash mode (none,
torch, flash) and strobe mode (software, external).

What do the others think on this?

-- 
Sakari Ailus
sakari.ailus@maxwell.research.nokia.com
