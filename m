Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:18285 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758138AbcEFK4l (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 6 May 2016 06:56:41 -0400
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: linux-media@vger.kernel.org
Cc: laurent.pinchart@ideasonboard.com, hverkuil@xs4all.nl,
	mchehab@osg.samsung.com
Subject: [RFC 14/22] media: Add MEDIA_IOC_DQEVENT
Date: Fri,  6 May 2016 13:53:23 +0300
Message-Id: <1462532011-15527-15-git-send-email-sakari.ailus@linux.intel.com>
In-Reply-To: <1462532011-15527-1-git-send-email-sakari.ailus@linux.intel.com>
References: <1462532011-15527-1-git-send-email-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Events on a media device tell about completion of requests. Blocking and
non-blocking operation is supported.

Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
---
 drivers/media/media-device.c | 114 +++++++++++++++++++++++++++++++++++++++++--
 include/media/media-device.h |  11 +++++
 include/uapi/linux/media.h   |  17 +++++++
 3 files changed, 137 insertions(+), 5 deletions(-)

diff --git a/drivers/media/media-device.c b/drivers/media/media-device.c
index 10b9a4a..357c3cb 100644
--- a/drivers/media/media-device.c
+++ b/drivers/media/media-device.c
@@ -23,6 +23,7 @@
 /* We need to access legacy defines from linux/media.h */
 #define __NEED_MEDIA_LEGACY_API
 
+#include <linux/atomic.h>
 #include <linux/compat.h>
 #include <linux/export.h>
 #include <linux/idr.h>
@@ -32,6 +33,7 @@
 #include <linux/types.h>
 #include <linux/pci.h>
 #include <linux/usb.h>
+#include <linux/wait.h>
 
 #include <media/media-device.h>
 #include <media/media-devnode.h>
@@ -42,6 +44,12 @@
 struct media_device_fh {
 	struct media_devnode_fh fh;
 	struct list_head requests;
+	struct {
+		spinlock_t lock;
+		struct list_head head;
+		wait_queue_head_t wait;
+		atomic_t sequence;
+	} kevents;
 };
 
 static inline struct media_device_fh *media_device_fh(struct file *filp)
@@ -92,6 +100,33 @@ void media_device_request_get(struct media_device_request *req)
 }
 EXPORT_SYMBOL_GPL(media_device_request_get);
 
+static void media_device_request_queue_event(struct media_device *mdev,
+					     struct media_device_request *req)
+{
+	struct media_kevent *kev = req->kev;
+	struct media_event *ev = &kev->ev;
+	struct media_device_fh *fh;
+	unsigned long flags;
+
+	spin_lock_irqsave(&mdev->req_lock, flags);
+	if (!req->filp) {
+		spin_unlock_irqrestore(&mdev->req_lock, flags);
+		return;
+	}
+	fh = media_device_fh(req->filp);
+
+	ev->sequence = atomic_inc_return(&fh->kevents.sequence);
+	ev->type = MEDIA_EVENT_TYPE_REQUEST_COMPLETE;
+	ev->req_complete.id = req->id;
+	ev->req_complete.status = 0;
+
+	list_add(&kev->list, &fh->kevents.head);
+	req->kev = NULL;
+	req->state = MEDIA_DEVICE_REQUEST_STATE_COMPLETE;
+	wake_up(&fh->kevents.wait);
+	spin_unlock_irqrestore(&mdev->req_lock, flags);
+}
+
 static void media_device_request_release(struct kref *kref)
 {
 	struct media_entity_request_data *data, *next;
@@ -106,6 +141,9 @@ static void media_device_request_release(struct kref *kref)
 
 	ida_simple_remove(&mdev->req_ids, req->id);
 
+	kfree(req->kev);
+	req->kev = NULL;
+
 	mdev->ops->req_free(mdev, req);
 }
 
@@ -180,10 +218,12 @@ void media_device_request_set_entity_data(struct media_device_request *req,
 EXPORT_SYMBOL_GPL(media_device_request_set_entity_data);
 
 static int media_device_request_alloc(struct media_device *mdev,
-				      struct media_device_fh *fh,
+				      struct file *filp,
 				      struct media_request_cmd *cmd)
 {
+	struct media_device_fh *fh = media_device_fh(filp);
 	struct media_device_request *req;
+	struct media_kevent *kev;
 	unsigned long flags;
 	int id = ida_simple_get(&mdev->req_ids, 1, 0, GFP_KERNEL);
 	int ret;
@@ -191,14 +231,22 @@ static int media_device_request_alloc(struct media_device *mdev,
 	if (id < 0)
 		return id;
 
+	kev = kzalloc(sizeof(*kev), GFP_KERNEL);
+	if (!kev) {
+		ret = -ENOMEM;
+		goto out_ida_simple_remove;
+	}
+
 	req = mdev->ops->req_alloc(mdev);
 	if (!req) {
 		ret = -ENOMEM;
-		goto out_ida_simple_remove;
+		goto out_kev_free;
 	}
 
 	req->mdev = mdev;
 	req->id = id;
+	req->filp = filp;
+	req->kev = kev;
 	kref_init(&req->kref);
 	INIT_LIST_HEAD(&req->data);
 
@@ -211,6 +259,9 @@ static int media_device_request_alloc(struct media_device *mdev,
 
 	return 0;
 
+out_kev_free:
+	kfree(kev);
+
 out_ida_simple_remove:
 	ida_simple_remove(&mdev->req_ids, id);
 
@@ -233,6 +284,8 @@ static void media_device_request_delete(struct media_device *mdev,
 void media_device_request_complete(struct media_device *mdev,
 				   struct media_device_request *req)
 {
+	media_device_request_queue_event(mdev, req);
+
 	media_device_request_delete(mdev, req);
 }
 EXPORT_SYMBOL_GPL(media_device_request_complete);
@@ -272,7 +325,6 @@ static long media_device_request_cmd(struct media_device *mdev,
 				     struct file *filp,
 				     struct media_request_cmd *cmd)
 {
-	struct media_device_fh *fh = media_device_fh(filp);
 	struct media_device_request *req = NULL;
 	unsigned long flags;
 	int ret;
@@ -288,7 +340,7 @@ static long media_device_request_cmd(struct media_device *mdev,
 
 	switch (cmd->cmd) {
 	case MEDIA_REQ_CMD_ALLOC:
-		ret = media_device_request_alloc(mdev, fh, cmd);
+		ret = media_device_request_alloc(mdev, filp, cmd);
 		break;
 
 	case MEDIA_REQ_CMD_DELETE:
@@ -347,6 +399,10 @@ static int media_device_open(struct file *filp)
 		return -ENOMEM;
 
 	INIT_LIST_HEAD(&fh->requests);
+	INIT_LIST_HEAD(&fh->kevents.head);
+	spin_lock_init(&fh->kevents.lock);
+	init_waitqueue_head(&fh->kevents.wait);
+	atomic_set(&fh->kevents.sequence, -1);
 	filp->private_data = &fh->fh;
 
 	return 0;
@@ -356,6 +412,7 @@ static int media_device_close(struct file *filp)
 {
 	struct media_device_fh *fh = media_device_fh(filp);
 	struct media_device *mdev = to_media_device(fh->fh.devnode);
+	struct media_kevent *kev, *kev_safe;
 
 	spin_lock_irq(&mdev->req_lock);
 	while (!list_empty(&fh->requests)) {
@@ -364,13 +421,17 @@ static int media_device_close(struct file *filp)
 		req = list_first_entry(&fh->requests, typeof(*req), fh_list);
 		list_del(&req->list);
 		list_del(&req->fh_list);
-
+		req->filp = NULL;
 		spin_unlock_irq(&mdev->req_lock);
 		media_device_request_put(req);
 		spin_lock_irq(&mdev->req_lock);
 	}
 	spin_unlock_irq(&mdev->req_lock);
 
+	/* No other users around --- no lock needed. */
+	list_for_each_entry_safe(kev, kev_safe, &fh->kevents.head, list)
+		list_del(&kev->list);
+
 	kfree(fh);
 
 	return 0;
@@ -686,6 +747,47 @@ static long media_device_get_topology(struct media_device *mdev,
 	return ret;
 }
 
+static struct media_kevent *opportunistic_dqevent(struct file *filp)
+{
+	struct media_device_fh *fh = media_device_fh(filp);
+	struct media_kevent *kev = NULL;
+	unsigned long flags;
+
+	spin_lock_irqsave(&fh->kevents.lock, flags);
+	if (!list_empty(&fh->kevents.head)) {
+		kev = list_last_entry(&fh->kevents.head,
+				      struct media_kevent, list);
+		list_del(&kev->list);
+	}
+	spin_unlock_irqrestore(&fh->kevents.lock, flags);
+
+	return kev;
+}
+
+static int media_device_dqevent(struct media_device *mdev,
+				struct file *filp,
+				struct media_event *ev)
+{
+	struct media_device_fh *fh = media_device_fh(filp);
+	struct media_kevent *kev;
+
+	if (filp->f_flags & O_NONBLOCK) {
+		kev = opportunistic_dqevent(filp);
+		if (!kev)
+			return -ENODATA;
+	} else {
+		int ret = wait_event_interruptible(
+			fh->kevents.wait, (kev = opportunistic_dqevent(filp)));
+		if (ret == -ERESTARTSYS)
+			return ret;
+	}
+
+	*ev = kev->ev;
+	kfree(kev);
+
+	return 0;
+}
+
 static long copy_arg_from_user(void *karg, void __user *uarg, unsigned int cmd)
 {
 	/* All media IOCTLs are _IOWR() */
@@ -835,6 +937,7 @@ static const struct media_ioctl_info ioctl_info[] = {
 	MEDIA_IOC(SETUP_LINK, media_device_setup_link, MEDIA_IOC_FL_GRAPH_MUTEX),
 	MEDIA_IOC(G_TOPOLOGY, media_device_get_topology, MEDIA_IOC_FL_GRAPH_MUTEX),
 	MEDIA_IOC(REQUEST_CMD, media_device_request_cmd, 0),
+	MEDIA_IOC(DQEVENT, media_device_dqevent, 0),
 };
 
 static long media_device_ioctl(struct file *filp, unsigned int cmd,
@@ -883,6 +986,7 @@ static const struct media_ioctl_info compat_ioctl_info[] = {
 	MEDIA_IOC(SETUP_LINK, media_device_setup_link, MEDIA_IOC_FL_GRAPH_MUTEX),
 	MEDIA_IOC(G_TOPOLOGY, media_device_get_topology, MEDIA_IOC_FL_GRAPH_MUTEX),
 	MEDIA_IOC(REQUEST_CMD, media_device_request_cmd, 0),
+	MEDIA_IOC(DQEVENT, media_device_dqevent, 0),
 };
 
 static long media_device_compat_ioctl(struct file *filp, unsigned int cmd,
diff --git a/include/media/media-device.h b/include/media/media-device.h
index 2082108..e62ad13 100644
--- a/include/media/media-device.h
+++ b/include/media/media-device.h
@@ -30,6 +30,8 @@
 #include <media/media-devnode.h>
 #include <media/media-entity.h>
 
+#include <uapi/linux/media.h>
+
 /**
  * DOC: Media Controller
  *
@@ -263,7 +265,9 @@
 
 struct ida;
 struct device;
+struct file;
 struct media_device;
+struct media_device_fh;
 
 enum media_device_request_state {
 	MEDIA_DEVICE_REQUEST_STATE_IDLE,
@@ -272,6 +276,11 @@ enum media_device_request_state {
 	MEDIA_DEVICE_REQUEST_STATE_COMPLETE,
 };
 
+struct media_kevent {
+	struct list_head list;
+	struct media_event ev;
+};
+
 /**
  * struct media_device_request - Media device request
  * @id: Request ID
@@ -286,6 +295,8 @@ enum media_device_request_state {
 struct media_device_request {
 	u32 id;
 	struct media_device *mdev;
+	struct file *filp;
+	struct media_kevent *kev;
 	struct kref kref;
 	struct list_head list;
 	struct list_head fh_list;
diff --git a/include/uapi/linux/media.h b/include/uapi/linux/media.h
index e8922ea..f6e1efe 100644
--- a/include/uapi/linux/media.h
+++ b/include/uapi/linux/media.h
@@ -399,11 +399,28 @@ struct __attribute__ ((packed)) media_request_cmd {
 	__u32 request;
 };
 
+#define MEDIA_EVENT_TYPE_REQUEST_COMPLETE	1
+
+struct media_event_request_complete {
+	__u32 id;
+	__s32 status;
+};
+
+struct media_event {
+	__u32 type;
+	__u32 sequence;
+
+	union {
+		struct media_event_request_complete req_complete;
+	};
+} __attribute__ ((packed));
+
 #define MEDIA_IOC_DEVICE_INFO		_IOWR('|', 0x00, struct media_device_info)
 #define MEDIA_IOC_ENUM_ENTITIES		_IOWR('|', 0x01, struct media_entity_desc)
 #define MEDIA_IOC_ENUM_LINKS		_IOWR('|', 0x02, struct media_links_enum)
 #define MEDIA_IOC_SETUP_LINK		_IOWR('|', 0x03, struct media_link_desc)
 #define MEDIA_IOC_G_TOPOLOGY		_IOWR('|', 0x04, struct media_v2_topology)
 #define MEDIA_IOC_REQUEST_CMD		_IOWR('|', 0x05, struct media_request_cmd)
+#define MEDIA_IOC_DQEVENT		_IOWR('|', 0x06, struct media_event)
 
 #endif /* __LINUX_MEDIA_H */
-- 
1.9.1

