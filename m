Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pg0-f66.google.com ([74.125.83.66]:33103 "EHLO
        mail-pg0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S936690AbdCXPsW (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 24 Mar 2017 11:48:22 -0400
Date: Fri, 24 Mar 2017 21:18:09 +0530
From: Arushi Singhal <arushisinghal19971997@gmail.com>
To: mchehab@kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-media@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, outreachy-kernel@googlegroups.com
Subject: [PATCH v2] staging: media: atomisp:Replace a bit shift.
Message-ID: <20170324154809.GA12158@arushi-HP-Pavilion-Notebook>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch replaces bit shifting on 1 with the BIT(x) macro.
This was done with coccinelle:
@@
constant c;
@@

-1 << c
+BIT(c)

Signed-off-by: Arushi Singhal <arushisinghal19971997@gmail.com>
---
changes in v2
 -remove the unnecessary parenthesis.

 drivers/staging/media/atomisp/pci/atomisp2/atomisp_cmd.c  | 12 ++++++------
 drivers/staging/media/atomisp/pci/atomisp2/atomisp_v4l2.c | 10 +++++-----
 2 files changed, 11 insertions(+), 11 deletions(-)

diff --git a/drivers/staging/media/atomisp/pci/atomisp2/atomisp_cmd.c b/drivers/staging/media/atomisp/pci/atomisp2/atomisp_cmd.c
index 94bc7938f533..8edcde282ec9 100644
--- a/drivers/staging/media/atomisp/pci/atomisp2/atomisp_cmd.c
+++ b/drivers/staging/media/atomisp/pci/atomisp2/atomisp_cmd.c
@@ -194,7 +194,7 @@ static int write_target_freq_to_hw(struct atomisp_device *isp,
 	if (isp_sspm1 & ISP_FREQ_VALID_MASK) {
 		dev_dbg(isp->dev, "clearing ISPSSPM1 valid bit.\n");
 		intel_mid_msgbus_write32(PUNIT_PORT, ISPSSPM1,
-				    isp_sspm1 & ~(1 << ISP_FREQ_VALID_OFFSET));
+				    isp_sspm1 & ~BIT(ISP_FREQ_VALID_OFFSET));
 	}
 
 	ratio = (2 * isp->hpll_freq + new_freq / 2) / new_freq - 1;
@@ -207,7 +207,7 @@ static int write_target_freq_to_hw(struct atomisp_device *isp,
 		intel_mid_msgbus_write32(PUNIT_PORT, ISPSSPM1,
 				   isp_sspm1
 				   | ratio << ISP_REQ_FREQ_OFFSET
-				   | 1 << ISP_FREQ_VALID_OFFSET
+				   | BIT(ISP_FREQ_VALID_OFFSET)
 				   | guar_ratio << ISP_REQ_GUAR_FREQ_OFFSET);
 
 		isp_sspm1 = intel_mid_msgbus_read32(PUNIT_PORT, ISPSSPM1);
@@ -417,10 +417,10 @@ void atomisp_msi_irq_init(struct atomisp_device *isp, struct pci_dev *dev)
 	u16 msg16;
 
 	pci_read_config_dword(dev, PCI_MSI_CAPID, &msg32);
-	msg32 |= 1 << MSI_ENABLE_BIT;
+	msg32 |= BIT(MSI_ENABLE_BIT);
 	pci_write_config_dword(dev, PCI_MSI_CAPID, msg32);
 
-	msg32 = (1 << INTR_IER) | (1 << INTR_IIR);
+	msg32 = BIT(INTR_IER) | BIT(INTR_IIR);
 	pci_write_config_dword(dev, PCI_INTERRUPT_CTRL, msg32);
 
 	pci_read_config_word(dev, PCI_COMMAND, &msg16);
@@ -435,7 +435,7 @@ void atomisp_msi_irq_uninit(struct atomisp_device *isp, struct pci_dev *dev)
 	u16 msg16;
 
 	pci_read_config_dword(dev, PCI_MSI_CAPID, &msg32);
-	msg32 &=  ~(1 << MSI_ENABLE_BIT);
+	msg32 &=  ~BIT(MSI_ENABLE_BIT);
 	pci_write_config_dword(dev, PCI_MSI_CAPID, msg32);
 
 	msg32 = 0x0;
@@ -536,7 +536,7 @@ static void clear_irq_reg(struct atomisp_device *isp)
 {
 	u32 msg_ret;
 	pci_read_config_dword(isp->pdev, PCI_INTERRUPT_CTRL, &msg_ret);
-	msg_ret |= 1 << INTR_IIR;
+	msg_ret |= BIT(INTR_IIR);
 	pci_write_config_dword(isp->pdev, PCI_INTERRUPT_CTRL, msg_ret);
 }
 
diff --git a/drivers/staging/media/atomisp/pci/atomisp2/atomisp_v4l2.c b/drivers/staging/media/atomisp/pci/atomisp2/atomisp_v4l2.c
index 626d2f114d8d..b1f685a841ba 100644
--- a/drivers/staging/media/atomisp/pci/atomisp2/atomisp_v4l2.c
+++ b/drivers/staging/media/atomisp/pci/atomisp2/atomisp_v4l2.c
@@ -330,11 +330,11 @@ static int atomisp_mrfld_pre_power_down(struct atomisp_device *isp)
 	 * IRQ, if so, waiting for it to be served
 	 */
 	pci_read_config_dword(dev, PCI_INTERRUPT_CTRL, &irq);
-	irq = irq & 1 << INTR_IIR;
+	irq = irq & BIT(INTR_IIR);
 	pci_write_config_dword(dev, PCI_INTERRUPT_CTRL, irq);
 
 	pci_read_config_dword(dev, PCI_INTERRUPT_CTRL, &irq);
-	if (!(irq & (1 << INTR_IIR)))
+	if (!(irq & BIT(INTR_IIR)))
 		goto done;
 
 	atomisp_store_uint32(MRFLD_INTR_CLEAR_REG, 0xFFFFFFFF);
@@ -347,11 +347,11 @@ static int atomisp_mrfld_pre_power_down(struct atomisp_device *isp)
 		return -EAGAIN;
 	} else {
 		pci_read_config_dword(dev, PCI_INTERRUPT_CTRL, &irq);
-		irq = irq & 1 << INTR_IIR;
+		irq = irq & BIT(INTR_IIR);
 		pci_write_config_dword(dev, PCI_INTERRUPT_CTRL, irq);
 
 		pci_read_config_dword(dev, PCI_INTERRUPT_CTRL, &irq);
-		if (!(irq & (1 << INTR_IIR))) {
+		if (!(irq & BIT(INTR_IIR))) {
 			atomisp_store_uint32(MRFLD_INTR_ENABLE_REG, 0x0);
 			goto done;
 		}
@@ -370,7 +370,7 @@ static int atomisp_mrfld_pre_power_down(struct atomisp_device *isp)
 	* HW sighting:4568410.
 	*/
 	pci_read_config_dword(dev, PCI_INTERRUPT_CTRL, &irq);
-	irq &= ~(1 << INTR_IER);
+	irq &= ~BIT(INTR_IER);
 	pci_write_config_dword(dev, PCI_INTERRUPT_CTRL, irq);
 
 	atomisp_msi_irq_uninit(isp, dev);
-- 
2.11.0
