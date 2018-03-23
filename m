Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:47202 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752190AbeCWVS1 (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 23 Mar 2018 17:18:27 -0400
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: linux-media@vger.kernel.org
Cc: hverkuil@xs4all.nl, acourbot@chromium.org,
        Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
Subject: [RFC v2 02/10] media: Add request API
Date: Fri, 23 Mar 2018 23:17:36 +0200
Message-Id: <1521839864-10146-3-git-send-email-sakari.ailus@linux.intel.com>
In-Reply-To: <1521839864-10146-1-git-send-email-sakari.ailus@linux.intel.com>
References: <1521839864-10146-1-git-send-email-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>

The request API allows bundling media device parameters with request
objects and queueing them to be executed atomically.

Signed-off-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Signed-off-by: Alexandre Courbot <acourbot@chromium.org>
---
 drivers/media/Makefile        |   3 +-
 drivers/media/media-device.c  |  15 +
 drivers/media/media-request.c | 650 ++++++++++++++++++++++++++++++++++++++++++
 include/media/media-device.h  |  19 +-
 include/media/media-request.h | 301 +++++++++++++++++++
 include/uapi/linux/media.h    |   8 +
 6 files changed, 994 insertions(+), 2 deletions(-)
 create mode 100644 drivers/media/media-request.c
 create mode 100644 include/media/media-request.h

diff --git a/drivers/media/Makefile b/drivers/media/Makefile
index 594b462..985d35e 100644
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
index da63da1..cc579ce 100644
--- a/drivers/media/media-device.c
+++ b/drivers/media/media-device.c
@@ -32,6 +32,7 @@
 #include <media/media-device.h>
 #include <media/media-devnode.h>
 #include <media/media-entity.h>
+#include <media/media-request.h>
 
 #ifdef CONFIG_MEDIA_CONTROLLER
 
@@ -366,6 +367,16 @@ static long media_device_get_topology(struct media_device *mdev,
 	return ret;
 }
 
+static long media_device_request_alloc(struct media_device *mdev,
+				       struct media_request_new *new)
+{
+	if (!mdev->ops || !mdev->ops->req_alloc || !mdev->ops->req_free ||
+	    !mdev->ops->req_queue)
+		return -ENOTTY;
+
+	return media_request_alloc(mdev, new);
+}
+
 static long copy_arg_from_user(void *karg, void __user *uarg, unsigned int cmd)
 {
 	/* All media IOCTLs are _IOWR() */
@@ -428,6 +439,7 @@ static const struct media_ioctl_info ioctl_info[] = {
 	MEDIA_IOC(ENUM_LINKS, media_device_enum_links, MEDIA_IOC_FL_GRAPH_MUTEX),
 	MEDIA_IOC(SETUP_LINK, media_device_setup_link, MEDIA_IOC_FL_GRAPH_MUTEX),
 	MEDIA_IOC(G_TOPOLOGY, media_device_get_topology, MEDIA_IOC_FL_GRAPH_MUTEX),
+	MEDIA_IOC(REQUEST_ALLOC, media_device_request_alloc, 0),
 };
 
 #define MASK_IOC_SIZE(cmd) \
@@ -739,6 +751,9 @@ void media_device_init(struct media_device *mdev)
 	INIT_LIST_HEAD(&mdev->pads);
 	INIT_LIST_HEAD(&mdev->links);
 	INIT_LIST_HEAD(&mdev->entity_notify);
+	INIT_LIST_HEAD(&mdev->classes);
+	spin_lock_init(&mdev->req_lock);
+
 	mutex_init(&mdev->graph_mutex);
 	ida_init(&mdev->entity_internal_idx);
 
diff --git a/drivers/media/media-request.c b/drivers/media/media-request.c
new file mode 100644
index 0000000..af108a7
--- /dev/null
+++ b/drivers/media/media-request.c
@@ -0,0 +1,650 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Media device request objects
+ *
+ * Copyright (C) 2018 Intel Corporation
+ * Copyright (C) 2018, The Chromium OS Authors.  All rights reserved.
+ *
+ * Author: Sakari Ailus <sakari.ailus@linux.intel.com>
+ */
+
+#include <linux/anon_inodes.h>
+#include <linux/file.h>
+#include <linux/mm.h>
+#include <linux/string.h>
+
+#include <media/media-device.h>
+#include <media/media-request.h>
+
+static const char *__request_state[] = {
+	"IDLE",
+	"QUEUEING",
+	"QUEUED",
+	"COMPLETE",
+	"REINIT",
+};
+
+const char *
+media_request_state_str(enum media_request_state state)
+{
+	if (state < ARRAY_SIZE(__request_state))
+		return __request_state[state];
+
+	return "UNKNOWN";
+}
+
+static void media_request_clean(struct media_request *req)
+{
+	struct media_request_ref *ref, *ref_safe;
+
+	list_for_each_entry_safe(ref, ref_safe, &req->obj_refs, req_list) {
+		media_request_ref_unbind(ref);
+		kfree(ref);
+	}
+}
+
+void media_request_release(struct kref *kref)
+{
+	struct media_request *req =
+		container_of(kref, struct media_request, kref);
+	struct media_device *mdev = req->mdev;
+
+	dev_dbg(mdev->dev, "request: release %s\n", req->debug_str);
+
+	media_request_clean(req);
+
+	mdev->ops->req_free(req);
+}
+EXPORT_SYMBOL_GPL(media_request_release);
+
+static unsigned int media_request_poll(struct file *filp,
+				       struct poll_table_struct *wait)
+{
+	struct media_request *req = filp->private_data;
+	struct media_device *mdev = req->mdev;
+	unsigned int poll_events = poll_requested_events(wait);
+	int ret = 0;
+
+	if (poll_events & (POLLIN | POLLOUT))
+		return POLLERR;
+
+	if (poll_events & POLLPRI) {
+		unsigned long flags;
+		bool complete;
+
+		spin_lock_irqsave(&mdev->req_lock, flags);
+		complete = req->state == MEDIA_REQUEST_STATE_COMPLETE;
+		spin_unlock_irqrestore(&mdev->req_lock, flags);
+
+		if (complete)
+			poll_wait(filp, &req->poll_wait, wait);
+		else
+			ret |= POLLPRI;
+	}
+
+	return ret;
+}
+
+static long media_request_ioctl_queue(struct media_request *req)
+{
+	struct media_device *mdev = req->mdev;
+	unsigned long flags;
+	int ret = 0;
+
+	dev_dbg(mdev->dev, "request: queue %s\n", req->debug_str);
+
+	/*
+	 * Ensure the request that is validated will be the one that gets queued
+	 * next by serialising the queueing process.
+	 */
+	mutex_lock(&mdev->req_queue_mutex);
+
+	spin_lock_irqsave(&mdev->req_lock, flags);
+	if (req->state != MEDIA_REQUEST_STATE_IDLE) {
+		ret = -EINVAL;
+		dev_dbg(mdev->dev,
+			"request: unable to queue %s, request in state %s\n",
+			req->debug_str, media_request_state_str(req->state));
+	} else {
+		req->state = MEDIA_REQUEST_STATE_QUEUEING;
+		media_request_sticky_to_old(req);
+	}
+	spin_unlock_irqrestore(&mdev->req_lock, flags);
+
+	if (ret)
+		goto err_unlock;
+
+	/*
+	 * Obtain a reference to the request, release once complete (or there's
+	 * an error).
+	 */
+	media_request_get(req);
+	spin_lock_irqsave(&mdev->req_lock, flags);
+	req->state = MEDIA_REQUEST_STATE_QUEUED;
+	spin_unlock_irqrestore(&mdev->req_lock, flags);
+
+	ret = mdev->ops->req_queue(req);
+	if (ret) {
+		dev_dbg(mdev->dev, "request: can't queue %s (%d)\n",
+			req->debug_str, ret);
+		goto err_put;
+	}
+
+	spin_lock_irqsave(&mdev->req_lock, flags);
+	media_request_new_to_sticky(req);
+	spin_unlock_irqrestore(&mdev->req_lock, flags);
+
+	mutex_unlock(&mdev->req_queue_mutex);
+
+	return 0;
+
+err_put:
+	media_request_put(req);
+
+	spin_lock_irqsave(&mdev->req_lock, flags);
+	media_request_detach_old(req);
+	spin_unlock_irqrestore(&mdev->req_lock, flags);
+
+err_unlock:
+	spin_lock_irqsave(&mdev->req_lock, flags);
+	req->state = MEDIA_REQUEST_STATE_IDLE;
+	spin_unlock_irqrestore(&mdev->req_lock, flags);
+	mutex_unlock(&mdev->req_queue_mutex);
+
+	return ret;
+}
+
+static long media_request_ioctl_reinit(struct media_request *req)
+{
+	struct media_device *mdev = req->mdev;
+	unsigned long flags;
+
+	spin_lock_irqsave(&mdev->req_lock, flags);
+	if (req->state != MEDIA_REQUEST_STATE_IDLE &&
+	    req->state != MEDIA_REQUEST_STATE_COMPLETE) {
+		dev_dbg(mdev->dev,
+			"request: %s in idle or complete state, cannot reinit\n",
+			req->debug_str);
+		spin_unlock_irqrestore(&mdev->req_lock, flags);
+		return -EINVAL;
+	}
+
+	req->state = MEDIA_REQUEST_STATE_REINIT;
+	spin_unlock_irqrestore(&mdev->req_lock, flags);
+
+	media_request_clean(req);
+
+	spin_lock_irqsave(&mdev->req_lock, flags);
+	req->state = MEDIA_REQUEST_STATE_IDLE;
+	spin_unlock_irqrestore(&mdev->req_lock, flags);
+
+	return 0;
+}
+
+#define MEDIA_REQUEST_IOC(__cmd, func)			\
+	[_IOC_NR(MEDIA_REQUEST_IOC_##__cmd) - 0x80] = {	\
+		.cmd = MEDIA_REQUEST_IOC_##__cmd,	\
+		.fn = func,				\
+	}
+
+struct media_request_ioctl_info {
+	unsigned int cmd;
+	long (*fn)(struct media_request *req);
+};
+
+static const struct media_request_ioctl_info ioctl_info[] = {
+	MEDIA_REQUEST_IOC(QUEUE, media_request_ioctl_queue),
+	MEDIA_REQUEST_IOC(REINIT, media_request_ioctl_reinit),
+};
+
+static long media_request_ioctl(struct file *filp, unsigned int cmd,
+				unsigned long __arg)
+{
+	struct media_request *req = filp->private_data;
+	const struct media_request_ioctl_info *info;
+
+	if (_IOC_NR(cmd) < 0x80 ||
+            _IOC_NR(cmd) >= 0x80 + ARRAY_SIZE(ioctl_info) ||
+            ioctl_info[_IOC_NR(cmd) - 0x80].cmd != cmd)
+		return -ENOIOCTLCMD;
+
+	info = &ioctl_info[_IOC_NR(cmd) - 0x80];
+
+	return info->fn(req);
+}
+
+static int media_request_close(struct inode *inode, struct file *filp)
+{
+	struct media_request *req = filp->private_data;
+
+	media_request_put(req);
+
+	return 0;
+}
+static const struct file_operations request_fops = {
+	.owner = THIS_MODULE,
+	.poll = media_request_poll,
+	.unlocked_ioctl = media_request_ioctl,
+	.release = media_request_close,
+};
+
+/**
+ * media_request_find - Find a request based on the file descriptor
+ * @mdev: The media device
+ * @request: The request file handle
+ *
+ * Find and return the request associated with the given file descriptor, or
+ * an error if no such request exists.
+ *
+ * When the function returns a request it increases its reference count. The
+ * caller is responsible for releasing the reference by calling
+ * media_request_put() on the request.
+ */
+struct media_request *
+media_request_find(struct media_device *mdev, int request)
+{
+	struct file *filp;
+	struct media_request *req;
+
+	filp = fget(request);
+	if (!filp)
+		return ERR_PTR(-ENOENT);
+
+	if (filp->f_op != &request_fops)
+		goto err_fput;
+	req = filp->private_data;
+	media_request_get(req);
+
+	if (req->mdev != mdev)
+		goto err_kref_put;
+
+	fput(filp);
+
+	return req;
+
+err_kref_put:
+	media_request_put(req);
+
+err_fput:
+	fput(filp);
+
+	return ERR_PTR(-EBADF);
+}
+EXPORT_SYMBOL_GPL(media_request_find);
+
+int media_request_alloc(struct media_device *mdev,
+			struct media_request_new *new)
+{
+	struct media_request *req;
+	struct file *filp;
+#ifdef CONFIG_DYNAMIC_DEBUG
+	char comm[TASK_COMM_LEN];
+#endif
+	int fd;
+	int ret;
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
+	req = mdev->ops->req_alloc(mdev);
+	if (!req) {
+		ret = -ENOMEM;
+		goto err_fput;
+	}
+
+	filp->private_data = req;
+	req->mdev = mdev;
+	req->state = MEDIA_REQUEST_STATE_IDLE;
+	kref_init(&req->kref);
+	INIT_LIST_HEAD(&req->obj_refs);
+
+	new->fd = fd;
+
+#ifdef CONFIG_DYNAMIC_DEBUG
+	get_task_comm(comm, current);
+	snprintf(req->debug_str, sizeof(req->debug_str), "%s:%d",
+		 comm, fd);
+#endif
+
+	dev_dbg(mdev->dev, "request: allocated %s\n", req->debug_str);
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
+void media_request_complete(struct media_device *mdev,
+			    struct media_request *req)
+{
+	unsigned long flags;
+
+	spin_lock_irqsave(&mdev->req_lock, flags);
+
+	if (!media_request_is_complete(req)) {
+		spin_unlock_irqrestore(&mdev->req_lock, flags);
+		dev_dbg(mdev->dev, "request: %s is not complete yet\n",
+			req->debug_str);
+		return;
+	}
+
+	if (req->state == MEDIA_REQUEST_STATE_IDLE) {
+		dev_dbg(mdev->dev,
+			"request: not completing an idle request %s\n",
+			req->debug_str);
+		spin_unlock_irqrestore(&mdev->req_lock, flags);
+		return;
+	}
+
+	if (WARN_ON(req->state != MEDIA_REQUEST_STATE_QUEUED)) {
+		dev_dbg(mdev->dev, "request: can't delete %s, state %s\n",
+			req->debug_str,
+			media_request_state_str(req->state));
+		spin_unlock_irqrestore(&mdev->req_lock, flags);
+		return;
+	}
+
+	req->state = MEDIA_REQUEST_STATE_COMPLETE;
+
+	spin_unlock_irqrestore(&mdev->req_lock, flags);
+
+	wake_up_all(&req->poll_wait);
+
+	media_request_put(req);
+}
+EXPORT_SYMBOL_GPL(media_request_complete);
+
+static void media_request_object_release(struct kref *kref)
+{
+	struct media_request_object *obj =
+		container_of(kref, struct media_request_object, kref);
+	struct media_device *mdev = obj->class->mdev;
+	unsigned long flags;
+
+	spin_lock_irqsave(&mdev->req_lock, flags);
+	list_del(&obj->object_list);
+	spin_unlock_irqrestore(&mdev->req_lock, flags);
+
+	obj->class->release(obj);
+}
+
+void media_request_object_put(struct media_request_object *obj)
+{
+	if (obj)
+		kref_put(&obj->kref, media_request_object_release);
+}
+EXPORT_SYMBOL_GPL(media_request_object_put);
+
+static struct media_request_object *
+media_request_object_get(struct media_request_object *obj)
+{
+	kref_get(&obj->kref);
+
+	return obj;
+}
+
+void
+media_request_class_register(struct media_device *mdev,
+			     struct media_request_class *class,
+			     void (*unbind)(struct media_request_ref *ref),
+			     void (*release)(struct media_request_object *object),
+			     bool completeable)
+{
+	unsigned long flags;
+
+	INIT_LIST_HEAD(&class->objects);
+	class->unbind = unbind;
+	class->release = release;
+	class->completeable = completeable;
+	class->mdev = mdev;
+
+	spin_lock_irqsave(&mdev->req_lock, flags);
+	list_add(&class->mdev_list, &mdev->classes);
+	spin_unlock_irqrestore(&mdev->req_lock, flags);
+}
+EXPORT_SYMBOL_GPL(media_request_class_register);
+
+void media_request_class_unregister(struct media_request_class *class)
+{
+	unsigned long flags;
+
+	if (!class || !class->mdev)
+		return;
+
+	spin_lock_irqsave(&class->mdev->req_lock, flags);
+	list_del(&class->mdev_list);
+	spin_unlock_irqrestore(&class->mdev->req_lock, flags);
+	media_request_object_put(class->sticky);
+
+	class->mdev = NULL;
+}
+EXPORT_SYMBOL_GPL(media_request_class_unregister);
+
+void media_request_class_set_sticky(struct media_request_class *class,
+				    struct media_request_object *sticky)
+{
+	if (WARN_ON(class->sticky))
+		return;
+
+	class->sticky = media_request_object_get(sticky);
+}
+
+void media_request_object_init(struct media_request_class *class,
+			       struct media_request_object *obj)
+{
+	unsigned long flags;
+
+	spin_lock_irqsave(&class->mdev->req_lock, flags);
+	list_add(&obj->object_list, &class->objects);
+	spin_unlock_irqrestore(&class->mdev->req_lock, flags);
+	obj->class = class;
+	kref_init(&obj->kref);
+}
+EXPORT_SYMBOL_GPL(media_request_object_init);
+
+void media_request_ref_put(struct media_request_ref *ref)
+{
+	if (!ref)
+		return;
+
+	media_request_object_put(ref->new);
+	media_request_object_put(ref->old);
+}
+EXPORT_SYMBOL_GPL(media_request_ref_put);
+
+static struct media_request_ref *
+media_request_ref_find(struct media_request *req,
+		       struct media_request_class *class)
+{
+	struct media_request_ref *ref;
+
+	lockdep_assert_held(&class->mdev->req_lock);
+
+	list_for_each_entry(ref, &req->obj_refs, req_list)
+		if (ref->new->class == class)
+			return ref;
+
+	return NULL;
+}
+
+static int __media_request_object_bind(struct media_request *req,
+				       struct media_request_ref *ref,
+				       struct media_request_object *obj)
+{
+	if (req->state != MEDIA_REQUEST_STATE_IDLE) {
+		dev_dbg(req->mdev->dev, "request: %s not idle but %s\n",
+			req->debug_str,
+			media_request_state_str(req->state));
+		return -EBUSY;
+	}
+
+	media_request_object_put(ref->new);
+	ref->new = media_request_object_get(obj);
+
+	return 0;
+}
+
+struct media_request_ref *
+media_request_object_bind(struct media_request *req,
+			  struct media_request_object *obj)
+{
+	struct media_request_class *class = obj->class;
+	struct media_device *mdev = class->mdev;
+	struct media_request_ref *ref, *ref_new;
+	unsigned long flags;
+	int ret;
+
+	ref_new = kzalloc(sizeof(*ref_new), GFP_KERNEL);
+
+	spin_lock_irqsave(&mdev->req_lock, flags);
+
+	ref = media_request_ref_find(req, obj->class);
+	if (!ref) {
+		if (!ref_new) {
+			ret = -ENOMEM;
+			goto err;
+		}
+
+		ref = ref_new;
+	}
+
+	ret = __media_request_object_bind(req, ref, obj);
+	if (ret)
+		goto err;
+
+	/* Newly created reference? */
+	if (ref == ref_new) {
+		list_add(&ref->req_list, &req->obj_refs);
+		if (class->completeable)
+			req->incomplete++;
+		ref->req = req;
+	}
+
+	spin_unlock_irqrestore(&req->mdev->req_lock, flags);
+
+	/* Release unused reference */
+	if (ref != ref_new)
+		kfree(ref_new);
+
+	return ref;
+
+err:
+	spin_unlock_irqrestore(&req->mdev->req_lock, flags);
+
+	kfree(ref_new);
+
+	return ERR_PTR(ret);
+}
+EXPORT_SYMBOL_GPL(media_request_object_bind);
+
+void media_request_ref_unbind(struct media_request_ref *ref)
+{
+	struct media_request_object *obj = ref->new;
+	struct media_device *mdev = obj->class->mdev;
+	unsigned long flags;
+
+	if (!obj->class->completeable)
+		return;
+
+	spin_lock_irqsave(&mdev->req_lock, flags);
+	if (!ref->complete) {
+		ref->req->incomplete--;
+		WARN_ON(ref->req->incomplete < 0);
+	}
+	list_del(&ref->req_list);
+	spin_unlock_irqrestore(&mdev->req_lock, flags);
+	if (ref->new->class->unbind)
+		ref->new->class->unbind(ref);
+	media_request_ref_put(ref);
+}
+EXPORT_SYMBOL_GPL(media_request_ref_unbind);
+
+/* Tip of the queue state is the state previous to the request. */
+void media_request_sticky_to_old(struct media_request *req)
+{
+	struct media_request_ref *ref;
+
+	lockdep_assert_held(&req->mdev->req_lock);
+
+	list_for_each_entry(ref, &req->obj_refs, req_list) {
+		struct media_request_class *class = ref->new->class;
+
+		if (!class->sticky)
+			continue;
+
+		ref->old = media_request_object_get(class->sticky);
+	}
+}
+EXPORT_SYMBOL_GPL(media_request_sticky_to_old);
+
+void media_request_new_to_sticky(struct media_request *req)
+{
+	struct media_request_ref *ref;
+
+	lockdep_assert_held(&req->mdev->req_lock);
+
+	list_for_each_entry(ref, &req->obj_refs, req_list) {
+		struct media_request_class *class = ref->new->class;
+
+		if (!class->sticky)
+			continue;
+
+		media_request_object_put(class->sticky);
+		class->sticky = media_request_object_get(ref->new);
+	}
+}
+EXPORT_SYMBOL_GPL(media_request_new_to_sticky);
+
+void media_request_detach_old(struct media_request *req)
+{
+	struct media_request_ref *ref;
+
+	lockdep_assert_held(&req->mdev->req_lock);
+
+	list_for_each_entry(ref, &req->obj_refs, req_list) {
+		media_request_object_put(ref->old);
+		ref->old = NULL;
+	}
+}
+EXPORT_SYMBOL_GPL(media_request_detach_old);
+
+bool media_request_is_complete(struct media_request *req)
+{
+	lockdep_assert_held(&req->mdev->req_lock);
+
+	return !req->incomplete;
+}
+EXPORT_SYMBOL_GPL(media_request_is_complete);
+
+void media_request_ref_complete(struct media_request_ref *ref)
+{
+	struct media_request_object *obj = ref->new;
+	struct media_device *mdev = obj->class->mdev;
+	unsigned long flags;
+
+	if (WARN_ON(!obj->class->completeable))
+		return;
+
+	spin_lock_irqsave(&mdev->req_lock, flags);
+	if (!ref->complete) {
+		ref->complete = true;
+		ref->req->incomplete--;
+		WARN_ON(ref->req->incomplete < 0);
+	}
+	spin_unlock_irqrestore(&mdev->req_lock, flags);
+	media_request_ref_put(ref);
+}
+EXPORT_SYMBOL_GPL(media_request_ref_complete);
diff --git a/include/media/media-device.h b/include/media/media-device.h
index bcc6ec4..704b4b5 100644
--- a/include/media/media-device.h
+++ b/include/media/media-device.h
@@ -19,14 +19,17 @@
 #ifndef _MEDIA_DEVICE_H
 #define _MEDIA_DEVICE_H
 
+#include <linux/anon_inodes.h>
+#include <linux/kref.h>
 #include <linux/list.h>
 #include <linux/mutex.h>
 
 #include <media/media-devnode.h>
 #include <media/media-entity.h>
 
-struct ida;
 struct device;
+struct ida;
+struct media_device;
 
 /**
  * struct media_entity_notify - Media Entity Notify
@@ -50,10 +53,16 @@ struct media_entity_notify {
  * struct media_device_ops - Media device operations
  * @link_notify: Link state change notification callback. This callback is
  *		 called with the graph_mutex held.
+ * @req_alloc: Allocate a request
+ * @req_free: Free a request
+ * @req_queue: Queue a request
  */
 struct media_device_ops {
 	int (*link_notify)(struct media_link *link, u32 flags,
 			   unsigned int notification);
+	struct media_request *(*req_alloc)(struct media_device *mdev);
+	void (*req_free)(struct media_request *req);
+	int (*req_queue)(struct media_request *req);
 };
 
 /**
@@ -88,6 +97,10 @@ struct media_device_ops {
  * @disable_source: Disable Source Handler function pointer
  *
  * @ops:	Operation handler callbacks
+ * @req_lock:	Serialise access to @requests
+ * @req_queue_mutex: Serialise validating and queueing requests
+ * @classes:	List of request classes, i.e. which objects may be contained in
+ *		media requests (@struct media_request_class.mdev_list)
  *
  * This structure represents an abstract high-level media device. It allows easy
  * access to entities and provides basic media device-level support. The
@@ -158,6 +171,10 @@ struct media_device {
 	void (*disable_source)(struct media_entity *entity);
 
 	const struct media_device_ops *ops;
+
+	spinlock_t req_lock;
+	struct mutex req_queue_mutex;
+	struct list_head classes;
 };
 
 /* We don't need to include pci.h or usb.h here */
diff --git a/include/media/media-request.h b/include/media/media-request.h
new file mode 100644
index 0000000..04db4ef
--- /dev/null
+++ b/include/media/media-request.h
@@ -0,0 +1,301 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Media device request objects
+ *
+ * Copyright (C) 2018 Intel Corporation
+ *
+ * Author: Sakari Ailus <sakari.ailus@linux.intel.com>
+ */
+
+#ifndef MEDIA_REQUEST_H
+#define MEDIA_REQUEST_H
+
+#include <linux/list.h>
+#include <linux/slab.h>
+#include <linux/spinlock.h>
+
+#include <media/media-device.h>
+
+enum media_request_state {
+	MEDIA_REQUEST_STATE_IDLE,
+	MEDIA_REQUEST_STATE_QUEUEING,
+	MEDIA_REQUEST_STATE_QUEUED,
+	MEDIA_REQUEST_STATE_COMPLETE,
+	MEDIA_REQUEST_STATE_REINIT,
+};
+
+/**
+ * media_request_state_str - Convert media request state to a string
+ *
+ * @state: The state of the media request
+ *
+ * Returns the string corresponding to a media request state.
+ */
+const char *
+media_request_state_str(enum media_request_state state);
+
+/**
+ * struct media_request - Media device request
+ * @mdev: Media device this request belongs to
+ * @kref: Reference count
+ * @req_list: List entry in the media device requests list
+ * @debug_prefix: Prefix for debug messages (process name:fd)
+ * @state: The state of the request
+ * @obj_refs: List of @struct media_request_object_ref req_list field
+ * @incomplete: The number of unsticky objects that have not been completed
+ * @poll_wait: Wait queue for poll
+ */
+struct media_request {
+	struct media_device *mdev;
+	struct kref kref;
+	struct list_head mdev_list;
+#ifdef CONFIG_DYNAMIC_DEBUG
+	char debug_str[TASK_COMM_LEN + 11];
+#endif
+	enum media_request_state state;
+	struct list_head obj_refs;
+	unsigned int incomplete;
+	struct wait_queue_head poll_wait;
+};
+
+struct media_request_object;
+struct media_request_ref;
+
+/**
+ * struct media_request_class - Class of object that may be part of a media
+ *				request
+ *
+ * @objects: List of objects belonging to a class (@struct media_request_object
+ *	     object_list field)
+ * @sticky: Configuration as of the latest request queued; also indicates that a
+ *	    class is sticky
+ * @mdev_list: List entry of the media device's class list
+ * @mdev: The media device
+ * @release: A callback function to release a previously initialised
+ *	     @struct media_request_object
+ */
+struct media_request_class {
+	bool completeable;
+	struct list_head objects;
+	struct media_request_object *sticky;
+	struct list_head mdev_list;
+	struct media_device *mdev;
+	void (*unbind)(struct media_request_ref *ref);
+	void (*release)(struct media_request_object *object);
+};
+
+/**
+ * struct media_request_object - An opaque object that belongs to a media
+ *				 request
+ *
+ * @class: The class which the object is related to
+ * @object_list: List entry of the object list of the class
+ * @kref: Reference to the object, acquire before releasing mdev->req_lock
+ *
+ * An object related to the request. The object data follows this struct.
+ */
+struct media_request_object {
+	struct media_request_class *class;
+	struct list_head object_list;
+	struct kref kref;
+};
+
+/**
+ * struct media_request_ref - Reference to a media request object
+ *
+ * @new: The new object
+ * @old: The old object
+ * @req_list: List entry of in the request's object list
+ * @req: The request the reference is related to
+ * @complete: A reference has been marked complete
+ *
+ * Represents a reference to a media request object; object references are bound
+ * to requests.
+ */
+struct media_request_ref {
+	struct media_request_object *new;
+	struct media_request_object *old;
+	struct list_head req_list;
+	struct media_request *req;
+	bool complete;
+};
+
+#define media_request_for_each_ref(ref, req)	     \
+	lockdep_assert_held(&(req)->mdev->req_lock); \
+	list_for_each_entry(ref, &req->obj_refs, req_list)
+
+
+void media_request_release(struct kref *kref);
+
+static inline void media_request_put(struct media_request *req)
+{
+	kref_put(&req->kref, media_request_release);
+}
+
+static inline void media_request_get(struct media_request *req)
+{
+	kref_get(&req->kref);
+}
+
+struct media_request *
+media_request_find(struct media_device *mdev, int request);
+
+int media_request_alloc(struct media_device *mdev,
+			struct media_request_new *new);
+
+void media_request_complete(struct media_device *mdev,
+			    struct media_request *req);
+
+/**
+ * media_request_class_register - Register a media device request class
+ *
+ * @mdev: The media device
+ * @class: The class to be registered
+ * @unbind: The unbind callback; called when a reference to a resource is
+ *	    unbound from an idle request
+ * @release: Release callback for a request object
+ * @completeable: Whether objects in this class must complete for the request to
+ *		  be completed
+ *
+ * Registers a media device class for request objects. Objects are allocated by
+ * the framework. Sticky objects are kept after the request has been completed;
+ * they are configuration rather than a resource (such as buffers).
+ */
+void
+media_request_class_register(struct media_device *mdev,
+			     struct media_request_class *class,
+			     void (*unbind)(struct media_request_ref *ref),
+			     void (*release)(struct media_request_object *object),
+			     bool completeable);
+
+/**
+ * media_request_class_set_sticky - Make a class sticky
+ *
+ * @class: The request object class
+ * @sticky: The sticky object
+ *
+ * Makes a class sticky as well as sets the sticky object to a class. Sticky
+ * objects represent configuration which may be changed by a request but will
+ * prevail until changed again.
+ */
+void media_request_class_set_sticky(struct media_request_class *class,
+				    struct media_request_object *sticky);
+
+/**
+ * media_request_class_unregister - Unregister a media device request class
+ *
+ * @class: The class to unregister
+ */
+void media_request_class_unregister(struct media_request_class *class);
+
+/**
+ * media_request_object_put - Put a media request object
+ *
+ * @obj: The object
+ *
+ * Put a reference to a media request object. Once all references are gone, the
+ * object's memory is released.
+ */
+void media_request_object_put(struct media_request_object *obj);
+
+/**
+ * media_request_object_init - Initialise an allocated media request object
+ *
+ * @class: The class the object belongs to
+ *
+ * Initialise a media request object. The object will be released using the
+ * release function of the class once it has no references (this function
+ * initialises references to one).
+ */
+void media_request_object_init(struct media_request_class *class,
+			       struct media_request_object *obj);
+
+/**
+ * __media_request_ref_put - Put a reference to a request object
+ *
+ * @ref: The reference
+ *
+ * Put a reference to a media request object. The caller must be holding @struct
+ * media_device.req_lock.
+ */
+void __media_request_ref_put(struct media_request_ref *ref);
+
+/**
+ * media_request_ref_put - Put a reference to a request object
+ *
+ * @ref: The reference
+ *
+ * Put a reference to a media request object.
+ */
+void media_request_ref_put(struct media_request_ref *ref);
+
+/**
+ * media_request_object_bind - Bind an object to a request
+ *
+ * @req: The request where the object is to be added
+ * @obj: The object
+ *
+ * Bind an object to a request.
+ *
+ * Returns a reference to the bound object.
+ */
+struct media_request_ref *
+media_request_object_bind(struct media_request *req,
+			  struct media_request_object *obj);
+
+/**
+ * media_request_sticky_to_old - Move sticky configuration to request
+ *
+ * @req: The request
+ *
+ * Move the current configuration to the request's old configuration.
+ */
+void media_request_sticky_to_old(struct media_request *req);
+
+/**
+ * media_request_new_to_sticky - Make the request configuration stick
+ *
+ * @req: The request
+ *
+ * Make the configuration in the request the current configuration.
+ */
+void media_request_new_to_sticky(struct media_request *req);
+
+/**
+ * media_request_detach_old - Detach old configuration
+ *
+ * @req: The request
+ *
+ * Detach the previous (old) configuration from the request.
+ */
+void media_request_detach_old(struct media_request *req);
+
+/*
+ * media_device_ref_unbind - Unbind an object reference from a request
+ *
+ * @ref: The reference to be unbound.
+ *
+ * Unbind a previously bound reference from a request. The object is put by this
+ * function as well. Only references to completeable objects may be unbound.
+ */
+void media_request_ref_unbind(struct media_request_ref *ref);
+
+/*
+ * media_request_is_complete - Tell whether the media request is complete
+ *
+ * @req: The request
+ *
+ * Return true if all unsticky objects have been completed in a request.
+ */
+bool media_request_is_complete(struct media_request *req);
+
+/**
+ * media_request_ref_complete - Mark a reference complete
+ *
+ * @ref: The reference to the request
+ *
+ * Mark a part of the request as completed. Also puts the ref.
+ */
+void media_request_ref_complete(struct media_request_ref *ref);
+
+#endif
diff --git a/include/uapi/linux/media.h b/include/uapi/linux/media.h
index c7e9a5c..a38e8fc 100644
--- a/include/uapi/linux/media.h
+++ b/include/uapi/linux/media.h
@@ -342,11 +342,19 @@ struct media_v2_topology {
 
 /* ioctls */
 
+struct __attribute__ ((packed)) media_request_new {
+	__s32 fd;
+};
+
 #define MEDIA_IOC_DEVICE_INFO	_IOWR('|', 0x00, struct media_device_info)
 #define MEDIA_IOC_ENUM_ENTITIES	_IOWR('|', 0x01, struct media_entity_desc)
 #define MEDIA_IOC_ENUM_LINKS	_IOWR('|', 0x02, struct media_links_enum)
 #define MEDIA_IOC_SETUP_LINK	_IOWR('|', 0x03, struct media_link_desc)
 #define MEDIA_IOC_G_TOPOLOGY	_IOWR('|', 0x04, struct media_v2_topology)
+#define MEDIA_IOC_REQUEST_ALLOC	_IOWR('|', 0x05, struct media_request_new)
+
+#define MEDIA_REQUEST_IOC_QUEUE		_IO('|',  0x80)
+#define MEDIA_REQUEST_IOC_REINIT	_IO('|',  0x81)
 
 #if !defined(__KERNEL__) || defined(__NEED_MEDIA_LEGACY_API)
 
-- 
2.7.4
