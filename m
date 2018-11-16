Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud7.xs4all.net ([194.109.24.31]:53695 "EHLO
        lb3-smtp-cloud7.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727398AbeKPT5X (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 16 Nov 2018 14:57:23 -0500
Subject: Re: [PATCH 1/2] vb2: add waiting_in_dqbuf flag
To: Tomasz Figa <tfiga@chromium.org>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>, mhjungk@gmail.com
References: <20181113150834.22125-1-hverkuil@xs4all.nl>
 <20181113150834.22125-2-hverkuil@xs4all.nl>
 <CAAFQd5DbDO79KXMhW=tPALy9WDTRBpQFY_bakqqriH9Qa9nBsw@mail.gmail.com>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <363c4eb1-7ed9-7adc-90c1-af09d6570b6d@xs4all.nl>
Date: Fri, 16 Nov 2018 10:45:46 +0100
MIME-Version: 1.0
In-Reply-To: <CAAFQd5DbDO79KXMhW=tPALy9WDTRBpQFY_bakqqriH9Qa9nBsw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 11/16/2018 09:43 AM, Tomasz Figa wrote:
> Hi Hans,
> 
> On Wed, Nov 14, 2018 at 12:08 AM Hans Verkuil <hverkuil@xs4all.nl> wrote:
>>
>> Calling VIDIOC_DQBUF can release the core serialization lock pointed to
>> by vb2_queue->lock if it has to wait for a new buffer to arrive.
>>
>> However, if userspace dup()ped the video device filehandle, then it is
>> possible to read or call DQBUF from two filehandles at the same time.
>>
> 
> What side effects would reading have?
> 
> As for another DQBUF in parallel, perhaps that's actually a valid
> operation that should be handled? I can imagine that one could want to
> have multiple threads dequeuing buffers as they become available, so
> that no dispatch thread is needed.

I think parallel DQBUFs can be done, but it has never been tested, nor
has vb2 been designed with that in mind. I also don't see the use-case
since if you have, say, two DQBUFs in parallel, then it will be random
which DQBUF gets which frame.

If we ever see a need for this, then that needs to be designed and tested
properly.

> 
>> It is also possible to call REQBUFS from one filehandle while the other
>> is waiting for a buffer. This will remove all the buffers and reallocate
>> new ones. Removing all the buffers isn't the problem here (that's already
>> handled correctly by DQBUF), but the reallocating part is: DQBUF isn't
>> aware that the buffers have changed.
>>
>> This is fixed by setting a flag whenever the lock is released while waiting
>> for a buffer to arrive. And checking the flag where needed so we can return
>> -EBUSY.
> 
> Maybe it would make more sense to actually handle those side effects?
> Such waiting DQBUF would then just fail in the same way as if it
> couldn't get a buffer (or if it's blocking, just retry until a correct
> buffer becomes available?).

That sounds like a good idea, but it isn't.

With this patch you can't call REQBUFS to reallocate buffers while a thread
is waiting for a buffer.

If I allow this, then the problem moves to when the thread that called REQBUFS
calls DQBUF next. Since we don't allow multiple DQBUFs this second DQBUF will
mysteriously fail. If we DO allow multiple DQBUFs, then how does REQBUFS ensure
that only the DQBUF that relied on the old buffers is stopped?

It sounds nice, but the more I think about it, the more problems I see with it.

I think it is perfectly reasonable to expect REQBUFS to return EBUSY if some
thread is still waiting for a buffer.

That said, I think one test is missing in vb2_core_create_bufs: there too it
should check waiting_in_dqbuf if q->num_buffers == 0: it is possible to do
REQBUFS(0) followed by CREATE_BUFS() while another thread is waiting for a
buffer. CREATE_BUFS acts like REQBUFS(count >= 1) in that case.

Admittedly, that would require some extremely unfortunate scheduling, but
it is easy enough to check this.

Regards,

	Hans

> 
> Best regards,
> Tomasz
> 
>>
>> Signed-off-by: Hans Verkuil <hverkuil@xs4all.nl>
>> ---
>>  .../media/common/videobuf2/videobuf2-core.c    | 18 ++++++++++++++++++
>>  include/media/videobuf2-core.h                 |  1 +
>>  2 files changed, 19 insertions(+)
>>
>> diff --git a/drivers/media/common/videobuf2/videobuf2-core.c b/drivers/media/common/videobuf2/videobuf2-core.c
>> index 03954c13024c..138223af701f 100644
>> --- a/drivers/media/common/videobuf2/videobuf2-core.c
>> +++ b/drivers/media/common/videobuf2/videobuf2-core.c
>> @@ -672,6 +672,11 @@ int vb2_core_reqbufs(struct vb2_queue *q, enum vb2_memory memory,
>>                 return -EBUSY;
>>         }
>>
>> +       if (q->waiting_in_dqbuf && *count) {
>> +               dprintk(1, "another dup()ped fd is waiting for a buffer\n");
>> +               return -EBUSY;
>> +       }
>> +
>>         if (*count == 0 || q->num_buffers != 0 ||
>>             (q->memory != VB2_MEMORY_UNKNOWN && q->memory != memory)) {
>>                 /*
>> @@ -1624,6 +1629,11 @@ static int __vb2_wait_for_done_vb(struct vb2_queue *q, int nonblocking)
>>         for (;;) {
>>                 int ret;
>>
>> +               if (q->waiting_in_dqbuf) {
>> +                       dprintk(1, "another dup()ped fd is waiting for a buffer\n");
>> +                       return -EBUSY;
>> +               }
>> +
>>                 if (!q->streaming) {
>>                         dprintk(1, "streaming off, will not wait for buffers\n");
>>                         return -EINVAL;
>> @@ -1651,6 +1661,7 @@ static int __vb2_wait_for_done_vb(struct vb2_queue *q, int nonblocking)
>>                         return -EAGAIN;
>>                 }
>>
>> +               q->waiting_in_dqbuf = 1;
>>                 /*
>>                  * We are streaming and blocking, wait for another buffer to
>>                  * become ready or for streamoff. Driver's lock is released to
>> @@ -1671,6 +1682,7 @@ static int __vb2_wait_for_done_vb(struct vb2_queue *q, int nonblocking)
>>                  * the locks or return an error if one occurred.
>>                  */
>>                 call_void_qop(q, wait_finish, q);
>> +               q->waiting_in_dqbuf = 0;
>>                 if (ret) {
>>                         dprintk(1, "sleep was interrupted\n");
>>                         return ret;
>> @@ -2547,6 +2559,12 @@ static size_t __vb2_perform_fileio(struct vb2_queue *q, char __user *data, size_
>>         if (!data)
>>                 return -EINVAL;
>>
>> +       if (q->waiting_in_dqbuf) {
>> +               dprintk(3, "another dup()ped fd is %s\n",
>> +                       read ? "reading" : "writing");
>> +               return -EBUSY;
>> +       }
>> +
>>         /*
>>          * Initialize emulator on first call.
>>          */
>> diff --git a/include/media/videobuf2-core.h b/include/media/videobuf2-core.h
>> index e86981d615ae..613f22910174 100644
>> --- a/include/media/videobuf2-core.h
>> +++ b/include/media/videobuf2-core.h
>> @@ -584,6 +584,7 @@ struct vb2_queue {
>>         unsigned int                    start_streaming_called:1;
>>         unsigned int                    error:1;
>>         unsigned int                    waiting_for_buffers:1;
>> +       unsigned int                    waiting_in_dqbuf:1;
>>         unsigned int                    is_multiplanar:1;
>>         unsigned int                    is_output:1;
>>         unsigned int                    copy_timestamp:1;
>> --
>> 2.19.1
>>
