Return-path: <mchehab@gaivota>
Received: from mail-ey0-f174.google.com ([209.85.215.174]:52748 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751235Ab0LaFcK (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 31 Dec 2010 00:32:10 -0500
Message-ID: <4d1d6ad9.857a0e0a.45e5.ffffd91c@mx.google.com>
From: "Igor M. Liplianin" <liplianin@me.by>
Date: Sat, 28 Aug 2010 02:47:15 +0300
Subject: [PATCH 10/18] cx23885: remove duplicate set interrupt mask
To: <mchehab@infradead.org>, linux-media@vger.kernel.org,
	<linux-kernel@vger.kernel.org>, <aospan@netup.ru>
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

Signed-off-by: Igor M. Liplianin <liplianin@netup.ru>
---
 drivers/media/video/cx23885/cx23885-core.c |   10 ++--------
 1 files changed, 2 insertions(+), 8 deletions(-)

diff --git a/drivers/media/video/cx23885/cx23885-core.c b/drivers/media/video/cx23885/cx23885-core.c
index 307eaf4..3a09dd2 100644
--- a/drivers/media/video/cx23885/cx23885-core.c
+++ b/drivers/media/video/cx23885/cx23885-core.c
@@ -904,12 +904,6 @@ static int cx23885_dev_setup(struct cx23885_dev *dev)
 	dev->pci_bus  = dev->pci->bus->number;
 	dev->pci_slot = PCI_SLOT(dev->pci->devfn);
 	cx23885_irq_add(dev, 0x001f00);
-	if (cx23885_boards[dev->board].ci_type == 1)
-		cx23885_irq_add(dev, 0x01800000); /* for CiMaxes */
-
-	if (cx23885_boards[dev->board].ci_type == 2)
-		cx23885_irq_add(dev, 0x00800000); /* for FPGA */
-
 
 	/* External Master 1 Bus */
 	dev->i2c_bus[0].nr = 0;
@@ -2074,10 +2068,10 @@ static int __devinit cx23885_initdev(struct pci_dev *pci_dev,
 
 	switch (dev->board) {
 	case CX23885_BOARD_NETUP_DUAL_DVBS2_CI:
-		cx23885_irq_add_enable(dev, 0x01800000); /* for NetUP */
+		cx23885_irq_add_enable(dev, PCI_MSK_GPIO1 | PCI_MSK_GPIO0);
 		break;
 	case CX23885_BOARD_NETUP_DUAL_DVB_T_C_CI_RF:
-		cx23885_irq_add_enable(dev, 0x00800000);
+		cx23885_irq_add_enable(dev, PCI_MSK_GPIO0);
 		break;
 	}
 
-- 
1.7.1

