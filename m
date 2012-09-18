Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:44177 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S932089Ab2IRHmi (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 18 Sep 2012 03:42:38 -0400
Date: Tue, 18 Sep 2012 10:42:33 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	=?iso-8859-1?Q?R=E9mi?= Denis-Courmont <remi@remlab.net>,
	linux-media@vger.kernel.org, Hans Verkuil <hans.verkuil@cisco.com>
Subject: Re: [RFCv3 API PATCH 15/31] v4l2-core: Add new
 V4L2_CAP_MONOTONIC_TS capability.
Message-ID: <20120918074159.GQ6834@valkosipuli.retiisi.org.uk>
References: <1347620266-13767-1-git-send-email-hans.verkuil@cisco.com>
 <5054E218.4010807@gmail.com>
 <201209161557.15049.hverkuil@xs4all.nl>
 <2870315.6PlfZS62FS@avalon>
 <50564BCE.8010901@gmail.com>
 <50575BA1.8020600@iki.fi>
 <505787CA.6070409@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <505787CA.6070409@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sylwester,

Sylwester Nawrocki wrote:
> On 09/17/2012 07:19 PM, Sakari Ailus wrote:
>> Sylwester Nawrocki wrote:
>>> On 09/16/2012 05:33 PM, Laurent Pinchart wrote:
>>>> On Sunday 16 September 2012 15:57:14 Hans Verkuil wrote:
>>>>> On Sat September 15 2012 22:16:24 Sylwester Nawrocki wrote:
>>>>>> On 09/15/2012 02:35 PM, Hans Verkuil wrote:
>>>>>>>>> One alternative might be to use a v4l2_buffer flag instead. That
>>>>>>>>> does
>>>>>>>>> have the advantage that in the future we can add additional flags
>>>>>>>>> should we need to support different clocks. Should we ever add
>>>>>>>>> support to switch clocks dynamically, then a buffer flag is more
>>>>>>>>> suitable than a driver capability. In that scenario it does make
>>>>>>>>> real
>>>>>>>>> sense to have a flag (or really mask).
>>>>>>>>>
>>>>>>>>> Say something like this:
>>>>>>>>>
>>>>>>>>> /* Clock Mask */
>>>>>>>>> V4L2_BUF_FLAG_CLOCK_MASK 0xf000
>>>>>>>>> /* Possible Clocks */
>>>>>>>>> V4L2_BUF_FLAG_CLOCK_SYSTEM 0x0000
>>>>>>>
>>>>>>> I realized that this should be called:
>>>>>>>
>>>>>>> V4L2_BUF_FLAG_CLOCK_UNKNOWN 0x0000
>>>>>>>
>>>>>>> With a comment saying that is clock is either the system clock or a
>>>>>>> monotonic clock. That reflects the current situation correctly.
>>>>>>>
>>>>>>>>> V4L2_BUF_FLAG_CLOCK_MONOTONIC 0x1000
>>>>>>
>>>>>> There is already lots of overhead related to the buffers
>>>>>> management, could
>>>>>> we perhaps have the most common option defined in a way that
>>>>>> drivers don't
>>>>>> need to update each buffer's flags before dequeuing, only to
>>>>>> indicate the
>>>>>> timestamp type (other than flags being modified in videobuf) ?
>>>>>
>>>>> Well, if all vb2 drivers use the monotonic clock, then you could do
>>>>> it in
>>>>> __fill_v4l2_buffer: instead of clearing just the state flags you'd
>>>>> clear
>>>>> state + clock flags, and you OR in the monotonic flag in the case
>>>>> statement
>>>>> below (adding just a single b->flags |= line in the DEQUEUED case).
>>>>>
>>>>> So that wouldn't add any overhead. Not that I think setting a flag
>>>>> will add
>>>>> any measurable overhead in any case.
>>>
>>> Yes, that might be indeed negligible overhead, especially if it's done
>>> well.
>>> User space logic usually adds much more to complexity.
>>>
>>> Might be good idea to add some helpers to videobuf2, so handling
>>> timestamps
>>> is as simple as possible in drivers.
>>
>> Of the V4L2 core. Taking the timestamp has to be done usually at a very
>> precise point in the code, and that's a decision I think is better done
>> in the driver. Timestamps are also independent of the videobuf2.
>
> Yes, good point. All in all videobuf2 belongs to v4l2-core, doesn't
> it ? ;)

You're correct. I meant to say that it could (or should) be separate 
from handling the buffers themselves.

> Taking a timestamp indeed needs some care and precision, but setting
> a flag could be considered a sort of separate issue - it's more relaxed
> and videobuf2 already handles the buffer flags.

True.

>>>>>> This buffer flags idea sounds to me worse than the capability flag.
>>>>>> After
>>>>>> all the drivers should use monotonic clock timestamps, shouldn't
>>>>>> they ?
>>>>>
>>>>> Yes. But you have monotonic and raw monotonic clocks at the moment, and
>>>>> perhaps others will be added in the future. You can't change clocks
>>>>> if you
>>>>> put this in the querycap capabilities.
>>>
>>> Fair enough. BTW, CLOCK_MONOTONIC_RAW is not defined in any POSIX
>>> standard,
>>> is it ?
>>
>> It's Linux-specific. Perhaps it's worth noting that both V4L2 and ALSA
>> are Linux-specific, too. :-)
>
> OK. I don't mind V4L2 and ALSA being Linux-specific...
>
> :)
>> Raw wonotonic time could be better in some use cases as it's not
>> NTP-adjusted. Which one is better for the purpose might be
>> system-specific, albeit I'm leaning on the side of the monotonic in a
>> general case.
>
> Yeah, I guess it's all determined by streams from what subsystems
> we're trying to synchronize and what clocks are used there. If there
> is a possibility to select from various clocks in at least one of
> the subsystems then we're all set.

It's not only that, it's also that the clock has to be suitable for the 
synchronisation problem at hand. Currently realtime timestamps could be 
used by ALSA and V4L2 but I could hardly recommend using them for 
audio/video synchronisation.

> The main issue here is that we already have plenty of different
> clocks and there is a need on the video side for at least:
> 1. reporting to user space what clock is used by a driver,
> and optionally
> 2. selecting clock type on user request.

I think the solution for 1 should be such it makes easy and clean to do 2.

>>>>> I'd really like to keep this door open. My experience is that if
>>>>> something
>>>>> is possible, then someone somewhere will want to use it.
>>>
>>> Indeed, caps flags approach might be too limited anyway. And a v4l2
>>> control
>>> might be not good for reporting things like these.
>>
>> Why not? Are there other mechanisms that are suitable for this than
>> controls? If we end up using controls for this, then we should make it
>> as easy as possible for the drivers.
>
> Sorry, my concern here was that timestamps are needed by all video
> devices and I wasn't sure if there are any video nodes that don't
> implement the v4l2 control ioctls. I.e. we might be enforcing adding
> controls support only for the purpose of being able to query the
> timestamps type. That was my concern here about using controls. However
> if all video devices implement the controls API then it's negligible.
> Moreover some parts of such control implementation could likely be
> a part v4l2-core.
>
> I'm just wondering why we need a flag when a control is going to be
> used anyway. It sounds like per-buffer controls/status but that's an
> issue that was previously discussed and is still not really addressed
> in V4L2 AFAICT.
>
> Flags + a control is likely going to fulfil all (most of) possible
> app requirements. Not sure if the applications really need to get
> timestamp type from each v4l2 buffer and the drivers need to be setting
> it. Rather than just using a control before starting/after stopping
> streaming to select, and at any time to query, the clock type.

I think so, too. It's unlikely that the user would want to change the 
value of the timestamp type control while streaming. Those flags could 
well be added later on if the need to do so arises.

Kind regards,

-- 
Sakari Ailus
sakari.ailus@iki.fi
