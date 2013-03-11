Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr8.xs4all.nl ([194.109.24.28]:2389 "EHLO
	smtp-vbr8.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754097Ab3CKLqs (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 11 Mar 2013 07:46:48 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Volokh Konstantin <volokh84@gmail.com>,
	Pete Eberlein <pete@sensoray.com>,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [REVIEW PATCH 07/42] go7007: fix i2c_xfer return codes.
Date: Mon, 11 Mar 2013 12:45:45 +0100
Message-Id: <92c6630881cc15a17e36f0aad5c2fd2f887ef7c2.1363000605.git.hans.verkuil@cisco.com>
In-Reply-To: <1363002380-19825-1-git-send-email-hverkuil@xs4all.nl>
References: <1363002380-19825-1-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <38bc3cc42d0c021432afd29c2c1e22cf380b06e0.1363000605.git.hans.verkuil@cisco.com>
References: <38bc3cc42d0c021432afd29c2c1e22cf380b06e0.1363000605.git.hans.verkuil@cisco.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

The i2c_xfer functions didn't return the proper error codes and (especially
important) on success they returned 0 instead of the number of transferred
messages.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/staging/media/go7007/go7007-i2c.c |   20 ++++++++++----------
 drivers/staging/media/go7007/go7007-usb.c |    6 +++---
 2 files changed, 13 insertions(+), 13 deletions(-)

diff --git a/drivers/staging/media/go7007/go7007-i2c.c b/drivers/staging/media/go7007/go7007-i2c.c
index 39456a3..1d0a400 100644
--- a/drivers/staging/media/go7007/go7007-i2c.c
+++ b/drivers/staging/media/go7007/go7007-i2c.c
@@ -52,11 +52,11 @@ static DEFINE_MUTEX(adlink_mpg24_i2c_lock);
 static int go7007_i2c_xfer(struct go7007 *go, u16 addr, int read,
 		u16 command, int flags, u8 *data)
 {
-	int i, ret = -1;
+	int i, ret = -EIO;
 	u16 val;
 
 	if (go->status == STATUS_SHUTDOWN)
-		return -1;
+		return -ENODEV;
 
 #ifdef GO7007_I2C_DEBUG
 	if (read)
@@ -146,7 +146,7 @@ static int go7007_smbus_xfer(struct i2c_adapter *adapter, u16 addr,
 	struct go7007 *go = i2c_get_adapdata(adapter);
 
 	if (size != I2C_SMBUS_BYTE_DATA)
-		return -1;
+		return -EIO;
 	return go7007_i2c_xfer(go, addr, read_write == I2C_SMBUS_READ, command,
 			flags & I2C_CLIENT_SCCB ? 0x10 : 0x00, &data->byte);
 }
@@ -170,26 +170,26 @@ static int go7007_i2c_master_xfer(struct i2c_adapter *adapter,
 					(msgs[i].flags & I2C_M_RD) ||
 					!(msgs[i + 1].flags & I2C_M_RD) ||
 					msgs[i + 1].len != 1)
-				return -1;
+				return -EIO;
 			if (go7007_i2c_xfer(go, msgs[i].addr, 1,
 					(msgs[i].buf[0] << 8) | msgs[i].buf[1],
 					0x01, &msgs[i + 1].buf[0]) < 0)
-				return -1;
+				return -EIO;
 			++i;
 		} else if (msgs[i].len == 3) {
 			if (msgs[i].flags & I2C_M_RD)
-				return -1;
+				return -EIO;
 			if (msgs[i].len != 3)
-				return -1;
+				return -EIO;
 			if (go7007_i2c_xfer(go, msgs[i].addr, 0,
 					(msgs[i].buf[0] << 8) | msgs[i].buf[1],
 					0x01, &msgs[i].buf[2]) < 0)
-				return -1;
+				return -EIO;
 		} else
-			return -1;
+			return -EIO;
 	}
 
-	return 0;
+	return num;
 }
 
 static u32 go7007_functionality(struct i2c_adapter *adapter)
diff --git a/drivers/staging/media/go7007/go7007-usb.c b/drivers/staging/media/go7007/go7007-usb.c
index 9dbf5ec..914b247 100644
--- a/drivers/staging/media/go7007/go7007-usb.c
+++ b/drivers/staging/media/go7007/go7007-usb.c
@@ -876,10 +876,10 @@ static int go7007_usb_i2c_master_xfer(struct i2c_adapter *adapter,
 	struct go7007_usb *usb = go->hpi_context;
 	u8 buf[16];
 	int buf_len, i;
-	int ret = -1;
+	int ret = -EIO;
 
 	if (go->status == STATUS_SHUTDOWN)
-		return -1;
+		return -ENODEV;
 
 	mutex_lock(&usb->i2c_lock);
 
@@ -936,7 +936,7 @@ static int go7007_usb_i2c_master_xfer(struct i2c_adapter *adapter,
 			memcpy(msgs[i].buf, buf + 1, msgs[i].len);
 		}
 	}
-	ret = 0;
+	ret = num;
 
 i2c_done:
 	mutex_unlock(&usb->i2c_lock);
-- 
1.7.10.4

