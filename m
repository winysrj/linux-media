Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.kundenserver.de ([212.227.17.10]:56784 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932118AbcGMIuv (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 13 Jul 2016 04:50:51 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Hans Verkuil <hans.verkuil@cisco.com>
Cc: Arnd Bergmann <arnd@arndb.de>,
	Mauro Carvalho Chehab <mchehab@kernel.org>,
	Matthias Brugger <matthias.bgg@gmail.com>,
	PoChun Lin <pochun.lin@mediatek.com>,
	Tiffany Lin <tiffany.lin@mediatek.com>,
	linux-media@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	linux-mediatek@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH v2] [media] mtk-vcodec: fix more type mismatches
Date: Wed, 13 Jul 2016 10:47:40 +0200
Message-Id: <20160713084916.2765651-1-arnd@arndb.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The newly added mtk-vcodec driver produces a number of warnings in an ARM
allmodconfig build, mainly since it assumes that dma_addr_t is 32-bit wide:

mtk-vcodec/venc/venc_vp8_if.c: In function 'vp8_enc_alloc_work_buf':
mtk-vcodec/venc/venc_vp8_if.c:212:191: error: cast to pointer from integer of different size [-Werror=int-to-pointer-cast]
mtk-vcodec/venc/venc_h264_if.c: In function 'h264_enc_alloc_work_buf':
mtk-vcodec/venc/venc_h264_if.c:297:190: error: cast to pointer from integer of different size [-Werror=int-to-pointer-cast]

This rearranges the format strings and type casts to what they should have been
in order to avoid the warnings. e0f80d8d62f5 ("[media] mtk-vcodec: fix two compiler
warnings") fixed some of the problems that were introduced at the same time, but
missed two others.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 drivers/media/platform/mtk-vcodec/venc/venc_h264_if.c | 4 ++--
 drivers/media/platform/mtk-vcodec/venc/venc_vp8_if.c  | 4 ++--
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/media/platform/mtk-vcodec/venc/venc_h264_if.c b/drivers/media/platform/mtk-vcodec/venc/venc_h264_if.c
index f4e18bb44cb9..9a600525b3c1 100644
--- a/drivers/media/platform/mtk-vcodec/venc/venc_h264_if.c
+++ b/drivers/media/platform/mtk-vcodec/venc/venc_h264_if.c
@@ -295,9 +295,9 @@ static int h264_enc_alloc_work_buf(struct venc_h264_inst *inst)
 		wb[i].iova = inst->work_bufs[i].dma_addr;
 
 		mtk_vcodec_debug(inst,
-				 "work_buf[%d] va=0x%p iova=0x%p size=%zu",
+				 "work_buf[%d] va=0x%p iova=%pad size=%zu",
 				 i, inst->work_bufs[i].va,
-				 (void *)inst->work_bufs[i].dma_addr,
+				 &inst->work_bufs[i].dma_addr,
 				 inst->work_bufs[i].size);
 	}
 
diff --git a/drivers/media/platform/mtk-vcodec/venc/venc_vp8_if.c b/drivers/media/platform/mtk-vcodec/venc/venc_vp8_if.c
index 5b4ef0f1740c..60bbcd2a0510 100644
--- a/drivers/media/platform/mtk-vcodec/venc/venc_vp8_if.c
+++ b/drivers/media/platform/mtk-vcodec/venc/venc_vp8_if.c
@@ -210,9 +210,9 @@ static int vp8_enc_alloc_work_buf(struct venc_vp8_inst *inst)
 		wb[i].iova = inst->work_bufs[i].dma_addr;
 
 		mtk_vcodec_debug(inst,
-				 "work_bufs[%d] va=0x%p,iova=0x%p,size=%zu",
+				 "work_bufs[%d] va=0x%p,iova=%pad,size=%zu",
 				 i, inst->work_bufs[i].va,
-				 (void *)inst->work_bufs[i].dma_addr,
+				 &inst->work_bufs[i].dma_addr,
 				 inst->work_bufs[i].size);
 	}
 
-- 
2.9.0

