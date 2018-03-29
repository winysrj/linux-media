Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:37544 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750716AbeC2KTZ (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 29 Mar 2018 06:19:25 -0400
Date: Thu, 29 Mar 2018 13:18:56 +0300
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org, Tomasz Figa <tfiga@google.com>,
        Alexandre Courbot <acourbot@chromium.org>,
        Gustavo Padovan <gustavo@padovan.org>,
        Hans Verkuil <hans.verkuil@cisco.com>
Subject: Re: [RFCv9 PATCH 05/29] media-request: add request ioctls
Message-ID: <20180329101856.l4u62dtvi3tao45o@paasikivi.fi.intel.com>
References: <20180328135030.7116-1-hverkuil@xs4all.nl>
 <20180328135030.7116-6-hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180328135030.7116-6-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

I think it'd be easier to review the code if it was a part of the previous
patch. It's so closely related to what's being done there.

On Wed, Mar 28, 2018 at 03:50:06PM +0200, Hans Verkuil wrote:
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
> index 8135d9d32af9..3ee3b27fd644 100644
> --- a/drivers/media/media-request.c
> +++ b/drivers/media/media-request.c
> @@ -105,10 +105,86 @@ static unsigned int media_request_poll(struct file *filp,
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

You could print the message after releasing the spinlock. Maybe store the
request state locally first?

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

Newline?

> +	return 0;
> +}
> +
>  static long media_request_ioctl(struct file *filp, unsigned int cmd,
> -				unsigned long __arg)
> +				unsigned long arg)

This belongs to the patch adding media_request_ioctl().

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
sakari.ailus@linux.intel.com
