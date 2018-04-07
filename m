Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud8.xs4all.net ([194.109.24.29]:60025 "EHLO
        lb3-smtp-cloud8.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751064AbeDGI5e (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 7 Apr 2018 04:57:34 -0400
Subject: Re: [RFCv9 PATCH 04/29] media-request: core request support
To: Sakari Ailus <sakari.ailus@linux.intel.com>
Cc: linux-media@vger.kernel.org, Tomasz Figa <tfiga@google.com>,
        Alexandre Courbot <acourbot@chromium.org>,
        Gustavo Padovan <gustavo@padovan.org>,
        Hans Verkuil <hans.verkuil@cisco.com>
References: <20180328135030.7116-1-hverkuil@xs4all.nl>
 <20180328135030.7116-5-hverkuil@xs4all.nl>
 <20180406203524.pjyqq3paua2cpqey@kekkonen.localdomain>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <983c6c54-e268-065c-f2ce-a48e6ab79925@xs4all.nl>
Date: Sat, 7 Apr 2018 10:57:31 +0200
MIME-Version: 1.0
In-Reply-To: <20180406203524.pjyqq3paua2cpqey@kekkonen.localdomain>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 06/04/18 22:35, Sakari Ailus wrote:
> Hi Hans,
> 
> Thanks for your work on this. A few comments below...
> 
> On Wed, Mar 28, 2018 at 03:50:05PM +0200, Hans Verkuil wrote:
>> From: Hans Verkuil <hans.verkuil@cisco.com>
>>
>> Implement the core of the media request processing.
>>
>> Drivers can bind request objects to a request. These objects
>> can then be marked completed if the driver finished using them,
>> or just be unbound if the results do not need to be kept (e.g.
>> in the case of buffers).
>>
>> Once all objects that were added are either unbound or completed,
>> the request is marked 'complete' and a POLLPRI signal is sent
>> via poll.
>>
>> Both requests and request objects are refcounted.
>>
>> While a request is queued its refcount is incremented (since it
>> is in use by a driver). Once it is completed the refcount is
>> decremented. When the user closes the request file descriptor
>> the refcount is also decremented. Once it reaches 0 all request
>> objects in the request are unbound and put() and the request
>> itself is freed.
>>
>> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
>> ---
>>  drivers/media/media-request.c | 269 +++++++++++++++++++++++++++++++++++++++++-
>>  include/media/media-request.h | 148 +++++++++++++++++++++++
>>  2 files changed, 416 insertions(+), 1 deletion(-)
>>
>> diff --git a/drivers/media/media-request.c b/drivers/media/media-request.c
>> index ead78613fdbe..8135d9d32af9 100644
>> --- a/drivers/media/media-request.c
>> +++ b/drivers/media/media-request.c
>> @@ -16,8 +16,275 @@
>>  #include <media/media-device.h>
>>  #include <media/media-request.h>
>>  
>> +static const char * const request_state[] = {
>> +	"idle",
>> +	"queueing",
>> +	"queued",
>> +	"complete",
>> +	"cleaning",
>> +};
>> +
>> +static const char *
>> +media_request_state_str(enum media_request_state state)
>> +{
>> +	if (WARN_ON(state >= ARRAY_SIZE(request_state)))
>> +		return "unknown";
>> +	return request_state[state];
>> +}
>> +
>> +static void media_request_clean(struct media_request *req)
>> +{
>> +	struct media_request_object *obj, *obj_safe;
>> +
>> +	WARN_ON(req->state != MEDIA_REQUEST_STATE_CLEANING);
>> +
>> +	list_for_each_entry_safe(obj, obj_safe, &req->objects, list) {
>> +		media_request_object_unbind(obj);
>> +		media_request_object_put(obj);
>> +	}
>> +
>> +	req->num_incomplete_objects = 0;
>> +	wake_up_interruptible(&req->poll_wait);
>> +}
>> +
>> +static void media_request_release(struct kref *kref)
>> +{
>> +	struct media_request *req =
>> +		container_of(kref, struct media_request, kref);
>> +	struct media_device *mdev = req->mdev;
>> +	unsigned long flags;
>> +
>> +	dev_dbg(mdev->dev, "request: release %s\n", req->debug_str);
>> +
>> +	spin_lock_irqsave(&req->lock, flags);
>> +	req->state = MEDIA_REQUEST_STATE_CLEANING;
>> +	spin_unlock_irqrestore(&req->lock, flags);
>> +
>> +	media_request_clean(req);
>> +
>> +	if (mdev->ops->req_free)
>> +		mdev->ops->req_free(req);
>> +	else
>> +		kfree(req);
>> +}
>> +
>> +void media_request_put(struct media_request *req)
>> +{
>> +	kref_put(&req->kref, media_request_release);
>> +}
>> +EXPORT_SYMBOL_GPL(media_request_put);
>> +
>> +static int media_request_close(struct inode *inode, struct file *filp)
>> +{
>> +	struct media_request *req = filp->private_data;
>> +
>> +	media_request_put(req);
> 
> One more newline?
> 
>> +	return 0;
>> +}
>> +
>> +static unsigned int media_request_poll(struct file *filp,
>> +				       struct poll_table_struct *wait)
>> +{
>> +	struct media_request *req = filp->private_data;
>> +	unsigned long flags;
>> +	enum media_request_state state;
>> +
>> +	if (!(poll_requested_events(wait) & POLLPRI))
>> +		return 0;
>> +
>> +	spin_lock_irqsave(&req->lock, flags);
>> +	state = req->state;
>> +	spin_unlock_irqrestore(&req->lock, flags);
>> +
>> +	if (state == MEDIA_REQUEST_STATE_COMPLETE)
>> +		return POLLPRI;
>> +	if (state == MEDIA_REQUEST_STATE_IDLE)
> 
> Should this be
> 
> 	if (state != MEDIA_REQUEST_STATE_QUEUED)

Good question. I'll take another look at this.

> 
> ? (Also see my other comment on the QUEUEING state below.)
> 
>> +		return POLLERR;
>> +
>> +	poll_wait(filp, &req->poll_wait, wait);
> 
> Newline?
> 
>> +	return 0;
>> +}
>> +
>> +static long media_request_ioctl(struct file *filp, unsigned int cmd,
>> +				unsigned long __arg)
>> +{
>> +	return -ENOIOCTLCMD;
>> +}
>> +
>> +static const struct file_operations request_fops = {
>> +	.owner = THIS_MODULE,
>> +	.poll = media_request_poll,
>> +	.unlocked_ioctl = media_request_ioctl,
>> +	.release = media_request_close,
>> +};
>> +
>>  int media_request_alloc(struct media_device *mdev,
>>  			struct media_request_alloc *alloc)
>>  {
>> -	return -ENOMEM;
>> +	struct media_request *req;
>> +	struct file *filp;
>> +	char comm[TASK_COMM_LEN];
>> +	int fd;
>> +	int ret;
>> +
>> +	fd = get_unused_fd_flags(O_CLOEXEC);
>> +	if (fd < 0)
>> +		return fd;
>> +
>> +	filp = anon_inode_getfile("request", &request_fops, NULL, O_CLOEXEC);
>> +	if (IS_ERR(filp)) {
>> +		ret = PTR_ERR(filp);
>> +		goto err_put_fd;
>> +	}
>> +
>> +	if (mdev->ops->req_alloc)
>> +		req = mdev->ops->req_alloc(mdev);
>> +	else
>> +		req = kzalloc(sizeof(*req), GFP_KERNEL);
>> +	if (!req) {
>> +		ret = -ENOMEM;
>> +		goto err_fput;
>> +	}
>> +
>> +	filp->private_data = req;
>> +	req->mdev = mdev;
>> +	req->state = MEDIA_REQUEST_STATE_IDLE;
>> +	req->num_incomplete_objects = 0;
>> +	kref_init(&req->kref);
>> +	INIT_LIST_HEAD(&req->objects);
>> +	spin_lock_init(&req->lock);
>> +	init_waitqueue_head(&req->poll_wait);
>> +
>> +	alloc->fd = fd;
>> +
>> +	get_task_comm(comm, current);
>> +	snprintf(req->debug_str, sizeof(req->debug_str), "%s:%d",
>> +		 comm, fd);
>> +	dev_dbg(mdev->dev, "request: allocated %s\n", req->debug_str);
>> +
>> +	fd_install(fd, filp);
>> +
>> +	return 0;
>> +
>> +err_fput:
>> +	fput(filp);
>> +
>> +err_put_fd:
>> +	put_unused_fd(fd);
>> +
>> +	return ret;
>> +}
>> +
>> +static void media_request_object_release(struct kref *kref)
>> +{
>> +	struct media_request_object *obj =
>> +		container_of(kref, struct media_request_object, kref);
>> +	struct media_request *req = obj->req;
>> +
>> +	if (req)
>> +		media_request_object_unbind(obj);
> 
> Newline?
> 
>> +	obj->ops->release(obj);
>> +}
>> +
>> +void media_request_object_put(struct media_request_object *obj)
>> +{
>> +	kref_put(&obj->kref, media_request_object_release);
>> +}
>> +EXPORT_SYMBOL_GPL(media_request_object_put);
>> +
>> +void media_request_object_init(struct media_request_object *obj)
>> +{
>> +	obj->ops = NULL;
>> +	obj->req = NULL;
>> +	obj->priv = NULL;
>> +	obj->completed = false;
> 
> The function is intended to be used on a freshly allocated object only. The
> allocation function should already zero the memory, so there should be no
> need to do this here anymore.

Actually, that's not true. struct vb2_buffer contains struct media_request_object
but it is only allocated when you allocate the buffers, after that this has to
be initialized every time you queue or prepare a buffer for a request.

It's probably true for everything else though, but buffers are the exception.

> 
>> +	INIT_LIST_HEAD(&obj->list);
> 
> There's no need to init this as it's a member of a list, not a head.
> 
>> +	kref_init(&obj->kref);
>> +}
>> +EXPORT_SYMBOL_GPL(media_request_object_init);
>> +
>> +void media_request_object_bind(struct media_request *req,
>> +			       const struct media_request_object_ops *ops,
>> +			       void *priv,
>> +			       struct media_request_object *obj)
>> +{
>> +	unsigned long flags;
>> +
>> +	WARN_ON(!ops->release);
>> +	obj->req = req;
>> +	obj->ops = ops;
>> +	obj->priv = priv;
>> +	spin_lock_irqsave(&req->lock, flags);
>> +	if (WARN_ON(req->state != MEDIA_REQUEST_STATE_IDLE))
> 
> How do you find out that a request is not in an idle state? I'd say you
> can't be sure otherwise as a request may be queued whilst another process
> is binding an object to it. I think the check here should be used prevent
> that.

??? If a request is being queued then the state is QUEUEING and you cannot
bind this object due to the test above. That's also the reason for having the
QUEUEING state: to prevent binding an object to a request that is in the
process of being queued.

> 
> I'd also assign fields other than req in object init as objects may be
> unbound from requests and outlive requests (video buffers, for instance).
> No ops nor priv field may be changed during a lifetime of an object.

Sorry, no idea what you mean. Could it be that you want to move the ops and
priv arguments to the object_init() function instead of the bind()?

If that's the case, then I'll have to look at that. I think I did that at
one point in time, but I moved it to the bind for some reason.

> 
>> +		goto unlock;
>> +	list_add_tail(&obj->list, &req->objects);
>> +	req->num_incomplete_objects++;
>> +unlock:
>> +	spin_unlock_irqrestore(&req->lock, flags);
>> +}
>> +EXPORT_SYMBOL_GPL(media_request_object_bind);
>> +
>> +void media_request_object_unbind(struct media_request_object *obj)
>> +{
>> +	struct media_request *req = obj->req;
>> +	unsigned long flags;
>> +	bool completed = false;
>> +
>> +	if (!req)
>> +		return;
>> +
>> +	spin_lock_irqsave(&req->lock, flags);
>> +	list_del(&obj->list);
>> +	obj->req = NULL;
>> +
>> +	if (req->state == MEDIA_REQUEST_STATE_COMPLETE ||
>> +	    req->state == MEDIA_REQUEST_STATE_CLEANING)
>> +		goto unlock;
>> +
>> +	if (WARN_ON(req->state == MEDIA_REQUEST_STATE_QUEUEING))
>> +		goto unlock;
>> +
>> +	if (WARN_ON(!req->num_incomplete_objects))
>> +		goto unlock;
>> +
>> +	req->num_incomplete_objects--;
>> +	if (req->state == MEDIA_REQUEST_STATE_QUEUED &&
>> +	    !req->num_incomplete_objects) {
>> +		req->state = MEDIA_REQUEST_STATE_COMPLETE;
>> +		completed = true;
>> +		wake_up_interruptible(&req->poll_wait);
>> +	}
>> +unlock:
>> +	spin_unlock_irqrestore(&req->lock, flags);
>> +	if (obj->ops->unbind)
>> +		obj->ops->unbind(obj);
>> +	if (completed)
>> +		media_request_put(req);
>> +}
>> +EXPORT_SYMBOL_GPL(media_request_object_unbind);
>> +
>> +void media_request_object_complete(struct media_request_object *obj)
>> +{
>> +	struct media_request *req = obj->req;
>> +	unsigned long flags;
>> +	bool completed = false;
>> +
>> +	spin_lock_irqsave(&req->lock, flags);
>> +	if (obj->completed)
>> +		goto unlock;
>> +	obj->completed = true;
>> +	if (WARN_ON(!req->num_incomplete_objects) ||
>> +	    WARN_ON(req->state != MEDIA_REQUEST_STATE_QUEUED))
> 
> If an object completes very soon after a request is queued, it is possible
> that the request is still in QUEUEING state. I'm actually beginning to
> wonder whether this state is useful; would it bring trouble if we just put
> it to QUEUED right from the beginning?

I think it would be better to split the req_queue op in two ops, so
media_request_ioctl_queue() would do this (pseudo code):

	req->state = MEDIA_REQUEST_STATE_PREPARING;
	ret = req->ops->req_prepare(req);
	if (ret) {
		req->state = IDLE;
		return ret;
	}
	req->state = QUEUED;
	req->ops->req_queue(req);  // void function, must always succeed
	return 0;

I think this works safely.

> 
>> +		goto unlock;
>> +
>> +	if (!--req->num_incomplete_objects) {
>> +		req->state = MEDIA_REQUEST_STATE_COMPLETE;
>> +		wake_up_interruptible(&req->poll_wait);
>> +		completed = true;
>> +	}
> 
> Newline here...
> 
>> +unlock:
>> +	spin_unlock_irqrestore(&req->lock, flags);
> 
> and here?
> 
>> +	if (completed)
>> +		media_request_put(req);
>>  }
>> +EXPORT_SYMBOL_GPL(media_request_object_complete);
>> diff --git a/include/media/media-request.h b/include/media/media-request.h
>> index dae3eccd9aa7..baed99eb1279 100644
>> --- a/include/media/media-request.h
>> +++ b/include/media/media-request.h
>> @@ -16,7 +16,155 @@
>>  
>>  #include <media/media-device.h>
>>  
>> +enum media_request_state {
>> +	MEDIA_REQUEST_STATE_IDLE,
>> +	MEDIA_REQUEST_STATE_QUEUEING,
>> +	MEDIA_REQUEST_STATE_QUEUED,
>> +	MEDIA_REQUEST_STATE_COMPLETE,
>> +	MEDIA_REQUEST_STATE_CLEANING,
>> +};
>> +
>> +struct media_request_object;
>> +
>> +/**
>> + * struct media_request - Media device request
> 
> And here (plus " *").
> 
>> + * @mdev: Media device this request belongs to
>> + * @kref: Reference count
>> + * @debug_prefix: Prefix for debug messages (process name:fd)
>> + * @state: The state of the request
>> + * @objects: List of @struct media_request_object request objects
>> + * @num_objects: The number objects in the request
>> + * @num_completed_objects: The number of completed objects in the request
>> + * @poll_wait: Wait queue for poll
>> + * @lock: Serializes access to this struct
>> + */
>> +struct media_request {
>> +	struct media_device *mdev;
>> +	struct kref kref;
>> +	char debug_str[TASK_COMM_LEN + 11];
>> +	enum media_request_state state;
>> +	struct list_head objects;
>> +	unsigned int num_incomplete_objects;
>> +	struct wait_queue_head poll_wait;
>> +	spinlock_t lock;
>> +};
>> +
>> +#ifdef CONFIG_MEDIA_CONTROLLER
>> +static inline void media_request_get(struct media_request *req)
>> +{
>> +	kref_get(&req->kref);
>> +}
>> +
>> +void media_request_put(struct media_request *req);
>> +
>>  int media_request_alloc(struct media_device *mdev,
>>  			struct media_request_alloc *alloc);
>> +#else
>> +static inline void media_request_get(struct media_request *req)
>> +{
>> +}
>> +
>> +static inline void media_request_put(struct media_request *req)
>> +{
>> +}
>> +#endif
>> +
>> +struct media_request_object_ops {
>> +	int (*prepare)(struct media_request_object *object);
>> +	void (*unprepare)(struct media_request_object *object);
>> +	void (*queue)(struct media_request_object *object);
>> +	void (*unbind)(struct media_request_object *object);
>> +	void (*release)(struct media_request_object *object);
>> +};
>> +
>> +/**
>> + * struct media_request_object - An opaque object that belongs to a media
>> + *				 request
>> + *
>> + * @priv: object's priv pointer
>> + * @list: List entry of the object for @struct media_request
>> + * @kref: Reference count of the object, acquire before releasing req->lock
>> + *
>> + * An object related to the request. This struct is embedded in the
>> + * larger object data.
>> + */
>> +struct media_request_object {
>> +	const struct media_request_object_ops *ops;
>> +	void *priv;
>> +	struct media_request *req;
>> +	struct list_head list;
>> +	struct kref kref;
>> +	bool completed;
>> +};
>> +
>> +#ifdef CONFIG_MEDIA_CONTROLLER
>> +static inline void media_request_object_get(struct media_request_object *obj)
>> +{
>> +	kref_get(&obj->kref);
>> +}
>> +
>> +/**
>> + * media_request_object_put - Put a media request object
>> + *
>> + * @obj: The object
>> + *
>> + * Put a media request object. Once all references are gone, the
>> + * object's memory is released.
>> + */
>> +void media_request_object_put(struct media_request_object *obj);
>> +
>> +/**
>> + * media_request_object_init - Initialise a media request object
>> + *
>> + * Initialise a media request object. The object will be released using the
>> + * release callback of the ops once it has no references (this function
>> + * initialises references to one).
>> + */
>> +void media_request_object_init(struct media_request_object *obj);
>> +
>> +/**
>> + * media_request_object_bind - Bind a media request object to a request
>> + */
>> +void media_request_object_bind(struct media_request *req,
>> +			       const struct media_request_object_ops *ops,
>> +			       void *priv,
>> +			       struct media_request_object *obj);
>> +
>> +void media_request_object_unbind(struct media_request_object *obj);
>> +
>> +/**
>> + * media_request_object_complete - Mark the media request object as complete
>> + */
>> +void media_request_object_complete(struct media_request_object *obj);
>> +#else
>> +static inline void media_request_object_get(struct media_request_object *obj)
>> +{
>> +}
>> +
>> +static inline void media_request_object_put(struct media_request_object *obj)
>> +{
>> +}
>> +
>> +static inline void media_request_object_init(struct media_request_object *obj)
>> +{
>> +	obj->ops = NULL;
>> +	obj->req = NULL;
>> +}
>> +
>> +static inline void media_request_object_bind(struct media_request *req,
>> +			       const struct media_request_object_ops *ops,
>> +			       void *priv,
>> +			       struct media_request_object *obj)
>> +{
>> +}
>> +
>> +static inline void media_request_object_unbind(struct media_request_object *obj)
>> +{
>> +}
>> +
>> +static inline void media_request_object_complete(struct media_request_object *obj)
>> +{
>> +}
>> +#endif
>>  
>>  #endif
> 

Regards,

	Hans
