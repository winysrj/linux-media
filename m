Return-path: <linux-media-owner@vger.kernel.org>
Received: from gateway01.websitewelcome.com ([69.56.170.19]:50336 "HELO
	gateway01.websitewelcome.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1750895Ab0AMXQF (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 13 Jan 2010 18:16:05 -0500
Received: from [66.15.212.169] (port=13613 helo=[10.140.5.12])
	by gator886.hostgator.com with esmtpsa (SSLv3:AES256-SHA:256)
	(Exim 4.69)
	(envelope-from <pete@sensoray.com>)
	id 1NVBVM-0002J6-K5
	for linux-media@vger.kernel.org; Wed, 13 Jan 2010 16:15:56 -0600
Subject: [PATCH] s2250: Fix write_reg i2c address
From: Pete Eberlein <pete@sensoray.com>
To: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Content-Type: text/plain
Date: Wed, 13 Jan 2010 14:15:48 -0800
Message-Id: <1263420948.4697.313.camel@pete-desktop>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The kernel i2c model uses right-aligned 7-bit i2c addresses, but the
2250 firmware uses an 8-bit address in the usb vendor request.  A
previous patch by Jean Delvare shifted the i2c addresses 1 bit to the
right, and this patch fixes the write_reg function to shift it back
before sending the vendor request.

Priority: normal

Signed-off-by: Pete Eberlein <pete@sensoray.com>

diff -r 3a4be7d7dabd -r 134a95c0d98b linux/drivers/staging/go7007/s2250-board.c
--- a/linux/drivers/staging/go7007/s2250-board.c	Sun Jan 03 17:04:42 2010 +0000
+++ b/linux/drivers/staging/go7007/s2250-board.c	Wed Jan 13 14:11:48 2010 -0800
@@ -159,7 +159,7 @@
 	struct go7007 *go = i2c_get_adapdata(client->adapter);
 	struct go7007_usb *usb;
 	int rc;
-	int dev_addr = client->addr;
+	int dev_addr = client->addr << 1;  /* firmware wants 8-bit address */
 	u8 *buf;
 
 	if (go == NULL)


