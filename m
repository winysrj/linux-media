Return-path: <linux-media-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:52706
        "EHLO osg.samsung.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1750726AbdGGRPq (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 7 Jul 2017 13:15:46 -0400
Subject: Re: [PATCH 05/12] [media] vivid: assign the specific device to the
 vb2_queue->dev
To: Gustavo Padovan <gustavo@padovan.org>, linux-media@vger.kernel.org
Cc: Hans Verkuil <hverkuil@xs4all.nl>,
        Javier Martinez Canillas <javier@osg.samsung.com>,
        Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
        Gustavo Padovan <gustavo.padovan@collabora.com>,
        Shuah Khan <shuahkh@osg.samsung.com>
References: <20170616073915.5027-1-gustavo@padovan.org>
 <20170616073915.5027-6-gustavo@padovan.org>
From: Shuah Khan <shuahkh@osg.samsung.com>
Message-ID: <c34cc77a-740f-3955-d6e6-2c04a778c190@osg.samsung.com>
Date: Fri, 7 Jul 2017 11:15:43 -0600
MIME-Version: 1.0
In-Reply-To: <20170616073915.5027-6-gustavo@padovan.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 06/16/2017 01:39 AM, Gustavo Padovan wrote:
> From: Gustavo Padovan <gustavo.padovan@collabora.com>
> 
> Instead of assigning the global v4l2 device, assign the specific device.
> This was causing trouble when using using V4L2 events with vivid
> devices. The device's queue should be the same we opened in userspace.
> 
> Signed-off-by: Gustavo Padovan <gustavo.padovan@collabora.com>
> ---
>  drivers/media/platform/vivid/vivid-core.c | 10 +++++-----
>  1 file changed, 5 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/media/platform/vivid/vivid-core.c b/drivers/media/platform/vivid/vivid-core.c
> index ef344b9..8843170 100644
> --- a/drivers/media/platform/vivid/vivid-core.c
> +++ b/drivers/media/platform/vivid/vivid-core.c
> @@ -1070,7 +1070,7 @@ static int vivid_create_instance(struct platform_device *pdev, int inst)
>  		q->timestamp_flags = V4L2_BUF_FLAG_TIMESTAMP_MONOTONIC;
>  		q->min_buffers_needed = 2;
>  		q->lock = &dev->mutex;
> -		q->dev = dev->v4l2_dev.dev;
> +		q->dev = &dev->vid_cap_dev.dev;

Does this work in all cases? My concern is that in some code paths
q->dev might be used to initiate release perhaps.

Fore example v4l2_dev.release is vivid_dev_release()
dev->v4l2_dev.release = vivid_dev_release;

vid_cap_dev release is video_device_release_empty

This is one difference, but there might be others and the code paths
that might depend on q->dev being the v4l2_dev.dev which is the global
dev.

> >  		ret = vb2_queue_init(q);
>  		if (ret)
> @@ -1090,7 +1090,7 @@ static int vivid_create_instance(struct platform_device *pdev, int inst)
>  		q->timestamp_flags = V4L2_BUF_FLAG_TIMESTAMP_MONOTONIC;
>  		q->min_buffers_needed = 2;
>  		q->lock = &dev->mutex;
> -		q->dev = dev->v4l2_dev.dev;
> +		q->dev = &dev->vid_out_dev.dev;
>  
>  		ret = vb2_queue_init(q);
>  		if (ret)
> @@ -1110,7 +1110,7 @@ static int vivid_create_instance(struct platform_device *pdev, int inst)
>  		q->timestamp_flags = V4L2_BUF_FLAG_TIMESTAMP_MONOTONIC;
>  		q->min_buffers_needed = 2;
>  		q->lock = &dev->mutex;
> -		q->dev = dev->v4l2_dev.dev;
> +		q->dev = &dev->vbi_cap_dev.dev;
>  
>  		ret = vb2_queue_init(q);
>  		if (ret)
> @@ -1130,7 +1130,7 @@ static int vivid_create_instance(struct platform_device *pdev, int inst)
>  		q->timestamp_flags = V4L2_BUF_FLAG_TIMESTAMP_MONOTONIC;
>  		q->min_buffers_needed = 2;
>  		q->lock = &dev->mutex;
> -		q->dev = dev->v4l2_dev.dev;
> +		q->dev = &dev->vbi_out_dev.dev;
>  
>  		ret = vb2_queue_init(q);
>  		if (ret)
> @@ -1149,7 +1149,7 @@ static int vivid_create_instance(struct platform_device *pdev, int inst)
>  		q->timestamp_flags = V4L2_BUF_FLAG_TIMESTAMP_MONOTONIC;
>  		q->min_buffers_needed = 8;
>  		q->lock = &dev->mutex;
> -		q->dev = dev->v4l2_dev.dev;
> +		q->dev = &dev->sdr_cap_dev.dev;
>  
>  		ret = vb2_queue_init(q);
>  		if (ret)
> 

thanks,
-- Shuah
