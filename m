Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud7.xs4all.net ([194.109.24.28]:53952 "EHLO
        lb2-smtp-cloud7.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726996AbeH1XUx (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 28 Aug 2018 19:20:53 -0400
Subject: Re: [PATCHv2 06/10] media-request: add
 media_request_(un)lock_for_access
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Paul Kocialkowski <paul.kocialkowski@bootlin.com>,
        Tomasz Figa <tfiga@chromium.org>,
        Hans Verkuil <hans.verkuil@cisco.com>
References: <20180828134911.44086-1-hverkuil@xs4all.nl>
 <20180828134911.44086-7-hverkuil@xs4all.nl>
Message-ID: <3f198506-e30c-2839-1f63-24695f8d1451@xs4all.nl>
Date: Tue, 28 Aug 2018 21:27:46 +0200
MIME-Version: 1.0
In-Reply-To: <20180828134911.44086-7-hverkuil@xs4all.nl>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 28/08/18 15:49, Hans Verkuil wrote:
> From: Hans Verkuil <hans.verkuil@cisco.com>
> 
> Add helper functions to prevent a completed request from being
> re-inited while it is being accessed.
> 
> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
> ---
>  drivers/media/media-request.c | 10 ++++++++
>  include/media/media-request.h | 46 +++++++++++++++++++++++++++++++++++
>  2 files changed, 56 insertions(+)
> 
> diff --git a/drivers/media/media-request.c b/drivers/media/media-request.c
> index 4cee67e6657e..414197645e09 100644
> --- a/drivers/media/media-request.c
> +++ b/drivers/media/media-request.c
> @@ -43,6 +43,7 @@ static void media_request_clean(struct media_request *req)
>  	/* Just a sanity check. No other code path is allowed to change this. */
>  	WARN_ON(req->state != MEDIA_REQUEST_STATE_CLEANING);
>  	WARN_ON(req->updating_count);
> +	WARN_ON(req->access_count);
>  
>  	list_for_each_entry_safe(obj, obj_safe, &req->objects, list) {
>  		media_request_object_unbind(obj);
> @@ -50,6 +51,7 @@ static void media_request_clean(struct media_request *req)
>  	}
>  
>  	req->updating_count = 0;
> +	req->access_count = 0;
>  	WARN_ON(req->num_incomplete_objects);
>  	req->num_incomplete_objects = 0;
>  	wake_up_interruptible_all(&req->poll_wait);
> @@ -198,6 +200,13 @@ static long media_request_ioctl_reinit(struct media_request *req)
>  		spin_unlock_irqrestore(&req->lock, flags);
>  		return -EBUSY;
>  	}
> +	if (req->access_count) {
> +		dev_dbg(mdev->dev,
> +			"request: %s is being accessed, cannot reinit\n",
> +			req->debug_str);
> +		spin_unlock_irqrestore(&req->lock, flags);
> +		return -EBUSY;
> +	}
>  	req->state = MEDIA_REQUEST_STATE_CLEANING;
>  	spin_unlock_irqrestore(&req->lock, flags);
>  
> @@ -313,6 +322,7 @@ int media_request_alloc(struct media_device *mdev, int *alloc_fd)
>  	spin_lock_init(&req->lock);
>  	init_waitqueue_head(&req->poll_wait);
>  	req->updating_count = 0;
> +	req->access_count = 0;
>  
>  	*alloc_fd = fd;
>  
> diff --git a/include/media/media-request.h b/include/media/media-request.h
> index ac02019c1d77..707c7577f46d 100644
> --- a/include/media/media-request.h
> +++ b/include/media/media-request.h
> @@ -53,6 +53,7 @@ struct media_request_object;
>   * @debug_str: Prefix for debug messages (process name:fd)
>   * @state: The state of the request
>   * @updating_count: count the number of request updates that are in progress
> + * @access_count: count the number of request accesses that are in progress
>   * @objects: List of @struct media_request_object request objects
>   * @num_incomplete_objects: The number of incomplete objects in the request
>   * @poll_wait: Wait queue for poll
> @@ -64,6 +65,7 @@ struct media_request {
>  	char debug_str[TASK_COMM_LEN + 11];
>  	enum media_request_state state;
>  	unsigned int updating_count;
> +	unsigned int access_count;
>  	struct list_head objects;
>  	unsigned int num_incomplete_objects;
>  	struct wait_queue_head poll_wait;
> @@ -72,6 +74,50 @@ struct media_request {
>  
>  #ifdef CONFIG_MEDIA_CONTROLLER
>  
> +/**
> + * media_request_lock_for_access - Lock the request to access its objects
> + *
> + * @req: The media request
> + *
> + * Use before accessing a completed request. A reference to the request must
> + * be held during the access. This usually takes place automatically through
> + * a file handle. Use @media_request_unlock_for_access when done.
> + */
> +static inline int __must_check
> +media_request_lock_for_access(struct media_request *req)
> +{
> +	unsigned long flags;
> +	int ret = -EBUSY;
> +
> +	spin_lock_irqsave(&req->lock, flags);
> +	if (req->state == MEDIA_REQUEST_STATE_COMPLETE) {
> +		req->access_count++;
> +		ret = 0;
> +	}
> +	spin_unlock_irqrestore(&req->lock, flags);
> +
> +	return ret;
> +}
> +
> +/**
> + * media_request_unlock_for_access - Unlock a request previously locked for
> + *				     access
> + *
> + * @req: The media request
> + *
> + * Unlock a request that has previously been locked using
> + * @media_request_lock_for_access.
> + */
> +static inline void media_request_unlock_for_access(struct media_request *req)
> +{
> +	unsigned long flags;
> +
> +	spin_lock_irqsave(&req->lock, flags);
> +	if (!WARN_ON(!req->access_count))
> +		req->access_count--;
> +	spin_unlock_irqrestore(&req->lock, flags);
> +}
> +
>  /**
>   * media_request_lock_for_update - Lock the request for updating its objects
>   *
> 

I also need to add *_for_access() stub functions that are used when the MEDIA_CONTROLLER
is not set in the kernel config.

I've fixed this in my tree.

Regards,

	Hans
