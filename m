Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:55182 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1750730AbeDLHbG (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 12 Apr 2018 03:31:06 -0400
Date: Thu, 12 Apr 2018 10:31:04 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org, Hans Verkuil <hans.verkuil@cisco.com>
Subject: Re: [RFCv11 PATCH 05/29] media-request: add request ioctls
Message-ID: <20180412073104.7k4ahzihiwxgoe6d@valkosipuli.retiisi.org.uk>
References: <20180409142026.19369-1-hverkuil@xs4all.nl>
 <20180409142026.19369-6-hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180409142026.19369-6-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

On Mon, Apr 09, 2018 at 04:20:02PM +0200, Hans Verkuil wrote:
> From: Hans Verkuil <hans.verkuil@cisco.com>
> 
> Implement the MEDIA_REQUEST_IOC_QUEUE and MEDIA_REQUEST_IOC_REINIT
> ioctls.
> 
> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
> ---
>  drivers/media/media-request.c | 80 +++++++++++++++++++++++++++++++++++++++++--
>  1 file changed, 78 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/media/media-request.c b/drivers/media/media-request.c
> index dffc290e4ada..27739ff7cb09 100644
> --- a/drivers/media/media-request.c
> +++ b/drivers/media/media-request.c
> @@ -118,10 +118,86 @@ static unsigned int media_request_poll(struct file *filp,
>  	return 0;
>  }
>  
> +static long media_request_ioctl_queue(struct media_request *req)
> +{
> +	struct media_device *mdev = req->mdev;
> +	unsigned long flags;
> +	int ret = 0;
> +
> +	dev_dbg(mdev->dev, "request: queue %s\n", req->debug_str);
> +
> +	spin_lock_irqsave(&req->lock, flags);
> +	if (req->state != MEDIA_REQUEST_STATE_IDLE) {
> +		dev_dbg(mdev->dev,
> +			"request: unable to queue %s, request in state %s\n",
> +			req->debug_str, media_request_state_str(req->state));
> +		spin_unlock_irqrestore(&req->lock, flags);
> +		return -EINVAL;
> +	}
> +	req->state = MEDIA_REQUEST_STATE_QUEUEING;
> +
> +	spin_unlock_irqrestore(&req->lock, flags);
> +
> +	/*
> +	 * Ensure the request that is validated will be the one that gets queued
> +	 * next by serialising the queueing process.
> +	 */
> +	mutex_lock(&mdev->req_queue_mutex);
> +
> +	ret = mdev->ops->req_queue(req);
> +	spin_lock_irqsave(&req->lock, flags);
> +	req->state = ret ? MEDIA_REQUEST_STATE_IDLE : MEDIA_REQUEST_STATE_QUEUED;
> +	spin_unlock_irqrestore(&req->lock, flags);
> +	mutex_unlock(&mdev->req_queue_mutex);
> +
> +	if (ret) {
> +		dev_dbg(mdev->dev, "request: can't queue %s (%d)\n",
> +			req->debug_str, ret);
> +	} else {
> +		media_request_get(req);
> +	}
> +
> +	return ret;
> +}
> +
> +static long media_request_ioctl_reinit(struct media_request *req)
> +{
> +	struct media_device *mdev = req->mdev;
> +	unsigned long flags;
> +
> +	spin_lock_irqsave(&req->lock, flags);
> +	if (req->state != MEDIA_REQUEST_STATE_IDLE &&
> +	    req->state != MEDIA_REQUEST_STATE_COMPLETE) {
> +		dev_dbg(mdev->dev,
> +			"request: %s not in idle or complete state, cannot reinit\n",
> +			req->debug_str);
> +		spin_unlock_irqrestore(&req->lock, flags);
> +		return -EINVAL;
> +	}
> +	req->state = MEDIA_REQUEST_STATE_CLEANING;
> +	spin_unlock_irqrestore(&req->lock, flags);
> +
> +	media_request_clean(req);
> +
> +	spin_lock_irqsave(&req->lock, flags);
> +	req->state = MEDIA_REQUEST_STATE_IDLE;
> +	spin_unlock_irqrestore(&req->lock, flags);

Newline here.

> +	return 0;
> +}
> +
>  static long media_request_ioctl(struct file *filp, unsigned int cmd,
> -				unsigned long __arg)
> +				unsigned long arg)

This change should be in the patch that added the function.

>  {
> -	return -ENOIOCTLCMD;
> +	struct media_request *req = filp->private_data;
> +
> +	switch (cmd) {
> +	case MEDIA_REQUEST_IOC_QUEUE:
> +		return media_request_ioctl_queue(req);
> +	case MEDIA_REQUEST_IOC_REINIT:
> +		return media_request_ioctl_reinit(req);
> +	default:
> +		return -ENOIOCTLCMD;
> +	}
>  }
>  
>  static const struct file_operations request_fops = {

-- 
Sakari Ailus
e-mail: sakari.ailus@iki.fi
