Return-path: <linux-media-owner@vger.kernel.org>
Received: from relay4-d.mail.gandi.net ([217.70.183.196]:37020 "EHLO
        relay4-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751272AbdELMhI (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 12 May 2017 08:37:08 -0400
From: Jacopo Mondi <jacopo@jmondi.org>
To: laurent.pinchart@ideasonboard.com, mchehab@kernel.org,
        hans.verkuil@cisco.com, sakari.ailus@linux.intel.com,
        sre@kernel.org, magnus.damm@gmail.com,
        wsa+renesas@sang-engineering.com
Cc: linux-media@vger.kernel.org, linux-renesas-soc@vger.kernel.org
Subject: [PATCH v3] media: i2c: ov772x: Force use of SCCB protocol
Date: Fri, 12 May 2017 14:36:59 +0200
Message-Id: <1494592619-23231-1-git-send-email-jacopo@jmondi.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Commit e78902976150 ("i2c: sh_mobile: don't send a stop condition by
default inside transfers") makes the i2c_sh_mobile I2C-adapter emit a
stop/start sequence between messages in a single transfer only when
explicitly requested with I2C_M_STOP.

This breaks the ov772x driver in the SH4 Migo-R board as the Omnivision
sensor uses the I2C-like SCCB protocol that doesn't support repeated
starts:

i2c-sh_mobile i2c-sh_mobile.0: Transfer request timed out
ov772x 0-0021: Product ID error 92:92

Fix it by marking the client as SCCB, forcing the emission of a
stop/start sequence between all messages.
As I2C_M_STOP requires the I2C adapter to support protocol mangling,
ensure that the I2C_FUNC_PROTOCOL_MANGLING functionality is available.

Tested on SH4 Migo-R board, with OV772x now successfully probing

soc-camera-pdrv soc-camera-pdrv.0: Probing soc-camera-pdrv.0
ov772x 0-0021: ov7725 Product ID 77:21 Manufacturer ID 7f:a2

Signed-off-by: Jacopo Mondi <jacopo@jmondi.org>
Suggested-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Acked-by: Wolfram Sang <wsa+renesas@sang-engineering.com>
Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

---
v1 -> v2:
- change commit message to describe what this fix is for first.

v2 -> v3:
- add to commit message that patch checks for I2C_FUNC_PROTOCOL_MANGLING support


 drivers/media/i2c/soc_camera/ov772x.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/media/i2c/soc_camera/ov772x.c b/drivers/media/i2c/soc_camera/ov772x.c
index 985a367..351abec 100644
--- a/drivers/media/i2c/soc_camera/ov772x.c
+++ b/drivers/media/i2c/soc_camera/ov772x.c
@@ -1062,11 +1062,13 @@ static int ov772x_probe(struct i2c_client *client,
 		return -EINVAL;
 	}

-	if (!i2c_check_functionality(adapter, I2C_FUNC_SMBUS_BYTE_DATA)) {
+	if (!i2c_check_functionality(adapter, I2C_FUNC_SMBUS_BYTE_DATA |
+					      I2C_FUNC_PROTOCOL_MANGLING)) {
 		dev_err(&adapter->dev,
-			"I2C-Adapter doesn't support I2C_FUNC_SMBUS_BYTE_DATA\n");
+			"I2C-Adapter doesn't support SMBUS_BYTE_DATA or PROTOCOL_MANGLING\n");
 		return -EIO;
 	}
+	client->flags |= I2C_CLIENT_SCCB;

 	priv = devm_kzalloc(&client->dev, sizeof(*priv), GFP_KERNEL);
 	if (!priv)
--
2.7.4
