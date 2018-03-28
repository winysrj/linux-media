Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud7.xs4all.net ([194.109.24.24]:53500 "EHLO
        lb1-smtp-cloud7.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1753242AbeC1Nuj (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 28 Mar 2018 09:50:39 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Sakari Ailus <sakari.ailus@linux.intel.com>,
        Tomasz Figa <tfiga@google.com>,
        Alexandre Courbot <acourbot@chromium.org>,
        Gustavo Padovan <gustavo@padovan.org>,
        Hans Verkuil <hans.verkuil@cisco.com>
Subject: [RFCv9 PATCH 06/29] media-request: add media_request_find
Date: Wed, 28 Mar 2018 15:50:07 +0200
Message-Id: <20180328135030.7116-7-hverkuil@xs4all.nl>
In-Reply-To: <20180328135030.7116-1-hverkuil@xs4all.nl>
References: <20180328135030.7116-1-hverkuil@xs4all.nl>
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
 include/media/media-request.h |  9 +++++++++
 2 files changed, 56 insertions(+)

diff --git a/drivers/media/media-request.c b/drivers/media/media-request.c
index 3ee3b27fd644..d54fd353d8a6 100644
--- a/drivers/media/media-request.c
+++ b/drivers/media/media-request.c
@@ -194,6 +194,53 @@ static const struct file_operations request_fops = {
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
+		return ERR_PTR(-ENOENT);
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
+	return ERR_PTR(-EBADF);
+}
+EXPORT_SYMBOL_GPL(media_request_find);
+
 int media_request_alloc(struct media_device *mdev,
 			struct media_request_alloc *alloc)
 {
diff --git a/include/media/media-request.h b/include/media/media-request.h
index baed99eb1279..c01b05570a31 100644
--- a/include/media/media-request.h
+++ b/include/media/media-request.h
@@ -57,6 +57,9 @@ static inline void media_request_get(struct media_request *req)
 
 void media_request_put(struct media_request *req);
 
+struct media_request *
+media_request_find(struct media_device *mdev, int request_fd);
+
 int media_request_alloc(struct media_device *mdev,
 			struct media_request_alloc *alloc);
 #else
@@ -67,6 +70,12 @@ static inline void media_request_get(struct media_request *req)
 static inline void media_request_put(struct media_request *req)
 {
 }
+
+static inline struct media_request *
+media_request_find(struct media_device *mdev, int request_fd)
+{
+	return ERR_PTR(-ENOENT);
+}
 #endif
 
 struct media_request_object_ops {
-- 
2.16.1
