Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pf0-f196.google.com ([209.85.192.196]:34588 "EHLO
        mail-pf0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752865AbdCBAKo (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Wed, 1 Mar 2017 19:10:44 -0500
Date: Wed, 1 Mar 2017 15:41:23 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Mauro Carvalho Chehab <mchehab@kernel.org>
Cc: Pavel Machek <pavel@ucw.cz>, Hans Verkuil <hans.verkuil@cisco.com>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] [media] ad5820: remove incorrect __exit markups
Message-ID: <20170301234123.GA12089@dtor-ws>
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
 drivers/media/i2c/ad5820.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/media/i2c/ad5820.c b/drivers/media/i2c/ad5820.c
index a9026a91855e..3d2a3c6b67d8 100644
--- a/drivers/media/i2c/ad5820.c
+++ b/drivers/media/i2c/ad5820.c
@@ -336,7 +336,7 @@ static int ad5820_probe(struct i2c_client *client,
 	return ret;
 }
 
-static int __exit ad5820_remove(struct i2c_client *client)
+static int ad5820_remove(struct i2c_client *client)
 {
 	struct v4l2_subdev *subdev = i2c_get_clientdata(client);
 	struct ad5820_device *coil = to_ad5820_device(subdev);
@@ -362,7 +362,7 @@ static struct i2c_driver ad5820_i2c_driver = {
 		.pm	= &ad5820_pm,
 	},
 	.probe		= ad5820_probe,
-	.remove		= __exit_p(ad5820_remove),
+	.remove		= ad5820_remove,
 	.id_table	= ad5820_id_table,
 };
 
-- 
2.12.0.rc1.440.g5b76565f74-goog


-- 
Dmitry
