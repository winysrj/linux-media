Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([92.198.50.35]:43362 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751382Ab3EUILp (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 21 May 2013 04:11:45 -0400
From: Philipp Zabel <p.zabel@pengutronix.de>
To: linux-media@vger.kernel.org
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Pawel Osciak <pawel@osciak.com>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	Tomasz Stanislawski <t.stanislaws@samsung.com>,
	Kyungmin Park <kyungmin.park@samsung.com>,
	Philipp Zabel <p.zabel@pengutronix.de>
Subject: [PATCH] [media] v4l: vb2-dma-contig: add support for file access mode flags for DMABUF exporting
Date: Tue, 21 May 2013 10:11:35 +0200
Message-Id: <1369123895-10574-1-git-send-email-p.zabel@pengutronix.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Currently it is not possible for userspace to map a DMABUF exported buffer
with write permissions. This patch allows to also pass O_RDONLY/O_RDWR when
exporting the buffer, so that userspace may map it with write permissions.

Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
---
 Documentation/DocBook/media/v4l/vidioc-expbuf.xml | 8 +++++---
 drivers/media/v4l2-core/videobuf2-core.c          | 8 ++++----
 drivers/media/v4l2-core/videobuf2-dma-contig.c    | 4 ++--
 include/media/videobuf2-core.h                    | 2 +-
 4 files changed, 12 insertions(+), 10 deletions(-)

diff --git a/Documentation/DocBook/media/v4l/vidioc-expbuf.xml b/Documentation/DocBook/media/v4l/vidioc-expbuf.xml
index e287c8f..4165e7b 100644
--- a/Documentation/DocBook/media/v4l/vidioc-expbuf.xml
+++ b/Documentation/DocBook/media/v4l/vidioc-expbuf.xml
@@ -73,7 +73,8 @@ range from zero to the maximal number of valid planes for the currently active
 format. For the single-planar API, applications must set <structfield> plane
 </structfield> to zero.  Additional flags may be posted in the <structfield>
 flags </structfield> field.  Refer to a manual for open() for details.
-Currently only O_CLOEXEC is supported.  All other fields must be set to zero.
+Currently only O_CLOEXEC, O_RDONLY, O_WRONLY, and O_RDWR are supported.  All
+other fields must be set to zero.
 In the case of multi-planar API, every plane is exported separately using
 multiple <constant> VIDIOC_EXPBUF </constant> calls. </para>
 
@@ -170,8 +171,9 @@ multi-planar API. Otherwise this value must be set to zero. </entry>
 	    <entry>__u32</entry>
 	    <entry><structfield>flags</structfield></entry>
 	    <entry>Flags for the newly created file, currently only <constant>
-O_CLOEXEC </constant> is supported, refer to the manual of open() for more
-details.</entry>
+O_CLOEXEC </constant>, <constant>O_RDONLY</constant>, <constant>O_WRONLY
+</constant>, and <constant>O_RDWR</constant> are supported, refer to the manual
+of open() for more details.</entry>
 	  </row>
 	  <row>
 	    <entry>__s32</entry>
diff --git a/drivers/media/v4l2-core/videobuf2-core.c b/drivers/media/v4l2-core/videobuf2-core.c
index 7d833ee..5f7ae44 100644
--- a/drivers/media/v4l2-core/videobuf2-core.c
+++ b/drivers/media/v4l2-core/videobuf2-core.c
@@ -1785,8 +1785,8 @@ int vb2_expbuf(struct vb2_queue *q, struct v4l2_exportbuffer *eb)
 		return -EINVAL;
 	}
 
-	if (eb->flags & ~O_CLOEXEC) {
-		dprintk(1, "Queue does support only O_CLOEXEC flag\n");
+	if (eb->flags & ~(O_CLOEXEC | O_ACCMODE)) {
+		dprintk(1, "Queue does support only O_CLOEXEC and access mode flags\n");
 		return -EINVAL;
 	}
 
@@ -1809,14 +1809,14 @@ int vb2_expbuf(struct vb2_queue *q, struct v4l2_exportbuffer *eb)
 
 	vb_plane = &vb->planes[eb->plane];
 
-	dbuf = call_memop(q, get_dmabuf, vb_plane->mem_priv);
+	dbuf = call_memop(q, get_dmabuf, vb_plane->mem_priv, eb->flags & O_ACCMODE);
 	if (IS_ERR_OR_NULL(dbuf)) {
 		dprintk(1, "Failed to export buffer %d, plane %d\n",
 			eb->index, eb->plane);
 		return -EINVAL;
 	}
 
-	ret = dma_buf_fd(dbuf, eb->flags);
+	ret = dma_buf_fd(dbuf, eb->flags & ~O_ACCMODE);
 	if (ret < 0) {
 		dprintk(3, "buffer %d, plane %d failed to export (%d)\n",
 			eb->index, eb->plane, ret);
diff --git a/drivers/media/v4l2-core/videobuf2-dma-contig.c b/drivers/media/v4l2-core/videobuf2-dma-contig.c
index fd56f25..e443df5 100644
--- a/drivers/media/v4l2-core/videobuf2-dma-contig.c
+++ b/drivers/media/v4l2-core/videobuf2-dma-contig.c
@@ -393,7 +393,7 @@ static struct sg_table *vb2_dc_get_base_sgt(struct vb2_dc_buf *buf)
 	return sgt;
 }
 
-static struct dma_buf *vb2_dc_get_dmabuf(void *buf_priv)
+static struct dma_buf *vb2_dc_get_dmabuf(void *buf_priv, unsigned long flags)
 {
 	struct vb2_dc_buf *buf = buf_priv;
 	struct dma_buf *dbuf;
@@ -404,7 +404,7 @@ static struct dma_buf *vb2_dc_get_dmabuf(void *buf_priv)
 	if (WARN_ON(!buf->sgt_base))
 		return NULL;
 
-	dbuf = dma_buf_export(buf, &vb2_dc_dmabuf_ops, buf->size, 0);
+	dbuf = dma_buf_export(buf, &vb2_dc_dmabuf_ops, buf->size, flags);
 	if (IS_ERR(dbuf))
 		return NULL;
 
diff --git a/include/media/videobuf2-core.h b/include/media/videobuf2-core.h
index d88a098..41709a8 100644
--- a/include/media/videobuf2-core.h
+++ b/include/media/videobuf2-core.h
@@ -83,7 +83,7 @@ struct vb2_fileio_data;
 struct vb2_mem_ops {
 	void		*(*alloc)(void *alloc_ctx, unsigned long size, gfp_t gfp_flags);
 	void		(*put)(void *buf_priv);
-	struct dma_buf *(*get_dmabuf)(void *buf_priv);
+	struct dma_buf *(*get_dmabuf)(void *buf_priv, unsigned long flags);
 
 	void		*(*get_userptr)(void *alloc_ctx, unsigned long vaddr,
 					unsigned long size, int write);
-- 
1.8.2.rc2

