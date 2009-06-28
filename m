Return-path: <linux-media-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.152]:16720 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751752AbZF1HWx (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 28 Jun 2009 03:22:53 -0400
Received: by fg-out-1718.google.com with SMTP id e21so714485fga.17
        for <linux-media@vger.kernel.org>; Sun, 28 Jun 2009 00:22:55 -0700 (PDT)
MIME-Version: 1.0
Date: Sun, 28 Jun 2009 10:22:55 +0300
Message-ID: <f1e62fb30906280022y51f71032g2572902725ed3529@mail.gmail.com>
Subject: [PATCH] [0906_02] Siano: Fixed SDIO compilation bugs
From: Udi Atar <udi.linuxtv@gmail.com>
To: LinuxML <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

# HG changeset patch
# User Udi Atar <udia@siano-ms.com>
# Date 1246172281 -10800
# Node ID 732b628672570537eb78109314fb60fa8f0efaf6
# Parent  05e6c5c9bcb401055acc74d4781bbd3ab345a1f4
Fix SDIO compilation bugs

From: Udi Atar <udia@siano-ms.com>

Fixed SDIO compilation bugs (for latest kernel).
Also fixed a memory overrun issue in buffer management.

Priority: normal

Signed-off-by: Udi Atar <udia@siano-ms.com>

diff -r 05e6c5c9bcb4 -r 732b62867257 linux/drivers/media/dvb/siano/smssdio.c
--- a/linux/drivers/media/dvb/siano/smssdio.c	Tue Jun 23 21:11:47 2009 -0300
+++ b/linux/drivers/media/dvb/siano/smssdio.c	Sun Jun 28 09:58:01 2009 +0300
@@ -46,6 +46,7 @@

 #define SMSSDIO_DATA		0x00
 #define SMSSDIO_INT		0x04
+#define SMSSDIO_BLOCK_SIZE	128

 static const struct sdio_device_id smssdio_ids[] = {
 	{SDIO_DEVICE(SDIO_VENDOR_ID_SIANO, SDIO_DEVICE_ID_SIANO_STELLAR),
@@ -85,7 +86,8 @@
 	sdio_claim_host(smsdev->func);

 	while (size >= smsdev->func->cur_blksize) {
-		ret = sdio_write_blocks(smsdev->func, SMSSDIO_DATA, buffer, 1);
+		ret = sdio_memcpy_toio(smsdev->func, SMSSDIO_DATA,
+					buffer, smsdev->func->cur_blksize);
 		if (ret)
 			goto out;

@@ -94,8 +96,8 @@
 	}

 	if (size) {
-		ret = sdio_write_bytes(smsdev->func, SMSSDIO_DATA,
-				       buffer, size);
+		ret = sdio_memcpy_toio(smsdev->func, SMSSDIO_DATA,
+					buffer, size);
 	}

 out:
@@ -125,23 +127,23 @@
 	 */
 	isr = sdio_readb(func, SMSSDIO_INT, &ret);
 	if (ret) {
-		dev_err(&smsdev->func->dev,
-			"Unable to read interrupt register!\n");
+		sms_err("Unable to read interrupt register!\n");
 		return;
 	}

 	if (smsdev->split_cb == NULL) {
 		cb = smscore_getbuffer(smsdev->coredev);
 		if (!cb) {
-			dev_err(&smsdev->func->dev,
-				"Unable to allocate data buffer!\n");
+			sms_err("Unable to allocate data buffer!\n");
 			return;
 		}

-		ret = sdio_read_blocks(smsdev->func, cb->p, SMSSDIO_DATA, 1);
+		ret = sdio_memcpy_fromio(smsdev->func,
+					 cb->p,
+					 SMSSDIO_DATA,
+					 SMSSDIO_BLOCK_SIZE);
 		if (ret) {
-			dev_err(&smsdev->func->dev,
-				"Error %d reading initial block!\n", ret);
+			sms_err("Error %d reading initial block!\n", ret);
 			return;
 		}

@@ -152,7 +154,10 @@
 			return;
 		}

-		size = hdr->msgLength - smsdev->func->cur_blksize;
+		if (hdr->msgLength > smsdev->func->cur_blksize)
+			size = hdr->msgLength - smsdev->func->cur_blksize;
+		else
+			size = 0;
 	} else {
 		cb = smsdev->split_cb;
 		hdr = cb->p;
@@ -162,23 +167,24 @@
 		smsdev->split_cb = NULL;
 	}

-	if (hdr->msgLength > smsdev->func->cur_blksize) {
+	if (size) {
 		void *buffer;

-		size = ALIGN(size, 128);
-		buffer = cb->p + hdr->msgLength;
+		buffer = cb->p + (hdr->msgLength - size);
+		size = ALIGN(size, SMSSDIO_BLOCK_SIZE);

-		BUG_ON(smsdev->func->cur_blksize != 128);
+		BUG_ON(smsdev->func->cur_blksize != SMSSDIO_BLOCK_SIZE);

 		/*
 		 * First attempt to transfer all of it in one go...
 		 */
-		ret = sdio_read_blocks(smsdev->func, buffer,
-				       SMSSDIO_DATA, size / 128);
+		ret = sdio_memcpy_fromio(smsdev->func,
+					 buffer,
+					 SMSSDIO_DATA,
+					 size);
 		if (ret && ret != -EINVAL) {
 			smscore_putbuffer(smsdev->coredev, cb);
-			dev_err(&smsdev->func->dev,
-				"Error %d reading data from card!\n", ret);
+			sms_err("Error %d reading data from card!\n", ret);
 			return;
 		}

@@ -191,12 +197,12 @@
 		 */
 		if (ret == -EINVAL) {
 			while (size) {
-				ret = sdio_read_blocks(smsdev->func,
-						       buffer, SMSSDIO_DATA, 1);
+				ret = sdio_memcpy_fromio(smsdev->func,
+						  buffer, SMSSDIO_DATA,
+						  smsdev->func->cur_blksize);
 				if (ret) {
 					smscore_putbuffer(smsdev->coredev, cb);
-					dev_err(&smsdev->func->dev,
-						"Error %d reading "
+					sms_err("Error %d reading "
 						"data from card!\n", ret);
 					return;
 				}
@@ -269,7 +275,7 @@
 	if (ret)
 		goto release;

-	ret = sdio_set_block_size(func, 128);
+	ret = sdio_set_block_size(func, SMSSDIO_BLOCK_SIZE);
 	if (ret)
 		goto disable;
