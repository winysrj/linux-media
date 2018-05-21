Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga05.intel.com ([192.55.52.43]:53660 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752668AbeEUIzQ (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 21 May 2018 04:55:16 -0400
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: linux-media@vger.kernel.org
Cc: hverkuil@xs4all.nl, Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCH v14 04/36] media-request: add media_request_object_find
Date: Mon, 21 May 2018 11:54:29 +0300
Message-Id: <20180521085501.16861-5-sakari.ailus@linux.intel.com>
In-Reply-To: <20180521085501.16861-1-sakari.ailus@linux.intel.com>
References: <20180521085501.16861-1-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Add media_request_object_find to find a request object inside a
request based on ops and/or priv values.

Objects of the same type (vb2 buffer, control handler) will have
the same ops value. And objects that refer to the same 'parent'
object (e.g. the v4l2_ctrl_handler that has the current driver
state) will have the same priv value.

The caller has to call media_request_object_put() for the returned
object since this function increments the refcount.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/media-request.c | 25 +++++++++++++++++++++++++
 include/media/media-request.h | 24 ++++++++++++++++++++++++
 2 files changed, 49 insertions(+)

diff --git a/drivers/media/media-request.c b/drivers/media/media-request.c
index edc1c3af1959c..c7e11e816e272 100644
--- a/drivers/media/media-request.c
+++ b/drivers/media/media-request.c
@@ -322,6 +322,31 @@ static void media_request_object_release(struct kref *kref)
 	obj->ops->release(obj);
 }
 
+struct media_request_object *
+media_request_object_find(struct media_request *req,
+			  const struct media_request_object_ops *ops,
+			  void *priv)
+{
+	struct media_request_object *obj;
+	struct media_request_object *found = NULL;
+	unsigned long flags;
+
+	if (WARN_ON(!ops || !priv))
+		return NULL;
+
+	spin_lock_irqsave(&req->lock, flags);
+	list_for_each_entry(obj, &req->objects, list) {
+		if (obj->ops == ops && obj->priv == priv) {
+			media_request_object_get(obj);
+			found = obj;
+			break;
+		}
+	}
+	spin_unlock_irqrestore(&req->lock, flags);
+	return found;
+}
+EXPORT_SYMBOL_GPL(media_request_object_find);
+
 void media_request_object_put(struct media_request_object *obj)
 {
 	kref_put(&obj->kref, media_request_object_release);
diff --git a/include/media/media-request.h b/include/media/media-request.h
index 997e096d7128d..5367b4a2f91ca 100644
--- a/include/media/media-request.h
+++ b/include/media/media-request.h
@@ -197,6 +197,22 @@ static inline void media_request_object_get(struct media_request_object *obj)
 void media_request_object_put(struct media_request_object *obj);
 
 /**
+ * media_request_object_find - Find an object in a request
+ *
+ * @ops: Find an object with this ops value
+ * @priv: Find an object with this priv value
+ *
+ * Both @ops and @priv must be non-NULL.
+ *
+ * Returns NULL if not found or the object pointer. The caller must
+ * call media_request_object_put() once it finished using the object.
+ */
+struct media_request_object *
+media_request_object_find(struct media_request *req,
+			  const struct media_request_object_ops *ops,
+			  void *priv);
+
+/**
  * media_request_object_init - Initialise a media request object
  *
  * Initialise a media request object. The object will be released using the
@@ -241,6 +257,14 @@ static inline void media_request_object_put(struct media_request_object *obj)
 {
 }
 
+static inline struct media_request_object *
+media_request_object_find(struct media_request *req,
+			  const struct media_request_object_ops *ops,
+			  void *priv)
+{
+	return NULL;
+}
+
 static inline void media_request_object_init(struct media_request_object *obj)
 {
 	obj->ops = NULL;
-- 
2.11.0
