Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr8.xs4all.nl ([194.109.24.28]:4266 "EHLO
	smtp-vbr8.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752152AbaDKIMM (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 11 Apr 2014 04:12:12 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: pawel@osciak.com, sakari.ailus@iki.fi, m.szyprowski@samsung.com,
	s.nawrocki@samsung.com, Hans Verkuil <hans.verkuil@cisco.com>
Subject: [REVIEWv3 PATCH 05/13] vb2: move __qbuf_mmap before __qbuf_userptr
Date: Fri, 11 Apr 2014 10:11:11 +0200
Message-Id: <1397203879-37443-6-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1397203879-37443-1-git-send-email-hverkuil@xs4all.nl>
References: <1397203879-37443-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

__qbuf_mmap was sort of hidden in between the much larger __qbuf_userptr
and __qbuf_dmabuf functions. Move it before __qbuf_userptr which is
also conform the usual order these memory models are implemented: first
mmap, then userptr, then dmabuf.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
Acked-by: Pawel Osciak <pawel@osciak.com>
Acked-by: Sakari Ailus <sakari.ailus@linux.intel.com>
---
 drivers/media/v4l2-core/videobuf2-core.c | 28 ++++++++++++++--------------
 1 file changed, 14 insertions(+), 14 deletions(-)

diff --git a/drivers/media/v4l2-core/videobuf2-core.c b/drivers/media/v4l2-core/videobuf2-core.c
index 1421075..2e448a7 100644
--- a/drivers/media/v4l2-core/videobuf2-core.c
+++ b/drivers/media/v4l2-core/videobuf2-core.c
@@ -1240,6 +1240,20 @@ static void __fill_vb2_buffer(struct vb2_buffer *vb, const struct v4l2_buffer *b
 }
 
 /**
+ * __qbuf_mmap() - handle qbuf of an MMAP buffer
+ */
+static int __qbuf_mmap(struct vb2_buffer *vb, const struct v4l2_buffer *b)
+{
+	int ret;
+
+	__fill_vb2_buffer(vb, b, vb->v4l2_planes);
+	ret = call_vb_qop(vb, buf_prepare, vb);
+	if (ret)
+		fail_vb_qop(vb, buf_prepare);
+	return ret;
+}
+
+/**
  * __qbuf_userptr() - handle qbuf of a USERPTR buffer
  */
 static int __qbuf_userptr(struct vb2_buffer *vb, const struct v4l2_buffer *b)
@@ -1346,20 +1360,6 @@ err:
 }
 
 /**
- * __qbuf_mmap() - handle qbuf of an MMAP buffer
- */
-static int __qbuf_mmap(struct vb2_buffer *vb, const struct v4l2_buffer *b)
-{
-	int ret;
-
-	__fill_vb2_buffer(vb, b, vb->v4l2_planes);
-	ret = call_vb_qop(vb, buf_prepare, vb);
-	if (ret)
-		fail_vb_qop(vb, buf_prepare);
-	return ret;
-}
-
-/**
  * __qbuf_dmabuf() - handle qbuf of a DMABUF buffer
  */
 static int __qbuf_dmabuf(struct vb2_buffer *vb, const struct v4l2_buffer *b)
-- 
1.9.1

