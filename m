Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pg0-f66.google.com ([74.125.83.66]:33319 "EHLO
        mail-pg0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753775AbdCBAWs (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Wed, 1 Mar 2017 19:22:48 -0500
Date: Wed, 1 Mar 2017 15:50:03 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Mauro Carvalho Chehab <mchehab@kernel.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jean-Baptiste Abbadie <jb@abbadie.fr>,
        Claudiu Beznea <claudiu.beznea@gmail.com>,
        linux-media@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] [media] Staging: media: radio-bcm2048: remove incorrect
 __exit markups
Message-ID: <20170301235003.GA18340@dtor-ws>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Even if bus is not hot-pluggable, devices can be unbound from the
driver via sysfs, so we should not be using __exit annotations on
remove() methods. The only exception is drivers registered with
platform_driver_probe() which specifically disables sysfs bind/unbind
attributes.

Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
---
 drivers/staging/media/bcm2048/radio-bcm2048.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/media/bcm2048/radio-bcm2048.c b/drivers/staging/media/bcm2048/radio-bcm2048.c
index 37bd439ee08b..1fba377f816b 100644
--- a/drivers/staging/media/bcm2048/radio-bcm2048.c
+++ b/drivers/staging/media/bcm2048/radio-bcm2048.c
@@ -2634,7 +2634,7 @@ static int bcm2048_i2c_driver_probe(struct i2c_client *client,
 	return err;
 }
 
-static int __exit bcm2048_i2c_driver_remove(struct i2c_client *client)
+static int bcm2048_i2c_driver_remove(struct i2c_client *client)
 {
 	struct bcm2048_device *bdev = i2c_get_clientdata(client);
 
@@ -2673,7 +2673,7 @@ static struct i2c_driver bcm2048_i2c_driver = {
 		.name	= BCM2048_DRIVER_NAME,
 	},
 	.probe		= bcm2048_i2c_driver_probe,
-	.remove		= __exit_p(bcm2048_i2c_driver_remove),
+	.remove		= bcm2048_i2c_driver_remove,
 	.id_table	= bcm2048_id,
 };
 
-- 
2.12.0.rc1.440.g5b76565f74-goog


-- 
Dmitry
