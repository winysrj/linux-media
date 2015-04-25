Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud2.xs4all.net ([194.109.24.29]:50082 "EHLO
	lb3-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933521AbbDYPnd (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 25 Apr 2015 11:43:33 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCH 05/12] dt3155v4l: remove bogus single-frame capture in init_board
Date: Sat, 25 Apr 2015 17:42:44 +0200
Message-Id: <1429976571-34872-6-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1429976571-34872-1-git-send-email-hverkuil@xs4all.nl>
References: <1429976571-34872-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

For some weird reason an attempt is made in init_board to capture a
single frame. No clue why, and everything works fine without that
code.

I suspect this was test code that was never removed.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/staging/media/dt3155v4l/dt3155v4l.c | 41 +++++------------------------
 drivers/staging/media/dt3155v4l/dt3155v4l.h |  3 +++
 2 files changed, 10 insertions(+), 34 deletions(-)

diff --git a/drivers/staging/media/dt3155v4l/dt3155v4l.c b/drivers/staging/media/dt3155v4l/dt3155v4l.c
index 34836f6..28b649d 100644
--- a/drivers/staging/media/dt3155v4l/dt3155v4l.c
+++ b/drivers/staging/media/dt3155v4l/dt3155v4l.c
@@ -29,8 +29,6 @@
 
 #define DT3155_DEVICE_ID 0x1223
 
-#define DT3155_BUF_SIZE (768 * 576)
-
 #ifdef CONFIG_DT3155_STREAMING
 #define DT3155_CAPTURE_METHOD V4L2_CAP_STREAMING
 #else
@@ -645,16 +643,14 @@ static const struct v4l2_ioctl_ops dt3155_ioctl_ops = {
 static int dt3155_init_board(struct dt3155_priv *pd)
 {
 	struct pci_dev *pdev = pd->pdev;
-	void *buf_cpu;
-	dma_addr_t buf_dma;
 	int i;
-	u8 tmp;
+	u8 tmp = 0;
 
 	pci_set_master(pdev); /* dt3155 needs it */
 
 	/*  resetting the adapter  */
-	iowrite32(FLD_CRPT_ODD | FLD_CRPT_EVEN | FLD_DN_ODD | FLD_DN_EVEN,
-							pd->regs + CSR1);
+	iowrite32(ADDR_ERR_ODD | ADDR_ERR_EVEN | FLD_CRPT_ODD | FLD_CRPT_EVEN |
+			FLD_DN_ODD | FLD_DN_EVEN, pd->regs + CSR1);
 	mmiowb();
 	msleep(20);
 
@@ -710,33 +706,10 @@ static int dt3155_init_board(struct dt3155_priv *pd)
 	write_i2c_reg(pd->regs, AD_ADDR, AD_CMD_REG);
 	write_i2c_reg(pd->regs, AD_CMD, VIDEO_CNL_1 | SYNC_CNL_1 | SYNC_LVL_3);
 
-	/* allocate memory, and initialize the DMA machine */
-	buf_cpu = dma_alloc_coherent(&pdev->dev, DT3155_BUF_SIZE, &buf_dma,
-								GFP_KERNEL);
-	if (!buf_cpu)
-		return -ENOMEM;
-	iowrite32(buf_dma, pd->regs + EVEN_DMA_START);
-	iowrite32(buf_dma, pd->regs + ODD_DMA_START);
-	iowrite32(0, pd->regs + EVEN_DMA_STRIDE);
-	iowrite32(0, pd->regs + ODD_DMA_STRIDE);
-
-	/*  Perform a pseudo even field acquire    */
-	iowrite32(FIFO_EN | SRST | CAP_CONT_ODD, pd->regs + CSR1);
-	write_i2c_reg(pd->regs, CSR2, pd->csr2 | SYNC_SNTL);
-	write_i2c_reg(pd->regs, CONFIG, pd->config);
-	write_i2c_reg(pd->regs, EVEN_CSR, CSR_SNGL);
-	write_i2c_reg(pd->regs, CSR2, pd->csr2 | BUSY_EVEN | SYNC_SNTL);
-	msleep(100);
-	read_i2c_reg(pd->regs, CSR2, &tmp);
-	write_i2c_reg(pd->regs, EVEN_CSR, CSR_ERROR | CSR_SNGL | CSR_DONE);
-	write_i2c_reg(pd->regs, ODD_CSR, CSR_ERROR | CSR_SNGL | CSR_DONE);
-	write_i2c_reg(pd->regs, CSR2, pd->csr2);
-	iowrite32(FIFO_EN | SRST | FLD_DN_EVEN | FLD_DN_ODD, pd->regs + CSR1);
-
-	/*  deallocate memory  */
-	dma_free_coherent(&pdev->dev, DT3155_BUF_SIZE, buf_cpu, buf_dma);
-	if (tmp & BUSY_EVEN)
-		return -EIO;
+	/* disable all irqs, clear all irq flags */
+	iowrite32(FLD_START | FLD_END_EVEN | FLD_END_ODD,
+			pd->regs + INT_CSR);
+
 	return 0;
 }
 
diff --git a/drivers/staging/media/dt3155v4l/dt3155v4l.h b/drivers/staging/media/dt3155v4l/dt3155v4l.h
index 16faefe..3c8073a 100644
--- a/drivers/staging/media/dt3155v4l/dt3155v4l.h
+++ b/drivers/staging/media/dt3155v4l/dt3155v4l.h
@@ -74,7 +74,10 @@
 #define AD_NEG_REF   0x02
 
 /* CSR1 bit masks */
+#define RANGE_EN       0x00008000
 #define CRPT_DIS       0x00004000
+#define ADDR_ERR_ODD   0x00000800
+#define ADDR_ERR_EVEN  0x00000400
 #define FLD_CRPT_ODD   0x00000200
 #define FLD_CRPT_EVEN  0x00000100
 #define FIFO_EN        0x00000080
-- 
2.1.4

