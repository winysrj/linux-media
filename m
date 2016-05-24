Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:36539 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753016AbcEXQu7 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 24 May 2016 12:50:59 -0400
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: linux-media@vger.kernel.org
Cc: laurent.pinchart@ideasonboard.com, hverkuil@xs4all.nl,
	mchehab@osg.samsung.com,
	Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
Subject: [RFC v2 06/21] media: Add per-entity request data support
Date: Tue, 24 May 2016 19:47:16 +0300
Message-Id: <1464108451-28142-7-git-send-email-sakari.ailus@linux.intel.com>
In-Reply-To: <1464108451-28142-1-git-send-email-sakari.ailus@linux.intel.com>
References: <1464108451-28142-1-git-send-email-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>

Allow subsystems to associate data with entities in each request. This
will be used by the V4L2 subdev core to store pad formats in requests.

Signed-off-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>

---

Changes since v0:

- Dereference requests without holding the list lock
- Remove requests from global list when closing the fh
---
 drivers/media/media-device.c | 71 ++++++++++++++++++++++++++++++++++++++++++++
 include/media/media-device.h |  7 +++++
 include/media/media-entity.h | 12 ++++++++
 3 files changed, 90 insertions(+)

diff --git a/drivers/media/media-device.c b/drivers/media/media-device.c
index 16fcc20..462823f 100644
--- a/drivers/media/media-device.c
+++ b/drivers/media/media-device.c
@@ -109,12 +109,18 @@ EXPORT_SYMBOL_GPL(media_device_request_get);
 
 static void media_device_request_release(struct kref *kref)
 {
+	struct media_entity_request_data *data, *next;
 	struct media_device_request *req =
 		container_of(kref, struct media_device_request, kref);
 	struct media_device *mdev = req->mdev;
 
 	dev_dbg(mdev->dev, "release request %u\n", req->id);
 
+	list_for_each_entry_safe(data, next, &req->data, list) {
+		list_del(&data->list);
+		data->release(data);
+	}
+
 	ida_simple_remove(&mdev->req_ids, req->id);
 
 	mdev->ops->req_free(mdev, req);
@@ -126,6 +132,70 @@ void media_device_request_put(struct media_device_request *req)
 }
 EXPORT_SYMBOL_GPL(media_device_request_put);
 
+/**
+ * media_device_request_get_entity_data - Get per-entity data
+ * @req: The request
+ * @entity: The entity
+ *
+ * Search and return per-entity data (as a struct media_entity_request_data
+ * instance) associated with the given entity for the request, as previously
+ * registered by a call to media_device_request_set_entity_data().
+ *
+ * The caller is expected to hold a reference to the request. Per-entity data is
+ * not reference counted, the returned pointer will be valid only as long as the
+ * reference to the request is held.
+ *
+ * Return the data instance pointer or NULL if no data could be found.
+ */
+struct media_entity_request_data *
+media_device_request_get_entity_data(struct media_device_request *req,
+				     struct media_entity *entity)
+{
+	struct media_entity_request_data *data;
+	unsigned long flags;
+
+	spin_lock_irqsave(&req->mdev->req_lock, flags);
+
+	list_for_each_entry(data, &req->data, list) {
+		if (data->entity == entity)
+			goto done;
+	}
+
+	data = NULL;
+
+done:
+	spin_unlock_irqrestore(&req->mdev->req_lock, flags);
+	return data;
+}
+EXPORT_SYMBOL_GPL(media_device_request_get_entity_data);
+
+/**
+ * media_device_request_set_entity_data - Set per-entity data
+ * @req: The request
+ * @entity: The entity
+ * @data: The data
+ *
+ * Record the given per-entity data as being associated with the entity for the
+ * request.
+ *
+ * Only one per-entity data instance can be associated with a request. The
+ * caller is responsible for enforcing this requirement.
+ *
+ * Ownership of the per-entity data is transferred to the request when calling
+ * this function. The data will be freed automatically when the last reference
+ * to the request is released.
+ */
+void media_device_request_set_entity_data(struct media_device_request *req,
+	struct media_entity *entity, struct media_entity_request_data *data)
+{
+	unsigned long flags;
+
+	spin_lock_irqsave(&req->mdev->req_lock, flags);
+	list_add_tail(&data->list, &req->data);
+	spin_unlock_irqrestore(&req->mdev->req_lock, flags);
+}
+EXPORT_SYMBOL_GPL(media_device_request_set_entity_data);
+
 static int media_device_request_alloc(struct media_device *mdev,
 				      struct file *filp,
 				      struct media_request_cmd *cmd)
@@ -152,6 +222,7 @@ static int media_device_request_alloc(struct media_device *mdev,
 	req->filp = filp;
 	req->state = MEDIA_DEVICE_REQUEST_STATE_IDLE;
 	kref_init(&req->kref);
+	INIT_LIST_HEAD(&req->data);
 
 	spin_lock_irqsave(&mdev->req_lock, flags);
 	list_add_tail(&req->list, &mdev->requests);
diff --git a/include/media/media-device.h b/include/media/media-device.h
index acb7181..d4e2929 100644
--- a/include/media/media-device.h
+++ b/include/media/media-device.h
@@ -281,6 +281,7 @@ enum media_device_request_state {
  * @fh_list: List entry in the media file handle requests list
  * @state: The state of the request, MEDIA_DEVICE_REQUEST_STATE_*,
  *	   access to state serialised by mdev->req_lock
+ * @data: Per-entity data list
  */
 struct media_device_request {
 	u32 id;
@@ -290,6 +291,7 @@ struct media_device_request {
 	struct list_head list;
 	struct list_head fh_list;
 	enum media_device_request_state state;
+	struct list_head data;
 };
 
 /**
@@ -768,5 +770,10 @@ void media_device_request_get(struct media_device_request *req);
 void media_device_request_put(struct media_device_request *req);
 void media_device_request_complete(struct media_device *mdev,
 				   struct media_device_request *req);
+struct media_entity_request_data *
+media_device_request_get_entity_data(struct media_device_request *req,
+				     struct media_entity *entity);
+void media_device_request_set_entity_data(struct media_device_request *req,
+	struct media_entity *entity, struct media_entity_request_data *data);
 
 #endif
diff --git a/include/media/media-entity.h b/include/media/media-entity.h
index cbb266f..cdc2e6c 100644
--- a/include/media/media-entity.h
+++ b/include/media/media-entity.h
@@ -557,6 +557,18 @@ void media_gobj_create(struct media_device *mdev,
  */
 void media_gobj_destroy(struct media_gobj *gobj);
 
+/*
+ * struct media_entity_request_data - Per-entity request data
+ * @entity: Entity this data belongs to
+ * @release: Release operation to free the data
+ * @list: List entry in the media_device_request data list
+ */
+struct media_entity_request_data {
+	struct media_entity *entity;
+	void (*release)(struct media_entity_request_data *data);
+	struct list_head list;
+};
+
 /**
  * media_entity_pads_init() - Initialize the entity pads
  *
-- 
1.9.1

