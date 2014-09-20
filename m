Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr9.xs4all.nl ([194.109.24.29]:3338 "EHLO
	smtp-vbr9.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756072AbaITMmI (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 20 Sep 2014 08:42:08 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCH 06/16] cx88: return proper errors during fw load
Date: Sat, 20 Sep 2014 14:41:41 +0200
Message-Id: <1411216911-7950-7-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1411216911-7950-1-git-send-email-hverkuil@xs4all.nl>
References: <1411216911-7950-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Don't return -1, return a proper error.

Replace dprintk(0, ...) by pr_err since firmware load errors should just be
reported as an error.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/pci/cx88/cx88-blackbird.c | 32 +++++++++++++++-----------------
 1 file changed, 15 insertions(+), 17 deletions(-)

diff --git a/drivers/media/pci/cx88/cx88-blackbird.c b/drivers/media/pci/cx88/cx88-blackbird.c
index 32abba4..11054cd 100644
--- a/drivers/media/pci/cx88/cx88-blackbird.c
+++ b/drivers/media/pci/cx88/cx88-blackbird.c
@@ -322,13 +322,13 @@ static int blackbird_mbox_func(void *priv, u32 command, int in, int out, u32 dat
 	memory_read(dev->core, dev->mailbox - 4, &value);
 	if (value != 0x12345678) {
 		dprintk(0, "Firmware and/or mailbox pointer not initialized or corrupted\n");
-		return -1;
+		return -EIO;
 	}
 
 	memory_read(dev->core, dev->mailbox, &flag);
 	if (flag) {
 		dprintk(0, "ERROR: Mailbox appears to be in use (%x)\n", flag);
-		return -1;
+		return -EIO;
 	}
 
 	flag |= 1; /* tell 'em we're working on it */
@@ -354,8 +354,8 @@ static int blackbird_mbox_func(void *priv, u32 command, int in, int out, u32 dat
 		if (0 != (flag & 4))
 			break;
 		if (time_after(jiffies,timeout)) {
-			dprintk(0, "ERROR: API Mailbox timeout\n");
-			return -1;
+			dprintk(0, "ERROR: API Mailbox timeout %x\n", command);
+			return -EIO;
 		}
 		udelay(10);
 	}
@@ -416,7 +416,7 @@ static int blackbird_find_mailbox(struct cx8802_dev *dev)
 		}
 	}
 	dprintk(0, "Mailbox signature values not found!\n");
-	return -1;
+	return -EIO;
 }
 
 static int blackbird_load_firmware(struct cx8802_dev *dev)
@@ -445,24 +445,23 @@ static int blackbird_load_firmware(struct cx8802_dev *dev)
 
 
 	if (retval != 0) {
-		dprintk(0, "ERROR: Hotplug firmware request failed (%s).\n",
+		pr_err("Hotplug firmware request failed (%s).\n",
 			CX2341X_FIRM_ENC_FILENAME);
-		dprintk(0, "Please fix your hotplug setup, the board will "
-			"not work without firmware loaded!\n");
-		return -1;
+		pr_err("Please fix your hotplug setup, the board will not work without firmware loaded!\n");
+		return -EIO;
 	}
 
 	if (firmware->size != BLACKBIRD_FIRM_IMAGE_SIZE) {
-		dprintk(0, "ERROR: Firmware size mismatch (have %zd, expected %d)\n",
+		pr_err("Firmware size mismatch (have %zd, expected %d)\n",
 			firmware->size, BLACKBIRD_FIRM_IMAGE_SIZE);
 		release_firmware(firmware);
-		return -1;
+		return -EINVAL;
 	}
 
 	if (0 != memcmp(firmware->data, magic, 8)) {
-		dprintk(0, "ERROR: Firmware magic mismatch, wrong file?\n");
+		pr_err("Firmware magic mismatch, wrong file?\n");
 		release_firmware(firmware);
-		return -1;
+		return -EINVAL;
 	}
 
 	/* transfer to the chip */
@@ -480,12 +479,11 @@ static int blackbird_load_firmware(struct cx8802_dev *dev)
 		memory_read(dev->core, i, &value);
 		checksum -= ~value;
 	}
+	release_firmware(firmware);
 	if (checksum) {
-		dprintk(0, "ERROR: Firmware load failed (checksum mismatch).\n");
-		release_firmware(firmware);
-		return -1;
+		pr_err("Firmware load might have failed (checksum mismatch).\n");
+		return -EIO;
 	}
-	release_firmware(firmware);
 	dprintk(0, "Firmware upload successful.\n");
 
 	retval |= register_write(dev->core, IVTV_REG_HW_BLOCKS, IVTV_CMD_HW_BLOCKS_RST);
-- 
2.1.0

