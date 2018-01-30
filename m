Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:46231 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753008AbeA3RtQ (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 30 Jan 2018 12:49:16 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Hans Verkuil <hansverk@cisco.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PATCH] v4l2-compat-ioctl32.c: make ctrl_is_pointer work for subdevs
Date: Tue, 30 Jan 2018 19:49:32 +0200
Message-ID: <1696034.lWE4eBQPQA@avalon>
In-Reply-To: <e72bf5c1-833e-ad7a-f92f-05527eabea14@cisco.com>
References: <e72bf5c1-833e-ad7a-f92f-05527eabea14@cisco.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

Thank you for the patch.

On Tuesday, 30 January 2018 17:18:32 EET Hans Verkuil wrote:
> If the device is of type VFL_TYPE_SUBDEV then vdev->ioctl_ops
> is NULL so the 'if (!ops->vidioc_query_ext_ctrl)' check would fail.

More than that, it would crash.

> Add a test for !ops to the condition.
> 
> All sub-devices that have controls will use the control framework,
> so they do not have an equivalent to ops->vidioc_query_ext_ctrl.
> Returning false if ops is NULL is the correct thing to do here.
> 
> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>

This is missing a Fixes: tag, and a Reported-by: tag would be nice too.

Apart from that,

Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

> ---
>  drivers/media/v4l2-core/v4l2-compat-ioctl32.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/media/v4l2-core/v4l2-compat-ioctl32.c
> b/drivers/media/v4l2-core/v4l2-compat-ioctl32.c index
> bdb5c226d01c..5198c9eeb348 100644
> --- a/drivers/media/v4l2-core/v4l2-compat-ioctl32.c
> +++ b/drivers/media/v4l2-core/v4l2-compat-ioctl32.c
> @@ -770,7 +770,7 @@ static inline bool ctrl_is_pointer(struct file *file,
> u32 id) return ctrl && ctrl->is_ptr;
>  	}
> 
> -	if (!ops->vidioc_query_ext_ctrl)
> +	if (!ops || !ops->vidioc_query_ext_ctrl)
>  		return false;
> 
>  	return !ops->vidioc_query_ext_ctrl(file, fh, &qec) &&

-- 
Regards,

Laurent Pinchart
