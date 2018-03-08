Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-it0-f68.google.com ([209.85.214.68]:34233 "EHLO
        mail-it0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754491AbeCHNsc (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Thu, 8 Mar 2018 08:48:32 -0500
Received: by mail-it0-f68.google.com with SMTP id n128so19666822ith.1
        for <linux-media@vger.kernel.org>; Thu, 08 Mar 2018 05:48:32 -0800 (PST)
Received: from mail-it0-f47.google.com (mail-it0-f47.google.com. [209.85.214.47])
        by smtp.gmail.com with ESMTPSA id 193sm8990775itf.1.2018.03.08.05.48.30
        for <linux-media@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 08 Mar 2018 05:48:30 -0800 (PST)
Received: by mail-it0-f47.google.com with SMTP id k79so7971792ita.2
        for <linux-media@vger.kernel.org>; Thu, 08 Mar 2018 05:48:30 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1520440654.1092.15.camel@bootlin.com>
References: <20180220044425.169493-20-acourbot@chromium.org> <1520440654.1092.15.camel@bootlin.com>
From: Alexandre Courbot <acourbot@chromium.org>
Date: Thu, 8 Mar 2018 22:48:08 +0900
Message-ID: <CAPBb6MUeUaHZj9y1N7wJk9yS8QL+zTqWCGvujcKCY0YpdeiyWg@mail.gmail.com>
Subject: Re: [RFCv4,19/21] media: vim2m: add request support
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

Hi Paul!

Thanks a lot for taking the time to try this! I am also working on
getting it to work with an actual driver, but you apparently found
rough edges that I missed.

On Thu, Mar 8, 2018 at 1:37 AM, Paul Kocialkowski
<paul.kocialkowski@bootlin.com> wrote:
> Hi,
>
> First off, I'd like to take the occasion to say thank-you for your work.
> This is a major piece of plumbing that is required for me to add support
> for the Allwinner CedarX VPU hardware in upstream Linux. Other drivers,
> such as tegra-vde (that was recently merged in staging) are also badly
> in need of this API.
>
> I have a few comments based on my experience integrating this request
> API with the Cedrus VPU driver (and the associated libva backend), that
> also concern the vim2m driver.
>
> On Tue, 2018-02-20 at 13:44 +0900, Alexandre Courbot wrote:
>> Set the necessary ops for supporting requests in vim2m.
>>
>> Signed-off-by: Alexandre Courbot <acourbot@chromium.org>
>> ---
>>  drivers/media/platform/Kconfig |  1 +
>>  drivers/media/platform/vim2m.c | 75
>> ++++++++++++++++++++++++++++++++++
>>  2 files changed, 76 insertions(+)
>>
>> diff --git a/drivers/media/platform/Kconfig
>> b/drivers/media/platform/Kconfig
>> index 614fbef08ddc..09be0b5f9afe 100644
>> --- a/drivers/media/platform/Kconfig
>> +++ b/drivers/media/platform/Kconfig
>
> [...]
>
>> +static int vim2m_request_submit(struct media_request *req,
>> +                             struct media_request_entity_data
>> *_data)
>> +{
>> +     struct v4l2_request_entity_data *data;
>> +
>> +     data = to_v4l2_entity_data(_data);
>
> We need to call v4l2_m2m_try_schedule here so that m2m scheduling can
> happen when only 2 buffers were queued and no other action was taken
> from usespace. In that scenario, m2m scheduling currently doesn't
> happen.

I don't think I understand the sequence of events that results in
v4l2_m2m_try_schedule() not being called. Do you mean something like:

*
* QBUF on output queue with request set
* QBUF on capture queue
* SUBMIT_REQUEST

?

The call to vb2_request_submit() right after should trigger
v4l2_m2m_try_schedule(), since the buffers associated to the request
will enter the vb2 queue and be passed to the m2m framework, which
will then call v4l2_m2m_try_schedule(). Or maybe you are thinking
about a different sequence of events?

>
> However, this requires access to the m2m context, which is not easy to
> get from req or _data. I'm not sure that some container_of magic would
> even do the trick here.

data_->entity will give you a pointer to the media_request_entity,
which is part of vim2m_ctx. You can thus get the m2m context by doing
container_of(data_->entity, struct vim2m_ctx, req_entity). See
vim2m_entity_data_alloc() for an example.

>
>> +     return vb2_request_submit(data);
>
> vb2_request_submit does not lock the associated request mutex although
> it accesses the associated queued buffers list, which I believe this
> mutex is supposed to protect.

After a request is submitted, the data protected by the mutex can only
be accessed by the driver when it processes the request. It cannot be
modified concurrently, so I think we are safe here.

I am also wondering whether the ioctl locking doesn't make the request
locking redundant. Request information can only be modified and
accessed through ioctls until it is submitted, and after that there
are no concurrent accesses. I need to think a bit more about it
though.

Cheers,
Alex.

>
> We could either wrap this call with media_request_lock(req) and
> media_request_unlock(req) or have the lock in the function itself, which
> would require passing it the req pointer.
>
> The latter would probably be safer for future use of the function.
>
>> +}
>> +
>> +static const struct media_request_entity_ops vim2m_request_entity_ops
>> = {
>> +     .data_alloc     = vim2m_entity_data_alloc,
>> +     .data_free      = v4l2_request_entity_data_free,
>> +     .submit         = vim2m_request_submit,
>> +};
>> +
>>  /*
>>   * File operations
>>   */
>> @@ -900,6 +967,9 @@ static int vim2m_open(struct file *file)
>>       ctx->dev = dev;
>>       hdl = &ctx->hdl;
>>       v4l2_ctrl_handler_init(hdl, 4);
>> +     v4l2_request_entity_init(&ctx->req_entity,
>> &vim2m_request_entity_ops,
>> +                              &ctx->dev->vfd);
>> +     ctx->fh.entity = &ctx->req_entity.base;
>>       v4l2_ctrl_new_std(hdl, &vim2m_ctrl_ops, V4L2_CID_HFLIP, 0, 1,
>> 1, 0);
>>       v4l2_ctrl_new_std(hdl, &vim2m_ctrl_ops, V4L2_CID_VFLIP, 0, 1,
>> 1, 0);
>>       v4l2_ctrl_new_custom(hdl, &vim2m_ctrl_trans_time_msec, NULL);
>> @@ -999,6 +1069,9 @@ static int vim2m_probe(struct platform_device
>> *pdev)
>>       if (!dev)
>>               return -ENOMEM;
>>
>> +     v4l2_request_mgr_init(&dev->req_mgr, &dev->vfd,
>> +                           &v4l2_request_ops);
>> +
>>       spin_lock_init(&dev->irqlock);
>>
>>       ret = v4l2_device_register(&pdev->dev, &dev->v4l2_dev);
>> @@ -1012,6 +1085,7 @@ static int vim2m_probe(struct platform_device
>> *pdev)
>>       vfd = &dev->vfd;
>>       vfd->lock = &dev->dev_mutex;
>>       vfd->v4l2_dev = &dev->v4l2_dev;
>> +     vfd->req_mgr = &dev->req_mgr.base;
>>
>>       ret = video_register_device(vfd, VFL_TYPE_GRABBER, 0);
>>       if (ret) {
>> @@ -1054,6 +1128,7 @@ static int vim2m_remove(struct platform_device
>> *pdev)
>>       del_timer_sync(&dev->timer);
>>       video_unregister_device(&dev->vfd);
>>       v4l2_device_unregister(&dev->v4l2_dev);
>> +     v4l2_request_mgr_free(&dev->req_mgr);
>>
>>       return 0;
>>  }
>
> --
> Paul Kocialkowski, Bootlin (formerly Free Electrons)
> Embedded Linux and kernel engineering
> https://bootlin.com
