Return-path: <linux-media-owner@vger.kernel.org>
Received: from gofer.mess.org ([88.97.38.141]:58857 "EHLO gofer.mess.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752896AbdEQRc5 (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 17 May 2017 13:32:57 -0400
From: Sean Young <sean@mess.org>
To: linux-media@vger.kernel.org
Subject: [PATCH 3/5] [media] sir_ir: remove init_port and drop_port functions
Date: Wed, 17 May 2017 18:32:52 +0100
Message-Id: <cbb39945637fe6e8211cc4911a36b5f7cb64d86d.1495035457.git.sean@mess.org>
In-Reply-To: <cover.1495035457.git.sean@mess.org>
References: <cover.1495035457.git.sean@mess.org>
In-Reply-To: <cover.1495035457.git.sean@mess.org>
References: <cover.1495035457.git.sean@mess.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

These functions are too short and removing them makes the code more
readable.

Signed-off-by: Sean Young <sean@mess.org>
---
 drivers/media/rc/sir_ir.c | 27 +++++----------------------
 1 file changed, 5 insertions(+), 22 deletions(-)

diff --git a/drivers/media/rc/sir_ir.c b/drivers/media/rc/sir_ir.c
index 1ee41adb..fdac570 100644
--- a/drivers/media/rc/sir_ir.c
+++ b/drivers/media/rc/sir_ir.c
@@ -58,11 +58,9 @@ static int init_chrdev(void);
 static irqreturn_t sir_interrupt(int irq, void *dev_id);
 static void send_space(unsigned long len);
 static void send_pulse(unsigned long len);
-static int init_hardware(void);
+static void init_hardware(void);
 static void drop_hardware(void);
 /* Initialisation */
-static int init_port(void);
-static void drop_port(void);
 
 static inline unsigned int sinp(int offset)
 {
@@ -288,7 +286,7 @@ static void send_pulse(unsigned long len)
 	}
 }
 
-static int init_hardware(void)
+static void init_hardware(void)
 {
 	unsigned long flags;
 
@@ -310,7 +308,6 @@ static int init_hardware(void)
 	/* turn on UART */
 	outb(UART_MCR_DTR | UART_MCR_RTS | UART_MCR_OUT2, io + UART_MCR);
 	spin_unlock_irqrestore(&hardware_lock, flags);
-	return 0;
 }
 
 static void drop_hardware(void)
@@ -327,7 +324,7 @@ static void drop_hardware(void)
 
 /* SECTION: Initialisation */
 
-static int init_port(void)
+static int init_sir_ir(void)
 {
 	int retval;
 
@@ -346,22 +343,8 @@ static int init_port(void)
 	}
 	pr_info("I/O port 0x%.4x, IRQ %d.\n", io, irq);
 
-	return 0;
-}
-
-static void drop_port(void)
-{
-	del_timer_sync(&timerlist);
-}
-
-static int init_sir_ir(void)
-{
-	int retval;
-
-	retval = init_port();
-	if (retval < 0)
-		return retval;
 	init_hardware();
+
 	return 0;
 }
 
@@ -379,7 +362,7 @@ static int sir_ir_probe(struct platform_device *dev)
 static int sir_ir_remove(struct platform_device *dev)
 {
 	drop_hardware();
-	drop_port();
+	del_timer_sync(&timerlist);
 	return 0;
 }
 
-- 
2.9.4
