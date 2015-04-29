Return-Path: <ricardo.ribalda@gmail.com>
From: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
To: Hans Verkuil <hans.verkuil@cisco.com>, Pawel Osciak <pawel@osciak.com>,
 Marek Szyprowski <m.szyprowski@samsung.com>,
 Kyungmin Park <kyungmin.park@samsung.com>,
 Mauro Carvalho Chehab <mchehab@osg.samsung.com>, linux-media@vger.kernel.org,
 linux-kernel@vger.kernel.org
Cc: Ricardo Ribalda <ricardo.ribalda@gmail.com>
Subject: [RESEND PATCH v2 3/3] media/videobuf2-dma-vmalloc: Save output from
 dma_map_sg
Date: Wed, 29 Apr 2015 14:00:47 +0200
Message-id: <1430308847-32140-4-git-send-email-ricardo.ribalda@gmail.com>
In-reply-to: <1430308847-32140-1-git-send-email-ricardo.ribalda@gmail.com>
References: <1430308847-32140-1-git-send-email-ricardo.ribalda@gmail.com>
MIME-version: 1.0
Content-type: text/plain
List-ID: <linux-media.vger.kernel.org>

From: Ricardo Ribalda <ricardo.ribalda@gmail.com>

dma_map_sg returns the number of areas mapped by the hardware,
which could be different than the areas given as an input.
The output must be saved to nent.

Signed-off-by: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
Reviewed-by: Marek Szyprowski <m.szyprowski@samsung.com>
---
 drivers/media/v4l2-core/videobuf2-vmalloc.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/media/v4l2-core/videobuf2-vmalloc.c b/drivers/media/v4l2-core/videobuf2-vmalloc.c
index 657ab302a5cf..2fe4c27f524a 100644
--- a/drivers/media/v4l2-core/videobuf2-vmalloc.c
+++ b/drivers/media/v4l2-core/videobuf2-vmalloc.c
@@ -287,7 +287,6 @@ static struct sg_table *vb2_vmalloc_dmabuf_ops_map(
 	/* stealing dmabuf mutex to serialize map/unmap operations */
 	struct mutex *lock = &db_attach->dmabuf->lock;
 	struct sg_table *sgt;
-	int ret;
 
 	mutex_lock(lock);
 
@@ -306,8 +305,9 @@ static struct sg_table *vb2_vmalloc_dmabuf_ops_map(
 	}
 
 	/* mapping to the client with new direction */
-	ret = dma_map_sg(db_attach->dev, sgt->sgl, sgt->orig_nents, dma_dir);
-	if (ret <= 0) {
+	sgt->nents = dma_map_sg(db_attach->dev, sgt->sgl, sgt->orig_nents,
+				dma_dir);
+	if (!sgt->nents) {
 		pr_err("failed to map scatterlist\n");
 		mutex_unlock(lock);
 		return ERR_PTR(-EIO);
-- 
2.1.4
