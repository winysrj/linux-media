Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:35423 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751316AbeCIXtZ (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 9 Mar 2018 18:49:25 -0500
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: linux-media@vger.kernel.org
Cc: acourbot@chromium.org,
        Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
Subject: [RFC 2/8] media: Add request API
Date: Sat, 10 Mar 2018 01:48:46 +0200
Message-Id: <1520639332-19190-3-git-send-email-sakari.ailus@linux.intel.com>
In-Reply-To: <1520639332-19190-1-git-send-email-sakari.ailus@linux.intel.com>
References: <1520639332-19190-1-git-send-email-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>

The request API allows bundling media device parameters with request
objects and applying them atomically, either synchronously or
asynchronously.

Signed-off-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
---
 drivers/media/media-device.c | 366 ++++++++++++++++++++++++++++++++++++++++++-
 include/media/media-device.h |  71 ++++++++-
 include/uapi/linux/media.h   |  10 ++
 3 files changed, 441 insertions(+), 6 deletions(-)

diff --git a/drivers/media/media-device.c b/drivers/media/media-device.c
index da63da1..41ec5ac 100644
--- a/drivers/media/media-device.c
+++ b/drivers/media/media-device.c
@@ -19,11 +19,13 @@
 /* We need to access legacy defines from linux/media.h */
 #define __NEED_MEDIA_LEGACY_API
 
+#include <linux/anon_inodes.h>
 #include <linux/compat.h>
 #include <linux/export.h>
-#include <linux/idr.h>
+#include <linux/file.h>
 #include <linux/ioctl.h>
 #include <linux/media.h>
+#include <linux/sched.h>
 #include <linux/slab.h>
 #include <linux/types.h>
 #include <linux/pci.h>
@@ -35,6 +37,349 @@
 
 #ifdef CONFIG_MEDIA_CONTROLLER
 
+static const char *__request_state[] = {
+	"IDLE",
+	"QUEUED",
+	"COMPLETED",
+};
+
+const char *
+media_device_request_state_str(enum media_device_request_state state)
+{
+	if (state < ARRAY_SIZE(__request_state))
+		return __request_state[state];
+
+	return "UNKNOWN";
+}
+
+/* -----------------------------------------------------------------------------
+ * Requests
+ */
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
+	unsigned long flags;
+
+	dev_dbg(mdev->dev, "request: release %s\n", req->debug_str);
+
+	spin_lock_irqsave(&mdev->req_lock, flags);
+	list_del(&req->list);
+	spin_unlock_irqrestore(&mdev->req_lock, flags);
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
+static int media_device_request_close(struct inode *inode, struct file *filp)
+{
+	struct media_device_request *req = filp->private_data;
+
+	media_device_request_put(req);
+
+	return 0;
+}
+
+static const struct file_operations request_fops = {
+	.owner = THIS_MODULE,
+	.release = media_device_request_close,
+};
+
+/**
+ * media_device_request_find - Find a request based on the file descriptor
+ * @mdev: The media device
+ * @request: The request file handle
+ *
+ * Find and return the request associated with the given file descriptor, or
+ * an error if no such request exists.
+ *
+ * When the function returns a request it increases its reference count. The
+ * caller is responsible for releasing the reference by calling
+ * media_device_request_put() on the request.
+ */
+struct media_device_request *
+media_device_request_find(struct media_device *mdev, int request)
+{
+	struct file *filp;
+	struct media_device_request *req;
+
+	filp = fget(request);
+	if (!filp)
+		return ERR_PTR(-ENOENT);
+
+	if (filp->f_op != &request_fops)
+		goto err_fput;
+	req = filp->private_data;
+	media_device_request_get(req);
+
+	if (req->mdev != mdev)
+		goto err_kref_put;
+
+	fput(filp);
+
+	return req;
+
+err_kref_put:
+	media_device_request_put(req);
+
+err_fput:
+	fput(filp);
+
+	return ERR_PTR(-EBADF);
+}
+EXPORT_SYMBOL_GPL(media_device_request_find);
+
+static int media_device_request_alloc(struct media_device *mdev,
+				      struct file *filp,
+				      struct media_request_cmd *cmd)
+{
+	struct media_device_request *req;
+#ifdef CONFIG_DYNAMIC_DEBUG
+	char comm[TASK_COMM_LEN];
+#endif
+	unsigned long flags;
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
+	req->state = MEDIA_DEVICE_REQUEST_STATE_IDLE;
+	kref_init(&req->kref);
+
+	spin_lock_irqsave(&mdev->req_lock, flags);
+	list_add_tail(&req->req_list, &mdev->req_idle);
+	spin_unlock_irqrestore(&mdev->req_lock, flags);
+
+	cmd->request = fd;
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
+void media_device_request_complete(struct media_device *mdev,
+				   struct media_device_request *req)
+{
+	unsigned long flags;
+
+	spin_lock_irqsave(&mdev->req_lock, flags);
+
+	if (req->state == MEDIA_DEVICE_REQUEST_STATE_IDLE) {
+		dev_dbg(mdev->dev,
+			"request: not completing an idle request %s\n",
+			req->debug_str);
+		spin_unlock_irqrestore(&mdev->req_lock, flags);
+		return;
+	}
+
+	if (WARN_ON(req->state != MEDIA_DEVICE_REQUEST_STATE_QUEUED)) {
+		dev_dbg(mdev->dev, "request: can't delete %s, state %s\n",
+			req->debug_str,
+			media_device_request_state_str(req->state));
+		spin_unlock_irqrestore(&mdev->req_lock, flags);
+		return;
+	}
+
+	req->state = MEDIA_DEVICE_REQUEST_STATE_COMPLETE;
+
+	spin_unlock_irqrestore(&mdev->req_lock, flags);
+
+	media_device_request_put(req);
+}
+EXPORT_SYMBOL_GPL(media_device_request_complete);
+
+static int media_device_request_queue(
+	struct media_device *mdev, struct media_device_request *req, bool try)
+{
+	char *str = try ? "try" : "queue";
+	unsigned long flags;
+	int ret = 0;
+
+	dev_dbg(mdev->dev, "request: %s %s\n", str, req->debug_str);
+
+	/*
+	 * Ensure the request that was just validated is the one that gets
+	 * queued next.
+	 */
+	mutex_lock(&mdev->req_queue_mutex);
+
+	spin_lock_irqsave(&mdev->req_lock, flags);
+	if (req->state != MEDIA_DEVICE_REQUEST_STATE_IDLE) {
+		ret = -EINVAL;
+		dev_dbg(mdev->dev,
+			"request: unable to %s %s, request in state %s\n",
+			str, req->debug_str,
+			media_device_request_state_str(req->state));
+	} else {
+		req->state = MEDIA_DEVICE_REQUEST_STATE_QUEUED;
+	}
+	spin_unlock_irqrestore(&mdev->req_lock, flags);
+
+	if (ret)
+		goto err_unlock;
+
+	ret = mdev->ops->req_validate(mdev, req);
+	if (ret || try) {
+		if (ret)
+			dev_dbg(mdev->dev,
+				"request: %s failed validation (%d)\n",
+				req->debug_str, ret);
+		goto err_set_idle;
+	}
+
+	/*
+	 * Obtain a reference to the request, release once complete (or there's
+	 * an error).
+	 */
+	media_device_request_get(req);
+	spin_lock_irqsave(&mdev->req_lock, flags);
+	list_move(&req->list, &mdev->req_queued);
+	spin_unlock_irqrestore(&mdev->req_lock, flags);
+
+	ret = mdev->ops->req_queue(mdev, req);
+	if (ret) {
+		dev_dbg(mdev->dev, "request: can't queue %s (%d)\n",
+			req->debug_str, ret);
+		goto err_put;
+	}
+
+	mutex_unlock(&mdev->req_queue_mutex);
+
+	return 0;
+
+err_put:
+	media_device_request_put(req);
+
+err_set_idle:
+	spin_lock_irqsave(&mdev->req_lock, flags);
+	req->state = MEDIA_DEVICE_REQUEST_STATE_IDLE;
+	spin_unlock_irqrestore(&mdev->req_lock, flags);
+
+err_unlock:
+	mutex_unlock(&mdev->req_queue_mutex);
+
+	return ret;
+
+}
+
+static long media_device_request_cmd(struct media_device *mdev,
+				     struct file *filp,
+				     struct media_request_cmd *cmd)
+{
+	struct media_device_request *req = NULL;
+	int ret;
+
+	if (!mdev->ops || !mdev->ops->req_alloc || !mdev->ops->req_free ||
+	    !mdev->ops->req_validate || !mdev->ops->req_queue)
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
+		ret = media_device_request_alloc(mdev, filp, cmd);
+		break;
+
+	case MEDIA_REQ_CMD_QUEUE:
+		ret = media_device_request_queue(mdev, req, false);
+		break;
+
+	case MEDIA_REQ_CMD_TRY:
+		ret = media_device_request_queue(mdev, req, true);
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
+	return ret < 0 ? ret : 0;
+}
+
+/**
+ * media_device_request_alloc_simple - Callback to allocate memory for media
+ *				       request
+ *
+ * @mdev: The media device for which the request is to be allocated
+ *
+ * Allocate memory for a media request. Drivers are free to implement their own
+ * callbacks if more than just the size of the @struct media_device_request
+ * itself is needed. Driver's own data comes after @struct media_device_request.
+ */
+struct media_device_request *
+media_device_request_alloc_simple(struct media_device *mdev)
+{
+	return kzalloc(sizeof(struct media_device_request), GFP_KERNEL);
+}
+EXPORT_SYMBOL_GPL(media_device_request_alloc_simple);
+
+/**
+ * media_device_request_alloc_free - Callback to release media request memory
+ *
+ * @mdev: The media device
+ * @req: The request which is to be released
+ *
+ * Release the media request memory. If more than this is needed to clean up a
+ * media request, drivers are free to implement their own callbacks.
+ */
+void media_device_request_free_simple(struct media_device *mdev,
+				      struct media_device_request *req)
+{
+	kfree(req);
+}
+EXPORT_SYMBOL_GPL(media_device_request_free_simple);
+
 /* -----------------------------------------------------------------------------
  * Userspace API
  */
@@ -55,6 +400,7 @@ static int media_device_close(struct file *filp)
 }
 
 static int media_device_get_info(struct media_device *dev,
+				 struct file *filp,
 				 struct media_device_info *info)
 {
 	memset(info, 0, sizeof(*info));
@@ -94,6 +440,7 @@ static struct media_entity *find_entity(struct media_device *mdev, u32 id)
 }
 
 static long media_device_enum_entities(struct media_device *mdev,
+				       struct file *filp,
 				       struct media_entity_desc *entd)
 {
 	struct media_entity *ent;
@@ -147,6 +494,7 @@ static void media_device_kpad_to_upad(const struct media_pad *kpad,
 }
 
 static long media_device_enum_links(struct media_device *mdev,
+				    struct file *filp,
 				    struct media_links_enum *links)
 {
 	struct media_entity *entity;
@@ -196,6 +544,7 @@ static long media_device_enum_links(struct media_device *mdev,
 }
 
 static long media_device_setup_link(struct media_device *mdev,
+				    struct file *filp,
 				    struct media_link_desc *linkd)
 {
 	struct media_link *link = NULL;
@@ -226,6 +575,7 @@ static long media_device_setup_link(struct media_device *mdev,
 }
 
 static long media_device_get_topology(struct media_device *mdev,
+				      struct file *filp,
 				      struct media_v2_topology *topo)
 {
 	struct media_entity *entity;
@@ -390,7 +740,8 @@ static long copy_arg_to_user(void __user *uarg, void *karg, unsigned int cmd)
 #define MEDIA_IOC_SZ_ARG(__cmd, func, fl, alt_sz, from_user, to_user)	\
 	[_IOC_NR(MEDIA_IOC_##__cmd)] = {				\
 		.cmd = MEDIA_IOC_##__cmd,				\
-		.fn = (long (*)(struct media_device *, void *))func,	\
+		.fn = (long (*)(struct media_device *,			\
+				struct file *, void *))func,		\
 		.flags = fl,						\
 		.alt_arg_sizes = alt_sz,				\
 		.arg_from_user = from_user,				\
@@ -417,7 +768,7 @@ struct media_ioctl_info {
 	 * pointer is NULL.
 	 */
 	const unsigned short *alt_arg_sizes;
-	long (*fn)(struct media_device *dev, void *arg);
+	long (*fn)(struct media_device *dev, struct file *file, void *arg);
 	long (*arg_from_user)(void *karg, void __user *uarg, unsigned int cmd);
 	long (*arg_to_user)(void __user *uarg, void *karg, unsigned int cmd);
 };
@@ -428,6 +779,7 @@ static const struct media_ioctl_info ioctl_info[] = {
 	MEDIA_IOC(ENUM_LINKS, media_device_enum_links, MEDIA_IOC_FL_GRAPH_MUTEX),
 	MEDIA_IOC(SETUP_LINK, media_device_setup_link, MEDIA_IOC_FL_GRAPH_MUTEX),
 	MEDIA_IOC(G_TOPOLOGY, media_device_get_topology, MEDIA_IOC_FL_GRAPH_MUTEX),
+	MEDIA_IOC(REQUEST_CMD, media_device_request_cmd, 0),
 };
 
 #define MASK_IOC_SIZE(cmd) \
@@ -500,7 +852,7 @@ static long media_device_ioctl(struct file *filp, unsigned int cmd,
 	if (info->flags & MEDIA_IOC_FL_GRAPH_MUTEX)
 		mutex_lock(&dev->graph_mutex);
 
-	ret = info->fn(dev, karg);
+	ret = info->fn(dev, filp, karg);
 
 	if (info->flags & MEDIA_IOC_FL_GRAPH_MUTEX)
 		mutex_unlock(&dev->graph_mutex);
@@ -540,7 +892,7 @@ static long media_device_enum_links32(struct media_device *mdev,
 	links.pads = compat_ptr(pads_ptr);
 	links.links = compat_ptr(links_ptr);
 
-	return media_device_enum_links(mdev, &links);
+	return media_device_enum_links(mdev, NULL, &links);
 }
 
 #define MEDIA_IOC_ENUM_LINKS32		_IOWR('|', 0x02, struct media_links_enum32)
@@ -765,6 +1117,10 @@ int __must_check __media_device_register(struct media_device *mdev,
 	if (!devnode)
 		return -ENOMEM;
 
+	spin_lock_init(&mdev->req_lock);
+	INIT_LIST_HEAD(&mdev->req_idle);
+	INIT_LIST_HEAD(&mdev->req_queued);
+
 	/* Register the device node. */
 	mdev->devnode = devnode;
 	devnode->fops = &media_device_fops;
diff --git a/include/media/media-device.h b/include/media/media-device.h
index bcc6ec4..0f32ceb 100644
--- a/include/media/media-device.h
+++ b/include/media/media-device.h
@@ -19,14 +19,51 @@
 #ifndef _MEDIA_DEVICE_H
 #define _MEDIA_DEVICE_H
 
+#include <linux/kref.h>
+#include <linux/idr.h>
 #include <linux/list.h>
 #include <linux/mutex.h>
 
 #include <media/media-devnode.h>
 #include <media/media-entity.h>
 
-struct ida;
 struct device;
+struct ida;
+struct media_device;
+
+enum media_device_request_state {
+	MEDIA_DEVICE_REQUEST_STATE_IDLE,
+	MEDIA_DEVICE_REQUEST_STATE_QUEUED,
+	MEDIA_DEVICE_REQUEST_STATE_COMPLETE,
+};
+
+/**
+ * media_device_request_state_str - Convert media request state to a string
+ *
+ * @state: The state of the media request
+ *
+ * Returns the string corresponding to a media request state.
+ */
+const char *
+media_device_request_state_str(enum media_device_request_state state);
+
+/**
+ * struct media_device_request - Media device request
+ * @mdev: Media device this request belongs to
+ * @kref: Reference count
+ * @list: List entry in the media device requests list
+ * @debug_prefix: Prefix for debug messages (process name:fd)
+ * @state: The state of the request
+ */
+struct media_device_request {
+	struct media_device *mdev;
+	struct kref kref;
+	struct list_head list;
+#ifdef CONFIG_DYNAMIC_DEBUG
+	char debug_str[TASK_COMM_LEN + 6];
+#endif
+	enum media_device_request_state state;
+};
 
 /**
  * struct media_entity_notify - Media Entity Notify
@@ -50,10 +87,21 @@ struct media_entity_notify {
  * struct media_device_ops - Media device operations
  * @link_notify: Link state change notification callback. This callback is
  *		 called with the graph_mutex held.
+ * @req_alloc: Allocate a request
+ * @req_free: Free a request
+ * @req_validate: Validate a request
+ * @req_queue: Queue a request
  */
 struct media_device_ops {
 	int (*link_notify)(struct media_link *link, u32 flags,
 			   unsigned int notification);
+	struct media_device_request *(*req_alloc)(struct media_device *mdev);
+	void (*req_free)(struct media_device *mdev,
+			 struct media_device_request *req);
+	int (*req_validate)(struct media_device *mdev,
+			 struct media_device_request *req);
+	int (*req_queue)(struct media_device *mdev,
+			 struct media_device_request *req);
 };
 
 /**
@@ -88,6 +136,11 @@ struct media_device_ops {
  * @disable_source: Disable Source Handler function pointer
  *
  * @ops:	Operation handler callbacks
+ * @req_lock:	Serialise access to @requests
+ * @req_queue_mutex: Serialise validating and queueing requests
+ * @req_idle:	List of idle requests (@struct media_request.list)
+ * @req_queued:	List of queued (and completed) requests (@struct
+ *		media_request.list)
  *
  * This structure represents an abstract high-level media device. It allows easy
  * access to entities and provides basic media device-level support. The
@@ -158,6 +211,11 @@ struct media_device {
 	void (*disable_source)(struct media_entity *entity);
 
 	const struct media_device_ops *ops;
+
+	spinlock_t req_lock;
+	struct mutex req_queue_mutex;
+	struct list_head req_queued;
+	struct list_head req_idle;
 };
 
 /* We don't need to include pci.h or usb.h here */
@@ -475,4 +533,15 @@ static inline void __media_device_usb_init(struct media_device *mdev,
 #define media_device_usb_init(mdev, udev, name) \
 	__media_device_usb_init(mdev, udev, name, KBUILD_MODNAME)
 
+struct media_device_request *
+media_device_request_find(struct media_device *mdev, int request);
+void media_device_request_get(struct media_device_request *req);
+void media_device_request_put(struct media_device_request *req);
+void media_device_request_complete(struct media_device *mdev,
+				   struct media_device_request *req);
+
+struct media_device_request *
+media_device_request_alloc_simple(struct media_device *mdev);
+void media_device_request_free_simple(struct media_device *mdev,
+				      struct media_device_request *req);
 #endif
diff --git a/include/uapi/linux/media.h b/include/uapi/linux/media.h
index c7e9a5c..9bc397b 100644
--- a/include/uapi/linux/media.h
+++ b/include/uapi/linux/media.h
@@ -342,11 +342,21 @@ struct media_v2_topology {
 
 /* ioctls */
 
+#define MEDIA_REQ_CMD_ALLOC		0
+#define MEDIA_REQ_CMD_TRY		1
+#define MEDIA_REQ_CMD_QUEUE		2
+
+struct __attribute__ ((packed)) media_request_cmd {
+	__u32 cmd;
+	__s32 request;
+};
+
 #define MEDIA_IOC_DEVICE_INFO	_IOWR('|', 0x00, struct media_device_info)
 #define MEDIA_IOC_ENUM_ENTITIES	_IOWR('|', 0x01, struct media_entity_desc)
 #define MEDIA_IOC_ENUM_LINKS	_IOWR('|', 0x02, struct media_links_enum)
 #define MEDIA_IOC_SETUP_LINK	_IOWR('|', 0x03, struct media_link_desc)
 #define MEDIA_IOC_G_TOPOLOGY	_IOWR('|', 0x04, struct media_v2_topology)
+#define MEDIA_IOC_REQUEST_CMD	_IOWR('|', 0x05, struct media_request_cmd)
 
 #if !defined(__KERNEL__) || defined(__NEED_MEDIA_LEGACY_API)
 
-- 
2.7.4
