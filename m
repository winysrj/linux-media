Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailgw02.mediatek.com ([210.61.82.184]:56728 "EHLO
	mailgw02.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752699AbbIUM0p (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 21 Sep 2015 08:26:45 -0400
From: Tiffany Lin <tiffany.lin@mediatek.com>
To: Pawel Osciak <pawel@osciak.com>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Kyungmin Park <kyungmin.park@samsung.com>
CC: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Matthias Brugger <matthias.bgg@gmail.com>,
	<linux-media@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<linux-arm-kernel@lists.infradead.org>,
	<linux-mediatek@lists.infradead.org>,
	Tiffany Lin <tiffany.lin@mediatek.com>
Subject: [RESEND PATCH] media: vb2: Fix vb2_dc_prepare do not correct sync data to device
Date: Mon, 21 Sep 2015 20:26:11 +0800
Message-ID: <1442838371-21484-1-git-send-email-tiffany.lin@mediatek.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

vb2_dc_prepare use the number of SG entries dma_map_sg_attrs return.
But in dma_sync_sg_for_device, it use lengths of each SG entries
before dma_map_sg_attrs. dma_map_sg_attrs will concatenate
SGs until dma length > dma seg bundary. sgt->nents will less than
sgt->orig_nents. Using SG entries after dma_map_sg_attrs
in vb2_dc_prepare will make some SGs are not sync to device.
After add DMA_ATTR_SKIP_CPU_SYNC in vb2_dc_get_userptr to remove
sync data to device twice. Device randomly get incorrect data because
some SGs are not sync to device. Change to use number of SG entries
before dma_map_sg_attrs in vb2_dc_prepare to prevent this issue.

Signed-off-by: Tiffany Lin <tiffany.lin@mediatek.com>
---
 drivers/media/v4l2-core/videobuf2-dma-contig.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/media/v4l2-core/videobuf2-dma-contig.c b/drivers/media/v4l2-core/videobuf2-dma-contig.c
index 2397ceb..c5d00bd 100644
--- a/drivers/media/v4l2-core/videobuf2-dma-contig.c
+++ b/drivers/media/v4l2-core/videobuf2-dma-contig.c
@@ -100,7 +100,7 @@ static void vb2_dc_prepare(void *buf_priv)
 	if (!sgt || buf->db_attach)
 		return;
 
-	dma_sync_sg_for_device(buf->dev, sgt->sgl, sgt->nents, buf->dma_dir);
+	dma_sync_sg_for_device(buf->dev, sgt->sgl, sgt->orig_nents, buf->dma_dir);
 }
 
 static void vb2_dc_finish(void *buf_priv)
@@ -112,7 +112,7 @@ static void vb2_dc_finish(void *buf_priv)
 	if (!sgt || buf->db_attach)
 		return;
 
-	dma_sync_sg_for_cpu(buf->dev, sgt->sgl, sgt->nents, buf->dma_dir);
+	dma_sync_sg_for_cpu(buf->dev, sgt->sgl, sgt->orig_nents, buf->dma_dir);
 }
 
 /*********************************************/
-- 
1.8.1.1.dirty

