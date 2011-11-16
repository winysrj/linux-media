Return-path: <linux-media-owner@vger.kernel.org>
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:52357 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753077Ab1KPFyS convert rfc822-to-8bit
	(ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 16 Nov 2011 00:54:18 -0500
Message-ID: <1321422844.2885.56.camel@deadeye>
Subject: [PATCH 5/5] staging: lirc_serial: Do not assume error codes
 returned by request_irq()
From: Ben Hutchings <ben@decadent.org.uk>
To: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Greg Kroah-Hartman <gregkh@suse.de>
Cc: linux-media@vger.kernel.org, devel@driverdev.osuosl.org
Date: Wed, 16 Nov 2011 05:54:04 +0000
In-Reply-To: <1321422581.2885.50.camel@deadeye>
References: <1321422581.2885.50.camel@deadeye>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Mime-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

lirc_serial_probe() must fail if request_irq() returns an error, even if
it isn't EBUSY or EINVAL,

Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/staging/media/lirc/lirc_serial.c |   21 +++++++++------------
 1 files changed, 9 insertions(+), 12 deletions(-)

diff --git a/drivers/staging/media/lirc/lirc_serial.c b/drivers/staging/media/lirc/lirc_serial.c
index 6f5257e..0ca308a 100644
--- a/drivers/staging/media/lirc/lirc_serial.c
+++ b/drivers/staging/media/lirc/lirc_serial.c
@@ -843,18 +843,15 @@ static int __devinit lirc_serial_probe(struct platform_device *dev)
 	result = request_irq(irq, irq_handler,
 			     (share_irq ? IRQF_SHARED : 0),
 			     LIRC_DRIVER_NAME, (void *)&hardware);
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
-		break;
-	};
+	if (result < 0) {
+		if (result == -EBUSY)
+			printk(KERN_ERR LIRC_DRIVER_NAME ": IRQ %d busy\n",
+			       irq);
+		else if (result == -EINVAL)
+			printk(KERN_ERR LIRC_DRIVER_NAME
+			       ": Bad irq number or handler\n");
+		return result;
+	}
 
 	/* Reserve io region. */
 	/*
-- 
1.7.7.2


