Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-vk0-f65.google.com ([209.85.213.65]:46555 "EHLO
        mail-vk0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750962AbeBWGfS (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 23 Feb 2018 01:35:18 -0500
Received: by mail-vk0-f65.google.com with SMTP id x125so4685291vkc.13
        for <linux-media@vger.kernel.org>; Thu, 22 Feb 2018 22:35:17 -0800 (PST)
Received: from mail-ua0-f181.google.com (mail-ua0-f181.google.com. [209.85.217.181])
        by smtp.gmail.com with ESMTPSA id j7sm408362uak.50.2018.02.22.22.35.14
        for <linux-media@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 22 Feb 2018 22:35:15 -0800 (PST)
Received: by mail-ua0-f181.google.com with SMTP id i15so5009502uak.3
        for <linux-media@vger.kernel.org>; Thu, 22 Feb 2018 22:35:14 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <86ad101f-f400-c7fd-2aa5-4dc618973f3d@xs4all.nl>
References: <20180220044425.169493-1-acourbot@chromium.org>
 <20180220044425.169493-14-acourbot@chromium.org> <86ad101f-f400-c7fd-2aa5-4dc618973f3d@xs4all.nl>
From: Tomasz Figa <tfiga@chromium.org>
Date: Fri, 23 Feb 2018 15:34:53 +0900
Message-ID: <CAAFQd5AOoknDxxqGKjDD0LDt4kYY=UdrLOKLtqs1foFdCviFNw@mail.gmail.com>
Subject: Re: [RFCv4 13/21] media: videobuf2-v4l2: support for requests
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Alexandre Courbot <acourbot@chromium.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Pawel Osciak <posciak@chromium.org>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Gustavo Padovan <gustavo.padovan@collabora.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
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

Would the prepare operation be completely independent of other state?
I can see a case when how the buffer is to be prepared may depend on
values of some controls. If so, it would be only possible at request
submission time. Alternatively, the application would have to be
mandated to include any controls that may affect buffer preparing in
the request and before the QBUF is called.

Best regards,
Tomasz
