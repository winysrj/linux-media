Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud2.xs4all.net ([194.109.24.21]:45124 "EHLO
        lb1-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752050AbdGFIgc (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 6 Jul 2017 04:36:32 -0400
Subject: Re: [PATCH 05/12] [media] vivid: assign the specific device to the
 vb2_queue->dev
To: Gustavo Padovan <gustavo@padovan.org>, linux-media@vger.kernel.org
References: <20170616073915.5027-1-gustavo@padovan.org>
 <20170616073915.5027-6-gustavo@padovan.org>
Cc: Javier Martinez Canillas <javier@osg.samsung.com>,
        Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
        Shuah Khan <shuahkh@osg.samsung.com>,
        Gustavo Padovan <gustavo.padovan@collabora.com>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <94a8f4db-9043-9809-d85d-7868aab1e667@xs4all.nl>
Date: Thu, 6 Jul 2017 10:36:21 +0200
MIME-Version: 1.0
In-Reply-To: <20170616073915.5027-6-gustavo@padovan.org>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 06/16/17 09:39, Gustavo Padovan wrote:
> From: Gustavo Padovan <gustavo.padovan@collabora.com>
> 
> Instead of assigning the global v4l2 device, assign the specific device.
> This was causing trouble when using using V4L2 events with vivid
> devices. The device's queue should be the same we opened in userspace.
> 
> Signed-off-by: Gustavo Padovan <gustavo.padovan@collabora.com>

Can you add a line to the commit log that says that this is needed for
the upcoming V4L2_EVENT_BUF_QUEUED support? This log message suggests that
the current vivid code is wrong, which it isn't. It just needs to be changed
so V4L2_EVENT_BUF_QUEUED can be supported.

After making that change:

Acked-by: Hans Verkuil <hans.verkuil@cisco.com>

Regards,

	Hans

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
>  
>  		ret = vb2_queue_init(q);
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
