Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga14.intel.com ([192.55.52.115]:13429 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754098AbbIHKgj (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 8 Sep 2015 06:36:39 -0400
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: linux-media@vger.kernel.org
Cc: pawel@osciak.com, m.szyprowski@samsung.com,
	kyungmin.park@samsung.com, hverkuil@xs4all.nl
Subject: [RFC 06/11] vb2: Improve struct vb2_mem_ops documentation; alloc and put are for MMAP
Date: Tue,  8 Sep 2015 13:33:50 +0300
Message-Id: <1441708435-12736-7-git-send-email-sakari.ailus@linux.intel.com>
In-Reply-To: <1441708435-12736-1-git-send-email-sakari.ailus@linux.intel.com>
References: <1441708435-12736-1-git-send-email-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The alloc() and put() ops are for MMAP buffers only. Document it.

Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
---
 include/media/videobuf2-core.h | 20 ++++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

diff --git a/include/media/videobuf2-core.h b/include/media/videobuf2-core.h
index a825bd5..efc9a19 100644
--- a/include/media/videobuf2-core.h
+++ b/include/media/videobuf2-core.h
@@ -24,16 +24,16 @@ struct vb2_threadio_data;
 
 /**
  * struct vb2_mem_ops - memory handling/memory allocator operations
- * @alloc:	allocate video memory and, optionally, allocator private data,
- *		return NULL on failure or a pointer to allocator private,
- *		per-buffer data on success; the returned private structure
- *		will then be passed as buf_priv argument to other ops in this
- *		structure. Additional gfp_flags to use when allocating the
- *		are also passed to this operation. These flags are from the
- *		gfp_flags field of vb2_queue.
- * @put:	inform the allocator that the buffer will no longer be used;
- *		usually will result in the allocator freeing the buffer (if
- *		no other users of this buffer are present); the buf_priv
+ * @alloc:	allocate video memory for an MMAP buffer and, optionally,
+ *		allocator private data, return NULL on failure or a pointer
+ *		to allocator private, per-buffer data on success; the returned
+ *		private structure will then be passed as buf_priv argument to
+ *		other ops in this structure. Additional gfp_flags to use when
+ *		allocating the are also passed to this operation. These flags
+ *		are from the gfp_flags field of vb2_queue.
+ * @put:	inform the allocator that the MMAP buffer will no longer be
+ *		used; usually will result in the allocator freeing the buffer
+ *		(if no other users of this buffer are present); the buf_priv
  *		argument is the allocator private per-buffer structure
  *		previously returned from the alloc callback.
  * @get_userptr: acquire userspace memory for a hardware operation; used for
-- 
2.1.0.231.g7484e3b

