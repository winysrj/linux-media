Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.18]:35925 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727266AbeJUWAO (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Sun, 21 Oct 2018 18:00:14 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date: Sun, 21 Oct 2018 15:45:39 +0200
From: Markus Dobel <markus.dobel@gmx.de>
To: Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-media@vger.kernel.org, Brad Love <brad@nextdimension.cc>
Subject: [PATCH] Revert 95f408bb Ryzen DMA related RiSC engine stall fixes
Message-ID: <3d7393a6287db137a69c4d05785522d5@gmx.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The original commit (the one reverted in this patch) introduced a 
regression,
making a previously flawless adapter unresponsive after running a few 
hours
to days. Since I never experienced the problems that the original commit 
is
supposed to fix, I propose to revert the change until a regression-free
variant is found.

Before submitting this, I've been running a system 24x7 with this revert 
for
several weeks now, and it's running stable again.

It's not a pure revert, as the original commit does not revert cleanly
anymore due to other changes, but content-wise it is.

Signed-off-by: Markus Dobel <markus.dobel@gmx.de>
---
  drivers/media/pci/cx23885/cx23885-core.c | 60 ------------------------
  drivers/media/pci/cx23885/cx23885-reg.h  | 14 ------
  2 files changed, 74 deletions(-)

diff --git a/drivers/media/pci/cx23885/cx23885-core.c 
b/drivers/media/pci/cx23885/cx23885-core.c
index 39804d830305..606f6fc0e68b 100644
--- a/drivers/media/pci/cx23885/cx23885-core.c
+++ b/drivers/media/pci/cx23885/cx23885-core.c
@@ -601,25 +601,6 @@ static void cx23885_risc_disasm(struct 
cx23885_tsport *port,
  	}
  }

-static void cx23885_clear_bridge_error(struct cx23885_dev *dev)
-{
-	uint32_t reg1_val = cx_read(TC_REQ); /* read-only */
-	uint32_t reg2_val = cx_read(TC_REQ_SET);
-
-	if (reg1_val && reg2_val) {
-		cx_write(TC_REQ, reg1_val);
-		cx_write(TC_REQ_SET, reg2_val);
-		cx_read(VID_B_DMA);
-		cx_read(VBI_B_DMA);
-		cx_read(VID_C_DMA);
-		cx_read(VBI_C_DMA);
-
-		dev_info(&dev->pci->dev,
-			"dma in progress detected 0x%08x 0x%08x, clearing\n",
-			reg1_val, reg2_val);
-	}
-}
-
  static void cx23885_shutdown(struct cx23885_dev *dev)
  {
  	/* disable RISC controller */
@@ -665,8 +646,6 @@ static void cx23885_reset(struct cx23885_dev *dev)
  	cx_write(CLK_DELAY, cx_read(CLK_DELAY) & 0x80000000);
  	cx_write(PAD_CTRL, 0x00500300);

-	/* clear dma in progress */
-	cx23885_clear_bridge_error(dev);
  	msleep(100);

  	cx23885_sram_channel_setup(dev, &dev->sram_channels[SRAM_CH01],
@@ -683,11 +662,6 @@ static void cx23885_reset(struct cx23885_dev *dev)
  	cx23885_sram_channel_setup(dev, &dev->sram_channels[SRAM_CH09], 128, 
0);

  	cx23885_gpio_setup(dev);
-
-	cx23885_irq_get_mask(dev);
-
-	/* clear dma in progress */
-	cx23885_clear_bridge_error(dev);
  }


@@ -702,8 +676,6 @@ static int cx23885_pci_quirks(struct cx23885_dev 
*dev)
  	if (dev->bridge == CX23885_BRIDGE_885)
  		cx_clear(RDR_TLCTL0, 1 << 4);

-	/* clear dma in progress */
-	cx23885_clear_bridge_error(dev);
  	return 0;
  }

@@ -1392,9 +1364,6 @@ int cx23885_start_dma(struct cx23885_tsport *port,
  	dprintk(1, "%s() w: %d, h: %d, f: %d\n", __func__,
  		dev->width, dev->height, dev->field);

-	/* clear dma in progress */
-	cx23885_clear_bridge_error(dev);
-
  	/* Stop the fifo and risc engine for this port */
  	cx_clear(port->reg_dma_ctl, port->dma_ctl_val);

@@ -1482,26 +1451,16 @@ int cx23885_start_dma(struct cx23885_tsport 
*port,
  	case CX23885_BRIDGE_888:
  		/* enable irqs */
  		dprintk(1, "%s() enabling TS int's and DMA\n", __func__);
-		/* clear dma in progress */
-		cx23885_clear_bridge_error(dev);
  		cx_set(port->reg_ts_int_msk,  port->ts_int_msk_val);
  		cx_set(port->reg_dma_ctl, port->dma_ctl_val);
-
-		/* clear dma in progress */
-		cx23885_clear_bridge_error(dev);
  		cx23885_irq_add(dev, port->pci_irqmask);
  		cx23885_irq_enable_all(dev);
-
-		/* clear dma in progress */
-		cx23885_clear_bridge_error(dev);
  		break;
  	default:
  		BUG();
  	}

  	cx_set(DEV_CNTRL2, (1<<5)); /* Enable RISC controller */
-	/* clear dma in progress */
-	cx23885_clear_bridge_error(dev);

  	if (cx23885_boards[dev->board].portb == CX23885_MPEG_ENCODER)
  		cx23885_av_clk(dev, 1);
@@ -1509,11 +1468,6 @@ int cx23885_start_dma(struct cx23885_tsport 
*port,
  	if (debug > 4)
  		cx23885_tsport_reg_dump(port);

-	cx23885_irq_get_mask(dev);
-
-	/* clear dma in progress */
-	cx23885_clear_bridge_error(dev);
-
  	return 0;
  }

@@ -1521,26 +1475,12 @@ static int cx23885_stop_dma(struct 
cx23885_tsport *port)
  {
  	struct cx23885_dev *dev = port->dev;
  	u32 reg;
-	int delay = 0;
-	uint32_t reg1_val;
-	uint32_t reg2_val;

  	dprintk(1, "%s()\n", __func__);

  	/* Stop interrupts and DMA */
  	cx_clear(port->reg_ts_int_msk, port->ts_int_msk_val);
  	cx_clear(port->reg_dma_ctl, port->dma_ctl_val);
-	/* just in case wait for any dma to complete before allowing dealloc 
*/
-	mdelay(20);
-	for (delay = 0; delay < 100; delay++) {
-		reg1_val = cx_read(TC_REQ);
-		reg2_val = cx_read(TC_REQ_SET);
-		if (reg1_val == 0 || reg2_val == 0)
-			break;
-		mdelay(1);
-	}
-	dev_dbg(&dev->pci->dev, "delay=%d reg1=0x%08x reg2=0x%08x\n",
-		delay, reg1_val, reg2_val);

  	if (cx23885_boards[dev->board].portb == CX23885_MPEG_ENCODER) {
  		reg = cx_read(PAD_CTRL);
diff --git a/drivers/media/pci/cx23885/cx23885-reg.h 
b/drivers/media/pci/cx23885/cx23885-reg.h
index 08cec8d91742..2d3cbafe2402 100644
--- a/drivers/media/pci/cx23885/cx23885-reg.h
+++ b/drivers/media/pci/cx23885/cx23885-reg.h
@@ -288,18 +288,6 @@ Channel manager Data Structure entry = 20 DWORD
  #define AUDIO_EXT_INT_MSTAT	0x00040068
  #define AUDIO_EXT_INT_SSTAT	0x0004006C

-/* Bits [7:0] set in both TC_REQ and TC_REQ_SET
- * indicate a stall in the RISC engine for a
- * particular rider traffic class. This causes
- * the 885 and 888 bridges (unknown about 887)
- * to become inoperable. Setting bits in
- * TC_REQ_SET resets the corresponding bits
- * in TC_REQ (and TC_REQ_SET) allowing
- * operation to continue.
- */
-#define TC_REQ		0x00040090
-#define TC_REQ_SET	0x00040094
-
  #define RDR_CFG0	0x00050000
  #define RDR_CFG1	0x00050004
  #define RDR_CFG2	0x00050008
@@ -398,8 +386,6 @@ Channel manager Data Structure entry = 20 DWORD
  #define VID_B_PIXEL_FRMT	0x00130184

  /* Video C Interface */
-#define VID_C_DMA		0x00130200
-#define VBI_C_DMA		0x00130208
  #define VID_C_GPCNT		0x00130220
  #define VID_C_GPCNT_CTL		0x00130230
  #define VBI_C_GPCNT_CTL		0x00130234
-- 
2.17.2
