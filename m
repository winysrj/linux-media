Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga14.intel.com ([143.182.124.37]:52751 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751355Ab3FZOhp (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 26 Jun 2013 10:37:45 -0400
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: Dan Carpenter <dan.carpenter@oracle.com>,
	Jarod Wilson <jarod@wilsonet.com>,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	YAMANE Toshiaki <yamanetoshi@gmail.com>,
	linux-media@vger.kernel.org
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: [PATCH v2] staging: lirc: clean error handling in probe()
Date: Wed, 26 Jun 2013 17:37:36 +0300
Message-Id: <1372257456-19212-1-git-send-email-andriy.shevchenko@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Dan Carpenter <dan.carpenter@oracle.com>

We have reorganized the error handling into a simpler and more canonical
format.

Additionally we removed extra empty lines, switched to devm_kzalloc(), and
substitute 'minor' by 'ret' in the igorplugusb_remote_probe() function.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
---
 drivers/staging/media/lirc/lirc_igorplugusb.c | 56 +++++++--------------------
 1 file changed, 14 insertions(+), 42 deletions(-)

diff --git a/drivers/staging/media/lirc/lirc_igorplugusb.c b/drivers/staging/media/lirc/lirc_igorplugusb.c
index 2faa391..28c8b0b 100644
--- a/drivers/staging/media/lirc/lirc_igorplugusb.c
+++ b/drivers/staging/media/lirc/lirc_igorplugusb.c
@@ -240,10 +240,6 @@ static int unregister_from_lirc(struct igorplug *ir)
 	dprintk(DRIVER_NAME "[%d]: calling lirc_unregister_driver\n", devnum);
 	lirc_unregister_driver(d->minor);
 
-	kfree(d);
-	ir->d = NULL;
-	kfree(ir);
-
 	return devnum;
 }
 
@@ -377,20 +373,16 @@ static int igorplugusb_remote_poll(void *data, struct lirc_buffer *buf)
 	return -ENODATA;
 }
 
-
-
 static int igorplugusb_remote_probe(struct usb_interface *intf,
 				    const struct usb_device_id *id)
 {
-	struct usb_device *dev = NULL;
+	struct usb_device *dev;
 	struct usb_host_interface *idesc = NULL;
 	struct usb_endpoint_descriptor *ep;
 	struct igorplug *ir = NULL;
 	struct lirc_driver *driver = NULL;
 	int devnum, pipe, maxp;
-	int minor = 0;
 	char buf[63], name[128] = "";
-	int mem_failure = 0;
 	int ret;
 
 	dprintk(DRIVER_NAME ": usb probe called.\n");
@@ -416,24 +408,18 @@ static int igorplugusb_remote_probe(struct usb_interface *intf,
 	dprintk(DRIVER_NAME "[%d]: bytes_in_key=%zu maxp=%d\n",
 		devnum, CODE_LENGTH, maxp);
 
-	mem_failure = 0;
-	ir = kzalloc(sizeof(struct igorplug), GFP_KERNEL);
-	if (!ir) {
-		mem_failure = 1;
-		goto mem_failure_switch;
-	}
-	driver = kzalloc(sizeof(struct lirc_driver), GFP_KERNEL);
-	if (!driver) {
-		mem_failure = 2;
-		goto mem_failure_switch;
-	}
+	ir = devm_kzalloc(&intf->dev, sizeof(*ir), GFP_KERNEL);
+	if (!ir)
+		return -ENOMEM;
+
+	driver = devm_kzalloc(&intf->dev, sizeof(*driver), GFP_KERNEL);
+	if (!driver)
+		return -ENOMEM;
 
 	ir->buf_in = usb_alloc_coherent(dev, DEVICE_BUFLEN + DEVICE_HEADERLEN,
 					GFP_ATOMIC, &ir->dma_in);
-	if (!ir->buf_in) {
-		mem_failure = 3;
-		goto mem_failure_switch;
-	}
+	if (!ir->buf_in)
+		return -ENOMEM;
 
 	strcpy(driver->name, DRIVER_NAME " ");
 	driver->minor = -1;
@@ -449,27 +435,14 @@ static int igorplugusb_remote_probe(struct usb_interface *intf,
 	driver->dev = &intf->dev;
 	driver->owner = THIS_MODULE;
 
-	minor = lirc_register_driver(driver);
-	if (minor < 0)
-		mem_failure = 9;
-
-mem_failure_switch:
-
-	switch (mem_failure) {
-	case 9:
+	ret = lirc_register_driver(driver);
+	if (ret < 0) {
 		usb_free_coherent(dev, DEVICE_BUFLEN + DEVICE_HEADERLEN,
 			ir->buf_in, ir->dma_in);
-	case 3:
-		kfree(driver);
-	case 2:
-		kfree(ir);
-	case 1:
-		printk(DRIVER_NAME "[%d]: out of memory (code=%d)\n",
-			devnum, mem_failure);
-		return -ENOMEM;
+		return ret;
 	}
 
-	driver->minor = minor;
+	driver->minor = ret;
 	ir->d = driver;
 	ir->devnum = devnum;
 	ir->usbdev = dev;
@@ -502,7 +475,6 @@ mem_failure_switch:
 	return 0;
 }
 
-
 static void igorplugusb_remote_disconnect(struct usb_interface *intf)
 {
 	struct usb_device *usbdev = interface_to_usbdev(intf);
-- 
1.8.3.1

