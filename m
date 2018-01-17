Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud7.xs4all.net ([194.109.24.31]:49674 "EHLO
        lb3-smtp-cloud7.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1750806AbeAQIiD (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 17 Jan 2018 03:38:03 -0500
Subject: Re: [RFC PATCH 5/9] media: vb2: add support for requests
To: Alexandre Courbot <acourbot@chromium.org>
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Pawel Osciak <posciak@chromium.org>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Tomasz Figa <tfiga@chromium.org>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Gustavo Padovan <gustavo.padovan@collabora.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        linux-kernel@vger.kernel.org
References: <20171215075625.27028-1-acourbot@chromium.org>
 <20171215075625.27028-6-acourbot@chromium.org>
 <b23c9899-cc09-bc75-a29d-fc8185e0cc63@xs4all.nl>
 <CAPBb6MVsE0doJ5CeV3h-X5b=Nd-Fn3SOa_pcjDHBabA-H7KyMQ@mail.gmail.com>
 <08090730-a828-40f9-2cd6-0501655937af@xs4all.nl>
 <CAPBb6MWjtQZpqGQeiCHbta=O6j0Jd_THf4MJUuvUdZBuWHLo2Q@mail.gmail.com>
 <3da94f7b-fb60-585d-1b9a-912d7a5555dc@xs4all.nl>
 <CAPBb6MWD6zzXiFKYhug94yvDO5s2AtQKygx=yMxYzFmzQgB=Gg@mail.gmail.com>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <9892e9a6-83e0-6bb1-ee6e-910d79a2723f@xs4all.nl>
Date: Wed, 17 Jan 2018 09:37:55 +0100
MIME-Version: 1.0
In-Reply-To: <CAPBb6MWD6zzXiFKYhug94yvDO5s2AtQKygx=yMxYzFmzQgB=Gg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 01/17/18 09:01, Alexandre Courbot wrote:
> On Tue, Jan 16, 2018 at 7:37 PM, Hans Verkuil <hverkuil@xs4all.nl> wrote:
>> On 01/16/2018 10:39 AM, Alexandre Courbot wrote:
>>> On Mon, Jan 15, 2018 at 6:07 PM, Hans Verkuil <hverkuil@xs4all.nl> wrote:
>>>> On 01/15/2018 09:24 AM, Alexandre Courbot wrote:
>>>>> On Fri, Jan 12, 2018 at 7:49 PM, Hans Verkuil <hverkuil@xs4all.nl> wrote:
>>>>>> On 12/15/17 08:56, Alexandre Courbot wrote:
>>>>>>> Add throttling support for buffers when requests are in use on a given
>>>>>>> queue. Buffers associated to a request are kept into the vb2 queue until
>>>>>>> the request becomes active, at which point all the buffers are passed to
>>>>>>> the driver. The queue can also signal that is has processed all of a
>>>>>>> request's buffers.
>>>>>>>
>>>>>>> Also add support for the request parameter when handling the QBUF ioctl.
>>>>>>>
>>>>>>> Signed-off-by: Alexandre Courbot <acourbot@chromium.org>
>>>>>>> ---
>>>>>>>  drivers/media/v4l2-core/videobuf2-core.c | 59 ++++++++++++++++++++++++++++----
>>>>>>>  drivers/media/v4l2-core/videobuf2-v4l2.c | 29 +++++++++++++++-
>>>>>>>  include/media/videobuf2-core.h           | 25 +++++++++++++-
>>>>>>>  3 files changed, 104 insertions(+), 9 deletions(-)
>>>>>>>
>>>>>>> diff --git a/drivers/media/v4l2-core/videobuf2-core.c b/drivers/media/v4l2-core/videobuf2-core.c
>>>>>>> index cb115ba6a1d2..c01038b7962a 100644
>>>>>>> --- a/drivers/media/v4l2-core/videobuf2-core.c
>>>>>>> +++ b/drivers/media/v4l2-core/videobuf2-core.c
>>>>>>> @@ -898,6 +898,8 @@ void vb2_buffer_done(struct vb2_buffer *vb, enum vb2_buffer_state state)
>>>>>>>                   state != VB2_BUF_STATE_REQUEUEING))
>>>>>>>               state = VB2_BUF_STATE_ERROR;
>>>>>>>
>>>>>>> +     WARN_ON(vb->request != q->cur_req);
>>>>>>
>>>>>> What's the reason for this WARN_ON? It's not immediately obvious to me.
>>>>>
>>>>> This is a safeguard against driver bugs: a buffer should not complete
>>>>> unless it is part of the request being currently processed.
>>>>>
>>>>>>
>>>>>>> +
>>>>>>>  #ifdef CONFIG_VIDEO_ADV_DEBUG
>>>>>>>       /*
>>>>>>>        * Although this is not a callback, it still does have to balance
>>>>>>> @@ -920,6 +922,13 @@ void vb2_buffer_done(struct vb2_buffer *vb, enum vb2_buffer_state state)
>>>>>>>               /* Add the buffer to the done buffers list */
>>>>>>>               list_add_tail(&vb->done_entry, &q->done_list);
>>>>>>>               vb->state = state;
>>>>>>> +
>>>>>>> +             if (q->cur_req) {
>>>>>>> +                     WARN_ON(q->req_buf_cnt < 1);
>>>>>>> +
>>>>>>> +                     if (--q->req_buf_cnt == 0)
>>>>>>> +                             q->cur_req = NULL;
>>>>>>> +             }
>>>>>>>       }
>>>>>>>       atomic_dec(&q->owned_by_drv_count);
>>>>>>>       spin_unlock_irqrestore(&q->done_lock, flags);
>>>>>>> @@ -1298,6 +1307,16 @@ int vb2_core_prepare_buf(struct vb2_queue *q, unsigned int index, void *pb)
>>>>>>>  }
>>>>>>>  EXPORT_SYMBOL_GPL(vb2_core_prepare_buf);
>>>>>>>
>>>>>>> +static void vb2_queue_enqueue_current_buffers(struct vb2_queue *q)
>>>>>>> +{
>>>>>>> +     struct vb2_buffer *vb;
>>>>>>> +
>>>>>>> +     list_for_each_entry(vb, &q->queued_list, queued_entry) {
>>>>>>> +             if (vb->request == q->cur_req)
>>>>>>> +                     __enqueue_in_driver(vb);
>>>>>>> +     }
>>>>>>> +}
>>>>>>
>>>>>> I think this will clash big time with the v4l2 fence patch series...
>>>>>
>>>>> Indeed, but on the other hand I was not a big fan of going through the
>>>>> whole list. :) So I welcome the extra throttling introduced by the
>>>>> fence series.
>>>>
>>>> There is only throttling if fences are used by userspace. Otherwise there
>>>> is no change.
>>>>
>>>>>
>>>>>>
>>>>>>> +
>>>>>>>  /**
>>>>>>>   * vb2_start_streaming() - Attempt to start streaming.
>>>>>>>   * @q:               videobuf2 queue
>>>>>>> @@ -1318,8 +1337,7 @@ static int vb2_start_streaming(struct vb2_queue *q)
>>>>>>>        * If any buffers were queued before streamon,
>>>>>>>        * we can now pass them to driver for processing.
>>>>>>>        */
>>>>>>> -     list_for_each_entry(vb, &q->queued_list, queued_entry)
>>>>>>> -             __enqueue_in_driver(vb);
>>>>>>> +     vb2_queue_enqueue_current_buffers(q);
>>>>>>>
>>>>>>>       /* Tell the driver to start streaming */
>>>>>>>       q->start_streaming_called = 1;
>>>>>>> @@ -1361,7 +1379,8 @@ static int vb2_start_streaming(struct vb2_queue *q)
>>>>>>>       return ret;
>>>>>>>  }
>>>>>>>
>>>>>>> -int vb2_core_qbuf(struct vb2_queue *q, unsigned int index, void *pb)
>>>>>>> +int vb2_core_qbuf(struct vb2_queue *q, unsigned int index,
>>>>>>> +               struct media_request *req, void *pb)
>>>>>>>  {
>>>>>>>       struct vb2_buffer *vb;
>>>>>>>       int ret;
>>>>>>> @@ -1392,6 +1411,7 @@ int vb2_core_qbuf(struct vb2_queue *q, unsigned int index, void *pb)
>>>>>>>       q->queued_count++;
>>>>>>>       q->waiting_for_buffers = false;
>>>>>>>       vb->state = VB2_BUF_STATE_QUEUED;
>>>>>>> +     vb->request = req;
>>>>>>>
>>>>>>>       if (pb)
>>>>>>>               call_void_bufop(q, copy_timestamp, vb, pb);
>>>>>>> @@ -1401,8 +1421,11 @@ int vb2_core_qbuf(struct vb2_queue *q, unsigned int index, void *pb)
>>>>>>>       /*
>>>>>>>        * If already streaming, give the buffer to driver for processing.
>>>>>>>        * If not, the buffer will be given to driver on next streamon.
>>>>>>> +      *
>>>>>>> +      * If using the request API, the buffer will be given to the driver
>>>>>>> +      * when the request becomes active.
>>>>>>>        */
>>>>>>> -     if (q->start_streaming_called)
>>>>>>> +     if (q->start_streaming_called && !req)
>>>>>>>               __enqueue_in_driver(vb);
>>>>>>>
>>>>>>>       /* Fill buffer information for the userspace */
>>>>>>> @@ -1427,6 +1450,28 @@ int vb2_core_qbuf(struct vb2_queue *q, unsigned int index, void *pb)
>>>>>>>  }
>>>>>>>  EXPORT_SYMBOL_GPL(vb2_core_qbuf);
>>>>>>>
>>>>>>> +void vb2_queue_start_request(struct vb2_queue *q, struct media_request *req)
>>>>>>> +{
>>>>>>> +     struct vb2_buffer *vb;
>>>>>>> +
>>>>>>> +     q->req_buf_cnt = 0;
>>>>>>> +     list_for_each_entry(vb, &q->queued_list, queued_entry) {
>>>>>>> +             if (vb->request == req)
>>>>>>> +                     ++q->req_buf_cnt;
>>>>>>> +     }
>>>>>>> +
>>>>>>> +     /* only consider the request if we actually have buffers for it */
>>>>>>> +     if (q->req_buf_cnt == 0)
>>>>>>> +             return;
>>>>>>> +
>>>>>>> +     q->cur_req = req;
>>>>>>> +
>>>>>>> +     /* If not streaming yet, we will enqueue the buffers later */
>>>>>>> +     if (q->start_streaming_called)
>>>>>>> +             vb2_queue_enqueue_current_buffers(q);
>>>>>>
>>>>>> If I understand all this correctly, then you are queuing one request at a
>>>>>> time to the vb2_queue. I.e. all the buffers queued to the driver belong to
>>>>>> the same request (q->cur_req).
>>>>>
>>>>> That is correct.
>>>>>
>>>>>> But that might work for codecs, but not
>>>>>> for camera drivers: you will typically have multiple requests queued up in
>>>>>> the driver.
>>>>>
>>>>> Aren't requests supposed to be performed sequentially, even in the
>>>>> camera case? Passing a buffer to the driver means that we allow it to
>>>>> process it using its current settings ; if another request is
>>>>> currently active, wouldn't that become an issue?
>>>>
>>>> Drivers often need multiple buffers queued before they can start the DMA
>>>> engine (usually at least two buffers have to be queued, just do a
>>>> git grep min_buffers_needed drivers/media).
>>>>
>>>> In addition, sensors often have to be programmed one or two frames earlier
>>>> for a new setting to take effect for the required frame.
>>>>
>>>> In other words: drivers need to be able to look ahead and vb2 should just
>>>> queue buffers/requests as soon as they are ready.
>>>
>>> Cannot drivers simply peek into their vb2_queue if they need to look
>>> ahead? My main concern here is that I would like to avoid having to
>>> make individual drivers aware of requests as much as possible. With
>>> the current design, drivers just need to care about unconditionally
>>> processing all the buffers that are passed to them by vb2, and not
>>> keeping it that way would complicate things.
>>
>> I'm not sure what the problem is. Once buffers are ready (i.e. not waiting
>> for fences or unfinished requests) then they should be queued to the driver.
>> At that time the driver can look at whatever associated request data the
>> newly queued buffer has and program the hardware.
> 
> I see what you mean and indeed if we want to maintain proper buffer
> ownership that would be the way to go.
> 
> What I wanted to avoid (but maybe this is unavoidable?) is having to
> make each individual driver aware of requests. I.e. the upper
> framework would take care of scheduling the buffers and of setting the
> controls when the time to process the request has come. While this
> would work well for simple hardware that can only process buffers one
> at a time, it would be sub-optimal for e.g. more sophisticated codecs
> with their own buffer queues and shadow registers.

You really can't do this. Only for codecs would this be feasible, not
other drivers.

This also means that we need a way to signal to userspace that a device
supports the request API since drivers indeed need to be modified for
this to work. But most capture drivers don't need the request API. The
current way of working is perfectly fine for them. It's just codecs and
complex camera drivers that need this.

> However, it is not clear to me how we can make the different IPs of a
> complex pipeline, all controlled by their own driver, cooperate and
> synchronize in order to properly set the pipeline topography and
> process the buffers only once that topography is set. Wouldn't that
> mean extra back-and-forth between the drivers and the request
> framework?

That would have to be coordinated by the top-level driver (usually
the driver that also creates the media device). But in any case, this
is out-of-scope of the request API since this is likely to be very
hardware dependent.

Regards,

	Hans
