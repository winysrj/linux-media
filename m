Return-path: <linux-media-owner@vger.kernel.org>
Received: from team.netup.ru ([77.72.80.1]:34184 "EHLO a-desktop"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753442AbbIYH4Z (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 25 Sep 2015 03:56:25 -0400
From: Abylay Ospan <aospan@netup.ru>
To: linux-media@vger.kernel.org, serjk@netup.ru, aospan@netup.ru,
	dan.carpenter@oracle.com, m.chehab@samsung.com
Subject: [PATCH] [media] netup_unidvb: fix potential crash when spi is NULL
Date: Fri, 25 Sep 2015 03:56:21 -0400
Message-Id: <1443167781-23220-1-git-send-email-aospan@netup.ru>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Abylay Ospan <aospan@netup.ru>
Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
---
 drivers/media/pci/netup_unidvb/netup_unidvb_spi.c | 12 ++++--------
 1 file changed, 4 insertions(+), 8 deletions(-)

diff --git a/drivers/media/pci/netup_unidvb/netup_unidvb_spi.c b/drivers/media/pci/netup_unidvb/netup_unidvb_spi.c
index f55b327..56773f3 100644
--- a/drivers/media/pci/netup_unidvb/netup_unidvb_spi.c
+++ b/drivers/media/pci/netup_unidvb/netup_unidvb_spi.c
@@ -80,11 +80,9 @@ irqreturn_t netup_spi_interrupt(struct netup_spi *spi)
 	u16 reg;
 	unsigned long flags;
 
-	if (!spi) {
-		dev_dbg(&spi->master->dev,
-			"%s(): SPI not initialized\n", __func__);
+	if (!spi)
 		return IRQ_NONE;
-	}
+
 	spin_lock_irqsave(&spi->lock, flags);
 	reg = readw(&spi->regs->control_stat);
 	if (!(reg & NETUP_SPI_CTRL_IRQ)) {
@@ -234,11 +232,9 @@ void netup_spi_release(struct netup_unidvb_dev *ndev)
 	unsigned long flags;
 	struct netup_spi *spi = ndev->spi;
 
-	if (!spi) {
-		dev_dbg(&spi->master->dev,
-			"%s(): SPI not initialized\n", __func__);
+	if (!spi)
 		return;
-	}
+
 	spin_lock_irqsave(&spi->lock, flags);
 	reg = readw(&spi->regs->control_stat);
 	writew(reg | NETUP_SPI_CTRL_IRQ, &spi->regs->control_stat);
-- 
2.1.4

