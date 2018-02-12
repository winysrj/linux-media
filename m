Return-path: <linux-media-owner@vger.kernel.org>
Received: from sub5.mail.dreamhost.com ([208.113.200.129]:35581 "EHLO
        homiemail-a92.g.dreamhost.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S932641AbeBLXoW (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 12 Feb 2018 18:44:22 -0500
From: Brad Love <brad@nextdimension.cc>
To: linux-media@vger.kernel.org
Cc: Brad Love <brad@nextdimension.cc>
Subject: [PATCH 4/4] cx23885: Override 888 ImpactVCBe crystal frequency
Date: Mon, 12 Feb 2018 17:44:08 -0600
Message-Id: <1518479048-10192-5-git-send-email-brad@nextdimension.cc>
In-Reply-To: <1518479048-10192-1-git-send-email-brad@nextdimension.cc>
References: <1518479048-10192-1-git-send-email-brad@nextdimension.cc>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hauppauge produced a revision of ImpactVCBe using an 888,
with a 25MHz crystal, instead of using the default third
overtone 50Mhz crystal. This overrides that frequency so
that the cx25840 is properly configured.

Signed-off-by: Brad Love <brad@nextdimension.cc>
---
 drivers/media/pci/cx23885/cx23885-core.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/drivers/media/pci/cx23885/cx23885-core.c b/drivers/media/pci/cx23885/cx23885-core.c
index 2c76a02..101904b 100644
--- a/drivers/media/pci/cx23885/cx23885-core.c
+++ b/drivers/media/pci/cx23885/cx23885-core.c
@@ -881,6 +881,16 @@ static int cx23885_dev_setup(struct cx23885_dev *dev)
 	if (cx23885_boards[dev->board].clk_freq > 0)
 		dev->clk_freq = cx23885_boards[dev->board].clk_freq;
 
+	if (dev->board == CX23885_BOARD_HAUPPAUGE_IMPACTVCBE &&
+		dev->pci->subsystem_device == 0x7137) {
+		/* Hauppauge ImpactVCBe device ID 0x7137 is populated
+		 * with an 888, and a 25Mhz crystal, instead of the
+		 * usual third overtone 50Mhz. The default clock rate must
+		 * be overridden so the cx25840 is properly configured
+		 */
+		dev->clk_freq = 25000000;
+	}
+
 	dev->pci_bus  = dev->pci->bus->number;
 	dev->pci_slot = PCI_SLOT(dev->pci->devfn);
 	cx23885_irq_add(dev, 0x001f00);
-- 
2.7.4
