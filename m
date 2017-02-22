Return-path: <linux-media-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:45010
        "EHLO osg.samsung.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S932511AbdBVQTx (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 22 Feb 2017 11:19:53 -0500
From: Javier Martinez Canillas <javier@osg.samsung.com>
To: linux-kernel@vger.kernel.org
Cc: Javier Martinez Canillas <javier@osg.samsung.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        linux-media@vger.kernel.org
Subject: [PATCH 1/3] [media] soc-camera: ov5642: Add OF device ID table
Date: Wed, 22 Feb 2017 13:11:27 -0300
Message-Id: <20170222161129.28613-1-javier@osg.samsung.com>
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

 drivers/media/i2c/soc_camera/ov5642.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/drivers/media/i2c/soc_camera/ov5642.c b/drivers/media/i2c/soc_camera/ov5642.c
index 3d185bd622a3..1926f382dfce 100644
--- a/drivers/media/i2c/soc_camera/ov5642.c
+++ b/drivers/media/i2c/soc_camera/ov5642.c
@@ -1063,9 +1063,18 @@ static const struct i2c_device_id ov5642_id[] = {
 };
 MODULE_DEVICE_TABLE(i2c, ov5642_id);
 
+#if IS_ENABLED(CONFIG_OF)
+static const struct of_device_id ov5642_of_match[] = {
+	{ .compatible = "ovti,ov5642" },
+	{ },
+};
+MODULE_DEVICE_TABLE(of, ov5642_of_match);
+#endif
+
 static struct i2c_driver ov5642_i2c_driver = {
 	.driver = {
 		.name = "ov5642",
+		.of_match_table = of_match_ptr(ov5642_of_match),
 	},
 	.probe		= ov5642_probe,
 	.remove		= ov5642_remove,
-- 
2.9.3
