Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud8.xs4all.net ([194.109.24.21]:36694 "EHLO
        lb1-smtp-cloud8.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727981AbeKSVVo (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 19 Nov 2018 16:21:44 -0500
Subject: Re: [PATCH 1/2] vb2: add waiting_in_dqbuf flag
To: Tomasz Figa <tfiga@chromium.org>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>, mhjungk@gmail.com
References: <20181113150834.22125-1-hverkuil@xs4all.nl>
 <20181113150834.22125-2-hverkuil@xs4all.nl>
 <CAAFQd5DbDO79KXMhW=tPALy9WDTRBpQFY_bakqqriH9Qa9nBsw@mail.gmail.com>
 <363c4eb1-7ed9-7adc-90c1-af09d6570b6d@xs4all.nl>
 <CAAFQd5BXxcSxVXwx3OvXWPfuGCRFf++wM8pn0rpuqZLnE96K4Q@mail.gmail.com>
 <7f01c7ae-197f-bb5e-b0d8-9e4f388802a9@xs4all.nl>
 <cf140415-95d4-d609-1a90-ee139da47487@xs4all.nl>
 <CAAFQd5CP=WPrn3HduyxVefuAL3w9ZjMaa3-AdvbRZx+sNTyhzg@mail.gmail.com>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <e57e921d-80fa-0c3b-f7a0-79e49566c7ab@xs4all.nl>
Date: Mon, 19 Nov 2018 11:58:25 +0100
MIME-Version: 1.0
In-Reply-To: <CAAFQd5CP=WPrn3HduyxVefuAL3w9ZjMaa3-AdvbRZx+sNTyhzg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 11/19/2018 11:32 AM, Tomasz Figa wrote:
> On Mon, Nov 19, 2018 at 6:54 PM Hans Verkuil <hverkuil@xs4all.nl> wrote:
>>
>> On 11/19/2018 09:44 AM, Hans Verkuil wrote:
>>> On 11/19/2018 06:27 AM, Tomasz Figa wrote:
>>>> On Fri, Nov 16, 2018 at 6:45 PM Hans Verkuil <hverkuil@xs4all.nl> wrote:
>>>>>
>>>>> On 11/16/2018 09:43 AM, Tomasz Figa wrote:
>>>>>> Hi Hans,
>>>>>>
>>>>>> On Wed, Nov 14, 2018 at 12:08 AM Hans Verkuil <hverkuil@xs4all.nl> wrote:
>>>>>>>
>>>>>>> Calling VIDIOC_DQBUF can release the core serialization lock pointed to
>>>>>>> by vb2_queue->lock if it has to wait for a new buffer to arrive.
>>>>>>>
>>>>>>> However, if userspace dup()ped the video device filehandle, then it is
>>>>>>> possible to read or call DQBUF from two filehandles at the same time.
>>>>>>>
>>>>>>
>>>>>> What side effects would reading have?
>>>>>>
>>>>>> As for another DQBUF in parallel, perhaps that's actually a valid
>>>>>> operation that should be handled? I can imagine that one could want to
>>>>>> have multiple threads dequeuing buffers as they become available, so
>>>>>> that no dispatch thread is needed.
>>>>>
>>>>> I think parallel DQBUFs can be done, but it has never been tested, nor
>>>>> has vb2 been designed with that in mind. I also don't see the use-case
>>>>> since if you have, say, two DQBUFs in parallel, then it will be random
>>>>> which DQBUF gets which frame.
>>>>>
>>>>
>>>> Any post processing that operates only on single frame data would be
>>>> able to benefit from multiple threads, with results ordered after the
>>>> processing, based on timestamps.
>>>>
>>>> Still, if that's not something we've ever claimed as supported and
>>>> couldn't work correctly with current code, it sounds fair to
>>>> completely forbid it for now.
>>>>
>>>>> If we ever see a need for this, then that needs to be designed and tested
>>>>> properly.
>>>>>
>>>>>>
>>>>>>> It is also possible to call REQBUFS from one filehandle while the other
>>>>>>> is waiting for a buffer. This will remove all the buffers and reallocate
>>>>>>> new ones. Removing all the buffers isn't the problem here (that's already
>>>>>>> handled correctly by DQBUF), but the reallocating part is: DQBUF isn't
>>>>>>> aware that the buffers have changed.
>>>>>>>
>>>>>>> This is fixed by setting a flag whenever the lock is released while waiting
>>>>>>> for a buffer to arrive. And checking the flag where needed so we can return
>>>>>>> -EBUSY.
>>>>>>
>>>>>> Maybe it would make more sense to actually handle those side effects?
>>>>>> Such waiting DQBUF would then just fail in the same way as if it
>>>>>> couldn't get a buffer (or if it's blocking, just retry until a correct
>>>>>> buffer becomes available?).
>>>>>
>>>>> That sounds like a good idea, but it isn't.
>>>>>
>>>>> With this patch you can't call REQBUFS to reallocate buffers while a thread
>>>>> is waiting for a buffer.
>>>>>
>>>>> If I allow this, then the problem moves to when the thread that called REQBUFS
>>>>> calls DQBUF next. Since we don't allow multiple DQBUFs this second DQBUF will
>>>>> mysteriously fail. If we DO allow multiple DQBUFs, then how does REQBUFS ensure
>>>>> that only the DQBUF that relied on the old buffers is stopped?
>>>>>
>>>>> It sounds nice, but the more I think about it, the more problems I see with it.
>>>>>
>>>>> I think it is perfectly reasonable to expect REQBUFS to return EBUSY if some
>>>>> thread is still waiting for a buffer.
>>>>>
>>>>> That said, I think one test is missing in vb2_core_create_bufs: there too it
>>>>> should check waiting_in_dqbuf if q->num_buffers == 0: it is possible to do
>>>>> REQBUFS(0) followed by CREATE_BUFS() while another thread is waiting for a
>>>>> buffer. CREATE_BUFS acts like REQBUFS(count >= 1) in that case.
>>>>>
>>>>> Admittedly, that would require some extremely unfortunate scheduling, but
>>>>> it is easy enough to check this.
>>>>
>>>> I thought a bit more about this and I agree with you. We should keep
>>>> things as simple as possible.
>>>>
>>>> Another thing that came to my mind is that the problematic scenario
>>>> described in the commit message can happen only if queue->lock ==
>>>> dev->lock. I wonder how likely it would be to mandate queue->lock !=
>>>> dev->lock?
>>>
>>> My plan is to switch vivid to that model. Expect patches for that today.
>>> One thing I noticed is that there is an issue with calling queue_setup
>>> in that case. I have a separate patch for that, so just read it when I
>>> post it.
>>
>> Note that this specific scenario can happen regardless of whether
>> queue->lock == dev->lock or not.
> 
> Ah, good point. Somehow I assumed that only QBUF/DQBUF would use
> queue->lock, while anything else would use dev->lock, but that's not
> the case.
> 
> Then I can't find any simpler and/or more general fix for now, so I'm
> okay with this.
> 
> Another note, don't we need similar error in case of REQBUFS(0), while
> DQBUF() is waiting? Current patch seems to add one only for count !=
> 0.

It's OK to delete since that will set q->streaming to false, and DQBUF will
return an error.

Regards,

	Hans
