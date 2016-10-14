Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:59056 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756467AbcJNUWn (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 14 Oct 2016 16:22:43 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
Subject: [PATCH 06/57] [media] soc_camera: don't break long lines
Date: Fri, 14 Oct 2016 17:19:54 -0300
Message-Id: <b43d1aa0ccb026534774b21cf5ec61950f4f1517.1476475771.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1476475770.git.mchehab@s-opensource.com>
References: <cover.1476475770.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1476475770.git.mchehab@s-opensource.com>
References: <cover.1476475770.git.mchehab@s-opensource.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Due to the 80-cols checkpatch warnings, several strings
were broken into multiple lines. This is not considered
a good practice anymore, as it makes harder to grep for
strings at the source code. So, join those continuation
lines.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 drivers/media/i2c/soc_camera/ov772x.c | 3 +--
 drivers/media/i2c/soc_camera/ov9740.c | 3 +--
 drivers/media/i2c/soc_camera/tw9910.c | 3 +--
 3 files changed, 3 insertions(+), 6 deletions(-)

diff --git a/drivers/media/i2c/soc_camera/ov772x.c b/drivers/media/i2c/soc_camera/ov772x.c
index 7e68762b3a4b..985a3672b243 100644
--- a/drivers/media/i2c/soc_camera/ov772x.c
+++ b/drivers/media/i2c/soc_camera/ov772x.c
@@ -1064,8 +1064,7 @@ static int ov772x_probe(struct i2c_client *client,
 
 	if (!i2c_check_functionality(adapter, I2C_FUNC_SMBUS_BYTE_DATA)) {
 		dev_err(&adapter->dev,
-			"I2C-Adapter doesn't support "
-			"I2C_FUNC_SMBUS_BYTE_DATA\n");
+			"I2C-Adapter doesn't support I2C_FUNC_SMBUS_BYTE_DATA\n");
 		return -EIO;
 	}
 
diff --git a/drivers/media/i2c/soc_camera/ov9740.c b/drivers/media/i2c/soc_camera/ov9740.c
index 0da632d7d33a..f11f76cdacad 100644
--- a/drivers/media/i2c/soc_camera/ov9740.c
+++ b/drivers/media/i2c/soc_camera/ov9740.c
@@ -881,8 +881,7 @@ static int ov9740_video_probe(struct i2c_client *client)
 		goto done;
 	}
 
-	dev_info(&client->dev, "ov9740 Model ID 0x%04x, Revision 0x%02x, "
-		 "Manufacturer 0x%02x, SMIA Version 0x%02x\n",
+	dev_info(&client->dev, "ov9740 Model ID 0x%04x, Revision 0x%02x, Manufacturer 0x%02x, SMIA Version 0x%02x\n",
 		 priv->model, priv->revision, priv->manid, priv->smiaver);
 
 	ret = v4l2_ctrl_handler_setup(&priv->hdl);
diff --git a/drivers/media/i2c/soc_camera/tw9910.c b/drivers/media/i2c/soc_camera/tw9910.c
index 4002c07f3857..c9c49ed707b8 100644
--- a/drivers/media/i2c/soc_camera/tw9910.c
+++ b/drivers/media/i2c/soc_camera/tw9910.c
@@ -947,8 +947,7 @@ static int tw9910_probe(struct i2c_client *client,
 
 	if (!i2c_check_functionality(adapter, I2C_FUNC_SMBUS_BYTE_DATA)) {
 		dev_err(&client->dev,
-			"I2C-Adapter doesn't support "
-			"I2C_FUNC_SMBUS_BYTE_DATA\n");
+			"I2C-Adapter doesn't support I2C_FUNC_SMBUS_BYTE_DATA\n");
 		return -EIO;
 	}
 
-- 
2.7.4


