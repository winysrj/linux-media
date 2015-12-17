Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:44652 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755429AbbLQIlC (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 17 Dec 2015 03:41:02 -0500
From: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: linux-sh@vger.kernel.org
Subject: [PATCH/RFC 23/48] media: Add request API
Date: Thu, 17 Dec 2015 10:40:01 +0200
Message-Id: <1450341626-6695-24-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
In-Reply-To: <1450341626-6695-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
References: <1450341626-6695-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The request API allows bundling media device parameters with request
objects and applying them atomically, either synchronously or
asynchronously.

Signed-off-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>

---

Changes since v0:

- Make the request ID 32 bits wide internally
---
 drivers/media/media-device.c | 175 +++++++++++++++++++++++++++++++++++++++++++
 include/media/media-device.h |  41 ++++++++++
 include/uapi/linux/media.h   |  12 +++
 3 files changed, 228 insertions(+)

diff --git a/drivers/media/media-device.c b/drivers/media/media-device.c
index 285f7d79d848..37da26806ed8 100644
--- a/drivers/media/media-device.c
+++ b/drivers/media/media-device.c
@@ -33,6 +33,7 @@
 
 struct media_device_fh {
 	struct media_devnode_fh fh;
+	struct list_head requests;
 };
 
 static inline struct media_device_fh *media_device_fh(struct file *filp)
@@ -41,6 +42,161 @@ static inline struct media_device_fh *media_device_fh(struct file *filp)
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
+
+	req = mdev->ops->req_alloc(mdev);
+	if (!req)
+		return -ENOMEM;
+
+	req->mdev = mdev;
+	kref_init(&req->kref);
+
+	spin_lock_irqsave(&mdev->req_lock, flags);
+	req->id = ++mdev->req_id;
+	list_add_tail(&req->list, &mdev->requests);
+	list_add_tail(&req->fh_list, &fh->requests);
+	spin_unlock_irqrestore(&mdev->req_lock, flags);
+
+	cmd->request = req->id;
+	return 0;
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
+				     struct media_device_fh *fh,
+				     struct media_request_cmd __user *_cmd)
+{
+	struct media_device_request *req = NULL;
+	struct media_request_cmd cmd;
+	int ret;
+
+	if (!mdev->ops || !mdev->ops->req_alloc || !mdev->ops->req_free)
+		return -ENOTTY;
+
+	if (copy_from_user(&cmd, _cmd, sizeof(cmd)))
+		return -EFAULT;
+
+	if (cmd.cmd != MEDIA_REQ_CMD_ALLOC) {
+		req = media_device_request_find(mdev, cmd.request);
+		if (!req)
+			return -EINVAL;
+	}
+
+	switch (cmd.cmd) {
+	case MEDIA_REQ_CMD_ALLOC:
+		ret = media_device_request_alloc(mdev, fh, &cmd);
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
+	if (copy_to_user(_cmd, &cmd, sizeof(cmd)))
+		return -EFAULT;
+
+	return 0;
+}
+
+/* -----------------------------------------------------------------------------
  * Userspace API
  */
 
@@ -52,6 +208,7 @@ static int media_device_open(struct file *filp)
 	if (!fh)
 		return -ENOMEM;
 
+	INIT_LIST_HEAD(&fh->requests);
 	filp->private_data = &fh->fh;
 
 	return 0;
@@ -60,6 +217,15 @@ static int media_device_open(struct file *filp)
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
 
@@ -257,6 +423,7 @@ static long media_device_ioctl(struct file *filp, unsigned int cmd,
 {
 	struct media_devnode *devnode = media_devnode_data(filp);
 	struct media_device *dev = to_media_device(devnode);
+	struct media_device_fh *fh = media_device_fh(filp);
 	long ret;
 
 	switch (cmd) {
@@ -284,6 +451,11 @@ static long media_device_ioctl(struct file *filp, unsigned int cmd,
 		mutex_unlock(&dev->graph_mutex);
 		break;
 
+	case MEDIA_IOC_REQUEST_CMD:
+		ret = media_device_request_cmd(dev, fh,
+				(struct media_request_cmd __user *)arg);
+		break;
+
 	default:
 		ret = -ENOIOCTLCMD;
 	}
@@ -404,6 +576,9 @@ int __must_check __media_device_register(struct media_device *mdev,
 	spin_lock_init(&mdev->lock);
 	mutex_init(&mdev->graph_mutex);
 
+	spin_lock_init(&mdev->req_lock);
+	INIT_LIST_HEAD(&mdev->requests);
+
 	/* Register the device node. */
 	mdev->devnode.fops = &media_device_fops;
 	mdev->devnode.parent = mdev->dev;
diff --git a/include/media/media-device.h b/include/media/media-device.h
index 7e6de4dbf497..bc003bedf087 100644
--- a/include/media/media-device.h
+++ b/include/media/media-device.h
@@ -23,6 +23,7 @@
 #ifndef _MEDIA_DEVICE_H
 #define _MEDIA_DEVICE_H
 
+#include <linux/kref.h>
 #include <linux/list.h>
 #include <linux/mutex.h>
 #include <linux/spinlock.h>
@@ -31,14 +32,42 @@
 #include <media/media-entity.h>
 
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
  * struct media_device_ops - Media device operations
  * @link_notify: Link state change notification callback
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
@@ -55,6 +84,9 @@ struct media_device_ops {
  * @lock:	Entities list lock
  * @graph_mutex: Entities graph operation lock
  * @ops:	Operation handler callbacks
+ * @req_lock:	Protects the req_id and requests fields
+ * @req_id:	Last request ID that was allocated
+ * @requests:	List of allocated requests
  *
  * This structure represents an abstract high-level media device. It allows easy
  * access to entities and provides basic media device-level support. The
@@ -86,6 +118,10 @@ struct media_device {
 	struct mutex graph_mutex;
 
 	const struct media_device_ops *ops;
+
+	spinlock_t req_lock;
+	u32 req_id;
+	struct list_head requests;
 };
 
 /* Supported link_notify @notification values. */
@@ -108,4 +144,9 @@ void media_device_unregister_entity(struct media_entity *entity);
 #define media_device_for_each_entity(entity, mdev)			\
 	list_for_each_entry(entity, &(mdev)->entities, list)
 
+struct media_device_request *
+media_device_request_find(struct media_device *mdev, u16 reqid);
+void media_device_request_get(struct media_device_request *req);
+void media_device_request_put(struct media_device_request *req);
+
 #endif
diff --git a/include/uapi/linux/media.h b/include/uapi/linux/media.h
index 4e816be3de39..fd8887a03988 100644
--- a/include/uapi/linux/media.h
+++ b/include/uapi/linux/media.h
@@ -167,9 +167,21 @@ struct media_links_enum {
 	__u32 reserved[4];
 };
 
+#define MEDIA_REQ_CMD_ALLOC		0
+#define MEDIA_REQ_CMD_DELETE		1
+#define MEDIA_REQ_CMD_APPLY		2
+#define MEDIA_REQ_CMD_QUEUE		3
+
+struct media_request_cmd {
+	__u32 cmd;
+	__u32 request;
+	__u32 reserved[9];
+};
+
 #define MEDIA_IOC_DEVICE_INFO		_IOWR('|', 0x00, struct media_device_info)
 #define MEDIA_IOC_ENUM_ENTITIES		_IOWR('|', 0x01, struct media_entity_desc)
 #define MEDIA_IOC_ENUM_LINKS		_IOWR('|', 0x02, struct media_links_enum)
 #define MEDIA_IOC_SETUP_LINK		_IOWR('|', 0x03, struct media_link_desc)
+#define MEDIA_IOC_REQUEST_CMD		_IOWR('|', 0x04, struct media_request_cmd)
 
 #endif /* __LINUX_MEDIA_H */
-- 
2.4.10

