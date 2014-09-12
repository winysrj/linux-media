Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr8.xs4all.nl ([194.109.24.28]:3040 "EHLO
	smtp-vbr8.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753967AbaILNAb (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 12 Sep 2014 09:00:31 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: pawel@osciak.com, m.szyprowski@samsung.com,
	laurent.pinchart@ideasonboard.com,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [RFCv2 PATCH 04/14] vb2: memop prepare: return errors
Date: Fri, 12 Sep 2014 14:59:53 +0200
Message-Id: <1410526803-25887-5-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1410526803-25887-1-git-send-email-hverkuil@xs4all.nl>
References: <1410526803-25887-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

For vb2-dma-sg the dma_map_sg function can return an error. This means that
the prepare memop also needs to change so an error can be returned.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/v4l2-core/videobuf2-dma-contig.c | 5 +++--
 drivers/media/v4l2-core/videobuf2-dma-sg.c     | 4 ++--
 include/media/videobuf2-core.h                 | 2 +-
 3 files changed, 6 insertions(+), 5 deletions(-)

diff --git a/drivers/media/v4l2-core/videobuf2-dma-contig.c b/drivers/media/v4l2-core/videobuf2-dma-contig.c
index 6675f12..ca870aa 100644
--- a/drivers/media/v4l2-core/videobuf2-dma-contig.c
+++ b/drivers/media/v4l2-core/videobuf2-dma-contig.c
@@ -111,16 +111,17 @@ static unsigned int vb2_dc_num_users(void *buf_priv)
 	return atomic_read(&buf->refcount);
 }
 
-static void vb2_dc_prepare(void *buf_priv)
+static int vb2_dc_prepare(void *buf_priv)
 {
 	struct vb2_dc_buf *buf = buf_priv;
 	struct sg_table *sgt = buf->dma_sgt;
 
 	/* DMABUF exporter will flush the cache for us */
 	if (!sgt || buf->db_attach)
-		return;
+		return 0;
 
 	dma_sync_sg_for_device(buf->dev, sgt->sgl, sgt->nents, buf->dma_dir);
+	return 0;
 }
 
 static void vb2_dc_finish(void *buf_priv)
diff --git a/drivers/media/v4l2-core/videobuf2-dma-sg.c b/drivers/media/v4l2-core/videobuf2-dma-sg.c
index f3bc01b..abd5252 100644
--- a/drivers/media/v4l2-core/videobuf2-dma-sg.c
+++ b/drivers/media/v4l2-core/videobuf2-dma-sg.c
@@ -170,12 +170,12 @@ static void vb2_dma_sg_put(void *buf_priv)
 	}
 }
 
-static void vb2_dma_sg_prepare(void *buf_priv)
+static int vb2_dma_sg_prepare(void *buf_priv)
 {
 	struct vb2_dma_sg_buf *buf = buf_priv;
 	struct sg_table *sgt = &buf->sg_table;
 
-	dma_map_sg(buf->dev, sgt->sgl, sgt->nents, buf->dma_dir);
+	return dma_map_sg(buf->dev, sgt->sgl, sgt->nents, buf->dma_dir) ? 0 : -EIO;
 }
 
 static void vb2_dma_sg_finish(void *buf_priv)
diff --git a/include/media/videobuf2-core.h b/include/media/videobuf2-core.h
index 02b96ef..0ac65a6 100644
--- a/include/media/videobuf2-core.h
+++ b/include/media/videobuf2-core.h
@@ -91,7 +91,7 @@ struct vb2_mem_ops {
 					unsigned long size, int write);
 	void		(*put_userptr)(void *buf_priv);
 
-	void		(*prepare)(void *buf_priv);
+	int		(*prepare)(void *buf_priv);
 	void		(*finish)(void *buf_priv);
 
 	void		*(*attach_dmabuf)(void *alloc_ctx, struct dma_buf *dbuf,
-- 
2.1.0

