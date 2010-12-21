Return-path: <mchehab@gaivota>
Received: from mx1.redhat.com ([209.132.183.28]:12844 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750835Ab0LULLZ (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 21 Dec 2010 06:11:25 -0500
Message-ID: <4D108B1A.6060004@redhat.com>
Date: Tue, 21 Dec 2010 09:10:18 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Hans Verkuil <hverkuil@xs4all.nl>
CC: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	linux-media@vger.kernel.org
Subject: Re: [GIT PULL FOR 2.6.37] uvcvideo: BKL removal
References: <201011291115.11061.laurent.pinchart@ideasonboard.com> <201012181145.29681.hverkuil@xs4all.nl> <4D0F47B8.6040600@redhat.com> <201012201328.06493.hverkuil@xs4all.nl>
In-Reply-To: <201012201328.06493.hverkuil@xs4all.nl>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

Em 20-12-2010 10:28, Hans Verkuil escreveu:
> On Monday, December 20, 2010 13:10:32 Mauro Carvalho Chehab wrote:
>> Em 18-12-2010 08:45, Hans Verkuil escreveu:
>>> On Saturday, December 18, 2010 01:54:41 Laurent Pinchart wrote:
>>>> Hi Mauro,
>>>>
>>>> On Friday 17 December 2010 18:09:39 Mauro Carvalho Chehab wrote:
>>>>> Em 14-12-2010 08:55, Laurent Pinchart escreveu:
>>>>>> Hi Mauro,
>>>>>>
>>>>>> Please don't forget this pull request for 2.6.37.
>>>>>
>>>>> Pull request for upstream sent today.
>>>>
>>>> Thank you.
>>>>
>>>>> I didn't find any regressions at the BKL removal patches, but I noticed a
>>>>> few issues with qv4l2, not all related to uvcvideo. The remaining of this
>>>>> email is an attempt to document them for later fixes.
>>>>>
>>>>> They don't seem to be regressions caused by BKL removal, but the better
>>>>> would be to fix them later.
>>>>>
>>>>> - with uvcvideo and two video apps, if qv4l2 is started first, the second
>>>>> application doesn't start/capture. I suspect that REQBUFS (used by qv4l2
>>>>> to probe mmap/userptr capabilities) create some resource locking at
>>>>> uvcvideo. The proper way is to lock the resources only if the driver is
>>>>> streaming, as other drivers and videobuf do.
>>>>
>>>> I don't agree with that. The uvcvideo driver has one buffer queue per device, 
>>>> so if an application requests buffers on one file handle it will lock other 
>>>> applications out. If the driver didn't it would be subject to race conditions.
>>>
>>> I agree with Laurent. Once an application calls REQBUFS with non-zero count,
>>> then it should lock the resources needed for streaming. The reason behind that
>>> is that REQBUFS also locks the current selected format in place, since the
>>> format determines the amount of memory needed for the buffers.
>>
>> qv4l2 calls REQBUFS(1), then REQBUFS(0). Well, this is currently wrong, as most
>> drivers will only release buffers at VIDIOC_STREAMOFF.
> 
> qv4l2 first calls STREAMOFF, then REQBUFS(1), then REQBUFS(0). In the hope that one
> of these will actually free any buffers. It's random at the moment when drivers
> release buffers, one of the reasons for using vb2.

This won't free buffers. REQBUFS(0) is not honored. so, what you're doing is really
STREAMOFF/REQBUFS(1).

It would work fine if you change the order to:
REQBUFS(1)
REQBUFS(0)
STREAMOFF

>> Anyway, even replacing 
>> REQBUFS(0) with VIDIOC_STREAMOFF at qv4l2 won't help with uvcvideo. It seems that,
>> once buffers are requested at uvcvideo, they will release only at close().
>>
>> One consequence on the way uvcvideo is currently doing it is that, if you use qv4l2,
>> it is impossible to change the video size, as it returns -EBUSY, if you ask it to
>> select a different format (even without streaming):
>> 	$ ./qv4l2
>> 	Set Capture Format: Device or resource busy
>>
>>> The reason a lot of drivers don't do this is partially because for many TV
>>> capture drivers it is highly unlikely that the buffer size will change after
>>> calling REQBUFS (there are basically only two formats: 720x480 or 720x576 and
>>> users will normally never change between the two). However, this is much more
>>> likely to happen for webcams and embedded systems supporting HDTV.
>>
>> What applications do, when they need to change the formats, is to call REQBUFS again.
>>
>>> The other reason is probably because driver developers simple do not realize
>>> they need to lock the resources on REQBUFS. I'm sure many existing drivers will
>>> fail miserably if you change the format after calling REQBUFS (particularly
>>> with mmap streaming mode).
>>
>> I didn't make any test, but I don't think they'll fail (at least, on the drivers
>> that use videobuf), as streaming format will be stored at the videobuf handling 
>> (at buffer_prepare callback).
>>
>> So, if you change the format, the change will be applied only at the next call
>> to REQBUFS.
> 
> This behavior isn't according to the spec. G/S_FMT relate to the current format,
> not to some future format. Most non-videobuf drivers will not support this
> behavior.
> 
> It should be simple, really:
> 
> STREAMOFF
> REQBUFS(0)
> 
> That's all that should be needed to stop streaming and return all buffers to the
> app. This is what uvc should also support (and I actually thought it did).
> 
> Attempts to change formats while buffers have been requested should be blocked
> with EBUSY. It's all perfectly reasonable. Well, perhaps next year we might
> succeed in having all drivers behave consistently...

You didn't understand me: uvcvideo is returning -EBUSY to format changes with
buffers freed.

If I understood well, during probe time, qv4l2 calls REQBUFS(1)/REQBUFS(0) for both
userptr and mmap, in order to detect what the device supports. This takes some locking
schema inside uvcvideo, but, as uvcvideo is only releasing such lock at close(),
it is impossible to change the video format. I even added an extra STREAMOFF at qv4l2
code, but this didn't solve the issue.

Well, maybe better than explaining it, you should try to change the video image size
or format with qv4l2 and an uvc camera ;)

Cheers,
Mauro
