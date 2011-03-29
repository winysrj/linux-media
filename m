Return-path: <mchehab@pedra>
Received: from smtp.nokia.com ([147.243.1.48]:50503 "EHLO mgw-sa02.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750994Ab1C2LwP (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 29 Mar 2011 07:52:15 -0400
Message-ID: <4D91C7CA.1050105@nokia.com>
Date: Tue, 29 Mar 2011 14:51:38 +0300
From: Sakari Ailus <sakari.ailus@nokia.com>
MIME-Version: 1.0
To: Hans Verkuil <hansverk@cisco.com>
CC: Hans Verkuil <hverkuil@xs4all.nl>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	Nayden Kanchev <nkanchev@mm-sol.com>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Cohen David Abraham <david.cohen@nokia.com>
Subject: Re: [RFC] V4L2 API for flash devices
References: <4D90854C.2000802@maxwell.research.nokia.com> <201103290849.48799.hverkuil@xs4all.nl> <4D91A7D7.5060909@maxwell.research.nokia.com> <201103291154.43536.hansverk@cisco.com> <4D91C4BA.20200@maxwell.research.nokia.com>
In-Reply-To: <4D91C4BA.20200@maxwell.research.nokia.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Sakari Ailus wrote:
> Hans Verkuil wrote:
>> On Tuesday, March 29, 2011 11:35:19 Sakari Ailus wrote:
>>> Hi Hans,
>>>
>>> Many thanks for the comments!
>>>
> 
> ...
> 
>>> It occurred to me that an application might want to turn off a flash
>>> which has been strobed on software. That can't be done on a single
>>> button control.
>>>
>>> V4L2_CID_FLASH_SHUTDOWN?
>>>
>>> The application would know the flash strobe is ongoing before it
>>> receives a timeout fault. I somehow feel that there should be a control
>>> telling that directly.
>>>
>>> What about using a bool control for the strobe?
>>
>> It depends: is the strobe signal just a pulse that kicks off the flash, or is 
>> it active throughout the flash duration? In the latter case a bool makes 
>> sense, in the first case an extra button control makes sense.
> 
> I like buttons since I associate them with action (like strobing) but on
> the other hand buttons don't allow querying the current state. On the
> other hand, the current state isn't always determinable, e.g. in the
> absence of the interrupt line from the flash controller interrupt pin
> (e.g. N900!).

Oh, I need to take my words back a bit.

There indeed is a way to get the on/off status for the flash, but that
involves I2C register access --- when you read the fault registers, you
do get the state, even if the interrupt linke is missing from the
device. At least I can't see why this wouldn't work, at least on this
particular chip.

What you can't have in this case is the event.

So, in my opinion this suggests that a single boolean control is the way
to go.

Regards,

-- 
Sakari Ailus
sakari.ailus@maxwell.research.nokia.com
