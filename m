Return-path: <mchehab@pedra>
Received: from smtp.nokia.com ([147.243.1.47]:25968 "EHLO mgw-sa01.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752904Ab1DEKX6 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 5 Apr 2011 06:23:58 -0400
Message-ID: <4D9AEDB7.8040601@nokia.com>
Date: Tue, 05 Apr 2011 13:23:51 +0300
From: Sakari Ailus <sakari.ailus@Nokia.com>
MIME-Version: 1.0
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
CC: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	Nayden Kanchev <nkanchev@mm-sol.com>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Cohen David Abraham <david.cohen@Nokia.com>
Subject: Re: [RFC] V4L2 API for flash devices
References: <4D90854C.2000802@maxwell.research.nokia.com> <201103301134.14798.laurent.pinchart@ideasonboard.com> <4D930E92.70302@maxwell.research.nokia.com> <201103301554.47092.laurent.pinchart@ideasonboard.com> <4D9438AD.7040405@maxwell.research.nokia.com>
In-Reply-To: <4D9438AD.7040405@maxwell.research.nokia.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi Laurent,

Sakari Ailus wrote:
> Laurent Pinchart wrote:
>> On Wednesday 30 March 2011 13:05:54 Sakari Ailus wrote:
>>> Laurent Pinchart wrote:
>>>> Hi Sakari,
>>>
>>> Hi Laurent,
>>>
>>> Thanks for the comments!
>>>
>>>> On Monday 28 March 2011 14:55:40 Sakari Ailus wrote:
>>>>
>>>> [snip]
>>>>
>>>>> 	V4L2_CID_FLASH_STROBE_MODE (menu; LED)
>>>>>
>>>>> Use hardware or software strobe. If hardware strobe is selected, the
>>>>> flash controller is a slave in the system where the sensor produces the
>>>>> strobe signal to the flash.
>>>>>
>>>>> In this case the flash controller setup is limited to programming strobe
>>>>> timeout and power (LED flash) and the sensor controls the timing and
>>>>> length of the strobe.
>>>>>
>>>>> enum v4l2_flash_strobe_mode {
>>>>>
>>>>> 	V4L2_FLASH_STROBE_MODE_SOFTWARE,
>>>>> 	V4L2_FLASH_STROBE_MODE_EXT_STROBE,
>>>>>
>>>>> };
>>>>
>>>> [snip]
>>>>
>>>>> 	V4L2_CID_FLASH_LED_MODE (menu; LED)
>>>>>
>>>>> enum v4l2_flash_led_mode {
>>>>>
>>>>> 	V4L2_FLASH_LED_MODE_FLASH = 1,
>>>>> 	V4L2_FLASH_LED_MODE_TORCH,
>>>>>
>>>>> };
>>>>
>>>> Thinking about this some more, shouldn't we combine the two controls ?
>>>> They are basically used to configure how the flash LED is controlled:
>>>> manually (torch mode), automatically by the flash controller (software
>>>> strobe mode) or automatically by an external component (external strobe
>>>> mode).
>>>
>>> That's a good question.
>>>
>>> The adp1653 supports also additional control (not implemented in the
>>> driver, though) that affect hardware strobe length. Based on register
>>> setting, the led will be on after strobe either until the timeout
>>> expires, or until the strobe signal is high.
>>>
>>> Should this be also part of the same control, or a different one?
>>
>> That can be controlled by a duration control. If the duration is 0, the flash 
>> is lit for the duration of the external strobe, otherwise it's lit for the 
>> programmed duration.
> 
> Sounds good to me.

Thinking about this again; there won't be a separate duration control
and the hardware timeout can't be zero in a general case.

So this is not an option, and I don't think we'd want to add duration
control for this purpose.

What about V4L2_CID_FLASH_EXTERNAL_STROBE_EDGE?

-- 
Sakari Ailus
sakari.ailus@maxwell.research.nokia.com
