Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga14.intel.com ([192.55.52.115]:28373 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752669AbeEUIzQ (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 21 May 2018 04:55:16 -0400
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: linux-media@vger.kernel.org
Cc: hverkuil@xs4all.nl
Subject: [PATCH v14 06/36] media-request: Add support for updating request objects optimally
Date: Mon, 21 May 2018 11:54:31 +0300
Message-Id: <20180521085501.16861-7-sakari.ailus@linux.intel.com>
In-Reply-To: <20180521085501.16861-1-sakari.ailus@linux.intel.com>
References: <20180521085501.16861-1-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add a new request state (UPDATING) as well as a count for updating the
request objects. This way, several updates may take place simultaneously
without affecting each other. The drivers (as well as frameworks) still
must serialise access to their own data structures; what is guaranteed by
the new state is simply correct and optimal handling of requests.

Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
---
 drivers/media/media-request.c |  3 ++-
 include/media/media-request.h | 53 +++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 55 insertions(+), 1 deletion(-)

diff --git a/drivers/media/media-request.c b/drivers/media/media-request.c
index a1576cf528605..03e74d72241a0 100644
--- a/drivers/media/media-request.c
+++ b/drivers/media/media-request.c
@@ -22,6 +22,7 @@ static const char * const request_state[] = {
 	[MEDIA_REQUEST_STATE_QUEUED]	 = "queued",
 	[MEDIA_REQUEST_STATE_COMPLETE]	 = "complete",
 	[MEDIA_REQUEST_STATE_CLEANING]	 = "cleaning",
+	[MEDIA_REQUEST_STATE_UPDATING]	 = "updating",
 };
 
 static const char *
@@ -385,7 +386,7 @@ int media_request_object_bind(struct media_request *req,
 
 	spin_lock_irqsave(&req->lock, flags);
 
-	if (WARN_ON(req->state != MEDIA_REQUEST_STATE_IDLE))
+	if (WARN_ON(req->state != MEDIA_REQUEST_STATE_UPDATING))
 		goto unlock;
 
 	list_add_tail(&obj->list, &req->objects);
diff --git a/include/media/media-request.h b/include/media/media-request.h
index e175538d3c669..42cc6e7f6e532 100644
--- a/include/media/media-request.h
+++ b/include/media/media-request.h
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
-- 
2.11.0
