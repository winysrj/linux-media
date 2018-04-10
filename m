Return-path: <linux-media-owner@vger.kernel.org>
Received: from osg.samsung.com ([64.30.133.232]:41149 "EHLO osg.samsung.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752408AbeDJK6C (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 10 Apr 2018 06:58:02 -0400
Date: Tue, 10 Apr 2018 07:57:56 -0300
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org, Hans Verkuil <hans.verkuil@cisco.com>
Subject: Re: [RFCv11 PATCH 05/29] media-request: add request ioctls
Message-ID: <20180410075756.3975ed22@vento.lan>
In-Reply-To: <20180409142026.19369-6-hverkuil@xs4all.nl>
References: <20180409142026.19369-1-hverkuil@xs4all.nl>
        <20180409142026.19369-6-hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Mon,  9 Apr 2018 16:20:02 +0200
Hans Verkuil <hverkuil@xs4all.nl> escreveu:

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

The locking here seems really weird. IMHO, it should lock before
touching state, as otherwise race conditions may happen.

As I suggested before, I would use an atomic type for state, and get rid
of the spin lock (as it seems that it is meant to be used just
for state).

> +
> +	ret = mdev->ops->req_queue(req);
> +	spin_lock_irqsave(&req->lock, flags);
> +	req->state = ret ? MEDIA_REQUEST_STATE_IDLE : MEDIA_REQUEST_STATE_QUEUED;
> +	spin_unlock_irqrestore(&req->lock, flags);
> +	mutex_unlock(&mdev->req_queue_mutex);
> +

Here, you have both mutex and spin locked. This is a strong indication
that locks are not well designed, are you're using two different locks
to protect the same data.

> +	if (ret) {
> +		dev_dbg(mdev->dev, "request: can't queue %s (%d)\n",
> +			req->debug_str, ret);
> +	} else {
> +		media_request_get(req);
> +	}
> +
> +	return ret;
> +}

IMHO, the above construction hides the main code inside an if due
to an error condition. Doing this makes it clearer that, under normal
circumstances, you're doing a kref_get() call:

	if (ret) {
		dev_dbg(mdev->dev, "request: can't queue %s (%d)\n",
			req->debug_str, ret);
		return ret;
	}

	kref_get(&req->kref);	// This is a way more easier to read than media_request_get(req);
	return 0;
}

Another related issue: IMHO, kref_get() should be called here with the
mutex hold. 

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

This code should be called with the mutex hold.

> +	return 0;
> +}
> +
>  static long media_request_ioctl(struct file *filp, unsigned int cmd,
> -				unsigned long __arg)
> +				unsigned long arg)
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



Thanks,
Mauro
