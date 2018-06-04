Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud9.xs4all.net ([194.109.24.26]:51312 "EHLO
        lb2-smtp-cloud9.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752746AbeFDLrB (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 4 Jun 2018 07:47:01 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCHv15 04/35] media-request: add media_request_get_by_fd
Date: Mon,  4 Jun 2018 13:46:17 +0200
Message-Id: <20180604114648.26159-5-hverkuil@xs4all.nl>
In-Reply-To: <20180604114648.26159-1-hverkuil@xs4all.nl>
References: <20180604114648.26159-1-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Add media_request_get_by_fd() to find a request based on the file
descriptor.

The caller has to call media_request_put() for the returned
request since this function increments the refcount.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
Acked-by: Sakari Ailus <sakari.ailus@linux.intel.com>
---
 drivers/media/media-request.c | 40 +++++++++++++++++++++++++++++++++++
 include/media/media-request.h | 24 +++++++++++++++++++++
 2 files changed, 64 insertions(+)

diff --git a/drivers/media/media-request.c b/drivers/media/media-request.c
index 09823235e4c8..b011f9911fbd 100644
--- a/drivers/media/media-request.c
+++ b/drivers/media/media-request.c
@@ -229,6 +229,46 @@ static const struct file_operations request_fops = {
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
+	/*
+	 * Note: as long as someone has an open filehandle of the request,
+	 * the request can never be released. The fget() above ensures that
+	 * even if userspace closes the request filehandle, the release()
+	 * fop won't be called, so the media_request_get() always succeeds
+	 * and there is no race condition where the request was released
+	 * before media_request_get() is called.
+	 */
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
index 8acd2627835c..d9931dddb3a8 100644
--- a/include/media/media-request.h
+++ b/include/media/media-request.h
@@ -142,6 +142,24 @@ static inline void media_request_get(struct media_request *req)
  */
 void media_request_put(struct media_request *req);
 
+/**
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
 /**
  * media_request_alloc - Allocate the media request
  *
@@ -163,6 +181,12 @@ static inline void media_request_put(struct media_request *req)
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
2.17.0
