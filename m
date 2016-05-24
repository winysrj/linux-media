Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:30726 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756468AbcEXQvB (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 24 May 2016 12:51:01 -0400
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: linux-media@vger.kernel.org
Cc: laurent.pinchart@ideasonboard.com, hverkuil@xs4all.nl,
	mchehab@osg.samsung.com
Subject: [RFC v2 13/21] media: Add MEDIA_IOC_DQEVENT
Date: Tue, 24 May 2016 19:47:23 +0300
Message-Id: <1464108451-28142-14-git-send-email-sakari.ailus@linux.intel.com>
In-Reply-To: <1464108451-28142-1-git-send-email-sakari.ailus@linux.intel.com>
References: <1464108451-28142-1-git-send-email-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Events on a media device tell about completion of requests. Blocking and
non-blocking operation is supported.

Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
---
 drivers/media/media-device.c | 102 ++++++++++++++++++++++++++++++++++++++++++-
 include/media/media-device.h |  10 +++++
 include/uapi/linux/media.h   |  17 ++++++++
 3 files changed, 128 insertions(+), 1 deletion(-)

diff --git a/drivers/media/media-device.c b/drivers/media/media-device.c
index 462823f..d00d3fc 100644
--- a/drivers/media/media-device.c
+++ b/drivers/media/media-device.c
@@ -23,6 +23,7 @@
 /* We need to access legacy defines from linux/media.h */
 #define __NEED_MEDIA_LEGACY_API
 
+#include <linux/atomic.h>
 #include <linux/compat.h>
 #include <linux/export.h>
 #include <linux/ioctl.h>
@@ -31,6 +32,7 @@
 #include <linux/types.h>
 #include <linux/pci.h>
 #include <linux/usb.h>
+#include <linux/wait.h>
 
 #include <media/media-device.h>
 #include <media/media-devnode.h>
@@ -51,6 +53,11 @@ static char *__request_state[] = {
 struct media_device_fh {
 	struct media_devnode_fh fh;
 	struct list_head requests;
+	struct {
+		struct list_head head;
+		wait_queue_head_t wait;
+		atomic_t sequence;
+	} kevents;
 };
 
 static inline struct media_device_fh *media_device_fh(struct file *filp)
@@ -107,6 +114,25 @@ void media_device_request_get(struct media_device_request *req)
 }
 EXPORT_SYMBOL_GPL(media_device_request_get);
 
+static void media_device_request_queue_event(struct media_device *mdev,
+					     struct media_device_request *req,
+					     struct media_device_fh *fh)
+{
+	struct media_kevent *kev = req->kev;
+	struct media_event *ev = &kev->ev;
+
+	lockdep_assert_held(&mdev->req_lock);
+
+	ev->sequence = atomic_inc_return(&fh->kevents.sequence);
+	ev->type = MEDIA_EVENT_TYPE_REQUEST_COMPLETE;
+	ev->req_complete.id = req->id;
+
+	list_add(&kev->list, &fh->kevents.head);
+	req->kev = NULL;
+	req->state = MEDIA_DEVICE_REQUEST_STATE_COMPLETE;
+	wake_up(&fh->kevents.wait);
+}
+
 static void media_device_request_release(struct kref *kref)
 {
 	struct media_entity_request_data *data, *next;
@@ -123,6 +149,9 @@ static void media_device_request_release(struct kref *kref)
 
 	ida_simple_remove(&mdev->req_ids, req->id);
 
+	kfree(req->kev);
+	req->kev = NULL;
+
 	mdev->ops->req_free(mdev, req);
 }
 
@@ -202,6 +231,7 @@ static int media_device_request_alloc(struct media_device *mdev,
 {
 	struct media_device_fh *fh = media_device_fh(filp);
 	struct media_device_request *req;
+	struct media_kevent *kev;
 	unsigned long flags;
 	int id = ida_simple_get(&mdev->req_ids, 1, 0, GFP_KERNEL);
 	int ret;
@@ -211,16 +241,23 @@ static int media_device_request_alloc(struct media_device *mdev,
 		return id;
 	}
 
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
 	req->filp = filp;
 	req->state = MEDIA_DEVICE_REQUEST_STATE_IDLE;
+	req->kev = kev;
 	kref_init(&req->kref);
 	INIT_LIST_HEAD(&req->data);
 
@@ -235,6 +272,9 @@ static int media_device_request_alloc(struct media_device *mdev,
 
 	return 0;
 
+out_kev_free:
+	kfree(kev);
+
 out_ida_simple_remove:
 	ida_simple_remove(&mdev->req_ids, id);
 
@@ -308,6 +348,8 @@ void media_device_request_complete(struct media_device *mdev,
 		 */
 		list_del(&req->list);
 		list_del(&req->fh_list);
+		media_device_request_queue_event(
+			mdev, req, media_device_fh(filp));
 		req->filp = NULL;
 	}
 
@@ -433,6 +475,9 @@ static int media_device_open(struct file *filp)
 		return -ENOMEM;
 
 	INIT_LIST_HEAD(&fh->requests);
+	INIT_LIST_HEAD(&fh->kevents.head);
+	init_waitqueue_head(&fh->kevents.wait);
+	atomic_set(&fh->kevents.sequence, -1);
 	filp->private_data = &fh->fh;
 
 	return 0;
@@ -455,6 +500,16 @@ static int media_device_close(struct file *filp)
 		media_device_request_put(req);
 		spin_lock_irq(&mdev->req_lock);
 	}
+
+	while (!list_empty(&fh->kevents.head)) {
+		struct media_kevent *kev =
+			list_first_entry(&fh->kevents.head, typeof(*kev), list);
+
+		list_del(&kev->list);
+		spin_unlock_irq(&mdev->req_lock);
+		kfree(kev);
+		spin_lock_irq(&mdev->req_lock);
+	}
 	spin_unlock_irq(&mdev->req_lock);
 
 	kfree(fh);
@@ -772,6 +827,49 @@ static long media_device_get_topology(struct media_device *mdev,
 	return ret;
 }
 
+static struct media_kevent *opportunistic_dqevent(struct media_device *mdev,
+						  struct file *filp)
+{
+	struct media_device_fh *fh = media_device_fh(filp);
+	struct media_kevent *kev = NULL;
+	unsigned long flags;
+
+	spin_lock_irqsave(&mdev->req_lock, flags);
+	if (!list_empty(&fh->kevents.head)) {
+		kev = list_last_entry(&fh->kevents.head,
+				      struct media_kevent, list);
+		list_del(&kev->list);
+	}
+	spin_unlock_irqrestore(&mdev->req_lock, flags);
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
+		kev = opportunistic_dqevent(mdev, filp);
+		if (!kev)
+			return -ENODATA;
+	} else {
+		int ret = wait_event_interruptible(
+			fh->kevents.wait,
+			(kev = opportunistic_dqevent(mdev, filp)));
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
@@ -924,6 +1022,7 @@ static const struct media_ioctl_info ioctl_info[] = {
 	MEDIA_IOC(SETUP_LINK, media_device_setup_link, MEDIA_IOC_FL_GRAPH_MUTEX),
 	MEDIA_IOC(G_TOPOLOGY, media_device_get_topology, MEDIA_IOC_FL_GRAPH_MUTEX),
 	MEDIA_IOC(REQUEST_CMD, media_device_request_cmd, 0),
+	MEDIA_IOC(DQEVENT, media_device_dqevent, 0),
 };
 
 static long media_device_ioctl(struct file *filp, unsigned int cmd,
@@ -972,6 +1071,7 @@ static const struct media_ioctl_info compat_ioctl_info[] = {
 	MEDIA_IOC(SETUP_LINK, media_device_setup_link, MEDIA_IOC_FL_GRAPH_MUTEX),
 	MEDIA_IOC(G_TOPOLOGY, media_device_get_topology, MEDIA_IOC_FL_GRAPH_MUTEX),
 	MEDIA_IOC(REQUEST_CMD, media_device_request_cmd, 0),
+	MEDIA_IOC(DQEVENT, media_device_dqevent, 0),
 };
 
 static long media_device_compat_ioctl(struct file *filp, unsigned int cmd,
diff --git a/include/media/media-device.h b/include/media/media-device.h
index d4e2929..21b3deb 100644
--- a/include/media/media-device.h
+++ b/include/media/media-device.h
@@ -31,6 +31,8 @@
 #include <media/media-devnode.h>
 #include <media/media-entity.h>
 
+#include <uapi/linux/media.h>
+
 /**
  * DOC: Media Controller
  *
@@ -263,7 +265,9 @@
  */
 
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
@@ -287,6 +296,7 @@ struct media_device_request {
 	u32 id;
 	struct media_device *mdev;
 	struct file *filp;
+	struct media_kevent *kev;
 	struct kref kref;
 	struct list_head list;
 	struct list_head fh_list;
diff --git a/include/uapi/linux/media.h b/include/uapi/linux/media.h
index e8922ea..60cc34c 100644
--- a/include/uapi/linux/media.h
+++ b/include/uapi/linux/media.h
@@ -399,11 +399,28 @@ struct __attribute__ ((packed)) media_request_cmd {
 	__u32 request;
 };
 
+struct __attribute__ ((packed)) media_event_request_complete {
+	__u32 id;
+};
+
+#define MEDIA_EVENT_TYPE_REQUEST_COMPLETE	1
+
+struct __attribute__ ((packed)) media_event {
+	__u32 type;
+	__u32 sequence;
+	__u32 reserved[4];
+
+	union {
+		struct media_event_request_complete req_complete;
+	};
+};
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

