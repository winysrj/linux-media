Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga12.intel.com ([192.55.52.136]:4424 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751275AbeCIXtY (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 9 Mar 2018 18:49:24 -0500
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: linux-media@vger.kernel.org
Cc: acourbot@chromium.org
Subject: [RFC 4/8] media: Add support for request classes and objects
Date: Sat, 10 Mar 2018 01:48:48 +0200
Message-Id: <1520639332-19190-5-git-send-email-sakari.ailus@linux.intel.com>
In-Reply-To: <1520639332-19190-1-git-send-email-sakari.ailus@linux.intel.com>
References: <1520639332-19190-1-git-send-email-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Media requests may contain multiple objects (e.g. V4L2 format or video
buffers). The media request objects support managing these in a generic
way. The classes are effectively a helper for managing certain kinds of
objects.

Objects may be sticky (the previous configuration matters, e.g. V4L2
format) or non-sticky (whatever was before is irrelevant, e.g. video
buffers).

The drivers are responsible for initialising the classes for types of
objects they support with requests. Some of this could possibly be
implemented in the media and V4L2 frameworks.

Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
---
 drivers/media/Makefile        |   3 +-
 drivers/media/media-device.c  |  27 +++-
 drivers/media/media-request.c | 287 ++++++++++++++++++++++++++++++++++++++++++
 include/media/media-device.h  |  13 +-
 include/media/media-request.h | 229 +++++++++++++++++++++++++++++++++
 5 files changed, 554 insertions(+), 5 deletions(-)
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
index a4d3884..873d83c 100644
--- a/drivers/media/media-device.c
+++ b/drivers/media/media-device.c
@@ -34,6 +34,7 @@
 #include <media/media-device.h>
 #include <media/media-devnode.h>
 #include <media/media-entity.h>
+#include <media/media-request.h>
 
 #ifdef CONFIG_MEDIA_CONTROLLER
 
@@ -66,15 +67,21 @@ static void media_device_request_release(struct kref *kref)
 {
 	struct media_device_request *req =
 		container_of(kref, struct media_device_request, kref);
+	struct media_request_ref *ref, *ref_safe;
 	struct media_device *mdev = req->mdev;
 	unsigned long flags;
 
 	dev_dbg(mdev->dev, "request: release %s\n", req->debug_str);
 
 	spin_lock_irqsave(&mdev->req_lock, flags);
-	list_del(&req->list);
+	list_del(&req->req_list);
 	spin_unlock_irqrestore(&mdev->req_lock, flags);
 
+	list_for_each_entry_safe(ref, ref_safe, &req->obj_refs, req_list) {
+		__media_request_ref_put(ref);
+		kfree(ref);
+	}
+
 	mdev->ops->req_free(mdev, req);
 }
 
@@ -203,6 +210,7 @@ static int media_device_request_alloc(struct media_device *mdev,
 	req->mdev = mdev;
 	req->state = MEDIA_DEVICE_REQUEST_STATE_IDLE;
 	kref_init(&req->kref);
+	INIT_LIST_HEAD(&req->obj_refs);
 
 	spin_lock_irqsave(&mdev->req_lock, flags);
 	list_add_tail(&req->req_list, &mdev->req_idle);
@@ -237,6 +245,13 @@ void media_device_request_complete(struct media_device *mdev,
 
 	spin_lock_irqsave(&mdev->req_lock, flags);
 
+	if (!media_request_is_complete(req)) {
+		spin_unlock_irqrestore(&mdev->req_lock, flags);
+		dev_dbg(mdev->dev, "request: %s is not complete yet\n",
+			req->debug_str);
+		return;
+	}
+
 	if (req->state == MEDIA_DEVICE_REQUEST_STATE_IDLE) {
 		dev_dbg(mdev->dev,
 			"request: not completing an idle request %s\n",
@@ -285,7 +300,9 @@ static int media_device_request_queue(
 			media_device_request_state_str(req->state));
 	} else {
 		req->state = MEDIA_DEVICE_REQUEST_STATE_QUEUED;
+		media_request_sticky_to_old(req);
 	}
+
 	spin_unlock_irqrestore(&mdev->req_lock, flags);
 
 	if (ret)
@@ -306,7 +323,7 @@ static int media_device_request_queue(
 	 */
 	media_device_request_get(req);
 	spin_lock_irqsave(&mdev->req_lock, flags);
-	list_move(&req->list, &mdev->req_queued);
+	list_move(&req->req_list, &mdev->req_queued);
 	spin_unlock_irqrestore(&mdev->req_lock, flags);
 
 	ret = mdev->ops->req_queue(mdev, req);
@@ -316,6 +333,10 @@ static int media_device_request_queue(
 		goto err_put;
 	}
 
+	spin_lock_irqsave(&mdev->req_lock, flags);
+	media_request_new_to_sticky(req);
+	spin_unlock_irqrestore(&mdev->req_lock, flags);
+
 	mutex_unlock(&mdev->req_queue_mutex);
 
 	return 0;
@@ -325,6 +346,7 @@ static int media_device_request_queue(
 
 err_set_idle:
 	spin_lock_irqsave(&mdev->req_lock, flags);
+	media_request_detach_old(req);
 	req->state = MEDIA_DEVICE_REQUEST_STATE_IDLE;
 	spin_unlock_irqrestore(&mdev->req_lock, flags);
 
@@ -1149,6 +1171,7 @@ int __must_check __media_device_register(struct media_device *mdev,
 	spin_lock_init(&mdev->req_lock);
 	INIT_LIST_HEAD(&mdev->req_idle);
 	INIT_LIST_HEAD(&mdev->req_queued);
+	INIT_LIST_HEAD(&mdev->classes);
 
 	/* Register the device node. */
 	mdev->devnode = devnode;
diff --git a/drivers/media/media-request.c b/drivers/media/media-request.c
new file mode 100644
index 0000000..f9f8b41
--- /dev/null
+++ b/drivers/media/media-request.c
@@ -0,0 +1,287 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Media device request objects
+ *
+ * Copyright (C) 2018 Intel Corporation
+ *
+ * Author: Sakari Ailus <sakari.ailus@linux.intel.com>
+ */
+
+#include <linux/mm.h>
+#include <linux/string.h>
+
+#include <media/media-device.h>
+#include <media/media-request.h>
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
+			     void (*release)(struct media_request_object *object),
+			     bool completeable)
+{
+	unsigned long flags;
+
+	INIT_LIST_HEAD(&class->objects);
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
+	spin_lock_irqsave(&class->mdev->req_lock, flags);
+	list_del(&class->mdev_list);
+	spin_unlock_irqrestore(&class->mdev->req_lock, flags);
+	media_request_object_put(class->sticky);
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
+media_request_ref_find(struct media_device_request *req,
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
+static int __media_request_object_bind(struct media_device_request *req,
+				       struct media_request_ref *ref,
+				       struct media_request_object *obj)
+{
+	if (req->state != MEDIA_DEVICE_REQUEST_STATE_IDLE) {
+		dev_dbg(req->mdev->dev, "request: %s not idle but %s\n",
+			req->debug_str,
+			media_device_request_state_str(req->state));
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
+media_request_object_bind(struct media_device_request *req,
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
+	if (WARN_ON(!obj->class->completeable))
+		return;
+
+	spin_lock_irqsave(&mdev->req_lock, flags);
+	if (!ref->complete) {
+		ref->req->incomplete--;
+		WARN_ON(ref->req->incomplete < 0);
+	}
+	list_del(&ref->req_list);
+	spin_unlock_irqrestore(&mdev->req_lock, flags);
+	media_request_ref_put(ref);
+}
+EXPORT_SYMBOL_GPL(media_request_ref_unbind);
+
+/* Tip of the queue state is the state previous to the request. */
+void media_request_sticky_to_old(struct media_device_request *req)
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
+void media_request_new_to_sticky(struct media_device_request *req)
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
+void media_request_detach_old(struct media_device_request *req)
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
+bool media_request_is_complete(struct media_device_request *req)
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
index 0f32ceb..01543f8 100644
--- a/include/media/media-device.h
+++ b/include/media/media-device.h
@@ -51,18 +51,24 @@ media_device_request_state_str(enum media_device_request_state state);
  * struct media_device_request - Media device request
  * @mdev: Media device this request belongs to
  * @kref: Reference count
- * @list: List entry in the media device requests list
+ * @req_list: List entry in the media device requests list
  * @debug_prefix: Prefix for debug messages (process name:fd)
  * @state: The state of the request
+ * @obj_refs: List of @struct media_request_object_ref req_list field
+ * @incomplete: The number of unsticky objects that have not been completed
+ * @poll_wait: Wait queue for poll
  */
 struct media_device_request {
 	struct media_device *mdev;
 	struct kref kref;
-	struct list_head list;
+	struct list_head req_list;
 #ifdef CONFIG_DYNAMIC_DEBUG
 	char debug_str[TASK_COMM_LEN + 6];
 #endif
 	enum media_device_request_state state;
+	struct list_head obj_refs;
+	unsigned int incomplete;
+	struct wait_queue_head poll_wait;
 };
 
 /**
@@ -141,6 +147,8 @@ struct media_device_ops {
  * @req_idle:	List of idle requests (@struct media_request.list)
  * @req_queued:	List of queued (and completed) requests (@struct
  *		media_request.list)
+ * @classes:	List of request classes, i.e. which objects may be contained in
+ *		media requests (@struct media_request_class.mdev_list)
  *
  * This structure represents an abstract high-level media device. It allows easy
  * access to entities and provides basic media device-level support. The
@@ -216,6 +224,7 @@ struct media_device {
 	struct mutex req_queue_mutex;
 	struct list_head req_queued;
 	struct list_head req_idle;
+	struct list_head classes;
 };
 
 /* We don't need to include pci.h or usb.h here */
diff --git a/include/media/media-request.h b/include/media/media-request.h
new file mode 100644
index 0000000..74037c8
--- /dev/null
+++ b/include/media/media-request.h
@@ -0,0 +1,229 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/*
+ * Media device request objects
+ *
+ * Copyright (C) 2018 Intel Corporation
+ *
+ * Author: Sakari Ailus <sakari.ailus@linux.intel.com>
+ */
+
+#include <linux/list.h>
+#include <linux/slab.h>
+#include <linux/spinlock.h>
+
+#include <media/media-device.h>
+
+struct media_request_object;
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
+	struct media_device_request *req;
+	bool complete;
+};
+
+#define media_request_for_each_ref(ref, req)	     \
+	lockdep_assert_held(&(req)->mdev->req_lock); \
+	list_for_each_entry(ref, req, obj_refs)
+
+
+/**
+ * media_request_class_register - Register a media device request class
+ *
+ * @mdev: The media device
+ * @class: The class to be registered
+ * @size: The size (in bytes) of an object in a class
+ * @completeable: Whether objects in this class must complete for the request to
+ *		  be completed
+ * @name: Name of the class for debug prints, may be NULL
+ *
+ * Registers a media device class for request objects. Objects are allocated by
+ * the framework. Sticky objects are kept after the request has been completed;
+ * they are configuration rather than a resource (such as buffers).
+ */
+void
+media_request_class_register(struct media_device *mdev,
+			     struct media_request_class *class,
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
+media_request_object_bind(struct media_device_request *req,
+			  struct media_request_object *obj);
+
+/**
+ * media_request_sticky_to_old - Move sticky configuration to request
+ *
+ * @req: The request
+ *
+ * Move the current configuration to the request's old configuration.
+ */
+void media_request_sticky_to_old(struct media_device_request *req);
+
+/**
+ * media_request_new_to_sticky - Make the request configuration stick
+ *
+ * @req: The request
+ *
+ * Make the configuration in the request the current configuration.
+ */
+void media_request_new_to_sticky(struct media_device_request *req);
+
+/**
+ * media_request_detach_old - Detach old configuration
+ *
+ * @req: The request
+ *
+ * Detach the previous (old) configuration from the request.
+ */
+void media_request_detach_old(struct media_device_request *req);
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
+bool media_request_is_complete(struct media_device_request *req);
+
+/**
+ * media_request_ref_complete - Mark a reference complete
+ *
+ * @ref: The reference to the request
+ *
+ * Mark a part of the request as completed. Also puts the ref.
+ */
+void media_request_ref_complete(struct media_request_ref *ref);
-- 
2.7.4
