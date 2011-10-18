Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtpo05.poczta.onet.pl ([213.180.142.136]:33798 "EHLO
	smtpo05.poczta.onet.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753238Ab1JRTuQ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 18 Oct 2011 15:50:16 -0400
Date: Tue, 18 Oct 2011 21:50:13 +0200
From: Piotr Chmura <chmooreck@poczta.onet.pl>
To: Piotr Chmura <chmooreck@poczta.onet.pl>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Devin Heitmueller <dheitmueller@kernellabs.com>,
	Stefan Richter <stefanr@s5r6.in-berlin.de>,
	Greg KH <gregkh@suse.de>,
	Patrick Dickey <pdickeybeta@gmail.com>,
	LMML <linux-media@vger.kernel.org>, devel@driverdev.osuosl.org
Subject: [RESEND PATCH 3/14] staging/media/as102: checkpatch fixes
Message-ID: <20111018215013.7eb0134a@darkstar>
In-Reply-To: <20111018111146.79eb6726.chmooreck@poczta.onet.pl>
References: <4E7F1FB5.5030803@gmail.com>
	<CAGoCfixneQG=S5wy2qZZ50+PB-QNTFx=GLM7RYPuxfXtUy6Ecg@mail.gmail.com>
	<4E7FF0A0.7060004@gmail.com>
	<CAGoCfizyLgpEd_ei-SYEf6WWs5cygQJNjKPNPOYOQUqF773D4Q@mail.gmail.com>
	<20110927094409.7a5fcd5a@stein>
	<20110927174307.GD24197@suse.de>
	<20110927213300.6893677a@stein>
	<4E999733.2010802@poczta.onet.pl>
	<4E99F2FC.5030200@poczta.onet.pl>
	<20111016105731.09d66f03@stein>
	<CAGoCfix9Yiju3-uyuPaV44dBg5i-LLdezz-fbo3v29i6ymRT7w@mail.gmail.com>
	<4E9ADFAE.8050208@redhat.com>
	<20111018094647.d4982eb2.chmooreck@poczta.onet.pl>
	<20111018111146.79eb6726.chmooreck@poczta.onet.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Patch taken from http://kernellabs.com/hg/~dheitmueller/v4l-dvb-as102-2/

Original source and comment:
# HG changeset patch
# User Devin Heitmueller <dheitmueller@kernellabs.com>
# Date 1267318626 18000
# Node ID b91e96a07bee27c1d421b4c3702e33ee8075de83
# Parent  e2ba344c99936bddc46722f1f1efec5600c58659
as102: checkpatch fixes

From: Devin Heitmueller <dheitmueller@kernellabs.com>

Fix make checkpatch issues reported against as102_fw.c.

Priority: normal

Signed-off-by: Devin Heitmueller <dheitmueller@kernellabs.com>
Signed-off-by: Piotr Chmura <chmooreck@poczta.onet.pl>

diff --git linux/drivers/staging/media/as102/as102_fw.c linuxb/drivers/media/dvb/as102/as102_fw.c
--- linux/drivers/staging/media/as102/as102_fw.c
+++ linuxb/drivers/staging/media/as102/as102_fw.c
@@ -1,6 +1,7 @@
 /*
  * Abilis Systems Single DVB-T Receiver
  * Copyright (C) 2008 Pierrick Hascoet <pierrick.hascoet@abilis.com>
+ * Copyright (C) 2010 Devin Heitmueller <dheitmueller@kernellabs.com>
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License as published by
@@ -31,15 +32,16 @@
 char as102_dt_fw1[] = "as102_data1_dt.hex";
 char as102_dt_fw2[] = "as102_data2_dt.hex";
 
-static unsigned char atohx(unsigned char *dst, char *src) {
+static unsigned char atohx(unsigned char *dst, char *src)
+{
 	unsigned char value = 0;
 
 	char msb = tolower(*src) - '0';
-	char lsb = tolower(*(src +1)) - '0';
+	char lsb = tolower(*(src + 1)) - '0';
 
-	if (msb > 9 )
+	if (msb > 9)
 		msb -= 7;
-	if (lsb > 9 )
+	if (lsb > 9)
 		lsb -= 7;
 
 	*dst = value = ((msb & 0xF) << 4) | (lsb & 0xF);
@@ -62,43 +64,42 @@
 	}
 
 	/* locate end of line */
-	for (src=fw_data; *src != '\n'; src += 2) {
+	for (src = fw_data; *src != '\n'; src += 2) {
 		atohx(&dst, src);
 		/* parse line to split addr / data */
 		switch (count) {
-			case 0:
-				*dataLength = dst;
-				break;
-			case 1:
-				addr[2] = dst;
-				break;
-			case 2:
-				addr[3] = dst;
-				break;
-			case 3:
-				/* check if data is an address */
-				if (dst == 0x04)
-					*addr_has_changed = 1;
-				else
-					*addr_has_changed = 0;
-				break;
-			case  4:
-			case  5:
-				if (*addr_has_changed) {
-					addr[(count - 4)] = dst;
-				} else {
-					data[(count - 4)] = dst;
-				}
-				break;
-			default:
+		case 0:
+			*dataLength = dst;
+			break;
+		case 1:
+			addr[2] = dst;
+			break;
+		case 2:
+			addr[3] = dst;
+			break;
+		case 3:
+			/* check if data is an address */
+			if (dst == 0x04)
+				*addr_has_changed = 1;
+			else
+				*addr_has_changed = 0;
+			break;
+		case  4:
+		case  5:
+			if (*addr_has_changed)
+				addr[(count - 4)] = dst;
+			else
 				data[(count - 4)] = dst;
-				break;
+			break;
+		default:
+			data[(count - 4)] = dst;
+			break;
 		}
 		count++;
 	}
 
 	/* return read value + ':' + '\n' */
-	return ((count * 2) + 2);
+	return (count * 2) + 2;
 }
 
 static int as102_firmware_upload(struct as102_bus_adapter_t *bus_adap,
@@ -122,17 +123,20 @@
 				&data_len,
 				&addr_has_changed);
 
-		if (read_bytes <= 0) {
+		if (read_bytes <= 0)
 			goto error;
-		}
 
 		/* detect the end of file */
-		if ((total_read_bytes += read_bytes) == firmware->size) {
+		total_read_bytes += read_bytes;
+		if (total_read_bytes == firmware->size) {
 			fw_pkt.u.request[0] = 0x00;
 			fw_pkt.u.request[1] = 0x03;
 
 			/* send EOF command */
-			if ((errno = bus_adap->ops->upload_fw_pkt(bus_adap,(uint8_t *) &fw_pkt, 2, 0)) < 0)
+			errno = bus_adap->ops->upload_fw_pkt(bus_adap,
+							     (uint8_t *)
+							     &fw_pkt, 2, 0);
+			if (errno < 0)
 				goto error;
 		} else {
 			if (!addr_has_changed) {
@@ -144,7 +148,12 @@
 				data_len += sizeof(fw_pkt.raw.address);
 
 				/* send cmd to device */
-				if ((errno = bus_adap->ops->upload_fw_pkt(bus_adap, (uint8_t *) &fw_pkt, data_len, 0)) < 0)
+				errno = bus_adap->ops->upload_fw_pkt(bus_adap,
+								     (uint8_t *)
+								     &fw_pkt,
+								     data_len,
+								     0);
+				if (errno < 0)
 					goto error;
 			}
 		}
@@ -154,7 +163,8 @@
 	return (errno == 0) ? total_read_bytes : errno;
 }
 
-int as102_fw_upload(struct as102_bus_adapter_t *bus_adap) {
+int as102_fw_upload(struct as102_bus_adapter_t *bus_adap)
+{
 	int errno = -EFAULT;
 	const struct firmware *firmware;
 	unsigned char *cmd_buf = NULL;
@@ -179,20 +189,23 @@
 
 #if defined(CONFIG_FW_LOADER) || defined(CONFIG_FW_LOADER_MODULE)
 	/* allocate buffer to store firmware upload command and data */
-	if ((cmd_buf = kzalloc(MAX_FW_PKT_SIZE, GFP_KERNEL)) == NULL) {
+	cmd_buf = kzalloc(MAX_FW_PKT_SIZE, GFP_KERNEL);
+	if (cmd_buf == NULL) {
 		errno = -ENOMEM;
 		goto error;
 	}
 
 	/* request kernel to locate firmware file: part1 */
-	if ((errno = request_firmware(&firmware, fw1, &dev->dev)) < 0) {
+	errno = request_firmware(&firmware, fw1, &dev->dev);
+	if (errno < 0) {
 		printk(KERN_ERR "%s: unable to locate firmware file: %s\n",
 				 DRIVER_NAME, fw1);
 		goto error;
 	}
 
 	/* initiate firmware upload */
-	if ((errno = as102_firmware_upload(bus_adap, cmd_buf, firmware)) < 0) {
+	errno = as102_firmware_upload(bus_adap, cmd_buf, firmware);
+	if (errno < 0) {
 		printk(KERN_ERR "%s: error during firmware upload part1\n",
 				 DRIVER_NAME);
 		goto error;
@@ -206,14 +219,16 @@
 	mdelay(100);
 
 	/* request kernel to locate firmware file: part2 */
-	if ((errno = request_firmware(&firmware, fw2, &dev->dev)) < 0) {
+	errno = request_firmware(&firmware, fw2, &dev->dev);
+	if (errno < 0) {
 		printk(KERN_ERR "%s: unable to locate firmware file: %s\n",
 				 DRIVER_NAME, fw2);
 		goto error;
 	}
 
 	/* initiate firmware upload */
-	if ((errno = as102_firmware_upload(bus_adap, cmd_buf, firmware)) < 0) {
+	errno = as102_firmware_upload(bus_adap, cmd_buf, firmware);
+	if (errno < 0) {
 		printk(KERN_ERR "%s: error during firmware upload part2\n",
 				 DRIVER_NAME);
 		goto error;
