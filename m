Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga14.intel.com ([192.55.52.115]:61701 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753269AbdDMH6w (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 13 Apr 2017 03:58:52 -0400
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: linux-media@vger.kernel.org
Cc: dri-devel@lists.freedesktop.org, posciak@chromium.org,
        m.szyprowski@samsung.com, kyungmin.park@samsung.com,
        hverkuil@xs4all.nl, sumit.semwal@linaro.org, robdclark@gmail.com,
        daniel.vetter@ffwll.ch, labbott@redhat.com
Subject: [RFC v3 14/14] vb2: Improve struct vb2_mem_ops documentation; alloc and put are for MMAP
Date: Thu, 13 Apr 2017 10:57:19 +0300
Message-Id: <1492070239-21532-15-git-send-email-sakari.ailus@linux.intel.com>
In-Reply-To: <1492070239-21532-1-git-send-email-sakari.ailus@linux.intel.com>
References: <1492070239-21532-1-git-send-email-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The alloc() and put() ops are for MMAP buffers only. Document it.

Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Acked-by: Hans Verkuil <hans.verkuil@cisco.com>
Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 include/media/videobuf2-core.h | 20 ++++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

diff --git a/include/media/videobuf2-core.h b/include/media/videobuf2-core.h
index 08f1d0e..dd67ae6 100644
--- a/include/media/videobuf2-core.h
+++ b/include/media/videobuf2-core.h
@@ -46,16 +46,16 @@ struct vb2_threadio_data;
 
 /**
  * struct vb2_mem_ops - memory handling/memory allocator operations
- * @alloc:	allocate video memory and, optionally, allocator private data,
- *		return ERR_PTR() on failure or a pointer to allocator private,
- *		per-buffer data on success; the returned private structure
- *		will then be passed as @buf_priv argument to other ops in this
- *		structure. Additional gfp_flags to use when allocating the
- *		are also passed to this operation. These flags are from the
- *		gfp_flags field of vb2_queue.
- * @put:	inform the allocator that the buffer will no longer be used;
- *		usually will result in the allocator freeing the buffer (if
- *		no other users of this buffer are present); the @buf_priv
+ * @alloc:	allocate video memory for an MMAP buffer and, optionally,
+ *		allocator private data, return ERR_PTR() on failure or a pointer
+ *		to allocator private, per-buffer data on success; the returned
+ *		private structure will then be passed as @buf_priv argument to
+ *		other ops in this structure. Additional gfp_flags to use when
+ *		allocating the memory are also passed to this operation. These
+ *		flags are from the gfp_flags field of vb2_queue.
+ * @put:	inform the allocator that the MMAP buffer will no longer be
+ *		used; usually will result in the allocator freeing the buffer
+ *		(if no other users of this buffer are present); the @buf_priv
  *		argument is the allocator private per-buffer structure
  *		previously returned from the alloc callback.
  * @get_dmabuf: acquire userspace memory for a hardware operation; used for
-- 
2.7.4
