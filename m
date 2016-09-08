Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:56888 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S938556AbcIHVhu (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Thu, 8 Sep 2016 17:37:50 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Pawel Osciak <pawel@osciak.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
Subject: [PATCH 13/15] [media] videobuf2-v4l2: document two helper functions
Date: Thu,  8 Sep 2016 18:37:39 -0300
Message-Id: <b5effeee5f145eccb543592985a895d28b334073.1473370390.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1473370390.git.mchehab@s-opensource.com>
References: <cover.1473370390.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1473370390.git.mchehab@s-opensource.com>
References: <cover.1473370390.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Document vb2_ops_wait_prepare() and vb2_ops_wait_finish(),
in order to fix those two warnings:
	Documentation/media/kapi/v4l2-dev.rst:166: WARNING: c:func reference target not found: vb2_ops_wait_prepare
	Documentation/media/kapi/v4l2-dev.rst:166: WARNING: c:func reference target not found: vb2_ops_wait_finish

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 include/media/videobuf2-v4l2.h | 17 +++++++++++++++--
 1 file changed, 15 insertions(+), 2 deletions(-)

diff --git a/include/media/videobuf2-v4l2.h b/include/media/videobuf2-v4l2.h
index 611d4f330a4c..036127c54bbf 100644
--- a/include/media/videobuf2-v4l2.h
+++ b/include/media/videobuf2-v4l2.h
@@ -268,9 +268,22 @@ unsigned long vb2_fop_get_unmapped_area(struct file *file, unsigned long addr,
 		unsigned long len, unsigned long pgoff, unsigned long flags);
 #endif
 
-/* struct vb2_ops helpers, only use if vq->lock is non-NULL. */
-
+/**
+ * vb2_ops_wait_prepare - helper function to lock a struct &vb2_queue
+ *
+ * @vq: pointer to struct vb2_queue
+ *
+ * ..note:: only use if vq->lock is non-NULL.
+ */
 void vb2_ops_wait_prepare(struct vb2_queue *vq);
+
+/**
+ * vb2_ops_wait_finish - helper function to unlock a struct &vb2_queue
+ *
+ * @vq: pointer to struct vb2_queue
+ *
+ * ..note:: only use if vq->lock is non-NULL.
+ */
 void vb2_ops_wait_finish(struct vb2_queue *vq);
 
 #endif /* _MEDIA_VIDEOBUF2_V4L2_H */
-- 
2.7.4


