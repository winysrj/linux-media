Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud7.xs4all.net ([194.109.24.24]:43613 "EHLO
        lb1-smtp-cloud7.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1732763AbeHNRIM (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 14 Aug 2018 13:08:12 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCHv18 05/35] media-request: add media_request_get_by_fd
Date: Tue, 14 Aug 2018 16:20:17 +0200
Message-Id: <20180814142047.93856-6-hverkuil@xs4all.nl>
In-Reply-To: <20180814142047.93856-1-hverkuil@xs4all.nl>
References: <20180814142047.93856-1-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Add media_request_get_by_fd() to find a request based on the file
descriptor.

The caller has to call media_request_put() for the returned
request since this function increments the refcount.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
Acked-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Reviewed-by: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
---
 include/media/media-request.h | 24 ++++++++++++++++++++++++
 1 file changed, 24 insertions(+)

diff --git a/include/media/media-request.h b/include/media/media-request.h
index 9664ebac5dc4..1c3e5d804d07 100644
--- a/include/media/media-request.h
+++ b/include/media/media-request.h
@@ -143,6 +143,24 @@ static inline void media_request_get(struct media_request *req)
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
@@ -164,6 +182,12 @@ static inline void media_request_put(struct media_request *req)
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
2.18.0
