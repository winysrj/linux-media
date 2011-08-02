Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.w1.samsung.com ([210.118.77.13]:60672 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752920Ab1HBJwT (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 2 Aug 2011 05:52:19 -0400
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: text/plain; charset=UTF-8; format=flowed
Received: from spt2.w1.samsung.com ([210.118.77.13]) by mailout3.w1.samsung.com
 (Sun Java(tm) System Messaging Server 6.3-8.04 (built Jul 29 2009; 32bit))
 with ESMTP id <0LPA0039YOR6ZV40@mailout3.w1.samsung.com> for
 linux-media@vger.kernel.org; Tue, 02 Aug 2011 10:52:18 +0100 (BST)
Received: from [127.0.0.1] ([106.10.22.139])
 by spt2.w1.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14
 2004)) with ESMTPA id <0LPA00L17OR4UB@spt2.w1.samsung.com> for
 linux-media@vger.kernel.org; Tue, 02 Aug 2011 10:52:17 +0100 (BST)
Date: Tue, 02 Aug 2011 11:52:18 +0200
From: Marek Szyprowski <m.szyprowski@samsung.com>
Subject: [PATCH 3/6] v4l: vb2: add support for shared buffer (shrbuf)
In-reply-to: <4E37C7D7.40301@samsung.com>
To: Marek Szyprowski <m.szyprowski@samsung.com>
Cc: linaro-mm-sig@lists.linaro.org, linux-media@vger.kernel.org,
	Tomasz Stanislawski <t.stanislaws@samsung.com>,
	Kyungmin Park <kyungmin.park@samsung.com>
Message-id: <4E37C8D2.4060900@samsung.com>
References: <4E37C7D7.40301@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Tomasz Stanislawski <t.stanislaws@samsung.com>

This patch adds support for SHRBUF memory type in videbuf2. It also provides
implementation of VIDIOC_EXPOBUF ioctl within videobuf2.

Signed-off-by: Tomasz Stanislawski <t.stanislaws@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
---
  drivers/media/video/videobuf2-core.c |  176 
++++++++++++++++++++++++++++++++++
  include/media/videobuf2-core.h       |    7 ++
  2 files changed, 183 insertions(+), 0 deletions(-)

diff --git a/drivers/media/video/videobuf2-core.c 
b/drivers/media/video/videobuf2-core.c
index 6ba1461..a1363a6 100644
--- a/drivers/media/video/videobuf2-core.c
+++ b/drivers/media/video/videobuf2-core.c
@@ -107,6 +107,25 @@ static void __vb2_buf_userptr_put(struct vb2_buffer 
*vb)
  }

  /**
+ * __vb2_buf_shrbuf_put() - release memory associated with
+ * a SHRBUF buffer
+ */
+static void __vb2_buf_shrbuf_put(struct vb2_buffer *vb)
+{
+    struct vb2_queue *q = vb->vb2_queue;
+    unsigned int plane;
+
+    for (plane = 0; plane < vb->num_planes; ++plane) {
+        void *mem_priv = vb->planes[plane].mem_priv;
+
+        if (mem_priv) {
+            call_memop(q, plane, put_shrbuf, mem_priv);
+            vb->planes[plane].mem_priv = NULL;
+        }
+    }
+}
+
+/**
   * __setup_offsets() - setup unique offsets ("cookies") for every plane in
   * every buffer on the queue
   */
@@ -220,6 +239,8 @@ static void __vb2_free_mem(struct vb2_queue *q)
          /* Free MMAP buffers or release USERPTR buffers */
          if (q->memory == V4L2_MEMORY_MMAP)
              __vb2_buf_mem_free(vb);
+        if (q->memory == V4L2_MEMORY_SHRBUF)
+            __vb2_buf_shrbuf_put(vb);
          else
              __vb2_buf_userptr_put(vb);
      }
@@ -314,6 +335,8 @@ static int __fill_v4l2_buffer(struct vb2_buffer *vb, 
struct v4l2_buffer *b)
              b->m.offset = vb->v4l2_planes[0].m.mem_offset;
          else if (q->memory == V4L2_MEMORY_USERPTR)
              b->m.userptr = vb->v4l2_planes[0].m.userptr;
+        else if (q->memory == V4L2_MEMORY_SHRBUF)
+            b->m.fd = vb->v4l2_planes[0].m.fd;
      }

      /*
@@ -402,6 +425,19 @@ static int __verify_mmap_ops(struct vb2_queue *q)
  }

  /**
+ * __verify_shrbuf_ops() - verify that all memory operations required for
+ * SHRBUF queue type have been provided
+ */
+static int __verify_shrbuf_ops(struct vb2_queue *q)
+{
+    if (!(q->io_modes & VB2_SHRBUF) || !q->mem_ops->put_shrbuf ||
+        !q->mem_ops->import_shrbuf || !q->mem_ops->export_shrbuf)
+        return -EINVAL;
+
+    return 0;
+}
+
+/**
   * __buffers_in_use() - return true if any buffers on the queue are in 
use and
   * the queue cannot be freed (by the means of REQBUFS(0)) call
   */
@@ -463,6 +499,7 @@ int vb2_reqbufs(struct vb2_queue *q, struct 
v4l2_requestbuffers *req)
      }

      if (req->memory != V4L2_MEMORY_MMAP
+ && req->memory != V4L2_MEMORY_SHRBUF
&& req->memory != V4L2_MEMORY_USERPTR) {
          dprintk(1, "reqbufs: unsupported memory type\n");
          return -EINVAL;
@@ -492,6 +529,11 @@ int vb2_reqbufs(struct vb2_queue *q, struct 
v4l2_requestbuffers *req)
          return -EINVAL;
      }

+    if (req->memory == V4L2_MEMORY_SHRBUF && __verify_shrbuf_ops(q)) {
+        dprintk(1, "reqbufs: SHRBUF for current setup unsupported\n");
+        return -EINVAL;
+    }
+
      /*
       * If the same number of buffers and memory access method is requested
       * then return immediately.
@@ -702,6 +744,10 @@ static int __fill_vb2_buffer(struct vb2_buffer *vb, 
struct v4l2_buffer *b,
                      b->m.planes[plane].length;
              }
          }
+        if (b->memory == V4L2_MEMORY_SHRBUF)
+            for (plane = 0; plane < vb->num_planes; ++plane)
+                v4l2_planes[plane].m.fd =
+                    b->m.planes[plane].m.fd;
      } else {
          /*
           * Single-planar buffers do not use planes array,
@@ -716,6 +762,8 @@ static int __fill_vb2_buffer(struct vb2_buffer *vb, 
struct v4l2_buffer *b,
              v4l2_planes[0].m.userptr = b->m.userptr;
              v4l2_planes[0].length = b->length;
          }
+        if (b->memory == V4L2_MEMORY_SHRBUF)
+            v4l2_planes[0].m.fd = b->m.fd;
      }

      vb->v4l2_buf.field = b->field;
@@ -813,6 +861,79 @@ static int __qbuf_mmap(struct vb2_buffer *vb, 
struct v4l2_buffer *b)
  }

  /**
+ * __qbuf_shrbuf() - handle qbuf of a SHRBUF buffer
+ */
+static int __qbuf_shrbuf(struct vb2_buffer *vb, struct v4l2_buffer *b)
+{
+    struct v4l2_plane planes[VIDEO_MAX_PLANES];
+    struct vb2_queue *q = vb->vb2_queue;
+    void *mem_priv;
+    unsigned int plane;
+    int ret;
+
+    /* Verify and copy relevant information provided by the userspace */
+    ret = __fill_vb2_buffer(vb, b, planes);
+    if (ret)
+        return ret;
+
+    for (plane = 0; plane < vb->num_planes; ++plane) {
+        /* Skip the plane if already verified */
+        if (vb->v4l2_planes[plane].m.fd == planes[plane].m.fd)
+            continue;
+
+        dprintk(3, "qbuf: buffer descriptor for plane %d changed, "
+                "reacquiring memory\n", plane);
+
+        /* Release previously acquired memory if present */
+        if (vb->planes[plane].mem_priv)
+            call_memop(q, plane, put_shrbuf,
+                    vb->planes[plane].mem_priv);
+
+        vb->planes[plane].mem_priv = NULL;
+
+        /* Acquire each plane's memory */
+        if (q->mem_ops->import_shrbuf) {
+            mem_priv = q->mem_ops->import_shrbuf(
+                q->alloc_ctx[plane], planes[plane].m.fd);
+            if (IS_ERR(mem_priv)) {
+                dprintk(1, "qbuf: failed acquiring userspace "
+                        "memory for plane %d\n", plane);
+                ret = PTR_ERR(mem_priv);
+                goto err;
+            }
+            vb->planes[plane].mem_priv = mem_priv;
+        }
+    }
+
+    /*
+     * Call driver-specific initialization on the newly acquired buffer,
+     * if provided.
+     */
+    ret = call_qop(q, buf_init, vb);
+    if (ret) {
+        dprintk(1, "qbuf: buffer initialization failed\n");
+        goto err;
+    }
+
+    /*
+     * Now that everything is in order, copy relevant information
+     * provided by userspace.
+     */
+    for (plane = 0; plane < vb->num_planes; ++plane)
+        vb->v4l2_planes[plane] = planes[plane];
+
+    return 0;
+err:
+    /* In case of errors, release planes that were already acquired */
+    for (; plane > 0; --plane) {
+        call_memop(q, plane, put_shrbuf,
+                vb->planes[plane - 1].mem_priv);
+        vb->planes[plane - 1].mem_priv = NULL;
+    }
+
+    return ret;
+}
+/**
   * __enqueue_in_driver() - enqueue a vb2_buffer in driver for processing
   */
  static void __enqueue_in_driver(struct vb2_buffer *vb)
@@ -882,6 +1003,8 @@ int vb2_qbuf(struct vb2_queue *q, struct 
v4l2_buffer *b)
          ret = __qbuf_mmap(vb, b);
      else if (q->memory == V4L2_MEMORY_USERPTR)
          ret = __qbuf_userptr(vb, b);
+    else if (q->memory == V4L2_MEMORY_SHRBUF)
+        ret = __qbuf_shrbuf(vb, b);
      else {
          WARN(1, "Invalid queue type\n");
          return -EINVAL;
@@ -1102,6 +1225,59 @@ int vb2_dqbuf(struct vb2_queue *q, struct 
v4l2_buffer *b, bool nonblocking)
  }
  EXPORT_SYMBOL_GPL(vb2_dqbuf);

+static int __find_plane_by_offset(struct vb2_queue *q, unsigned long off,
+            unsigned int *_buffer, unsigned int *_plane);
+
+/**
+ * vb2_expbuf() - Export a buffer as a file descriptor
+ * @q:        videobuf2 queue
+ * @b:        buffer structure passed from userspace to vidioc_expbuf 
handler
+ *        in driver
+ *
+ * The return values from this function are intended to be directly 
returned
+ * from vidioc_expbuf handler in driver.
+ */
+int vb2_expbuf(struct vb2_queue *q, unsigned int offset)
+{
+    struct vb2_buffer *vb = NULL;
+    struct vb2_plane *vb_plane;
+    unsigned int buffer, plane;
+    int ret;
+
+    if (q->memory != V4L2_MEMORY_MMAP) {
+        dprintk(1, "Queue is not currently set up for mmap\n");
+        return -EINVAL;
+    }
+
+    if (~q->io_modes & VB2_SHRBUF) {
+        dprintk(1, "Queue does not support shared buffer\n");
+        return -EINVAL;
+    }
+
+    /*
+     * Find the plane corresponding to the offset passed by userspace.
+     */
+    ret = __find_plane_by_offset(q, offset, &buffer, &plane);
+    if (ret) {
+        dprintk(1, "invalid offset %d\n", offset);
+        return ret;
+    }
+
+    vb = q->bufs[buffer];
+    vb_plane = &vb->planes[plane];
+
+    ret = q->mem_ops->export_shrbuf(vb_plane->mem_priv);
+    if (ret < 0) {
+        dprintk(1, "Failed to export buffer %d, plane %d\n",
+            buffer, plane);
+        return -EINVAL;
+    }
+
+    dprintk(3, "buffer %d, plane %d exported as %d descriptor\n",
+        buffer, plane, ret);
+    return ret;
+}
+
  /**
   * vb2_streamon - start streaming
   * @q:        videobuf2 queue
diff --git a/include/media/videobuf2-core.h b/include/media/videobuf2-core.h
index f87472a..d2610e5 100644
--- a/include/media/videobuf2-core.h
+++ b/include/media/videobuf2-core.h
@@ -65,6 +65,10 @@ struct vb2_mem_ops {
                      unsigned long size, int write);
      void        (*put_userptr)(void *buf_priv);

+    void        *(*import_shrbuf)(void *alloc_ctx, int fd);
+    int        (*export_shrbuf)(void *buf_priv);
+    void        (*put_shrbuf)(void *buf_priv);
+
      void        *(*vaddr)(void *buf_priv);
      void        *(*cookie)(void *buf_priv);

@@ -82,6 +86,7 @@ struct vb2_plane {
   * enum vb2_io_modes - queue access methods
   * @VB2_MMAP:        driver supports MMAP with streaming API
   * @VB2_USERPTR:    driver supports USERPTR with streaming API
+ * @VB2_SHRBUF:        driver supports SHRBUF with streaming API
   * @VB2_READ:        driver supports read() style access
   * @VB2_WRITE:        driver supports write() style access
   */
@@ -90,6 +95,7 @@ enum vb2_io_modes {
      VB2_USERPTR    = (1 << 1),
      VB2_READ    = (1 << 2),
      VB2_WRITE    = (1 << 3),
+    VB2_SHRBUF    = (1 << 4),
  };

  /**
@@ -296,6 +302,7 @@ int vb2_queue_init(struct vb2_queue *q);
  void vb2_queue_release(struct vb2_queue *q);

  int vb2_qbuf(struct vb2_queue *q, struct v4l2_buffer *b);
+int vb2_expbuf(struct vb2_queue *q, unsigned int offset);
  int vb2_dqbuf(struct vb2_queue *q, struct v4l2_buffer *b, bool 
nonblocking);

  int vb2_streamon(struct vb2_queue *q, enum v4l2_buf_type type);
-- 
1.7.6



