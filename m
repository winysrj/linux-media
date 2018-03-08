Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-io0-f194.google.com ([209.85.223.194]:40285 "EHLO
        mail-io0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755107AbeCHNvA (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Thu, 8 Mar 2018 08:51:00 -0500
Received: by mail-io0-f194.google.com with SMTP id v6so7107619iog.7
        for <linux-media@vger.kernel.org>; Thu, 08 Mar 2018 05:51:00 -0800 (PST)
Received: from mail-it0-f53.google.com (mail-it0-f53.google.com. [209.85.214.53])
        by smtp.gmail.com with ESMTPSA id 35sm14498778ios.39.2018.03.08.05.50.57
        for <linux-media@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 08 Mar 2018 05:50:58 -0800 (PST)
Received: by mail-it0-f53.google.com with SMTP id c11so7689572ith.4
        for <linux-media@vger.kernel.org>; Thu, 08 Mar 2018 05:50:57 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1520441424.1092.25.camel@bootlin.com>
References: <20180220044425.169493-14-acourbot@chromium.org> <1520441424.1092.25.camel@bootlin.com>
From: Alexandre Courbot <acourbot@chromium.org>
Date: Thu, 8 Mar 2018 22:50:36 +0900
Message-ID: <CAPBb6MWBezCNbApxvjkeuzrkWOd4Zq4_edsLokc=G+rKEWvmoQ@mail.gmail.com>
Subject: Re: [RFCv4,13/21] media: videobuf2-v4l2: support for requests
To: Paul Kocialkowski <paul.kocialkowski@bootlin.com>
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Pawel Osciak <posciak@chromium.org>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Tomasz Figa <tfiga@chromium.org>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Gustavo Padovan <gustavo.padovan@collabora.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Maxime Ripard <maxime.ripard@bootlin.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, Mar 8, 2018 at 1:50 AM, Paul Kocialkowski
<paul.kocialkowski@bootlin.com> wrote:
> Hi,
>
> On Tue, 2018-02-20 at 13:44 +0900, Alexandre Courbot wrote:
>> Add a new vb2_qbuf_request() (a request-aware version of vb2_qbuf())
>> that request-aware drivers can call to queue a buffer into a request
>> instead of directly into the vb2 queue if relevent.
>>
>> This function expects that drivers invoking it are using instances of
>> v4l2_request_entity and v4l2_request_entity_data to describe their
>> entity and entity data respectively.
>>
>> Also add the vb2_request_submit() helper function which drivers can
>> invoke in order to queue all the buffers previously queued into a
>> request into the regular vb2 queue.
>
> See a comment/proposal below about an issue I encountered when using
> multi-planar formats.
>
>> Signed-off-by: Alexandre Courbot <acourbot@chromium.org>
>> ---
>>  .../media/common/videobuf2/videobuf2-v4l2.c   | 129
>> +++++++++++++++++-
>>  include/media/videobuf2-v4l2.h                |  59 ++++++++
>>  2 files changed, 187 insertions(+), 1 deletion(-)
>>
>> diff --git a/drivers/media/common/videobuf2/videobuf2-v4l2.c
>> b/drivers/media/common/videobuf2/videobuf2-v4l2.c
>> index 6d4d184aa68e..0627c3339572 100644
>> --- a/drivers/media/common/videobuf2/videobuf2-v4l2.c
>> +++ b/drivers/media/common/videobuf2/videobuf2-v4l2.c
>
> [...]
>
>> +#if IS_ENABLED(CONFIG_MEDIA_REQUEST_API)
>> +int vb2_qbuf_request(struct vb2_queue *q, struct v4l2_buffer *b,
>> +                  struct media_request_entity *entity)
>> +{
>> +     struct v4l2_request_entity_data *data;
>> +     struct v4l2_vb2_request_buffer *qb;
>> +     struct media_request *req;
>> +     struct vb2_buffer *vb;
>> +     int ret = 0;
>> +
>> +     if (b->request_fd <= 0)
>> +             return vb2_qbuf(q, b);
>> +
>> +     if (!q->allow_requests)
>> +             return -EINVAL;
>> +
>> +     req = media_request_get_from_fd(b->request_fd);
>> +     if (!req)
>> +             return -EINVAL;
>> +
>> +     data = to_v4l2_entity_data(media_request_get_entity_data(req,
>> entity));
>> +     if (IS_ERR(data)) {
>> +             ret = PTR_ERR(data);
>> +             goto out;
>> +     }
>> +
>> +     mutex_lock(&req->lock);
>> +
>> +     if (req->state != MEDIA_REQUEST_STATE_IDLE) {
>> +             ret = -EINVAL;
>> +             goto out;
>> +     }
>> +
>> +     ret = vb2_queue_or_prepare_buf(q, b, "qbuf");
>> +     if (ret)
>> +             goto out;
>> +
>> +     vb = q->bufs[b->index];
>> +     switch (vb->state) {
>> +     case VB2_BUF_STATE_DEQUEUED:
>> +             break;
>> +     case VB2_BUF_STATE_PREPARED:
>> +             break;
>> +     case VB2_BUF_STATE_PREPARING:
>> +             dprintk(1, "buffer still being prepared\n");
>> +             ret = -EINVAL;
>> +             goto out;
>> +     default:
>> +             dprintk(1, "invalid buffer state %d\n", vb->state);
>> +             ret = -EINVAL;
>> +             goto out;
>> +     }
>> +
>> +     /* do we already have a buffer for this request in the queue?
>> */
>> +     list_for_each_entry(qb, &data->queued_buffers, node) {
>> +             if (qb->queue == q) {
>> +                     ret = -EBUSY;
>> +                     goto out;
>> +             }
>> +     }
>> +
>> +     qb = kzalloc(sizeof(*qb), GFP_KERNEL);
>> +     if (!qb) {
>> +             ret = -ENOMEM;
>> +             goto out;
>> +     }
>> +
>> +     /*
>> +      * TODO should be prepare the buffer here if needed, to
>> report errors
>> +      * early?
>> +      */
>> +     qb->pre_req_state = vb->state;
>> +     qb->queue = q;
>> +     memcpy(&qb->v4l2_buf, b, sizeof(*b));
>
> I am getting data corruption on qb->v4l2_buf.m.planes from this when
> using planar buffers, only after exiting the ioctl handler (i.e. when
> accessing this buffer later from the queue).
>
> I initially thought this was because the planes pointer was copied as-is
> from userspace, but Maxime Ripard suggested that this would have
> automatically triggered a visible fault in the kernel.
>
> Thus, my best guess is that the data is properly copied from userspace
> but freed when leaving the ioctl handler, which doesn't work our with
> the request API.
>
> A dirty fix that I came up with consists in re-allocating the planes
> buffer here and copying its contents from "b", so that it can live
> beyond the ioctl call.
>
> I am not too sure whether this should be fixed here or in the part of
> the v4l2 common code that frees this data. What do you think?

Oh, nice catch. Copying plane information indeed requires more work
than a dumb memcpy(). I suppose this should be handled here, but let
me come back to this after a good night of sleep. :)

Thanks! I will try to fix this tomorrow and push a temporary version
somewhere so you can move forward.

Alex.
