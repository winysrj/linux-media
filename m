Return-path: <mchehab@pedra>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:58777 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756688Ab1DFUF0 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 6 Apr 2011 16:05:26 -0400
Received: by wwa36 with SMTP id 36so2211567wwa.1
        for <linux-media@vger.kernel.org>; Wed, 06 Apr 2011 13:05:24 -0700 (PDT)
Message-ID: <4D9CC780.3000902@gmail.com>
Date: Wed, 06 Apr 2011 22:05:20 +0200
From: Sylwester Nawrocki <snjw23@gmail.com>
MIME-Version: 1.0
To: Pawel Osciak <pawel@osciak.com>
CC: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	linux-media@vger.kernel.org, m.szyprowski@samsung.com,
	hverkuil@xs4all.nl
Subject: Re: [RFC/PATCH 1/2] v4l: videobuf2: Handle buf_queue errors
References: <1298830353-9797-1-git-send-email-laurent.pinchart@ideasonboard.com> <1298830353-9797-2-git-send-email-laurent.pinchart@ideasonboard.com> <AANLkTimx+MBg4qPHzubOCrAe7vDsic8_ot99NOxOWDHD@mail.gmail.com> <201103011154.19883.laurent.pinchart@ideasonboard.com> <AANLkTi=UKiPWRoDMj5aS1bAMOrnHOJ3Kiq-NyTQQpUjd@mail.gmail.com>
In-Reply-To: <AANLkTi=UKiPWRoDMj5aS1bAMOrnHOJ3Kiq-NyTQQpUjd@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi Pawel,

On 03/07/2011 12:20 AM, Pawel Osciak wrote:
> Hi Laurent,
> 
> On Tue, Mar 1, 2011 at 02:54, Laurent Pinchart
> <laurent.pinchart@ideasonboard.com>  wrote:
>> Hi Pawel,
>>
>> On Monday 28 February 2011 16:44:38 Pawel Osciak wrote:
>>> Hi Laurent,
>>> A few questions from me below. I feel we need to talk about this
>>> change a bit more, it introduces some recovery and consistency
>>> problems, unless I'm missing something.
>>>
>>> On Sun, Feb 27, 2011 at 10:12, Laurent Pinchart wrote:
>>>> videobuf2 expects drivers to check buffer in the buf_prepare operation
>>>> and to return success only if the buffer can queued without any issue.
>>>>
>>>> For hot-pluggable devices, disconnection events need to be handled at
>>>> buf_queue time. Checking the disconnected flag and adding the buffer to
>>>> the driver queue need to be performed without releasing the driver
>>>> spinlock, otherwise race conditions can occur in which the driver could
>>>> still allow a buffer to be queued after the disconnected flag has been
>>>> set, resulting in a hang during the next DQBUF operation.
>>>>
>>>> This problem can be solved either in the videobuf2 core or in the device
>>>> drivers. To avoid adding a spinlock to videobuf2, make buf_queue return
>>>> an int and handle buf_queue failures in videobuf2. Drivers must not
>>>> return an error in buf_queue if the condition leading to the error can
>>>> be caught in buf_prepare.
>>>>
>>>> Signed-off-by: Laurent Pinchart<laurent.pinchart@ideasonboard.com>
>>>> ---
>>>>   drivers/media/video/videobuf2-core.c |   32
>>>> ++++++++++++++++++++++++++------ include/media/videobuf2-core.h       |
>>>>     2 +-
>>>>   2 files changed, 27 insertions(+), 7 deletions(-)
>>>>
>>>> diff --git a/drivers/media/video/videobuf2-core.c
>>>> b/drivers/media/video/videobuf2-core.c index cc7ab0a..1d81536 100644
>>>> --- a/drivers/media/video/videobuf2-core.c
>>>> +++ b/drivers/media/video/videobuf2-core.c
>>>> @@ -798,13 +798,22 @@ static int __qbuf_mmap(struct vb2_buffer *vb,
>>>> struct v4l2_buffer *b) /**
>>>>   * __enqueue_in_driver() - enqueue a vb2_buffer in driver for processing
>>>>   */
>>>> -static void __enqueue_in_driver(struct vb2_buffer *vb)
>>>> +static int __enqueue_in_driver(struct vb2_buffer *vb)
>>>>   {
>>>>         struct vb2_queue *q = vb->vb2_queue;
>>>> +       int ret;
>>>>
>>>>         vb->state = VB2_BUF_STATE_ACTIVE;
>>>>         atomic_inc(&q->queued_count);
>>>> -       q->ops->buf_queue(vb);
>>>> +       ret = q->ops->buf_queue(vb);
>>>> +       if (ret == 0)
>>>> +               return 0;
>>>> +
>>>> +       vb->state = VB2_BUF_STATE_ERROR;
>>>> +       atomic_dec(&q->queued_count);
>>>> +       wake_up_all(&q->done_wq);
>>>> +
>>>> +       return ret;
>>>
>>> Unless I am missing something, when this happens for an n-th buffer,
>>> we wake up all, but only one buffer will have the ERROR state, all the
>>> other will be in QUEUED state. This will mess up return values from
>>> dqbuf (if this happens on streamon) for other buffers, they will have
>>> their V4L2_BUF_FLAG_QUEUED set after dqbuf. Also, returning 0 from
>>> DQBUF and the V4L2_BUF_FLAG_ERROR for the failed buffer suggests that
>>> streaming may continue.
>>
>> Actually not quite, as the driver is expected to mark all buffers as erroneous
>> and wake up userspace when the disconnection event is received. Subsequent
>> calls to VIDIOC_QBUF (or VIDIOC_STREAMON) need to return an error. I'm not
>> sure if we need to wake up userspace then, as applications shouldn't sleep on
>> VIDIOC_DQBUF or select() after VIDIOC_QBUF or VIDIOC_STREAMON returned an
>> error.
>>
> 
> Ok, but what do you mean by driver marking them as erroneous? By
> issuing vb2_buffer_done with *_ERROR as parameter? Also, you meant
> that vb2 should be waking userspace, right? I believe we should aim
> for a solution that would require the driver to do as little as
> possible and move everything to vb2.
> vb2_dqbuf will return EINVAL and poll()/select() should fail because
> they check for streaming state. As long as the disconnection event
> (e.g. failed qbuf) disables streaming flag in vb2, we should be ok.
> 
>>> So how do we recover from this disconnection event? What is the
>>> general idea? If buf_queue fails, can we restart from some point (i.e.
>>> reuse the buffers later) or do we have to clean up completely (i.e.
>>> deallocate, etc.)? Right now we are staying in an undefined state.
>>> If we cannot recover, we shouldn't be setting V4L2_BUF_FLAG_ERROR, but
>>> returning a stronger error instead and maybe clean up the rest, which
>>> is not waited for somehow. If we can recover on the other hand, we
>>> shouldn't be probably waking up all sleepers or at least giving them
>>> meaningful errors.
>>
>> I think a disconnection is pretty fatal. If the user unplugs the webcam,
>> there's not much that can be done anymore. Userspace needs to be woken up with
>> all buffers marked as erroneous, and the next QBUF call needs to return an
>> error without queuing any buffer. We need to define the expected behaviour in
>> the V4L2 spec, so that applications can rely on it and implement it properly.
>> I would also like to handle this inside videobuf2 if possible (something like
>> vb2_disconnect() ?) to ensure that all drivers behave correctly, but I'm not
>> sure if that will be possible without messing locking up.
>>
> 
> I definitely agree that videbuf2 should handle as much as possible and
> it shouldn't be left up to drivers. Although I'm not an expert in USB,
> shouldn't a disconnection event cause a removal of the device node?
> Could you explain how does that work for USB devices in general? If
> not, we may need a more general state in vb2, something like "device
> inoperable". Not only qbuf should fail then, but almost everything
> should. And memory should be freed. I feel there will be the locking
> problems as well.
> 
> I definitely agree that we need to add this to the V4L2 spec. So could
> we start from that point? Could we maybe start with a general flow and
> expected behavior for a disconnection event? I guess we both have some
> ideas in mind, but first I'd like to establish what will happen in
> linux driver/USB core when a device is disconnected. My understanding
> is that the driver is removed and module is unloaded, but how does
> that happen if we are in the middle of something? Could you give an
> example of what happens after a disconnect a camera? Then we could
> start designing a general approach, beginning with the API point of
> view.
> 
>>>>   }
>>>>   /**
>>>> @@ -890,8 +899,13 @@ int vb2_qbuf(struct vb2_queue *q, struct v4l2_buffer
>>>> *b) * If already streaming, give the buffer to driver for processing. *
>>>> If not, the buffer will be given to driver on next streamon. */
>>>> -       if (q->streaming)
>>>> -               __enqueue_in_driver(vb);
>>>> +       if (q->streaming) {
>>>> +               ret = __enqueue_in_driver(vb);
>>>> +               if (ret<  0) {
>>>> +                       dprintk(1, "qbuf: buffer queue failed\n");
>>>> +                       return ret;
>>>> +               }
>>>> +       }
>>>
>>> What errors can be allowed to be returned from driver here? EIO? Also,
>>> isn't returning an error here to userspace suggesting that qbuf didn't
>>> happen? But it actually did happen, we put the buffer onto vb2 list
>>> and set it state to QUEUED. From the point of view of vb2, the buffer
>>> is on its queue, but the userspace may not think so.
>>
>> You're right, that's an issue. The buffer shouldn't be queued at all.
>>
> 
> By the way, I'm beginning to think that the simplest way would maybe
> be adding a new flag to vb2_buffer_done... The problem however is of
> course that there might be a parallel qbuf going on... I really,
> really would prefer not putting locks around buf_queue back...
> 
>> Regarding error codes, I would return -ENXIO (No such device or address -
>> POSIX.1) to tell that the device has been disconnected. -ENODEV is misleading,
>> it's short description is "No such device", but it means that the device
>> doesn't support the requested operation.
>>

As buf_queue callback is called by vb2 only after start_streaming,
for a camera snapshot capture I needed to start a pipeline only from the
buf_queue handler level, i.e. subdev's video s_stream op was called from
within buf_queue. s_stream couldn't be done in the start_streaming handler
as at the time it is invoked there is always no buffer available in the
bridge H/W.
It's a consequence of how the vb2_streamon() is designed.

Before, I used to simply call s_stream in start_streaming, only deferring
the actual bridge DMA enable till a buf_queue call, thus letting first frames
in the stream to be lost. This of course cannot be done in case of single-frame
capture.

To make a long story short, it would be useful in my case to have the ability
to return error codes as per VIDIOC_STREAMON through buf_queue in the driver
(when the first buffer is queued).
At the moment mainly EPIPE comes to my mind. This error code has no meaning
in the API for QBUF though. Should the pipeline be started from buf_queue
the errors from buf_queue would be seen in userspace via VIDIOC_STREAMON
and/or VIDIOC_QBUF.

It should be also possible to signal any errors originating from the subdev
when s_stream is called on it, perhaps by EIO ?

What do you think ?

> 
> I have no preference here, I guess both should be ok.
> 
> To sum up, it'd be great if we could design a comprehensive solution
> please, starting on the abstract level, i.e. what happens during the
> disconnect and how we want to react from the point of view of the API.
> Could you describe what happens during a disconnect?
> 

--
Regards,
Sylwester Nawrocki
