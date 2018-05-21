Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga17.intel.com ([192.55.52.151]:21564 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751116AbeEUIzO (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 21 May 2018 04:55:14 -0400
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: linux-media@vger.kernel.org
Cc: hverkuil@xs4all.nl, Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCH v14 03/36] media-request: add media_request_get_by_fd
Date: Mon, 21 May 2018 11:54:28 +0300
Message-Id: <20180521085501.16861-4-sakari.ailus@linux.intel.com>
In-Reply-To: <20180521085501.16861-1-sakari.ailus@linux.intel.com>
References: <20180521085501.16861-1-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Add media_request_get_by_fd() to find a request based on the file
descriptor.

The caller has to call media_request_put() for the returned
request since this function increments the refcount.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/media-request.c | 32 ++++++++++++++++++++++++++++++++
 include/media/media-request.h | 24 ++++++++++++++++++++++++
 2 files changed, 56 insertions(+)

diff --git a/drivers/media/media-request.c b/drivers/media/media-request.c
index c216c4ab628b5..edc1c3af1959c 100644
--- a/drivers/media/media-request.c
+++ b/drivers/media/media-request.c
@@ -218,6 +218,38 @@ static const struct file_operations request_fops = {
 	.release = media_request_close,
 };
 
+struct media_request *
+media_request_get_by_fd(struct media_device *mdev, int request_fd)
+{
+	struct file *filp;
+	struct media_request *req;
+
+	if (!mdev || !mdev->ops ||
+	    !mdev->ops->req_validate || !mdev->ops->req_queue)
+		return ERR_PTR(-EPERM);
+
+	filp = fget(request_fd);
+	if (!filp)
+		return ERR_PTR(-ENOENT);
+
+	if (filp->f_op != &request_fops)
+		goto err_fput;
+	req = filp->private_data;
+	if (req->mdev != mdev)
+		goto err_fput;
+
+	media_request_get(req);
+	fput(filp);
+
+	return req;
+
+err_fput:
+	fput(filp);
+
+	return ERR_PTR(-ENOENT);
+}
+EXPORT_SYMBOL_GPL(media_request_get_by_fd);
+
 int media_request_alloc(struct media_device *mdev,
 			struct media_request_alloc *alloc)
 {
diff --git a/include/media/media-request.h b/include/media/media-request.h
index e39122dfd7176..997e096d7128d 100644
--- a/include/media/media-request.h
+++ b/include/media/media-request.h
@@ -87,6 +87,24 @@ static inline void media_request_get(struct media_request *req)
 void media_request_put(struct media_request *req);
 
 /**
+ * media_request_get_by_fd - Get a media request by fd
+ *
+ * @mdev: Media device this request belongs to
+ * @request_fd: The file descriptor of the request
+ *
+ * Get the request represented by @request_fd that is owned
+ * by the media device.
+ *
+ * Return a -EPERM error pointer if requests are not supported
+ * by this driver. Return -ENOENT if the request was not found.
+ * Return the pointer to the request if found: the caller will
+ * have to call @media_request_put when it finished using the
+ * request.
+ */
+struct media_request *
+media_request_get_by_fd(struct media_device *mdev, int request_fd);
+
+/**
  * media_request_alloc - Allocate the media request
  *
  * @mdev: Media device this request belongs to
@@ -107,6 +125,12 @@ static inline void media_request_put(struct media_request *req)
 {
 }
 
+static inline struct media_request *
+media_request_get_by_fd(struct media_device *mdev, int request_fd)
+{
+	return ERR_PTR(-EPERM);
+}
+
 #endif
 
 /**
-- 
2.11.0
