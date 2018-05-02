Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:36044 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1751045AbeEBWYG (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 2 May 2018 18:24:06 -0400
Date: Thu, 3 May 2018 01:24:04 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org, Hans Verkuil <hans.verkuil@cisco.com>
Subject: Re: [RFCv12 PATCH 03/29] media-request: implement media requests
Message-ID: <20180502222404.ksvbdv656dd2r75b@valkosipuli.retiisi.org.uk>
References: <20180501090051.9321-1-hverkuil@xs4all.nl>
 <20180501090051.9321-4-hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180501090051.9321-4-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

On Tue, May 01, 2018 at 11:00:25AM +0200, Hans Verkuil wrote:
> From: Hans Verkuil <hans.verkuil@cisco.com>
> 
> Add initial media request support.
> 
> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
> ---
>  drivers/media/Makefile        |   3 +-
>  drivers/media/media-device.c  |  13 ++
>  drivers/media/media-request.c | 418 ++++++++++++++++++++++++++++++++++
>  include/media/media-device.h  |  17 ++
>  include/media/media-request.h | 193 ++++++++++++++++
>  5 files changed, 643 insertions(+), 1 deletion(-)
>  create mode 100644 drivers/media/media-request.c
>  create mode 100644 include/media/media-request.h
> 
> diff --git a/drivers/media/Makefile b/drivers/media/Makefile
> index 594b462ddf0e..985d35ec6b29 100644
> --- a/drivers/media/Makefile
> +++ b/drivers/media/Makefile
> @@ -3,7 +3,8 @@
>  # Makefile for the kernel multimedia device drivers.
>  #
>  
> -media-objs	:= media-device.o media-devnode.o media-entity.o
> +media-objs	:= media-device.o media-devnode.o media-entity.o \
> +		   media-request.o
>  
>  #
>  # I2C drivers should come before other drivers, otherwise they'll fail
> diff --git a/drivers/media/media-device.c b/drivers/media/media-device.c
> index 35e81f7c0d2f..25d7e2a3ee84 100644
> --- a/drivers/media/media-device.c
> +++ b/drivers/media/media-device.c
> @@ -32,6 +32,7 @@
>  #include <media/media-device.h>
>  #include <media/media-devnode.h>
>  #include <media/media-entity.h>
> +#include <media/media-request.h>
>  
>  #ifdef CONFIG_MEDIA_CONTROLLER
>  
> @@ -366,6 +367,15 @@ static long media_device_get_topology(struct media_device *mdev,
>  	return ret;
>  }
>  
> +static long media_device_request_alloc(struct media_device *mdev,
> +				       struct media_request_alloc *alloc)
> +{
> +	if (!mdev->ops || !mdev->ops->req_validate || !mdev->ops->req_queue)
> +		return -ENOTTY;
> +
> +	return media_request_alloc(mdev, alloc);
> +}
> +
>  static long copy_arg_from_user(void *karg, void __user *uarg, unsigned int cmd)
>  {
>  	/* All media IOCTLs are _IOWR() */
> @@ -414,6 +424,7 @@ static const struct media_ioctl_info ioctl_info[] = {
>  	MEDIA_IOC(ENUM_LINKS, media_device_enum_links, MEDIA_IOC_FL_GRAPH_MUTEX),
>  	MEDIA_IOC(SETUP_LINK, media_device_setup_link, MEDIA_IOC_FL_GRAPH_MUTEX),
>  	MEDIA_IOC(G_TOPOLOGY, media_device_get_topology, MEDIA_IOC_FL_GRAPH_MUTEX),
> +	MEDIA_IOC(REQUEST_ALLOC, media_device_request_alloc, 0),
>  };
>  
>  static long media_device_ioctl(struct file *filp, unsigned int cmd,
> @@ -686,6 +697,8 @@ void media_device_init(struct media_device *mdev)
>  	INIT_LIST_HEAD(&mdev->pads);
>  	INIT_LIST_HEAD(&mdev->links);
>  	INIT_LIST_HEAD(&mdev->entity_notify);
> +
> +	mutex_init(&mdev->req_queue_mutex);

You'll need to add the corresponding mutex_destroy() to
media_device_cleanup().

>  	mutex_init(&mdev->graph_mutex);
>  	ida_init(&mdev->entity_internal_idx);
>  
> diff --git a/drivers/media/media-request.c b/drivers/media/media-request.c
> new file mode 100644
> index 000000000000..22881d5700c8
> --- /dev/null
> +++ b/drivers/media/media-request.c
> @@ -0,0 +1,418 @@
> +// SPDX-License-Identifier: GPL-2.0
> +/*
> + * Media device request objects
> + *
> + * Copyright (C) 2018 Intel Corporation
> + * Copyright (C) 2018 Google, Inc.
> + *
> + * Author: Sakari Ailus <sakari.ailus@linux.intel.com>
> + */
> +
> +#include <linux/anon_inodes.h>
> +#include <linux/file.h>
> +
> +#include <media/media-device.h>
> +#include <media/media-request.h>
> +
> +static const char * const request_state[] = {
> +	[MEDIA_REQUEST_STATE_IDLE]	 = "idle",
> +	[MEDIA_REQUEST_STATE_VALIDATING] = "validating",
> +	[MEDIA_REQUEST_STATE_QUEUED]	 = "queued",
> +	[MEDIA_REQUEST_STATE_COMPLETE]	 = "complete",
> +	[MEDIA_REQUEST_STATE_CLEANING]	 = "cleaning",
> +};
> +
> +static const char *
> +media_request_state_str(enum media_request_state state)
> +{
> +	if (WARN_ON(state >= ARRAY_SIZE(request_state)))
> +		return "unknown";

Unknown or invalid? I'd think that states that are not defined in
request_state above are not valid.

> +	return request_state[state];
> +}
> +
> +static void media_request_clean(struct media_request *req)
> +{
> +	struct media_request_object *obj, *obj_safe;
> +
> +	WARN_ON(atomic_read(&req->state) != MEDIA_REQUEST_STATE_CLEANING);
> +
> +	list_for_each_entry_safe(obj, obj_safe, &req->objects, list) {
> +		media_request_object_unbind(obj);
> +		media_request_object_put(obj);
> +	}
> +
> +	req->num_incomplete_objects = 0;
> +	wake_up_interruptible_all(&req->poll_wait);
> +}
> +
> +static void media_request_release(struct kref *kref)
> +{
> +	struct media_request *req =
> +		container_of(kref, struct media_request, kref);
> +	struct media_device *mdev = req->mdev;
> +
> +	dev_dbg(mdev->dev, "request: release %s\n", req->debug_str);
> +
> +	atomic_set(&req->state, MEDIA_REQUEST_STATE_CLEANING);
> +
> +	media_request_clean(req);
> +
> +	if (mdev->ops->req_free)
> +		mdev->ops->req_free(req);
> +	else
> +		kfree(req);
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
> +	/*
> +	 * This is serialized with the req_queue_mutex and streaming
> +	 * has stopped, so there is no need to take the spinlock here.
> +	 */
> +	WARN_ON_ONCE(!mutex_is_locked(&req->mdev->req_queue_mutex));

Hmm. How about lockdep_assert_held(&req->mdev->req_queue_mutex)?

> +	if (atomic_read(&req->state) != MEDIA_REQUEST_STATE_QUEUED)
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

A newline would be nice here.

> +	return 0;
> +}
> +
> +static unsigned int media_request_poll(struct file *filp,
> +				       struct poll_table_struct *wait)
> +{
> +	struct media_request *req = filp->private_data;
> +	unsigned long flags;
> +	unsigned int ret = 0;
> +	enum media_request_state state;
> +
> +	if (!(poll_requested_events(wait) & POLLPRI))
> +		return 0;
> +
> +	spin_lock_irqsave(&req->lock, flags);
> +	state = atomic_read(&req->state);
> +
> +	if (state == MEDIA_REQUEST_STATE_COMPLETE) {
> +		ret = POLLPRI;
> +		goto unlock;
> +	}
> +	if (state == MEDIA_REQUEST_STATE_IDLE) {

Should this be just anything else than QUEUE or VALIDATING? You're missing
CLEANING here, for instance.

> +		ret = POLLERR;
> +		goto unlock;
> +	}
> +
> +	poll_wait(filp, &req->poll_wait, wait);

Newline?

> +unlock:
> +	spin_unlock_irqrestore(&req->lock, flags);
> +	return ret;
> +}
> +
> +static long media_request_ioctl_queue(struct media_request *req)
> +{
> +	struct media_device *mdev = req->mdev;
> +	enum media_request_state state;
> +	unsigned long flags;
> +	int ret = 0;
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
> +	spin_lock_irqsave(&req->lock, flags);
> +	state = atomic_cmpxchg(&req->state, MEDIA_REQUEST_STATE_IDLE,
> +			       MEDIA_REQUEST_STATE_VALIDATING);
> +	spin_unlock_irqrestore(&req->lock, flags);
> +	if (state != MEDIA_REQUEST_STATE_IDLE) {
> +		dev_dbg(mdev->dev,
> +			"request: unable to queue %s, request in state %s\n",
> +			req->debug_str, media_request_state_str(state));
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
> +	atomic_set(&req->state,
> +		   ret ? MEDIA_REQUEST_STATE_IDLE : MEDIA_REQUEST_STATE_QUEUED);
> +
> +	if (!ret)
> +		mdev->ops->req_queue(req);
> +
> +	mutex_unlock(&mdev->req_queue_mutex);
> +
> +	if (ret) {
> +		dev_dbg(mdev->dev, "request: can't queue %s (%d)\n",
> +			req->debug_str, ret);
> +	} else {
> +		media_request_get(req);

You'll need to get a reference before you queue the request. Otherwise it's
possible that it completes before you get here, and you end up accessing
released memory. The request refcount might be also under 0 before that
though.

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
> +	if (atomic_read(&req->state) != MEDIA_REQUEST_STATE_IDLE &&
> +	    atomic_read(&req->state) != MEDIA_REQUEST_STATE_COMPLETE) {
> +		dev_dbg(mdev->dev,
> +			"request: %s not in idle or complete state, cannot reinit\n",
> +			req->debug_str);
> +		spin_unlock_irqrestore(&req->lock, flags);
> +		return -EBUSY;
> +	}
> +	atomic_set(&req->state, MEDIA_REQUEST_STATE_CLEANING);
> +	spin_unlock_irqrestore(&req->lock, flags);
> +
> +	media_request_clean(req);
> +
> +	atomic_set(&req->state, MEDIA_REQUEST_STATE_IDLE);
> +
> +	return 0;
> +}
> +
> +static long media_request_ioctl(struct file *filp, unsigned int cmd,
> +				unsigned long arg)
> +{
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
> +}
> +
> +static const struct file_operations request_fops = {
> +	.owner = THIS_MODULE,
> +	.poll = media_request_poll,
> +	.unlocked_ioctl = media_request_ioctl,
> +	.release = media_request_close,
> +};
> +
> +int media_request_alloc(struct media_device *mdev,
> +			struct media_request_alloc *alloc)
> +{
> +	struct media_request *req;
> +	struct file *filp;
> +	char comm[TASK_COMM_LEN];
> +	int fd;
> +	int ret;
> +
> +	/* Either both are NULL or both are non-NULL */
> +	if (WARN_ON(!mdev->ops->req_alloc ^ !mdev->ops->req_free))
> +		return -ENOMEM;
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
> +	atomic_set(&req->state, MEDIA_REQUEST_STATE_IDLE);
> +	req->num_incomplete_objects = 0;
> +	kref_init(&req->kref);
> +	INIT_LIST_HEAD(&req->objects);
> +	spin_lock_init(&req->lock);
> +	init_waitqueue_head(&req->poll_wait);
> +
> +	alloc->fd = fd;
> +
> +	get_task_comm(comm, current);
> +	snprintf(req->debug_str, sizeof(req->debug_str), "%s:%d",
> +		 comm, fd);
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
> +int media_request_object_bind(struct media_request *req,
> +			      const struct media_request_object_ops *ops,
> +			      void *priv,
> +			      struct media_request_object *obj)
> +{
> +	unsigned long flags;
> +	int ret = -EBUSY;
> +
> +	if (WARN_ON(!ops->release || !ops->cancel))
> +		return -EPERM;
> +
> +	obj->req = req;
> +	obj->ops = ops;
> +	obj->priv = priv;

I think this function would benefit from some sprinkling of newlines here
and there. :-)

> +	spin_lock_irqsave(&req->lock, flags);
> +	if (WARN_ON(atomic_read(&req->state) != MEDIA_REQUEST_STATE_IDLE))
> +		goto unlock;
> +	list_add_tail(&obj->list, &req->objects);
> +	req->num_incomplete_objects++;
> +	ret = 0;
> +unlock:
> +	spin_unlock_irqrestore(&req->lock, flags);
> +	return ret;
> +}
> +EXPORT_SYMBOL_GPL(media_request_object_bind);
> +
> +void media_request_object_unbind(struct media_request_object *obj)
> +{
> +	struct media_request *req = obj->req;
> +	enum media_request_state state;
> +	unsigned long flags;
> +	bool completed = false;
> +
> +	if (WARN_ON(!req))
> +		return;
> +
> +	spin_lock_irqsave(&req->lock, flags);
> +	list_del(&obj->list);
> +	obj->req = NULL;
> +
> +	state = atomic_read(&req->state);
> +
> +	if (state == MEDIA_REQUEST_STATE_COMPLETE ||
> +	    state == MEDIA_REQUEST_STATE_CLEANING)
> +		goto unlock;
> +
> +	if (WARN_ON(state == MEDIA_REQUEST_STATE_VALIDATING))
> +		goto unlock;
> +
> +	if (WARN_ON(!req->num_incomplete_objects))
> +		goto unlock;
> +
> +	req->num_incomplete_objects--;
> +	if (state == MEDIA_REQUEST_STATE_QUEUED &&
> +	    !req->num_incomplete_objects) {
> +		atomic_set(&req->state, MEDIA_REQUEST_STATE_COMPLETE);
> +		completed = true;
> +		wake_up_interruptible_all(&req->poll_wait);
> +	}

A newline before a label would be nice.

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
> +	    WARN_ON(atomic_read(&req->state) != MEDIA_REQUEST_STATE_QUEUED))
> +		goto unlock;
> +
> +	if (!--req->num_incomplete_objects) {
> +		atomic_set(&req->state, MEDIA_REQUEST_STATE_COMPLETE);
> +		wake_up_interruptible_all(&req->poll_wait);
> +		completed = true;
> +	}
> +unlock:
> +	spin_unlock_irqrestore(&req->lock, flags);
> +	if (completed)
> +		media_request_put(req);
> +}
> +EXPORT_SYMBOL_GPL(media_request_object_complete);
> diff --git a/include/media/media-device.h b/include/media/media-device.h
> index bcc6ec434f1f..ae846208be51 100644
> --- a/include/media/media-device.h
> +++ b/include/media/media-device.h
> @@ -27,6 +27,7 @@
>  
>  struct ida;
>  struct device;
> +struct media_device;
>  
>  /**
>   * struct media_entity_notify - Media Entity Notify
> @@ -50,10 +51,22 @@ struct media_entity_notify {
>   * struct media_device_ops - Media device operations
>   * @link_notify: Link state change notification callback. This callback is
>   *		 called with the graph_mutex held.
> + * @req_alloc: Allocate a request
> + * @req_free: Free a request
> + * @req_validate: Validate a request, but do not queue yet
> + * @req_queue: Queue a validated request, cannot fail. If something goes
> + *	       wrong when queueing this request then it should be marked
> + *	       as such internally in the driver and any related buffers
> + *	       will eventually return to userspace with V4L2_BUF_FLAG_ERROR
> + *	       set.

Note that this is MC; I think the reference is fine but I'd make it
explicit this is V4L2, and possibly that it's an example.

>   */
>  struct media_device_ops {
>  	int (*link_notify)(struct media_link *link, u32 flags,
>  			   unsigned int notification);
> +	struct media_request *(*req_alloc)(struct media_device *mdev);
> +	void (*req_free)(struct media_request *req);
> +	int (*req_validate)(struct media_request *req);
> +	void (*req_queue)(struct media_request *req);
>  };
>  
>  /**
> @@ -88,6 +101,8 @@ struct media_device_ops {
>   * @disable_source: Disable Source Handler function pointer
>   *
>   * @ops:	Operation handler callbacks
> + * @req_queue_mutex: Serialise the MEDIA_REQUEST_IOC_QUEUE ioctl w.r.t. this
> + *		     media device.
>   *
>   * This structure represents an abstract high-level media device. It allows easy
>   * access to entities and provides basic media device-level support. The
> @@ -158,6 +173,8 @@ struct media_device {
>  	void (*disable_source)(struct media_entity *entity);
>  
>  	const struct media_device_ops *ops;
> +
> +	struct mutex req_queue_mutex;
>  };
>  
>  /* We don't need to include pci.h or usb.h here */
> diff --git a/include/media/media-request.h b/include/media/media-request.h
> new file mode 100644
> index 000000000000..9051dfbc7d30
> --- /dev/null
> +++ b/include/media/media-request.h
> @@ -0,0 +1,193 @@
> +// SPDX-License-Identifier: GPL-2.0
> +/*
> + * Media device request objects
> + *
> + * Copyright (C) 2018 Intel Corporation
> + *
> + * Author: Sakari Ailus <sakari.ailus@linux.intel.com>
> + */
> +
> +#ifndef MEDIA_REQUEST_H
> +#define MEDIA_REQUEST_H
> +
> +#include <linux/list.h>
> +#include <linux/slab.h>
> +#include <linux/spinlock.h>
> +#include <linux/atomic.h>
> +
> +#include <media/media-device.h>
> +
> +/**
> + * enum media_request_state - media request state
> + *
> + * @MEDIA_REQUEST_STATE_IDLE:		Idle
> + * @MEDIA_REQUEST_STATE_VALIDATING:	Validating the request, no state changes
> + *					allowed
> + * @MEDIA_REQUEST_STATE_QUEUED:		Queued
> + * @MEDIA_REQUEST_STATE_COMPLETE:	Completed, the request is done
> + * @MEDIA_REQUEST_STATE_CLEANING:	Cleaning, the request is being re-inited
> + */
> +enum media_request_state {
> +	MEDIA_REQUEST_STATE_IDLE,
> +	MEDIA_REQUEST_STATE_VALIDATING,
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
> + * @debug_str: Prefix for debug messages (process name:fd)
> + * @state: The state of the request
> + * @objects: List of @struct media_request_object request objects
> + * @num_objects: The number of objects in the request
> + * @num_incompleted_objects: The number of incomplete objects in the request
> + * @poll_wait: Wait queue for poll
> + * @lock: Serializes access to this struct
> + */
> +struct media_request {
> +	struct media_device *mdev;
> +	struct kref kref;
> +	char debug_str[TASK_COMM_LEN + 11];
> +	atomic_t state;
> +	struct list_head objects;
> +	unsigned int num_incomplete_objects;
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
> +int media_request_alloc(struct media_device *mdev,
> +			struct media_request_alloc *alloc);
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
> +
> +/**
> + * struct media_request_object - An opaque object that belongs to a media
> + *				 request
> + *
> + * @ops: object's operations
> + * @priv: object's priv pointer
> + * @req: the request this object belongs to (can be NULL)
> + * @list: List entry of the object for @struct media_request
> + * @kref: Reference count of the object, acquire before releasing req->lock
> + * @completed: If true, then this object was completed.
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
> +int media_request_object_bind(struct media_request *req,
> +			      const struct media_request_object_ops *ops,
> +			      void *priv,
> +			      struct media_request_object *obj);
> +
> +void media_request_object_unbind(struct media_request_object *obj);
> +
> +/**
> + * media_request_object_complete - Mark the media request object as complete
> + */
> +void media_request_object_complete(struct media_request_object *obj);
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
> +static inline int media_request_object_bind(struct media_request *req,
> +			       const struct media_request_object_ops *ops,
> +			       void *priv,
> +			       struct media_request_object *obj)
> +{
> +	return 0;
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
> +
> +#endif
> 

-- 
Kind regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi
