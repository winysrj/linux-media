Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga07.intel.com ([134.134.136.100]:48861 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1755523AbeDYQjL (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 25 Apr 2018 12:39:11 -0400
From: Yong Zhi <yong.zhi@intel.com>
To: linux-media@vger.kernel.org, sakari.ailus@linux.intel.com
Cc: tfiga@chromium.org, rajmohan.mani@intel.com,
        tuukka.toivonen@intel.com, tian.shu.qiu@intel.com,
        Bingbu Cao <bingbu.cao@intel.com>,
        Andy Yeh <andy.yeh@intel.com>, Yong Zhi <yong.zhi@intel.com>
Subject: [PATCH] media: intel-ipu3: cio2: Handle IRQs until INT_STS is cleared
Date: Wed, 25 Apr 2018 09:40:15 -0700
Message-Id: <1524674415-11598-1-git-send-email-yong.zhi@intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Bingbu Cao <bingbu.cao@intel.com>

Interrupt behavior shows that some time the frame end and frame start
of next frame is unstable and can range from several to hundreds
of micro-sec. In the case of ~10us, isr may not clear next sof interrupt
status in single handling, which prevents new interrupts from coming.

Fix this by handling all pending IRQs before exiting isr, so
any abnormal behavior results from very short interrupt status
changes is protected.

Signed-off-by: Andy Yeh <andy.yeh@intel.com>
Signed-off-by: Bingbu Cao <bingbu.cao@intel.com>
Signed-off-by: Yong Zhi <yong.zhi@intel.com>
---
 drivers/media/pci/intel/ipu3/ipu3-cio2.c | 32 ++++++++++++++++++++++----------
 1 file changed, 22 insertions(+), 10 deletions(-)

diff --git a/drivers/media/pci/intel/ipu3/ipu3-cio2.c b/drivers/media/pci/intel/ipu3/ipu3-cio2.c
index 7d768ec..2902715 100644
--- a/drivers/media/pci/intel/ipu3/ipu3-cio2.c
+++ b/drivers/media/pci/intel/ipu3/ipu3-cio2.c
@@ -640,18 +640,10 @@ static const char *const cio2_port_errs[] = {
 	"PKT2LONG",
 };
 
-static irqreturn_t cio2_irq(int irq, void *cio2_ptr)
+static void cio2_irq_handle_once(struct cio2_device *cio2, u32 int_status)
 {
-	struct cio2_device *cio2 = cio2_ptr;
 	void __iomem *const base = cio2->base;
 	struct device *dev = &cio2->pci_dev->dev;
-	u32 int_status, int_clear;
-
-	int_status = readl(base + CIO2_REG_INT_STS);
-	int_clear = int_status;
-
-	if (!int_status)
-		return IRQ_NONE;
 
 	if (int_status & CIO2_INT_IOOE) {
 		/*
@@ -770,9 +762,29 @@ static irqreturn_t cio2_irq(int irq, void *cio2_ptr)
 		int_status &= ~(CIO2_INT_IOIE | CIO2_INT_IOIRQ);
 	}
 
-	writel(int_clear, base + CIO2_REG_INT_STS);
 	if (int_status)
 		dev_warn(dev, "unknown interrupt 0x%x on INT\n", int_status);
+}
+
+static irqreturn_t cio2_irq(int irq, void *cio2_ptr)
+{
+	struct cio2_device *cio2 = cio2_ptr;
+	void __iomem *const base = cio2->base;
+	struct device *dev = &cio2->pci_dev->dev;
+	u32 int_status;
+
+	int_status = readl(base + CIO2_REG_INT_STS);
+	dev_dbg(dev, "isr enter - interrupt status 0x%x\n", int_status);
+	if (!int_status)
+		return IRQ_NONE;
+
+	do {
+		writel(int_status, base + CIO2_REG_INT_STS);
+		cio2_irq_handle_once(cio2, int_status);
+		int_status = readl(base + CIO2_REG_INT_STS);
+		if (int_status)
+			dev_dbg(dev, "pending status 0x%x\n", int_status);
+	} while (int_status);
 
 	return IRQ_HANDLED;
 }
-- 
2.7.4
