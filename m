Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wr1-f66.google.com ([209.85.221.66]:45996 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726878AbeHLKA0 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sun, 12 Aug 2018 06:00:26 -0400
From: Iliya Iliev <iliyailiev3592@gmail.com>
To: mchehab@kernel.org
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        Iliya Iliev <iliyailiev3592@gmail.com>
Subject: [PATCH] drivers: media: pci: b2c2: Fix errors due to unappropriate coding style.
Date: Sun, 12 Aug 2018 10:23:11 +0300
Message-Id: <20180812072311.29776-1-iliyailiev3592@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Fix error due to assignment in conditional expression.
Fix errors due to absence of empty spaces separators after commas in
function calls.
Fix errors due to lines longer than 80 characters.

Signed-off-by: Iliya Iliev <iliyailiev3592@gmail.com>
---
 drivers/media/pci/b2c2/flexcop-dma.c | 70 +++++++++++++++-------------
 1 file changed, 37 insertions(+), 33 deletions(-)

diff --git a/drivers/media/pci/b2c2/flexcop-dma.c b/drivers/media/pci/b2c2/flexcop-dma.c
index f07610a1646d..ba45b378d739 100644
--- a/drivers/media/pci/b2c2/flexcop-dma.c
+++ b/drivers/media/pci/b2c2/flexcop-dma.c
@@ -17,7 +17,8 @@ int flexcop_dma_allocate(struct pci_dev *pdev,
 		return -EINVAL;
 	}
 
-	if ((tcpu = pci_alloc_consistent(pdev, size, &tdma)) != NULL) {
+	tcpu = pci_alloc_consistent(pdev, size, &tdma);
+	if (tcpu != NULL) {
 		dma->pdev = pdev;
 		dma->cpu_addr0 = tcpu;
 		dma->dma_addr0 = tdma;
@@ -34,7 +35,7 @@ void flexcop_dma_free(struct flexcop_dma *dma)
 {
 	pci_free_consistent(dma->pdev, dma->size*2,
 			dma->cpu_addr0, dma->dma_addr0);
-	memset(dma,0,sizeof(struct flexcop_dma));
+	memset(dma, 0, sizeof(struct flexcop_dma));
 }
 EXPORT_SYMBOL(flexcop_dma_free);
 
@@ -42,23 +43,24 @@ int flexcop_dma_config(struct flexcop_device *fc,
 		struct flexcop_dma *dma,
 		flexcop_dma_index_t dma_idx)
 {
-	flexcop_ibi_value v0x0,v0x4,v0xc;
-	v0x0.raw = v0x4.raw = v0xc.raw = 0;
+	flexcop_ibi_value v0x0, v0x4, v0xc;
 
+	v0x0.raw = v0x4.raw = v0xc.raw = 0;
 	v0x0.dma_0x0.dma_address0 = dma->dma_addr0 >> 2;
 	v0xc.dma_0xc.dma_address1 = dma->dma_addr1 >> 2;
 	v0x4.dma_0x4_write.dma_addr_size = dma->size / 4;
 
 	if ((dma_idx & FC_DMA_1) == dma_idx) {
-		fc->write_ibi_reg(fc,dma1_000,v0x0);
-		fc->write_ibi_reg(fc,dma1_004,v0x4);
-		fc->write_ibi_reg(fc,dma1_00c,v0xc);
+		fc->write_ibi_reg(fc, dma1_000, v0x0);
+		fc->write_ibi_reg(fc, dma1_004, v0x4);
+		fc->write_ibi_reg(fc, dma1_00c, v0xc);
 	} else if ((dma_idx & FC_DMA_2) == dma_idx) {
-		fc->write_ibi_reg(fc,dma2_010,v0x0);
-		fc->write_ibi_reg(fc,dma2_014,v0x4);
-		fc->write_ibi_reg(fc,dma2_01c,v0xc);
+		fc->write_ibi_reg(fc, dma2_010, v0x0);
+		fc->write_ibi_reg(fc, dma2_014, v0x4);
+		fc->write_ibi_reg(fc, dma2_01c, v0xc);
 	} else {
-		err("either DMA1 or DMA2 can be configured within one flexcop_dma_config call.");
+		err("either DMA1 or DMA2 can be configured within one %s call.",
+			__func__);
 		return -EINVAL;
 	}
 
@@ -72,8 +74,8 @@ int flexcop_dma_xfer_control(struct flexcop_device *fc,
 		flexcop_dma_addr_index_t index,
 		int onoff)
 {
-	flexcop_ibi_value v0x0,v0xc;
-	flexcop_ibi_register r0x0,r0xc;
+	flexcop_ibi_value v0x0, v0xc;
+	flexcop_ibi_register r0x0, r0xc;
 
 	if ((dma_idx & FC_DMA_1) == dma_idx) {
 		r0x0 = dma1_000;
@@ -82,15 +84,16 @@ int flexcop_dma_xfer_control(struct flexcop_device *fc,
 		r0x0 = dma2_010;
 		r0xc = dma2_01c;
 	} else {
-		err("either transfer DMA1 or DMA2 can be started within one flexcop_dma_xfer_control call.");
+		err("transfer DMA1 or DMA2 can be started within one %s call.",
+			__func__);
 		return -EINVAL;
 	}
 
-	v0x0 = fc->read_ibi_reg(fc,r0x0);
-	v0xc = fc->read_ibi_reg(fc,r0xc);
+	v0x0 = fc->read_ibi_reg(fc, r0x0);
+	v0xc = fc->read_ibi_reg(fc, r0xc);
 
-	deb_rdump("reg: %03x: %x\n",r0x0,v0x0.raw);
-	deb_rdump("reg: %03x: %x\n",r0xc,v0xc.raw);
+	deb_rdump("reg: %03x: %x\n", r0x0, v0x0.raw);
+	deb_rdump("reg: %03x: %x\n", r0xc, v0xc.raw);
 
 	if (index & FC_DMA_SUBADDR_0)
 		v0x0.dma_0x0.dma_0start = onoff;
@@ -98,11 +101,11 @@ int flexcop_dma_xfer_control(struct flexcop_device *fc,
 	if (index & FC_DMA_SUBADDR_1)
 		v0xc.dma_0xc.dma_1start = onoff;
 
-	fc->write_ibi_reg(fc,r0x0,v0x0);
-	fc->write_ibi_reg(fc,r0xc,v0xc);
+	fc->write_ibi_reg(fc, r0x0, v0x0);
+	fc->write_ibi_reg(fc, r0xc, v0xc);
 
-	deb_rdump("reg: %03x: %x\n",r0x0,v0x0.raw);
-	deb_rdump("reg: %03x: %x\n",r0xc,v0xc.raw);
+	deb_rdump("reg: %03x: %x\n", r0x0, v0x0.raw);
+	deb_rdump("reg: %03x: %x\n", r0xc, v0xc.raw);
 	return 0;
 }
 EXPORT_SYMBOL(flexcop_dma_xfer_control);
@@ -112,10 +115,11 @@ static int flexcop_dma_remap(struct flexcop_device *fc,
 		int onoff)
 {
 	flexcop_ibi_register r = (dma_idx & FC_DMA_1) ? dma1_00c : dma2_01c;
-	flexcop_ibi_value v = fc->read_ibi_reg(fc,r);
-	deb_info("%s\n",__func__);
+	flexcop_ibi_value v = fc->read_ibi_reg(fc, r);
+
+	deb_info("%s\n", __func__);
 	v.dma_0xc.remap_enable = onoff;
-	fc->write_ibi_reg(fc,r,v);
+	fc->write_ibi_reg(fc, r, v);
 	return 0;
 }
 
@@ -123,7 +127,7 @@ int flexcop_dma_control_size_irq(struct flexcop_device *fc,
 		flexcop_dma_index_t no,
 		int onoff)
 {
-	flexcop_ibi_value v = fc->read_ibi_reg(fc,ctrl_208);
+	flexcop_ibi_value v = fc->read_ibi_reg(fc, ctrl_208);
 
 	if (no & FC_DMA_1)
 		v.ctrl_208.DMA1_IRQ_Enable_sig = onoff;
@@ -131,7 +135,7 @@ int flexcop_dma_control_size_irq(struct flexcop_device *fc,
 	if (no & FC_DMA_2)
 		v.ctrl_208.DMA2_IRQ_Enable_sig = onoff;
 
-	fc->write_ibi_reg(fc,ctrl_208,v);
+	fc->write_ibi_reg(fc, ctrl_208, v);
 	return 0;
 }
 EXPORT_SYMBOL(flexcop_dma_control_size_irq);
@@ -140,7 +144,7 @@ int flexcop_dma_control_timer_irq(struct flexcop_device *fc,
 		flexcop_dma_index_t no,
 		int onoff)
 {
-	flexcop_ibi_value v = fc->read_ibi_reg(fc,ctrl_208);
+	flexcop_ibi_value v = fc->read_ibi_reg(fc, ctrl_208);
 
 	if (no & FC_DMA_1)
 		v.ctrl_208.DMA1_Timer_Enable_sig = onoff;
@@ -148,7 +152,7 @@ int flexcop_dma_control_timer_irq(struct flexcop_device *fc,
 	if (no & FC_DMA_2)
 		v.ctrl_208.DMA2_Timer_Enable_sig = onoff;
 
-	fc->write_ibi_reg(fc,ctrl_208,v);
+	fc->write_ibi_reg(fc, ctrl_208, v);
 	return 0;
 }
 EXPORT_SYMBOL(flexcop_dma_control_timer_irq);
@@ -158,13 +162,13 @@ int flexcop_dma_config_timer(struct flexcop_device *fc,
 		flexcop_dma_index_t dma_idx, u8 cycles)
 {
 	flexcop_ibi_register r = (dma_idx & FC_DMA_1) ? dma1_004 : dma2_014;
-	flexcop_ibi_value v = fc->read_ibi_reg(fc,r);
+	flexcop_ibi_value v = fc->read_ibi_reg(fc, r);
 
-	flexcop_dma_remap(fc,dma_idx,0);
+	flexcop_dma_remap(fc, dma_idx, 0);
 
-	deb_info("%s\n",__func__);
+	deb_info("%s\n", __func__);
 	v.dma_0x4_write.dmatimer = cycles;
-	fc->write_ibi_reg(fc,r,v);
+	fc->write_ibi_reg(fc, r, v);
 	return 0;
 }
 EXPORT_SYMBOL(flexcop_dma_config_timer);
-- 
2.17.1
