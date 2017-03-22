Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pg0-f67.google.com ([74.125.83.67]:36838 "EHLO
        mail-pg0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750731AbdCVEdA (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 22 Mar 2017 00:33:00 -0400
From: Arushi Singhal <arushisinghal19971997@gmail.com>
To: outreachy-kernel@googlegroups.com
Cc: linux-media@vger.kernel.org, gregkh@linuxfoundation.org,
        mchehab@kernel.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org,
        Arushi Singhal <arushisinghal19971997@gmail.com>
Subject: [PATCH 1/3] staging: media: Replace a bit shift by a use of BIT.
Date: Wed, 22 Mar 2017 09:56:07 +0530
Message-Id: <20170322042609.23525-2-arushisinghal19971997@gmail.com>
In-Reply-To: <20170322042609.23525-1-arushisinghal19971997@gmail.com>
References: <20170322042609.23525-1-arushisinghal19971997@gmail.com>
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
 .../staging/media/atomisp/pci/atomisp2/atomisp_cmd.c   | 12 ++++++------
 .../media/atomisp/pci/atomisp2/atomisp_compat_css20.c  |  6 +++---
 .../staging/media/atomisp/pci/atomisp2/atomisp_drvfs.c |  6 +++---
 .../staging/media/atomisp/pci/atomisp2/atomisp_v4l2.c  | 18 +++++++++---------
 .../staging/media/atomisp/pci/atomisp2/hmm/hmm_bo.c    |  2 +-
 5 files changed, 22 insertions(+), 22 deletions(-)

diff --git a/drivers/staging/media/atomisp/pci/atomisp2/atomisp_cmd.c b/drivers/staging/media/atomisp/pci/atomisp2/atomisp_cmd.c
index 94bc7938f533..63e79a23fe7e 100644
--- a/drivers/staging/media/atomisp/pci/atomisp2/atomisp_cmd.c
+++ b/drivers/staging/media/atomisp/pci/atomisp2/atomisp_cmd.c
@@ -194,7 +194,7 @@ static int write_target_freq_to_hw(struct atomisp_device *isp,
 	if (isp_sspm1 & ISP_FREQ_VALID_MASK) {
 		dev_dbg(isp->dev, "clearing ISPSSPM1 valid bit.\n");
 		intel_mid_msgbus_write32(PUNIT_PORT, ISPSSPM1,
-				    isp_sspm1 & ~(1 << ISP_FREQ_VALID_OFFSET));
+				    isp_sspm1 & ~(BIT(ISP_FREQ_VALID_OFFSET)));
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
+	msg32 = (BIT(INTR_IER)) | (BIT(INTR_IIR));
 	pci_write_config_dword(dev, PCI_INTERRUPT_CTRL, msg32);
 
 	pci_read_config_word(dev, PCI_COMMAND, &msg16);
@@ -435,7 +435,7 @@ void atomisp_msi_irq_uninit(struct atomisp_device *isp, struct pci_dev *dev)
 	u16 msg16;
 
 	pci_read_config_dword(dev, PCI_MSI_CAPID, &msg32);
-	msg32 &=  ~(1 << MSI_ENABLE_BIT);
+	msg32 &=  ~(BIT(MSI_ENABLE_BIT));
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
 
diff --git a/drivers/staging/media/atomisp/pci/atomisp2/atomisp_compat_css20.c b/drivers/staging/media/atomisp/pci/atomisp2/atomisp_compat_css20.c
index 2e20a81091f4..a3acd99a02e9 100644
--- a/drivers/staging/media/atomisp/pci/atomisp2/atomisp_compat_css20.c
+++ b/drivers/staging/media/atomisp/pci/atomisp2/atomisp_compat_css20.c
@@ -2017,11 +2017,11 @@ void atomisp_css_input_set_mode(struct atomisp_sub_device *asd,
 		    &asd->stream_env[ATOMISP_INPUT_STREAM_GENERAL].stream_config;
 		s_config->mode = IA_CSS_INPUT_MODE_TPG;
 		s_config->source.tpg.mode = IA_CSS_TPG_MODE_CHECKERBOARD;
-		s_config->source.tpg.x_mask = (1 << 4) - 1;
+		s_config->source.tpg.x_mask = (BIT(4)) - 1;
 		s_config->source.tpg.x_delta = -2;
-		s_config->source.tpg.y_mask = (1 << 4) - 1;
+		s_config->source.tpg.y_mask = (BIT(4)) - 1;
 		s_config->source.tpg.y_delta = 3;
-		s_config->source.tpg.xy_mask = (1 << 8) - 1;
+		s_config->source.tpg.xy_mask = (BIT(8)) - 1;
 		return;
 	}
 
diff --git a/drivers/staging/media/atomisp/pci/atomisp2/atomisp_drvfs.c b/drivers/staging/media/atomisp/pci/atomisp2/atomisp_drvfs.c
index fcfe8d7190b0..44736a39cda5 100644
--- a/drivers/staging/media/atomisp/pci/atomisp2/atomisp_drvfs.c
+++ b/drivers/staging/media/atomisp/pci/atomisp2/atomisp_drvfs.c
@@ -44,9 +44,9 @@ struct _iunit_debug {
 	unsigned int		dbgopt;
 };
 
-#define OPTION_BIN_LIST			(1<<0)
-#define OPTION_BIN_RUN			(1<<1)
-#define OPTION_MEM_STAT			(1<<2)
+#define OPTION_BIN_LIST			(BIT(0))
+#define OPTION_BIN_RUN			(BIT(1))
+#define OPTION_MEM_STAT			(BIT(2))
 #define OPTION_VALID			(OPTION_BIN_LIST \
 					| OPTION_BIN_RUN \
 					| OPTION_MEM_STAT)
diff --git a/drivers/staging/media/atomisp/pci/atomisp2/atomisp_v4l2.c b/drivers/staging/media/atomisp/pci/atomisp2/atomisp_v4l2.c
index 626d2f114d8d..558f3b451eae 100644
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
+	if (!(irq & (BIT(INTR_IIR))))
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
+		if (!(irq & (BIT(INTR_IIR)))) {
 			atomisp_store_uint32(MRFLD_INTR_ENABLE_REG, 0x0);
 			goto done;
 		}
@@ -370,7 +370,7 @@ static int atomisp_mrfld_pre_power_down(struct atomisp_device *isp)
 	* HW sighting:4568410.
 	*/
 	pci_read_config_dword(dev, PCI_INTERRUPT_CTRL, &irq);
-	irq &= ~(1 << INTR_IER);
+	irq &= ~(BIT(INTR_IER));
 	pci_write_config_dword(dev, PCI_INTERRUPT_CTRL, irq);
 
 	atomisp_msi_irq_uninit(isp, dev);
@@ -388,7 +388,7 @@ static int atomisp_mrfld_pre_power_down(struct atomisp_device *isp)
 void punit_ddr_dvfs_enable(bool enable)
 {
 	int reg = intel_mid_msgbus_read32(PUNIT_PORT, MRFLD_ISPSSDVFS);
-	int door_bell = 1 << 8;
+	int door_bell = BIT(8);
 	int max_wait = 30;
 
 	if (enable) {
@@ -726,9 +726,9 @@ int atomisp_csi_lane_config(struct atomisp_device *isp)
 	pci_read_config_dword(isp->pdev, MRFLD_PCI_CSI_CONTROL, &csi_control);
 	csi_control &= ~port_config_mask;
 	csi_control |= (portconfigs[i].code << MRFLD_PORT_CONFIGCODE_SHIFT)
-		| (portconfigs[i].lanes[0] ? 0 : (1 << MRFLD_PORT1_ENABLE_SHIFT))
-		| (portconfigs[i].lanes[1] ? 0 : (1 << MRFLD_PORT2_ENABLE_SHIFT))
-		| (portconfigs[i].lanes[2] ? 0 : (1 << MRFLD_PORT3_ENABLE_SHIFT))
+		| (portconfigs[i].lanes[0] ? 0 : (BIT(MRFLD_PORT1_ENABLE_SHIFT)))
+		| (portconfigs[i].lanes[1] ? 0 : (BIT(MRFLD_PORT2_ENABLE_SHIFT)))
+		| (portconfigs[i].lanes[2] ? 0 : (BIT(MRFLD_PORT3_ENABLE_SHIFT)))
 		| (((1 << portconfigs[i].lanes[0]) - 1) << MRFLD_PORT1_LANES_SHIFT)
 		| (((1 << portconfigs[i].lanes[1]) - 1) << MRFLD_PORT2_LANES_SHIFT)
 		| (((1 << portconfigs[i].lanes[2]) - 1) << port3_lanes_shift);
diff --git a/drivers/staging/media/atomisp/pci/atomisp2/hmm/hmm_bo.c b/drivers/staging/media/atomisp/pci/atomisp2/hmm/hmm_bo.c
index 82593ef35b2d..d3a9c1690b62 100644
--- a/drivers/staging/media/atomisp/pci/atomisp2/hmm/hmm_bo.c
+++ b/drivers/staging/media/atomisp/pci/atomisp2/hmm/hmm_bo.c
@@ -1232,7 +1232,7 @@ int hmm_bo_bind(struct hmm_buffer_object *bo)
 				page_to_phys(bo->page_obj[i].page), 1);
 		if (ret)
 			goto map_err;
-		virt += (1 << PAGE_SHIFT);
+		virt += (BIT(PAGE_SHIFT));
 	}
 
 	/*
-- 
2.11.0
