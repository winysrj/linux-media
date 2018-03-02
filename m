Return-path: <linux-media-owner@vger.kernel.org>
Received: from relay3-d.mail.gandi.net ([217.70.183.195]:42589 "EHLO
        relay3-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1426315AbeCBOrD (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 2 Mar 2018 09:47:03 -0500
From: Jacopo Mondi <jacopo+renesas@jmondi.org>
To: mchehab@s-opensource.com, laurent.pinchart@ideasonboard.com,
        hans.verkuil@cisco.com, g.liakhovetski@gmx.de, bhumirks@gmail.com,
        joe@perches.com
Cc: Jacopo Mondi <jacopo+renesas@jmondi.org>,
        linux-media@vger.kernel.org
Subject: [PATCH v2 03/11] media: tw9910: Mixed style fixes
Date: Fri,  2 Mar 2018 15:46:35 +0100
Message-Id: <1520002003-10200-4-git-send-email-jacopo+renesas@jmondi.org>
In-Reply-To: <1520002003-10200-1-git-send-email-jacopo+renesas@jmondi.org>
References: <1520002003-10200-1-git-send-email-jacopo+renesas@jmondi.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Two minor style fixes, align function parameter and remove un-necessary
spaces.

Signed-off-by: Jacopo Mondi <jacopo+renesas@jmondi.org>
---
 drivers/media/i2c/tw9910.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/media/i2c/tw9910.c b/drivers/media/i2c/tw9910.c
index 1c3c8f0..0232017 100644
--- a/drivers/media/i2c/tw9910.c
+++ b/drivers/media/i2c/tw9910.c
@@ -533,9 +533,9 @@ static int tw9910_s_std(struct v4l2_subdev *sd, v4l2_std_id norm)
 	}
 	if (!ret)
 		ret = i2c_smbus_write_byte_data(client, CROP_HI,
-						((vdelay >> 2) & 0xc0) |
-						((vact >> 4) & 0x30) |
-						((hdelay >> 6) & 0x0c) |
+						((vdelay >> 2) & 0xc0)	|
+						((vact >> 4) & 0x30)	|
+						((hdelay >> 6) & 0x0c)	|
 						((hact >> 8) & 0x03));
 	if (!ret)
 		ret = i2c_smbus_write_byte_data(client, VDELAY_LO,
@@ -953,7 +953,7 @@ static int tw9910_probe(struct i2c_client *client,
 	if (!priv)
 		return -ENOMEM;
 
-	priv->info   = info;
+	priv->info = info;
 
 	v4l2_i2c_subdev_init(&priv->subdev, client, &tw9910_subdev_ops);
 
-- 
2.7.4
