Return-path: <mchehab@gaivota>
Received: from mx1.redhat.com ([209.132.183.28]:41656 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755821Ab0LTMKs (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 20 Dec 2010 07:10:48 -0500
Message-ID: <4D0F47B8.6040600@redhat.com>
Date: Mon, 20 Dec 2010 10:10:32 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Hans Verkuil <hverkuil@xs4all.nl>
CC: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	linux-media@vger.kernel.org
Subject: Re: [GIT PULL FOR 2.6.37] uvcvideo: BKL removal
References: <201011291115.11061.laurent.pinchart@ideasonboard.com> <4D0B9953.7090202@redhat.com> <201012180154.42363.laurent.pinchart@ideasonboard.com> <201012181145.29681.hverkuil@xs4all.nl>
In-Reply-To: <201012181145.29681.hverkuil@xs4all.nl>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

Em 18-12-2010 08:45, Hans Verkuil escreveu:
> On Saturday, December 18, 2010 01:54:41 Laurent Pinchart wrote:
>> Hi Mauro,
>>
>> On Friday 17 December 2010 18:09:39 Mauro Carvalho Chehab wrote:
>>> Em 14-12-2010 08:55, Laurent Pinchart escreveu:
>>>> Hi Mauro,
>>>>
>>>> Please don't forget this pull request for 2.6.37.
>>>
>>> Pull request for upstream sent today.
>>
>> Thank you.
>>
>>> I didn't find any regressions at the BKL removal patches, but I noticed a
>>> few issues with qv4l2, not all related to uvcvideo. The remaining of this
>>> email is an attempt to document them for later fixes.
>>>
>>> They don't seem to be regressions caused by BKL removal, but the better
>>> would be to fix them later.
>>>
>>> - with uvcvideo and two video apps, if qv4l2 is started first, the second
>>> application doesn't start/capture. I suspect that REQBUFS (used by qv4l2
>>> to probe mmap/userptr capabilities) create some resource locking at
>>> uvcvideo. The proper way is to lock the resources only if the driver is
>>> streaming, as other drivers and videobuf do.
>>
>> I don't agree with that. The uvcvideo driver has one buffer queue per device, 
>> so if an application requests buffers on one file handle it will lock other 
>> applications out. If the driver didn't it would be subject to race conditions.
> 
> I agree with Laurent. Once an application calls REQBUFS with non-zero count,
> then it should lock the resources needed for streaming. The reason behind that
> is that REQBUFS also locks the current selected format in place, since the
> format determines the amount of memory needed for the buffers.

qv4l2 calls REQBUFS(1), then REQBUFS(0). Well, this is currently wrong, as most
drivers will only release buffers at VIDIOC_STREAMOFF. Anyway, even replacing 
REQBUFS(0) with VIDIOC_STREAMOFF at qv4l2 won't help with uvcvideo. It seems that,
once buffers are requested at uvcvideo, they will release only at close().

One consequence on the way uvcvideo is currently doing it is that, if you use qv4l2,
it is impossible to change the video size, as it returns -EBUSY, if you ask it to
select a different format (even without streaming):
	$ ./qv4l2
	Set Capture Format: Device or resource busy

> The reason a lot of drivers don't do this is partially because for many TV
> capture drivers it is highly unlikely that the buffer size will change after
> calling REQBUFS (there are basically only two formats: 720x480 or 720x576 and
> users will normally never change between the two). However, this is much more
> likely to happen for webcams and embedded systems supporting HDTV.

What applications do, when they need to change the formats, is to call REQBUFS again.

> The other reason is probably because driver developers simple do not realize
> they need to lock the resources on REQBUFS. I'm sure many existing drivers will
> fail miserably if you change the format after calling REQBUFS (particularly
> with mmap streaming mode).

I didn't make any test, but I don't think they'll fail (at least, on the drivers
that use videobuf), as streaming format will be stored at the videobuf handling 
(at buffer_prepare callback).

So, if you change the format, the change will be applied only at the next call
to REQBUFS.

Cheers,
Mauro
