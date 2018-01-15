Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-io0-f196.google.com ([209.85.223.196]:39332 "EHLO
        mail-io0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751228AbeAOIZN (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 15 Jan 2018 03:25:13 -0500
Received: by mail-io0-f196.google.com with SMTP id b198so9575454iof.6
        for <linux-media@vger.kernel.org>; Mon, 15 Jan 2018 00:25:12 -0800 (PST)
Received: from mail-it0-f54.google.com (mail-it0-f54.google.com. [209.85.214.54])
        by smtp.gmail.com with ESMTPSA id c8sm5055096itg.15.2018.01.15.00.25.11
        for <linux-media@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 15 Jan 2018 00:25:11 -0800 (PST)
Received: by mail-it0-f54.google.com with SMTP id c16so12492itc.5
        for <linux-media@vger.kernel.org>; Mon, 15 Jan 2018 00:25:11 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <39a23bdb-8493-d47f-7596-e4954743766b@xs4all.nl>
References: <20171215075625.27028-1-acourbot@chromium.org> <20171215075625.27028-7-acourbot@chromium.org>
 <39a23bdb-8493-d47f-7596-e4954743766b@xs4all.nl>
From: Alexandre Courbot <acourbot@chromium.org>
Date: Mon, 15 Jan 2018 17:24:50 +0900
Message-ID: <CAPBb6MU7tLj-tMeME5wuFku_AsOqQzTPd7_cG5PM7HTy-_anmQ@mail.gmail.com>
Subject: Re: [RFC PATCH 6/9] media: vb2: add support for requests in QBUF ioctl
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

On Fri, Jan 12, 2018 at 8:37 PM, Hans Verkuil <hverkuil@xs4all.nl> wrote:
> On 12/15/17 08:56, Alexandre Courbot wrote:
>> Support the request argument of the QBUF ioctl.
>>
>> Signed-off-by: Alexandre Courbot <acourbot@chromium.org>
>> ---
>>  drivers/media/v4l2-core/v4l2-ioctl.c | 93 +++++++++++++++++++++++++++++++++++-
>>  1 file changed, 92 insertions(+), 1 deletion(-)
>>
>> diff --git a/drivers/media/v4l2-core/v4l2-ioctl.c b/drivers/media/v4l2-core/v4l2-ioctl.c
>> index 8d041247e97f..28f9c368563e 100644
>> --- a/drivers/media/v4l2-core/v4l2-ioctl.c
>> +++ b/drivers/media/v4l2-core/v4l2-ioctl.c
>> @@ -29,6 +29,7 @@
>>  #include <media/v4l2-device.h>
>>  #include <media/videobuf2-v4l2.h>
>>  #include <media/v4l2-mc.h>
>> +#include <media/media-request.h>
>>
>>  #include <trace/events/v4l2.h>
>>
>> @@ -965,6 +966,81 @@ static int check_fmt(struct file *file, enum v4l2_buf_type type)
>>       return -EINVAL;
>>  }
>>
>> +/*
>> + * Validate that a given request can be used during an ioctl.
>> + *
>> + * When using the request API, request file descriptors must be matched against
>> + * the actual request object. User-space can pass any file descriptor, so we
>> + * need to make sure the call is valid before going further.
>> + *
>> + * This function looks up the request and associated data and performs the
>> + * following sanity checks:
>> + *
>> + * * Make sure that the entity supports requests,
>> + * * Make sure that the entity belongs to the media_device managing the passed
>> + *   request,
>> + * * Make sure that the entity data (if any) is associated to the current file
>> + *   handler.
>> + *
>> + * This function returns a pointer to the valid request, or and error code in
>> + * case of failure. When successful, a reference to the request is acquired and
>> + * must be properly released.
>> + */
>> +#ifdef CONFIG_MEDIA_CONTROLLER
>> +static struct media_request *
>> +check_request(int request, struct file *file, void *fh)
>> +{
>> +     struct media_request *req = NULL;
>> +     struct video_device *vfd = video_devdata(file);
>> +     struct v4l2_fh *vfh =
>> +             test_bit(V4L2_FL_USES_V4L2_FH, &vfd->flags) ? fh : NULL;
>> +     struct media_entity *entity = &vfd->entity;
>> +     const struct media_entity *ent;
>> +     struct media_request_entity_data *data;
>> +     bool found = false;
>> +
>> +     if (!entity)
>> +             return ERR_PTR(-EINVAL);
>> +
>> +     /* Check that the entity supports requests */
>> +     if (!entity->req_ops)
>> +             return ERR_PTR(-ENOTSUPP);
>> +
>> +     req = media_request_get_from_fd(request);
>
> You can get the media_device from vfd->v4l2_dev->mdev. So it is much easier
> to just pass the media_device as an argument to media_request_get_from_fd()...
>
>> +     if (!req)
>> +             return ERR_PTR(-EINVAL);
>> +
>> +     /* Validate that the entity belongs to the media_device managing
>> +      * the request queue */
>> +     media_device_for_each_entity(ent, req->queue->mdev) {
>> +             if (entity == ent) {
>> +                     found = true;
>> +                     break;
>> +             }
>> +     }
>> +     if (!found) {
>> +             media_request_put(req);
>> +             return ERR_PTR(-EINVAL);
>> +     }
>
> ...and then you don't need to do this ^^^ extra validation check.

Ah right, all you need to do is check that req->queue->mdev ==
vfd->v4l2_dev->mdev and you can get rid of this whole block. I don't
think we can do that in media_request_get_from_fd() though, since it
is called from other places where (IIUC) we don't have access to the
media_device.

>
>> +
>> +     /* Validate that the entity's data belongs to the correct fh */
>> +     data = media_request_get_entity_data(req, entity, vfh);
>> +     if (IS_ERR(data)) {
>> +             media_request_put(req);
>> +             return ERR_PTR(PTR_ERR(data));
>> +     }
>
> This assumes that each filehandle has its own state. That's true for codecs,
> but not for most (all?) other devices. There the state is per device instance.
>
> I'm not sure if we have a unique identifying mark for such drivers. The closest
> is checking if fh->m2m_ctx is non-NULL, but I don't know if all drivers with
> per-filehandle state use that field. An alternative might be to check if
> fh->ctrl_handler is non-NULL. But again, I'm not sure if that's a 100% valid
> check.

I think the current code already takes that case into account: if the
device does not uses v4l2_fh, then the fh argument passed to
media_request_get_entity_data() will be null, and so will be data->fh.
