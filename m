Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud9.xs4all.net ([194.109.24.26]:46706 "EHLO
        lb2-smtp-cloud9.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751146AbeBHIk4 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 8 Feb 2018 03:40:56 -0500
Subject: Re: [PATCH 1/7] media: v4l2-compat-ioctl32.c: make ctrl_is_pointer
 work for subdevs
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>, stable@vger.kernel.org,
        Mauro Carvalho Chehab <mchehab@s-opensource.com>
References: <20180207143939.29491-1-hverkuil@xs4all.nl>
 <20180207143939.29491-2-hverkuil@xs4all.nl>
Message-ID: <f7e45b12-cac8-9a32-ba40-b0d2321acefd@xs4all.nl>
Date: Thu, 8 Feb 2018 09:40:49 +0100
MIME-Version: 1.0
In-Reply-To: <20180207143939.29491-2-hverkuil@xs4all.nl>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 02/07/2018 03:39 PM, Hans Verkuil wrote:
> From: Hans Verkuil <hansverk@cisco.com>
> 
> If the device is of type VFL_TYPE_SUBDEV then vdev->ioctl_ops
> is NULL so the 'if (!ops->vidioc_query_ext_ctrl)' check would crash.
> Add a test for !ops to the condition.
> 
> All sub-devices that have controls will use the control framework,
> so they do not have an equivalent to ops->vidioc_query_ext_ctrl.
> Returning false if ops is NULL is the correct thing to do here.
> 
> Fixes: b8c601e8af ("v4l2-compat-ioctl32.c: fix ctrl_is_pointer")
> 
> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
> Acked-by: Sakari Ailus <sakari.ailus@linux.intel.com>
> Reported-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> Cc: <stable@vger.kernel.org>      # for v4.15 and up
> Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
> ---
>  drivers/media/v4l2-core/v4l2-compat-ioctl32.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/media/v4l2-core/v4l2-compat-ioctl32.c b/drivers/media/v4l2-core/v4l2-compat-ioctl32.c
> index bdb5c226d01c..5198c9eeb348 100644
> --- a/drivers/media/v4l2-core/v4l2-compat-ioctl32.c
> +++ b/drivers/media/v4l2-core/v4l2-compat-ioctl32.c
> @@ -770,7 +770,7 @@ static inline bool ctrl_is_pointer(struct file *file, u32 id)
>  		return ctrl && ctrl->is_ptr;
>  	}
>  
> -	if (!ops->vidioc_query_ext_ctrl)
> +	if (!ops || !ops->vidioc_query_ext_ctrl)
>  		return false;
>  
>  	return !ops->vidioc_query_ext_ctrl(file, fh, &qec) &&
> 

Oops, ignore this one. Obviously not part of the patch series.

	Hans
