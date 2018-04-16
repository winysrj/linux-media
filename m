Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pf0-f196.google.com ([209.85.192.196]:39386 "EHLO
        mail-pf0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752630AbeDPCwQ (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sun, 15 Apr 2018 22:52:16 -0400
From: Akinobu Mita <akinobu.mita@gmail.com>
To: linux-media@vger.kernel.org, devicetree@vger.kernel.org
Cc: Akinobu Mita <akinobu.mita@gmail.com>,
        Jacopo Mondi <jacopo+renesas@jmondi.org>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Mauro Carvalho Chehab <mchehab@s-opensource.com>
Subject: [PATCH v2 01/10] media: ov772x: allow i2c controllers without I2C_FUNC_PROTOCOL_MANGLING
Date: Mon, 16 Apr 2018 11:51:42 +0900
Message-Id: <1523847111-12986-2-git-send-email-akinobu.mita@gmail.com>
In-Reply-To: <1523847111-12986-1-git-send-email-akinobu.mita@gmail.com>
References: <1523847111-12986-1-git-send-email-akinobu.mita@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The ov772x driver only works when the i2c controller have
I2C_FUNC_PROTOCOL_MANGLING.  However, many i2c controller drivers don't
support it.

The reason that the ov772x requires I2C_FUNC_PROTOCOL_MANGLING is that
it doesn't support repeated starts.

This changes the reading ov772x register method so that it doesn't
require I2C_FUNC_PROTOCOL_MANGLING by calling two separated i2c messages.

Cc: Jacopo Mondi <jacopo+renesas@jmondi.org>
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Cc: Sakari Ailus <sakari.ailus@linux.intel.com>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
---
* v2
- Replace the implementation of ov772x_read() instead of adding an
  alternative method

 drivers/media/i2c/ov772x.c | 19 ++++++++++++++-----
 1 file changed, 14 insertions(+), 5 deletions(-)

diff --git a/drivers/media/i2c/ov772x.c b/drivers/media/i2c/ov772x.c
index b62860c..7e79da0 100644
--- a/drivers/media/i2c/ov772x.c
+++ b/drivers/media/i2c/ov772x.c
@@ -542,9 +542,19 @@ static struct ov772x_priv *to_ov772x(struct v4l2_subdev *sd)
 	return container_of(sd, struct ov772x_priv, subdev);
 }
 
-static inline int ov772x_read(struct i2c_client *client, u8 addr)
+static int ov772x_read(struct i2c_client *client, u8 addr)
 {
-	return i2c_smbus_read_byte_data(client, addr);
+	int ret;
+	u8 val;
+
+	ret = i2c_master_send(client, &addr, 1);
+	if (ret < 0)
+		return ret;
+	ret = i2c_master_recv(client, &val, 1);
+	if (ret < 0)
+		return ret;
+
+	return val;
 }
 
 static inline int ov772x_write(struct i2c_client *client, u8 addr, u8 value)
@@ -1255,10 +1265,9 @@ static int ov772x_probe(struct i2c_client *client,
 		return -EINVAL;
 	}
 
-	if (!i2c_check_functionality(adapter, I2C_FUNC_SMBUS_BYTE_DATA |
-					      I2C_FUNC_PROTOCOL_MANGLING)) {
+	if (!i2c_check_functionality(adapter, I2C_FUNC_SMBUS_BYTE_DATA)) {
 		dev_err(&adapter->dev,
-			"I2C-Adapter doesn't support SMBUS_BYTE_DATA or PROTOCOL_MANGLING\n");
+			"I2C-Adapter doesn't support SMBUS_BYTE_DATA\n");
 		return -EIO;
 	}
 	client->flags |= I2C_CLIENT_SCCB;
-- 
2.7.4
