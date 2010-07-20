Return-path: <linux-media-owner@vger.kernel.org>
Received: from proofpoint-cluster.metrocast.net ([65.175.128.136]:32186 "EHLO
	proofpoint-cluster.metrocast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758090Ab0GTBYh (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 19 Jul 2010 21:24:37 -0400
Subject: [PATCH 15/17] cx23885: Protect PCI interrupt mask manipulations
 with a spinlock
From: Andy Walls <awalls@md.metrocast.net>
To: linux-media@vger.kernel.org
Cc: Kenney Phillisjr <kphillisjr@gmail.com>,
	Steven Toth <stoth@kernellabs.com>,
	"Igor M.Liplianin" <liplianin@me.by>
In-Reply-To: <cover.1279586511.git.awalls@md.metrocast.net>
References: <cover.1279586511.git.awalls@md.metrocast.net>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 19 Jul 2010 21:25:11 -0400
Message-ID: <1279589111.31145.13.camel@localhost>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch encapsulates access to the PCI_INT_MSK register and
dev->pci_irqmask variable and protects them with a spinlock.
This is needed because both the hard IRQ handler and a workhandler
will need to manipulate the mask to disable the AV_CORE interrupt.

Signed-off-by: Andy Walls <awalls@md.metrocast.net>
---
 drivers/media/video/cx23885/cx23885-cards.c |   17 ++---
 drivers/media/video/cx23885/cx23885-core.c  |   94 +++++++++++++++++++++++++--
 drivers/media/video/cx23885/cx23885-vbi.c   |    2 +-
 drivers/media/video/cx23885/cx23885-video.c |    7 +-
 drivers/media/video/cx23885/cx23885.h       |    5 ++
 5 files changed, 103 insertions(+), 22 deletions(-)

diff --git a/drivers/media/video/cx23885/cx23885-cards.c b/drivers/media/video/cx23885/cx23885-cards.c
index 5c11caf..b8ad935 100644
--- a/drivers/media/video/cx23885/cx23885-cards.c
+++ b/drivers/media/video/cx23885/cx23885-cards.c
@@ -972,7 +972,6 @@ int cx23885_ir_init(struct cx23885_dev *dev)
 		dev->sd_ir = cx23885_find_hw(dev, CX23885_HW_888_IR);
 		v4l2_subdev_call(dev->sd_cx25840, core, s_io_pin_config,
 				 ir_rxtx_pin_cfg_count, ir_rxtx_pin_cfg);
-		dev->pci_irqmask |= PCI_MSK_IR;
 		/*
 		 * For these boards we need to invert the Tx output via the
 		 * IR controller to have the LED off while idle
@@ -993,7 +992,6 @@ int cx23885_ir_init(struct cx23885_dev *dev)
 		}
 		v4l2_subdev_call(dev->sd_cx25840, core, s_io_pin_config,
 				 ir_rx_pin_cfg_count, ir_rx_pin_cfg);
-		dev->pci_irqmask |= PCI_MSK_AV_CORE;
 		break;
 	case CX23885_BOARD_HAUPPAUGE_HVR1250:
 		dev->sd_ir = cx23885_find_hw(dev, CX23885_HW_AV_CORE);
@@ -1003,7 +1001,6 @@ int cx23885_ir_init(struct cx23885_dev *dev)
 		}
 		v4l2_subdev_call(dev->sd_cx25840, core, s_io_pin_config,
 				 ir_rxtx_pin_cfg_count, ir_rxtx_pin_cfg);
-		dev->pci_irqmask |= PCI_MSK_AV_CORE;
 		break;
 	case CX23885_BOARD_DVICO_FUSIONHDTV_DVB_T_DUAL_EXP:
 		request_module("ir-kbd-i2c");
@@ -1018,15 +1015,13 @@ void cx23885_ir_fini(struct cx23885_dev *dev)
 	switch (dev->board) {
 	case CX23885_BOARD_HAUPPAUGE_HVR1850:
 	case CX23885_BOARD_HAUPPAUGE_HVR1290:
-		dev->pci_irqmask &= ~PCI_MSK_IR;
-		cx_clear(PCI_INT_MSK, PCI_MSK_IR);
+		cx23885_irq_remove(dev, PCI_MSK_IR);
 		cx23888_ir_remove(dev);
 		dev->sd_ir = NULL;
 		break;
 	case CX23885_BOARD_TEVII_S470:
 	case CX23885_BOARD_HAUPPAUGE_HVR1250:
-		dev->pci_irqmask &= ~PCI_MSK_AV_CORE;
-		cx_clear(PCI_INT_MSK, PCI_MSK_AV_CORE);
+		cx23885_irq_remove(dev, PCI_MSK_AV_CORE);
 		/* sd_ir is a duplicate pointer to the AV Core, just clear it */
 		dev->sd_ir = NULL;
 		break;
@@ -1038,13 +1033,13 @@ void cx23885_ir_pci_int_enable(struct cx23885_dev *dev)
 	switch (dev->board) {
 	case CX23885_BOARD_HAUPPAUGE_HVR1850:
 	case CX23885_BOARD_HAUPPAUGE_HVR1290:
-		if (dev->sd_ir && (dev->pci_irqmask & PCI_MSK_IR))
-			cx_set(PCI_INT_MSK, PCI_MSK_IR);
+		if (dev->sd_ir)
+			cx23885_irq_add_enable(dev, PCI_MSK_IR);
 		break;
 	case CX23885_BOARD_TEVII_S470:
 	case CX23885_BOARD_HAUPPAUGE_HVR1250:
-		if (dev->sd_ir && (dev->pci_irqmask & PCI_MSK_AV_CORE))
-			cx_set(PCI_INT_MSK, PCI_MSK_AV_CORE);
+		if (dev->sd_ir)
+			cx23885_irq_add_enable(dev, PCI_MSK_AV_CORE);
 		break;
 	}
 }
diff --git a/drivers/media/video/cx23885/cx23885-core.c b/drivers/media/video/cx23885/cx23885-core.c
index f912be2..fa2f4b1 100644
--- a/drivers/media/video/cx23885/cx23885-core.c
+++ b/drivers/media/video/cx23885/cx23885-core.c
@@ -299,6 +299,83 @@ static struct sram_channel cx23887_sram_channels[] = {
 	},
 };
 
+void cx23885_irq_add(struct cx23885_dev *dev, u32 mask)
+{
+	unsigned long flags;
+	spin_lock_irqsave(&dev->pci_irqmask_lock, flags);
+
+	dev->pci_irqmask |= mask;
+
+	spin_unlock_irqrestore(&dev->pci_irqmask_lock, flags);
+}
+
+void cx23885_irq_add_enable(struct cx23885_dev *dev, u32 mask)
+{
+	unsigned long flags;
+	spin_lock_irqsave(&dev->pci_irqmask_lock, flags);
+
+	dev->pci_irqmask |= mask;
+	cx_set(PCI_INT_MSK, mask);
+
+	spin_unlock_irqrestore(&dev->pci_irqmask_lock, flags);
+}
+
+void cx23885_irq_enable(struct cx23885_dev *dev, u32 mask)
+{
+	u32 v;
+	unsigned long flags;
+	spin_lock_irqsave(&dev->pci_irqmask_lock, flags);
+
+	v = mask & dev->pci_irqmask;
+	if (v)
+		cx_set(PCI_INT_MSK, v);
+
+	spin_unlock_irqrestore(&dev->pci_irqmask_lock, flags);
+}
+
+static inline void cx23885_irq_enable_all(struct cx23885_dev *dev)
+{
+	cx23885_irq_enable(dev, 0xffffffff);
+}
+
+void cx23885_irq_disable(struct cx23885_dev *dev, u32 mask)
+{
+	unsigned long flags;
+	spin_lock_irqsave(&dev->pci_irqmask_lock, flags);
+
+	cx_clear(PCI_INT_MSK, mask);
+
+	spin_unlock_irqrestore(&dev->pci_irqmask_lock, flags);
+}
+
+static inline void cx23885_irq_disable_all(struct cx23885_dev *dev)
+{
+	cx23885_irq_disable(dev, 0xffffffff);
+}
+
+void cx23885_irq_remove(struct cx23885_dev *dev, u32 mask)
+{
+	unsigned long flags;
+	spin_lock_irqsave(&dev->pci_irqmask_lock, flags);
+
+	dev->pci_irqmask &= ~mask;
+	cx_clear(PCI_INT_MSK, mask);
+
+	spin_unlock_irqrestore(&dev->pci_irqmask_lock, flags);
+}
+
+static u32 cx23885_irq_get_mask(struct cx23885_dev *dev)
+{
+	u32 v;
+	unsigned long flags;
+	spin_lock_irqsave(&dev->pci_irqmask_lock, flags);
+
+	v = cx_read(PCI_INT_MSK);
+
+	spin_unlock_irqrestore(&dev->pci_irqmask_lock, flags);
+	return v;
+}
+
 static int cx23885_risc_decode(u32 risc)
 {
 	static char *instr[16] = {
@@ -548,7 +625,7 @@ static void cx23885_shutdown(struct cx23885_dev *dev)
 	cx_write(UART_CTL, 0);
 
 	/* Disable Interrupts */
-	cx_write(PCI_INT_MSK, 0);
+	cx23885_irq_disable_all(dev);
 	cx_write(VID_A_INT_MSK, 0);
 	cx_write(VID_B_INT_MSK, 0);
 	cx_write(VID_C_INT_MSK, 0);
@@ -774,6 +851,8 @@ static int cx23885_dev_setup(struct cx23885_dev *dev)
 {
 	int i;
 
+	spin_lock_init(&dev->pci_irqmask_lock);
+
 	mutex_init(&dev->lock);
 	mutex_init(&dev->gpio_lock);
 
@@ -820,9 +899,9 @@ static int cx23885_dev_setup(struct cx23885_dev *dev)
 
 	dev->pci_bus  = dev->pci->bus->number;
 	dev->pci_slot = PCI_SLOT(dev->pci->devfn);
-	dev->pci_irqmask = 0x001f00;
+	cx23885_irq_add(dev, 0x001f00);
 	if (cx23885_boards[dev->board].cimax > 0)
-		dev->pci_irqmask |= 0x01800000; /* for CiMaxes */
+		cx23885_irq_add(dev, 0x01800000); /* for CiMaxes */
 
 	/* External Master 1 Bus */
 	dev->i2c_bus[0].nr = 0;
@@ -1156,7 +1235,7 @@ static void cx23885_tsport_reg_dump(struct cx23885_tsport *port)
 	dprintk(1, "%s() DEV_CNTRL2               0x%08X\n", __func__,
 		cx_read(DEV_CNTRL2));
 	dprintk(1, "%s() PCI_INT_MSK              0x%08X\n", __func__,
-		cx_read(PCI_INT_MSK));
+		cx23885_irq_get_mask(dev));
 	dprintk(1, "%s() AUD_INT_INT_MSK          0x%08X\n", __func__,
 		cx_read(AUDIO_INT_INT_MSK));
 	dprintk(1, "%s() AUD_INT_DMA_CTL          0x%08X\n", __func__,
@@ -1292,7 +1371,8 @@ static int cx23885_start_dma(struct cx23885_tsport *port,
 		dprintk(1, "%s() enabling TS int's and DMA\n", __func__);
 		cx_set(port->reg_ts_int_msk,  port->ts_int_msk_val);
 		cx_set(port->reg_dma_ctl, port->dma_ctl_val);
-		cx_set(PCI_INT_MSK, dev->pci_irqmask | port->pci_irqmask);
+		cx23885_irq_add(dev, port->pci_irqmask);
+		cx23885_irq_enable_all(dev);
 		break;
 	default:
 		BUG();
@@ -1653,7 +1733,7 @@ static irqreturn_t cx23885_irq(int irq, void *dev_id)
 	bool subdev_handled;
 
 	pci_status = cx_read(PCI_INT_STAT);
-	pci_mask = cx_read(PCI_INT_MSK);
+	pci_mask = cx23885_irq_get_mask(dev);
 	vida_status = cx_read(VID_A_INT_STAT);
 	vida_mask = cx_read(VID_A_INT_MSK);
 	ts1_status = cx_read(VID_B_INT_STAT);
@@ -1977,7 +2057,7 @@ static int __devinit cx23885_initdev(struct pci_dev *pci_dev,
 
 	switch (dev->board) {
 	case CX23885_BOARD_NETUP_DUAL_DVBS2_CI:
-		cx_set(PCI_INT_MSK, 0x01800000); /* for NetUP */
+		cx23885_irq_add_enable(dev, 0x01800000); /* for NetUP */
 		break;
 	}
 
diff --git a/drivers/media/video/cx23885/cx23885-vbi.c b/drivers/media/video/cx23885/cx23885-vbi.c
index 708a8c7..c0b6038 100644
--- a/drivers/media/video/cx23885/cx23885-vbi.c
+++ b/drivers/media/video/cx23885/cx23885-vbi.c
@@ -74,7 +74,7 @@ static int cx23885_start_vbi_dma(struct cx23885_dev    *dev,
 	q->count = 1;
 
 	/* enable irqs */
-	cx_set(PCI_INT_MSK, cx_read(PCI_INT_MSK) | 0x01);
+	cx23885_irq_add_enable(dev, 0x01);
 	cx_set(VID_A_INT_MSK, 0x000022);
 
 	/* start dma */
diff --git a/drivers/media/video/cx23885/cx23885-video.c b/drivers/media/video/cx23885/cx23885-video.c
index 2519455..da66e5f 100644
--- a/drivers/media/video/cx23885/cx23885-video.c
+++ b/drivers/media/video/cx23885/cx23885-video.c
@@ -441,7 +441,7 @@ static int cx23885_start_video_dma(struct cx23885_dev *dev,
 	q->count = 1;
 
 	/* enable irq */
-	cx_set(PCI_INT_MSK, cx_read(PCI_INT_MSK) | 0x01);
+	cx23885_irq_add_enable(dev, 0x01);
 	cx_set(VID_A_INT_MSK, 0x000011);
 
 	/* start dma */
@@ -1465,7 +1465,7 @@ static const struct v4l2_file_operations radio_fops = {
 void cx23885_video_unregister(struct cx23885_dev *dev)
 {
 	dprintk(1, "%s()\n", __func__);
-	cx_clear(PCI_INT_MSK, 1);
+	cx23885_irq_remove(dev, 0x01);
 
 	if (dev->video_dev) {
 		if (video_is_registered(dev->video_dev))
@@ -1502,7 +1502,8 @@ int cx23885_video_register(struct cx23885_dev *dev)
 		VID_A_DMA_CTL, 0x11, 0x00);
 
 	/* Don't enable VBI yet */
-	cx_set(PCI_INT_MSK, 1);
+
+	cx23885_irq_add_enable(dev, 0x01);
 
 	if (TUNER_ABSENT != dev->tuner_type) {
 		struct v4l2_subdev *sd = NULL;
diff --git a/drivers/media/video/cx23885/cx23885.h b/drivers/media/video/cx23885/cx23885.h
index 460f430..5bf6ed0 100644
--- a/drivers/media/video/cx23885/cx23885.h
+++ b/drivers/media/video/cx23885/cx23885.h
@@ -325,6 +325,7 @@ struct cx23885_dev {
 	u32                        __iomem *lmmio;
 	u8                         __iomem *bmmio;
 	int                        pci_irqmask;
+	spinlock_t		   pci_irqmask_lock; /* protects mask reg too */
 	int                        hwrevision;
 
 	/* This valud is board specific and is used to configure the
@@ -485,6 +486,10 @@ extern u32 cx23885_gpio_get(struct cx23885_dev *dev, u32 mask);
 extern void cx23885_gpio_enable(struct cx23885_dev *dev, u32 mask,
 	int asoutput);
 
+extern void cx23885_irq_add_enable(struct cx23885_dev *dev, u32 mask);
+extern void cx23885_irq_enable(struct cx23885_dev *dev, u32 mask);
+extern void cx23885_irq_disable(struct cx23885_dev *dev, u32 mask);
+extern void cx23885_irq_remove(struct cx23885_dev *dev, u32 mask);
 
 /* ----------------------------------------------------------- */
 /* cx23885-cards.c                                             */
-- 
1.7.1.1


