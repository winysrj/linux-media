Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:44651 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755111AbbLQIlE (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 17 Dec 2015 03:41:04 -0500
From: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: linux-sh@vger.kernel.org
Subject: [PATCH/RFC 24/48] media: Add per-entity request data support
Date: Thu, 17 Dec 2015 10:40:02 +0200
Message-Id: <1450341626-6695-25-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
In-Reply-To: <1450341626-6695-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
References: <1450341626-6695-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Allow subsystems to associate data with entities in each request. This
will be used by the V4L2 subdev core to store pad formats in requests.

Signed-off-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>

---

Changes since v0:

- Dereference requests without holding the list lock
- Remove requests from global list when closing the fh
---
 drivers/media/media-device.c | 82 ++++++++++++++++++++++++++++++++++++++++++--
 include/media/media-device.h |  7 ++++
 include/media/media-entity.h | 12 +++++++
 3 files changed, 99 insertions(+), 2 deletions(-)

diff --git a/drivers/media/media-device.c b/drivers/media/media-device.c
index 37da26806ed8..7fc94bf23eff 100644
--- a/drivers/media/media-device.c
+++ b/drivers/media/media-device.c
@@ -86,10 +86,16 @@ EXPORT_SYMBOL_GPL(media_device_request_get);
 
 static void media_device_request_release(struct kref *kref)
 {
+	struct media_entity_request_data *data, *next;
 	struct media_device_request *req =
 		container_of(kref, struct media_device_request, kref);
 	struct media_device *mdev = req->mdev;
 
+	list_for_each_entry_safe(data, next, &req->data, list) {
+		list_del(&data->list);
+		data->release(data);
+	}
+
 	mdev->ops->req_free(mdev, req);
 }
 
@@ -99,6 +105,70 @@ void media_device_request_put(struct media_device_request *req)
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
 				      struct media_device_fh *fh,
 				      struct media_request_cmd *cmd)
@@ -112,6 +182,7 @@ static int media_device_request_alloc(struct media_device *mdev,
 
 	req->mdev = mdev;
 	kref_init(&req->kref);
+	INIT_LIST_HEAD(&req->data);
 
 	spin_lock_irqsave(&mdev->req_lock, flags);
 	req->id = ++mdev->req_id;
@@ -130,6 +201,7 @@ static void media_device_request_delete(struct media_device *mdev,
 
 	spin_lock_irqsave(&mdev->req_lock, flags);
 	list_del(&req->list);
+	list_del(&req->fh_list);
 	spin_unlock_irqrestore(&mdev->req_lock, flags);
 
 	media_device_request_put(req);
@@ -218,12 +290,18 @@ static int media_device_close(struct file *filp)
 {
 	struct media_device_fh *fh = media_device_fh(filp);
 	struct media_device *mdev = to_media_device(fh->fh.devnode);
-	struct media_device_request *req, *next;
 
 	spin_lock_irq(&mdev->req_lock);
-	list_for_each_entry_safe(req, next, &fh->requests, fh_list) {
+	while (!list_empty(&fh->requests)) {
+		struct media_device_request *req;
+
+		req = list_first_entry(&fh->requests, typeof(*req), fh_list);
+		list_del(&req->list);
 		list_del(&req->fh_list);
+
+		spin_unlock_irq(&mdev->req_lock);
 		media_device_request_put(req);
+		spin_lock_irq(&mdev->req_lock);
 	}
 	spin_unlock_irq(&mdev->req_lock);
 
diff --git a/include/media/media-device.h b/include/media/media-device.h
index bc003bedf087..0a374328a135 100644
--- a/include/media/media-device.h
+++ b/include/media/media-device.h
@@ -41,6 +41,7 @@ struct media_device;
  * @kref: Reference count
  * @list: List entry in the media device requests list
  * @fh_list: List entry in the media file handle requests list
+ * @data: Per-entity data list
  */
 struct media_device_request {
 	u32 id;
@@ -48,6 +49,7 @@ struct media_device_request {
 	struct kref kref;
 	struct list_head list;
 	struct list_head fh_list;
+	struct list_head data;
 };
 
 /**
@@ -148,5 +150,10 @@ struct media_device_request *
 media_device_request_find(struct media_device *mdev, u16 reqid);
 void media_device_request_get(struct media_device_request *req);
 void media_device_request_put(struct media_device_request *req);
+struct media_entity_request_data *
+media_device_request_get_entity_data(struct media_device_request *req,
+				     struct media_entity *entity);
+void media_device_request_set_entity_data(struct media_device_request *req,
+	struct media_entity *entity, struct media_entity_request_data *data);
 
 #endif
diff --git a/include/media/media-entity.h b/include/media/media-entity.h
index 197f93799753..36e2129e61c6 100644
--- a/include/media/media-entity.h
+++ b/include/media/media-entity.h
@@ -133,6 +133,18 @@ struct media_entity_graph {
 	int top;
 };
 
+/**
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
 int media_entity_init(struct media_entity *entity, u16 num_pads,
 		struct media_pad *pads, u16 extra_links);
 void media_entity_cleanup(struct media_entity *entity);
-- 
2.4.10

