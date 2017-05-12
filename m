Return-path: <linux-media-owner@vger.kernel.org>
Received: from relay4-d.mail.gandi.net ([217.70.183.196]:56025 "EHLO
        relay4-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751323AbdELJwx (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 12 May 2017 05:52:53 -0400
From: Jacopo Mondi <jacopo@jmondi.org>
To: laurent.pinchart@ideasonboard.com, mchehab@kernel.org,
        hans.verkuil@cisco.com, sakari.ailus@linux.intel.com,
        sre@kernel.org, magnus.damm@gmail.com,
        wsa+renesas@sang-engineering.com
Cc: linux-media@vger.kernel.org, linux-renesas-soc@vger.kernel.org
Subject: [PATCH] media: i2c: ov772x: Force use of SCCB protocol
Date: Fri, 12 May 2017 11:52:43 +0200
Message-Id: <1494582763-22385-1-git-send-email-jacopo@jmondi.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Force use of Omnivision's SCCB protocol and make sure the I2c adapter
supports protocol mangling during probe.

Testing done on SH4 Migo-R board.
As commit:
[e789029761503f0cce03e8767a56ae099b88e1bd]
"i2c: sh_mobile: don't send a stop condition by default inside transfers"
makes the i2c adapter emit a stop bit between messages in a single
transfer only when explicitly required, the ov772x driver fails to
probe due to i2c transfer timeout without SCCB flag set.

i2c-sh_mobile i2c-sh_mobile.0: Transfer request timed out
ov772x 0-0021: Product ID error 92:92

With this patch applied:

soc-camera-pdrv soc-camera-pdrv.0: Probing soc-camera-pdrv.0
ov772x 0-0021: ov7725 Product ID 77:21 Manufacturer ID 7f:a2

Signed-off-by: Jacopo Mondi <jacopo@jmondi.org>
---
 drivers/media/i2c/soc_camera/ov772x.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/media/i2c/soc_camera/ov772x.c b/drivers/media/i2c/soc_camera/ov772x.c
index 985a367..8a4b29e 100644
--- a/drivers/media/i2c/soc_camera/ov772x.c
+++ b/drivers/media/i2c/soc_camera/ov772x.c
@@ -1067,6 +1067,7 @@ static int ov772x_probe(struct i2c_client *client,
 			"I2C-Adapter doesn't support I2C_FUNC_SMBUS_BYTE_DATA\n");
 		return -EIO;
 	}
+	client->flags |= I2C_CLIENT_SCCB;
 
 	priv = devm_kzalloc(&client->dev, sizeof(*priv), GFP_KERNEL);
 	if (!priv)
-- 
2.7.4
