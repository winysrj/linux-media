Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bn1bon0110.outbound.protection.outlook.com ([157.56.111.110]:45865
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754522AbbHJRL6 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 10 Aug 2015 13:11:58 -0400
From: Fabio Estevam <fabio.estevam@freescale.com>
To: <mchehab@osg.samsung.com>
CC: <jan@kloetzke.net>, <linux-media@vger.kernel.org>,
	<zy900702@163.com>, Fabio Estevam <fabio.estevam@freescale.com>
Subject: [PATCH] [media] mantis: Fix error handling in mantis_dma_init()
Date: Mon, 10 Aug 2015 14:11:41 -0300
Message-ID: <1439226701-5896-1-git-send-email-fabio.estevam@freescale.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Current code assigns 0 to variable 'err', which makes mantis_dma_init()
to return success even if mantis_alloc_buffers() fails.

Fix it by checking the return value from mantis_alloc_buffers() and
propagating it in the case of error. 

Reported-by: RUC_Soft_Sec <zy900702@163.com>
Signed-off-by: Fabio Estevam <fabio.estevam@freescale.com>
---
 drivers/media/pci/mantis/mantis_dma.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/media/pci/mantis/mantis_dma.c b/drivers/media/pci/mantis/mantis_dma.c
index 1d59c7e..87990ec 100644
--- a/drivers/media/pci/mantis/mantis_dma.c
+++ b/drivers/media/pci/mantis/mantis_dma.c
@@ -130,10 +130,11 @@ err:
 
 int mantis_dma_init(struct mantis_pci *mantis)
 {
-	int err = 0;
+	int err;
 
 	dprintk(MANTIS_DEBUG, 1, "Mantis DMA init");
-	if (mantis_alloc_buffers(mantis) < 0) {
+	err = mantis_alloc_buffers(mantis);
+	if (err < 0) {
 		dprintk(MANTIS_ERROR, 1, "Error allocating DMA buffer");
 
 		/* Stop RISC Engine */
-- 
1.9.1

