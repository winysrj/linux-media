Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-gy0-f174.google.com ([209.85.160.174]:43260 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030568Ab2CBUk4 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 2 Mar 2012 15:40:56 -0500
Received: by ghrr11 with SMTP id r11so1009930ghr.19
        for <linux-media@vger.kernel.org>; Fri, 02 Mar 2012 12:40:56 -0800 (PST)
Date: Fri, 2 Mar 2012 14:40:47 -0600
From: Jonathan Nieder <jrnieder@gmail.com>
To: Ben Hutchings <ben@decadent.org.uk>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	linux-media@vger.kernel.org, devel@driverdev.osuosl.org,
	Jarod Wilson <jarod@redhat.com>,
	Torsten Crass <torsten.crass@eBiology.de>
Subject: [PATCH 2/4] [media] staging: lirc_serial: Free resources on failure
 paths of lirc_serial_probe()
Message-ID: <20120302204047.GC22323@burratino>
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
Date: Wed, 16 Nov 2011 01:52:11 -0300

commit c8e57e1b766c2321aa76ee5e6878c69bd2313d62 upstream.

Failure to allocate the I/O region leaves the IRQ allocated.
A later failure leaves them both allocated.

Reported-by: Torsten Crass <torsten.crass@eBiology.de>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
Signed-off-by: Jonathan Nieder <jrnieder@gmail.com>
---
 drivers/staging/lirc/lirc_serial.c |   19 ++++++++++++++++---
 1 file changed, 16 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/lirc/lirc_serial.c b/drivers/staging/lirc/lirc_serial.c
index c8a4b7bc5879..fa023da6bdaa 100644
--- a/drivers/staging/lirc/lirc_serial.c
+++ b/drivers/staging/lirc/lirc_serial.c
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
1.7.9.2

