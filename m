Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:45601 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752662AbeEUIzP (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 21 May 2018 04:55:15 -0400
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: linux-media@vger.kernel.org
Cc: hverkuil@xs4all.nl
Subject: [PATCH v14 05/36] media-request: Make request state an enum
Date: Mon, 21 May 2018 11:54:30 +0300
Message-Id: <20180521085501.16861-6-sakari.ailus@linux.intel.com>
In-Reply-To: <20180521085501.16861-1-sakari.ailus@linux.intel.com>
References: <20180521085501.16861-1-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Make the request state an enum in order to simplify serialising access to
the state as well as other fields in the request. Using the atomic would
be fine as such, but it conveys the suggestion that the atomic operations
alone will be enough for changing that state which is not true.

Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
---
 drivers/media/media-request.c | 57 ++++++++++++++++++++++---------------------
 include/media/media-request.h |  2 +-
 2 files changed, 30 insertions(+), 29 deletions(-)

diff --git a/drivers/media/media-request.c b/drivers/media/media-request.c
index c7e11e816e272..a1576cf528605 100644
--- a/drivers/media/media-request.c
+++ b/drivers/media/media-request.c
@@ -36,7 +36,8 @@ static void media_request_clean(struct media_request *req)
 {
 	struct media_request_object *obj, *obj_safe;
 
-	WARN_ON(atomic_read(&req->state) != MEDIA_REQUEST_STATE_CLEANING);
+	/* Just a sanity check. No other code path is allowed to change this. */
+	WARN_ON(req->state != MEDIA_REQUEST_STATE_CLEANING);
 
 	list_for_each_entry_safe(obj, obj_safe, &req->objects, list) {
 		media_request_object_unbind(obj);
@@ -55,7 +56,8 @@ static void media_request_release(struct kref *kref)
 
 	dev_dbg(mdev->dev, "request: release %s\n", req->debug_str);
 
-	atomic_set(&req->state, MEDIA_REQUEST_STATE_CLEANING);
+	/* No other users, no need for a spinlock */
+	req->state = MEDIA_REQUEST_STATE_CLEANING;
 
 	media_request_clean(req);
 
@@ -85,19 +87,16 @@ static unsigned int media_request_poll(struct file *filp,
 	struct media_request *req = filp->private_data;
 	unsigned long flags;
 	unsigned int ret = 0;
-	enum media_request_state state;
 
 	if (!(poll_requested_events(wait) & POLLPRI))
 		return 0;
 
 	spin_lock_irqsave(&req->lock, flags);
-	state = atomic_read(&req->state);
-
-	if (state == MEDIA_REQUEST_STATE_COMPLETE) {
+	if (req->state == MEDIA_REQUEST_STATE_COMPLETE) {
 		ret = POLLPRI;
 		goto unlock;
 	}
-	if (state != MEDIA_REQUEST_STATE_QUEUED) {
+	if (req->state != MEDIA_REQUEST_STATE_QUEUED) {
 		ret = POLLERR;
 		goto unlock;
 	}
@@ -127,10 +126,11 @@ static long media_request_ioctl_queue(struct media_request *req)
 	mutex_lock(&mdev->req_queue_mutex);
 
 	spin_lock_irqsave(&req->lock, flags);
-	state = atomic_cmpxchg(&req->state, MEDIA_REQUEST_STATE_IDLE,
-			       MEDIA_REQUEST_STATE_VALIDATING);
+	if (req->state == MEDIA_REQUEST_STATE_IDLE)
+		req->state = MEDIA_REQUEST_STATE_VALIDATING;
+	state = req->state;
 	spin_unlock_irqrestore(&req->lock, flags);
-	if (state != MEDIA_REQUEST_STATE_IDLE) {
+	if (state != MEDIA_REQUEST_STATE_VALIDATING) {
 		dev_dbg(mdev->dev,
 			"request: unable to queue %s, request in state %s\n",
 			req->debug_str, media_request_state_str(state));
@@ -155,8 +155,10 @@ static long media_request_ioctl_queue(struct media_request *req)
 	 * canceled, and that uses the req_queue_mutex which is still locked
 	 * while req_queue is called, so that's safe as well.
 	 */
-	atomic_set(&req->state,
-		   ret ? MEDIA_REQUEST_STATE_IDLE : MEDIA_REQUEST_STATE_QUEUED);
+	spin_lock_irqsave(&req->lock, flags);
+	req->state = ret ? MEDIA_REQUEST_STATE_IDLE
+			 : MEDIA_REQUEST_STATE_QUEUED;
+	spin_unlock_irqrestore(&req->lock, flags);
 
 	if (!ret)
 		mdev->ops->req_queue(req);
@@ -178,20 +180,22 @@ static long media_request_ioctl_reinit(struct media_request *req)
 	unsigned long flags;
 
 	spin_lock_irqsave(&req->lock, flags);
-	if (atomic_read(&req->state) != MEDIA_REQUEST_STATE_IDLE &&
-	    atomic_read(&req->state) != MEDIA_REQUEST_STATE_COMPLETE) {
+	if (req->state != MEDIA_REQUEST_STATE_IDLE &&
+	    req->state != MEDIA_REQUEST_STATE_COMPLETE) {
 		dev_dbg(mdev->dev,
 			"request: %s not in idle or complete state, cannot reinit\n",
 			req->debug_str);
 		spin_unlock_irqrestore(&req->lock, flags);
 		return -EBUSY;
 	}
-	atomic_set(&req->state, MEDIA_REQUEST_STATE_CLEANING);
+	req->state = MEDIA_REQUEST_STATE_CLEANING;
 	spin_unlock_irqrestore(&req->lock, flags);
 
 	media_request_clean(req);
 
-	atomic_set(&req->state, MEDIA_REQUEST_STATE_IDLE);
+	spin_lock_irqsave(&req->lock, flags);
+	req->state = MEDIA_REQUEST_STATE_IDLE;
+	spin_unlock_irqrestore(&req->lock, flags);
 
 	return 0;
 }
@@ -284,7 +288,7 @@ int media_request_alloc(struct media_device *mdev,
 
 	filp->private_data = req;
 	req->mdev = mdev;
-	atomic_set(&req->state, MEDIA_REQUEST_STATE_IDLE);
+	req->state = MEDIA_REQUEST_STATE_IDLE;
 	req->num_incomplete_objects = 0;
 	kref_init(&req->kref);
 	INIT_LIST_HEAD(&req->objects);
@@ -381,7 +385,7 @@ int media_request_object_bind(struct media_request *req,
 
 	spin_lock_irqsave(&req->lock, flags);
 
-	if (WARN_ON(atomic_read(&req->state) != MEDIA_REQUEST_STATE_IDLE))
+	if (WARN_ON(req->state != MEDIA_REQUEST_STATE_IDLE))
 		goto unlock;
 
 	list_add_tail(&obj->list, &req->objects);
@@ -397,7 +401,6 @@ EXPORT_SYMBOL_GPL(media_request_object_bind);
 void media_request_object_unbind(struct media_request_object *obj)
 {
 	struct media_request *req = obj->req;
-	enum media_request_state state;
 	unsigned long flags;
 	bool completed = false;
 
@@ -408,22 +411,20 @@ void media_request_object_unbind(struct media_request_object *obj)
 	list_del(&obj->list);
 	obj->req = NULL;
 
-	state = atomic_read(&req->state);
-
-	if (state == MEDIA_REQUEST_STATE_COMPLETE ||
-	    state == MEDIA_REQUEST_STATE_CLEANING)
+	if (req->state == MEDIA_REQUEST_STATE_COMPLETE ||
+	    req->state == MEDIA_REQUEST_STATE_CLEANING)
 		goto unlock;
 
-	if (WARN_ON(state == MEDIA_REQUEST_STATE_VALIDATING))
+	if (WARN_ON(req->state == MEDIA_REQUEST_STATE_VALIDATING))
 		goto unlock;
 
 	if (WARN_ON(!req->num_incomplete_objects))
 		goto unlock;
 
 	req->num_incomplete_objects--;
-	if (state == MEDIA_REQUEST_STATE_QUEUED &&
+	if (req->state == MEDIA_REQUEST_STATE_QUEUED &&
 	    !req->num_incomplete_objects) {
-		atomic_set(&req->state, MEDIA_REQUEST_STATE_COMPLETE);
+		req->state = MEDIA_REQUEST_STATE_COMPLETE;
 		completed = true;
 		wake_up_interruptible_all(&req->poll_wait);
 	}
@@ -448,11 +449,11 @@ void media_request_object_complete(struct media_request_object *obj)
 		goto unlock;
 	obj->completed = true;
 	if (WARN_ON(!req->num_incomplete_objects) ||
-	    WARN_ON(atomic_read(&req->state) != MEDIA_REQUEST_STATE_QUEUED))
+	    WARN_ON(req->state != MEDIA_REQUEST_STATE_QUEUED))
 		goto unlock;
 
 	if (!--req->num_incomplete_objects) {
-		atomic_set(&req->state, MEDIA_REQUEST_STATE_COMPLETE);
+		req->state = MEDIA_REQUEST_STATE_COMPLETE;
 		wake_up_interruptible_all(&req->poll_wait);
 		completed = true;
 	}
diff --git a/include/media/media-request.h b/include/media/media-request.h
index 5367b4a2f91ca..e175538d3c669 100644
--- a/include/media/media-request.h
+++ b/include/media/media-request.h
@@ -55,7 +55,7 @@ struct media_request {
 	struct media_device *mdev;
 	struct kref kref;
 	char debug_str[TASK_COMM_LEN + 11];
-	atomic_t state;
+	enum media_request_state state;
 	struct list_head objects;
 	unsigned int num_incomplete_objects;
 	struct wait_queue_head poll_wait;
-- 
2.11.0
