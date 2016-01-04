Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:54750 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753645AbcADM0f (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 4 Jan 2016 07:26:35 -0500
From: Javier Martinez Canillas <javier@osg.samsung.com>
To: linux-kernel@vger.kernel.org
Cc: devicetree@vger.kernel.org,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Enrico Butera <ebutera@gmail.com>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Enric Balletbo i Serra <eballetbo@gmail.com>,
	Rob Herring <robh+dt@kernel.org>,
	Eduard Gavin <egavinc@gmail.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	linux-media@vger.kernel.org,
	Javier Martinez Canillas <javier@osg.samsung.com>
Subject: [PATCH 08/10] [media] tvp5150: Add OF match table
Date: Mon,  4 Jan 2016 09:25:30 -0300
Message-Id: <1451910332-23385-9-git-send-email-javier@osg.samsung.com>
In-Reply-To: <1451910332-23385-1-git-send-email-javier@osg.samsung.com>
References: <1451910332-23385-1-git-send-email-javier@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Eduard Gavin <egavinc@gmail.com>

The Documentation/devicetree/bindings/media/i2c/tvp5150.txt DT binding doc
lists "ti,tvp5150" as the device compatible string but the driver does not
have an OF match table. Add the table to the driver so the I2C core can do
an OF style match.

Signed-off-by: Eduard Gavin <egavinc@gmail.com>
Signed-off-by: Javier Martinez Canillas <javier@osg.samsung.com>
---

 drivers/media/i2c/tvp5150.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/drivers/media/i2c/tvp5150.c b/drivers/media/i2c/tvp5150.c
index 105bd1c6b17f..caac96a577f8 100644
--- a/drivers/media/i2c/tvp5150.c
+++ b/drivers/media/i2c/tvp5150.c
@@ -1295,8 +1295,17 @@ static const struct i2c_device_id tvp5150_id[] = {
 };
 MODULE_DEVICE_TABLE(i2c, tvp5150_id);
 
+#if IS_ENABLED(CONFIG_OF)
+static const struct of_device_id tvp5150_of_match[] = {
+	{ .compatible = "ti,tvp5150", },
+	{ /* sentinel */ },
+};
+MODULE_DEVICE_TABLE(of, tvp5150_of_match);
+#endif
+
 static struct i2c_driver tvp5150_driver = {
 	.driver = {
+		.of_match_table = of_match_ptr(tvp5150_of_match),
 		.name	= "tvp5150",
 	},
 	.probe		= tvp5150_probe,
-- 
2.4.3

