Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pa0-f51.google.com ([209.85.220.51]:54969 "EHLO
	mail-pa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751166AbaLYISe (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 25 Dec 2014 03:18:34 -0500
Received: by mail-pa0-f51.google.com with SMTP id ey11so11412962pad.24
        for <linux-media@vger.kernel.org>; Thu, 25 Dec 2014 00:18:34 -0800 (PST)
Date: Thu, 25 Dec 2014 16:18:31 +0800
From: "Nibble Max" <nibble.max@gmail.com>
To: "Antti Palosaari" <crope@iki.fi>
Cc: "linux-media" <linux-media@vger.kernel.org>,
	"Olli Salonen" <olli.salonen@iki.fi>
Subject: [PATCH 1/1] smipcie: return more proper value in interrupt handler.
Message-ID: <201412251618286562378@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="gb2312"
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


Although IRQ_HANDLED is "safe" value to return, 
it is better to let the kernel know whether the driver handle the interrupt or not.

Signed-off-by: Nibble Max <nibble.max@gmail.com>
---
 drivers/media/pci/smipcie/smipcie.c | 12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/drivers/media/pci/smipcie/smipcie.c b/drivers/media/pci/smipcie/smipcie.c
index f773350..36c8ed7 100644
--- a/drivers/media/pci/smipcie/smipcie.c
+++ b/drivers/media/pci/smipcie/smipcie.c
@@ -448,16 +448,19 @@ static void smi_port_exit(struct smi_port *port)
 	port->enable = 0;
 }
 
-static void smi_port_irq(struct smi_port *port, u32 int_status)
+static int smi_port_irq(struct smi_port *port, u32 int_status)
 {
 	u32 port_req_irq = port->_dmaInterruptCH0 | port->_dmaInterruptCH1;
+	int handled = 0;
 
 	if (int_status & port_req_irq) {
 		smi_port_disableInterrupt(port);
 		port->_int_status = int_status;
 		smi_port_clearInterrupt(port);
 		tasklet_schedule(&port->tasklet);
+		handled = 1;
 	}
+	return handled;
 }
 
 static irqreturn_t smi_irq_handler(int irq, void *dev_id)
@@ -465,18 +468,19 @@ static irqreturn_t smi_irq_handler(int irq, void *dev_id)
 	struct smi_dev *dev = dev_id;
 	struct smi_port *port0 = &dev->ts_port[0];
 	struct smi_port *port1 = &dev->ts_port[1];
+	int handled = 0;
 
 	u32 intr_status = smi_read(MSI_INT_STATUS);
 
 	/* ts0 interrupt.*/
 	if (dev->info->ts_0)
-		smi_port_irq(port0, intr_status);
+		handled += smi_port_irq(port0, intr_status);
 
 	/* ts1 interrupt.*/
 	if (dev->info->ts_1)
-		smi_port_irq(port1, intr_status);
+		handled += smi_port_irq(port1, intr_status);
 
-	return IRQ_HANDLED;
+	return IRQ_RETVAL(handled);
 }
 
 static struct i2c_client *smi_add_i2c_client(struct i2c_adapter *adapter,

-- 
1.9.1

