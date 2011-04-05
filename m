Return-path: <mchehab@pedra>
Received: from smtp.nokia.com ([147.243.1.48]:25754 "EHLO mgw-sa02.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751141Ab1DEKBJ (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 5 Apr 2011 06:01:09 -0400
Message-ID: <4D9AE83C.4070305@nokia.com>
Date: Tue, 05 Apr 2011 13:00:28 +0300
From: Sakari Ailus <sakari.ailus@nokia.com>
MIME-Version: 1.0
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
CC: Hans Verkuil <hansverk@cisco.com>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	Nayden Kanchev <nkanchev@mm-sol.com>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Cohen David Abraham <david.cohen@nokia.com>
Subject: Re: [RFC] V4L2 API for flash devices
References: <4D90854C.2000802@maxwell.research.nokia.com> <4D91C4BA.20200@maxwell.research.nokia.com> <4D91C7CA.1050105@nokia.com> <201103301047.15678.laurent.pinchart@ideasonboard.com>
In-Reply-To: <201103301047.15678.laurent.pinchart@ideasonboard.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Laurent Pinchart wrote:
> Hi Sakari,

Hi Laurent,

> On Tuesday 29 March 2011 13:51:38 Sakari Ailus wrote:
>> Sakari Ailus wrote:
>>> Hans Verkuil wrote:
>>>> On Tuesday, March 29, 2011 11:35:19 Sakari Ailus wrote:
>>>>> Hi Hans,
>>>>>
>>>>> Many thanks for the comments!
>>>
>>> ...
>>>
>>>>> It occurred to me that an application might want to turn off a flash
>>>>> which has been strobed on software. That can't be done on a single
>>>>> button control.
>>>>>
>>>>> V4L2_CID_FLASH_SHUTDOWN?
>>>>>
>>>>> The application would know the flash strobe is ongoing before it
>>>>> receives a timeout fault. I somehow feel that there should be a control
>>>>> telling that directly.
>>>>>
>>>>> What about using a bool control for the strobe?
>>>>
>>>> It depends: is the strobe signal just a pulse that kicks off the flash,
>>>> or is it active throughout the flash duration? In the latter case a
>>>> bool makes sense, in the first case an extra button control makes
>>>> sense.
>>>
>>> I like buttons since I associate them with action (like strobing) but on
>>> the other hand buttons don't allow querying the current state. On the
>>> other hand, the current state isn't always determinable, e.g. in the
>>> absence of the interrupt line from the flash controller interrupt pin
>>> (e.g. N900!).
>>
>> Oh, I need to take my words back a bit.
>>
>> There indeed is a way to get the on/off status for the flash, but that
>> involves I2C register access --- when you read the fault registers, you
>> do get the state, even if the interrupt linke is missing from the
>> device. At least I can't see why this wouldn't work, at least on this
>> particular chip.
>>
>> What you can't have in this case is the event.
>>
>> So, in my opinion this suggests that a single boolean control is the way
>> to go.
> 
> Why would an application want to turn off a flash that has been strobbed in 
> software ? Applications should set the flash duration and then strobe it.

The applications won't know beforehand the exact timing of the exposure
of the frames on the sensor and the latencies of the operating system
possibly affected by other processes running on the system. Thus it's
impossible to know exactly how long flash strobe (on software, that is!)
is required.

So, as far as I see there should be a way to turn the flash off and the
timeout would mostly function as a safeguard. This is likely dependent
on the flash controller as well.

-- 
Sakari Ailus
sakari.ailus@maxwell.research.nokia.com
