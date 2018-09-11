Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx3-rdu2.redhat.com ([66.187.233.73]:57958 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727797AbeIKSlo (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 11 Sep 2018 14:41:44 -0400
From: Gerd Hoffmann <kraxel@redhat.com>
To: dri-devel@lists.freedesktop.org
Cc: laurent.pinchart@ideasonboard.com, daniel@ffwll.ch,
        Gerd Hoffmann <kraxel@redhat.com>,
        Sumit Semwal <sumit.semwal@linaro.org>,
        Jonathan Corbet <corbet@lwn.net>,
        linux-media@vger.kernel.org (open list:DMA BUFFER SHARING FRAMEWORK),
        linaro-mm-sig@lists.linaro.org (moderated list:DMA BUFFER SHARING
        FRAMEWORK), linux-doc@vger.kernel.org (open list:DOCUMENTATION),
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH v2 13/13] udmabuf: add documentation
Date: Tue, 11 Sep 2018 15:42:16 +0200
Message-Id: <20180911134216.9760-14-kraxel@redhat.com>
In-Reply-To: <20180911134216.9760-1-kraxel@redhat.com>
References: <20180911134216.9760-1-kraxel@redhat.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Gerd Hoffmann <kraxel@redhat.com>
---
 include/uapi/linux/udmabuf.h         | 50 +++++++++++++++++++++++++++++++++---
 Documentation/driver-api/dma-buf.rst |  8 ++++++
 2 files changed, 55 insertions(+), 3 deletions(-)

diff --git a/include/uapi/linux/udmabuf.h b/include/uapi/linux/udmabuf.h
index 46b6532ed8..f30b37cb5c 100644
--- a/include/uapi/linux/udmabuf.h
+++ b/include/uapi/linux/udmabuf.h
@@ -5,8 +5,38 @@
 #include <linux/types.h>
 #include <linux/ioctl.h>
 
+/**
+ * DOC: udmabuf
+ *
+ * udmabuf is a device driver which allows userspace create dmabufs.
+ * The memory used for these dmabufs must be backed by memfd.  The
+ * memfd must have F_SEAL_SHRINK and it must not have F_SEAL_WRITE.
+ *
+ * The driver has two ioctls, one to create a dmabuf from a single
+ * memory block and one to create a dmabuf from a list of memory
+ * blocks.
+ *
+ * UDMABUF_CREATE - _IOW('u', 0x42, udmabuf_create)
+ *
+ * UDMABUF_CREATE_LIST - _IOW('u', 0x43, udmabuf_create_list)
+ */
+
+#define UDMABUF_CREATE       _IOW('u', 0x42, struct udmabuf_create)
+#define UDMABUF_CREATE_LIST  _IOW('u', 0x43, struct udmabuf_create_list)
+
 #define UDMABUF_FLAGS_CLOEXEC	0x01
 
+/**
+ * struct udmabuf_create - create a dmabuf from a single memory block.
+ *
+ * @memfd: The file handle.
+ * @offset: Start of the buffer (from memfd start).
+ * Must be page aligned.
+ * @size: Size of the buffer.  Must be rounded to page size.
+ *
+ * flags:
+ * UDMABUF_FLAGS_CLOEXEC: set CLOEXEC flag for the dmabuf.
+ */
 struct udmabuf_create {
 	__u32 memfd;
 	__u32 flags;
@@ -14,6 +44,14 @@ struct udmabuf_create {
 	__u64 size;
 };
 
+/**
+ * struct udmabuf_create_item - one memory block list item.
+ *
+ * @memfd: The file handle.
+ * @offset: Start of the buffer (from memfd start).
+ * Must be page aligned.
+ * @size: Size of the buffer.  Must be rounded to page size.
+ */
 struct udmabuf_create_item {
 	__u32 memfd;
 	__u32 __pad;
@@ -21,13 +59,19 @@ struct udmabuf_create_item {
 	__u64 size;
 };
 
+/**
+ * struct udmabuf_create_list - create a dmabuf from a memory block list.
+ *
+ * @count: The number of list elements.
+ * @list: The memory block list
+ *
+ * flags:
+ * UDMABUF_FLAGS_CLOEXEC: set CLOEXEC flag for the dmabuf.
+ */
 struct udmabuf_create_list {
 	__u32 flags;
 	__u32 count;
 	struct udmabuf_create_item list[];
 };
 
-#define UDMABUF_CREATE       _IOW('u', 0x42, struct udmabuf_create)
-#define UDMABUF_CREATE_LIST  _IOW('u', 0x43, struct udmabuf_create_list)
-
 #endif /* _UAPI_LINUX_UDMABUF_H */
diff --git a/Documentation/driver-api/dma-buf.rst b/Documentation/driver-api/dma-buf.rst
index b541e97c7a..1f62c30a14 100644
--- a/Documentation/driver-api/dma-buf.rst
+++ b/Documentation/driver-api/dma-buf.rst
@@ -166,3 +166,11 @@ DMA Fence uABI/Sync File
 .. kernel-doc:: include/linux/sync_file.h
    :internal:
 
+Userspace DMA Buffer driver
+~~~~~~~~~~~~~~~~~~~~~~~~~~~
+
+.. kernel-doc:: include/uapi/linux/udmabuf.h
+   :doc: udmabuf
+
+.. kernel-doc:: include/uapi/linux/udmabuf.h
+   :internal:
-- 
2.9.3
