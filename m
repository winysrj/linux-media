Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud7.xs4all.net ([194.109.24.28]:38803 "EHLO
        lb2-smtp-cloud7.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1754623AbeFOHJB (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 15 Jun 2018 03:09:01 -0400
Subject: Re: [PATCHv15 02/35] media-request: implement media requests
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>
References: <20180604114648.26159-1-hverkuil@xs4all.nl>
 <20180604114648.26159-3-hverkuil@xs4all.nl>
Message-ID: <d394794c-3db3-6748-e5d3-605a3c028917@xs4all.nl>
Date: Fri, 15 Jun 2018 09:08:55 +0200
MIME-Version: 1.0
In-Reply-To: <20180604114648.26159-3-hverkuil@xs4all.nl>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 04/06/18 13:46, Hans Verkuil wrote:
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
>  drivers/media/media-request.c | 421 ++++++++++++++++++++++++++++++++++
>  include/media/media-device.h  |  24 ++
>  include/media/media-request.h | 326 ++++++++++++++++++++++++++
>  5 files changed, 787 insertions(+), 1 deletion(-)
>  create mode 100644 drivers/media/media-request.c
>  create mode 100644 include/media/media-request.h
> 

<snip>

> diff --git a/include/media/media-request.h b/include/media/media-request.h
> new file mode 100644
> index 000000000000..8acd2627835c
> --- /dev/null
> +++ b/include/media/media-request.h
> @@ -0,0 +1,326 @@

<snip>

> +/**
> + * struct media_request - Media device request
> + * @mdev: Media device this request belongs to
> + * @kref: Reference count
> + * @debug_str: Prefix for debug messages (process name:fd)
> + * @state: The state of the request
> + * @updating_count: count the number of request updates that are in progress
> + * @objects: List of @struct media_request_object request objects
> + * @num_incomplete_objects: The number of incomplete objects in the request
> + * @poll_wait: Wait queue for poll
> + * @lock: Serializes access to this struct
> + */
> +struct media_request {
> +	struct media_device *mdev;
> +	struct kref kref;
> +	char debug_str[TASK_COMM_LEN + 11];
> +	enum media_request_state state;
> +	refcount_t updating_count;

This will be replaced by unsigned int: it turns out that if CONFIG_REFCOUNT_FULL is set,
the refcount implementation will complain when you increase the refcount from 0 to 1
since it expects that refcount_t it used as it is in kref. Since updating_count is
protected by the spinlock anyway there is no need to use refcount_t, a simple
unsigned int works just as well.

Regards,

	Hans

> +	struct list_head objects;
> +	unsigned int num_incomplete_objects;
> +	struct wait_queue_head poll_wait;
> +	spinlock_t lock;
> +};
