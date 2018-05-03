Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud8.xs4all.net ([194.109.24.25]:52964 "EHLO
        lb2-smtp-cloud8.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751416AbeECOxY (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 3 May 2018 10:53:24 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCHv13 05/28] media-request: add media_request_object_find
Date: Thu,  3 May 2018 16:52:55 +0200
Message-Id: <20180503145318.128315-6-hverkuil@xs4all.nl>
In-Reply-To: <20180503145318.128315-1-hverkuil@xs4all.nl>
References: <20180503145318.128315-1-hverkuil@xs4all.nl>
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
index edc1c3af1959..c7e11e816e27 100644
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
index 997e096d7128..5367b4a2f91c 100644
--- a/include/media/media-request.h
+++ b/include/media/media-request.h
@@ -196,6 +196,22 @@ static inline void media_request_object_get(struct media_request_object *obj)
  */
 void media_request_object_put(struct media_request_object *obj);
 
+/**
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
 /**
  * media_request_object_init - Initialise a media request object
  *
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
2.17.0
