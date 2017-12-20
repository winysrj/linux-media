Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-it0-f68.google.com ([209.85.214.68]:39395 "EHLO
        mail-it0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753868AbdLTJ34 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 20 Dec 2017 04:29:56 -0500
Received: by mail-it0-f68.google.com with SMTP id 68so6098188ite.4
        for <linux-media@vger.kernel.org>; Wed, 20 Dec 2017 01:29:55 -0800 (PST)
Received: from mail-it0-f41.google.com (mail-it0-f41.google.com. [209.85.214.41])
        by smtp.gmail.com with ESMTPSA id z188sm2435481itb.28.2017.12.20.01.29.54
        for <linux-media@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 20 Dec 2017 01:29:54 -0800 (PST)
Received: by mail-it0-f41.google.com with SMTP id u62so6005975ita.2
        for <linux-media@vger.kernel.org>; Wed, 20 Dec 2017 01:29:54 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20171218205358.GA29766@jade>
References: <20171215075625.27028-1-acourbot@chromium.org> <20171215075625.27028-10-acourbot@chromium.org>
 <20171218205358.GA29766@jade>
From: Alexandre Courbot <acourbot@chromium.org>
Date: Wed, 20 Dec 2017 18:29:33 +0900
Message-ID: <CAPBb6MX1KQp=JmqhCASmQQF_-d09iVSdN6uBrAxGs4yuqgPfPw@mail.gmail.com>
Subject: Re: [RFC PATCH 9/9] media: vim2m: add request support
To: Gustavo Padovan <gustavo@padovan.org>
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Hans Verkuil <hverkuil@xs4all.nl>,
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

On Tue, Dec 19, 2017 at 5:53 AM, Gustavo Padovan <gustavo@padovan.org> wrote:
> Hi Alex,
>
> 2017-12-15 Alexandre Courbot <acourbot@chromium.org>:
>
>> Set the necessary ops for supporting requests in vim2m.
>>
>> Signed-off-by: Alexandre Courbot <acourbot@chromium.org>
>> ---
>>  drivers/media/platform/vim2m.c | 22 ++++++++++++++++++++++
>>  1 file changed, 22 insertions(+)
>>
>> diff --git a/drivers/media/platform/vim2m.c b/drivers/media/platform/vim2m.c
>> index a32e8a7950eb..ffe94ef9214d 100644
>> --- a/drivers/media/platform/vim2m.c
>> +++ b/drivers/media/platform/vim2m.c
>> @@ -30,6 +30,7 @@
>>  #include <media/v4l2-ctrls.h>
>>  #include <media/v4l2-event.h>
>>  #include <media/videobuf2-vmalloc.h>
>> +#include <media/media-request.h>
>>
>>  MODULE_DESCRIPTION("Virtual device for mem2mem framework testing");
>>  MODULE_AUTHOR("Pawel Osciak, <pawel@osciak.com>");
>> @@ -142,6 +143,7 @@ struct vim2m_dev {
>>       struct video_device     vfd;
>>  #ifdef CONFIG_MEDIA_CONTROLLER
>>       struct media_device     mdev;
>> +     struct media_request_queue *req_queue;
>>  #endif
>>
>>       atomic_t                num_inst;
>> @@ -937,6 +939,11 @@ static int vim2m_open(struct file *file)
>>               goto open_unlock;
>>       }
>>
>> +#ifdef CONFIG_MEDIA_CONTROLLER
>> +     v4l2_mem_ctx_request_init(ctx->fh.m2m_ctx, dev->req_queue,
>> +                               &dev->vfd.entity);
>> +#endif
>> +
>>       v4l2_fh_add(&ctx->fh);
>>       atomic_inc(&dev->num_inst);
>>
>> @@ -992,6 +999,12 @@ static const struct v4l2_m2m_ops m2m_ops = {
>>       .job_abort      = job_abort,
>>  };
>>
>> +#ifdef CONFIG_MEDIA_CONTROLLER
>> +static const struct media_entity_operations vim2m_entity_ops = {
>> +     .process_request = v4l2_m2m_process_request,
>> +};
>> +#endif
>> +
>>  static int vim2m_probe(struct platform_device *pdev)
>>  {
>>       struct vim2m_dev *dev;
>> @@ -1006,6 +1019,10 @@ static int vim2m_probe(struct platform_device *pdev)
>>
>>  #ifdef CONFIG_MEDIA_CONTROLLER
>>       dev->mdev.dev = &pdev->dev;
>> +     dev->req_queue = media_request_queue_generic_alloc(&dev->mdev);
>> +     if (IS_ERR(dev->req_queue))
>> +             return PTR_ERR(dev->req_queue);
>> +     dev->mdev.req_queue = dev->req_queue;
>>       strlcpy(dev->mdev.model, "vim2m", sizeof(dev->mdev.model));
>>       media_device_init(&dev->mdev);
>>       dev->v4l2_dev.mdev = &dev->mdev;
>> @@ -1023,6 +1040,11 @@ static int vim2m_probe(struct platform_device *pdev)
>>       vfd->lock = &dev->dev_mutex;
>>       vfd->v4l2_dev = &dev->v4l2_dev;
>>
>> +#ifdef CONFIG_MEDIA_CONTROLLER
>> +     vfd->entity.ops = &vim2m_entity_ops;
>> +     vfd->entity.req_ops = &media_entity_request_generic_ops;
>> +#endif
>> +
>
> It seems to me that we can avoid most of this patch and just setup the
> request support automatically when the media device node is registered.
> The less change we impose to drivers the better I think.

I'd like to move things more towards that direction, if possible. The
main blocker for now is that I want to keep the ability for drivers to
overload the request ops to fit their needs. But maybe we can just
allow some level of specialization if specified, while falling back to
sane defaults otherwise.
