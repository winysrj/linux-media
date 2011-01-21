Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:57432 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752082Ab1AUEbA (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 20 Jan 2011 23:31:00 -0500
Received: from int-mx01.intmail.prod.int.phx2.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id p0L4Ux53024224
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Thu, 20 Jan 2011 23:31:00 -0500
From: Jarod Wilson <jarod@redhat.com>
To: linux-media@vger.kernel.org
Cc: Jarod Wilson <jarod@redhat.com>
Subject: [PATCH 2/3] lirc_zilog: z8 on usb doesn't like back-to-back i2c_master_send
Date: Thu, 20 Jan 2011 23:30:24 -0500
Message-Id: <1295584225-21210-3-git-send-email-jarod@redhat.com>
In-Reply-To: <1295584225-21210-1-git-send-email-jarod@redhat.com>
References: <1295584225-21210-1-git-send-email-jarod@redhat.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Both the HD-PVR and HVR-1950, driven by the hdpvr and pvrusb2 drivers
respectively, have a zilog z8 chip exposed via i2c. These are both
usb-connected devices, and on both of them, back-to-back i2c_master_send
calls that work fine with a z8 on a pci card fail with a -EIO, as the
chip isn't yet ready from the prior command. To cope with that, add a
delay and retry loop where necessary.

Signed-off-by: Jarod Wilson <jarod@redhat.com>
---
 drivers/staging/lirc/lirc_zilog.c |   32 ++++++++++++++++++++++++++------
 1 files changed, 26 insertions(+), 6 deletions(-)

diff --git a/drivers/staging/lirc/lirc_zilog.c b/drivers/staging/lirc/lirc_zilog.c
index 3fe5f41..0aad0d7 100644
--- a/drivers/staging/lirc/lirc_zilog.c
+++ b/drivers/staging/lirc/lirc_zilog.c
@@ -495,7 +495,7 @@ static int send_data_block(struct IR_tx *tx, unsigned char *data_block)
 /* send boot data to the IR TX device */
 static int send_boot_data(struct IR_tx *tx)
 {
-	int ret;
+	int ret, i;
 	unsigned char buf[4];
 
 	/* send the boot block */
@@ -503,7 +503,7 @@ static int send_boot_data(struct IR_tx *tx)
 	if (ret != 0)
 		return ret;
 
-	/* kick it off? */
+	/* Hit the go button to activate the new boot data */
 	buf[0] = 0x00;
 	buf[1] = 0x20;
 	ret = i2c_master_send(tx->c, buf, 2);
@@ -511,7 +511,19 @@ static int send_boot_data(struct IR_tx *tx)
 		zilog_error("i2c_master_send failed with %d\n", ret);
 		return ret < 0 ? ret : -EFAULT;
 	}
-	ret = i2c_master_send(tx->c, buf, 1);
+
+	/*
+	 * Wait for zilog to settle after hitting go post boot block upload.
+	 * Without this delay, the HD-PVR and HVR-1950 both return an -EIO
+	 * upon attempting to get firmware revision, and tx probe thus fails.
+	 */
+	for (i = 0; i < 10; i++) {
+		ret = i2c_master_send(tx->c, buf, 1);
+		if (ret == 1)
+			break;
+		udelay(100);
+	}
+
 	if (ret != 1) {
 		zilog_error("i2c_master_send failed with %d\n", ret);
 		return ret < 0 ? ret : -EFAULT;
@@ -523,8 +535,8 @@ static int send_boot_data(struct IR_tx *tx)
 		zilog_error("i2c_master_recv failed with %d\n", ret);
 		return 0;
 	}
-	if (buf[0] != 0x80) {
-		zilog_error("unexpected IR TX response: %02x\n", buf[0]);
+	if ((buf[0] != 0x80) && (buf[0] != 0xa0)) {
+		zilog_error("unexpected IR TX init response: %02x\n", buf[0]);
 		return 0;
 	}
 	zilog_notify("Zilog/Hauppauge IR blaster firmware version "
@@ -827,7 +839,15 @@ static int send_code(struct IR_tx *tx, unsigned int code, unsigned int key)
 		zilog_error("i2c_master_send failed with %d\n", ret);
 		return ret < 0 ? ret : -EFAULT;
 	}
-	ret = i2c_master_send(tx->c, buf, 1);
+
+	/* Give the z8 a moment to process data block */
+	for (i = 0; i < 10; i++) {
+		ret = i2c_master_send(tx->c, buf, 1);
+		if (ret == 1)
+			break;
+		udelay(100);
+	}
+
 	if (ret != 1) {
 		zilog_error("i2c_master_send failed with %d\n", ret);
 		return ret < 0 ? ret : -EFAULT;
-- 
1.7.3.4

