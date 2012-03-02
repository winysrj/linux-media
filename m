Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:42410 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030567Ab2CBUkV (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 2 Mar 2012 15:40:21 -0500
Received: by iagz16 with SMTP id z16so2763192iag.19
        for <linux-media@vger.kernel.org>; Fri, 02 Mar 2012 12:40:21 -0800 (PST)
Date: Fri, 2 Mar 2012 14:40:13 -0600
From: Jonathan Nieder <jrnieder@gmail.com>
To: Ben Hutchings <ben@decadent.org.uk>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	linux-media@vger.kernel.org, devel@driverdev.osuosl.org,
	Jarod Wilson <jarod@redhat.com>,
	Torsten Crass <torsten.crass@eBiology.de>
Subject: [PATCH 1/4] [media] staging: lirc_serial: Fix init/exit order
Message-ID: <20120302204012.GB22323@burratino>
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
Date: Wed, 16 Nov 2011 01:49:41 -0300

commit 9105b8b200410383d0854bbe237ee385d7d33ba6 upstream.

Currently the module init function registers a platform_device and
only then allocates its IRQ and I/O region.  This allows allocation to
race with the device's suspend() function.  Instead, allocate
resources in the platform driver's probe() function and free them in
the remove() function.

The module exit function removes the platform device before the
character device that provides access to it.  Change it to reverse the
order of initialisation.

Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
Signed-off-by: Jonathan Nieder <jrnieder@gmail.com>
---
 drivers/staging/lirc/lirc_serial.c |   56 ++++++++++++++----------------------
 1 file changed, 21 insertions(+), 35 deletions(-)

diff --git a/drivers/staging/lirc/lirc_serial.c b/drivers/staging/lirc/lirc_serial.c
index 805df913bb6e..c8a4b7bc5879 100644
--- a/drivers/staging/lirc/lirc_serial.c
+++ b/drivers/staging/lirc/lirc_serial.c
@@ -836,7 +836,7 @@ static int hardware_init_port(void)
 	return 0;
 }
 
-static int init_port(void)
+static int __devinit lirc_serial_probe(struct platform_device *dev)
 {
 	int i, nlow, nhigh, result;
 
@@ -913,6 +913,18 @@ static int init_port(void)
 	return 0;
 }
 
+static int __devexit lirc_serial_remove(struct platform_device *dev)
+{
+	free_irq(irq, (void *)&hardware);
+
+	if (iommap != 0)
+		release_mem_region(iommap, 8 << ioshift);
+	else
+		release_region(io, 8);
+
+	return 0;
+}
+
 static int set_use_inc(void *data)
 {
 	unsigned long flags;
@@ -1076,16 +1088,6 @@ static struct lirc_driver driver = {
 
 static struct platform_device *lirc_serial_dev;
 
-static int __devinit lirc_serial_probe(struct platform_device *dev)
-{
-	return 0;
-}
-
-static int __devexit lirc_serial_remove(struct platform_device *dev)
-{
-	return 0;
-}
-
 static int lirc_serial_suspend(struct platform_device *dev,
 			       pm_message_t state)
 {
@@ -1188,10 +1190,6 @@ static int __init lirc_serial_init_module(void)
 {
 	int result;
 
-	result = lirc_serial_init();
-	if (result)
-		return result;
-
 	switch (type) {
 	case LIRC_HOMEBREW:
 	case LIRC_IRDEO:
@@ -1211,8 +1209,7 @@ static int __init lirc_serial_init_module(void)
 		break;
 #endif
 	default:
-		result = -EINVAL;
-		goto exit_serial_exit;
+		return -EINVAL;
 	}
 	if (!softcarrier) {
 		switch (type) {
@@ -1228,37 +1225,26 @@ static int __init lirc_serial_init_module(void)
 		}
 	}
 
-	result = init_port();
-	if (result < 0)
-		goto exit_serial_exit;
+	result = lirc_serial_init();
+	if (result)
+		return result;
+
 	driver.features = hardware[type].features;
 	driver.dev = &lirc_serial_dev->dev;
 	driver.minor = lirc_register_driver(&driver);
 	if (driver.minor < 0) {
 		printk(KERN_ERR  LIRC_DRIVER_NAME
 		       ": register_chrdev failed!\n");
-		result = -EIO;
-		goto exit_release;
+		lirc_serial_exit();
+		return -EIO;
 	}
 	return 0;
-exit_release:
-	release_region(io, 8);
-exit_serial_exit:
-	lirc_serial_exit();
-	return result;
 }
 
 static void __exit lirc_serial_exit_module(void)
 {
-	lirc_serial_exit();
-
-	free_irq(irq, (void *)&hardware);
-
-	if (iommap != 0)
-		release_mem_region(iommap, 8 << ioshift);
-	else
-		release_region(io, 8);
 	lirc_unregister_driver(driver.minor);
+	lirc_serial_exit();
 	dprintk("cleaned up module\n");
 }
 
-- 
1.7.9.2

