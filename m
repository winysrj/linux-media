Return-path: <linux-media-owner@vger.kernel.org>
Received: from osg.samsung.com ([64.30.133.232]:52786 "EHLO osg.samsung.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751774AbeDJKcN (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 10 Apr 2018 06:32:13 -0400
Date: Tue, 10 Apr 2018 07:32:06 -0300
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org, Hans Verkuil <hans.verkuil@cisco.com>
Subject: Re: [RFCv11 PATCH 04/29] media-request: core request support
Message-ID: <20180410073206.12d4c67d@vento.lan>
In-Reply-To: <20180409142026.19369-5-hverkuil@xs4all.nl>
References: <20180409142026.19369-1-hverkuil@xs4all.nl>
        <20180409142026.19369-5-hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Mon,  9 Apr 2018 16:20:01 +0200
Hans Verkuil <hverkuil@xs4all.nl> escreveu:

> From: Hans Verkuil <hans.verkuil@cisco.com>
> 
> Implement the core of the media request processing.
> 
> Drivers can bind request objects to a request. These objects
> can then be marked completed if the driver finished using them,
> or just be unbound if the results do not need to be kept (e.g.
> in the case of buffers).
> 
> Once all objects that were added are either unbound or completed,
> the request is marked 'complete' and a POLLPRI signal is sent
> via poll.
> 
> Both requests and request objects are refcounted.
> 
> While a request is queued its refcount is incremented (since it
> is in use by a driver). Once it is completed the refcount is
> decremented. When the user closes the request file descriptor
> the refcount is also decremented. Once it reaches 0 all request
> objects in the request are unbound and put() and the request
> itself is freed.
> 
> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
> ---
>  drivers/media/media-request.c | 284 +++++++++++++++++++++++++++++++++++++++++-
>  include/media/media-request.h | 156 +++++++++++++++++++++++
>  2 files changed, 439 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/media/media-request.c b/drivers/media/media-request.c
> index ead78613fdbe..dffc290e4ada 100644
> --- a/drivers/media/media-request.c
> +++ b/drivers/media/media-request.c
> @@ -16,8 +16,290 @@
>  #include <media/media-device.h>
>  #include <media/media-request.h>
>  
> +static const char * const request_state[] = {
> +	"idle",
> +	"queueing",
> +	"queued",
> +	"complete",
> +	"cleaning",
> +};

Please use c99 designated inits here, e. g.:

static const char * const request_state[] = {
	[MEDIA_REQUEST_STATE_IDLE] = "idle",
	...
};

> +
> +static const char *
> +media_request_state_str(enum media_request_state state)
> +{
> +	if (WARN_ON(state >= ARRAY_SIZE(request_state)))
> +		return "unknown";
> +	return request_state[state];
> +}
> +
> +static void media_request_clean(struct media_request *req)
> +{
> +	struct media_request_object *obj, *obj_safe;
> +
> +	WARN_ON(req->state != MEDIA_REQUEST_STATE_CLEANING);
> +
> +	list_for_each_entry_safe(obj, obj_safe, &req->objects, list) {
> +		media_request_object_unbind(obj);
> +		media_request_object_put(obj);
> +	}
> +
> +	req->num_incomplete_objects = 0;
> +	wake_up_interruptible(&req->poll_wait);
> +}
> +
> +static void media_request_release(struct kref *kref)
> +{
> +	struct media_request *req =
> +		container_of(kref, struct media_request, kref);
> +	struct media_device *mdev = req->mdev;
> +	unsigned long flags;
> +
> +	dev_dbg(mdev->dev, "request: release %s\n", req->debug_str);
> +
> +	spin_lock_irqsave(&req->lock, flags);
> +	req->state = MEDIA_REQUEST_STATE_CLEANING;
> +	spin_unlock_irqrestore(&req->lock, flags);
> +
> +	media_request_clean(req);
> +
> +	if (mdev->ops->req_free)
> +		mdev->ops->req_free(req);
> +	else
> +		kfree(req);

Without looking at req_free() implementation, I would actually prefer
to always do a kfree(req) here. So, a req_free() function would only
free "extra" allocations, and not the request itself. e. g.:

...
	if (mdev->ops->req_free)
		mdev->ops->req_free(req);

	kfree(req);
}


> +}
> +
> +void media_request_put(struct media_request *req)
> +{
> +	kref_put(&req->kref, media_request_release);
> +}
> +EXPORT_SYMBOL_GPL(media_request_put);
> +
> +void media_request_cancel(struct media_request *req)
> +{
> +	struct media_request_object *obj, *obj_safe;
> +
> +	if (req->state != MEDIA_REQUEST_STATE_QUEUED)
> +		return;
> +
> +	list_for_each_entry_safe(obj, obj_safe, &req->objects, list)
> +		if (obj->ops->cancel)
> +			obj->ops->cancel(obj);
> +}
> +EXPORT_SYMBOL_GPL(media_request_cancel);
> +
> +static int media_request_close(struct inode *inode, struct file *filp)
> +{
> +	struct media_request *req = filp->private_data;
> +
> +	media_request_put(req);
> +	return 0;
> +}
> +
> +static unsigned int media_request_poll(struct file *filp,
> +				       struct poll_table_struct *wait)
> +{
> +	struct media_request *req = filp->private_data;
> +	unsigned long flags;
> +	enum media_request_state state;
> +
> +	if (!(poll_requested_events(wait) & POLLPRI))
> +		return 0;
> +
> +	spin_lock_irqsave(&req->lock, flags);
> +	state = req->state;
> +	spin_unlock_irqrestore(&req->lock, flags);

IMO, it would be better to use an atomic var for state, having a
lockless access to it.

> +
> +	if (state == MEDIA_REQUEST_STATE_COMPLETE)
> +		return POLLPRI;
> +	if (state == MEDIA_REQUEST_STATE_IDLE)
> +		return POLLERR;
> +
> +	poll_wait(filp, &req->poll_wait, wait);
> +	return 0;
> +}
> +
> +static long media_request_ioctl(struct file *filp, unsigned int cmd,
> +				unsigned long __arg)
> +{
> +	return -ENOIOCTLCMD;
> +}
> +
> +static const struct file_operations request_fops = {
> +	.owner = THIS_MODULE,
> +	.poll = media_request_poll,
> +	.unlocked_ioctl = media_request_ioctl,
> +	.release = media_request_close,
> +};
> +
>  int media_request_alloc(struct media_device *mdev,
>  			struct media_request_alloc *alloc)
>  {
> -	return -ENOMEM;
> +	struct media_request *req;
> +	struct file *filp;
> +	char comm[TASK_COMM_LEN];
> +	int fd;
> +	int ret;
> +
> +	fd = get_unused_fd_flags(O_CLOEXEC);
> +	if (fd < 0)
> +		return fd;
> +
> +	filp = anon_inode_getfile("request", &request_fops, NULL, O_CLOEXEC);
> +	if (IS_ERR(filp)) {
> +		ret = PTR_ERR(filp);
> +		goto err_put_fd;
> +	}
> +
> +	if (mdev->ops->req_alloc)
> +		req = mdev->ops->req_alloc(mdev);
> +	else
> +		req = kzalloc(sizeof(*req), GFP_KERNEL);
> +	if (!req) {
> +		ret = -ENOMEM;
> +		goto err_fput;
> +	}
> +
> +	filp->private_data = req;
> +	req->mdev = mdev;
> +	req->state = MEDIA_REQUEST_STATE_IDLE;
> +	req->num_incomplete_objects = 0;
> +	kref_init(&req->kref);
> +	INIT_LIST_HEAD(&req->objects);
> +	spin_lock_init(&req->lock);
> +	init_waitqueue_head(&req->poll_wait);
> +
> +	alloc->fd = fd;

Btw, this is a very good reason why you should define the ioctl to
have an integer argument instead of a struct with a __s32 field
on it, as per my comment to patch 02/29:

	#define MEDIA_IOC_REQUEST_ALLOC	_IOWR('|', 0x05, int)

At 64 bit architectures, you're truncating the file descriptor!

> +	get_task_comm(comm, current);
> +	snprintf(req->debug_str, sizeof(req->debug_str), "%s:%d",
> +		 comm, fd);

Not sure if it is a good idea to store the task that allocated
the request. While it makes sense for the dev_dbg() below, it
may not make sense anymore on other dev_dbg() you would be
using it.

> +	dev_dbg(mdev->dev, "request: allocated %s\n", req->debug_str);
> +
> +	fd_install(fd, filp);
> +
> +	return 0;
> +
> +err_fput:
> +	fput(filp);
> +
> +err_put_fd:
> +	put_unused_fd(fd);
> +
> +	return ret;
> +}
> +
> +static void media_request_object_release(struct kref *kref)
> +{
> +	struct media_request_object *obj =
> +		container_of(kref, struct media_request_object, kref);
> +	struct media_request *req = obj->req;
> +
> +	if (req)
> +		media_request_object_unbind(obj);
> +	obj->ops->release(obj);
> +}
> +
> +void media_request_object_put(struct media_request_object *obj)
> +{
> +	kref_put(&obj->kref, media_request_object_release);
> +}
> +EXPORT_SYMBOL_GPL(media_request_object_put);
> +
> +void media_request_object_init(struct media_request_object *obj)
> +{
> +	obj->ops = NULL;
> +	obj->req = NULL;
> +	obj->priv = NULL;
> +	obj->completed = false;
> +	INIT_LIST_HEAD(&obj->list);
> +	kref_init(&obj->kref);
> +}
> +EXPORT_SYMBOL_GPL(media_request_object_init);
> +
> +void media_request_object_bind(struct media_request *req,
> +			       const struct media_request_object_ops *ops,
> +			       void *priv,
> +			       struct media_request_object *obj)
> +{
> +	unsigned long flags;
> +
> +	if (WARN_ON(!ops->release || !ops->cancel))
> +		return;
> +
> +	obj->req = req;
> +	obj->ops = ops;
> +	obj->priv = priv;
> +	spin_lock_irqsave(&req->lock, flags);
> +	if (WARN_ON(req->state != MEDIA_REQUEST_STATE_IDLE))
> +		goto unlock;
> +	list_add_tail(&obj->list, &req->objects);
> +	req->num_incomplete_objects++;
> +unlock:
> +	spin_unlock_irqrestore(&req->lock, flags);
> +}
> +EXPORT_SYMBOL_GPL(media_request_object_bind);
> +
> +void media_request_object_unbind(struct media_request_object *obj)
> +{
> +	struct media_request *req = obj->req;
> +	unsigned long flags;
> +	bool completed = false;
> +
> +	if (!req)
> +		return;
> +
> +	spin_lock_irqsave(&req->lock, flags);
> +	list_del(&obj->list);
> +	obj->req = NULL;
> +
> +	if (req->state == MEDIA_REQUEST_STATE_COMPLETE ||
> +	    req->state == MEDIA_REQUEST_STATE_CLEANING)
> +		goto unlock;
> +
> +	if (WARN_ON(req->state == MEDIA_REQUEST_STATE_QUEUEING))
> +		goto unlock;
> +
> +	if (WARN_ON(!req->num_incomplete_objects))
> +		goto unlock;
> +
> +	req->num_incomplete_objects--;
> +	if (req->state == MEDIA_REQUEST_STATE_QUEUED &&
> +	    !req->num_incomplete_objects) {
> +		req->state = MEDIA_REQUEST_STATE_COMPLETE;
> +		completed = true;
> +		wake_up_interruptible(&req->poll_wait);
> +	}
> +unlock:
> +	spin_unlock_irqrestore(&req->lock, flags);
> +	if (obj->ops->unbind)
> +		obj->ops->unbind(obj);
> +	if (completed)
> +		media_request_put(req);
> +}
> +EXPORT_SYMBOL_GPL(media_request_object_unbind);
> +
> +void media_request_object_complete(struct media_request_object *obj)
> +{
> +	struct media_request *req = obj->req;
> +	unsigned long flags;
> +	bool completed = false;
> +
> +	spin_lock_irqsave(&req->lock, flags);
> +	if (obj->completed)
> +		goto unlock;
> +	obj->completed = true;
> +	if (WARN_ON(!req->num_incomplete_objects) ||
> +	    WARN_ON(req->state != MEDIA_REQUEST_STATE_QUEUED))
> +		goto unlock;
> +
> +	if (!--req->num_incomplete_objects) {
> +		req->state = MEDIA_REQUEST_STATE_COMPLETE;
> +		wake_up_interruptible(&req->poll_wait);
> +		completed = true;
> +	}
> +unlock:
> +	spin_unlock_irqrestore(&req->lock, flags);
> +	if (completed)
> +		media_request_put(req);
>  }
> +EXPORT_SYMBOL_GPL(media_request_object_complete);
> diff --git a/include/media/media-request.h b/include/media/media-request.h
> index dae3eccd9aa7..082c3cae04ac 100644
> --- a/include/media/media-request.h
> +++ b/include/media/media-request.h
> @@ -16,7 +16,163 @@
>  
>  #include <media/media-device.h>
>  
> +enum media_request_state {
> +	MEDIA_REQUEST_STATE_IDLE,
> +	MEDIA_REQUEST_STATE_QUEUEING,
> +	MEDIA_REQUEST_STATE_QUEUED,
> +	MEDIA_REQUEST_STATE_COMPLETE,
> +	MEDIA_REQUEST_STATE_CLEANING,
> +};
> +
> +struct media_request_object;
> +
> +/**
> + * struct media_request - Media device request
> + * @mdev: Media device this request belongs to
> + * @kref: Reference count
> + * @debug_prefix: Prefix for debug messages (process name:fd)
> + * @state: The state of the request
> + * @objects: List of @struct media_request_object request objects
> + * @num_objects: The number objects in the request
> + * @num_completed_objects: The number of completed objects in the request

This doesn't match any var...

> + * @poll_wait: Wait queue for poll
> + * @lock: Serializes access to this struct
> + */
> +struct media_request {
> +	struct media_device *mdev;
> +	struct kref kref;
> +	char debug_str[TASK_COMM_LEN + 11];
> +	enum media_request_state state;
> +	struct list_head objects;
> +	unsigned int num_incomplete_objects;

... as it seems that you decide to count incomplete objects, instead
of complete ones.

> +	struct wait_queue_head poll_wait;
> +	spinlock_t lock;
> +};
> +
> +#ifdef CONFIG_MEDIA_CONTROLLER
> +
> +static inline void media_request_get(struct media_request *req)
> +{
> +	kref_get(&req->kref);
> +}
> +
> +void media_request_put(struct media_request *req);
> +void media_request_cancel(struct media_request *req);
> +
>  int media_request_alloc(struct media_device *mdev,
>  			struct media_request_alloc *alloc);
> +#else
> +static inline void media_request_get(struct media_request *req)
> +{
> +}
> +
> +static inline void media_request_put(struct media_request *req)
> +{
> +}
> +
> +static inline void media_request_cancel(struct media_request *req)
> +{
> +}
> +
> +#endif
> +
> +struct media_request_object_ops {
> +	int (*prepare)(struct media_request_object *object);
> +	void (*unprepare)(struct media_request_object *object);
> +	void (*queue)(struct media_request_object *object);
> +	void (*unbind)(struct media_request_object *object);
> +	void (*cancel)(struct media_request_object *object);
> +	void (*release)(struct media_request_object *object);
> +};

-ENODESCRIPTION. Please describe the struct and its fields.

> +
> +/**
> + * struct media_request_object - An opaque object that belongs to a media
> + *				 request
> + *
> + * @priv: object's priv pointer
> + * @list: List entry of the object for @struct media_request
> + * @kref: Reference count of the object, acquire before releasing req->lock

Field descriptions missing.

> + *
> + * An object related to the request. This struct is embedded in the
> + * larger object data.
> + */
> +struct media_request_object {
> +	const struct media_request_object_ops *ops;
> +	void *priv;
> +	struct media_request *req;
> +	struct list_head list;
> +	struct kref kref;
> +	bool completed;
> +};
> +
> +#ifdef CONFIG_MEDIA_CONTROLLER
> +static inline void media_request_object_get(struct media_request_object *obj)
> +{
> +	kref_get(&obj->kref);
> +}

Why do you need a function? Just use kref_get() were needed, instead of
aliasing it for no good reason.

> +
> +/**
> + * media_request_object_put - Put a media request object
> + *
> + * @obj: The object
> + *
> + * Put a media request object. Once all references are gone, the
> + * object's memory is released.
> + */
> +void media_request_object_put(struct media_request_object *obj);
> +
> +/**
> + * media_request_object_init - Initialise a media request object
> + *
> + * Initialise a media request object. The object will be released using the
> + * release callback of the ops once it has no references (this function
> + * initialises references to one).
> + */
> +void media_request_object_init(struct media_request_object *obj);
> +
> +/**
> + * media_request_object_bind - Bind a media request object to a request
> + */
> +void media_request_object_bind(struct media_request *req,
> +			       const struct media_request_object_ops *ops,
> +			       void *priv,
> +			       struct media_request_object *obj);
> +
> +void media_request_object_unbind(struct media_request_object *obj);
> +
> +/**
> + * media_request_object_complete - Mark the media request object as complete
> + */
> +void media_request_object_complete(struct media_request_object *obj);

The kernel-doc tags there are wrong: They don't describe the function
arguments.

Please validate it with sphinx to be sure that everything is ok.

> +#else
> +static inline void media_request_object_get(struct media_request_object *obj)
> +{
> +}
> +
> +static inline void media_request_object_put(struct media_request_object *obj)
> +{
> +}
> +
> +static inline void media_request_object_init(struct media_request_object *obj)
> +{
> +	obj->ops = NULL;
> +	obj->req = NULL;
> +}
> +
> +static inline void media_request_object_bind(struct media_request *req,
> +			       const struct media_request_object_ops *ops,
> +			       void *priv,
> +			       struct media_request_object *obj)
> +{
> +}
> +
> +static inline void media_request_object_unbind(struct media_request_object *obj)
> +{
> +}
> +
> +static inline void media_request_object_complete(struct media_request_object *obj)
> +{
> +}
> +#endif
>  
>  #endif



Thanks,
Mauro
