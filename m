Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:28286 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751901Ab1FPTbx (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 16 Jun 2011 15:31:53 -0400
From: Jarod Wilson <jarod@redhat.com>
To: linux-media@vger.kernel.org
Cc: Jarod Wilson <jarod@redhat.com>, devel@driverdev.osuosl.org
Subject: [PATCH] [staging] lirc_serial: allocate irq at init time
Date: Thu, 16 Jun 2011 15:31:46 -0400
Message-Id: <1308252706-13879-1-git-send-email-jarod@redhat.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

There's really no good reason not to just grab the desired IRQ at driver
init time, instead of every time the lirc device node is accessed. This
also improves the speed and reliability with which a serial transmitter
can operate, as back-to-back transmission attempts (i.e., channel change
to a multi-digit channel) don't have to spend time acquiring and then
releasing the IRQ for every digit, sometimes multiple times, if lircd
has been told to use the min_repeat parameter.

CC: devel@driverdev.osuosl.org
Signed-off-by: Jarod Wilson <jarod@redhat.com>
---
 drivers/staging/lirc/lirc_serial.c |   44 +++++++++++++++++------------------
 1 files changed, 21 insertions(+), 23 deletions(-)

diff --git a/drivers/staging/lirc/lirc_serial.c b/drivers/staging/lirc/lirc_serial.c
index 1c3099b..805df91 100644
--- a/drivers/staging/lirc/lirc_serial.c
+++ b/drivers/staging/lirc/lirc_serial.c
@@ -838,7 +838,23 @@ static int hardware_init_port(void)
 
 static int init_port(void)
 {
-	int i, nlow, nhigh;
+	int i, nlow, nhigh, result;
+
+	result = request_irq(irq, irq_handler,
+			     IRQF_DISABLED | (share_irq ? IRQF_SHARED : 0),
+			     LIRC_DRIVER_NAME, (void *)&hardware);
+
+	switch (result) {
+	case -EBUSY:
+		printk(KERN_ERR LIRC_DRIVER_NAME ": IRQ %d busy\n", irq);
+		return -EBUSY;
+	case -EINVAL:
+		printk(KERN_ERR LIRC_DRIVER_NAME
+		       ": Bad irq number or handler\n");
+		return -EINVAL;
+	default:
+		break;
+	};
 
 	/* Reserve io region. */
 	/*
@@ -893,34 +909,17 @@ static int init_port(void)
 		printk(KERN_INFO LIRC_DRIVER_NAME  ": Manually using active "
 		       "%s receiver\n", sense ? "low" : "high");
 
+	dprintk("Interrupt %d, port %04x obtained\n", irq, io);
 	return 0;
 }
 
 static int set_use_inc(void *data)
 {
-	int result;
 	unsigned long flags;
 
 	/* initialize timestamp */
 	do_gettimeofday(&lasttv);
 
-	result = request_irq(irq, irq_handler,
-			     IRQF_DISABLED | (share_irq ? IRQF_SHARED : 0),
-			     LIRC_DRIVER_NAME, (void *)&hardware);
-
-	switch (result) {
-	case -EBUSY:
-		printk(KERN_ERR LIRC_DRIVER_NAME ": IRQ %d busy\n", irq);
-		return -EBUSY;
-	case -EINVAL:
-		printk(KERN_ERR LIRC_DRIVER_NAME
-		       ": Bad irq number or handler\n");
-		return -EINVAL;
-	default:
-		dprintk("Interrupt %d, port %04x obtained\n", irq, io);
-		break;
-	};
-
 	spin_lock_irqsave(&hardware[type].lock, flags);
 
 	/* Set DLAB 0. */
@@ -945,10 +944,6 @@ static void set_use_dec(void *data)
 	soutp(UART_IER, sinp(UART_IER) &
 	      (~(UART_IER_MSI|UART_IER_RLSI|UART_IER_THRI|UART_IER_RDI)));
 	spin_unlock_irqrestore(&hardware[type].lock, flags);
-
-	free_irq(irq, (void *)&hardware);
-
-	dprintk("freed IRQ %d\n", irq);
 }
 
 static ssize_t lirc_write(struct file *file, const char *buf,
@@ -1256,6 +1251,9 @@ exit_serial_exit:
 static void __exit lirc_serial_exit_module(void)
 {
 	lirc_serial_exit();
+
+	free_irq(irq, (void *)&hardware);
+
 	if (iommap != 0)
 		release_mem_region(iommap, 8 << ioshift);
 	else
-- 
1.7.1

