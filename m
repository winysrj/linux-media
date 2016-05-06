Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:14228 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758059AbcEFK4k (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 6 May 2016 06:56:40 -0400
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: linux-media@vger.kernel.org
Cc: laurent.pinchart@ideasonboard.com, hverkuil@xs4all.nl,
	mchehab@osg.samsung.com,
	Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
Subject: [RFC 01/22] media: Add request API
Date: Fri,  6 May 2016 13:53:10 +0300
Message-Id: <1462532011-15527-2-git-send-email-sakari.ailus@linux.intel.com>
In-Reply-To: <1462532011-15527-1-git-send-email-sakari.ailus@linux.intel.com>
References: <1462532011-15527-1-git-send-email-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>

The request API allows bundling media device parameters with request
objects and applying them atomically, either synchronously or
asynchronously.

Signed-off-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>

---

Changes since v0:

- Make the request ID 32 bits wide internally

---

- Strip off the reserved fields

- Use __attribute__ ((packed)) for the IOCTL argument struct.

- Manage request ID space using ida_simple

- Fix compat handling for requests

Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
---
 drivers/media/media-device.c | 194 ++++++++++++++++++++++++++++++++++++++++++-
 include/media/media-device.h |  41 +++++++++
 include/uapi/linux/media.h   |  11 +++
 3 files changed, 243 insertions(+), 3 deletions(-)

diff --git a/drivers/media/media-device.c b/drivers/media/media-device.c
index 3b9a1bf..4fc1eb1 100644
--- a/drivers/media/media-device.c
+++ b/drivers/media/media-device.c
@@ -41,6 +41,7 @@
 
 struct media_device_fh {
 	struct media_devnode_fh fh;
+	struct list_head requests;
 };
 
 static inline struct media_device_fh *media_device_fh(struct file *filp)
@@ -49,6 +50,170 @@ static inline struct media_device_fh *media_device_fh(struct file *filp)
 }
 
 /* -----------------------------------------------------------------------------
+ * Requests
+ */
+
+/**
+ * media_device_request_find - Find a request based from its ID
+ * @mdev: The media device
+ * @reqid: The request ID
+ *
+ * Find and return the request associated with the given ID, or NULL if no such
+ * request exists.
+ *
+ * When the function returns a non-NULL request it increases its reference
+ * count. The caller is responsible for releasing the reference by calling
+ * media_device_request_put() on the request.
+ */
+struct media_device_request *
+media_device_request_find(struct media_device *mdev, u16 reqid)
+{
+	struct media_device_request *req;
+	unsigned long flags;
+	bool found = false;
+
+	spin_lock_irqsave(&mdev->req_lock, flags);
+	list_for_each_entry(req, &mdev->requests, list) {
+		if (req->id == reqid) {
+			kref_get(&req->kref);
+			found = true;
+			break;
+		}
+	}
+	spin_unlock_irqrestore(&mdev->req_lock, flags);
+
+	return found ? req : NULL;
+}
+EXPORT_SYMBOL_GPL(media_device_request_find);
+
+void media_device_request_get(struct media_device_request *req)
+{
+	kref_get(&req->kref);
+}
+EXPORT_SYMBOL_GPL(media_device_request_get);
+
+static void media_device_request_release(struct kref *kref)
+{
+	struct media_device_request *req =
+		container_of(kref, struct media_device_request, kref);
+	struct media_device *mdev = req->mdev;
+
+	ida_simple_remove(&mdev->req_ids, req->id);
+
+	mdev->ops->req_free(mdev, req);
+}
+
+void media_device_request_put(struct media_device_request *req)
+{
+	kref_put(&req->kref, media_device_request_release);
+}
+EXPORT_SYMBOL_GPL(media_device_request_put);
+
+static int media_device_request_alloc(struct media_device *mdev,
+				      struct media_device_fh *fh,
+				      struct media_request_cmd *cmd)
+{
+	struct media_device_request *req;
+	unsigned long flags;
+	int id = ida_simple_get(&mdev->req_ids, 1, 0, GFP_KERNEL);
+	int ret;
+
+	if (id < 0)
+		return id;
+
+	req = mdev->ops->req_alloc(mdev);
+	if (!req) {
+		ret = -ENOMEM;
+		goto out_ida_simple_remove;
+	}
+
+	req->mdev = mdev;
+	req->id = id;
+	kref_init(&req->kref);
+
+	spin_lock_irqsave(&mdev->req_lock, flags);
+	list_add_tail(&req->list, &mdev->requests);
+	list_add_tail(&req->fh_list, &fh->requests);
+	spin_unlock_irqrestore(&mdev->req_lock, flags);
+
+	cmd->request = req->id;
+
+	return 0;
+
+out_ida_simple_remove:
+	ida_simple_remove(&mdev->req_ids, id);
+
+	return ret;
+}
+
+static void media_device_request_delete(struct media_device *mdev,
+					struct media_device_request *req)
+{
+	unsigned long flags;
+
+	spin_lock_irqsave(&mdev->req_lock, flags);
+	list_del(&req->list);
+	spin_unlock_irqrestore(&mdev->req_lock, flags);
+
+	media_device_request_put(req);
+}
+
+static long media_device_request_cmd(struct media_device *mdev,
+				     struct file *filp,
+				     struct media_request_cmd *cmd)
+{
+	struct media_device_fh *fh = media_device_fh(filp);
+	struct media_device_request *req = NULL;
+	int ret;
+
+	if (!mdev->ops || !mdev->ops->req_alloc || !mdev->ops->req_free)
+		return -ENOTTY;
+
+	if (cmd->cmd != MEDIA_REQ_CMD_ALLOC) {
+		req = media_device_request_find(mdev, cmd->request);
+		if (!req)
+			return -EINVAL;
+	}
+
+	switch (cmd->cmd) {
+	case MEDIA_REQ_CMD_ALLOC:
+		ret = media_device_request_alloc(mdev, fh, cmd);
+		break;
+
+	case MEDIA_REQ_CMD_DELETE:
+		media_device_request_delete(mdev, req);
+		ret = 0;
+		break;
+
+	case MEDIA_REQ_CMD_APPLY:
+		if (!mdev->ops->req_apply)
+			return -ENOSYS;
+
+		ret = mdev->ops->req_apply(mdev, req);
+		break;
+
+	case MEDIA_REQ_CMD_QUEUE:
+		if (!mdev->ops->req_queue)
+			return -ENOSYS;
+
+		ret = mdev->ops->req_queue(mdev, req);
+		break;
+
+	default:
+		ret = -EINVAL;
+		break;
+	}
+
+	if (req)
+		media_device_request_put(req);
+
+	if (ret < 0)
+		return ret;
+
+	return 0;
+}
+
+/* -----------------------------------------------------------------------------
  * Userspace API
  */
 
@@ -65,6 +230,7 @@ static int media_device_open(struct file *filp)
 	if (!fh)
 		return -ENOMEM;
 
+	INIT_LIST_HEAD(&fh->requests);
 	filp->private_data = &fh->fh;
 
 	return 0;
@@ -73,6 +239,15 @@ static int media_device_open(struct file *filp)
 static int media_device_close(struct file *filp)
 {
 	struct media_device_fh *fh = media_device_fh(filp);
+	struct media_device *mdev = to_media_device(fh->fh.devnode);
+	struct media_device_request *req, *next;
+
+	spin_lock_irq(&mdev->req_lock);
+	list_for_each_entry_safe(req, next, &fh->requests, fh_list) {
+		list_del(&req->fh_list);
+		media_device_request_put(req);
+	}
+	spin_unlock_irq(&mdev->req_lock);
 
 	kfree(fh);
 
@@ -80,6 +255,7 @@ static int media_device_close(struct file *filp)
 }
 
 static int media_device_get_info(struct media_device *dev,
+				 struct file *filp,
 				 struct media_device_info *info)
 {
 	memset(info, 0, sizeof(*info));
@@ -119,6 +295,7 @@ static struct media_entity *find_entity(struct media_device *mdev, u32 id)
 }
 
 static long media_device_enum_entities(struct media_device *mdev,
+				       struct file *filp,
 				       struct media_entity_desc *entd)
 {
 	struct media_entity *ent;
@@ -172,6 +349,7 @@ static void media_device_kpad_to_upad(const struct media_pad *kpad,
 }
 
 static long media_device_enum_links(struct media_device *mdev,
+				    struct file *filp,
 				    struct media_links_enum *links)
 {
 	struct media_entity *entity;
@@ -220,6 +398,7 @@ static long media_device_enum_links(struct media_device *mdev,
 }
 
 static long media_device_setup_link(struct media_device *mdev,
+				    struct file *filp,
 				    struct media_link_desc *linkd)
 {
 	struct media_link *link = NULL;
@@ -248,6 +427,7 @@ static long media_device_setup_link(struct media_device *mdev,
 }
 
 static long media_device_get_topology(struct media_device *mdev,
+				      struct file *filp,
 				      struct media_v2_topology *topo)
 {
 	struct media_entity *entity;
@@ -417,7 +597,8 @@ static long copy_arg_to_user_nop(void __user *uarg, void *karg,
 #define MEDIA_IOC_SZ_ARG(__cmd, func, fl, alt_sz, from_user, to_user)	\
 	[_IOC_NR(MEDIA_IOC_##__cmd)] = {				\
 		.cmd = MEDIA_IOC_##__cmd,				\
-		.fn = (long (*)(struct media_device *, void *))func,	\
+		.fn = (long (*)(struct media_device *,			\
+				struct file *, void *))func,		\
 		.flags = fl,						\
 		.alt_arg_sizes = alt_sz,				\
 		.arg_from_user = from_user,				\
@@ -438,7 +619,7 @@ static long copy_arg_to_user_nop(void __user *uarg, void *karg,
 /* the table is indexed by _IOC_NR(cmd) */
 struct media_ioctl_info {
 	unsigned int cmd;
-	long (*fn)(struct media_device *dev, void *arg);
+	long (*fn)(struct media_device *dev, struct file *file, void *arg);
 	unsigned short flags;
 	const unsigned short *alt_arg_sizes;
 	long (*arg_from_user)(void *karg, void __user *uarg, unsigned int cmd);
@@ -511,7 +692,7 @@ static long __media_device_ioctl(
 	if (info->flags & MEDIA_IOC_FL_GRAPH_MUTEX)
 		mutex_lock(&dev->graph_mutex);
 
-	ret = info->fn(dev, karg);
+	ret = info->fn(dev, filp, karg);
 
 	if (info->flags & MEDIA_IOC_FL_GRAPH_MUTEX)
 		mutex_unlock(&dev->graph_mutex);
@@ -531,6 +712,7 @@ static const struct media_ioctl_info ioctl_info[] = {
 	MEDIA_IOC(ENUM_LINKS, media_device_enum_links, MEDIA_IOC_FL_GRAPH_MUTEX),
 	MEDIA_IOC(SETUP_LINK, media_device_setup_link, MEDIA_IOC_FL_GRAPH_MUTEX),
 	MEDIA_IOC(G_TOPOLOGY, media_device_get_topology, MEDIA_IOC_FL_GRAPH_MUTEX),
+	MEDIA_IOC(REQUEST_CMD, media_device_request_cmd, 0),
 };
 
 static long media_device_ioctl(struct file *filp, unsigned int cmd,
@@ -578,6 +760,7 @@ static const struct media_ioctl_info compat_ioctl_info[] = {
 	MEDIA_IOC_ARG(ENUM_LINKS32, media_device_enum_links, MEDIA_IOC_FL_GRAPH_MUTEX, from_user_enum_links32, copy_arg_to_user_nop),
 	MEDIA_IOC(SETUP_LINK, media_device_setup_link, MEDIA_IOC_FL_GRAPH_MUTEX),
 	MEDIA_IOC(G_TOPOLOGY, media_device_get_topology, MEDIA_IOC_FL_GRAPH_MUTEX),
+	MEDIA_IOC(REQUEST_CMD, media_device_request_cmd, 0),
 };
 
 static long media_device_compat_ioctl(struct file *filp, unsigned int cmd,
@@ -762,6 +945,7 @@ void media_device_init(struct media_device *mdev)
 	INIT_LIST_HEAD(&mdev->entity_notify);
 	mutex_init(&mdev->graph_mutex);
 	ida_init(&mdev->entity_internal_idx);
+	ida_init(&mdev->req_ids);
 
 	dev_dbg(mdev->dev, "Media device initialized\n");
 }
@@ -769,6 +953,7 @@ EXPORT_SYMBOL_GPL(media_device_init);
 
 void media_device_cleanup(struct media_device *mdev)
 {
+	ida_destroy(&mdev->req_ids);
 	ida_destroy(&mdev->entity_internal_idx);
 	mdev->entity_internal_idx_max = 0;
 	media_entity_graph_walk_cleanup(&mdev->pm_count_walk);
@@ -781,6 +966,9 @@ int __must_check __media_device_register(struct media_device *mdev,
 {
 	int ret;
 
+	spin_lock_init(&mdev->req_lock);
+	INIT_LIST_HEAD(&mdev->requests);
+
 	/* Register the device node. */
 	mdev->devnode.fops = &media_device_fops;
 	mdev->devnode.parent = mdev->dev;
diff --git a/include/media/media-device.h b/include/media/media-device.h
index 19c8ed4..49c3367a 100644
--- a/include/media/media-device.h
+++ b/include/media/media-device.h
@@ -23,6 +23,7 @@
 #ifndef _MEDIA_DEVICE_H
 #define _MEDIA_DEVICE_H
 
+#include <linux/kref.h>
 #include <linux/list.h>
 #include <linux/mutex.h>
 
@@ -262,6 +263,23 @@
 
 struct ida;
 struct device;
+struct media_device;
+
+/**
+ * struct media_device_request - Media device request
+ * @id: Request ID
+ * @mdev: Media device this request belongs to
+ * @kref: Reference count
+ * @list: List entry in the media device requests list
+ * @fh_list: List entry in the media file handle requests list
+ */
+struct media_device_request {
+	u32 id;
+	struct media_device *mdev;
+	struct kref kref;
+	struct list_head list;
+	struct list_head fh_list;
+};
 
 /**
  * struct media_entity_notify - Media Entity Notify
@@ -283,10 +301,21 @@ struct media_entity_notify {
  * struct media_device_ops - Media device operations
  * @link_notify: Link state change notification callback. This callback is
  *		 called with the graph_mutex held.
+ * @req_alloc: Allocate a request
+ * @req_free: Free a request
+ * @req_apply: Apply a request
+ * @req_queue: Queue a request
  */
 struct media_device_ops {
 	int (*link_notify)(struct media_link *link, u32 flags,
 			   unsigned int notification);
+	struct media_device_request *(*req_alloc)(struct media_device *mdev);
+	void (*req_free)(struct media_device *mdev,
+			 struct media_device_request *req);
+	int (*req_apply)(struct media_device *mdev,
+			 struct media_device_request *req);
+	int (*req_queue)(struct media_device *mdev,
+			 struct media_device_request *req);
 };
 
 /**
@@ -322,6 +351,9 @@ struct media_device_ops {
  * @disable_source: Disable Source Handler function pointer
  *
  * @ops:	Operation handler callbacks
+ * @req_ids:	Allocated request IDs
+ * @req_lock:	Serialise access to requests list
+ * @requests:	List of allocated requests
  *
  * This structure represents an abstract high-level media device. It allows easy
  * access to entities and provides basic media device-level support. The
@@ -389,6 +421,10 @@ struct media_device {
 	void (*disable_source)(struct media_entity *entity);
 
 	const struct media_device_ops *ops;
+
+	struct ida req_ids;
+	spinlock_t req_lock;
+	struct list_head requests;
 };
 
 /* We don't need to include pci.h or usb.h here */
@@ -715,4 +751,9 @@ static inline void __media_device_usb_init(struct media_device *mdev,
 #define media_device_usb_init(mdev, udev, name) \
 	__media_device_usb_init(mdev, udev, name, KBUILD_MODNAME)
 
+struct media_device_request *
+media_device_request_find(struct media_device *mdev, u16 reqid);
+void media_device_request_get(struct media_device_request *req);
+void media_device_request_put(struct media_device_request *req);
+
 #endif
diff --git a/include/uapi/linux/media.h b/include/uapi/linux/media.h
index df59ede..e8922ea 100644
--- a/include/uapi/linux/media.h
+++ b/include/uapi/linux/media.h
@@ -389,10 +389,21 @@ struct media_v2_topology {
 
 /* ioctls */
 
+#define MEDIA_REQ_CMD_ALLOC		0
+#define MEDIA_REQ_CMD_DELETE		1
+#define MEDIA_REQ_CMD_APPLY		2
+#define MEDIA_REQ_CMD_QUEUE		3
+
+struct __attribute__ ((packed)) media_request_cmd {
+	__u32 cmd;
+	__u32 request;
+};
+
 #define MEDIA_IOC_DEVICE_INFO		_IOWR('|', 0x00, struct media_device_info)
 #define MEDIA_IOC_ENUM_ENTITIES		_IOWR('|', 0x01, struct media_entity_desc)
 #define MEDIA_IOC_ENUM_LINKS		_IOWR('|', 0x02, struct media_links_enum)
 #define MEDIA_IOC_SETUP_LINK		_IOWR('|', 0x03, struct media_link_desc)
 #define MEDIA_IOC_G_TOPOLOGY		_IOWR('|', 0x04, struct media_v2_topology)
+#define MEDIA_IOC_REQUEST_CMD		_IOWR('|', 0x05, struct media_request_cmd)
 
 #endif /* __LINUX_MEDIA_H */
-- 
1.9.1

