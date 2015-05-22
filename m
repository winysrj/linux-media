Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud3.xs4all.net ([194.109.24.22]:51875 "EHLO
	lb1-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757123AbbEVOAL (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 22 May 2015 10:00:11 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCH 08/11] cobalt: fix sparse warnings
Date: Fri, 22 May 2015 15:59:41 +0200
Message-Id: <1432303184-8594-9-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1432303184-8594-1-git-send-email-hverkuil@xs4all.nl>
References: <1432303184-8594-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

drivers/media/pci/cobalt/cobalt-i2c.c:130:17: warning: dereference of noderef expression
drivers/media/pci/cobalt/cobalt-i2c.c:147:17: warning: dereference of noderef expression
drivers/media/pci/cobalt/cobalt-i2c.c:151:26: warning: dereference of noderef expression
drivers/media/pci/cobalt/cobalt-i2c.c:156:34: warning: dereference of noderef expression
drivers/media/pci/cobalt/cobalt-i2c.c:206:17: warning: dereference of noderef expression
drivers/media/pci/cobalt/cobalt-i2c.c:210:26: warning: dereference of noderef expression
drivers/media/pci/cobalt/cobalt-i2c.c:215:34: warning: dereference of noderef expression
drivers/media/pci/cobalt/cobalt-i2c.c:225:27: warning: dereference of noderef expression
drivers/media/pci/cobalt/cobalt-i2c.c:335:17: warning: dereference of noderef expression
drivers/media/pci/cobalt/cobalt-i2c.c:336:17: warning: dereference of noderef expression
drivers/media/pci/cobalt/cobalt-i2c.c:337:17: warning: dereference of noderef expression
drivers/media/pci/cobalt/cobalt-i2c.c:348:34: warning: dereference of noderef expression
drivers/media/pci/cobalt/cobalt-i2c.c:352:17: warning: dereference of noderef expression
drivers/media/pci/cobalt/cobalt-i2c.c:353:17: warning: dereference of noderef expression
drivers/media/pci/cobalt/cobalt-i2c.c:356:17: warning: dereference of noderef expression
drivers/media/pci/cobalt/cobalt-i2c.c:357:17: warning: dereference of noderef expression
drivers/media/pci/cobalt/cobalt-i2c.c:359:17: warning: dereference of noderef expression

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/pci/cobalt/cobalt-driver.h |  2 +-
 drivers/media/pci/cobalt/cobalt-i2c.c    | 56 ++++++++++++++++----------------
 2 files changed, 29 insertions(+), 29 deletions(-)

diff --git a/drivers/media/pci/cobalt/cobalt-driver.h b/drivers/media/pci/cobalt/cobalt-driver.h
index 3d9a9ffb..f63ce19 100644
--- a/drivers/media/pci/cobalt/cobalt-driver.h
+++ b/drivers/media/pci/cobalt/cobalt-driver.h
@@ -177,7 +177,7 @@ struct cobalt_i2c_regs;
 /* Per I2C bus private algo callback data */
 struct cobalt_i2c_data {
 	struct cobalt *cobalt;
-	volatile struct cobalt_i2c_regs __iomem *regs;
+	struct cobalt_i2c_regs __iomem *regs;
 };
 
 struct pci_consistent_buffer {
diff --git a/drivers/media/pci/cobalt/cobalt-i2c.c b/drivers/media/pci/cobalt/cobalt-i2c.c
index 57b330f..ad16b89 100644
--- a/drivers/media/pci/cobalt/cobalt-i2c.c
+++ b/drivers/media/pci/cobalt/cobalt-i2c.c
@@ -90,25 +90,25 @@ struct cobalt_i2c_regs {
 #define I2C_FREQUENCY			400000
 #define ALT_CPU_FREQ			83333333
 
-static volatile struct cobalt_i2c_regs __iomem *
+static struct cobalt_i2c_regs __iomem *
 cobalt_i2c_regs(struct cobalt *cobalt, unsigned idx)
 {
 	switch (idx) {
 	case 0:
 	default:
-		return (volatile struct cobalt_i2c_regs __iomem *)
+		return (struct cobalt_i2c_regs __iomem *)
 			(cobalt->bar1 + COBALT_I2C_0_BASE);
 	case 1:
-		return (volatile struct cobalt_i2c_regs __iomem *)
+		return (struct cobalt_i2c_regs __iomem *)
 			(cobalt->bar1 + COBALT_I2C_1_BASE);
 	case 2:
-		return (volatile struct cobalt_i2c_regs __iomem *)
+		return (struct cobalt_i2c_regs __iomem *)
 			(cobalt->bar1 + COBALT_I2C_2_BASE);
 	case 3:
-		return (volatile struct cobalt_i2c_regs __iomem *)
+		return (struct cobalt_i2c_regs __iomem *)
 			(cobalt->bar1 + COBALT_I2C_3_BASE);
 	case 4:
-		return (volatile struct cobalt_i2c_regs __iomem *)
+		return (struct cobalt_i2c_regs __iomem *)
 			(cobalt->bar1 + COBALT_I2C_HSMA_BASE);
 	}
 }
@@ -116,7 +116,7 @@ cobalt_i2c_regs(struct cobalt *cobalt, unsigned idx)
 /* Do low-level i2c byte transfer.
  * Returns -1 in case of an error or 0 otherwise.
  */
-static int cobalt_tx_bytes(volatile struct cobalt_i2c_regs __iomem *regs,
+static int cobalt_tx_bytes(struct cobalt_i2c_regs __iomem *regs,
 		struct i2c_adapter *adap, bool start, bool stop,
 		u8 *data, u16 len)
 {
@@ -127,7 +127,7 @@ static int cobalt_tx_bytes(volatile struct cobalt_i2c_regs __iomem *regs,
 
 	for (i = 0; i < len; i++) {
 		/* Setup data */
-		regs->txr_rxr = data[i];
+		iowrite8(data[i], &regs->txr_rxr);
 
 		/* Setup command */
 		if (i == 0 && start != 0) {
@@ -144,16 +144,16 @@ static int cobalt_tx_bytes(volatile struct cobalt_i2c_regs __iomem *regs,
 		}
 
 		/* Execute command */
-		regs->cr_sr = cmd;
+		iowrite8(cmd, &regs->cr_sr);
 
 		/* Wait for transfer to complete (TIP = 0) */
 		start_time = jiffies;
-		status = regs->cr_sr;
+		status = ioread8(&regs->cr_sr);
 		while (status & M00018_SR_BITMAP_TIP_MSK) {
 			if (time_after(jiffies, start_time + adap->timeout))
 				return -ETIMEDOUT;
 			cond_resched();
-			status = regs->cr_sr;
+			status = ioread8(&regs->cr_sr);
 		}
 
 		/* Verify ACK */
@@ -174,7 +174,7 @@ static int cobalt_tx_bytes(volatile struct cobalt_i2c_regs __iomem *regs,
 /* Do low-level i2c byte read.
  * Returns -1 in case of an error or 0 otherwise.
  */
-static int cobalt_rx_bytes(volatile struct cobalt_i2c_regs __iomem *regs,
+static int cobalt_rx_bytes(struct cobalt_i2c_regs __iomem *regs,
 		struct i2c_adapter *adap, bool start, bool stop,
 		u8 *data, u16 len)
 {
@@ -203,16 +203,16 @@ static int cobalt_rx_bytes(volatile struct cobalt_i2c_regs __iomem *regs,
 			cmd |= M00018_CR_BITMAP_ACK_MSK;
 
 		/* Execute command */
-		regs->cr_sr = cmd;
+		iowrite8(cmd, &regs->cr_sr);
 
 		/* Wait for transfer to complete (TIP = 0) */
 		start_time = jiffies;
-		status = regs->cr_sr;
+		status = ioread8(&regs->cr_sr);
 		while (status & M00018_SR_BITMAP_TIP_MSK) {
 			if (time_after(jiffies, start_time + adap->timeout))
 				return -ETIMEDOUT;
 			cond_resched();
-			status = regs->cr_sr;
+			status = ioread8(&regs->cr_sr);
 		}
 
 		/* Verify arbitration */
@@ -222,7 +222,7 @@ static int cobalt_rx_bytes(volatile struct cobalt_i2c_regs __iomem *regs,
 		}
 
 		/* Store data */
-		data[i] = regs->txr_rxr;
+		data[i] = ioread8(&regs->txr_rxr);
 	}
 	return 0;
 }
@@ -231,7 +231,7 @@ static int cobalt_rx_bytes(volatile struct cobalt_i2c_regs __iomem *regs,
  * The m00018 stop isn't doing the right thing (wrong timing).
  * So instead send a start condition, 8 zeroes and a stop condition.
  */
-static int cobalt_stop(volatile struct cobalt_i2c_regs __iomem *regs,
+static int cobalt_stop(struct cobalt_i2c_regs __iomem *regs,
 		struct i2c_adapter *adap)
 {
 	u8 data = 0;
@@ -243,7 +243,7 @@ static int cobalt_xfer(struct i2c_adapter *adap,
 			struct i2c_msg msgs[], int num)
 {
 	struct cobalt_i2c_data *data = adap->algo_data;
-	volatile struct cobalt_i2c_regs __iomem *regs = data->regs;
+	struct cobalt_i2c_regs __iomem *regs = data->regs;
 	struct i2c_msg *pmsg;
 	unsigned short flags;
 	int ret = 0;
@@ -327,14 +327,14 @@ int cobalt_i2c_init(struct cobalt *cobalt)
 	prescale = ((ALT_CPU_FREQ) / (5 * I2C_FREQUENCY)) - 1;
 
 	for (i = 0; i < COBALT_NUM_ADAPTERS; i++) {
-		volatile struct cobalt_i2c_regs __iomem *regs =
+		struct cobalt_i2c_regs __iomem *regs =
 			cobalt_i2c_regs(cobalt, i);
 		struct i2c_adapter *adap = &cobalt->i2c_adap[i];
 
 		/* Disable I2C */
-		regs->cr_sr = M00018_CTR_BITMAP_EN_MSK;
-		regs->ctr = 0;
-		regs->cr_sr = 0;
+		iowrite8(M00018_CTR_BITMAP_EN_MSK, &regs->cr_sr);
+		iowrite8(0, &regs->ctr);
+		iowrite8(0, &regs->cr_sr);
 
 		start_time = jiffies;
 		do {
@@ -345,18 +345,18 @@ int cobalt_i2c_init(struct cobalt *cobalt)
 				}
 				return -ETIMEDOUT;
 			}
-			status = regs->cr_sr;
+			status = ioread8(&regs->cr_sr);
 		} while (status & M00018_SR_BITMAP_TIP_MSK);
 
 		/* Disable I2C */
-		regs->ctr = 0;
-		regs->cr_sr = 0;
+		iowrite8(0, &regs->ctr);
+		iowrite8(0, &regs->cr_sr);
 
 		/* Calculate i2c prescaler */
-		regs->prerlo = prescale & 0xff;
-		regs->prerhi = (prescale >> 8) & 0xff;
+		iowrite8(prescale & 0xff, &regs->prerlo);
+		iowrite8((prescale >> 8) & 0xff, &regs->prerhi);
 		/* Enable I2C, interrupts disabled */
-		regs->ctr = M00018_CTR_BITMAP_EN_MSK;
+		iowrite8(M00018_CTR_BITMAP_EN_MSK, &regs->ctr);
 		/* Setup algorithm for adapter */
 		cobalt->i2c_data[i].cobalt = cobalt;
 		cobalt->i2c_data[i].regs = regs;
-- 
2.1.4

