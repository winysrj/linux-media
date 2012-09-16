Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-we0-f174.google.com ([74.125.82.174]:53425 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752077Ab2IPV7q (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 16 Sep 2012 17:59:46 -0400
Received: by weyx8 with SMTP id x8so3513836wey.19
        for <linux-media@vger.kernel.org>; Sun, 16 Sep 2012 14:59:44 -0700 (PDT)
Message-ID: <50564BCE.8010901@gmail.com>
Date: Sun, 16 Sep 2012 23:59:42 +0200
From: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
MIME-Version: 1.0
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Hans Verkuil <hverkuil@xs4all.nl>
CC: Sakari Ailus <sakari.ailus@iki.fi>,
	=?ISO-8859-1?Q?R=E9mi_Denis-Cou?= =?ISO-8859-1?Q?rmont?=
	<remi@remlab.net>, linux-media@vger.kernel.org,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: Re: [RFCv3 API PATCH 15/31] v4l2-core: Add new V4L2_CAP_MONOTONIC_TS
 capability.
References: <1347620266-13767-1-git-send-email-hans.verkuil@cisco.com> <5054E218.4010807@gmail.com> <201209161557.15049.hverkuil@xs4all.nl> <2870315.6PlfZS62FS@avalon>
In-Reply-To: <2870315.6PlfZS62FS@avalon>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 09/16/2012 05:33 PM, Laurent Pinchart wrote:
> On Sunday 16 September 2012 15:57:14 Hans Verkuil wrote:
>> On Sat September 15 2012 22:16:24 Sylwester Nawrocki wrote:
>>> On 09/15/2012 02:35 PM, Hans Verkuil wrote:
>>>>>>> If we switch all existing drivers to monotonic timestamps in kernel
>>>>>>> release
>>>>>>> 3.x, v4l2-compliance can just use the version it gets from
>>>>>>> VIDIOC_QUERYCAP and enforce monotonic timestamps verification if the
>>>>>>> version is>= 3.x. This isn't more difficult for apps to check than a
>>>>>>> dedicated flag (although it's less explicit).
>>>>>>
>>>>>> I think that checking for the driver (kernel) version is a very poor
>>>>>> substitute for testing against a proper flag.
>>>>>
>>>>> That flag should be the default in this case. The flag should be set by
>>>>> the framework instead giving every driver the job of setting it.
>>>>>
>>>>>> One alternative might be to use a v4l2_buffer flag instead. That does
>>>>>> have the advantage that in the future we can add additional flags
>>>>>> should we need to support different clocks. Should we ever add
>>>>>> support to switch clocks dynamically, then a buffer flag is more
>>>>>> suitable than a driver capability. In that scenario it does make real
>>>>>> sense to have a flag (or really mask).
>>>>>>
>>>>>> Say something like this:
>>>>>>
>>>>>> /* Clock Mask */
>>>>>> V4L2_BUF_FLAG_CLOCK_MASK	0xf000
>>>>>> /* Possible Clocks */
>>>>>> V4L2_BUF_FLAG_CLOCK_SYSTEM	0x0000
>>>>
>>>> I realized that this should be called:
>>>>
>>>> V4L2_BUF_FLAG_CLOCK_UNKNOWN	0x0000
>>>>
>>>> With a comment saying that is clock is either the system clock or a
>>>> monotonic clock. That reflects the current situation correctly.
>>>>
>>>>>> V4L2_BUF_FLAG_CLOCK_MONOTONIC	0x1000
>>>
>>> There is already lots of overhead related to the buffers management, could
>>> we perhaps have the most common option defined in a way that drivers don't
>>> need to update each buffer's flags before dequeuing, only to indicate the
>>> timestamp type (other than flags being modified in videobuf) ?
>>
>> Well, if all vb2 drivers use the monotonic clock, then you could do it in
>> __fill_v4l2_buffer: instead of clearing just the state flags you'd clear
>> state + clock flags, and you OR in the monotonic flag in the case statement
>> below (adding just a single b->flags |= line in the DEQUEUED case).
>>
>> So that wouldn't add any overhead. Not that I think setting a flag will add
>> any measurable overhead in any case.

Yes, that might be indeed negligible overhead, especially if it's done well.
User space logic usually adds much more to complexity.

Might be good idea to add some helpers to videobuf2, so handling timestamps
is as simple as possible in drivers.

>>> This buffer flags idea sounds to me worse than the capability flag. After
>>> all the drivers should use monotonic clock timestamps, shouldn't they ?
>>
>> Yes. But you have monotonic and raw monotonic clocks at the moment, and
>> perhaps others will be added in the future. You can't change clocks if you
>> put this in the querycap capabilities.

Fair enough. BTW, CLOCK_MONOTONIC_RAW is not defined in any POSIX standard, 
is it ?

>>> Have anyone has ever come with a use case for switching timestamps clock
>>> type, can anyone give an example of it ? How likely is we will ever need
>>> that ?
>>
>> Well, ALSA allows you to switch between gettimeofday and monotonic. So in
>> theory at least if an app selects gettimeofday for alsa, that app might also
>> want to select gettimeofday for v4l2.

OK, I'm not complaining any more. :)

>> I'd really like to keep this door open. My experience is that if something
>> is possible, then someone somewhere will want to use it.

Indeed, caps flags approach might be too limited anyway. And a v4l2 control
might be not good for reporting things like these.

> As far as system timestamps are concerned I think the monotonic clock should
> be enough, at least for now. Raw monotonic could possibly be useful later.
> 
> Another important use case I have in mind is to provide raw device timestamps.
> For instance UVC devices send a device clock timestamp along with video
> frames. That timestamp can be useful to userspace applications.

Could be interesting to add support for something like this. Of what format
are then such device timestamps ?

--
Regards,
Sylwester
