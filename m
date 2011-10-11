Return-path: <linux-media-owner@vger.kernel.org>
Received: from bear.ext.ti.com ([192.94.94.41]:40388 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754130Ab1JKJZK (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 11 Oct 2011 05:25:10 -0400
From: Sumit Semwal <sumit.semwal@ti.com>
To: <linux-kernel@vger.kernel.org>,
	<linux-arm-kernel@lists.infradead.org>, <linux-mm@kvack.org>,
	<linaro-mm-sig@lists.linaro.org>,
	<dri-devel@lists.freedesktop.org>, <linux-media@vger.kernel.org>
CC: <linux@arm.linux.org.uk>, <arnd@arndb.de>,
	<jesse.barker@linaro.org>, <m.szyprowski@samsung.com>,
	<rob@ti.com>, <daniel@ffwll.ch>, <t.stanislaws@samsung.com>,
	Sumit Semwal <sumit.semwal@ti.com>,
	Sumit Semwal <sumit.semwal@linaro.org>
Subject: [RFC 2/2] dma-buf: Documentation for buffer sharing framework
Date: Tue, 11 Oct 2011 14:53:53 +0530
Message-ID: <1318325033-32688-3-git-send-email-sumit.semwal@ti.com>
In-Reply-To: <1318325033-32688-1-git-send-email-sumit.semwal@ti.com>
References: <1318325033-32688-1-git-send-email-sumit.semwal@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add documentation for dma buffer sharing framework, explaining the
various operations, members and API of the dma buffer sharing
framework.

Signed-off-by: Sumit Semwal <sumit.semwal@linaro.org>
Signed-off-by: Sumit Semwal <sumit.semwal@ti.com>
---
 Documentation/dma-buf-sharing.txt |  210 +++++++++++++++++++++++++++++++++++++
 1 files changed, 210 insertions(+), 0 deletions(-)
 create mode 100644 Documentation/dma-buf-sharing.txt

diff --git a/Documentation/dma-buf-sharing.txt b/Documentation/dma-buf-sharing.txt
new file mode 100644
index 0000000..4da6644
--- /dev/null
+++ b/Documentation/dma-buf-sharing.txt
@@ -0,0 +1,210 @@
+                    DMA Buffer Sharing API Guide
+                    ~~~~~~~~~~~~~~~~~~~~~~~~~~~~
+
+                            Sumit Semwal
+                <sumit dot semwal at linaro dot org>
+                 <sumit dot semwal at ti dot com>
+
+This document serves as a guide to device-driver writers on what is the dma-buf
+buffer sharing API, how to use it for exporting and using shared buffers.
+
+Any device driver which wishes to be a part of dma buffer sharing, can do so as
+either the 'exporter' of buffers, or the 'user' of buffers.
+
+Say a driver A wants to use buffers created by driver B, then we call B as the
+exporter, and B as buffer-user.
+
+The exporter
+- implements and manages operations[1] for the buffer
+- allows other users to share the buffer by using dma_buf sharing APIs,
+- manages the details of buffer allocation,
+- decides about the actual backing storage where this allocation happens,
+- takes care of any migration of scatterlist - for all (shared) users of this
+   buffer,
+- optionally, provides mmap capability for drivers that need it.
+
+The buffer-user
+- is one of (many) sharing users of the buffer.
+- doesn't need to worry about how the buffer is allocated, or where.
+- needs a mechanism to get access to the scatterlist that makes up this buffer
+   in memory, mapped into its own address space, so it can access the same area
+   of memory.
+
+
+The dma_buf buffer sharing API usage contains the following steps:
+
+1. Exporter announces that it wishes to export a buffer
+2. Userspace gets the file descriptor associated with the exported buffer, and
+   passes it around to potential buffer-users based on use case
+3. Each buffer-user 'connects' itself to the buffer
+4. When needed, buffer-user requests access to the buffer from exporter
+5. When finished with its use, the buffer-user notifies end-of-dma to exporter
+6. when buffer-user is done using this buffer completely, it 'disconnects'
+   itself from the buffer.
+
+
+1. Exporter's announcement of buffer export
+
+   The buffer exporter announces its wish to export a buffer. In this, it
+   connects its own private buffer data, provides implementation for operations
+   that can be performed on the exported dma_buf, and flags for the file
+   associated with this buffer.
+
+   Interface:
+      struct dma_buf *dma_buf_export(void *priv, struct dma_buf_ops *ops,
+                                int flags)
+
+   If this succeeds, dma_buf_export allocates a dma_buf structure, and returns a
+   pointer to the same. It also associates an anon file with this buffer, so it
+   can be exported. On failure to allocate the dma_buf object, it returns NULL.
+
+2. Userspace gets a handle to pass around to potential buffer-users
+
+   Userspace entity requests for a file-descriptor (fd) which is a handle to the
+   anon file associated with the buffer. It can then share the fd with other
+   drivers and/or processes.
+
+   Interface:
+      int dma_buf_fd(struct dma_buf *dmabuf)
+
+   This API installs an fd for the anon file associated with this buffer;
+   returns either 'fd', or error.
+
+3. Each buffer-user 'connects' itself to the buffer
+
+   Each buffer-user now gets a reference to the buffer, using the fd passed to
+   it.
+
+   Interface:
+      struct dma_buf *dma_buf_get(int fd)
+
+   This API will return a reference to the dma_buf, and increment refcount for
+   it.
+
+   After this, the buffer-user needs to attach its device with the buffer, which
+   helps the exporter to know of device buffer constraints.
+
+   Interface:
+      struct dma_buf_attachment *dma_buf_attach(struct dma_buf *dmabuf,
+                                                struct device *dev)
+
+   This API returns reference to an attachment structure, which is then used
+   for scatterlist operations. It will optionally call the 'attach' dma_buf
+   operation, if provided by the exporter.
+
+   The dma-buf sharing framework does the book-keeping bits related to keeping
+   the list of all attachments to a buffer.
+
+Till this stage, the buffer-exporter has the option to choose not to actually
+allocate the backing storage for this buffer, but wait for the first buffer-user
+to request use of buffer for allocation.
+
+
+4. When needed, buffer-user requests access to the buffer
+
+   Whenever a buffer-user wants to use the buffer for any dma, it asks for
+   access to the buffer using dma_buf->ops->get_scatterlist operation. Atleast
+   one attach to the buffer should have happened before get_scatterlist can be
+   called.
+
+   Interface: [member of struct dma_buf_ops]
+      struct scatterlist * (*get_scatterlist)(struct dma_buf_attachment *,
+                                                enum dma_data_direction,
+                                                int* nents);
+
+   It is one of the buffer operations that must be implemented by the exporter.
+   It should return the scatterlist for this buffer, mapped into caller's address
+   space.
+
+   If this is being called for the first time, the exporter can now choose to
+   scan through the list of attachments for this buffer, collate the requirements
+   of the attached devices, and choose an appropriate backing storage for the
+   buffer.
+
+   Based on enum dma_data_direction, it might be possible to have multiple users
+   accessing at the same time (for reading, maybe), or any other kind of sharing
+   that the exporter might wish to make available to buffer-users.
+
+
+5. When finished, the buffer-user notifies end-of-dma to exporter
+
+   Once the dma for the current buffer-user is over, it signals 'end-of-dma' to
+   the exporter using the dma_buf->ops->put_scatterlist() operation.
+
+   Interface:
+      void (*put_scatterlist)(struct dma_buf_attachment *, struct scatterlist *,
+                              int nents);
+
+   put_scatterlist signifies the end-of-dma for the attachment provided.
+
+
+6. when buffer-user is done using this buffer, it 'disconnects' itself from the
+   buffer.
+
+   After the buffer-user has no more interest in using this buffer, it should
+   disconnect itself from the buffer:
+
+   - it first detaches itself from the buffer.
+
+   Interface:
+      void dma_buf_detach(struct dma_buf *dmabuf,
+                          struct dma_buf_attachment *dmabuf_attach);
+
+   This API removes the attachment from the list in dmabuf, and optionally calls
+   dma_buf->ops->detach(), if provided by exporter, for any housekeeping bits.
+
+   - Then, the buffer-user returns the buffer reference to exporter.
+
+   Interface:
+     void dma_buf_put(struct dma_buf *dmabuf);
+
+   This API then reduces the refcount for this buffer.
+
+   If, as a result of this call, the refcount becomes 0, the 'release' file
+   operation related to this fd is called. It calls the dmabuf->ops->release()
+   operation in turn, and frees the memory allocated for dmabuf when exported.
+
+NOTES:
+- Importance of attach-detach and {get,put}_scatterlist operation pairs
+   The attach-detach calls allow the exporter to figure out backing-storage
+   constraints for the currently-interested devices. This allows preferential
+   allocation, and/or migration of pages across different types of storage
+   available, if possible.
+
+   Bracketing of dma access with {get,put}_scatterlist operations is essential
+   to allow just-in-time backing of storage, and migration mid-way through a
+   use-case.
+
+- Migration of backing storage if needed
+   After
+   - atleast one get_scatterlist has happened,
+   - and the backing storage has been allocated for this buffer,
+   If another new buffer-user intends to attach itself to this buffer, it might
+   be allowed, if possible for the exporter.
+
+   In case it is allowed by the exporter:
+    if the new buffer-user has stricter 'backing-storage constraints', and the
+    exporter can handle these constraints, the exporter can just stall on the
+    get_scatterlist till all outstanding access is completed (as signalled by
+    put_scatterlist).
+    Once all ongoing access is completed, the exporter could potentially move
+    the buffer to the stricter backing-storage, and then allow further
+    {get,put}_scatterlist operations from any buffer-user from the migrated
+    backing-storage.
+
+   If the exporter cannot fulfill the backing-storage constraints of the new
+   buffer-user device as requested, dma_buf_attach() would return an error to
+   denote non-compatibility of the new buffer-sharing request with the current
+   buffer.
+
+   If the exporter chooses not to allow an attach() operation once a
+   get_scatterlist has been called, it simply returns an error.
+
+- mmap file operation
+   An mmap() file operation is provided for the fd associated with the buffer.
+   If the exporter defines an mmap operation, the mmap() fop calls this to allow
+   mmap for devices that might need it; if not, it returns an error.
+
+References:
+[1] struct dma_buf_ops in include/linux/dma-buf.h
+[2] All interfaces mentioned above defined in include/linux/dma-buf.h
-- 
1.7.4.1

