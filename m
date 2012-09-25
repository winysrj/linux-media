Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wi0-f178.google.com ([209.85.212.178]:35532 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751309Ab2IYWsI (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 25 Sep 2012 18:48:08 -0400
Received: by wibhr7 with SMTP id hr7so1345227wib.1
        for <linux-media@vger.kernel.org>; Tue, 25 Sep 2012 15:48:07 -0700 (PDT)
Message-ID: <506234A4.9000603@gmail.com>
Date: Wed, 26 Sep 2012 00:48:04 +0200
From: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
MIME-Version: 1.0
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
CC: linux-media@vger.kernel.org, Sakari Ailus <sakari.ailus@iki.fi>,
	Hans Verkuil <hverkuil@xs4all.nl>, remi@remlab.net,
	daniel-gl@gmx.net
Subject: Re: [RFC] Timestamps and V4L2
References: <20120920202122.GA12025@valkosipuli.retiisi.org.uk> <505DB12F.1090600@iki.fi> <505DF194.9030007@gmail.com> <1389232.pNkvQadbzf@avalon>
In-Reply-To: <1389232.pNkvQadbzf@avalon>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Laurent,

On 09/25/2012 02:34 AM, Laurent Pinchart wrote:
> On Saturday 22 September 2012 19:12:52 Sylwester Nawrocki wrote:
>> On 09/22/2012 02:38 PM, Sakari Ailus wrote:
>>>> You are missing one other option:
>>>>
>>>> Using v4l2_buffer flags to report the clock
>>>> -------------------------------------------
>>>>
>>>> By defining flags like this:
>>>>
>>>> V4L2_BUF_FLAG_CLOCK_MASK 0x7000
>>>> /* Possible Clocks */
>>>> V4L2_BUF_FLAG_CLOCK_UNKNOWN 0x0000 /* system or monotonic, we don't
>>>> know */
>>>> V4L2_BUF_FLAG_CLOCK_MONOTONIC 0x1000
>>>>
>>>> you could tell the application which clock is used.
>>>>
>>>> This does allow for more clocks to be added in the future and clock
>>>> selection would then be done by a control or possibly an ioctl. For now
>>>> there are no plans to do such things, so this flag should be sufficient.
>>>> And it can be implemented very efficiently. It works with existing
>>>> drivers as well, since they will report CLOCK_UNKNOWN.
>>>>
>>>> I am very much in favor of this approach.
>>
>> +1
>>
>> I think I like this idea best, it's relatively simple (even with adding
>> support for reporting flags in VIDIOC_QUERYBUF) for the purpose.
>>
>> If we ever need the clock selection API I would vote for an IOCTL.
>> The controls API is a bad choice for something such fundamental as
>> type of clock for buffer timestamping IMHO. Let's stop making the
>> controls API a dumping ground for almost everything in V4L2! ;)
> 
> What's wrong in using the control API in this case ? :-)

It just feels like not the right tool for the job. I don't think
timestamps are something the user is supposed to play with directly.
IMHO it's better to keep controls for purposes they were originally
designed as much as possible, i.e. for tweaking some parameters of
a device. The controls are already quite complex and probably not so
easy to grasp from a user perspective, even without things like
timestamps added there.

>>> Thanks for adding this. I knew I was forgetting something but didn't
>>> remember what --- I swear it was unintentional! :-)
>>>
>>> If we'd add more clocks without providing an ability to choose the clock
>>> from the user space, how would the clock be selected? It certainly isn't
>>> the driver's job, nor I think it should be system-specific either
>>> (platform data on embedded systems).
>>>
>>> It's up to the application and its needs. That would suggest we should
>>> always provide monotonic timestamps to applications (besides a potential
>>> driver-specific timestamp), and for that purpose the capability flag ---
>>> I admit I disliked the idea at first --- is enough.
>>>
>>> What comes to buffer flags, the application would also have to receive
>>> the first buffer from the device to even know what kind of timestamps
>>> the device uses, or at least call QUERYBUF. And in principle the flag
>>> should be checked on every buffer, unless we also specify the flag is
>>> the same for all buffers. And at certain point this will stop to make
>>> any sense...
>>
>> Good point. Perhaps VIDIOC_QUERYBUF and VIDIOC_DQBUF should be reporting
>> timestamps type only for the time they are being called. Not per buffer,
>> per device. And applications would be checking the flags any time they
>> want to find out what is the buffer timestamp type. Or every time if it
>> don't have full control over the device (S/G_PRIORITY).
>>
>>> A capability flag is cleaner solution from this perspective, and it can
>>> be amended by a control (or an ioctl) later on: the flag can be
>>> disregarded by applications whenever the control is present. If the
>>> application doesn't know about the control it can still rely on the
>>> flag. (I think this would be less clean than to go for the control right
>>> from the beginning, but better IMO.)
>>
>> But with the capability flag we would only be able to report one type of
>> clock, right ?
> 
> That's correct. The capability flag could mean "I support the clock selection
> API and default to a monotonic timestamp" though.

OK, sounds good.

>>>>> Device-dependent timestamp
>>>>> --------------------------
>>>>>
>>>>> Should we agree on selectable timestamps, the existing timestamp field
>>>>> (or a union with another field of different type) could be used for the
>>>>> device-dependent timestamps.
>>>>
>>>> No. Device timestamps should get their own field. You want to be able
>>>> to relate device timestamps with the monotonic timestamps, so you need
>>>> both.
>>>>
>>>>> Alternatively we can choose to re-use the existing timecode field.
>>>>>
>>>>> At the moment there's no known use case for passing device-dependent
>>>>> timestamps at the same time with monotonic timestamps.
>>>>
>>>> Well, the use case is there, but there is no driver support. The device
>>>> timestamps should be 64 bits to accomodate things like PTS and DTS from
>>>> MPEG streams. Since timecode is 128 bits we might want to use two u64
>>>> fields or perhaps 4 u32 fields.
>>>
>>> That should be an union for different kinds (or rather types) of
>>> device-dependent timestamps. On uvcvideo I think this is u32, not u64.
>>> We should be also able to tell what kind device dependent timestamp
>>> there is --- should buffer flags be used for that as well?
>>
>> Timecode has 'type' and 'flags' fields, couldn't it be accommodated for
>> reporting device-dependant timestamps as well ?
> 
> The timecode field is free for reuse, so we can definitely use it for device-
> specific timestamps.

All right, I didn't realize then we could just completely reuse this field.
How it would be re-designed is another topic for (long) discussions. :)

--

Regards,
Sylwester
