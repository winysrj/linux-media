Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud9.xs4all.net ([194.109.24.26]:40071 "EHLO
        lb2-smtp-cloud9.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1753975AbeGEQDo (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 5 Jul 2018 12:03:44 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>
Subject: [PATCHv16 03/34] media-request: implement media requests
Date: Thu,  5 Jul 2018 18:03:06 +0200
Message-Id: <20180705160337.54379-4-hverkuil@xs4all.nl>
In-Reply-To: <20180705160337.54379-1-hverkuil@xs4all.nl>
References: <20180705160337.54379-1-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Add initial media request support:

1) Add MEDIA_IOC_REQUEST_ALLOC ioctl support to media-device.c
2) Add struct media_request to store request objects.
3) Add struct media_request_object to represent a request object.
4) Add MEDIA_REQUEST_IOC_QUEUE/REINIT ioctl support.

Basic lifecycle: the application allocates a request, adds
objects to it, queues the request, polls until it is completed
and can then read the final values of the objects at the time
of completion. When it closes the file descriptor the request
memory will be freed (actually, when the last user of that request
releases the request).

Drivers will bind an object to a request (the 'adds objects to it'
phase), when MEDIA_REQUEST_IOC_QUEUE is called the request is
validated (req_validate op), then queued (the req_queue op).

When done with an object it can either be unbound from the request
(e.g. when the driver has finished with a vb2 buffer) or marked as
completed (e.g. for controls associated with a buffer). When all
objects in the request are completed (or unbound), then the request
fd will signal an exception (poll).

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
Co-developed-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Co-developed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Co-developed-by: Alexandre Courbot <acourbot@chromium.org>
---
 drivers/media/Makefile        |   3 +-
 drivers/media/media-device.c  |  14 ++
 drivers/media/media-request.c | 423 ++++++++++++++++++++++++++++++++++
 include/media/media-device.h  |  21 ++
 include/media/media-request.h | 327 ++++++++++++++++++++++++++
 5 files changed, 787 insertions(+), 1 deletion(-)
 create mode 100644 drivers/media/media-request.c
 create mode 100644 include/media/media-request.h

diff --git a/drivers/media/Makefile b/drivers/media/Makefile
index 594b462ddf0e..985d35ec6b29 100644
--- a/drivers/media/Makefile
+++ b/drivers/media/Makefile
@@ -3,7 +3,8 @@
 # Makefile for the kernel multimedia device drivers.
 #
 
-media-objs	:= media-device.o media-devnode.o media-entity.o
+media-objs	:= media-device.o media-devnode.o media-entity.o \
+		   media-request.o
 
 #
 # I2C drivers should come before other drivers, otherwise they'll fail
diff --git a/drivers/media/media-device.c b/drivers/media/media-device.c
index 47bb2254fbfd..77bfb0654ef2 100644
--- a/drivers/media/media-device.c
+++ b/drivers/media/media-device.c
@@ -29,6 +29,7 @@
 #include <media/media-device.h>
 #include <media/media-devnode.h>
 #include <media/media-entity.h>
+#include <media/media-request.h>
 
 #ifdef CONFIG_MEDIA_CONTROLLER
 
@@ -374,6 +375,15 @@ static long media_device_get_topology(struct media_device *mdev, void *arg)
 	return ret;
 }
 
+static long media_device_request_alloc(struct media_device *mdev,
+				       struct media_request_alloc *alloc)
+{
+	if (!mdev->ops || !mdev->ops->req_validate || !mdev->ops->req_queue)
+		return -ENOTTY;
+
+	return media_request_alloc(mdev, alloc);
+}
+
 static long copy_arg_from_user(void *karg, void __user *uarg, unsigned int cmd)
 {
 	/* All media IOCTLs are _IOWR() */
@@ -422,6 +432,7 @@ static const struct media_ioctl_info ioctl_info[] = {
 	MEDIA_IOC(ENUM_LINKS, media_device_enum_links, MEDIA_IOC_FL_GRAPH_MUTEX),
 	MEDIA_IOC(SETUP_LINK, media_device_setup_link, MEDIA_IOC_FL_GRAPH_MUTEX),
 	MEDIA_IOC(G_TOPOLOGY, media_device_get_topology, MEDIA_IOC_FL_GRAPH_MUTEX),
+	MEDIA_IOC(REQUEST_ALLOC, media_device_request_alloc, 0),
 };
 
 static long media_device_ioctl(struct file *filp, unsigned int cmd,
@@ -694,6 +705,8 @@ void media_device_init(struct media_device *mdev)
 	INIT_LIST_HEAD(&mdev->pads);
 	INIT_LIST_HEAD(&mdev->links);
 	INIT_LIST_HEAD(&mdev->entity_notify);
+
+	mutex_init(&mdev->req_queue_mutex);
 	mutex_init(&mdev->graph_mutex);
 	ida_init(&mdev->entity_internal_idx);
 
@@ -707,6 +720,7 @@ void media_device_cleanup(struct media_device *mdev)
 	mdev->entity_internal_idx_max = 0;
 	media_graph_walk_cleanup(&mdev->pm_count_walk);
 	mutex_destroy(&mdev->graph_mutex);
+	mutex_destroy(&mdev->req_queue_mutex);
 }
 EXPORT_SYMBOL_GPL(media_device_cleanup);
 
diff --git a/drivers/media/media-request.c b/drivers/media/media-request.c
new file mode 100644
index 000000000000..253068f51a1f
--- /dev/null
+++ b/drivers/media/media-request.c
@@ -0,0 +1,423 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * Media device request objects
+ *
+ * Copyright 2018 Cisco Systems, Inc. and/or its affiliates. All rights reserved.
+ * Copyright (C) 2018 Intel Corporation
+ * Copyright (C) 2018 Google, Inc.
+ *
+ * Author: Hans Verkuil <hans.verkuil@cisco.com>
+ * Author: Sakari Ailus <sakari.ailus@linux.intel.com>
+ */
+
+#include <linux/anon_inodes.h>
+#include <linux/file.h>
+#include <linux/refcount.h>
+
+#include <media/media-device.h>
+#include <media/media-request.h>
+
+static const char * const request_state[] = {
+	[MEDIA_REQUEST_STATE_IDLE]	 = "idle",
+	[MEDIA_REQUEST_STATE_VALIDATING] = "validating",
+	[MEDIA_REQUEST_STATE_QUEUED]	 = "queued",
+	[MEDIA_REQUEST_STATE_COMPLETE]	 = "complete",
+	[MEDIA_REQUEST_STATE_CLEANING]	 = "cleaning",
+	[MEDIA_REQUEST_STATE_UPDATING]	 = "updating",
+};
+
+static const char *
+media_request_state_str(enum media_request_state state)
+{
+	BUILD_BUG_ON(ARRAY_SIZE(request_state) != NR_OF_MEDIA_REQUEST_STATE);
+
+	if (WARN_ON(state >= ARRAY_SIZE(request_state)))
+		return "invalid";
+	return request_state[state];
+}
+
+static void media_request_clean(struct media_request *req)
+{
+	struct media_request_object *obj, *obj_safe;
+
+	/* Just a sanity check. No other code path is allowed to change this. */
+	WARN_ON(req->state != MEDIA_REQUEST_STATE_CLEANING);
+	WARN_ON(req->updating_count);
+
+	list_for_each_entry_safe(obj, obj_safe, &req->objects, list) {
+		media_request_object_unbind(obj);
+		media_request_object_put(obj);
+	}
+
+	req->updating_count = 0;
+	WARN_ON(req->num_incomplete_objects);
+	req->num_incomplete_objects = 0;
+	wake_up_interruptible_all(&req->poll_wait);
+}
+
+static void media_request_release(struct kref *kref)
+{
+	struct media_request *req =
+		container_of(kref, struct media_request, kref);
+	struct media_device *mdev = req->mdev;
+
+	dev_dbg(mdev->dev, "request: release %s\n", req->debug_str);
+
+	/* No other users, no need for a spinlock */
+	req->state = MEDIA_REQUEST_STATE_CLEANING;
+
+	media_request_clean(req);
+
+	if (mdev->ops->req_free)
+		mdev->ops->req_free(req);
+	else
+		kfree(req);
+}
+
+void media_request_put(struct media_request *req)
+{
+	kref_put(&req->kref, media_request_release);
+}
+EXPORT_SYMBOL_GPL(media_request_put);
+
+static int media_request_close(struct inode *inode, struct file *filp)
+{
+	struct media_request *req = filp->private_data;
+
+	media_request_put(req);
+	return 0;
+}
+
+static unsigned int media_request_poll(struct file *filp,
+				       struct poll_table_struct *wait)
+{
+	struct media_request *req = filp->private_data;
+	unsigned long flags;
+	unsigned int ret = 0;
+
+	if (!(poll_requested_events(wait) & POLLPRI))
+		return 0;
+
+	spin_lock_irqsave(&req->lock, flags);
+	if (req->state == MEDIA_REQUEST_STATE_COMPLETE) {
+		ret = POLLPRI;
+		goto unlock;
+	}
+	if (req->state != MEDIA_REQUEST_STATE_QUEUED) {
+		ret = POLLERR;
+		goto unlock;
+	}
+
+	poll_wait(filp, &req->poll_wait, wait);
+
+unlock:
+	spin_unlock_irqrestore(&req->lock, flags);
+	return ret;
+}
+
+static long media_request_ioctl_queue(struct media_request *req)
+{
+	struct media_device *mdev = req->mdev;
+	enum media_request_state state;
+	unsigned long flags;
+	int ret;
+
+	dev_dbg(mdev->dev, "request: queue %s\n", req->debug_str);
+
+	/*
+	 * Ensure the request that is validated will be the one that gets queued
+	 * next by serialising the queueing process. This mutex is also used
+	 * to serialize with canceling a vb2 queue and with setting values such
+	 * as controls in a request.
+	 */
+	mutex_lock(&mdev->req_queue_mutex);
+
+	media_request_get(req);
+
+	spin_lock_irqsave(&req->lock, flags);
+	if (req->state == MEDIA_REQUEST_STATE_IDLE)
+		req->state = MEDIA_REQUEST_STATE_VALIDATING;
+	state = req->state;
+	spin_unlock_irqrestore(&req->lock, flags);
+	if (state != MEDIA_REQUEST_STATE_VALIDATING) {
+		dev_dbg(mdev->dev,
+			"request: unable to queue %s, request in state %s\n",
+			req->debug_str, media_request_state_str(state));
+		mutex_unlock(&mdev->req_queue_mutex);
+		return -EBUSY;
+	}
+
+	ret = mdev->ops->req_validate(req);
+
+	/*
+	 * If the req_validate was successful, then we mark the state as QUEUED
+	 * and call req_queue. The reason we set the state first is that this
+	 * allows req_queue to unbind or complete the queued objects in case
+	 * they are immediately 'consumed'. State changes from QUEUED to another
+	 * state can only happen if either the driver changes the state or if
+	 * the user cancels the vb2 queue. The driver can only change the state
+	 * after each object is queued through the req_queue op (and note that
+	 * that op cannot fail), so setting the state to QUEUED up front is
+	 * safe.
+	 *
+	 * The other reason for changing the state is if the vb2 queue is
+	 * canceled, and that uses the req_queue_mutex which is still locked
+	 * while req_queue is called, so that's safe as well.
+	 */
+	spin_lock_irqsave(&req->lock, flags);
+	req->state = ret ? MEDIA_REQUEST_STATE_IDLE
+			 : MEDIA_REQUEST_STATE_QUEUED;
+	spin_unlock_irqrestore(&req->lock, flags);
+
+	if (!ret)
+		mdev->ops->req_queue(req);
+
+	mutex_unlock(&mdev->req_queue_mutex);
+
+	if (ret) {
+		dev_dbg(mdev->dev, "request: can't queue %s (%d)\n",
+			req->debug_str, ret);
+		media_request_put(req);
+	}
+
+	return ret;
+}
+
+static long media_request_ioctl_reinit(struct media_request *req)
+{
+	struct media_device *mdev = req->mdev;
+	unsigned long flags;
+
+	spin_lock_irqsave(&req->lock, flags);
+	if (req->state != MEDIA_REQUEST_STATE_IDLE &&
+	    req->state != MEDIA_REQUEST_STATE_COMPLETE) {
+		dev_dbg(mdev->dev,
+			"request: %s not in idle or complete state, cannot reinit\n",
+			req->debug_str);
+		spin_unlock_irqrestore(&req->lock, flags);
+		return -EBUSY;
+	}
+	req->state = MEDIA_REQUEST_STATE_CLEANING;
+	spin_unlock_irqrestore(&req->lock, flags);
+
+	media_request_clean(req);
+
+	spin_lock_irqsave(&req->lock, flags);
+	req->state = MEDIA_REQUEST_STATE_IDLE;
+	spin_unlock_irqrestore(&req->lock, flags);
+
+	return 0;
+}
+
+static long media_request_ioctl(struct file *filp, unsigned int cmd,
+				unsigned long arg)
+{
+	struct media_request *req = filp->private_data;
+
+	switch (cmd) {
+	case MEDIA_REQUEST_IOC_QUEUE:
+		return media_request_ioctl_queue(req);
+	case MEDIA_REQUEST_IOC_REINIT:
+		return media_request_ioctl_reinit(req);
+	default:
+		return -ENOIOCTLCMD;
+	}
+}
+
+static const struct file_operations request_fops = {
+	.owner = THIS_MODULE,
+	.poll = media_request_poll,
+	.unlocked_ioctl = media_request_ioctl,
+	.release = media_request_close,
+};
+
+int media_request_alloc(struct media_device *mdev,
+			struct media_request_alloc *alloc)
+{
+	struct media_request *req;
+	struct file *filp;
+	char comm[TASK_COMM_LEN];
+	int fd;
+	int ret;
+
+	/* Either both are NULL or both are non-NULL */
+	if (WARN_ON(!mdev->ops->req_alloc ^ !mdev->ops->req_free))
+		return -ENOMEM;
+
+	fd = get_unused_fd_flags(O_CLOEXEC);
+	if (fd < 0)
+		return fd;
+
+	filp = anon_inode_getfile("request", &request_fops, NULL, O_CLOEXEC);
+	if (IS_ERR(filp)) {
+		ret = PTR_ERR(filp);
+		goto err_put_fd;
+	}
+
+	if (mdev->ops->req_alloc)
+		req = mdev->ops->req_alloc(mdev);
+	else
+		req = kzalloc(sizeof(*req), GFP_KERNEL);
+	if (!req) {
+		ret = -ENOMEM;
+		goto err_fput;
+	}
+
+	filp->private_data = req;
+	req->mdev = mdev;
+	req->state = MEDIA_REQUEST_STATE_IDLE;
+	req->num_incomplete_objects = 0;
+	kref_init(&req->kref);
+	INIT_LIST_HEAD(&req->objects);
+	spin_lock_init(&req->lock);
+	init_waitqueue_head(&req->poll_wait);
+	req->updating_count = 0;
+
+	alloc->fd = fd;
+
+	get_task_comm(comm, current);
+	snprintf(req->debug_str, sizeof(req->debug_str), "%s:%d",
+		 comm, fd);
+	dev_dbg(mdev->dev, "request: allocated %s\n", req->debug_str);
+
+	fd_install(fd, filp);
+
+	return 0;
+
+err_fput:
+	fput(filp);
+
+err_put_fd:
+	put_unused_fd(fd);
+
+	return ret;
+}
+
+static void media_request_object_release(struct kref *kref)
+{
+	struct media_request_object *obj =
+		container_of(kref, struct media_request_object, kref);
+	struct media_request *req = obj->req;
+
+	if (WARN_ON(req))
+		media_request_object_unbind(obj);
+	obj->ops->release(obj);
+}
+
+void media_request_object_put(struct media_request_object *obj)
+{
+	kref_put(&obj->kref, media_request_object_release);
+}
+EXPORT_SYMBOL_GPL(media_request_object_put);
+
+void media_request_object_init(struct media_request_object *obj)
+{
+	obj->ops = NULL;
+	obj->req = NULL;
+	obj->priv = NULL;
+	obj->completed = false;
+	INIT_LIST_HEAD(&obj->list);
+	kref_init(&obj->kref);
+}
+EXPORT_SYMBOL_GPL(media_request_object_init);
+
+int media_request_object_bind(struct media_request *req,
+			      const struct media_request_object_ops *ops,
+			      void *priv,
+			      struct media_request_object *obj)
+{
+	unsigned long flags;
+	int ret = -EBUSY;
+
+	if (WARN_ON(!ops->release))
+		return -EPERM;
+
+	spin_lock_irqsave(&req->lock, flags);
+
+	if (WARN_ON(req->state != MEDIA_REQUEST_STATE_UPDATING))
+		goto unlock;
+
+	obj->req = req;
+	obj->ops = ops;
+	obj->priv = priv;
+
+	list_add_tail(&obj->list, &req->objects);
+	req->num_incomplete_objects++;
+	ret = 0;
+
+unlock:
+	spin_unlock_irqrestore(&req->lock, flags);
+	return ret;
+}
+EXPORT_SYMBOL_GPL(media_request_object_bind);
+
+void media_request_object_unbind(struct media_request_object *obj)
+{
+	struct media_request *req = obj->req;
+	unsigned long flags;
+	bool completed = false;
+
+	if (WARN_ON(!req))
+		return;
+
+	spin_lock_irqsave(&req->lock, flags);
+	list_del(&obj->list);
+	obj->req = NULL;
+
+	if (req->state == MEDIA_REQUEST_STATE_COMPLETE)
+		goto unlock;
+
+	if (WARN_ON(req->state == MEDIA_REQUEST_STATE_VALIDATING))
+		goto unlock;
+
+	if (req->state == MEDIA_REQUEST_STATE_CLEANING) {
+		if (!obj->completed)
+			req->num_incomplete_objects--;
+		goto unlock;
+	}
+
+	if (WARN_ON(!req->num_incomplete_objects))
+		goto unlock;
+
+	req->num_incomplete_objects--;
+	if (req->state == MEDIA_REQUEST_STATE_QUEUED &&
+	    !req->num_incomplete_objects) {
+		req->state = MEDIA_REQUEST_STATE_COMPLETE;
+		completed = true;
+		wake_up_interruptible_all(&req->poll_wait);
+	}
+
+unlock:
+	spin_unlock_irqrestore(&req->lock, flags);
+	if (obj->ops->unbind)
+		obj->ops->unbind(obj);
+	if (completed)
+		media_request_put(req);
+}
+EXPORT_SYMBOL_GPL(media_request_object_unbind);
+
+void media_request_object_complete(struct media_request_object *obj)
+{
+	struct media_request *req = obj->req;
+	unsigned long flags;
+	bool completed = false;
+
+	spin_lock_irqsave(&req->lock, flags);
+	if (obj->completed)
+		goto unlock;
+	obj->completed = true;
+	if (WARN_ON(!req->num_incomplete_objects) ||
+	    WARN_ON(req->state != MEDIA_REQUEST_STATE_QUEUED))
+		goto unlock;
+
+	if (!--req->num_incomplete_objects) {
+		req->state = MEDIA_REQUEST_STATE_COMPLETE;
+		wake_up_interruptible_all(&req->poll_wait);
+		completed = true;
+	}
+unlock:
+	spin_unlock_irqrestore(&req->lock, flags);
+	if (completed)
+		media_request_put(req);
+}
+EXPORT_SYMBOL_GPL(media_request_object_complete);
diff --git a/include/media/media-device.h b/include/media/media-device.h
index bcc6ec434f1f..110b89567671 100644
--- a/include/media/media-device.h
+++ b/include/media/media-device.h
@@ -27,6 +27,7 @@
 
 struct ida;
 struct device;
+struct media_device;
 
 /**
  * struct media_entity_notify - Media Entity Notify
@@ -50,10 +51,26 @@ struct media_entity_notify {
  * struct media_device_ops - Media device operations
  * @link_notify: Link state change notification callback. This callback is
  *		 called with the graph_mutex held.
+ * @req_alloc: Allocate a request. Set this if you need to allocate a struct
+ *	       larger then struct media_request. @req_alloc and @req_free must
+ *	       either both be set or both be NULL.
+ * @req_free: Free a request. Set this if @req_alloc was set as well, leave
+ *	      to NULL otherwise.
+ * @req_validate: Validate a request, but do not queue yet. The req_queue_mutex
+ *	          lock is held when this op is called.
+ * @req_queue: Queue a validated request, cannot fail. If something goes
+ *	       wrong when queueing this request then it should be marked
+ *	       as such internally in the driver and any related buffers
+ *	       must eventually return to vb2 with state VB2_BUF_STATE_ERROR.
+ *	       The req_queue_mutex lock is held when this op is called.
  */
 struct media_device_ops {
 	int (*link_notify)(struct media_link *link, u32 flags,
 			   unsigned int notification);
+	struct media_request *(*req_alloc)(struct media_device *mdev);
+	void (*req_free)(struct media_request *req);
+	int (*req_validate)(struct media_request *req);
+	void (*req_queue)(struct media_request *req);
 };
 
 /**
@@ -88,6 +105,8 @@ struct media_device_ops {
  * @disable_source: Disable Source Handler function pointer
  *
  * @ops:	Operation handler callbacks
+ * @req_queue_mutex: Serialise the MEDIA_REQUEST_IOC_QUEUE ioctl w.r.t.
+ *		     other operations that stop or start streaming.
  *
  * This structure represents an abstract high-level media device. It allows easy
  * access to entities and provides basic media device-level support. The
@@ -158,6 +177,8 @@ struct media_device {
 	void (*disable_source)(struct media_entity *entity);
 
 	const struct media_device_ops *ops;
+
+	struct mutex req_queue_mutex;
 };
 
 /* We don't need to include pci.h or usb.h here */
diff --git a/include/media/media-request.h b/include/media/media-request.h
new file mode 100644
index 000000000000..fe5a04fb970c
--- /dev/null
+++ b/include/media/media-request.h
@@ -0,0 +1,327 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * Media device request objects
+ *
+ * Copyright 2018 Cisco Systems, Inc. and/or its affiliates. All rights reserved.
+ * Copyright (C) 2018 Intel Corporation
+ *
+ * Author: Hans Verkuil <hans.verkuil@cisco.com>
+ * Author: Sakari Ailus <sakari.ailus@linux.intel.com>
+ */
+
+#ifndef MEDIA_REQUEST_H
+#define MEDIA_REQUEST_H
+
+#include <linux/list.h>
+#include <linux/slab.h>
+#include <linux/spinlock.h>
+#include <linux/refcount.h>
+
+#include <media/media-device.h>
+
+/**
+ * enum media_request_state - media request state
+ *
+ * @MEDIA_REQUEST_STATE_IDLE:		Idle
+ * @MEDIA_REQUEST_STATE_VALIDATING:	Validating the request, no state changes
+ *					allowed
+ * @MEDIA_REQUEST_STATE_QUEUED:		Queued
+ * @MEDIA_REQUEST_STATE_COMPLETE:	Completed, the request is done
+ * @MEDIA_REQUEST_STATE_CLEANING:	Cleaning, the request is being re-inited
+ * @MEDIA_REQUEST_STATE_UPDATING:	The request is being updated, i.e.
+ *					request objects are being added,
+ *					modified or removed
+ * @NR_OF_MEDIA_REQUEST_STATE:		The number of media request states, used
+ *					internally for sanity check purposes
+ */
+enum media_request_state {
+	MEDIA_REQUEST_STATE_IDLE,
+	MEDIA_REQUEST_STATE_VALIDATING,
+	MEDIA_REQUEST_STATE_QUEUED,
+	MEDIA_REQUEST_STATE_COMPLETE,
+	MEDIA_REQUEST_STATE_CLEANING,
+	MEDIA_REQUEST_STATE_UPDATING,
+	NR_OF_MEDIA_REQUEST_STATE,
+};
+
+struct media_request_object;
+
+/**
+ * struct media_request - Media device request
+ * @mdev: Media device this request belongs to
+ * @kref: Reference count
+ * @debug_str: Prefix for debug messages (process name:fd)
+ * @state: The state of the request
+ * @updating_count: count the number of request updates that are in progress
+ * @objects: List of @struct media_request_object request objects
+ * @num_incomplete_objects: The number of incomplete objects in the request
+ * @poll_wait: Wait queue for poll
+ * @lock: Serializes access to this struct
+ */
+struct media_request {
+	struct media_device *mdev;
+	struct kref kref;
+	char debug_str[TASK_COMM_LEN + 11];
+	enum media_request_state state;
+	unsigned int updating_count;
+	struct list_head objects;
+	unsigned int num_incomplete_objects;
+	struct wait_queue_head poll_wait;
+	spinlock_t lock;
+};
+
+#ifdef CONFIG_MEDIA_CONTROLLER
+
+/**
+ * media_request_lock_for_update - Lock the request for updating its objects
+ *
+ * @req: The media request
+ *
+ * Use before updating a request, i.e. adding, modifying or removing a request
+ * object in it. A reference to the request must be held during the update. This
+ * usually takes place automatically through a file handle. Use
+ * @media_request_unlock_for_update when done.
+ */
+static inline int __must_check
+media_request_lock_for_update(struct media_request *req)
+{
+	unsigned long flags;
+	int ret = 0;
+
+	spin_lock_irqsave(&req->lock, flags);
+	if (req->state == MEDIA_REQUEST_STATE_IDLE ||
+	    req->state == MEDIA_REQUEST_STATE_UPDATING) {
+		req->state = MEDIA_REQUEST_STATE_UPDATING;
+		req->updating_count++;
+	} else {
+		ret = -EBUSY;
+	}
+	spin_unlock_irqrestore(&req->lock, flags);
+
+	return ret;
+}
+
+/**
+ * media_request_unlock_for_update - Unlock a request previously locked for
+ *				     update
+ *
+ * @req: The media request
+ *
+ * Unlock a request that has previously been locked using
+ * @media_request_lock_for_update.
+ */
+static inline void media_request_unlock_for_update(struct media_request *req)
+{
+	unsigned long flags;
+
+	spin_lock_irqsave(&req->lock, flags);
+	WARN_ON(req->updating_count <= 0);
+	if (!--req->updating_count)
+		req->state = MEDIA_REQUEST_STATE_IDLE;
+	spin_unlock_irqrestore(&req->lock, flags);
+}
+
+/**
+ * media_request_get - Get the media request
+ *
+ * @req: The media request
+ *
+ * Get the media request.
+ */
+static inline void media_request_get(struct media_request *req)
+{
+	kref_get(&req->kref);
+}
+
+/**
+ * media_request_put - Put the media request
+ *
+ * @req: The media request
+ *
+ * Put the media request. The media request will be released
+ * when the refcount reaches 0.
+ */
+void media_request_put(struct media_request *req);
+
+/**
+ * media_request_alloc - Allocate the media request
+ *
+ * @mdev: Media device this request belongs to
+ * @alloc: Store the request's file descriptor in this struct
+ *
+ * Allocated the media request and put the fd in @alloc->fd.
+ */
+int media_request_alloc(struct media_device *mdev,
+			struct media_request_alloc *alloc);
+
+#else
+
+static inline void media_request_get(struct media_request *req)
+{
+}
+
+static inline void media_request_put(struct media_request *req)
+{
+}
+
+#endif
+
+/**
+ * struct media_request_object_ops - Media request object operations
+ * @prepare: Validate and prepare the request object, optional.
+ * @unprepare: Unprepare the request object, optional.
+ * @queue: Queue the request object, optional.
+ * @unbind: Unbind the request object, optional.
+ * @release: Release the request object, required.
+ */
+struct media_request_object_ops {
+	int (*prepare)(struct media_request_object *object);
+	void (*unprepare)(struct media_request_object *object);
+	void (*queue)(struct media_request_object *object);
+	void (*unbind)(struct media_request_object *object);
+	void (*release)(struct media_request_object *object);
+};
+
+/**
+ * struct media_request_object - An opaque object that belongs to a media
+ *				 request
+ *
+ * @ops: object's operations
+ * @priv: object's priv pointer
+ * @req: the request this object belongs to (can be NULL)
+ * @list: List entry of the object for @struct media_request
+ * @kref: Reference count of the object, acquire before releasing req->lock
+ * @completed: If true, then this object was completed.
+ *
+ * An object related to the request. This struct is always embedded in
+ * another struct that contains the actual data for this request object.
+ */
+struct media_request_object {
+	const struct media_request_object_ops *ops;
+	void *priv;
+	struct media_request *req;
+	struct list_head list;
+	struct kref kref;
+	bool completed;
+};
+
+#ifdef CONFIG_MEDIA_CONTROLLER
+
+/**
+ * media_request_object_get - Get a media request object
+ *
+ * @obj: The object
+ *
+ * Get a media request object.
+ */
+static inline void media_request_object_get(struct media_request_object *obj)
+{
+	kref_get(&obj->kref);
+}
+
+/**
+ * media_request_object_put - Put a media request object
+ *
+ * @obj: The object
+ *
+ * Put a media request object. Once all references are gone, the
+ * object's memory is released.
+ */
+void media_request_object_put(struct media_request_object *obj);
+
+/**
+ * media_request_object_init - Initialise a media request object
+ *
+ * @obj: The object
+ *
+ * Initialise a media request object. The object will be released using the
+ * release callback of the ops once it has no references (this function
+ * initialises references to one).
+ */
+void media_request_object_init(struct media_request_object *obj);
+
+/**
+ * media_request_object_bind - Bind a media request object to a request
+ *
+ * @req: The media request
+ * @ops: The object ops for this object
+ * @priv: A driver-specific priv pointer associated with this object
+ * @obj: The object
+ *
+ * Bind this object to the request and set the ops and priv values of
+ * the object so it can be found later with media_request_object_find().
+ *
+ * Every bound object must be unbound or completed by the kernel at some
+ * point in time, otherwise the request will never complete. When the
+ * request is released all completed objects will be unbound by the
+ * request core code.
+ */
+int media_request_object_bind(struct media_request *req,
+			      const struct media_request_object_ops *ops,
+			      void *priv,
+			      struct media_request_object *obj);
+
+/**
+ * media_request_object_unbind - Unbind a media request object
+ *
+ * @obj: The object
+ *
+ * Unbind the media request object from the request.
+ */
+void media_request_object_unbind(struct media_request_object *obj);
+
+/**
+ * media_request_object_complete - Mark the media request object as complete
+ *
+ * @obj: The object
+ *
+ * Mark the media request object as complete. Only bound objects can
+ * be completed.
+ */
+void media_request_object_complete(struct media_request_object *obj);
+
+#else
+
+static inline int __must_check
+media_request_lock_for_update(struct media_request *req)
+{
+	return -EINVAL;
+}
+
+static inline void media_request_unlock_for_update(struct media_request *req)
+{
+}
+
+static inline void media_request_object_get(struct media_request_object *obj)
+{
+}
+
+static inline void media_request_object_put(struct media_request_object *obj)
+{
+}
+
+static inline void media_request_object_init(struct media_request_object *obj)
+{
+	obj->ops = NULL;
+	obj->req = NULL;
+}
+
+static inline int media_request_object_bind(struct media_request *req,
+			       const struct media_request_object_ops *ops,
+			       void *priv,
+			       struct media_request_object *obj)
+{
+	return 0;
+}
+
+static inline void media_request_object_unbind(struct media_request_object *obj)
+{
+}
+
+static inline void media_request_object_complete(struct media_request_object *obj)
+{
+}
+
+#endif
+
+#endif
-- 
2.18.0
