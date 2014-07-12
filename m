Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-we0-f176.google.com ([74.125.82.176]:54399 "EHLO
	mail-we0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752191AbaGLSuL (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 12 Jul 2014 14:50:11 -0400
Received: by mail-we0-f176.google.com with SMTP id u56so2439240wes.21
        for <linux-media@vger.kernel.org>; Sat, 12 Jul 2014 11:50:09 -0700 (PDT)
From: Luke Hart <luke.hart@birchleys.eu>
To: m.chehab@samsung.com
Cc: linux-media@vger.kernel.org, Luke Hart <luke.hart@birchleys.eu>
Subject: [PATCH] radio-bcm2048.c: Fix some checkpatch.pl errors
Date: Sat, 12 Jul 2014 19:48:22 +0100
Message-Id: <1405190902-29224-1-git-send-email-luke.hart@birchleys.eu>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Fix the following warnings reported in radio-bcm2048.c:

WARNING: else is not generally useful after a break or return
#374: FILE: radio-bcm2048.c:374:
+		return 0;
+	} else {

WARNING: else is not generally useful after a break or return
#728: FILE: radio-bcm2048.c:728:
+			return BCM2048_DE_EMPHASIS_75us;
+		else

WARNING: unchecked sscanf return value
#1974: FILE: radio-bcm2048.c:1974:
+	sscanf(buf, mask, &value);					\

WARNING: Missing a blank line after declarations
#2245: FILE: radio-bcm2048.c:2245:
+		unsigned char tmpbuf[3];
+		tmpbuf[i] = bdev->rds_info.radio_text[bdev->rd_index+i+2];

WARNING: Possible unnecessary 'out of memory' message
#2601: FILE: radio-bcm2048.c:2601:
+	if (!bdev) {
+		dev_dbg(&client->dev, "Failed to alloc video device.\n");

The following error was left since it seems to be a false positive:

ERROR: Macros with complex values should be enclosed in parenthesis
#2021: FILE: radio-bcm2048.c:2021:
+#define DEFINE_SYSFS_PROPERTY(prop, signal, size, mask, check)		\
+property_write(prop, signal size, mask, check)				\
+property_read(prop, size, mask)

Signed-off-by: Luke Hart <luke.hart@birchleys.eu>
---
 drivers/staging/media/bcm2048/radio-bcm2048.c | 20 ++++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

diff --git a/drivers/staging/media/bcm2048/radio-bcm2048.c b/drivers/staging/media/bcm2048/radio-bcm2048.c
index bbf236e..6a07b46 100644
--- a/drivers/staging/media/bcm2048/radio-bcm2048.c
+++ b/drivers/staging/media/bcm2048/radio-bcm2048.c
@@ -369,13 +369,12 @@ static int bcm2048_send_command(struct bcm2048_device *bdev, unsigned int reg,
 	data[0] = reg & 0xff;
 	data[1] = value & 0xff;
 
-	if (i2c_master_send(client, data, 2) == 2) {
+	if (i2c_master_send(client, data, 2) == 2)
 		return 0;
-	} else {
-		dev_err(&bdev->client->dev, "BCM I2C error!\n");
-		dev_err(&bdev->client->dev, "Is Bluetooth up and running?\n");
-		return -EIO;
-	}
+
+	dev_err(&bdev->client->dev, "BCM I2C error!\n");
+	dev_err(&bdev->client->dev, "Is Bluetooth up and running?\n");
+	return -EIO;
 }
 
 static int bcm2048_recv_command(struct bcm2048_device *bdev, unsigned int reg,
@@ -725,8 +724,8 @@ static int bcm2048_get_fm_deemphasis(struct bcm2048_device *bdev)
 	if (!err) {
 		if (value & BCM2048_DE_EMPHASIS_SELECT)
 			return BCM2048_DE_EMPHASIS_75us;
-		else
-			return BCM2048_DE_EMPHASIS_50us;
+
+		return BCM2048_DE_EMPHASIS_50us;
 	}
 
 	return err;
@@ -1971,7 +1970,8 @@ static ssize_t bcm2048_##prop##_write(struct device *dev,		\
 	if (!bdev)							\
 		return -ENODEV;						\
 									\
-	sscanf(buf, mask, &value);					\
+	if (sscanf(buf, mask, &value) != 1)				\
+		return -EINVAL;						\
 									\
 	if (check)							\
 		return -EDOM;						\
@@ -2242,6 +2242,7 @@ static ssize_t bcm2048_fops_read(struct file *file, char __user *buf,
 	i = 0;
 	while (i < count) {
 		unsigned char tmpbuf[3];
+
 		tmpbuf[i] = bdev->rds_info.radio_text[bdev->rd_index+i+2];
 		tmpbuf[i+1] = bdev->rds_info.radio_text[bdev->rd_index+i+1];
 		tmpbuf[i+2] = ((bdev->rds_info.radio_text[bdev->rd_index+i]
@@ -2598,7 +2599,6 @@ static int bcm2048_i2c_driver_probe(struct i2c_client *client,
 
 	bdev = kzalloc(sizeof(*bdev), GFP_KERNEL);
 	if (!bdev) {
-		dev_dbg(&client->dev, "Failed to alloc video device.\n");
 		err = -ENOMEM;
 		goto exit;
 	}
-- 
2.0.0

