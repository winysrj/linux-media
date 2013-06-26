Return-path: <linux-media-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:25971 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751195Ab3FZHyM (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 26 Jun 2013 03:54:12 -0400
Date: Wed, 26 Jun 2013 10:53:58 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Jarod Wilson <jarod@wilsonet.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	YAMANE Toshiaki <yamanetoshi@gmail.com>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	linux-media@vger.kernel.org
Subject: [patch] [media] staging: lirc: clean error handling in probe()
Message-ID: <20130626075358.GC1895@elgon.mountain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

I have reorganized the error handling into a simpler and more canonical
format.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

diff --git a/drivers/staging/media/lirc/lirc_igorplugusb.c b/drivers/staging/media/lirc/lirc_igorplugusb.c
index 2faa391..4cf3933 100644
--- a/drivers/staging/media/lirc/lirc_igorplugusb.c
+++ b/drivers/staging/media/lirc/lirc_igorplugusb.c
@@ -390,7 +390,6 @@ static int igorplugusb_remote_probe(struct usb_interface *intf,
 	int devnum, pipe, maxp;
 	int minor = 0;
 	char buf[63], name[128] = "";
-	int mem_failure = 0;
 	int ret;
 
 	dprintk(DRIVER_NAME ": usb probe called.\n");
@@ -416,24 +415,17 @@ static int igorplugusb_remote_probe(struct usb_interface *intf,
 	dprintk(DRIVER_NAME "[%d]: bytes_in_key=%zu maxp=%d\n",
 		devnum, CODE_LENGTH, maxp);
 
-	mem_failure = 0;
 	ir = kzalloc(sizeof(struct igorplug), GFP_KERNEL);
-	if (!ir) {
-		mem_failure = 1;
-		goto mem_failure_switch;
-	}
+	if (!ir)
+		return -ENOMEM;
 	driver = kzalloc(sizeof(struct lirc_driver), GFP_KERNEL);
-	if (!driver) {
-		mem_failure = 2;
-		goto mem_failure_switch;
-	}
+	if (!driver)
+		goto err_free_ir;
 
 	ir->buf_in = usb_alloc_coherent(dev, DEVICE_BUFLEN + DEVICE_HEADERLEN,
 					GFP_ATOMIC, &ir->dma_in);
-	if (!ir->buf_in) {
-		mem_failure = 3;
-		goto mem_failure_switch;
-	}
+	if (!ir->buf_in)
+		goto err_free_driver;
 
 	strcpy(driver->name, DRIVER_NAME " ");
 	driver->minor = -1;
@@ -451,23 +443,7 @@ static int igorplugusb_remote_probe(struct usb_interface *intf,
 
 	minor = lirc_register_driver(driver);
 	if (minor < 0)
-		mem_failure = 9;
-
-mem_failure_switch:
-
-	switch (mem_failure) {
-	case 9:
-		usb_free_coherent(dev, DEVICE_BUFLEN + DEVICE_HEADERLEN,
-			ir->buf_in, ir->dma_in);
-	case 3:
-		kfree(driver);
-	case 2:
-		kfree(ir);
-	case 1:
-		printk(DRIVER_NAME "[%d]: out of memory (code=%d)\n",
-			devnum, mem_failure);
-		return -ENOMEM;
-	}
+		goto err_free_usb;
 
 	driver->minor = minor;
 	ir->d = driver;
@@ -500,6 +476,16 @@ mem_failure_switch:
 
 	usb_set_intfdata(intf, ir);
 	return 0;
+
+err_free_usb:
+	usb_free_coherent(dev, DEVICE_BUFLEN + DEVICE_HEADERLEN, ir->buf_in,
+			  ir->dma_in);
+err_free_driver:
+	kfree(driver);
+err_free_ir:
+	kfree(ir);
+
+	return -ENOMEM;
 }
 
 
