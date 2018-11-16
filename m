Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud7.xs4all.net ([194.109.24.31]:44750 "EHLO
        lb3-smtp-cloud7.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727543AbeKPT76 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 16 Nov 2018 14:59:58 -0500
Subject: Re: [PATCH 2/2] vb2: don't allow queueing buffers when canceling
 queue
To: Tomasz Figa <tfiga@chromium.org>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>, mhjungk@gmail.com
References: <20181113150834.22125-1-hverkuil@xs4all.nl>
 <20181113150834.22125-3-hverkuil@xs4all.nl>
 <CAAFQd5DWXJX29U8wpL=fysNo6TSc4scxa4uhEkdFVMDEQ85F3Q@mail.gmail.com>
 <13809aac-2304-1aef-b87e-4216997ff70b@xs4all.nl>
 <CAAFQd5CbWdh7MKJh41SOFbwHu9yN5d=WOtixVBMPjkSt9V4CMQ@mail.gmail.com>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <4cc9b992-e09a-61f7-6dbd-4be247086605@xs4all.nl>
Date: Fri, 16 Nov 2018 10:48:21 +0100
MIME-Version: 1.0
In-Reply-To: <CAAFQd5CbWdh7MKJh41SOFbwHu9yN5d=WOtixVBMPjkSt9V4CMQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 11/16/2018 09:45 AM, Tomasz Figa wrote:
> On Fri, Nov 16, 2018 at 5:42 PM Hans Verkuil <hverkuil@xs4all.nl> wrote:
>>
>> On 11/16/2018 09:34 AM, Tomasz Figa wrote:
>>> Hi Hans,
>>>
>>> On Wed, Nov 14, 2018 at 12:08 AM Hans Verkuil <hverkuil@xs4all.nl> wrote:
>>>>
>>>> Calling the stop_streaming op can release the core serialization lock
>>>> pointed to by vb2_queue->lock if it has to wait for buffers to finish.
>>>> An example of that behavior is the vivid driver.
>>>
>>> Why would vb2_queue->lock have to be released to wait for buffer to
>>> finish? The drivers I worked with never had to do anything like that.
>>
>> Actually, they all do. It's done through the wait_prepare/finish callbacks
>> and by setting those to vb2_ops_wait_prepare/finish.
>>
>> If you don't, then while one thread is waiting for a buffer to arrive,
>> another thread cannot queue a new buffer since it will be serialized by
>> queue->lock.
>>
>> v4l2-compliance even tests for this.
> 
> Why would you need the userspace to queue more buffers when you're
> stopping the queue?

Ah, I misunderstood your question. Your question was: why should stop_streaming
have to release the lock when it waits for buffers to finish.

In this case (vivid) the thread generating the image takes the main lock, which
is the same as queue->lock. So stop_streaming (which is called with the same
lock taken) has to unlock it, stop the thread, then retake it.

I thought this would be more common, but after analyzing other usages of kthread
it appears to be vivid specific. So I agree that it is better to fix vivid
instead of messing about with vb2.

Regards,

	Hans

> 
>>
>>>
>>>>
>>>> However, if userspace dup()ped the video device filehandle, then it is
>>>> possible to stop streaming on one filehandle and call read/write or
>>>> VIDIOC_QBUF from the other.
>>>
>>> How about other ioctls? I can imagine at least STREAMON could be
>>> called at the same time too, but not sure if it would have any side
>>> effects.
>>
>> STREAMON would return an error since q->streaming is still set while
>> in the stop_streaming callback.
>>
>> So that combination is safe.
>>
> 
> Okay, thanks. I'm still slightly worried that this approach with a
> flag makes it possible to miss some non-trivial cases, though...
> 
>> Regards,
>>
>>         Hans
>>
>>>
>>> Best regards,
>>> Tomasz
>>>
>>>>
>>>> This is fixed by setting a flag whenever stop_streaming is called and
>>>> checking the flag where needed so we can return -EBUSY.
>>>>
>>>> Signed-off-by: Hans Verkuil <hverkuil@xs4all.nl>
>>>> Reported-by: syzbot+736c3aae4af7b50d9683@syzkaller.appspotmail.com
>>>> ---
>>>>  drivers/media/common/videobuf2/videobuf2-core.c | 14 +++++++++++++-
>>>>  include/media/videobuf2-core.h                  |  1 +
>>>>  2 files changed, 14 insertions(+), 1 deletion(-)
>>>>
>>>> diff --git a/drivers/media/common/videobuf2/videobuf2-core.c b/drivers/media/common/videobuf2/videobuf2-core.c
>>>> index 138223af701f..560577321fe7 100644
>>>> --- a/drivers/media/common/videobuf2/videobuf2-core.c
>>>> +++ b/drivers/media/common/videobuf2/videobuf2-core.c
>>>> @@ -1503,6 +1503,10 @@ int vb2_core_qbuf(struct vb2_queue *q, unsigned int index, void *pb,
>>>>                 dprintk(1, "fatal error occurred on queue\n");
>>>>                 return -EIO;
>>>>         }
>>>> +       if (q->in_stop_streaming) {
>>>> +               dprintk(1, "stop_streaming is called\n");
>>>> +               return -EBUSY;
>>>> +       }
>>>>
>>>>         vb = q->bufs[index];
>>>>
>>>> @@ -1834,8 +1838,11 @@ static void __vb2_queue_cancel(struct vb2_queue *q)
>>>>          * Tell driver to stop all transactions and release all queued
>>>>          * buffers.
>>>>          */
>>>> -       if (q->start_streaming_called)
>>>> +       if (q->start_streaming_called) {
>>>> +               q->in_stop_streaming = 1;
>>>>                 call_void_qop(q, stop_streaming, q);
>>>> +               q->in_stop_streaming = 0;
>>>> +       }
>>>>
>>>>         /*
>>>>          * If you see this warning, then the driver isn't cleaning up properly
>>>> @@ -2565,6 +2572,11 @@ static size_t __vb2_perform_fileio(struct vb2_queue *q, char __user *data, size_
>>>>                 return -EBUSY;
>>>>         }
>>>>
>>>> +       if (q->in_stop_streaming) {
>>>> +               dprintk(3, "stop_streaming is called\n");
>>>> +               return -EBUSY;
>>>> +       }
>>>> +
>>>>         /*
>>>>          * Initialize emulator on first call.
>>>>          */
>>>> diff --git a/include/media/videobuf2-core.h b/include/media/videobuf2-core.h
>>>> index 613f22910174..5a3d3ada5940 100644
>>>> --- a/include/media/videobuf2-core.h
>>>> +++ b/include/media/videobuf2-core.h
>>>> @@ -585,6 +585,7 @@ struct vb2_queue {
>>>>         unsigned int                    error:1;
>>>>         unsigned int                    waiting_for_buffers:1;
>>>>         unsigned int                    waiting_in_dqbuf:1;
>>>> +       unsigned int                    in_stop_streaming:1;
>>>>         unsigned int                    is_multiplanar:1;
>>>>         unsigned int                    is_output:1;
>>>>         unsigned int                    copy_timestamp:1;
>>>> --
>>>> 2.19.1
>>>>
>>
