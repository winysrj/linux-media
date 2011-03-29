Return-path: <mchehab@pedra>
Received: from smtp.nokia.com ([147.243.1.48]:46997 "EHLO mgw-sa02.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752827Ab1C2Lix (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 29 Mar 2011 07:38:53 -0400
Message-ID: <4D91C4BA.20200@maxwell.research.nokia.com>
Date: Tue, 29 Mar 2011 14:38:34 +0300
From: Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>
MIME-Version: 1.0
To: Hans Verkuil <hansverk@cisco.com>
CC: Hans Verkuil <hverkuil@xs4all.nl>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	Nayden Kanchev <nkanchev@mm-sol.com>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Cohen David Abraham <david.cohen@nokia.com>
Subject: Re: [RFC] V4L2 API for flash devices
References: <4D90854C.2000802@maxwell.research.nokia.com> <201103290849.48799.hverkuil@xs4all.nl> <4D91A7D7.5060909@maxwell.research.nokia.com> <201103291154.43536.hansverk@cisco.com>
In-Reply-To: <201103291154.43536.hansverk@cisco.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hans Verkuil wrote:
> On Tuesday, March 29, 2011 11:35:19 Sakari Ailus wrote:
>> Hi Hans,
>>
>> Many thanks for the comments!
>>

...

>> It occurred to me that an application might want to turn off a flash
>> which has been strobed on software. That can't be done on a single
>> button control.
>>
>> V4L2_CID_FLASH_SHUTDOWN?
>>
>> The application would know the flash strobe is ongoing before it
>> receives a timeout fault. I somehow feel that there should be a control
>> telling that directly.
>>
>> What about using a bool control for the strobe?
> 
> It depends: is the strobe signal just a pulse that kicks off the flash, or is 
> it active throughout the flash duration? In the latter case a bool makes 
> sense, in the first case an extra button control makes sense.

I like buttons since I associate them with action (like strobing) but on
the other hand buttons don't allow querying the current state. On the
other hand, the current state isn't always determinable, e.g. in the
absence of the interrupt line from the flash controller interrupt pin
(e.g. N900!).

I don't think having a separate bool control for the state of the flash
is very neat either.

Well, a boolean control could be seen as a two-state button also. :-)

In a summary: sometimes the state can be determined, while sometimes it
can't. So I think we'd need both and some drivers could implement a
subset of them.

A single control could be used for both, but then the flash state would
be always off if the hardware doesn't support reading back the state. To
make this explicit for user space, likely three controls would be required:

V4L2_CID_FLASH_STROBE (button)
V4L2_CID_FLASH_SHUTDOWN (button)
V4L2_CID_FLASH_LIT (boolean)

...

>> I'm not sure about that.
>>
>> The driver already must take care of protecting the hardware in my
>> opinion. Besides, at least one control is required to select the
>> duration for the flash if there's no hardware synchronisation.
>>
>> What about this:
>>
>> 	V4L2_CID_FLASH_TIMEOUT
>>
>> Hardware timeout, read-only. Programmed to the maximum value allowed by
>> the hardware for the external strobe, greater or equal to
>> V4L2_CID_FLASH_DURATION for software strobe.
>>
>> 	V4L2_CID_FLASH_DURATION
>>
>> Software implemented timeout when V4L2_CID_FLASH_STROBE_MODE ==
>> V4L2_FLASH_STROBE_MODE_SOFTWARE.
>>
>> I have to say I'm not entirely sure the duration control is required.
>> The timeout could be writable for software strobe in the case drivers do
>> not implement software timeout. The granularity isn't _that_ much
>> anyway. Also, a timeout fault should be produced whenever the duration
>> would expire.
>>
>> Perhaps it would be best to just leave that out for now.
> 
> Do you need something like this for the N900? If not, then leaving it out 
> until we have a bit more experience is a good option.

We don't.

I think making V4L2_CID_FLASH_TIMEOUT writable would be useful since the
only other way to shut off the flash would be the shutdown control in
software strobe. On the other hand, this should bring no advantages to
flash synchronisation, but allows the application to get a strobe of
chosen length.

Also, the ADP1653 supports a mode of hardware strobe operation where the
strobe triggers the flash which stays on until the timeout independent
of the strobe signal.

There likely should be an additional control for this in the end,
although I don't know of any use for such mode.

Cheers,

-- 
Sakari Ailus
sakari.ailus@maxwell.research.nokia.com
