Return-path: <linux-media-owner@vger.kernel.org>
Received: from sub5.mail.dreamhost.com ([208.113.200.129]:44811 "EHLO
        homiemail-a116.g.dreamhost.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1755946AbeEHVU0 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 8 May 2018 17:20:26 -0400
From: Brad Love <brad@nextdimension.cc>
To: linux-media@vger.kernel.org, mchehab@kernel.org,
        mspieth@digivation.com.au
Cc: Brad Love <brad@nextdimension.cc>
Subject: [PATCH 3/5] cx23885: Ryzen DMA related RiSC engine stall fixes
Date: Tue,  8 May 2018 16:20:18 -0500
Message-Id: <1525814420-25243-4-git-send-email-brad@nextdimension.cc>
In-Reply-To: <1525814420-25243-1-git-send-email-brad@nextdimension.cc>
References: <1525814420-25243-1-git-send-email-brad@nextdimension.cc>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This bug affects all of Hauppauge QuadHD boards when used on all Ryzen
platforms and some XEON platforms. On these platforms it is possible to
error out the RiSC engine and cause it to stall, whereafter the only
way to reset the board to a working state is to reboot.

This is the fatal condition with current driver:

[  255.663598] cx23885: cx23885[0]: mpeg risc op code error
[  255.663607] cx23885: cx23885[0]: TS1 B - dma channel status dump
[  255.663612] cx23885: cx23885[0]:   cmds: init risc lo   : 0xffe54000
[  255.663615] cx23885: cx23885[0]:   cmds: init risc hi   : 0x00000000
[  255.663619] cx23885: cx23885[0]:   cmds: cdt base       : 0x00010870
[  255.663622] cx23885: cx23885[0]:   cmds: cdt size       : 0x0000000a
[  255.663625] cx23885: cx23885[0]:   cmds: iq base        : 0x00010630
[  255.663629] cx23885: cx23885[0]:   cmds: iq size        : 0x00000010
[  255.663632] cx23885: cx23885[0]:   cmds: risc pc lo     : 0xffe54018
[  255.663636] cx23885: cx23885[0]:   cmds: risc pc hi     : 0x00000000
[  255.663639] cx23885: cx23885[0]:   cmds: iq wr ptr      : 0x00004192
[  255.663642] cx23885: cx23885[0]:   cmds: iq rd ptr      : 0x0000418c
[  255.663645] cx23885: cx23885[0]:   cmds: cdt current    : 0x00010898
[  255.663649] cx23885: cx23885[0]:   cmds: pci target lo  : 0xf85ca340
[  255.663652] cx23885: cx23885[0]:   cmds: pci target hi  : 0x00000000
[  255.663655] cx23885: cx23885[0]:   cmds: line / byte    : 0x000c0000
[  255.663659] cx23885: cx23885[0]:   risc0:
[  255.663661] 0x1c0002f0 [ write sol eol count=752 ]
[  255.663666] cx23885: cx23885[0]:   risc1:
[  255.663667] 0xf85ca050 [ INVALID sol 22 20 19 18 resync 13 count=80 ]
[  255.663674] cx23885: cx23885[0]:   risc2:
[  255.663674] 0x00000000 [ INVALID count=0 ]
[  255.663678] cx23885: cx23885[0]:   risc3:
[  255.663679] 0x1c0002f0 [ write sol eol count=752 ]
[  255.663684] cx23885: cx23885[0]:   (0x00010630) iq 0:
[  255.663685] 0x1c0002f0 [ write sol eol count=752 ]
[  255.663690] cx23885: cx23885[0]:   iq 1: 0xf85ca630 [ arg #1 ]
[  255.663693] cx23885: cx23885[0]:   iq 2: 0x00000000 [ arg #2 ]
[  255.663696] cx23885: cx23885[0]:   (0x0001063c) iq 3:
[  255.663697] 0x1c0002f0 [ write sol eol count=752 ]
[  255.663702] cx23885: cx23885[0]:   iq 4: 0xf85ca920 [ arg #1 ]
[  255.663705] cx23885: cx23885[0]:   iq 5: 0x00000000 [ arg #2 ]
[  255.663709] cx23885: cx23885[0]:   (0x00010648) iq 6:
[  255.663709] 0xf85ca340 [ INVALID sol 22 20 19 18 resync 13 count=832 ]
[  255.663716] cx23885: cx23885[0]:   (0x0001064c) iq 7:
[  255.663717] 0x00000000 [ INVALID count=0 ]
[  255.663721] cx23885: cx23885[0]:   (0x00010650) iq 8:
[  255.663721] 0x00000000 [ INVALID count=0 ]
[  255.663725] cx23885: cx23885[0]:   (0x00010654) iq 9:
[  255.663726] 0x1c0002f0 [ write sol eol count=752 ]
[  255.663731] cx23885: cx23885[0]:   iq a: 0xf85c9780 [ arg #1 ]
[  255.663734] cx23885: cx23885[0]:   iq b: 0x00000000 [ arg #2 ]
[  255.663737] cx23885: cx23885[0]:   (0x00010660) iq c:
[  255.663738] 0x1c0002f0 [ write sol eol count=752 ]
[  255.663743] cx23885: cx23885[0]:   iq d: 0xf85c9a70 [ arg #1 ]
[  255.663746] cx23885: cx23885[0]:   iq e: 0x00000000 [ arg #2 ]
[  255.663749] cx23885: cx23885[0]:   (0x0001066c) iq f:
[  255.663750] 0x1c0002f0 [ write sol eol count=752 ]
[  255.663755] cx23885: cx23885[0]:   iq 10: 0xf4fa2920 [ arg #1 ]
[  255.663758] cx23885: cx23885[0]:   iq 11: 0x00000000 [ arg #2 ]
[  255.663759] cx23885: cx23885[0]: fifo: 0x00005000 -> 0x6000
[  255.663760] cx23885: cx23885[0]: ctrl: 0x00010630 -> 0x10690
[  255.663764] cx23885: cx23885[0]:   ptr1_reg: 0x00005980
[  255.663767] cx23885: cx23885[0]:   ptr2_reg: 0x000108a8
[  255.663770] cx23885: cx23885[0]:   cnt1_reg: 0x0000000b
[  255.663773] cx23885: cx23885[0]:   cnt2_reg: 0x00000003

Included is checks of the TC_REQ and TC_REQ_SET registers during states
of board initialization, reset, DMA start, and DMA stop. If both registers
are set, this indicates a stall in the RiSC engine, at which point the
bridge error is cleared.

A small delay is introduced in stop_dma as well, to allow transfers in
progress to finish.

After application all models work on Ryzen, occasionally yielding:

cx23885_clear_bridge_error: dma in progress detected 0x00000001 0x00000001, clearing

Signed-off-by: Brad Love <brad@nextdimension.cc>
---
 drivers/media/pci/cx23885/cx23885-core.c | 63 +++++++++++++++++++++++++++++++-
 drivers/media/pci/cx23885/cx23885-reg.h  | 14 +++++++
 2 files changed, 75 insertions(+), 2 deletions(-)

diff --git a/drivers/media/pci/cx23885/cx23885-core.c b/drivers/media/pci/cx23885/cx23885-core.c
index 3f55319..20a1fd2 100644
--- a/drivers/media/pci/cx23885/cx23885-core.c
+++ b/drivers/media/pci/cx23885/cx23885-core.c
@@ -601,6 +601,25 @@ static void cx23885_risc_disasm(struct cx23885_tsport *port,
 	}
 }
 
+static void cx23885_clear_bridge_error(struct cx23885_dev *dev)
+{
+	uint32_t reg1_val = cx_read(TC_REQ); /* read-only */
+	uint32_t reg2_val = cx_read(TC_REQ_SET);
+
+	if (reg1_val && reg2_val) {
+		cx_write(TC_REQ, reg1_val);
+		cx_write(TC_REQ_SET, reg2_val);
+		cx_read(VID_B_DMA);
+		cx_read(VBI_B_DMA);
+		cx_read(VID_C_DMA);
+		cx_read(VBI_C_DMA);
+
+		dev_info(&dev->pci->dev,
+			"dma in progress detected 0x%08x 0x%08x, clearing\n",
+			reg1_val, reg2_val);
+	}
+}
+
 static void cx23885_shutdown(struct cx23885_dev *dev)
 {
 	/* disable RISC controller */
@@ -633,6 +652,7 @@ static void cx23885_shutdown(struct cx23885_dev *dev)
 
 static void cx23885_reset(struct cx23885_dev *dev)
 {
+	uint32_t reg;
 	dprintk(1, "%s()\n", __func__);
 
 	cx23885_shutdown(dev);
@@ -646,6 +666,8 @@ static void cx23885_reset(struct cx23885_dev *dev)
 	cx_write(CLK_DELAY, cx_read(CLK_DELAY) & 0x80000000);
 	cx_write(PAD_CTRL, 0x00500300);
 
+	/* clear dma in progress */
+	cx23885_clear_bridge_error(dev);
 	mdelay(100);
 
 	cx23885_sram_channel_setup(dev, &dev->sram_channels[SRAM_CH01],
@@ -662,6 +684,11 @@ static void cx23885_reset(struct cx23885_dev *dev)
 	cx23885_sram_channel_setup(dev, &dev->sram_channels[SRAM_CH09], 128, 0);
 
 	cx23885_gpio_setup(dev);
+
+	cx23885_irq_get_mask(dev);
+
+	/* clear dma in progress */
+	cx23885_clear_bridge_error(dev);
 }
 
 
@@ -676,6 +703,8 @@ static int cx23885_pci_quirks(struct cx23885_dev *dev)
 	if (dev->bridge == CX23885_BRIDGE_885)
 		cx_clear(RDR_TLCTL0, 1 << 4);
 
+	/* clear dma in progress */
+	cx23885_clear_bridge_error(dev);
 	return 0;
 }
 
@@ -1352,6 +1381,9 @@ int cx23885_start_dma(struct cx23885_tsport *port,
 	dprintk(1, "%s() w: %d, h: %d, f: %d\n", __func__,
 		dev->width, dev->height, dev->field);
 
+	/* clear dma in progress */
+	cx23885_clear_bridge_error(dev);
+
 	/* Stop the fifo and risc engine for this port */
 	cx_clear(port->reg_dma_ctl, port->dma_ctl_val);
 
@@ -1432,16 +1464,26 @@ int cx23885_start_dma(struct cx23885_tsport *port,
 	case CX23885_BRIDGE_888:
 		/* enable irqs */
 		dprintk(1, "%s() enabling TS int's and DMA\n", __func__);
+		/* clear dma in progress */
+		cx23885_clear_bridge_error(dev);
 		cx_set(port->reg_ts_int_msk,  port->ts_int_msk_val);
 		cx_set(port->reg_dma_ctl, port->dma_ctl_val);
+
+		/* clear dma in progress */
+		cx23885_clear_bridge_error(dev);
 		cx23885_irq_add(dev, port->pci_irqmask);
 		cx23885_irq_enable_all(dev);
+
+		/* clear dma in progress */
+		cx23885_clear_bridge_error(dev);
 		break;
 	default:
 		BUG();
 	}
 
 	cx_set(DEV_CNTRL2, (1<<5)); /* Enable RISC controller */
+	/* clear dma in progress */
+	cx23885_clear_bridge_error(dev);
 
 	if (cx23885_boards[dev->board].portb == CX23885_MPEG_ENCODER)
 		cx23885_av_clk(dev, 1);
@@ -1449,6 +1491,11 @@ int cx23885_start_dma(struct cx23885_tsport *port,
 	if (debug > 4)
 		cx23885_tsport_reg_dump(port);
 
+	cx23885_irq_get_mask(dev);
+
+	/* clear dma in progress */
+	cx23885_clear_bridge_error(dev);
+
 	return 0;
 }
 
@@ -1456,15 +1503,28 @@ static int cx23885_stop_dma(struct cx23885_tsport *port)
 {
 	struct cx23885_dev *dev = port->dev;
 	u32 reg;
+	int delay = 0;
+	uint32_t reg1_val;
+	uint32_t reg2_val;
 
 	dprintk(1, "%s()\n", __func__);
 
 	/* Stop interrupts and DMA */
 	cx_clear(port->reg_ts_int_msk, port->ts_int_msk_val);
 	cx_clear(port->reg_dma_ctl, port->dma_ctl_val);
+	/* just in case wait for any dma to complete before allowing dealloc */
+	mdelay(20);
+	for (delay = 0; delay < 100; delay++) {
+		reg1_val = cx_read(TC_REQ);
+		reg2_val = cx_read(TC_REQ_SET);
+		if (reg1_val == 0 || reg2_val == 0)
+			break;
+		mdelay(1);
+	}
+	dev_dbg(&dev->pci->dev, "delay=%d reg1=0x%08x reg2=0x%08x\n",
+		delay, reg1_val, reg2_val);
 
 	if (cx23885_boards[dev->board].portb == CX23885_MPEG_ENCODER) {
-
 		reg = cx_read(PAD_CTRL);
 
 		/* Set TS1_OE */
@@ -1475,7 +1535,6 @@ static int cx23885_stop_dma(struct cx23885_tsport *port)
 		cx_write(PAD_CTRL, reg);
 		cx_write(port->reg_src_sel, 0);
 		cx_write(port->reg_gen_ctrl, 8);
-
 	}
 
 	if (cx23885_boards[dev->board].portb == CX23885_MPEG_ENCODER)
diff --git a/drivers/media/pci/cx23885/cx23885-reg.h b/drivers/media/pci/cx23885/cx23885-reg.h
index 2d3cbaf..08cec8d 100644
--- a/drivers/media/pci/cx23885/cx23885-reg.h
+++ b/drivers/media/pci/cx23885/cx23885-reg.h
@@ -288,6 +288,18 @@ Channel manager Data Structure entry = 20 DWORD
 #define AUDIO_EXT_INT_MSTAT	0x00040068
 #define AUDIO_EXT_INT_SSTAT	0x0004006C
 
+/* Bits [7:0] set in both TC_REQ and TC_REQ_SET
+ * indicate a stall in the RISC engine for a
+ * particular rider traffic class. This causes
+ * the 885 and 888 bridges (unknown about 887)
+ * to become inoperable. Setting bits in
+ * TC_REQ_SET resets the corresponding bits
+ * in TC_REQ (and TC_REQ_SET) allowing
+ * operation to continue.
+ */
+#define TC_REQ		0x00040090
+#define TC_REQ_SET	0x00040094
+
 #define RDR_CFG0	0x00050000
 #define RDR_CFG1	0x00050004
 #define RDR_CFG2	0x00050008
@@ -386,6 +398,8 @@ Channel manager Data Structure entry = 20 DWORD
 #define VID_B_PIXEL_FRMT	0x00130184
 
 /* Video C Interface */
+#define VID_C_DMA		0x00130200
+#define VBI_C_DMA		0x00130208
 #define VID_C_GPCNT		0x00130220
 #define VID_C_GPCNT_CTL		0x00130230
 #define VBI_C_GPCNT_CTL		0x00130234
-- 
2.7.4
