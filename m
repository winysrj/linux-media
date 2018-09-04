Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud9.xs4all.net ([194.109.24.22]:37850 "EHLO
        lb1-smtp-cloud9.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726157AbeIDMWx (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 4 Sep 2018 08:22:53 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Paul Kocialkowski <paul.kocialkowski@bootlin.com>,
        Tomasz Figa <tfiga@chromium.org>,
        Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCHv4 06/10] media-request: add media_request_(un)lock_for_access
Date: Tue,  4 Sep 2018 09:58:46 +0200
Message-Id: <20180904075850.2406-7-hverkuil@xs4all.nl>
In-Reply-To: <20180904075850.2406-1-hverkuil@xs4all.nl>
References: <20180904075850.2406-1-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Add helper functions to prevent a completed request from being
re-inited while it is being accessed.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
Reviewed-by: Tomasz Figa <tfiga@chromium.org>
---
 drivers/media/media-request.c | 10 +++++++
 include/media/media-request.h | 56 +++++++++++++++++++++++++++++++++++
 2 files changed, 66 insertions(+)

diff --git a/drivers/media/media-request.c b/drivers/media/media-request.c
index 4cee67e6657e..414197645e09 100644
--- a/drivers/media/media-request.c
+++ b/drivers/media/media-request.c
@@ -43,6 +43,7 @@ static void media_request_clean(struct media_request *req)
 	/* Just a sanity check. No other code path is allowed to change this. */
 	WARN_ON(req->state != MEDIA_REQUEST_STATE_CLEANING);
 	WARN_ON(req->updating_count);
+	WARN_ON(req->access_count);
 
 	list_for_each_entry_safe(obj, obj_safe, &req->objects, list) {
 		media_request_object_unbind(obj);
@@ -50,6 +51,7 @@ static void media_request_clean(struct media_request *req)
 	}
 
 	req->updating_count = 0;
+	req->access_count = 0;
 	WARN_ON(req->num_incomplete_objects);
 	req->num_incomplete_objects = 0;
 	wake_up_interruptible_all(&req->poll_wait);
@@ -198,6 +200,13 @@ static long media_request_ioctl_reinit(struct media_request *req)
 		spin_unlock_irqrestore(&req->lock, flags);
 		return -EBUSY;
 	}
+	if (req->access_count) {
+		dev_dbg(mdev->dev,
+			"request: %s is being accessed, cannot reinit\n",
+			req->debug_str);
+		spin_unlock_irqrestore(&req->lock, flags);
+		return -EBUSY;
+	}
 	req->state = MEDIA_REQUEST_STATE_CLEANING;
 	spin_unlock_irqrestore(&req->lock, flags);
 
@@ -313,6 +322,7 @@ int media_request_alloc(struct media_device *mdev, int *alloc_fd)
 	spin_lock_init(&req->lock);
 	init_waitqueue_head(&req->poll_wait);
 	req->updating_count = 0;
+	req->access_count = 0;
 
 	*alloc_fd = fd;
 
diff --git a/include/media/media-request.h b/include/media/media-request.h
index ac02019c1d77..d8c8db89dbde 100644
--- a/include/media/media-request.h
+++ b/include/media/media-request.h
@@ -53,6 +53,7 @@ struct media_request_object;
  * @debug_str: Prefix for debug messages (process name:fd)
  * @state: The state of the request
  * @updating_count: count the number of request updates that are in progress
+ * @access_count: count the number of request accesses that are in progress
  * @objects: List of @struct media_request_object request objects
  * @num_incomplete_objects: The number of incomplete objects in the request
  * @poll_wait: Wait queue for poll
@@ -64,6 +65,7 @@ struct media_request {
 	char debug_str[TASK_COMM_LEN + 11];
 	enum media_request_state state;
 	unsigned int updating_count;
+	unsigned int access_count;
 	struct list_head objects;
 	unsigned int num_incomplete_objects;
 	struct wait_queue_head poll_wait;
@@ -72,6 +74,50 @@ struct media_request {
 
 #ifdef CONFIG_MEDIA_CONTROLLER
 
+/**
+ * media_request_lock_for_access - Lock the request to access its objects
+ *
+ * @req: The media request
+ *
+ * Use before accessing a completed request. A reference to the request must
+ * be held during the access. This usually takes place automatically through
+ * a file handle. Use @media_request_unlock_for_access when done.
+ */
+static inline int __must_check
+media_request_lock_for_access(struct media_request *req)
+{
+	unsigned long flags;
+	int ret = -EBUSY;
+
+	spin_lock_irqsave(&req->lock, flags);
+	if (req->state == MEDIA_REQUEST_STATE_COMPLETE) {
+		req->access_count++;
+		ret = 0;
+	}
+	spin_unlock_irqrestore(&req->lock, flags);
+
+	return ret;
+}
+
+/**
+ * media_request_unlock_for_access - Unlock a request previously locked for
+ *				     access
+ *
+ * @req: The media request
+ *
+ * Unlock a request that has previously been locked using
+ * @media_request_lock_for_access.
+ */
+static inline void media_request_unlock_for_access(struct media_request *req)
+{
+	unsigned long flags;
+
+	spin_lock_irqsave(&req->lock, flags);
+	if (!WARN_ON(!req->access_count))
+		req->access_count--;
+	spin_unlock_irqrestore(&req->lock, flags);
+}
+
 /**
  * media_request_lock_for_update - Lock the request for updating its objects
  *
@@ -333,6 +379,16 @@ void media_request_object_complete(struct media_request_object *obj);
 
 #else
 
+static inline int __must_check
+media_request_lock_for_access(struct media_request *req)
+{
+	return -EINVAL;
+}
+
+static inline void media_request_unlock_for_access(struct media_request *req)
+{
+}
+
 static inline int __must_check
 media_request_lock_for_update(struct media_request *req)
 {
-- 
2.18.0
