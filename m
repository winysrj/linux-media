Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud7.xs4all.net ([194.109.24.24]:48979 "EHLO
        lb1-smtp-cloud7.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1732324AbeHNQUZ (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 14 Aug 2018 12:20:25 -0400
Subject: Re: [PATCHv17 03/34] media-request: implement media requests
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>
References: <20180804124526.46206-1-hverkuil@xs4all.nl>
 <20180804124526.46206-4-hverkuil@xs4all.nl>
Message-ID: <40060404-abe2-ae5c-d4ca-f01d17316eb5@xs4all.nl>
Date: Tue, 14 Aug 2018 15:33:11 +0200
MIME-Version: 1.0
In-Reply-To: <20180804124526.46206-4-hverkuil@xs4all.nl>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 04/08/18 14:44, Hans Verkuil wrote:
> From: Hans Verkuil <hans.verkuil@cisco.com>
> 
> Add initial media request support:
> 
> 1) Add MEDIA_IOC_REQUEST_ALLOC ioctl support to media-device.c
> 2) Add struct media_request to store request objects.
> 3) Add struct media_request_object to represent a request object.
> 4) Add MEDIA_REQUEST_IOC_QUEUE/REINIT ioctl support.
> 
> Basic lifecycle: the application allocates a request, adds
> objects to it, queues the request, polls until it is completed
> and can then read the final values of the objects at the time
> of completion. When it closes the file descriptor the request
> memory will be freed (actually, when the last user of that request
> releases the request).
> 
> Drivers will bind an object to a request (the 'adds objects to it'
> phase), when MEDIA_REQUEST_IOC_QUEUE is called the request is
> validated (req_validate op), then queued (the req_queue op).
> 
> When done with an object it can either be unbound from the request
> (e.g. when the driver has finished with a vb2 buffer) or marked as
> completed (e.g. for controls associated with a buffer). When all
> objects in the request are completed (or unbound), then the request
> fd will signal an exception (poll).
> 
> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
> Co-developed-by: Sakari Ailus <sakari.ailus@linux.intel.com>
> Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
> Co-developed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> Co-developed-by: Alexandre Courbot <acourbot@chromium.org>
> ---
>  drivers/media/Makefile        |   3 +-
>  drivers/media/media-device.c  |  14 ++
>  drivers/media/media-request.c | 423 ++++++++++++++++++++++++++++++++++
>  include/media/media-device.h  |  21 ++
>  include/media/media-request.h | 327 ++++++++++++++++++++++++++
>  5 files changed, 787 insertions(+), 1 deletion(-)
>  create mode 100644 drivers/media/media-request.c
>  create mode 100644 include/media/media-request.h
> 

<snip>

> +static long media_request_ioctl_queue(struct media_request *req)
> +{
> +	struct media_device *mdev = req->mdev;
> +	enum media_request_state state;
> +	unsigned long flags;
> +	int ret;
> +
> +	dev_dbg(mdev->dev, "request: queue %s\n", req->debug_str);
> +
> +	/*
> +	 * Ensure the request that is validated will be the one that gets queued
> +	 * next by serialising the queueing process. This mutex is also used
> +	 * to serialize with canceling a vb2 queue and with setting values such
> +	 * as controls in a request.
> +	 */
> +	mutex_lock(&mdev->req_queue_mutex);
> +
> +	media_request_get(req);

Here we get a reference to the request...

> +
> +	spin_lock_irqsave(&req->lock, flags);
> +	if (req->state == MEDIA_REQUEST_STATE_IDLE)
> +		req->state = MEDIA_REQUEST_STATE_VALIDATING;
> +	state = req->state;
> +	spin_unlock_irqrestore(&req->lock, flags);
> +	if (state != MEDIA_REQUEST_STATE_VALIDATING) {
> +		dev_dbg(mdev->dev,
> +			"request: unable to queue %s, request in state %s\n",
> +			req->debug_str, media_request_state_str(state));

...but we didn't put it again in this error path. Thus this request is never
released.

Fixed by adding a media_request_put(req) here.

Found with v4l2-compliance.

> +		mutex_unlock(&mdev->req_queue_mutex);
> +		return -EBUSY;
> +	}
> +
> +	ret = mdev->ops->req_validate(req);
> +
> +	/*
> +	 * If the req_validate was successful, then we mark the state as QUEUED
> +	 * and call req_queue. The reason we set the state first is that this
> +	 * allows req_queue to unbind or complete the queued objects in case
> +	 * they are immediately 'consumed'. State changes from QUEUED to another
> +	 * state can only happen if either the driver changes the state or if
> +	 * the user cancels the vb2 queue. The driver can only change the state
> +	 * after each object is queued through the req_queue op (and note that
> +	 * that op cannot fail), so setting the state to QUEUED up front is
> +	 * safe.
> +	 *
> +	 * The other reason for changing the state is if the vb2 queue is
> +	 * canceled, and that uses the req_queue_mutex which is still locked
> +	 * while req_queue is called, so that's safe as well.
> +	 */
> +	spin_lock_irqsave(&req->lock, flags);
> +	req->state = ret ? MEDIA_REQUEST_STATE_IDLE
> +			 : MEDIA_REQUEST_STATE_QUEUED;
> +	spin_unlock_irqrestore(&req->lock, flags);
> +
> +	if (!ret)
> +		mdev->ops->req_queue(req);
> +
> +	mutex_unlock(&mdev->req_queue_mutex);
> +
> +	if (ret) {
> +		dev_dbg(mdev->dev, "request: can't queue %s (%d)\n",
> +			req->debug_str, ret);
> +		media_request_put(req);
> +	}
> +
> +	return ret;
> +}

Regards,

	Hans
