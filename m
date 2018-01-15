Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-it0-f68.google.com ([209.85.214.68]:40892 "EHLO
        mail-it0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751965AbeAOIY6 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 15 Jan 2018 03:24:58 -0500
Received: by mail-it0-f68.google.com with SMTP id 196so10904iti.5
        for <linux-media@vger.kernel.org>; Mon, 15 Jan 2018 00:24:58 -0800 (PST)
Received: from mail-io0-f174.google.com (mail-io0-f174.google.com. [209.85.223.174])
        by smtp.gmail.com with ESMTPSA id 201sm8244712ioe.78.2018.01.15.00.24.56
        for <linux-media@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 15 Jan 2018 00:24:56 -0800 (PST)
Received: by mail-io0-f174.google.com with SMTP id 25so12238089ioj.9
        for <linux-media@vger.kernel.org>; Mon, 15 Jan 2018 00:24:56 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <b23c9899-cc09-bc75-a29d-fc8185e0cc63@xs4all.nl>
References: <20171215075625.27028-1-acourbot@chromium.org> <20171215075625.27028-6-acourbot@chromium.org>
 <b23c9899-cc09-bc75-a29d-fc8185e0cc63@xs4all.nl>
From: Alexandre Courbot <acourbot@chromium.org>
Date: Mon, 15 Jan 2018 17:24:35 +0900
Message-ID: <CAPBb6MVsE0doJ5CeV3h-X5b=Nd-Fn3SOa_pcjDHBabA-H7KyMQ@mail.gmail.com>
Subject: Re: [RFC PATCH 5/9] media: vb2: add support for requests
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Pawel Osciak <posciak@chromium.org>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Tomasz Figa <tfiga@chromium.org>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Gustavo Padovan <gustavo.padovan@collabora.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, Jan 12, 2018 at 7:49 PM, Hans Verkuil <hverkuil@xs4all.nl> wrote:
> On 12/15/17 08:56, Alexandre Courbot wrote:
>> Add throttling support for buffers when requests are in use on a given
>> queue. Buffers associated to a request are kept into the vb2 queue until
>> the request becomes active, at which point all the buffers are passed to
>> the driver. The queue can also signal that is has processed all of a
>> request's buffers.
>>
>> Also add support for the request parameter when handling the QBUF ioctl.
>>
>> Signed-off-by: Alexandre Courbot <acourbot@chromium.org>
>> ---
>>  drivers/media/v4l2-core/videobuf2-core.c | 59 ++++++++++++++++++++++++++++----
>>  drivers/media/v4l2-core/videobuf2-v4l2.c | 29 +++++++++++++++-
>>  include/media/videobuf2-core.h           | 25 +++++++++++++-
>>  3 files changed, 104 insertions(+), 9 deletions(-)
>>
>> diff --git a/drivers/media/v4l2-core/videobuf2-core.c b/drivers/media/v4l2-core/videobuf2-core.c
>> index cb115ba6a1d2..c01038b7962a 100644
>> --- a/drivers/media/v4l2-core/videobuf2-core.c
>> +++ b/drivers/media/v4l2-core/videobuf2-core.c
>> @@ -898,6 +898,8 @@ void vb2_buffer_done(struct vb2_buffer *vb, enum vb2_buffer_state state)
>>                   state != VB2_BUF_STATE_REQUEUEING))
>>               state = VB2_BUF_STATE_ERROR;
>>
>> +     WARN_ON(vb->request != q->cur_req);
>
> What's the reason for this WARN_ON? It's not immediately obvious to me.

This is a safeguard against driver bugs: a buffer should not complete
unless it is part of the request being currently processed.

>
>> +
>>  #ifdef CONFIG_VIDEO_ADV_DEBUG
>>       /*
>>        * Although this is not a callback, it still does have to balance
>> @@ -920,6 +922,13 @@ void vb2_buffer_done(struct vb2_buffer *vb, enum vb2_buffer_state state)
>>               /* Add the buffer to the done buffers list */
>>               list_add_tail(&vb->done_entry, &q->done_list);
>>               vb->state = state;
>> +
>> +             if (q->cur_req) {
>> +                     WARN_ON(q->req_buf_cnt < 1);
>> +
>> +                     if (--q->req_buf_cnt == 0)
>> +                             q->cur_req = NULL;
>> +             }
>>       }
>>       atomic_dec(&q->owned_by_drv_count);
>>       spin_unlock_irqrestore(&q->done_lock, flags);
>> @@ -1298,6 +1307,16 @@ int vb2_core_prepare_buf(struct vb2_queue *q, unsigned int index, void *pb)
>>  }
>>  EXPORT_SYMBOL_GPL(vb2_core_prepare_buf);
>>
>> +static void vb2_queue_enqueue_current_buffers(struct vb2_queue *q)
>> +{
>> +     struct vb2_buffer *vb;
>> +
>> +     list_for_each_entry(vb, &q->queued_list, queued_entry) {
>> +             if (vb->request == q->cur_req)
>> +                     __enqueue_in_driver(vb);
>> +     }
>> +}
>
> I think this will clash big time with the v4l2 fence patch series...

Indeed, but on the other hand I was not a big fan of going through the
whole list. :) So I welcome the extra throttling introduced by the
fence series.

>
>> +
>>  /**
>>   * vb2_start_streaming() - Attempt to start streaming.
>>   * @q:               videobuf2 queue
>> @@ -1318,8 +1337,7 @@ static int vb2_start_streaming(struct vb2_queue *q)
>>        * If any buffers were queued before streamon,
>>        * we can now pass them to driver for processing.
>>        */
>> -     list_for_each_entry(vb, &q->queued_list, queued_entry)
>> -             __enqueue_in_driver(vb);
>> +     vb2_queue_enqueue_current_buffers(q);
>>
>>       /* Tell the driver to start streaming */
>>       q->start_streaming_called = 1;
>> @@ -1361,7 +1379,8 @@ static int vb2_start_streaming(struct vb2_queue *q)
>>       return ret;
>>  }
>>
>> -int vb2_core_qbuf(struct vb2_queue *q, unsigned int index, void *pb)
>> +int vb2_core_qbuf(struct vb2_queue *q, unsigned int index,
>> +               struct media_request *req, void *pb)
>>  {
>>       struct vb2_buffer *vb;
>>       int ret;
>> @@ -1392,6 +1411,7 @@ int vb2_core_qbuf(struct vb2_queue *q, unsigned int index, void *pb)
>>       q->queued_count++;
>>       q->waiting_for_buffers = false;
>>       vb->state = VB2_BUF_STATE_QUEUED;
>> +     vb->request = req;
>>
>>       if (pb)
>>               call_void_bufop(q, copy_timestamp, vb, pb);
>> @@ -1401,8 +1421,11 @@ int vb2_core_qbuf(struct vb2_queue *q, unsigned int index, void *pb)
>>       /*
>>        * If already streaming, give the buffer to driver for processing.
>>        * If not, the buffer will be given to driver on next streamon.
>> +      *
>> +      * If using the request API, the buffer will be given to the driver
>> +      * when the request becomes active.
>>        */
>> -     if (q->start_streaming_called)
>> +     if (q->start_streaming_called && !req)
>>               __enqueue_in_driver(vb);
>>
>>       /* Fill buffer information for the userspace */
>> @@ -1427,6 +1450,28 @@ int vb2_core_qbuf(struct vb2_queue *q, unsigned int index, void *pb)
>>  }
>>  EXPORT_SYMBOL_GPL(vb2_core_qbuf);
>>
>> +void vb2_queue_start_request(struct vb2_queue *q, struct media_request *req)
>> +{
>> +     struct vb2_buffer *vb;
>> +
>> +     q->req_buf_cnt = 0;
>> +     list_for_each_entry(vb, &q->queued_list, queued_entry) {
>> +             if (vb->request == req)
>> +                     ++q->req_buf_cnt;
>> +     }
>> +
>> +     /* only consider the request if we actually have buffers for it */
>> +     if (q->req_buf_cnt == 0)
>> +             return;
>> +
>> +     q->cur_req = req;
>> +
>> +     /* If not streaming yet, we will enqueue the buffers later */
>> +     if (q->start_streaming_called)
>> +             vb2_queue_enqueue_current_buffers(q);
>
> If I understand all this correctly, then you are queuing one request at a
> time to the vb2_queue. I.e. all the buffers queued to the driver belong to
> the same request (q->cur_req).

That is correct.

> But that might work for codecs, but not
> for camera drivers: you will typically have multiple requests queued up in
> the driver.

Aren't requests supposed to be performed sequentially, even in the
camera case? Passing a buffer to the driver means that we allow it to
process it using its current settings ; if another request is
currently active, wouldn't that become an issue?

>
> In any case, I don't think the req_buf_cnt and cur_req fields belong in
> vb2_queue.
>
> Another weird thing here is that it appears that you allow for multiple
> buffers for the same device in the same request. I'm not sure that is
> useful. For one, it will postpone the completion of the request until
> all buffers are dequeued.

s/dequeued/completed. A request is marked as completed as soon as all
its buffers are marked as done, and can be polled before its buffers
are dequeued by user-space.

Do you suggest that we enforce a "one buffer per queue per request"
rule? I cannot thing of any case where this would be a hard limiting
factor (and it would certainly simplify the code), on the other hand
it may slow things down a bit in the case where we want to e.g. take
several shots in fast succession with the same parameters. But I have
no evidence that the extra lag would be noticeable.

>
>> +}
>> +EXPORT_SYMBOL_GPL(vb2_queue_start_request);
>> +
>>  /**
>>   * __vb2_wait_for_done_vb() - wait for a buffer to become available
>>   * for dequeuing
>> @@ -2242,7 +2287,7 @@ static int __vb2_init_fileio(struct vb2_queue *q, int read)
>>                * Queue all buffers.
>>                */
>>               for (i = 0; i < q->num_buffers; i++) {
>> -                     ret = vb2_core_qbuf(q, i, NULL);
>> +                     ret = vb2_core_qbuf(q, i, NULL, NULL);
>>                       if (ret)
>>                               goto err_reqbufs;
>>                       fileio->bufs[i].queued = 1;
>> @@ -2421,7 +2466,7 @@ static size_t __vb2_perform_fileio(struct vb2_queue *q, char __user *data, size_
>>
>>               if (copy_timestamp)
>>                       b->timestamp = ktime_get_ns();
>> -             ret = vb2_core_qbuf(q, index, NULL);
>> +             ret = vb2_core_qbuf(q, index, NULL, NULL);
>>               dprintk(5, "vb2_dbuf result: %d\n", ret);
>>               if (ret)
>>                       return ret;
>> @@ -2524,7 +2569,7 @@ static int vb2_thread(void *data)
>>               if (copy_timestamp)
>>                       vb->timestamp = ktime_get_ns();;
>>               if (!threadio->stop)
>> -                     ret = vb2_core_qbuf(q, vb->index, NULL);
>> +                     ret = vb2_core_qbuf(q, vb->index, NULL, NULL);
>>               call_void_qop(q, wait_prepare, q);
>>               if (ret || threadio->stop)
>>                       break;
>> diff --git a/drivers/media/v4l2-core/videobuf2-v4l2.c b/drivers/media/v4l2-core/videobuf2-v4l2.c
>> index bde7b8a3a303..55b16b4db9a6 100644
>> --- a/drivers/media/v4l2-core/videobuf2-v4l2.c
>> +++ b/drivers/media/v4l2-core/videobuf2-v4l2.c
>> @@ -28,6 +28,7 @@
>>  #include <media/v4l2-fh.h>
>>  #include <media/v4l2-event.h>
>>  #include <media/v4l2-common.h>
>> +#include <media/media-request.h>
>>
>>  #include <media/videobuf2-v4l2.h>
>>
>> @@ -561,6 +562,7 @@ EXPORT_SYMBOL_GPL(vb2_create_bufs);
>>
>>  int vb2_qbuf(struct vb2_queue *q, struct v4l2_buffer *b)
>>  {
>> +     struct media_request *req = NULL;
>>       int ret;
>>
>>       if (vb2_fileio_is_active(q)) {
>> @@ -568,8 +570,33 @@ int vb2_qbuf(struct vb2_queue *q, struct v4l2_buffer *b)
>>               return -EBUSY;
>>       }
>>
>> +     /*
>> +      * The caller should have validated that the request is valid,
>> +      * so we just need to look it up without further checking
>> +      */
>> +     if (b->request > 0) {
>> +             req = media_request_get_from_fd(b->request);
>> +             if (!req)
>> +                     return -EINVAL;
>> +             media_request_queue_lock(req->queue);
>> +
>> +             if (req->state != MEDIA_REQUEST_STATE_IDLE) {
>> +                     ret = -EINVAL;
>> +                     goto done;
>> +             }
>> +     }
>> +
>>       ret = vb2_queue_or_prepare_buf(q, b, "qbuf");
>> -     return ret ? ret : vb2_core_qbuf(q, b->index, b);
>> +     if (!ret)
>> +             ret = vb2_core_qbuf(q, b->index, req, b);
>> +
>> +done:
>> +     if (req) {
>> +             media_request_queue_unlock(req->queue);
>> +             media_request_put(req);
>> +     }
>> +
>> +     return ret;
>
> I'm trying to remember what we decided w.r.t. mixing buffers associated with
> a request and buffers without a request. I can't see anything in the meeting
> notes. I have a faint memory that we decided to not allow that (i.e. once
> you start using requests, then all buffers should be associated with a
> request). Does anyone remember?

My recollection is that we do not support that, on the other hand is
there a case where allowing it would break things? Especially if we
decide to limit each request to one buffer per queue.

>
>>  }
>>  EXPORT_SYMBOL_GPL(vb2_qbuf);
>>
>> diff --git a/include/media/videobuf2-core.h b/include/media/videobuf2-core.h
>> index ef9b64398c8c..7d5e8e53e256 100644
>> --- a/include/media/videobuf2-core.h
>> +++ b/include/media/videobuf2-core.h
>> @@ -44,6 +44,8 @@ enum vb2_memory {
>>  struct vb2_fileio_data;
>>  struct vb2_threadio_data;
>>
>> +struct media_request;
>> +
>>  /**
>>   * struct vb2_mem_ops - memory handling/memory allocator operations
>>   * @alloc:   allocate video memory and, optionally, allocator private data,
>> @@ -237,6 +239,7 @@ struct vb2_queue;
>>   *                   on an internal driver queue
>>   * @planes:          private per-plane information; do not change
>>   * @timestamp:               frame timestamp in ns
>> + * @request:         pointer this buffer's request, if any
>>   */
>>  struct vb2_buffer {
>>       struct vb2_queue        *vb2_queue;
>> @@ -246,6 +249,7 @@ struct vb2_buffer {
>>       unsigned int            num_planes;
>>       struct vb2_plane        planes[VB2_MAX_PLANES];
>>       u64                     timestamp;
>> +     struct media_request    *request;
>>
>>       /* private: internal use only
>>        *
>> @@ -500,6 +504,8 @@ struct vb2_buf_ops {
>>   *           when a buffer with the V4L2_BUF_FLAG_LAST is dequeued.
>>   * @fileio:  file io emulator internal data, used only if emulator is active
>>   * @threadio:        thread io internal data, used only if thread is active
>> + * @cur_req: request currently being processed by this queue
>> + * @req_buf_cnt:number of buffers still to process in the current request
>>   */
>>  struct vb2_queue {
>>       unsigned int                    type;
>> @@ -554,6 +560,9 @@ struct vb2_queue {
>>       struct vb2_fileio_data          *fileio;
>>       struct vb2_threadio_data        *threadio;
>>
>> +     struct media_request            *cur_req;
>> +     u32                             req_buf_cnt;
>> +
>
> As mentioned above, this is very dubious.

This wouldn't be needed if I understood your intent properly about
limiting requests to one buffer per queue. If not, where would you
suggest to move this?
