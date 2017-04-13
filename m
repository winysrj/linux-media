Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:57654 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750745AbdDMH57 (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 13 Apr 2017 03:57:59 -0400
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: linux-media@vger.kernel.org
Cc: dri-devel@lists.freedesktop.org, posciak@chromium.org,
        m.szyprowski@samsung.com, kyungmin.park@samsung.com,
        hverkuil@xs4all.nl, sumit.semwal@linaro.org, robdclark@gmail.com,
        daniel.vetter@ffwll.ch, labbott@redhat.com
Subject: [RFC v3 01/14] vb2: Rename confusingly named internal buffer preparation functions
Date: Thu, 13 Apr 2017 10:57:06 +0300
Message-Id: <1492070239-21532-2-git-send-email-sakari.ailus@linux.intel.com>
In-Reply-To: <1492070239-21532-1-git-send-email-sakari.ailus@linux.intel.com>
References: <1492070239-21532-1-git-send-email-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

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
index 94afbbf9..8df680d 100644
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
@@ -1087,9 +1087,9 @@ static int __qbuf_userptr(struct vb2_buffer *vb, const void *pb)
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
@@ -1255,13 +1255,13 @@ static int __buf_prepare(struct vb2_buffer *vb, const void *pb)
 
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
2.7.4
