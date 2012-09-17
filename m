Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:44030 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S932142Ab2IQRTd (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 17 Sep 2012 13:19:33 -0400
Message-ID: <50575BA1.8020600@iki.fi>
Date: Mon, 17 Sep 2012 20:19:29 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
MIME-Version: 1.0
To: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
CC: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	=?ISO-8859-1?Q?R=E9mi_Denis-Courmont?= <remi@remlab.net>,
	linux-media@vger.kernel.org, Hans Verkuil <hans.verkuil@cisco.com>
Subject: Re: [RFCv3 API PATCH 15/31] v4l2-core: Add new V4L2_CAP_MONOTONIC_TS
 capability.
References: <1347620266-13767-1-git-send-email-hans.verkuil@cisco.com> <5054E218.4010807@gmail.com> <201209161557.15049.hverkuil@xs4all.nl> <2870315.6PlfZS62FS@avalon> <50564BCE.8010901@gmail.com>
In-Reply-To: <50564BCE.8010901@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sylwester,

Sylwester Nawrocki wrote:
> On 09/16/2012 05:33 PM, Laurent Pinchart wrote:
>> On Sunday 16 September 2012 15:57:14 Hans Verkuil wrote:
>>> On Sat September 15 2012 22:16:24 Sylwester Nawrocki wrote:
>>>> On 09/15/2012 02:35 PM, Hans Verkuil wrote:
>>>>>>>> If we switch all existing drivers to monotonic timestamps in kernel
>>>>>>>> release
>>>>>>>> 3.x, v4l2-compliance can just use the version it gets from
>>>>>>>> VIDIOC_QUERYCAP and enforce monotonic timestamps verification if the
>>>>>>>> version is>= 3.x. This isn't more difficult for apps to check than a
>>>>>>>> dedicated flag (although it's less explicit).
>>>>>>>
>>>>>>> I think that checking for the driver (kernel) version is a very poor
>>>>>>> substitute for testing against a proper flag.
>>>>>>
>>>>>> That flag should be the default in this case. The flag should be set by
>>>>>> the framework instead giving every driver the job of setting it.
>>>>>>
>>>>>>> One alternative might be to use a v4l2_buffer flag instead. That does
>>>>>>> have the advantage that in the future we can add additional flags
>>>>>>> should we need to support different clocks. Should we ever add
>>>>>>> support to switch clocks dynamically, then a buffer flag is more
>>>>>>> suitable than a driver capability. In that scenario it does make real
>>>>>>> sense to have a flag (or really mask).
>>>>>>>
>>>>>>> Say something like this:
>>>>>>>
>>>>>>> /* Clock Mask */
>>>>>>> V4L2_BUF_FLAG_CLOCK_MASK	0xf000
>>>>>>> /* Possible Clocks */
>>>>>>> V4L2_BUF_FLAG_CLOCK_SYSTEM	0x0000
>>>>>
>>>>> I realized that this should be called:
>>>>>
>>>>> V4L2_BUF_FLAG_CLOCK_UNKNOWN	0x0000
>>>>>
>>>>> With a comment saying that is clock is either the system clock or a
>>>>> monotonic clock. That reflects the current situation correctly.
>>>>>
>>>>>>> V4L2_BUF_FLAG_CLOCK_MONOTONIC	0x1000
>>>>
>>>> There is already lots of overhead related to the buffers management, could
>>>> we perhaps have the most common option defined in a way that drivers don't
>>>> need to update each buffer's flags before dequeuing, only to indicate the
>>>> timestamp type (other than flags being modified in videobuf) ?
>>>
>>> Well, if all vb2 drivers use the monotonic clock, then you could do it in
>>> __fill_v4l2_buffer: instead of clearing just the state flags you'd clear
>>> state + clock flags, and you OR in the monotonic flag in the case statement
>>> below (adding just a single b->flags |= line in the DEQUEUED case).
>>>
>>> So that wouldn't add any overhead. Not that I think setting a flag will add
>>> any measurable overhead in any case.
>
> Yes, that might be indeed negligible overhead, especially if it's done well.
> User space logic usually adds much more to complexity.
>
> Might be good idea to add some helpers to videobuf2, so handling timestamps
> is as simple as possible in drivers.

Of the V4L2 core. Taking the timestamp has to be done usually at a very 
precise point in the code, and that's a decision I think is better done 
in the driver. Timestamps are also independent of the videobuf2.

>>>> This buffer flags idea sounds to me worse than the capability flag. After
>>>> all the drivers should use monotonic clock timestamps, shouldn't they ?
>>>
>>> Yes. But you have monotonic and raw monotonic clocks at the moment, and
>>> perhaps others will be added in the future. You can't change clocks if you
>>> put this in the querycap capabilities.
>
> Fair enough. BTW, CLOCK_MONOTONIC_RAW is not defined in any POSIX standard,
> is it ?

It's Linux-specific. Perhaps it's worth noting that both V4L2 and ALSA 
are Linux-specific, too. :-)

Raw wonotonic time could be better in some use cases as it's not 
NTP-adjusted. Which one is better for the purpose might be 
system-specific, albeit I'm leaning on the side of the monotonic in a 
general case.

...

>>> I'd really like to keep this door open. My experience is that if something
>>> is possible, then someone somewhere will want to use it.
>
> Indeed, caps flags approach might be too limited anyway. And a v4l2 control
> might be not good for reporting things like these.

Why not? Are there other mechanisms that are suitable for this than 
controls? If we end up using controls for this, then we should make it 
as easy as possible for the drivers.

Kind regards,

-- 
Sakari Ailus
sakari.ailus@iki.fi
