Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pf0-f196.google.com ([209.85.192.196]:46514 "EHLO
        mail-pf0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753640AbdLOH4w (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 15 Dec 2017 02:56:52 -0500
Received: by mail-pf0-f196.google.com with SMTP id c204so5604372pfc.13
        for <linux-media@vger.kernel.org>; Thu, 14 Dec 2017 23:56:52 -0800 (PST)
From: Alexandre Courbot <acourbot@chromium.org>
To: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Pawel Osciak <posciak@chromium.org>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Tomasz Figa <tfiga@chromium.org>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Gustavo Padovan <gustavo.padovan@collabora.com>
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        Alexandre Courbot <acourbot@chromium.org>
Subject: [RFC PATCH 1/9] media: add request API core and UAPI
Date: Fri, 15 Dec 2017 16:56:17 +0900
Message-Id: <20171215075625.27028-2-acourbot@chromium.org>
In-Reply-To: <20171215075625.27028-1-acourbot@chromium.org>
References: <20171215075625.27028-1-acourbot@chromium.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The request API provides a way to group buffers and device parameters
into units of work to be queued and executed. This patch introduces the
UAPI and core framework.

This patch is based on the previous work by Laurent Pinchart. The core
has changed considerably, but the UAPI is mostly untouched.

Signed-off-by: Alexandre Courbot <acourbot@chromium.org>
---
 drivers/media/Makefile               |   3 +-
 drivers/media/media-device.c         |   6 +
 drivers/media/media-request.c        | 390 +++++++++++++++++++++++++++++++++++
 drivers/media/v4l2-core/v4l2-ioctl.c |   2 +-
 include/media/media-device.h         |   3 +
 include/media/media-entity.h         |   6 +
 include/media/media-request.h        | 269 ++++++++++++++++++++++++
 include/uapi/linux/media.h           |  11 +
 8 files changed, 688 insertions(+), 2 deletions(-)
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
index e79f72b8b858..045cec7d2de9 100644
--- a/drivers/media/media-device.c
+++ b/drivers/media/media-device.c
@@ -32,6 +32,7 @@
 #include <media/media-device.h>
 #include <media/media-devnode.h>
 #include <media/media-entity.h>
+#include <media/media-request.h>
 
 #ifdef CONFIG_MEDIA_CONTROLLER
 
@@ -407,6 +408,7 @@ static const struct media_ioctl_info ioctl_info[] = {
 	MEDIA_IOC(ENUM_LINKS, media_device_enum_links, MEDIA_IOC_FL_GRAPH_MUTEX),
 	MEDIA_IOC(SETUP_LINK, media_device_setup_link, MEDIA_IOC_FL_GRAPH_MUTEX),
 	MEDIA_IOC(G_TOPOLOGY, media_device_get_topology, MEDIA_IOC_FL_GRAPH_MUTEX),
+	MEDIA_IOC(REQUEST_CMD, media_device_request_cmd, 0),
 };
 
 static long media_device_ioctl(struct file *filp, unsigned int cmd,
@@ -688,6 +690,10 @@ EXPORT_SYMBOL_GPL(media_device_init);
 
 void media_device_cleanup(struct media_device *mdev)
 {
+	if (mdev->req_queue) {
+		mdev->req_queue->ops->release(mdev->req_queue);
+		mdev->req_queue = NULL;
+	}
 	ida_destroy(&mdev->entity_internal_idx);
 	mdev->entity_internal_idx_max = 0;
 	media_graph_walk_cleanup(&mdev->pm_count_walk);
diff --git a/drivers/media/media-request.c b/drivers/media/media-request.c
new file mode 100644
index 000000000000..15dc65ddfe41
--- /dev/null
+++ b/drivers/media/media-request.c
@@ -0,0 +1,390 @@
+/*
+ * Request and request queue base management
+ *
+ * Copyright (C) 2017, The Chromium OS Authors.  All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ */
+
+#include <linux/anon_inodes.h>
+#include <linux/media.h>
+#include <linux/fs.h>
+#include <linux/file.h>
+#include <linux/slab.h>
+#include <linux/list.h>
+
+#include <media/media-request.h>
+#include <media/media-device.h>
+
+const struct file_operations request_fops;
+
+void media_request_get(struct media_request *req)
+{
+	kref_get(&req->kref);
+}
+EXPORT_SYMBOL_GPL(media_request_get);
+
+struct media_request *
+media_request_get_from_fd(int fd)
+{
+	struct file *f;
+	struct media_request *req;
+
+	f = fget(fd);
+	if (!f)
+		return NULL;
+
+	/* Not a request FD? */
+	if (f->f_op != &request_fops) {
+		fput(f);
+		return NULL;
+	}
+
+	req = f->private_data;
+	media_request_get(req);
+	fput(f);
+
+	return req;
+}
+EXPORT_SYMBOL_GPL(media_request_get_from_fd);
+
+static void media_request_release(struct kref *kref)
+{
+	struct media_request_entity_data *data, *next;
+	struct media_request *req =
+		container_of(kref, typeof(*req), kref);
+	struct media_device *mdev = req->queue->mdev;
+
+	dev_dbg(mdev->dev, "%s: releasing request %u\n", __func__, req->id);
+
+	list_del(&req->list);
+	list_for_each_entry_safe(data, next, &req->data, list) {
+		list_del(&data->list);
+		data->entity->req_ops->release_data(data);
+	}
+
+	req->queue->ops->req_free(req->queue, req);
+}
+
+void media_request_put(struct media_request *req)
+{
+	kref_put(&req->kref, media_request_release);
+}
+EXPORT_SYMBOL_GPL(media_request_put);
+
+struct media_request_entity_data *
+media_request_get_entity_data(struct media_request *req,
+			      struct media_entity *entity, void *fh)
+{
+	struct media_request_queue *queue = req->queue;
+	struct media_request_entity_data *data;
+
+	media_request_queue_lock(queue);
+
+	/* First look whether we already have entity data */
+	list_for_each_entry(data, &req->data, list) {
+		if (data->entity == entity) {
+			/*
+			 * If so, then the fh must match otherwise this means
+			 * we are trying to set the same entity through
+			 * different handles
+			 */
+			if (data->fh != fh)
+				data = ERR_PTR(-EINVAL);
+			goto done;
+		}
+	}
+
+	/* No entity data found, let's create it */
+	data = entity->req_ops->alloc_data(req, entity);
+	if (IS_ERR(data))
+		goto done;
+	data->fh = fh;
+	data->entity = entity;
+	list_add_tail(&data->list, &req->data);
+
+done:
+	media_request_queue_unlock(queue);
+	return data;
+}
+EXPORT_SYMBOL_GPL(media_request_get_entity_data);
+
+static const char * const media_request_states[] __maybe_unused = {
+	"IDLE",
+	"QUEUED",
+	"COMPLETED",
+	"DELETED",
+};
+
+static const char *media_request_state(enum media_request_state state)
+{
+	return state < ARRAY_SIZE(media_request_states) ?
+		media_request_states[state] : "INVALID";
+}
+
+static int media_device_request_close(struct inode *inode, struct file *filp)
+{
+	struct media_request *req = filp->private_data;
+
+	if (req == NULL)
+		return 0;
+
+	media_request_put(req);
+
+	return 0;
+}
+
+static unsigned int media_request_poll(struct file *file, poll_table *wait)
+{
+	struct media_request *req = file->private_data;
+
+	poll_wait(file, &req->wait_queue, wait);
+
+	if (req->state == MEDIA_REQUEST_STATE_COMPLETE)
+		return POLLIN | POLLRDNORM;
+
+	return 0;
+}
+
+const struct file_operations request_fops = {
+	.owner = THIS_MODULE,
+	.poll = media_request_poll,
+	.release = media_device_request_close,
+};
+
+/*
+ * Called when all the entities taking part in a request have completed their
+ * part.
+ *
+ * The request queue mutex must be held when this function is called.
+ */
+static void media_device_request_complete(struct media_request *req)
+{
+	struct media_request_queue *queue = req->queue;
+	struct media_device *mdev = queue->mdev;
+
+	if (WARN_ON(req->state != MEDIA_REQUEST_STATE_QUEUED)) {
+		dev_dbg(mdev->dev, "%s: can't complete %u, state %s\n",
+			__func__, req->id, media_request_state(req->state));
+		return;
+	}
+
+	req->state = MEDIA_REQUEST_STATE_COMPLETE;
+
+	wake_up_interruptible(&req->wait_queue);
+
+	queue->ops->req_complete(queue);
+
+	/* Release the reference acquired when we queued the request */
+	media_request_put(req);
+}
+
+void media_request_entity_complete(struct media_request_queue *queue,
+				   struct media_entity *entity)
+{
+	struct media_request_entity_data *data;
+	struct media_request *req;
+	bool completed = true;
+
+	media_request_queue_lock(queue);
+
+	req = queue->active_request;
+
+	list_for_each_entry(data, &req->data, list) {
+		if (data->entity == entity)
+			data->completed = true;
+
+		if (!data->completed)
+			completed = false;
+	}
+
+	/* All entities of the request have completed, request is done */
+	if (completed)
+		media_device_request_complete(req);
+
+	media_request_queue_unlock(queue);
+
+}
+EXPORT_SYMBOL_GPL(media_request_entity_complete);
+
+void media_request_queue_init(struct media_request_queue *queue,
+			      struct media_device *mdev,
+			      const struct media_request_queue_ops *ops)
+{
+	queue->mdev = mdev;
+	mutex_init(&queue->mutex);
+	INIT_LIST_HEAD(&queue->requests);
+	queue->ops = ops;
+}
+EXPORT_SYMBOL_GPL(media_request_queue_init);
+
+void media_request_queue_release(struct media_request_queue *queue)
+{
+	struct media_device *mdev = queue->mdev;
+
+	media_request_queue_lock(queue);
+
+	/* Just a sanity check - we should have no remaining requests */
+	while (!list_empty(&queue->requests)) {
+		struct media_request *req;
+
+		req = list_first_entry(&queue->requests, typeof(*req), list);
+		dev_warn(mdev->dev,
+			"%s: request %u still referenced, deleting forcibly!\n",
+			__func__, req->id);
+		media_request_release(&req->kref);
+	}
+
+	media_request_queue_unlock(queue);
+}
+EXPORT_SYMBOL_GPL(media_request_queue_release);
+
+/*
+ * Process the MEDIA_REQ_CMD_ALLOC command
+ */
+static int media_request_cmd_alloc(struct media_request_queue *queue,
+				   struct media_request_cmd *cmd)
+{
+	struct media_request *req;
+	int fd;
+
+	req = queue->ops->req_alloc(queue);
+	if (!req)
+		return -ENOMEM;
+
+	req->queue = queue;
+	req->state = MEDIA_REQUEST_STATE_IDLE;
+	kref_init(&req->kref);
+	INIT_LIST_HEAD(&req->data);
+	init_waitqueue_head(&req->wait_queue);
+
+	media_request_queue_lock(queue);
+	req->id = ++queue->req_id;
+	list_add_tail(&req->list, &queue->requests);
+	media_request_queue_unlock(queue);
+
+	fd = anon_inode_getfd("media_request", &request_fops, req, O_CLOEXEC);
+	if (fd < 0)
+		return fd;
+
+	cmd->fd = fd;
+
+	return 0;
+}
+
+/*
+ * Process the MEDIA_REQ_CMD_QUEUE command
+ */
+static int media_request_cmd_queue(struct media_request_queue *queue,
+				   struct media_request *req)
+{
+	int ret = 0;
+
+	media_request_queue_lock(queue);
+
+	if (req->state != MEDIA_REQUEST_STATE_IDLE) {
+		dev_dbg(queue->mdev->dev,
+			"%s: unable to queue request %u in state %s\n",
+			__func__, req->id, media_request_state(req->state));
+		media_request_queue_unlock(queue);
+		return -EINVAL;
+	}
+
+	req->state = MEDIA_REQUEST_STATE_QUEUED;
+	ret = queue->ops->req_queue(queue, req);
+	if (ret) {
+		req->state = MEDIA_REQUEST_STATE_IDLE;
+		media_request_queue_unlock(queue);
+		dev_dbg(queue->mdev->dev, "%s: cannot queue %u\n", __func__,
+			req->id);
+		return ret;
+	}
+
+	media_request_queue_unlock(queue);
+
+	/* The queue holds a reference to the request */
+	media_request_get(req);
+
+	return 0;
+}
+
+static int media_request_cmd_reinit(struct media_request_queue *queue,
+				    struct media_request *req)
+{
+	struct media_request_entity_data *data, *next;
+
+	media_request_queue_lock(queue);
+
+	if (req->state == MEDIA_REQUEST_STATE_QUEUED) {
+		dev_dbg(queue->mdev->dev,
+			"%s: unable to reinit queued request %u\n", __func__,
+			req->id);
+		media_request_queue_unlock(queue);
+		return -EINVAL;
+	}
+
+	/* delete all entity data */
+	list_for_each_entry_safe(data, next, &req->data, list) {
+		list_del(&data->list);
+		data->entity->req_ops->release_data(data);
+	}
+
+	/* reinitialize request to idle state */
+	req->state = MEDIA_REQUEST_STATE_IDLE;
+
+	media_request_queue_unlock(queue);
+
+	return 0;
+}
+
+long media_device_request_cmd(struct media_device *mdev,
+			      struct media_request_cmd *cmd)
+{
+	struct media_request *req = NULL;
+	int ret;
+
+	if (!mdev->req_queue)
+		return -ENOTTY;
+
+	if (cmd->cmd != MEDIA_REQ_CMD_ALLOC) {
+		req = media_request_get_from_fd(cmd->fd);
+		if (IS_ERR(req))
+			return PTR_ERR(req);
+
+		/* requests must belong to this media device's queue */
+		if (req->queue != mdev->req_queue) {
+			media_request_put(req);
+			return -EINVAL;
+		}
+	}
+
+	switch (cmd->cmd) {
+	case MEDIA_REQ_CMD_ALLOC:
+		ret = media_request_cmd_alloc(mdev->req_queue, cmd);
+		break;
+
+	case MEDIA_REQ_CMD_QUEUE:
+		ret = media_request_cmd_queue(mdev->req_queue, req);
+		break;
+
+	case MEDIA_REQ_CMD_REINIT:
+		ret = media_request_cmd_reinit(mdev->req_queue, req);
+		break;
+
+	default:
+		ret = -EINVAL;
+		break;
+	}
+
+	if (req)
+		media_request_put(req);
+
+	return ret;
+}
diff --git a/drivers/media/v4l2-core/v4l2-ioctl.c b/drivers/media/v4l2-core/v4l2-ioctl.c
index b60a6b0841d1..ec4ecd5aa8bf 100644
--- a/drivers/media/v4l2-core/v4l2-ioctl.c
+++ b/drivers/media/v4l2-core/v4l2-ioctl.c
@@ -867,7 +867,7 @@ static int check_ext_ctrls(struct v4l2_ext_controls *c, int allow_priv)
 	__u32 i;
 
 	/* zero the reserved fields */
-	c->reserved[0] = c->reserved[1] = 0;
+	c->reserved[0] = 0;
 	for (i = 0; i < c->count; i++)
 		c->controls[i].reserved2[0] = 0;
 
diff --git a/include/media/media-device.h b/include/media/media-device.h
index bcc6ec434f1f..3feaa02128d1 100644
--- a/include/media/media-device.h
+++ b/include/media/media-device.h
@@ -27,6 +27,7 @@
 
 struct ida;
 struct device;
+struct media_request_queue;
 
 /**
  * struct media_entity_notify - Media Entity Notify
@@ -158,6 +159,8 @@ struct media_device {
 	void (*disable_source)(struct media_entity *entity);
 
 	const struct media_device_ops *ops;
+
+	struct media_request_queue *req_queue;
 };
 
 /* We don't need to include pci.h or usb.h here */
diff --git a/include/media/media-entity.h b/include/media/media-entity.h
index 222d379960b7..bfb7a4565904 100644
--- a/include/media/media-entity.h
+++ b/include/media/media-entity.h
@@ -26,6 +26,9 @@
 #include <linux/list.h>
 #include <linux/media.h>
 
+struct media_request;
+struct media_request_entity_data;
+
 /* Enums used internally at the media controller to represent graphs */
 
 /**
@@ -193,6 +196,8 @@ struct media_entity_operations {
 			  const struct media_pad *local,
 			  const struct media_pad *remote, u32 flags);
 	int (*link_validate)(struct media_link *link);
+	int (*process_request)(struct media_request *req,
+			       struct media_request_entity_data *data);
 };
 
 /**
@@ -275,6 +280,7 @@ struct media_entity {
 	struct list_head links;
 
 	const struct media_entity_operations *ops;
+	const struct media_request_entity_ops *req_ops;
 
 	int stream_count;
 	int use_count;
diff --git a/include/media/media-request.h b/include/media/media-request.h
new file mode 100644
index 000000000000..ead7fd8898c4
--- /dev/null
+++ b/include/media/media-request.h
@@ -0,0 +1,269 @@
+/*
+ * Generic request queue.
+ *
+ * Copyright (C) 2017, The Chromium OS Authors.  All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ */
+
+#ifndef _MEDIA_REQUEST_H
+#define _MEDIA_REQUEST_H
+
+#include <linux/kref.h>
+#include <linux/wait.h>
+#include <linux/list.h>
+
+struct media_device;
+struct media_request_queue;
+struct media_request_cmd;
+struct media_entity;
+struct media_request_entity_data;
+
+#ifdef CONFIG_MEDIA_CONTROLLER
+
+enum media_request_state {
+	MEDIA_REQUEST_STATE_IDLE,
+	MEDIA_REQUEST_STATE_QUEUED,
+	MEDIA_REQUEST_STATE_COMPLETE,
+	MEDIA_REQUEST_STATE_DELETED,
+};
+
+/**
+ * struct media_request - Media request base structure
+ * @id:		request id, used internally for debugging
+ * @queue:	request queue this request belongs to
+ * @kref: 	reference count
+ * @list: 	list entry in the media device requests list
+ * @state:	current state of the request
+ * @data:	per-entity data list
+ * @wait_queue:	wait queue that signals once the request has completed
+ */
+struct media_request {
+	u32 id;
+	struct media_request_queue *queue;
+	struct kref kref;
+	struct list_head list;
+	enum media_request_state state;
+	struct list_head data;
+	wait_queue_head_t wait_queue;
+};
+
+/**
+ * media_request_get() - increment the reference counter of a request
+ *
+ * The calling context must call media_request_put() once it does not need
+ * the reference to the request anymore.
+ *
+ * @req:	request to acquire a reference of
+ */
+void media_request_get(struct media_request *req);
+
+/**
+ * media_request_get_from_fd() - lookup request by fd and acquire a reference.
+ *
+ * Look a request up from its fd, acquire a reference and return a pointer to
+ * the request. As for media_request_get(), media_request_put() must be called
+ * once the reference is not used anymore.
+ *
+ * @req:	request to lookup and acquire.
+ *
+ */
+struct media_request *media_request_get_from_fd(int fd);
+
+/**
+ * media_request_put() - decrement the reference counter of a request
+ *
+ * Mirror function of media_request_get() and media_request_get_from_fd(). Will
+ * free the request if this was the last valid reference.
+ *
+ * @req:	request to release.
+ */
+void media_request_put(struct media_request *req);
+
+/**
+ * media_request_get_entity_data() - get per-entity data for a request
+ * @req:	request to get entity data from
+ * @entity:	entity to get data of
+ * @fh:		cookie identifying the handle from which the entity is accessed
+ *
+ * Seach and return the entity data associated associated to the request. If no
+ * such data exists, it is allocated as per the entity operations.
+ *
+ * The fh arguments serves as a cookie to make sure the same entity is not
+ * accessed through different opened file handles. The same handle must be
+ * passed to all calls of this function for the same entity. Failure to do so
+ * will return an error.
+ *
+ * Returns the per-entity data, or an error code if a problem happened. -EINVAL
+ * means that data for the entity already existed, but has been allocated under
+ * a different cookie.
+ */
+struct media_request_entity_data *
+media_request_get_entity_data(struct media_request *req,
+			      struct media_entity *entity, void *fh);
+
+
+/**
+ * media_request_entity_complete() - to be invoked when an entity has completed
+ *				     its part of the currently active request
+ *
+ * @queue:	request queue
+ * @entity:	the entity that completed
+ */
+void media_request_entity_complete(struct media_request_queue *queue,
+				   struct media_entity *entity);
+
+/**
+ * struct media_request_queue_ops - request queue operations
+ *
+ * @release:	release all memory associated to the queue
+ * @req_qlloc:	allocate a request for this queue
+ * @req_free:	free a previously allocated request
+ * @req_queue:	queue a request for execution
+ * @req_complete: callback invoked when the active request has completed
+ *
+ */
+struct media_request_queue_ops {
+	void (*release)(struct media_request_queue *queue);
+	struct media_request *(*req_alloc)(struct media_request_queue *queue);
+	void (*req_free)(struct media_request_queue *queue,
+			 struct media_request *req);
+	int (*req_queue)(struct media_request_queue *queue,
+			 struct media_request *req);
+	void (*req_complete)(struct media_request_queue *queue);
+};
+
+/**
+ * struct media_request_queue - queue of requests
+ *
+ * @mdev:	media_device that manages this queue
+ * @ops:	implementation of the queue
+ * @mutex:	protects requests, active_request, req_id, and all members of
+ *		struct media_request
+ * @active_request: request being currently run by this queue
+ * @requests:	list of requests (not in any particular order) that this
+ *		queue owns.
+ * @req_id:	counter used to identify requests for debugging purposes
+ */
+struct media_request_queue {
+	struct media_device *mdev;
+	const struct media_request_queue_ops *ops;
+
+	struct mutex mutex;
+	struct list_head requests;
+	struct media_request *active_request;
+	u32 req_id;
+};
+
+static inline void media_request_queue_lock(struct media_request_queue *queue)
+{
+	mutex_lock(&queue->mutex);
+}
+
+static inline void media_request_queue_unlock(struct media_request_queue *queue)
+{
+	mutex_unlock(&queue->mutex);
+}
+
+/**
+ * media_request_queue_init() - initialize a request queue
+ *
+ * This function is to be called by request queue implementations to initialize
+ * the base structure.
+ *
+ * @queue:	queue to initialize
+ * @mdev:	media device owning this queue
+ * @ops:	ops to be used with this queue
+ */
+void media_request_queue_init(struct media_request_queue *queue,
+			      struct media_device *mdev,
+			      const struct media_request_queue_ops *ops);
+
+/**
+ * media_request_queue_release() - release resources held by a request queue
+ *
+ * The caller is still responsible for freeing the memory held by the queue
+ * structure itself.
+ *
+ * @queue:	queue to be released
+ */
+void media_request_queue_release(struct media_request_queue *queue);
+
+/**
+ * struct media_request_entity_data - per-entity request data
+ *
+ * Base structure used to store request state data. To be extended by actual
+ * implementation.
+ *
+ * @entity:	entity this data belongs to
+ * @fh:		subsystem-dependent. For V4L2, the v4l2_fh of the opened device
+ * @list:	entry in media_request::data
+ * @completed:	whether this entity has completed its part of the request
+ */
+struct media_request_entity_data {
+	struct media_entity *entity;
+	void *fh;
+	struct list_head list;
+	bool completed;
+};
+
+/**
+ * struct media_request_entity_ops - request-related entity operations
+ *
+ * All these operations are mandatory if the request API is to be used with
+ * an entity.
+ *
+ * @alloc_data:		allocate request data for this entity
+ * @release_data:	release previously allocated data
+ * @apply_data:		apply the data to the entity prior to running a request
+ *
+ */
+struct media_request_entity_ops {
+	struct media_request_entity_data *(*alloc_data)
+		(struct media_request *req, struct media_entity *entity);
+	void (*release_data)(struct media_request_entity_data *data);
+	int (*apply_data)(struct media_request_entity_data *data);
+};
+
+/**
+ * media_device_request_cmd() - perform the REQUEST_CMD ioctl
+ *
+ * @mdev:	media device the ioctl has been called on
+ * @cmd:	user-space request command structure
+ */
+long media_device_request_cmd(struct media_device *mdev,
+			      struct media_request_cmd *cmd);
+
+#else /* CONFIG_MEDIA_CONTROLLER */
+
+static inline struct media_request *media_request_get_from_fd(int fd)
+{
+	return ERR_PTR(-ENOTSUPP);
+}
+
+static inline void media_request_put(struct media_request *req)
+{
+}
+
+static inline struct media_request *media_request_get_entity_data(
+					  struct media_request *req,
+					  struct media_entity *entity, void *fh)
+{
+	return ERR_PTR(-ENOTSUPP);
+}
+
+static inline void media_request_entity_complete(struct media_request *req,
+						 struct media_entity *entity)
+{
+}
+
+#endif /* CONFIG_MEDIA_CONTROLLER */
+
+#endif
diff --git a/include/uapi/linux/media.h b/include/uapi/linux/media.h
index b9b9446095e9..247823ea0d1a 100644
--- a/include/uapi/linux/media.h
+++ b/include/uapi/linux/media.h
@@ -406,6 +406,16 @@ struct media_v2_topology {
 	__u64 ptr_links;
 } __attribute__ ((packed));
 
+#define MEDIA_REQ_CMD_ALLOC		0
+#define MEDIA_REQ_CMD_QUEUE		1
+#define MEDIA_REQ_CMD_REINIT		2
+
+struct media_request_cmd {
+	__u32 cmd;
+	__s32 fd;
+	__u32 flags;
+} __attribute__ ((packed));
+
 /* ioctls */
 
 #define MEDIA_IOC_DEVICE_INFO		_IOWR('|', 0x00, struct media_device_info)
@@ -413,5 +423,6 @@ struct media_v2_topology {
 #define MEDIA_IOC_ENUM_LINKS		_IOWR('|', 0x02, struct media_links_enum)
 #define MEDIA_IOC_SETUP_LINK		_IOWR('|', 0x03, struct media_link_desc)
 #define MEDIA_IOC_G_TOPOLOGY		_IOWR('|', 0x04, struct media_v2_topology)
+#define MEDIA_IOC_REQUEST_CMD		_IOWR('|', 0x05, struct media_request_cmd)
 
 #endif /* __LINUX_MEDIA_H */
-- 
2.15.1.504.g5279b80103-goog
