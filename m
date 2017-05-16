Return-path: <linux-media-owner@vger.kernel.org>
Received: from gofer.mess.org ([88.97.38.141]:49545 "EHLO gofer.mess.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751338AbdEPIp5 (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 16 May 2017 04:45:57 -0400
Date: Tue, 16 May 2017 09:45:55 +0100
From: Sean Young <sean@mess.org>
To: kernel test robot <fengguang.wu@intel.com>
Cc: LKP <lkp@01.org>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
        Mauro Carvalho Chehab <m.chehab@samsung.com>,
        wfg@linux.intel.com
Subject: [PATCH] [media] sir_ir: infinite loop in interrupt handler
Message-ID: <20170516084555.GA9699@gofer.mess.org>
References: <591060f1.yq3IrK0+vZ5287bb%fengguang.wu@intel.com>
 <20170516074143.GA8691@gofer.mess.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170516074143.GA8691@gofer.mess.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Since this driver does no detection of hardware, it might be used with
a non-sir port. Escape out if we are spinning.

Signed-off-by: Sean Young <sean@mess.org>
---
 drivers/media/rc/sir_ir.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/media/rc/sir_ir.c b/drivers/media/rc/sir_ir.c
index e12ec50..90a5f8f 100644
--- a/drivers/media/rc/sir_ir.c
+++ b/drivers/media/rc/sir_ir.c
@@ -183,9 +183,15 @@ static irqreturn_t sir_interrupt(int irq, void *dev_id)
 	static unsigned long delt;
 	unsigned long deltintr;
 	unsigned long flags;
+	int counter = 0;
 	int iir, lsr;
 
 	while ((iir = inb(io + UART_IIR) & UART_IIR_ID)) {
+		if (++counter > 256) {
+			dev_err(&sir_ir_dev->dev, "Trapped in interrupt");
+			break;
+		}
+
 		switch (iir & UART_IIR_ID) { /* FIXME toto treba preriedit */
 		case UART_IIR_MSI:
 			(void)inb(io + UART_MSR);
-- 
2.9.4
