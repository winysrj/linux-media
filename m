Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga05.intel.com ([192.55.52.43]:59313 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752604AbeEULd0 (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 21 May 2018 07:33:26 -0400
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: linux-media@vger.kernel.org
Cc: hverkuil@xs4all.nl
Subject: [PATCH v14.2 v14 06/36] media-request: Add support for updating request objects optimally
Date: Mon, 21 May 2018 14:33:12 +0300
Message-Id: <20180521113312.19799-1-sakari.ailus@linux.intel.com>
In-Reply-To: <20180521102905.17704-1-sakari.ailus@linux.intel.com>
References: <20180521102905.17704-1-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add a new request state (UPDATING) as well as a count for updating the
request objects. This way, several updates may take place simultaneously
without affecting each other. The drivers (as well as frameworks) still
must serialise access to their own data structures; what is guaranteed by
the new state is simply correct and optimal handling of requests.

Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
---
since v14.1:

- Add dummy variants of the update lock functions to be used if MC is
  disabled.

 drivers/media/media-request.c |  7 ++++-
 include/media/media-request.h | 65 ++++++++++++++++++++++++++++++++++++++++++-
 2 files changed, 70 insertions(+), 2 deletions(-)

diff --git a/drivers/media/media-request.c b/drivers/media/media-request.c
index a1576cf528605..cbffb0261df02 100644
--- a/drivers/media/media-request.c
+++ b/drivers/media/media-request.c
@@ -12,6 +12,7 @@
 
 #include <linux/anon_inodes.h>
 #include <linux/file.h>
+#include <linux/refcount.h>
 
 #include <media/media-device.h>
 #include <media/media-request.h>
@@ -22,6 +23,7 @@ static const char * const request_state[] = {
 	[MEDIA_REQUEST_STATE_QUEUED]	 = "queued",
 	[MEDIA_REQUEST_STATE_COMPLETE]	 = "complete",
 	[MEDIA_REQUEST_STATE_CLEANING]	 = "cleaning",
+	[MEDIA_REQUEST_STATE_UPDATING]	 = "updating",
 };
 
 static const char *
@@ -38,12 +40,14 @@ static void media_request_clean(struct media_request *req)
 
 	/* Just a sanity check. No other code path is allowed to change this. */
 	WARN_ON(req->state != MEDIA_REQUEST_STATE_CLEANING);
+	WARN_ON(refcount_read(&req->updating_count));
 
 	list_for_each_entry_safe(obj, obj_safe, &req->objects, list) {
 		media_request_object_unbind(obj);
 		media_request_object_put(obj);
 	}
 
+	refcount_set(&req->updating_count, 0);
 	req->num_incomplete_objects = 0;
 	wake_up_interruptible_all(&req->poll_wait);
 }
@@ -294,6 +298,7 @@ int media_request_alloc(struct media_device *mdev,
 	INIT_LIST_HEAD(&req->objects);
 	spin_lock_init(&req->lock);
 	init_waitqueue_head(&req->poll_wait);
+	refcount_set(&req->updating_count, 0);
 
 	alloc->fd = fd;
 
@@ -385,7 +390,7 @@ int media_request_object_bind(struct media_request *req,
 
 	spin_lock_irqsave(&req->lock, flags);
 
-	if (WARN_ON(req->state != MEDIA_REQUEST_STATE_IDLE))
+	if (WARN_ON(req->state != MEDIA_REQUEST_STATE_UPDATING))
 		goto unlock;
 
 	list_add_tail(&obj->list, &req->objects);
diff --git a/include/media/media-request.h b/include/media/media-request.h
index e175538d3c669..2a622b2d400f8 100644
--- a/include/media/media-request.h
+++ b/include/media/media-request.h
@@ -15,7 +15,7 @@
 #include <linux/list.h>
 #include <linux/slab.h>
 #include <linux/spinlock.h>
-#include <linux/atomic.h>
+#include <linux/refcount.h>
 
 #include <media/media-device.h>
 
@@ -28,6 +28,9 @@
  * @MEDIA_REQUEST_STATE_QUEUED:		Queued
  * @MEDIA_REQUEST_STATE_COMPLETE:	Completed, the request is done
  * @MEDIA_REQUEST_STATE_CLEANING:	Cleaning, the request is being re-inited
+ * @MEDIA_REQUEST_STATE_UPDATING:	The request is being updated, i.e.
+ *					request objects are being added,
+ *					modified or removed
  */
 enum media_request_state {
 	MEDIA_REQUEST_STATE_IDLE,
@@ -35,6 +38,7 @@ enum media_request_state {
 	MEDIA_REQUEST_STATE_QUEUED,
 	MEDIA_REQUEST_STATE_COMPLETE,
 	MEDIA_REQUEST_STATE_CLEANING,
+	MEDIA_REQUEST_STATE_UPDATING,
 };
 
 struct media_request_object;
@@ -56,6 +60,7 @@ struct media_request {
 	struct kref kref;
 	char debug_str[TASK_COMM_LEN + 11];
 	enum media_request_state state;
+	refcount_t updating_count;
 	struct list_head objects;
 	unsigned int num_incomplete_objects;
 	struct wait_queue_head poll_wait;
@@ -65,6 +70,54 @@ struct media_request {
 #ifdef CONFIG_MEDIA_CONTROLLER
 
 /**
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
+		refcount_inc(&req->updating_count);
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
+	if (refcount_dec_and_test(&req->updating_count))
+		req->state = MEDIA_REQUEST_STATE_IDLE;
+	spin_unlock_irqrestore(&req->lock, flags);
+}
+
+/**
  * media_request_get - Get the media request
  *
  * @req: The request
@@ -249,6 +302,16 @@ void media_request_object_complete(struct media_request_object *obj);
 
 #else
 
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
 static inline void media_request_object_get(struct media_request_object *obj)
 {
 }
-- 
2.11.0
