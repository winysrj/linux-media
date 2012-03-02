Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:55421 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756401Ab2CBUl5 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 2 Mar 2012 15:41:57 -0500
Received: by mail-iy0-f174.google.com with SMTP id z16so2764466iag.19
        for <linux-media@vger.kernel.org>; Fri, 02 Mar 2012 12:41:57 -0800 (PST)
Date: Fri, 2 Mar 2012 14:41:49 -0600
From: Jonathan Nieder <jrnieder@gmail.com>
To: Ben Hutchings <ben@decadent.org.uk>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	linux-media@vger.kernel.org, devel@driverdev.osuosl.org,
	Jarod Wilson <jarod@redhat.com>,
	Torsten Crass <torsten.crass@eBiology.de>
Subject: [PATCH 4/4] [media] staging: lirc_serial: Do not assume error codes
 returned by request_irq()
Message-ID: <20120302204149.GE22323@burratino>
References: <1321422581.2885.50.camel@deadeye>
 <20120302034545.GA31860@burratino>
 <1330662942.8460.229.camel@deadeye>
 <20120302203913.GA22323@burratino>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120302203913.GA22323@burratino>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Ben Hutchings <ben@decadent.org.uk>
Date: Wed, 16 Nov 2011 01:54:04 -0300

commit affc9a0d59ac49bd304e2137bd5e4ffdd6fdfa52 upstream.

lirc_serial_probe() must fail if request_irq() returns an error, even if
it isn't EBUSY or EINVAL,

Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
Signed-off-by: Jonathan Nieder <jrnieder@gmail.com>
---
 drivers/staging/lirc/lirc_serial.c |   21 +++++++++------------
 1 file changed, 9 insertions(+), 12 deletions(-)

diff --git a/drivers/staging/lirc/lirc_serial.c b/drivers/staging/lirc/lirc_serial.c
index 4b8fefb954d3..21cbc9ae79c9 100644
--- a/drivers/staging/lirc/lirc_serial.c
+++ b/drivers/staging/lirc/lirc_serial.c
@@ -843,18 +843,15 @@ static int __devinit lirc_serial_probe(struct platform_device *dev)
 	result = request_irq(irq, irq_handler,
 			     IRQF_DISABLED | (share_irq ? IRQF_SHARED : 0),
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
1.7.9.2

