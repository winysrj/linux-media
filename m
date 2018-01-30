Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:53188 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1751931AbeA3QKq (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 30 Jan 2018 11:10:46 -0500
Date: Tue, 30 Jan 2018 18:10:44 +0200
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Hans Verkuil <hansverk@cisco.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PATCH] v4l2-compat-ioctl32.c: make ctrl_is_pointer work for
 subdevs
Message-ID: <20180130161043.3zykwbskkhxfhqxe@valkosipuli.retiisi.org.uk>
References: <e72bf5c1-833e-ad7a-f92f-05527eabea14@cisco.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e72bf5c1-833e-ad7a-f92f-05527eabea14@cisco.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, Jan 30, 2018 at 04:18:32PM +0100, Hans Verkuil wrote:
> If the device is of type VFL_TYPE_SUBDEV then vdev->ioctl_ops
> is NULL so the 'if (!ops->vidioc_query_ext_ctrl)' check would fail.
> Add a test for !ops to the condition.
> 
> All sub-devices that have controls will use the control framework,
> so they do not have an equivalent to ops->vidioc_query_ext_ctrl.
> Returning false if ops is NULL is the correct thing to do here.
> 
> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>

Acked-by: Sakari Ailus <sakari.ailus@linux.intel.com>

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
> -- 
> 2.14.1
> 

-- 
Sakari Ailus
e-mail: sakari.ailus@iki.fi
