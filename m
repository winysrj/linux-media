Return-path: <linux-media-owner@vger.kernel.org>
Received: from osg.samsung.com ([64.30.133.232]:34643 "EHLO osg.samsung.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752310AbdK2TIu (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 29 Nov 2017 14:08:50 -0500
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Minghsiu Tsai <minghsiu.tsai@mediatek.com>,
        Houlong Wei <houlong.wei@mediatek.com>,
        Andrew-CT Chen <andrew-ct.chen@mediatek.com>,
        Tiffany Lin <tiffany.lin@mediatek.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org
Subject: [PATCH 11/22] media: mtk-vpu: add description for wdt fields at struct mtk_vpu
Date: Wed, 29 Nov 2017 14:08:29 -0500
Message-Id: <51d70fd5c5c5d154674ba93655b4bb333f4cc96e.1511982439.git.mchehab@s-opensource.com>
In-Reply-To: <73497577f67fbb917e40ab4328104ff310a7c356.1511982439.git.mchehab@s-opensource.com>
References: <73497577f67fbb917e40ab4328104ff310a7c356.1511982439.git.mchehab@s-opensource.com>
In-Reply-To: <73497577f67fbb917e40ab4328104ff310a7c356.1511982439.git.mchehab@s-opensource.com>
References: <73497577f67fbb917e40ab4328104ff310a7c356.1511982439.git.mchehab@s-opensource.com>
To: unlisted-recipients:; (no To-header on input)@bombadil.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Fix those warnings:
  drivers/media/platform/mtk-vpu/mtk_vpu.c:223: warning: No description found for parameter 'wdt'
  drivers/media/platform/mtk-vpu/mtk_vpu.c:223: warning: No description found for parameter 'wdt_refcnt'

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 drivers/media/platform/mtk-vpu/mtk_vpu.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/media/platform/mtk-vpu/mtk_vpu.c b/drivers/media/platform/mtk-vpu/mtk_vpu.c
index 853d598937f6..1ff6a93262b7 100644
--- a/drivers/media/platform/mtk-vpu/mtk_vpu.c
+++ b/drivers/media/platform/mtk-vpu/mtk_vpu.c
@@ -181,6 +181,7 @@ struct share_obj {
  * @extmem:		VPU extended memory information
  * @reg:		VPU TCM and configuration registers
  * @run:		VPU initialization status
+ * @wdt:		VPU watchdog workqueue
  * @ipi_desc:		VPU IPI descriptor
  * @recv_buf:		VPU DTCM share buffer for receiving. The
  *			receive buffer is only accessed in interrupt context.
@@ -194,7 +195,7 @@ struct share_obj {
  *			suppose a client is using VPU to decode VP8.
  *			If the other client wants to encode VP8,
  *			it has to wait until VP8 decode completes.
- * @wdt_refcnt		WDT reference count to make sure the watchdog can be
+ * @wdt_refcnt:		WDT reference count to make sure the watchdog can be
  *			disabled if no other client is using VPU service
  * @ack_wq:		The wait queue for each codec and mdp. When sleeping
  *			processes wake up, they will check the condition
-- 
2.14.3
