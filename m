Return-path: <linux-media-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:45013
        "EHLO osg.samsung.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S932519AbdBVQTx (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 22 Feb 2017 11:19:53 -0500
From: Javier Martinez Canillas <javier@osg.samsung.com>
To: linux-kernel@vger.kernel.org
Cc: Javier Martinez Canillas <javier@osg.samsung.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Eduardo Valentin <edubezval@gmail.com>,
        linux-media@vger.kernel.org
Subject: [PATCH 3/3] [media] si4713: Add OF device ID table
Date: Wed, 22 Feb 2017 13:11:29 -0300
Message-Id: <20170222161129.28613-3-javier@osg.samsung.com>
In-Reply-To: <20170222161129.28613-1-javier@osg.samsung.com>
References: <20170222161129.28613-1-javier@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The driver doesn't have a struct of_device_id table but supported devices
are registered via Device Trees. This is working on the assumption that a
I2C device registered via OF will always match a legacy I2C device ID and
that the MODALIAS reported will always be of the form i2c:<device>.

But this could change in the future so the correct approach is to have an
OF device ID table if the devices are registered via OF.

Signed-off-by: Javier Martinez Canillas <javier@osg.samsung.com>
---

 drivers/media/radio/si4713/si4713.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/drivers/media/radio/si4713/si4713.c b/drivers/media/radio/si4713/si4713.c
index 60f026a58076..f4a53f1e856e 100644
--- a/drivers/media/radio/si4713/si4713.c
+++ b/drivers/media/radio/si4713/si4713.c
@@ -1656,9 +1656,18 @@ static const struct i2c_device_id si4713_id[] = {
 };
 MODULE_DEVICE_TABLE(i2c, si4713_id);
 
+#if IS_ENABLED(CONFIG_OF)
+static const struct of_device_id si4713_of_match[] = {
+	{ .compatible = "silabs,si4713" },
+	{ },
+};
+MODULE_DEVICE_TABLE(of, si4713_of_match);
+#endif
+
 static struct i2c_driver si4713_i2c_driver = {
 	.driver		= {
 		.name	= "si4713",
+		.of_match_table = of_match_ptr(si4713_of_match),
 	},
 	.probe		= si4713_probe,
 	.remove         = si4713_remove,
-- 
2.9.3
