Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr2.xs4all.nl ([194.109.24.22]:1989 "EHLO
	smtp-vbr2.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753150AbaBYKEy (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 25 Feb 2014 05:04:54 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: pawel@osciak.com, s.nawrocki@samsung.com, m.szyprowski@samsung.com,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [RFCv1 PATCH 13/20] vb2: move __qbuf_mmap before __qbuf_userptr
Date: Tue, 25 Feb 2014 11:04:18 +0100
Message-Id: <1393322665-29889-14-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1393322665-29889-1-git-send-email-hverkuil@xs4all.nl>
References: <1393322665-29889-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

__qbuf_mmap was sort of hidden in between the much larger __qbuf_userptr
and __qbuf_dmabuf functions. Move it before __qbuf_userptr which is
also conform the usual order these memory models are implemented: first
mmap, then userptr, then dmabuf.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/v4l2-core/videobuf2-core.c | 50 ++++++++++++++++----------------
 1 file changed, 25 insertions(+), 25 deletions(-)

diff --git a/drivers/media/v4l2-core/videobuf2-core.c b/drivers/media/v4l2-core/videobuf2-core.c
index 1f8ab7b..1dc1db8 100644
--- a/drivers/media/v4l2-core/videobuf2-core.c
+++ b/drivers/media/v4l2-core/videobuf2-core.c
@@ -1241,6 +1241,31 @@ static void __buf_finish_memory(struct vb2_buffer *vb)
 }
 
 /**
+ * __qbuf_mmap() - handle qbuf of an MMAP buffer
+ */
+static int __qbuf_mmap(struct vb2_buffer *vb, const struct v4l2_buffer *b)
+{
+	int ret;
+
+	__fill_vb2_buffer(vb, b, vb->v4l2_planes);
+
+	ret = __buf_prepare_memory(vb);
+	if (ret) {
+		call_vb_qop(vb, buf_cleanup, vb);
+		dprintk(1, "%s: buffer memory preparation failed\n", __func__);
+		return ret;
+	}
+
+	ret = call_vb_qop(vb, buf_prepare, vb);
+	if (ret) {
+		dprintk(1, "%s: buffer preparation failed\n", __func__);
+		fail_vb_qop(vb, buf_prepare);
+		__buf_finish_memory(vb);
+	}
+	return ret;
+}
+
+/**
  * __qbuf_userptr() - handle qbuf of a USERPTR buffer
  */
 static int __qbuf_userptr(struct vb2_buffer *vb, const struct v4l2_buffer *b)
@@ -1354,31 +1379,6 @@ err:
 }
 
 /**
- * __qbuf_mmap() - handle qbuf of an MMAP buffer
- */
-static int __qbuf_mmap(struct vb2_buffer *vb, const struct v4l2_buffer *b)
-{
-	int ret;
-
-	__fill_vb2_buffer(vb, b, vb->v4l2_planes);
-
-	ret = __buf_prepare_memory(vb);
-	if (ret) {
-		call_vb_qop(vb, buf_cleanup, vb);
-		dprintk(1, "%s: buffer memory preparation failed\n", __func__);
-		return ret;
-	}
-
-	ret = call_vb_qop(vb, buf_prepare, vb);
-	if (ret) {
-		dprintk(1, "%s: buffer preparation failed\n", __func__);
-		fail_vb_qop(vb, buf_prepare);
-		__buf_finish_memory(vb);
-	}
-	return ret;
-}
-
-/**
  * __qbuf_dmabuf() - handle qbuf of a DMABUF buffer
  */
 static int __qbuf_dmabuf(struct vb2_buffer *vb, const struct v4l2_buffer *b)
-- 
1.9.0

