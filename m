Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud3.xs4all.net ([194.109.24.22]:52371 "EHLO
	lb1-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751661AbbHJNjS (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 10 Aug 2015 09:39:18 -0400
Message-ID: <55C8A968.40104@xs4all.nl>
Date: Mon, 10 Aug 2015 15:38:48 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
CC: Junghak Sung <jh1009.sung@samsung.com>,
	linux-media@vger.kernel.org, laurent.pinchart@ideasonboard.com,
	sakari.ailus@iki.fi, pawel@osciak.com, inki.dae@samsung.com,
	sw0312.kim@samsung.com, nenggun.kim@samsung.com,
	sangbae90.lee@samsung.com, rany.kwon@samsung.com
Subject: Re: [RFC PATCH v2 3/5] media: videobuf2: Divide videobuf2-core into
 2 parts
References: <1438332277-6542-1-git-send-email-jh1009.sung@samsung.com>	<1438332277-6542-4-git-send-email-jh1009.sung@samsung.com>	<55C893F9.408@xs4all.nl> <20150810095532.2386616d@recife.lan>
In-Reply-To: <20150810095532.2386616d@recife.lan>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 08/10/2015 02:55 PM, Mauro Carvalho Chehab wrote:
> Em Mon, 10 Aug 2015 14:07:21 +0200
> Hans Verkuil <hverkuil@xs4all.nl> escreveu:
> 
>> Hi Junghak,
>>
>> I'm reviewing the header changes since I think there are several improvements
>> that can be done that will make things more logical and will simplify the code.
>>
>> My comments below are a mix of suggestions for improvement and brainstorming.
>>
>> Feel free to ask for clarification if something is not clear.
>>
>> On 07/31/2015 10:44 AM, Junghak Sung wrote:
>>> Divide videobuf2-core into core part and v4l2-specific part
>>>  - core part: videobuf2 core related with buffer management & memory allocation
>>>  - v4l2-specific part: v4l2-specific stuff
>>>
>>> Signed-off-by: Junghak Sung <jh1009.sung@samsung.com>
>>> Signed-off-by: Geunyoung Kim <nenggun.kim@samsung.com>
>>> Acked-by: Seung-Woo Kim <sw0312.kim@samsung.com>
>>> Acked-by: Inki Dae <inki.dae@samsung.com>
>>> ---
>>
>> <snip>
> 
> ...
> 
>> I noticed that __qbuf_mmap/userptr/dmabuf are all in -v4l2.c. That's a bad sign:
>> those are some of the most complex vb2 functions and they really belong in the
>> core since you'll need it for DVB as well. As suggested above, by moving the index,
>> length and offset/userptr/fd data to the core structs these functions can all be
>> moved back into core.c as far as I can see.
> 
> Well, that will depend on how the DVB implementation will actually be.
> 
> Currently, VB2 has lot of V4L2-dependent code on it, with lots of V4L2
> structs from videodev2.h that are there.
> 
> Well, if we want the core to be re-used, it should not include videodev2.h
> anymore. Also, it should not assume that all non-V4L2 cores would use
> exactly the same logic for the userspace API.

Agreed.

> In the DVB case, it makes no sense to have anything similar to OVERLAY
> there.

VB2 doesn't support overlay at all, so that's no problem.

> I also can't see any usage for USERPTR at DVB neither, as either
> MMAP or DMABUF should fulfill all userspace needs I'm aware of.

While USERPTR isn't needed for DVB, the actual handling of such buffers
is completely independent of the API. I think it is from an architecture
point-of-view a really bad idea if anyone other than the vb2 core would
call the memops. So yes, the core would have code that is not needed by
DVB, but it still is something that belongs to the core in my view. Anything
else is very ugly.

> 
> Also, the meta data for the DVB upcoming ioctls for MMAP/DMABUF aren't
> yet proposed. They can be very different than the ones inside the V4L2
> ioctls.

Well, it's pretty much constrained by mmap() and the dma-buf API. I.e. an
offset for for mmap and a fd for dmabuf. You don't have a choice here.

> 
> So, I guess it is better for now to keep those API-dependent stuff at 
> VB2-v4l2 and, once the DVB code (and the corresponding API bits) are
> written, revisit it and then move the common code to the VB2 core.

I strongly disagree with that. Having API-dependent code calling memops
defeats the purpose. There is nothing wrong with having a vb2 core that
supports e.g. USERPTR and dma-buf as long as that core is API-independent.

But there is a lot wrong if the API-dependent code is bypassing the vb2 core
code to call low-level memops.

>> It is good to remember that today the v4l2_buffer struct is used in the vb2
>> core because vb2 is only used with v4l2, so why duplicate v4l2_buffer fields
>> in the vb2 core structs? 
> 
> We should not have any v4l2_* struct inside VB2 core, as the DVB core
> should not be dependent on the V4L2 structs. So, everything that it is
> V4L2-specific should be inside the VB2-v4l2. The reverse is also true:
> we should not pollute the VB2 core with DVB-specific data structures.

I never said anything else. I was talking about what's used today and why
it is the way it is now.

> So, all VB2-specific struct should be at VB2-dvb.
> 
>> But if we want to reuse it for other subsystems, then
>> the vb2 core structs should contain all the core buffer information. This avoids
>> the need for a lot of the ops that you added and makes it possible to keep the
>> __qbuf_mmap/userptr/dmabuf in the core code as well.
>>
>> Adding these fields to the vb2 core structs is something that can be done first,
>> before splitting up core.c into core.c and v4l2.c.
> 
> I'm afraid that we'll lose the big picture if we try to put the
> API-dependent parts at the core before adding a non-V4L2 usage on VB2.
> 
> We can always simplify the code latter, but IMHO we should focus first
> on adding the new functionality (support for DVB). Afterwards, we'll have
> a better view on what API-dependent code could be shared.

This is core code. I must be able to follow all the changes and right now
I can't. So simplifications like this should be done first before the split.
It will makes things much easier to follow.

The whole goal of a vb2 core is that it:

1) does not use any v4l2/dvb/whatever subsystem specific structs or includes.
2) deals with *all* the buffer memory handling. This is the most complex part, and
   that's what really belongs here. So memops being called from API-dependent code
   is wrong and I'll NACK that.
3) does all the ringbuffer handling etc.

The split will be much more obvious and logical if things like index, length,
offset/userptr/fd are added to the vb2 core structs. We could have done that
when we created vb2 since it's obviously essential core buffer information, but we
had the v4l2_buffer struct anyway so there was no real need to do so. But now there
is.

Regards,

	Hans
