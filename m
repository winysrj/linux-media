Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pg0-f68.google.com ([74.125.83.68]:41498 "EHLO
        mail-pg0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932161AbeCKTnC (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sun, 11 Mar 2018 15:43:02 -0400
Subject: Re: [RFCv4,19/21] media: vim2m: add request support
To: Paul Kocialkowski <paul.kocialkowski@bootlin.com>,
        Alexandre Courbot <acourbot@chromium.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Pawel Osciak <posciak@chromium.org>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Tomasz Figa <tfiga@chromium.org>,
        Sakari Ailus <sakari.ailus@linux.intel.com>
Cc: Gustavo Padovan <gustavo.padovan@collabora.com>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        Maxime Ripard <maxime.ripard@bootlin.com>
References: <20180220044425.169493-20-acourbot@chromium.org>
 <1520440654.1092.15.camel@bootlin.com>
From: Dmitry Osipenko <digetx@gmail.com>
Message-ID: <6470b45d-e9dc-0a22-febc-cd18ae1092be@gmail.com>
Date: Sun, 11 Mar 2018 22:42:50 +0300
MIME-Version: 1.0
In-Reply-To: <1520440654.1092.15.camel@bootlin.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,

On 07.03.2018 19:37, Paul Kocialkowski wrote:
> Hi,
> 
> First off, I'd like to take the occasion to say thank-you for your work.
> This is a major piece of plumbing that is required for me to add support
> for the Allwinner CedarX VPU hardware in upstream Linux. Other drivers,
> such as tegra-vde (that was recently merged in staging) are also badly
> in need of this API.

Certainly it would be good to have a common UAPI. Yet I haven't got my hands on
trying to implement the V4L interface for the tegra-vde driver, but I've taken a
look at Cedrus driver and for now I've one question:

Would it be possible (or maybe already is) to have a single IOCTL that takes
input/output buffers with codec parameters, processes the request(s) and returns
to userspace when everything is done? Having 5 context switches for a single
frame decode (like Cedrus VAAPI driver does) looks like a bit of overhead.

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
>> +				struct media_request_entity_data
>> *_data)
>> +{
>> +	struct v4l2_request_entity_data *data;
>> +
>> +	data = to_v4l2_entity_data(_data);
> 
> We need to call v4l2_m2m_try_schedule here so that m2m scheduling can
> happen when only 2 buffers were queued and no other action was taken
> from usespace. In that scenario, m2m scheduling currently doesn't
> happen.
> 
> However, this requires access to the m2m context, which is not easy to
> get from req or _data. I'm not sure that some container_of magic would
> even do the trick here.
> 
>> +	return vb2_request_submit(data);
> 
> vb2_request_submit does not lock the associated request mutex although
> it accesses the associated queued buffers list, which I believe this
> mutex is supposed to protect.
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
>> +	.data_alloc	= vim2m_entity_data_alloc,
>> +	.data_free	= v4l2_request_entity_data_free,
>> +	.submit		= vim2m_request_submit,
>> +};
>> +
>>  /*
>>   * File operations
>>   */
>> @@ -900,6 +967,9 @@ static int vim2m_open(struct file *file)
>>  	ctx->dev = dev;
>>  	hdl = &ctx->hdl;
>>  	v4l2_ctrl_handler_init(hdl, 4);
>> +	v4l2_request_entity_init(&ctx->req_entity,
>> &vim2m_request_entity_ops,
>> +				 &ctx->dev->vfd);
>> +	ctx->fh.entity = &ctx->req_entity.base;
>>  	v4l2_ctrl_new_std(hdl, &vim2m_ctrl_ops, V4L2_CID_HFLIP, 0, 1,
>> 1, 0);
>>  	v4l2_ctrl_new_std(hdl, &vim2m_ctrl_ops, V4L2_CID_VFLIP, 0, 1,
>> 1, 0);
>>  	v4l2_ctrl_new_custom(hdl, &vim2m_ctrl_trans_time_msec, NULL);
>> @@ -999,6 +1069,9 @@ static int vim2m_probe(struct platform_device
>> *pdev)
>>  	if (!dev)
>>  		return -ENOMEM;
>>  
>> +	v4l2_request_mgr_init(&dev->req_mgr, &dev->vfd,
>> +			      &v4l2_request_ops);
>> +
>>  	spin_lock_init(&dev->irqlock);
>>  
>>  	ret = v4l2_device_register(&pdev->dev, &dev->v4l2_dev);
>> @@ -1012,6 +1085,7 @@ static int vim2m_probe(struct platform_device
>> *pdev)
>>  	vfd = &dev->vfd;
>>  	vfd->lock = &dev->dev_mutex;
>>  	vfd->v4l2_dev = &dev->v4l2_dev;
>> +	vfd->req_mgr = &dev->req_mgr.base;
>>  
>>  	ret = video_register_device(vfd, VFL_TYPE_GRABBER, 0);
>>  	if (ret) {
>> @@ -1054,6 +1128,7 @@ static int vim2m_remove(struct platform_device
>> *pdev)
>>  	del_timer_sync(&dev->timer);
>>  	video_unregister_device(&dev->vfd);
>>  	v4l2_device_unregister(&dev->v4l2_dev);
>> +	v4l2_request_mgr_free(&dev->req_mgr);
>>  
>>  	return 0;
>>  }
> 


-- 
Dmitry
