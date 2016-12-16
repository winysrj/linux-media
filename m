Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:50153 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756817AbcLPBXz (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 15 Dec 2016 20:23:55 -0500
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
Subject: [RFC v2 01/11] vb2: Rename confusingly named internal buffer preparation functions
Date: Fri, 16 Dec 2016 03:24:15 +0200
Message-Id: <20161216012425.11179-2-laurent.pinchart+renesas@ideasonboard.com>
In-Reply-To: <20161216012425.11179-1-laurent.pinchart+renesas@ideasonboard.com>
References: <20161216012425.11179-1-laurent.pinchart+renesas@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Sakari Ailus <sakari.ailus@linux.intel.com>

Rename __qbuf_*() functions which are specific to a buffer type as
__prepare_*() which matches with what they do. The naming was there for
historical reasons; the purpose of the functions was changed without
renaming them.

Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Acked-by: Hans Verkuil <hans.verkuil@cisco.com>
Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 drivers/media/v4l2-core/videobuf2-core.c | 18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

diff --git a/drivers/media/v4l2-core/videobuf2-core.c b/drivers/media/v4l2-core/videobuf2-core.c
index 7c1d390ea438..5379c8718010 100644
--- a/drivers/media/v4l2-core/videobuf2-core.c
+++ b/drivers/media/v4l2-core/videobuf2-core.c
@@ -956,9 +956,9 @@ void vb2_discard_done(struct vb2_queue *q)
 EXPORT_SYMBOL_GPL(vb2_discard_done);
 
 /**
- * __qbuf_mmap() - handle qbuf of an MMAP buffer
+ * __prepare_mmap() - prepare an MMAP buffer
  */
-static int __qbuf_mmap(struct vb2_buffer *vb, const void *pb)
+static int __prepare_mmap(struct vb2_buffer *vb, const void *pb)
 {
 	int ret = 0;
 
@@ -969,9 +969,9 @@ static int __qbuf_mmap(struct vb2_buffer *vb, const void *pb)
 }
 
 /**
- * __qbuf_userptr() - handle qbuf of a USERPTR buffer
+ * __prepare_userptr() - prepare a USERPTR buffer
  */
-static int __qbuf_userptr(struct vb2_buffer *vb, const void *pb)
+static int __prepare_userptr(struct vb2_buffer *vb, const void *pb)
 {
 	struct vb2_plane planes[VB2_MAX_PLANES];
 	struct vb2_queue *q = vb->vb2_queue;
@@ -1086,9 +1086,9 @@ static int __qbuf_userptr(struct vb2_buffer *vb, const void *pb)
 }
 
 /**
- * __qbuf_dmabuf() - handle qbuf of a DMABUF buffer
+ * __prepare_dmabuf() - prepare a DMABUF buffer
  */
-static int __qbuf_dmabuf(struct vb2_buffer *vb, const void *pb)
+static int __prepare_dmabuf(struct vb2_buffer *vb, const void *pb)
 {
 	struct vb2_plane planes[VB2_MAX_PLANES];
 	struct vb2_queue *q = vb->vb2_queue;
@@ -1253,13 +1253,13 @@ static int __buf_prepare(struct vb2_buffer *vb, const void *pb)
 
 	switch (q->memory) {
 	case VB2_MEMORY_MMAP:
-		ret = __qbuf_mmap(vb, pb);
+		ret = __prepare_mmap(vb, pb);
 		break;
 	case VB2_MEMORY_USERPTR:
-		ret = __qbuf_userptr(vb, pb);
+		ret = __prepare_userptr(vb, pb);
 		break;
 	case VB2_MEMORY_DMABUF:
-		ret = __qbuf_dmabuf(vb, pb);
+		ret = __prepare_dmabuf(vb, pb);
 		break;
 	default:
 		WARN(1, "Invalid queue type\n");
-- 
Regards,

Laurent Pinchart

