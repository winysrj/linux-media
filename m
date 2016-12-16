Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:50169 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1757064AbcLPBYA (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 15 Dec 2016 20:24:00 -0500
From: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: dri-devel@lists.freedesktop.org,
        Pawel Osciak <posciak@chromium.org>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Sumit Semwal <sumit.semwal@linaro.org>,
        Rob Clark <robdclark@gmail.com>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Laura Abbott <labbott@redhat.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>
Subject: [RFC v2 06/11] vb2: Improve struct vb2_mem_ops documentation; alloc and put are for MMAP
Date: Fri, 16 Dec 2016 03:24:20 +0200
Message-Id: <20161216012425.11179-7-laurent.pinchart+renesas@ideasonboard.com>
In-Reply-To: <20161216012425.11179-1-laurent.pinchart+renesas@ideasonboard.com>
References: <20161216012425.11179-1-laurent.pinchart+renesas@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Sakari Ailus <sakari.ailus@linux.intel.com>

The alloc() and put() ops are for MMAP buffers only. Document it.

Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Acked-by: Hans Verkuil <hans.verkuil@cisco.com>
Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
Changes since v1:

- Fixed typo in documentation
---
 include/media/videobuf2-core.h | 20 ++++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

diff --git a/include/media/videobuf2-core.h b/include/media/videobuf2-core.h
index bfad0588bb2b..15084b90e2d5 100644
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
Regards,

Laurent Pinchart

