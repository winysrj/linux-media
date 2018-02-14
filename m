Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:42770 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S967713AbeBNN0r (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 14 Feb 2018 08:26:47 -0500
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: linux-media@vger.kernel.org
Cc: acourbot@chromium.org
Subject: [PATCH 1/1] media: request: Add support for tagged request-based objects
Date: Wed, 14 Feb 2018 15:26:35 +0200
Message-Id: <1518614795-7434-1-git-send-email-sakari.ailus@linux.intel.com>
In-Reply-To: <20180207014821.164536-1-acourbot@chromium.org>
References: <20180207014821.164536-1-acourbot@chromium.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Allow binding objects to requests that can be later on fetched based on
that tag.

The intent is that the objects are bound at the time data is bound to a
request and later retrieved for validation (and finally applied) when the
request is queued. A tag can be any pointer, as long as it is unique to a
request.

Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
---
Hi Alexandre,

Here's the patch. It's on top of your current set so if you remove entity
data support there may be some conflicts to resolve. It's only been
compile tested so far, but is rather simple. By providing a tag, the
caller may attach data objects to the request and they can be found later
on, by using the same tag, when the request is queued.

The drivers are still responsible for adding only objects they can support
with requests. The driver must also detach the data from the request, and
at the queue time, make sure that no objects that weren't accounted for
were added.

 drivers/media/media-request.c | 105 ++++++++++++++++++++++++++++++++++++++++++
 include/media/media-request.h |  75 ++++++++++++++++++++++++++++++
 2 files changed, 180 insertions(+)

diff --git a/drivers/media/media-request.c b/drivers/media/media-request.c
index 30a2323..c96b747 100644
--- a/drivers/media/media-request.c
+++ b/drivers/media/media-request.c
@@ -57,10 +57,115 @@ media_request_get_from_fd(int fd)
 }
 EXPORT_SYMBOL_GPL(media_request_get_from_fd);
 
+int media_request_data_attach(struct media_request *req, const void *tag,
+			      void *data,
+			      void (*release)(struct media_request *req,
+					      const void *tag, void *data))
+{
+	struct media_request_data *req_data;
+
+	req_data = kzalloc(sizeof(*req_data), GFP_KERNEL);
+	if (!req_data)
+		return -ENOMEM;
+
+	req_data->req = req;
+	req_data->tag = tag;
+	req_data->data = data;
+	req_data->release = release;
+
+	mutex_lock(&req->lock);
+	list_add(&req_data->list, &req->data_list);
+	mutex_unlock(&req->lock);
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(media_request_data_attach);
+
+struct media_request_data *__media_request_data_find(
+	struct media_request *req, const void *tag)
+{
+	struct media_request_data *req_data;
+
+	lockdep_assert_held(&req->lock);
+
+	list_for_each_entry(req_data, &req->data_list, list)
+		if (req_data->tag == tag)
+			return req_data;
+
+	return NULL;
+}
+EXPORT_SYMBOL_GPL(__media_request_data_find);
+
+void *media_request_data_find(struct media_request *req, const void *tag)
+{
+	struct media_request_data *req_data;
+	void *data;
+
+	mutex_lock(&req->lock);
+	req_data = __media_request_data_find(req, tag);
+	mutex_lock(&req->lock);
+
+	data = req_data ? req_data->data : NULL;
+
+	return data;
+}
+EXPORT_SYMBOL_GPL(media_request_data_find);
+
+void media_request_data_detach(struct media_request *req, const void *tag)
+{
+	struct media_request_data *req_data;
+
+	mutex_lock(&req->lock);
+
+	req_data = __media_request_data_find(req, tag);
+	if (WARN_ON(!req_data)) {
+		mutex_unlock(&req->lock);
+		return;
+	}
+
+	list_del(&req_data->list);
+
+	mutex_unlock(&req->lock);
+
+	if (req_data->release)
+		req_data->release(req_data->req, req_data->tag, req_data->data);
+
+	kfree(req_data);
+}
+EXPORT_SYMBOL_GPL(media_request_data_detach);
+
+static void __media_request_data_detach(struct media_request_data *req)
+{
+	struct media_request_data *req_data;
+
+	list_del(&req_data->list);
+
+	if (req_data->release)
+		req_data->release(req_data->req, req_data->tag, req_data->data);
+
+	kfree(req_data);
+}
+
+bool media_request_has_data(struct media_request *req)
+{
+	bool ret;
+
+	mutex_lock(&req->lock);
+	ret = list_empty(&req->data_list);
+	mutex_unlock(&req->lock);
+
+	return ret;
+}
+
 static void media_request_release(struct kref *kref)
 {
 	struct media_request *req =
 		container_of(kref, typeof(*req), kref);
+	struct media_request_data *req_data, *req_data_safe;
+
+	/* Last reference; no need to acquire the lock here. */
+	list_for_each_entry_safe(req_data, req_data_safe, &req->data_list, list)
+		__media_request_data_detach(req_data);
 
 	req->mgr->ops->req_free(req);
 }
diff --git a/include/media/media-request.h b/include/media/media-request.h
index 817df13..64b945d 100644
--- a/include/media/media-request.h
+++ b/include/media/media-request.h
@@ -36,12 +36,23 @@ enum media_request_state {
 	MEDIA_REQUEST_STATE_DELETED,
 };
 
+struct media_request_data {
+	struct media_request *req;
+	const void *tag;
+	struct list_head list;
+	void *data;
+	void (*release)(struct media_request *req,
+			const void *tag, void *data);
+};
+
 /**
  * struct media_request - Media request base structure
  * @id:		request id, used internally for debugging
  * @mgr:	manager this request belongs to
  * @kref:	reference count
  * @list:	list entry in the media device requests list
+ * @data_list:	list of data entries related to the request;
+ *		struct media_request_data.list
  * @lock:	protects internal state against concurrent accesses
  * @state:	current state of the request
  * @data:	per-entity data list
@@ -55,6 +66,7 @@ struct media_request {
 	struct media_request_mgr *mgr;
 	struct kref kref;
 	struct list_head list;
+	struct list_head data_list;
 
 	struct mutex lock;
 	enum media_request_state state;
@@ -89,6 +101,69 @@ struct media_request *media_request_get(struct media_request *req);
 struct media_request *media_request_get_from_fd(int fd);
 
 /**
+ * media_request_data_attach - Attach data related to a tag in a request
+ *
+ * Attach data to a request. The data can be later on retrieved based on the
+ * tag. The data remains attached until it is detached using
+ * @media_request_data_detach.
+ *
+ * The lifetime of the attachment is the same than that of the request itself.
+ *
+ * @req:	request to which data is to be attached
+ * @tag:	the tag to the data, based on which it can be found later;
+ *		unique to the request
+ * @data:	pointer to the data
+ * @release:	release callback for data, may be NULL
+ */
+int media_request_data_attach(struct media_request *req, const void *tag,
+			      void *data,
+			      void (*release)(struct media_request *req,
+					      const void *tag, void *data));
+
+/**
+ * __media_request_data_find - Find data related to a media request based on a
+ *			       tag
+ *
+ * Retrieve data related to a media request based on a tag.
+ *
+ * Compared to @media_request_data_find, this function returns the underlying
+ * media request data object as well as requires the caller to acquire the
+ * request lock.
+ */
+struct media_request_data *__media_request_data_find(
+	struct media_request *req, const void *tag);
+
+/**
+ * media_request_data_find - Find data related to a media request based on a
+ *			     tag
+ *
+ * Retrieve data related to a media request based on a tag.
+ *
+ * Compared to @__media_request_data_find, this function returns the data only
+ * and performs any locking by itself.
+ */
+void *media_request_data_find(struct media_request *req, const void *tag);
+
+/**
+ * media_request_data_detach - Detach an object from the media request
+ *
+ * Explicitly detach an object from the media request.
+ *
+ * @req:	request to remove the object from
+ * @tag:	tag based on which the object is retrieved for detaching
+ */
+void media_request_data_detach(struct media_request *req, const void *tag);
+
+/**
+ * media_request_has_data - Does the request have object bound to it?
+ *
+ * Return true if the request has objects bound to it, otherwise false.
+ *
+ * @req:	request which is queried for attached objects
+ */
+bool media_request_has_data(struct media_request *req);
+
+/**
  * media_request_put() - decrement the reference counter of a request
  *
  * Mirror function of media_request_get() and media_request_get_from_fd(). Will
-- 
2.7.4
