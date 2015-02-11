Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-la0-f45.google.com ([209.85.215.45]:36236 "EHLO
	mail-la0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751616AbbBKKdx (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 11 Feb 2015 05:33:53 -0500
From: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
To: Pawel Osciak <pawel@osciak.com>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Kyungmin Park <kyungmin.park@samsung.com>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
	Hans Verkuil <hans.verkuil@cisco.com>
Cc: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
Subject: [PATCH v2 2/3] media/videobuf2-dma-contig: Save output from dma_map_sg
Date: Wed, 11 Feb 2015 11:33:46 +0100
Message-Id: <1423650827-16232-2-git-send-email-ricardo.ribalda@gmail.com>
In-Reply-To: <1423650827-16232-1-git-send-email-ricardo.ribalda@gmail.com>
References: <1423650827-16232-1-git-send-email-ricardo.ribalda@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

dma_map_sg returns the number of areas mapped by the hardware,
which could be different than the areas given as an input.
The output must be saved to nent.

Signed-off-by: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
---
 drivers/media/v4l2-core/videobuf2-dma-contig.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/media/v4l2-core/videobuf2-dma-contig.c b/drivers/media/v4l2-core/videobuf2-dma-contig.c
index b481d20..bfb5917 100644
--- a/drivers/media/v4l2-core/videobuf2-dma-contig.c
+++ b/drivers/media/v4l2-core/videobuf2-dma-contig.c
@@ -299,7 +299,6 @@ static struct sg_table *vb2_dc_dmabuf_ops_map(
 	/* stealing dmabuf mutex to serialize map/unmap operations */
 	struct mutex *lock = &db_attach->dmabuf->lock;
 	struct sg_table *sgt;
-	int ret;
 
 	mutex_lock(lock);
 
@@ -318,8 +317,9 @@ static struct sg_table *vb2_dc_dmabuf_ops_map(
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

