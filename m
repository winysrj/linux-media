Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-it0-f68.google.com ([209.85.214.68]:55968 "EHLO
        mail-it0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751709AbeBUGCK (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 21 Feb 2018 01:02:10 -0500
Received: by mail-it0-f68.google.com with SMTP id n7so937293ita.5
        for <linux-media@vger.kernel.org>; Tue, 20 Feb 2018 22:02:09 -0800 (PST)
Received: from mail-it0-f52.google.com (mail-it0-f52.google.com. [209.85.214.52])
        by smtp.gmail.com with ESMTPSA id e94sm2417286itd.21.2018.02.20.22.02.07
        for <linux-media@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 20 Feb 2018 22:02:08 -0800 (PST)
Received: by mail-it0-f52.google.com with SMTP id l129so965247ita.3
        for <linux-media@vger.kernel.org>; Tue, 20 Feb 2018 22:02:07 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <86ad101f-f400-c7fd-2aa5-4dc618973f3d@xs4all.nl>
References: <20180220044425.169493-1-acourbot@chromium.org>
 <20180220044425.169493-14-acourbot@chromium.org> <86ad101f-f400-c7fd-2aa5-4dc618973f3d@xs4all.nl>
From: Alexandre Courbot <acourbot@chromium.org>
Date: Wed, 21 Feb 2018 15:01:46 +0900
Message-ID: <CAPBb6MVH0ezPye53MOL1fwuU5SEAMamG-S0jkJoF2Kp-LVok+A@mail.gmail.com>
Subject: Re: [RFCv4 13/21] media: videobuf2-v4l2: support for requests
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Pawel Osciak <posciak@chromium.org>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Tomasz Figa <tfiga@chromium.org>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Gustavo Padovan <gustavo.padovan@collabora.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, Feb 21, 2018 at 1:18 AM, Hans Verkuil <hverkuil@xs4all.nl> wrote:
> On 02/20/2018 05:44 AM, Alexandre Courbot wrote:
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
>>
>> Signed-off-by: Alexandre Courbot <acourbot@chromium.org>
>> ---
>>  .../media/common/videobuf2/videobuf2-v4l2.c   | 129 +++++++++++++++++-
>>  include/media/videobuf2-v4l2.h                |  59 ++++++++
>>  2 files changed, 187 insertions(+), 1 deletion(-)
>>
>
> <snip>
>
>> @@ -776,10 +899,14 @@ EXPORT_SYMBOL_GPL(vb2_ioctl_querybuf);
>>  int vb2_ioctl_qbuf(struct file *file, void *priv, struct v4l2_buffer *p)
>>  {
>>       struct video_device *vdev = video_devdata(file);
>> +     struct v4l2_fh *fh = NULL;
>> +
>> +     if (test_bit(V4L2_FL_USES_V4L2_FH, &vdev->flags))
>> +             fh = file->private_data;
>
> No need for this. All drivers using vb2 will also use v4l2_fh.

Fixed.

>
>>
>>       if (vb2_queue_is_busy(vdev, file))
>>               return -EBUSY;
>> -     return vb2_qbuf(vdev->queue, p);
>> +     return vb2_qbuf_request(vdev->queue, p, fh ? fh->entity : NULL);
>>  }
>>  EXPORT_SYMBOL_GPL(vb2_ioctl_qbuf);
>>
>> diff --git a/include/media/videobuf2-v4l2.h b/include/media/videobuf2-v4l2.h
>> index 3d5e2d739f05..d4dfa266a0da 100644
>> --- a/include/media/videobuf2-v4l2.h
>> +++ b/include/media/videobuf2-v4l2.h
>> @@ -23,6 +23,12 @@
>>  #error VB2_MAX_PLANES != VIDEO_MAX_PLANES
>>  #endif
>>
>> +struct media_entity;
>> +struct v4l2_fh;
>> +struct media_request;
>> +struct media_request_entity;
>> +struct v4l2_request_entity_data;
>> +
>>  /**
>>   * struct vb2_v4l2_buffer - video buffer information for v4l2.
>>   *
>> @@ -116,6 +122,59 @@ int vb2_prepare_buf(struct vb2_queue *q, struct v4l2_buffer *b);
>>   */
>>  int vb2_qbuf(struct vb2_queue *q, struct v4l2_buffer *b);
>>
>> +#if IS_ENABLED(CONFIG_MEDIA_REQUEST_API)
>> +
>> +/**
>> + * vb2_qbuf_request() - Queue a buffer, with request support
>> + * @q:               pointer to &struct vb2_queue with videobuf2 queue.
>> + * @b:               buffer structure passed from userspace to
>> + *           &v4l2_ioctl_ops->vidioc_qbuf handler in driver
>> + * @entity:  request entity to queue for if requests are used.
>> + *
>> + * Should be called from &v4l2_ioctl_ops->vidioc_qbuf handler of a driver.
>> + *
>> + * If requests are not in use, calling this is equivalent to calling vb2_qbuf().
>> + *
>> + * If the request_fd member of b is set, then the buffer represented by b is
>> + * queued in the request instead of the vb2 queue. The buffer will be passed
>> + * to the vb2 queue when the request is submitted.
>
> I would definitely also prepare the buffer at this time. That way you'll see any
> errors relating to the prepare early on.

I was wondering about that, so glad to have your opinion on this. Will
make sure buffers are prepared before queuing them to a request.

>
>> + *
>> + * The return values from this function are intended to be directly returned
>> + * from &v4l2_ioctl_ops->vidioc_qbuf handler in driver.
>> + */
>> +int vb2_qbuf_request(struct vb2_queue *q, struct v4l2_buffer *b,
>> +                  struct media_request_entity *entity);
>> +
>> +/**
>> + * vb2_request_submit() - Queue all the buffers in a v4l2 request.
>> + * @data:    request entity data to queue buffers of
>> + *
>> + * This function should be called from the media_request_entity_ops::submit
>> + * hook for instances of media_request_v4l2_entity_data. It will immediately
>> + * queue all the request-bound buffers to their respective vb2 queues.
>> + *
>> + * Errors from vb2_core_qbuf() are returned if something happened. Also, since
>> + * v4l2 request entities require at least one buffer for the request to trigger,
>> + * this function will return -EINVAL if no buffer have been bound at all for
>> + * this entity.
>> + */
>> +int vb2_request_submit(struct v4l2_request_entity_data *data);
>> +
>> +#else /* CONFIG_MEDIA_REQUEST_API */
>> +
>> +static inline int vb2_qbuf_request(struct vb2_queue *q, struct v4l2_buffer *b,
>> +                                struct media_request_entity *entity)
>> +{
>> +     return vb2_qbuf(q, b);
>> +}
>> +
>> +static inline int vb2_request_submit(struct v4l2_request_entity_data *data)
>> +{
>> +     return -ENOTSUPP;
>> +}
>> +
>> +#endif /* CONFIG_MEDIA_REQUEST_API */
>> +
>>  /**
>>   * vb2_expbuf() - Export a buffer as a file descriptor
>>   * @q:               pointer to &struct vb2_queue with videobuf2 queue.
>>
>
> Regards,
>
>         Hans
