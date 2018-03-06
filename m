Return-path: <linux-media-owner@vger.kernel.org>
Received: from sub5.mail.dreamhost.com ([208.113.200.129]:44189 "EHLO
        homiemail-a48.g.dreamhost.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1753976AbeCFTPl (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 6 Mar 2018 14:15:41 -0500
From: Brad Love <brad@nextdimension.cc>
To: linux-media@vger.kernel.org
Cc: Brad Love <brad@nextdimension.cc>
Subject: [PATCH 4/4] cx23885: Override 888 ImpactVCBe crystal frequency
Date: Tue,  6 Mar 2018 13:15:37 -0600
Message-Id: <1520363737-25724-5-git-send-email-brad@nextdimension.cc>
In-Reply-To: <1520363737-25724-1-git-send-email-brad@nextdimension.cc>
References: <1520363737-25724-1-git-send-email-brad@nextdimension.cc>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hauppauge produced a revision of ImpactVCBe using an 888,
with a 25MHz crystal, instead of using the default third
overtone 50Mhz crystal. This overrides that frequency so
that the cx25840 is properly configured. Without the proper
crystal setup the cx25840 cannot load the firmware or
decode video.

Signed-off-by: Brad Love <brad@nextdimension.cc>
---
 drivers/media/pci/cx23885/cx23885-core.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/drivers/media/pci/cx23885/cx23885-core.c b/drivers/media/pci/cx23885/cx23885-core.c
index 2c76a02..ff369e9 100644
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
