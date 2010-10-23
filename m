Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:50207 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755661Ab0JWD1a (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 22 Oct 2010 23:27:30 -0400
Received: from int-mx09.intmail.prod.int.phx2.redhat.com (int-mx09.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id o9N3RTsq023962
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Fri, 22 Oct 2010 23:27:29 -0400
Received: from [10.3.227.40] (vpn-227-40.phx2.redhat.com [10.3.227.40])
	by int-mx09.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP id o9N3RSGo032619
	for <linux-media@vger.kernel.org>; Fri, 22 Oct 2010 23:27:28 -0400
Message-ID: <4CC2561F.4000501@redhat.com>
Date: Sat, 23 Oct 2010 01:27:27 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: "linux-med >> Linux Media Mailing List" <linux-media@vger.kernel.org>
Subject: [PATCHv2] tm6000: Remove some ugly debug code
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Those time debugs were here just while developing the driver. They are
not really needed, as kernel may be configured to print jiffies with
printk's. Also, it breaks, if more than one device is connected.

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>

---

v2: Removed a wrong hunk on another file that doesn't belong here

diff --git a/drivers/staging/tm6000/tm6000-core.c b/drivers/staging/tm6000/tm6000-core.c
index 9b45101..0883ea5 100644
--- a/drivers/staging/tm6000/tm6000-core.c
+++ b/drivers/staging/tm6000/tm6000-core.c
@@ -37,7 +37,6 @@ int tm6000_read_write_usb(struct tm6000_core *dev, u8 req_type, u8 req,
 {
 	int          ret, i;
 	unsigned int pipe;
-	static int   ini = 0, last = 0, n = 0;
 	u8	     *data = NULL;
 
 	if (len)
@@ -52,19 +51,12 @@ int tm6000_read_write_usb(struct tm6000_core *dev, u8 req_type, u8 req,
 	}
 
 	if (tm6000_debug & V4L2_DEBUG_I2C) {
-		if (!ini)
-			last = ini = jiffies;
+		printk("(dev %p, pipe %08x): ", dev->udev, pipe);
 
-		printk("%06i (dev %p, pipe %08x): ", n, dev->udev, pipe);
-
-		printk("%s: %06u ms %06u ms %02x %02x %02x %02x %02x %02x %02x %02x ",
+		printk("%s: %02x %02x %02x %02x %02x %02x %02x %02x ",
 			(req_type & USB_DIR_IN) ? " IN" : "OUT",
-			jiffies_to_msecs(jiffies-last),
-			jiffies_to_msecs(jiffies-ini),
 			req_type, req, value&0xff, value>>8, index&0xff,
 			index>>8, len&0xff, len>>8);
-		last = jiffies;
-		n++;
 
 		if (!(req_type & USB_DIR_IN)) {
 			printk(">>> ");
