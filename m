Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pf0-f196.google.com ([209.85.192.196]:36308 "EHLO
        mail-pf0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751989AbeBGBsf (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Tue, 6 Feb 2018 20:48:35 -0500
Received: by mail-pf0-f196.google.com with SMTP id k5so1478912pff.3
        for <linux-media@vger.kernel.org>; Tue, 06 Feb 2018 17:48:35 -0800 (PST)
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
Subject: [RFCv3 01/17] media: add request API core and UAPI
Date: Wed,  7 Feb 2018 10:48:05 +0900
Message-Id: <20180207014821.164536-2-acourbot@chromium.org>
In-Reply-To: <20180207014821.164536-1-acourbot@chromium.org>
References: <20180207014821.164536-1-acourbot@chromium.org>
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
 drivers/media/media-device.c         |   7 +
 drivers/media/media-request-mgr.c    | 105 ++++++++++++
 drivers/media/media-request.c        | 311 +++++++++++++++++++++++++++++++++++
 drivers/media/v4l2-core/v4l2-ioctl.c |   2 +-
 include/media/media-device.h         |   3 +
 include/media/media-entity.h         |   9 +
 include/media/media-request-mgr.h    |  73 ++++++++
 include/media/media-request.h        | 186 +++++++++++++++++++++
 include/uapi/linux/media.h           |  10 ++
 10 files changed, 707 insertions(+), 2 deletions(-)
 create mode 100644 drivers/media/media-request-mgr.c
 create mode 100644 drivers/media/media-request.c
 create mode 100644 include/media/media-request-mgr.h
 create mode 100644 include/media/media-request.h

diff --git a/drivers/media/Makefile b/drivers/media/Makefile
index 594b462ddf0e..06c43ddb52ea 100644
--- a/drivers/media/Makefile
+++ b/drivers/media/Makefile
@@ -3,7 +3,8 @@
 # Makefile for the kernel multimedia device drivers.
 #
 
-media-objs	:= media-device.o media-devnode.o media-entity.o
+media-objs	:= media-device.o media-devnode.o media-entity.o \
+		   media-request.o media-request-mgr.o
 
 #
 # I2C drivers should come before other drivers, otherwise they'll fail
diff --git a/drivers/media/media-device.c b/drivers/media/media-device.c
index e79f72b8b858..024ee81a8334 100644
--- a/drivers/media/media-device.c
+++ b/drivers/media/media-device.c
@@ -32,6 +32,8 @@
 #include <media/media-device.h>
 #include <media/media-devnode.h>
 #include <media/media-entity.h>
+#include <media/media-request.h>
+#include <media/media-request-mgr.h>
 
 #ifdef CONFIG_MEDIA_CONTROLLER
 
@@ -407,6 +409,7 @@ static const struct media_ioctl_info ioctl_info[] = {
 	MEDIA_IOC(ENUM_LINKS, media_device_enum_links, MEDIA_IOC_FL_GRAPH_MUTEX),
 	MEDIA_IOC(SETUP_LINK, media_device_setup_link, MEDIA_IOC_FL_GRAPH_MUTEX),
 	MEDIA_IOC(G_TOPOLOGY, media_device_get_topology, MEDIA_IOC_FL_GRAPH_MUTEX),
+	MEDIA_IOC(REQUEST_CMD, media_device_request_cmd, 0),
 };
 
 static long media_device_ioctl(struct file *filp, unsigned int cmd,
@@ -688,6 +691,10 @@ EXPORT_SYMBOL_GPL(media_device_init);
 
 void media_device_cleanup(struct media_device *mdev)
 {
+	if (mdev->req_mgr) {
+		media_request_mgr_free(mdev->req_mgr);
+		mdev->req_mgr = NULL;
+	}
 	ida_destroy(&mdev->entity_internal_idx);
 	mdev->entity_internal_idx_max = 0;
 	media_graph_walk_cleanup(&mdev->pm_count_walk);
diff --git a/drivers/media/media-request-mgr.c b/drivers/media/media-request-mgr.c
new file mode 100644
index 000000000000..686e877a884b
--- /dev/null
+++ b/drivers/media/media-request-mgr.c
@@ -0,0 +1,105 @@
+/*
+ * Generic request manager implementation.
+ *
+ * Copyright (C) 2018, The Chromium OS Authors.  All rights reserved.
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
+#include <linux/device.h>
+#include <linux/slab.h>
+
+#include <media/media-device.h>
+#include <media/media-request.h>
+#include <media/media-request-mgr.h>
+
+static struct media_request *
+media_request_alloc(struct media_request_mgr *mgr)
+{
+	struct media_request *req;
+
+	req = kzalloc(sizeof(*req), GFP_KERNEL);
+	if (!req)
+		return ERR_PTR(-ENOMEM);
+
+	req->mgr = mgr;
+	req->state = MEDIA_REQUEST_STATE_IDLE;
+	kref_init(&req->kref);
+	INIT_LIST_HEAD(&req->data);
+	init_waitqueue_head(&req->complete_wait);
+	ATOMIC_INIT_NOTIFIER_HEAD(&req->submit_notif);
+	mutex_init(&req->lock);
+
+	mutex_lock(&mgr->mutex);
+	req->id = ++mgr->req_id;
+	list_add_tail(&req->list, &mgr->requests);
+	mutex_unlock(&mgr->mutex);
+
+	return req;
+}
+
+static void media_request_free(struct media_request *req)
+{
+	struct media_request_mgr *mgr = req->mgr;
+	struct media_request_entity_data *data, *next;
+
+	mutex_lock(&mgr->mutex);
+	list_del(&req->list);
+	mutex_unlock(&mgr->mutex);
+
+	list_for_each_entry_safe(data, next, &req->data, list) {
+		list_del(&data->list);
+		data->entity->req_ops->data_free(data);
+	}
+
+	kfree(req);
+}
+
+void media_request_mgr_free(struct media_request_mgr *mgr)
+{
+	struct media_device *mdev = mgr->mdev;
+
+	/* Just a sanity check - we should have no remaining requests */
+	while (!list_empty(&mgr->requests)) {
+		struct media_request *req;
+
+		req = list_first_entry(&mgr->requests, typeof(*req), list);
+		dev_warn(mdev->dev,
+			"%s: request %u still referenced, deleting forcibly!\n",
+			__func__, req->id);
+		mgr->ops->req_free(req);
+	}
+
+	kfree(mgr);
+}
+EXPORT_SYMBOL_GPL(media_request_mgr_free);
+
+static const struct media_request_mgr_ops request_mgr_generic_ops = {
+	.req_alloc = media_request_alloc,
+	.req_free = media_request_free,
+};
+
+struct media_request_mgr *
+media_request_mgr_alloc(struct media_device *mdev)
+{
+	struct media_request_mgr *mgr;
+
+	mgr = kzalloc(sizeof(*mgr), GFP_KERNEL);
+	if (!mgr)
+		return ERR_PTR(-ENOMEM);
+
+	mgr->mdev = mdev;
+	mutex_init(&mgr->mutex);
+	INIT_LIST_HEAD(&mgr->requests);
+	mgr->ops = &request_mgr_generic_ops;
+
+	return mgr;
+}
+EXPORT_SYMBOL_GPL(media_request_mgr_alloc);
diff --git a/drivers/media/media-request.c b/drivers/media/media-request.c
new file mode 100644
index 000000000000..30a23235b019
--- /dev/null
+++ b/drivers/media/media-request.c
@@ -0,0 +1,311 @@
+/*
+ * Request base implementation
+ *
+ * Copyright (C) 2018, The Chromium OS Authors.  All rights reserved.
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
+#include <media/media-device.h>
+#include <media/media-request.h>
+#include <media/media-request-mgr.h>
+
+const struct file_operations request_fops;
+
+struct media_request *media_request_get(struct media_request *req)
+{
+	kref_get(&req->kref);
+	return req;
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
+	struct media_request *req =
+		container_of(kref, typeof(*req), kref);
+
+	req->mgr->ops->req_free(req);
+}
+
+void media_request_put(struct media_request *req)
+{
+	if (WARN_ON(req == NULL))
+		return;
+
+	kref_put(&req->kref, media_request_release);
+}
+EXPORT_SYMBOL_GPL(media_request_put);
+
+struct media_request_entity_data *
+media_request_get_entity_data(struct media_request *req,
+			      struct media_entity *entity, void *fh)
+{
+	struct media_request_entity_data *data;
+
+	mutex_lock(&req->lock);
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
+	data = entity->req_ops->data_alloc(entity, fh);
+	if (IS_ERR(data))
+		goto done;
+	data->fh = fh;
+	data->entity = entity;
+	list_add_tail(&data->list, &req->data);
+
+done:
+	mutex_unlock(&req->lock);
+	return data;
+}
+EXPORT_SYMBOL_GPL(media_request_get_entity_data);
+
+static const char * const media_request_states[] __maybe_unused = {
+	"IDLE",
+	"SUBMITTED",
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
+	poll_wait(file, &req->complete_wait, wait);
+
+	if (req->state == MEDIA_REQUEST_STATE_COMPLETED)
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
+void media_request_complete(struct media_request *req)
+{
+	struct media_request_mgr *mgr = req->mgr;
+	struct media_device *mdev = mgr->mdev;
+
+	mutex_lock(&req->lock);
+
+	if (WARN_ON(req->state != MEDIA_REQUEST_STATE_SUBMITTED)) {
+		dev_dbg(mdev->dev, "%s: can't complete %u, state %s\n",
+			__func__, req->id, media_request_state(req->state));
+		mutex_unlock(&req->lock);
+		return;
+	}
+
+	req->state = MEDIA_REQUEST_STATE_COMPLETED;
+
+	if (mgr->ops->req_complete)
+		mgr->ops->req_complete(req);
+
+	wake_up_interruptible(&req->complete_wait);
+
+	mutex_unlock(&req->lock);
+
+	/* Release the reference acquired when we submitted the request */
+	media_request_put(req);
+}
+EXPORT_SYMBOL_GPL(media_request_complete);
+
+/*
+ * Process the MEDIA_REQ_CMD_ALLOC command
+ */
+static int media_request_cmd_alloc(struct media_request_mgr *mgr,
+				   struct media_request_cmd *cmd)
+{
+	struct media_request *req;
+	int fd;
+
+	req = mgr->ops->req_alloc(mgr);
+	if (!req)
+		return -ENOMEM;
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
+ * Process the MEDIA_REQ_CMD_SUBMIT command
+ */
+static int media_request_cmd_submit(struct media_request *req)
+{
+	mutex_lock(&req->lock);
+
+	if (req->state != MEDIA_REQUEST_STATE_IDLE) {
+		dev_dbg(req->mgr->mdev->dev,
+			"%s: unable to submit request in state %s\n",
+			__func__, media_request_state(req->state));
+		mutex_unlock(&req->lock);
+		return -EINVAL;
+	}
+
+	if (atomic_read(&req->buf_cpt) == 0) {
+		dev_dbg(req->mgr->mdev->dev,
+			"%s: request has no buffers!\n", __func__);
+		mutex_unlock(&req->lock);
+		return -EINVAL;
+	}
+
+	req->state = MEDIA_REQUEST_STATE_SUBMITTED;
+
+	/* Hold a reference to the request until it is completed */
+	media_request_get(req);
+
+	mutex_unlock(&req->lock);
+
+	atomic_notifier_call_chain(&req->submit_notif, req->state, req);
+
+	return 0;
+}
+
+static int media_request_cmd_reinit(struct media_request *req)
+{
+	struct media_request_entity_data *data, *next;
+
+	mutex_lock(&req->lock);
+
+	if (req->state == MEDIA_REQUEST_STATE_SUBMITTED) {
+		dev_dbg(req->mgr->mdev->dev,
+			"%s: unable to reinit submitted request\n", __func__);
+		mutex_unlock(&req->lock);
+		return -EINVAL;
+	}
+
+	/* delete all entity data */
+	list_for_each_entry_safe(data, next, &req->data, list) {
+		list_del(&data->list);
+		data->entity->req_ops->data_free(data);
+	}
+
+	/* reinitialize request to idle state */
+	req->state = MEDIA_REQUEST_STATE_IDLE;
+	atomic_set(&req->buf_cpt, 0);
+
+	mutex_unlock(&req->lock);
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
+	if (!mdev->req_mgr)
+		return -ENOTTY;
+
+	if (cmd->cmd != MEDIA_REQ_CMD_ALLOC) {
+		req = media_request_get_from_fd(cmd->fd);
+		if (IS_ERR(req))
+			return PTR_ERR(req);
+
+		/* requests must belong to this media device's manager */
+		if (req->mgr != mdev->req_mgr) {
+			media_request_put(req);
+			return -EINVAL;
+		}
+	}
+
+	switch (cmd->cmd) {
+	case MEDIA_REQ_CMD_ALLOC:
+		ret = media_request_cmd_alloc(mdev->req_mgr, cmd);
+		break;
+
+	case MEDIA_REQ_CMD_SUBMIT:
+		ret = media_request_cmd_submit(req);
+		break;
+
+	case MEDIA_REQ_CMD_REINIT:
+		ret = media_request_cmd_reinit(req);
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
index 260288ca4f55..e5109e5b8bf5 100644
--- a/drivers/media/v4l2-core/v4l2-ioctl.c
+++ b/drivers/media/v4l2-core/v4l2-ioctl.c
@@ -870,7 +870,7 @@ static int check_ext_ctrls(struct v4l2_ext_controls *c, int allow_priv)
 	__u32 i;
 
 	/* zero the reserved fields */
-	c->reserved[0] = c->reserved[1] = 0;
+	c->reserved[0] = 0;
 	for (i = 0; i < c->count; i++)
 		c->controls[i].reserved2[0] = 0;
 
diff --git a/include/media/media-device.h b/include/media/media-device.h
index bcc6ec434f1f..f2d471b8a53f 100644
--- a/include/media/media-device.h
+++ b/include/media/media-device.h
@@ -27,6 +27,7 @@
 
 struct ida;
 struct device;
+struct media_request_mgr;
 
 /**
  * struct media_entity_notify - Media Entity Notify
@@ -158,6 +159,8 @@ struct media_device {
 	void (*disable_source)(struct media_entity *entity);
 
 	const struct media_device_ops *ops;
+
+	struct media_request_mgr *req_mgr;
 };
 
 /* We don't need to include pci.h or usb.h here */
diff --git a/include/media/media-entity.h b/include/media/media-entity.h
index a732af1dbba0..39f5e88e2b23 100644
--- a/include/media/media-entity.h
+++ b/include/media/media-entity.h
@@ -172,6 +172,8 @@ struct media_pad {
 	unsigned long flags;
 };
 
+struct media_request;
+struct v4l2_ext_controls;
 /**
  * struct media_entity_operations - Media entity operations
  * @get_fwnode_pad:	Return the pad number based on a fwnode endpoint or
@@ -197,6 +199,11 @@ struct media_entity_operations {
 	int (*link_validate)(struct media_link *link);
 };
 
+struct media_entity_request_ops {
+	struct media_request_entity_data *(*data_alloc)(struct media_entity *entity, void *fh);
+	void (*data_free)(struct media_request_entity_data *data);
+};
+
 /**
  * enum media_entity_type - Media entity type
  *
@@ -281,6 +288,8 @@ struct media_entity {
 
 	const struct media_entity_operations *ops;
 
+	const struct media_entity_request_ops *req_ops;
+
 	int stream_count;
 	int use_count;
 
diff --git a/include/media/media-request-mgr.h b/include/media/media-request-mgr.h
new file mode 100644
index 000000000000..a3161fa2add0
--- /dev/null
+++ b/include/media/media-request-mgr.h
@@ -0,0 +1,73 @@
+/*
+ * Generic request manager.
+ *
+ * Copyright (C) 2018, The Chromium OS Authors.  All rights reserved.
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
+#ifndef _MEDIA_REQUEST_MGR_H
+#define _MEDIA_REQUEST_MGR_H
+
+#include <linux/mutex.h>
+
+struct media_request_mgr;
+
+/**
+ * struct media_request_mgr_ops - request manager operations
+ *
+ * @req_alloc:	allocate a request
+ * @req_free:	free a previously allocated request
+ * @req_complete: callback invoked when a request has completed
+ *
+ */
+struct media_request_mgr_ops {
+	struct media_request *(*req_alloc)(struct media_request_mgr *mgr);
+	void (*req_free)(struct media_request *req);
+	void (*req_complete)(struct media_request *req);
+};
+
+/**
+ * struct media_request_mgr - requests manager
+ *
+ * @mdev:	media_device owning this manager
+ * @ops:	implementation of the manager
+ * @mutex:	protects requests, active_request, req_id, and all members of
+ *		struct media_request
+ * @requests:	list of alive requests produced by this manager
+ * @req_id:	counter used to identify requests for debugging purposes
+ */
+struct media_request_mgr {
+	struct media_device *mdev;
+	const struct media_request_mgr_ops *ops;
+
+	struct mutex mutex;
+	struct list_head requests;
+	u32 req_id;
+};
+
+/**
+ * media_request_mgr_alloc() - return an instance of the generic manager
+ *
+ * @mdev:	owning media device
+ */
+struct media_request_mgr *
+media_request_mgr_alloc(struct media_device *mdev);
+
+/**
+ * media_request_mgr_free() - free a media manager
+ *
+ * This should only be called when all requests produced by this manager
+ * has been destroyed. Will warn if that is not the case.
+ *
+ */
+void media_request_mgr_free(struct media_request_mgr *mgr);
+
+#endif
diff --git a/include/media/media-request.h b/include/media/media-request.h
new file mode 100644
index 000000000000..817df13ef6e3
--- /dev/null
+++ b/include/media/media-request.h
@@ -0,0 +1,186 @@
+/*
+ * Media requests.
+ *
+ * Copyright (C) 2018, The Chromium OS Authors.  All rights reserved.
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
+#include <linux/list.h>
+#include <linux/notifier.h>
+#include <linux/wait.h>
+
+struct media_device;
+struct media_entity;
+struct media_request_cmd;
+struct media_request_entity_data;
+struct media_request_mgr;
+
+#ifdef CONFIG_MEDIA_CONTROLLER
+
+enum media_request_state {
+	MEDIA_REQUEST_STATE_IDLE,
+	MEDIA_REQUEST_STATE_SUBMITTED,
+	MEDIA_REQUEST_STATE_COMPLETED,
+	MEDIA_REQUEST_STATE_DELETED,
+};
+
+/**
+ * struct media_request - Media request base structure
+ * @id:		request id, used internally for debugging
+ * @mgr:	manager this request belongs to
+ * @kref:	reference count
+ * @list:	list entry in the media device requests list
+ * @lock:	protects internal state against concurrent accesses
+ * @state:	current state of the request
+ * @data:	per-entity data list
+ * @complete_wait:	wait queue that signals once the request has completed
+ * @submit_notif:	notification list to call when the request is submitted
+ * @buf_cpt:	counter of queued/completed buffers used to decide when the
+ *		request is completed
+ */
+struct media_request {
+	u32 id;
+	struct media_request_mgr *mgr;
+	struct kref kref;
+	struct list_head list;
+
+	struct mutex lock;
+	enum media_request_state state;
+	struct list_head data;
+	wait_queue_head_t complete_wait;
+	struct atomic_notifier_head submit_notif;
+	atomic_t buf_cpt;
+};
+
+/**
+ * media_request_get() - increment the reference counter of a request
+ *
+ * The calling context must call media_request_put() once it does not need
+ * the reference to the request anymore.
+ *
+ * Returns the request that has been passed as argument.
+ *
+ * @req:	request to acquire a reference of
+ */
+struct media_request *media_request_get(struct media_request *req);
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
+ * Search and return the entity data associated associated to the request. If no
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
+ * media_request_complete() - to be invoked when the request is complete
+ *
+ * @req:	request which has completed
+ */
+void media_request_complete(struct media_request *req);
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
+ * @applied:	whether this request has already been applied for this entity
+ */
+struct media_request_entity_data {
+	struct media_entity *entity;
+	void *fh;
+	struct list_head list;
+	bool applied;
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
+static inline media_request_get(struct media_request *req)
+{
+}
+
+static inline struct media_request *media_request_get_from_fd(int fd)
+{
+	return ERR_PTR(-ENOSYS);
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
+	return ERR_PTR(-ENOSYS);
+}
+
+static inline void media_request_entity_complete(struct media_request *req)
+{
+}
+
+#endif /* CONFIG_MEDIA_CONTROLLER */
+
+#endif
diff --git a/include/uapi/linux/media.h b/include/uapi/linux/media.h
index b9b9446095e9..6e20ac9848b5 100644
--- a/include/uapi/linux/media.h
+++ b/include/uapi/linux/media.h
@@ -406,6 +406,15 @@ struct media_v2_topology {
 	__u64 ptr_links;
 } __attribute__ ((packed));
 
+#define MEDIA_REQ_CMD_ALLOC		0
+#define MEDIA_REQ_CMD_SUBMIT		1
+#define MEDIA_REQ_CMD_REINIT		2
+
+struct media_request_cmd {
+	__u32 cmd;
+	__s32 fd;
+} __attribute__ ((packed));
+
 /* ioctls */
 
 #define MEDIA_IOC_DEVICE_INFO		_IOWR('|', 0x00, struct media_device_info)
@@ -413,5 +422,6 @@ struct media_v2_topology {
 #define MEDIA_IOC_ENUM_LINKS		_IOWR('|', 0x02, struct media_links_enum)
 #define MEDIA_IOC_SETUP_LINK		_IOWR('|', 0x03, struct media_link_desc)
 #define MEDIA_IOC_G_TOPOLOGY		_IOWR('|', 0x04, struct media_v2_topology)
+#define MEDIA_IOC_REQUEST_CMD		_IOWR('|', 0x05, struct media_request_cmd)
 
 #endif /* __LINUX_MEDIA_H */
-- 
2.16.0.rc1.238.g530d649a79-goog
