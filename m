Return-path: <linux-media-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:49031 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753777Ab3A3HDm (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 30 Jan 2013 02:03:42 -0500
Date: Wed, 30 Jan 2013 10:03:43 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: linux-media@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [patch] [media] tm6000: check an allocation for failure
Message-ID: <20130130070343.GA12396@elgon.mountain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This allocation had no error checking.  It didn't need to be under
the mutex so I moved it out form there. That makes the error handling
easier and is a potential speed up.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

diff --git a/drivers/media/usb/tm6000/tm6000-core.c b/drivers/media/usb/tm6000/tm6000-core.c
index 22cc011..7c32353 100644
--- a/drivers/media/usb/tm6000/tm6000-core.c
+++ b/drivers/media/usb/tm6000/tm6000-core.c
@@ -40,10 +40,13 @@ int tm6000_read_write_usb(struct tm6000_core *dev, u8 req_type, u8 req,
 	u8	     *data = NULL;
 	int delay = 5000;
 
-	mutex_lock(&dev->usb_lock);
-
-	if (len)
+	if (len) {
 		data = kzalloc(len, GFP_KERNEL);
+		if (!data)
+			return -ENOMEM;
+	}
+
+	mutex_lock(&dev->usb_lock);
 
 	if (req_type & USB_DIR_IN)
 		pipe = usb_rcvctrlpipe(dev->udev, 0);
