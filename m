Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ey0-f174.google.com ([209.85.215.174]:58562 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752682Ab1JaQZh (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 31 Oct 2011 12:25:37 -0400
Received: by mail-ey0-f174.google.com with SMTP id 27so5444327eye.19
        for <linux-media@vger.kernel.org>; Mon, 31 Oct 2011 09:25:36 -0700 (PDT)
From: Sylwester Nawrocki <snjw23@gmail.com>
To: devel@driverdev.osuosl.org, linux-media@vger.kernel.org
Cc: Piotr Chmura <chmooreck@poczta.onet.pl>,
	Devin Heitmueller <dheitmueller@kernellabs.com>,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	Sylwester Nawrocki <snjw23@gmail.com>,
	Stefan Richter <stefanr@s5r6.in-berlin.de>,
	Greg KH <gregkh@suse.de>
Subject: [PATCH 03/17] staging: as102: Fix CodingStyle errors in file as102_fw.c
Date: Mon, 31 Oct 2011 17:24:41 +0100
Message-Id: <1320078295-3379-4-git-send-email-snjw23@gmail.com>
In-Reply-To: <1320078295-3379-1-git-send-email-snjw23@gmail.com>
References: <1320078295-3379-1-git-send-email-snjw23@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Devin Heitmueller <dheitmueller@kernellabs.com>

Fix Linux kernel coding style (whitespace and indentation) errors
in file as102_fw.c. No functional changes.

Signed-off-by: Devin Heitmueller <dheitmueller@kernellabs.com>
Signed-off-by: Piotr Chmura <chmooreck@poczta.onet.pl>
Signed-off-by: Sylwester Nawrocki <snjw23@gmail.com>
---
 drivers/staging/media/as102/as102_fw.c |  101 ++++++++++++++++++--------------
 1 files changed, 58 insertions(+), 43 deletions(-)

diff --git a/drivers/staging/media/as102/as102_fw.c b/drivers/staging/media/as102/as102_fw.c
index d921a6f..c019df9 100644
--- a/drivers/staging/media/as102/as102_fw.c
+++ b/drivers/staging/media/as102/as102_fw.c
@@ -1,6 +1,7 @@
 /*
  * Abilis Systems Single DVB-T Receiver
  * Copyright (C) 2008 Pierrick Hascoet <pierrick.hascoet@abilis.com>
+ * Copyright (C) 2010 Devin Heitmueller <dheitmueller@kernellabs.com>
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License as published by
@@ -31,15 +32,16 @@ char as102_st_fw2[] = "as102_data2_st.hex";
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
@@ -62,43 +64,42 @@ static int parse_hex_line(unsigned char *fw_data, unsigned char *addr,
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
@@ -122,17 +123,20 @@ static int as102_firmware_upload(struct as102_bus_adapter_t *bus_adap,
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
@@ -144,7 +148,12 @@ static int as102_firmware_upload(struct as102_bus_adapter_t *bus_adap,
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
@@ -154,7 +163,8 @@ error:
 	return (errno == 0) ? total_read_bytes : errno;
 }
 
-int as102_fw_upload(struct as102_bus_adapter_t *bus_adap) {
+int as102_fw_upload(struct as102_bus_adapter_t *bus_adap)
+{
 	int errno = -EFAULT;
 	const struct firmware *firmware;
 	unsigned char *cmd_buf = NULL;
@@ -179,20 +189,23 @@ int as102_fw_upload(struct as102_bus_adapter_t *bus_adap) {
 
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
@@ -206,14 +219,16 @@ int as102_fw_upload(struct as102_bus_adapter_t *bus_adap) {
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
-- 
1.7.4.1

