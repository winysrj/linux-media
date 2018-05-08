Return-path: <linux-media-owner@vger.kernel.org>
Received: from sub5.mail.dreamhost.com ([208.113.200.129]:44807 "EHLO
        homiemail-a116.g.dreamhost.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1755941AbeEHVU0 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 8 May 2018 17:20:26 -0400
From: Brad Love <brad@nextdimension.cc>
To: linux-media@vger.kernel.org, mchehab@kernel.org,
        mspieth@digivation.com.au
Cc: Brad Love <brad@nextdimension.cc>
Subject: [PATCH 2/5] cx23885: Use PCI and TS masks in irq functions
Date: Tue,  8 May 2018 16:20:17 -0500
Message-Id: <1525814420-25243-3-git-send-email-brad@nextdimension.cc>
In-Reply-To: <1525814420-25243-1-git-send-email-brad@nextdimension.cc>
References: <1525814420-25243-1-git-send-email-brad@nextdimension.cc>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Currently mask is read for pci_status/ts1_status/ts2_status, but
otherwise ignored. The masks are now used to determine whether
action is warranted.

Signed-off-by: Brad Love <brad@nextdimension.cc>
---
 drivers/media/pci/cx23885/cx23885-core.c | 12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

diff --git a/drivers/media/pci/cx23885/cx23885-core.c b/drivers/media/pci/cx23885/cx23885-core.c
index b279758..3f55319 100644
--- a/drivers/media/pci/cx23885/cx23885-core.c
+++ b/drivers/media/pci/cx23885/cx23885-core.c
@@ -1704,6 +1704,12 @@ static irqreturn_t cx23885_irq(int irq, void *dev_id)
 
 	pci_status = cx_read(PCI_INT_STAT);
 	pci_mask = cx23885_irq_get_mask(dev);
+	if ((pci_status & pci_mask) == 0) {
+		dprintk(7, "pci_status: 0x%08x  pci_mask: 0x%08x\n",
+			pci_status, pci_mask);
+		goto out;
+	}
+
 	vida_status = cx_read(VID_A_INT_STAT);
 	vida_mask = cx_read(VID_A_INT_MSK);
 	audint_status = cx_read(AUDIO_INT_INT_STAT);
@@ -1713,7 +1719,9 @@ static irqreturn_t cx23885_irq(int irq, void *dev_id)
 	ts2_status = cx_read(VID_C_INT_STAT);
 	ts2_mask = cx_read(VID_C_INT_MSK);
 
-	if ((pci_status == 0) && (ts2_status == 0) && (ts1_status == 0))
+	if (((pci_status & pci_mask) == 0) &&
+		((ts2_status & ts2_mask) == 0) &&
+		((ts1_status & ts1_mask) == 0))
 		goto out;
 
 	vida_count = cx_read(VID_A_GPCNT);
@@ -1840,7 +1848,7 @@ static irqreturn_t cx23885_irq(int irq, void *dev_id)
 	}
 
 	if (handled)
-		cx_write(PCI_INT_STAT, pci_status);
+		cx_write(PCI_INT_STAT, pci_status & pci_mask);
 out:
 	return IRQ_RETVAL(handled);
 }
-- 
2.7.4
