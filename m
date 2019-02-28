Return-Path: <SRS0=4gsG=RD=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C9446C43381
	for <linux-media@archiver.kernel.org>; Thu, 28 Feb 2019 07:19:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 95C81218AE
	for <linux-media@archiver.kernel.org>; Thu, 28 Feb 2019 07:19:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731236AbfB1HTv (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Thu, 28 Feb 2019 02:19:51 -0500
Received: from metis.ext.pengutronix.de ([85.220.165.71]:60401 "EHLO
        metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730951AbfB1HTu (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 28 Feb 2019 02:19:50 -0500
Received: from dude02.hi.pengutronix.de ([2001:67c:670:100:1d::28] helo=dude02.pengutronix.de.)
        by metis.ext.pengutronix.de with esmtp (Exim 4.89)
        (envelope-from <l.stach@pengutronix.de>)
        id 1gzFyr-0000RW-HN; Thu, 28 Feb 2019 08:19:45 +0100
From:   Lucas Stach <l.stach@pengutronix.de>
To:     Pawel Osciak <pawel@osciak.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>
Cc:     Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-media@vger.kernel.org, kernel@pengutronix.de,
        patchwork-lst@pengutronix.de
Subject: [PATCH] media: vb2-dc: skip CPU sync in map/unmap dma_buf
Date:   Thu, 28 Feb 2019 08:19:43 +0100
Message-Id: <20190228071943.13072-1-l.stach@pengutronix.de>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:67c:670:100:1d::28
X-SA-Exim-Mail-From: l.stach@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-media@vger.kernel.org
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

This is rougly equivalent to ca0e68e21aae (drm/prime: skip CPU sync
in map/unmap dma_buf). The contig memory allocated is already device
coherent memory, so there is no point in doing a CPU sync when
mapping it to another device. Also most importers currently cache
the mapping so the CPU sync would only happen on the first import.
With that in mind we are better off with not pretending to do a
cache synchronization at all.

This gets rid of a lot of CPU overhead in uses where those dma-bufs
are regularily imported and detached again, like Weston is currently
doing in the DRM compositor.

Signed-off-by: Lucas Stach <l.stach@pengutronix.de>
---
 drivers/media/common/videobuf2/videobuf2-dma-contig.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/media/common/videobuf2/videobuf2-dma-contig.c b/drivers/media/common/videobuf2/videobuf2-dma-contig.c
index aff0ab7bf83d..d38f097c14ae 100644
--- a/drivers/media/common/videobuf2/videobuf2-dma-contig.c
+++ b/drivers/media/common/videobuf2/videobuf2-dma-contig.c
@@ -273,8 +273,8 @@ static void vb2_dc_dmabuf_ops_detach(struct dma_buf *dbuf,
 
 	/* release the scatterlist cache */
 	if (attach->dma_dir != DMA_NONE)
-		dma_unmap_sg(db_attach->dev, sgt->sgl, sgt->orig_nents,
-			attach->dma_dir);
+		dma_unmap_sg_attrs(db_attach->dev, sgt->sgl, sgt->orig_nents,
+			attach->dma_dir, DMA_ATTR_SKIP_CPU_SYNC);
 	sg_free_table(sgt);
 	kfree(attach);
 	db_attach->priv = NULL;
@@ -305,8 +305,8 @@ static struct sg_table *vb2_dc_dmabuf_ops_map(
 	}
 
 	/* mapping to the client with new direction */
-	sgt->nents = dma_map_sg(db_attach->dev, sgt->sgl, sgt->orig_nents,
-				dma_dir);
+	sgt->nents = dma_map_sg_attrs(db_attach->dev, sgt->sgl, sgt->orig_nents,
+				dma_dir, DMA_ATTR_SKIP_CPU_SYNC);
 	if (!sgt->nents) {
 		pr_err("failed to map scatterlist\n");
 		mutex_unlock(lock);
-- 
2.20.1

