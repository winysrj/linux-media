Return-path: <linux-media-owner@vger.kernel.org>
Received: from gateway07.websitewelcome.com ([69.56.176.23]:49773 "HELO
	gateway07.websitewelcome.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1755093AbZIRVKH (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 18 Sep 2009 17:10:07 -0400
Received: from [66.15.212.169] (port=30677 helo=[10.140.5.16])
	by gator886.hostgator.com with esmtpsa (SSLv3:AES256-SHA:256)
	(Exim 4.69)
	(envelope-from <pete@sensoray.com>)
	id 1Moi7C-0002jL-6m
	for linux-media@vger.kernel.org; Fri, 18 Sep 2009 13:23:26 -0500
Subject: [PATCH 6/9] s2250-board: Fix memory leaks
From: Pete <pete@sensoray.com>
To: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Content-Type: text/plain
Date: Fri, 18 Sep 2009 11:23:30 -0700
Message-Id: <1253298210.4314.570.camel@pete-desktop>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

In some error cases, allocated buffers need to be freed before returning.

Priority: normal

Signed-off-by: Pete Eberlein <pete@sensoray.com>

diff -r e227a099a9f2 -r bf8ee230f1a0 linux/drivers/staging/go7007/s2250-board.c
--- a/linux/drivers/staging/go7007/s2250-board.c	Fri Sep 18 10:37:01 2009 -0700
+++ b/linux/drivers/staging/go7007/s2250-board.c	Fri Sep 18 10:39:03 2009 -0700
@@ -203,10 +203,13 @@
 	usb = go->hpi_context;
 	if (mutex_lock_interruptible(&usb->i2c_lock) != 0) {
 		printk(KERN_INFO "i2c lock failed\n");
+		kfree(buf);
 		return -EINTR;
 	}
-	if (go7007_usb_vendor_request(go, 0x57, addr, val, buf, 16, 1) < 0)
+	if (go7007_usb_vendor_request(go, 0x57, addr, val, buf, 16, 1) < 0) {
+		kfree(buf);
 		return -EFAULT;
+	}
 
 	mutex_unlock(&usb->i2c_lock);
 	if (buf[0] == 0) {
@@ -214,6 +217,7 @@
 
 		subaddr = (buf[4] << 8) + buf[5];
 		val_read = (buf[2] << 8) + buf[3];
+		kfree(buf);
 		if (val_read != val) {
 			printk(KERN_INFO "invalid fp write %x %x\n",
 			       val_read, val);
@@ -224,8 +228,10 @@
 			       subaddr, addr);
 			return -EFAULT;
 		}
-	} else
+	} else {
+		kfree(buf);
 		return -EFAULT;
+	}
 
 	/* save last 12b value */
 	if (addr == 0x12b)


