Return-path: <linux-media-owner@vger.kernel.org>
Received: from gateway05.websitewelcome.com ([64.5.52.8]:54972 "HELO
	gateway05.websitewelcome.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1757876AbZKJTeI (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 10 Nov 2009 14:34:08 -0500
Received: from [66.15.212.169] (port=18739 helo=[10.140.5.16])
	by gator886.hostgator.com with esmtpsa (SSLv3:AES256-SHA:256)
	(Exim 4.69)
	(envelope-from <pete@sensoray.com>)
	id 1N7wNA-00060L-Oh
	for linux-media@vger.kernel.org; Tue, 10 Nov 2009 13:27:25 -0600
Subject: [PATCH 2/5] s2250: Mutex function usage.
From: Pete Eberlein <pete@sensoray.com>
To: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Content-Type: text/plain
Date: Tue, 10 Nov 2009 11:21:31 -0800
Message-Id: <1257880891.21307.1104.camel@pete-desktop>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Pete Eberlein <pete@sensoray.com>

Fix mutex function usage, which was overlooked in a previous patch.

Priority: normal

Signed-off-by: Pete Eberlein <pete@sensoray.com>

diff -r a603ad1e6a1c -r 99e4a0cf6788 linux/drivers/staging/go7007/s2250-board.c
--- a/linux/drivers/staging/go7007/s2250-board.c	Tue Nov 10 10:41:56 2009 -0800
+++ b/linux/drivers/staging/go7007/s2250-board.c	Tue Nov 10 10:47:34 2009 -0800
@@ -261,7 +261,7 @@
 
 	memset(buf, 0xcd, 6);
 	usb = go->hpi_context;
-	if (down_interruptible(&usb->i2c_lock) != 0) {
+	if (mutex_lock_interruptible(&usb->i2c_lock) != 0) {
 		printk(KERN_INFO "i2c lock failed\n");
 		kfree(buf);
 		return -EINTR;
@@ -270,7 +270,7 @@
 		kfree(buf);
 		return -EFAULT;
 	}
-	up(&usb->i2c_lock);
+	mutex_unlock(&usb->i2c_lock);
 
 	*val = (buf[0] << 8) | buf[1];
 	kfree(buf);

