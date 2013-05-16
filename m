Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bk0-f52.google.com ([209.85.214.52]:38823 "EHLO
	mail-bk0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750767Ab3EPPAZ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 16 May 2013 11:00:25 -0400
Received: by mail-bk0-f52.google.com with SMTP id mz10so942605bkb.25
        for <linux-media@vger.kernel.org>; Thu, 16 May 2013 08:00:23 -0700 (PDT)
Message-ID: <5194F484.6060701@gmail.com>
Date: Thu, 16 May 2013 17:00:20 +0200
From: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
MIME-Version: 1.0
To: Hans Verkuil <hverkuil@xs4all.nl>
CC: linux-media <linux-media@vger.kernel.org>
Subject: Re: [RFCv2] Motion Detection API
References: <201305131132.26033.hverkuil@xs4all.nl> <5193A875.3000805@gmail.com> <201305160954.54413.hverkuil@xs4all.nl>
In-Reply-To: <201305160954.54413.hverkuil@xs4all.nl>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 05/16/2013 09:54 AM, Hans Verkuil wrote:
>>> 	#define V4L2_EVENT_MOTION_DET 5
>>>
>>> 	/**
>>> 	 * struct v4l2_event_motion_det - motion detection event
>>> 	 * @flags:             if set to V4L2_EVENT_MD_VALID_FRAME, then the
>>> 	 *                     frame_sequence field is valid.
>>> 	 * @frame_sequence:    the frame sequence number associated with this event.
>>> 	 * @mask:              which regions detected motion.
>>> 	 */
>>> 	struct v4l2_event_motion_det {
>>> 	       __u32 flags;
>>> 	       __u32 frame_sequence;
>>> 	       __u32 mask;
>>> 	};	
>>>
>>> - Add two new ioctls to get and set the block data:
>>>
>>>           #define V4L2_MD_TYPE_REGION     (1)
>>>           #define V4L2_MD_TYPE_THRESHOLD  (2)
>>>
>>>           struct v4l2_md_blocks {
>>>                   __u32 type;
>>>                   struct v4l2_rect rect;
>>>                   __u32 block_min;
>>>                   __u32 block_max;
>>> 		__u32 __user *blocks;
>>>                   __u32 reserved[32];
>>>           } __attribute__ ((packed));
>>
>> How about changing it to:
>>
>>             struct v4l2_md_blocks {
>>                   __u32 type;
>>                   __u32 size;
>>                   struct v4l2_rect rect;
>>                   __u32 block_min;
>>                   __u32 block_max;
>>                   __u32 reserved[32];
>>    		__u16 __user blocks[];
>>             } __attribute__ ((packed));
>>
>> i.e. making 'blocks' a flexible length array, so the size of the structure
>> is same on 32 and 64-bit architectures ? And we don't need any compat code ?
>> 'size' would indicate actual size of the blocks array.
>
> Nice idea, but it won't work: video_usercopy() will copy that struct to a
> kernel-space buffer and pass that on to the driver. But at that point the
> blocks array is cut off and the driver doesn't have access to the userspace
> pointer anymore.

I should have mentioned that it would require some modification at
video_usercopy(), but then it would not have been that much different from
adding compat code I guess. It would certainly not simplify already complex
video_usercopy()...

> It's really not all that difficult to add compat code for this, so I'll just
> stick with a pointer.
>
>> Also, the motion detection normally involves at least 2 frames, but
>> don't we
>> need a means to get MD result per frame ? Since the event is per frame ?
>> I guess this is something that could be added later if required.
>
> ???
>
> The event provides the result on a per-frame basis. Actually, it doesn't
> have to be per-frame: if flags == 0, it will depend on the hardware whether
> you can actually relate motion to frames.

I thought about adding, e.g. frame_sequence field to struct v4l2_md_blocks,
but there seems to be no practical use for it.

> I just realized that there is a hole in this RFC if flags == 0: if the motion
> detection is not per-frame, but just some global state, then we also need a
> way to tell userspace when the motion stopped.

> My original idea was that you get an event per frame where there is motion.
> So if you get a frame but no associated event, then motion stopped.

Hmm, not that good. I think it would be simpler for user space if it can use
the events API only to get all basic data.

> An alternative implementation would be that you get an event whenever the
> mask changes value (with the assumption that mask == 0 when you start
> streaming).

Yes, this sounds quite intuitive. You get an event whenever motion started
or stopped.

And this way there would be no need for sending events continuously for 
each
frame when there is motion detected ?

> I think this might be more efficient and it works better if you can't
> associate this event with a specific frame.

Yes, that makes sense to me. I assume it is better to have this API not
coupled too much with the streaming IO ioctls.

> What do you think?

Regards,
Sylwester
