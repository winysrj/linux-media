Return-path: <linux-media-owner@vger.kernel.org>
Received: from canardo.mork.no ([148.122.252.1]:53576 "EHLO canardo.mork.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752646Ab0CUUJI (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 21 Mar 2010 16:09:08 -0400
From: =?utf-8?q?Bj=C3=B8rn=20Mork?= <bjorn@mork.no>
To: linux-media@vger.kernel.org
Cc: =?utf-8?q?Bj=C3=B8rn=20Mork?= <bjorn@mork.no>, stable@kernel.org
Subject: [PATCH] V4L/DVB: saa7146: IRQF_DISABLED causes only trouble
Date: Sun, 21 Mar 2010 21:08:55 +0100
Message-Id: <1269202135-340-1-git-send-email-bjorn@mork.no>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

As discussed many times, e.g. in http://lkml.org/lkml/2007/7/26/401
mixing IRQF_DISABLED with IRQF_SHARED just doesn't make sense.

Remove IRQF_DISABLED to avoid random unexpected behaviour.

Ever since I started using the saa7146 driver, I've had occasional
soft lockups.  I do not have any real evidence that the saa7146
driver is the cause, but the lockups are gone after removing the
IRQF_DISABLED flag from this driver.

On my system, this driver shares an irq17 with the pata_jmicron
driver:

 17:       2115      10605    9422844    8193902   IO-APIC-fasteoi   pata_jmicron, saa7146 (0)

This may be a mitigating factor.

Signed-off-by: Bjørn Mork <bjorn@mork.no>
Cc: stable@kernel.org
---
 drivers/media/common/saa7146_core.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/media/common/saa7146_core.c b/drivers/media/common/saa7146_core.c
index 982f000..038dcc8 100644
--- a/drivers/media/common/saa7146_core.c
+++ b/drivers/media/common/saa7146_core.c
@@ -416,7 +416,7 @@ static int saa7146_init_one(struct pci_dev *pci, const struct pci_device_id *ent
 	saa7146_write(dev, MC2, 0xf8000000);
 
 	/* request an interrupt for the saa7146 */
-	err = request_irq(pci->irq, interrupt_hw, IRQF_SHARED | IRQF_DISABLED,
+	err = request_irq(pci->irq, interrupt_hw, IRQF_SHARED,
 			  dev->name, dev);
 	if (err < 0) {
 		ERR(("request_irq() failed.\n"));
-- 
1.5.6.5

