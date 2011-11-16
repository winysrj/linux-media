Return-path: <linux-media-owner@vger.kernel.org>
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:52332 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753077Ab1KPFwT convert rfc822-to-8bit
	(ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 16 Nov 2011 00:52:19 -0500
Message-ID: <1321422731.2885.52.camel@deadeye>
Subject: [PATCH 2/5] staging: lirc_serial: Free resources on failure paths
 of lirc_serial_probe()
From: Ben Hutchings <ben@decadent.org.uk>
To: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Greg Kroah-Hartman <gregkh@suse.de>
Cc: linux-media@vger.kernel.org, devel@driverdev.osuosl.org,
	Torsten Crass <torsten.crass@eBiology.de>
Date: Wed, 16 Nov 2011 05:52:11 +0000
In-Reply-To: <1321422581.2885.50.camel@deadeye>
References: <1321422581.2885.50.camel@deadeye>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Mime-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Failure to allocate the I/O region leaves the IRQ allocated.
A later failure leaves them both allocated.

Reported-by: Torsten Crass <torsten.crass@eBiology.de>
References: http://bugs.debian.org/645811
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/staging/media/lirc/lirc_serial.c |   19 ++++++++++++++++---
 1 files changed, 16 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/media/lirc/lirc_serial.c b/drivers/staging/media/lirc/lirc_serial.c
index 8637631..d833772 100644
--- a/drivers/staging/media/lirc/lirc_serial.c
+++ b/drivers/staging/media/lirc/lirc_serial.c
@@ -875,11 +875,14 @@ static int __devinit lirc_serial_probe(struct platform_device *dev)
 		       ": or compile the serial port driver as module and\n");
 		printk(KERN_WARNING LIRC_DRIVER_NAME
 		       ": make sure this module is loaded first\n");
-		return -EBUSY;
+		result = -EBUSY;
+		goto exit_free_irq;
 	}
 
-	if (hardware_init_port() < 0)
-		return -EINVAL;
+	if (hardware_init_port() < 0) {
+		result = -EINVAL;
+		goto exit_release_region;
+	}
 
 	/* Initialize pulse/space widths */
 	init_timing_params(duty_cycle, freq);
@@ -911,6 +914,16 @@ static int __devinit lirc_serial_probe(struct platform_device *dev)
 
 	dprintk("Interrupt %d, port %04x obtained\n", irq, io);
 	return 0;
+
+exit_release_region:
+	if (iommap != 0)
+		release_mem_region(iommap, 8 << ioshift);
+	else
+		release_region(io, 8);
+exit_free_irq:
+	free_irq(irq, (void *)&hardware);
+
+	return result;
 }
 
 static int __devexit lirc_serial_remove(struct platform_device *dev)
-- 
1.7.7.2



