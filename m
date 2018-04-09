Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud7.xs4all.net ([194.109.24.31]:45099 "EHLO
        lb3-smtp-cloud7.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751996AbeDIOUd (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 9 Apr 2018 10:20:33 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Subject: [RFCv11 PATCH 06/29] media-request: add media_request_find
Date: Mon,  9 Apr 2018 16:20:03 +0200
Message-Id: <20180409142026.19369-7-hverkuil@xs4all.nl>
In-Reply-To: <20180409142026.19369-1-hverkuil@xs4all.nl>
References: <20180409142026.19369-1-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Add media_request_find() to find a request based on the file
descriptor.

The caller has to call media_request_put() for the returned
request since this function increments the refcount.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/media-request.c | 47 +++++++++++++++++++++++++++++++++++++++++++
 include/media/media-request.h | 10 +++++++++
 2 files changed, 57 insertions(+)

diff --git a/drivers/media/media-request.c b/drivers/media/media-request.c
index 27739ff7cb09..02b620c81de5 100644
--- a/drivers/media/media-request.c
+++ b/drivers/media/media-request.c
@@ -207,6 +207,53 @@ static const struct file_operations request_fops = {
 	.release = media_request_close,
 };
 
+/**
+ * media_request_find - Find a request based on the file descriptor
+ * @mdev: The media device
+ * @request: The request file handle
+ *
+ * Find and return the request associated with the given file descriptor, or
+ * an error if no such request exists.
+ *
+ * When the function returns a request it increases its reference count. The
+ * caller is responsible for releasing the reference by calling
+ * media_request_put() on the request.
+ */
+struct media_request *
+media_request_find(struct media_device *mdev, int request_fd)
+{
+	struct file *filp;
+	struct media_request *req;
+
+	if (!mdev || !mdev->ops || !mdev->ops->req_queue)
+		return ERR_PTR(-EPERM);
+
+	filp = fget(request_fd);
+	if (!filp)
+		return ERR_PTR(-ENOENT);
+
+	if (filp->f_op != &request_fops)
+		goto err_fput;
+	req = filp->private_data;
+	media_request_get(req);
+
+	if (req->mdev != mdev)
+		goto err_kref_put;
+
+	fput(filp);
+
+	return req;
+
+err_kref_put:
+	media_request_put(req);
+
+err_fput:
+	fput(filp);
+
+	return ERR_PTR(-ENOENT);
+}
+EXPORT_SYMBOL_GPL(media_request_find);
+
 int media_request_alloc(struct media_device *mdev,
 			struct media_request_alloc *alloc)
 {
diff --git a/include/media/media-request.h b/include/media/media-request.h
index 082c3cae04ac..033697d493cd 100644
--- a/include/media/media-request.h
+++ b/include/media/media-request.h
@@ -59,6 +59,9 @@ static inline void media_request_get(struct media_request *req)
 void media_request_put(struct media_request *req);
 void media_request_cancel(struct media_request *req);
 
+struct media_request *
+media_request_find(struct media_device *mdev, int request_fd);
+
 int media_request_alloc(struct media_device *mdev,
 			struct media_request_alloc *alloc);
 #else
@@ -74,6 +77,12 @@ static inline void media_request_cancel(struct media_request *req)
 {
 }
 
+static inline struct media_request *
+media_request_find(struct media_device *mdev, int request_fd)
+{
+	return ERR_PTR(-ENOENT);
+}
+
 #endif
 
 struct media_request_object_ops {
@@ -173,6 +182,7 @@ static inline void media_request_object_unbind(struct media_request_object *obj)
 static inline void media_request_object_complete(struct media_request_object *obj)
 {
 }
+
 #endif
 
 #endif
-- 
2.16.3
