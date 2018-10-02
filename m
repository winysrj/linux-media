Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lj1-f193.google.com ([209.85.208.193]:45977 "EHLO
        mail-lj1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726890AbeJBOO0 (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Tue, 2 Oct 2018 10:14:26 -0400
From: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
To: Pavel Machek <pavel@ucw.cz>, Sakari Ailus <sakari.ailus@iki.fi>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
Subject: [PATCH v5 6/6] [media] ad5820: Add support for ad5821 and ad5823
Date: Tue,  2 Oct 2018 09:32:22 +0200
Message-Id: <20181002073222.11368-6-ricardo.ribalda@gmail.com>
In-Reply-To: <20181002073222.11368-1-ricardo.ribalda@gmail.com>
References: <20181002073222.11368-1-ricardo.ribalda@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

According to the datasheet, both AD5821 and AD5820 share a compatible
register-set:
http://www.analog.com/media/en/technical-documentation/data-sheets/AD5821.pdf

Some camera modules also refer that AD5823 is a replacement of AD5820:
https://download.kamami.com/p564094-OV8865_DS.pdf

Suggested-by: Pavel Machek <pavel@ucw.cz>
Signed-off-by: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
---
 drivers/media/i2c/ad5820.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/drivers/media/i2c/ad5820.c b/drivers/media/i2c/ad5820.c
index 4ae4e6a776fd..2c0dd9960268 100644
--- a/drivers/media/i2c/ad5820.c
+++ b/drivers/media/i2c/ad5820.c
@@ -33,8 +33,6 @@
 #include <media/v4l2-device.h>
 #include <media/v4l2-subdev.h>
 
-#define AD5820_NAME		"ad5820"
-
 /* Register definitions */
 #define AD5820_POWER_DOWN		(1 << 15)
 #define AD5820_DAC_SHIFT		4
@@ -367,13 +365,17 @@ static int ad5820_remove(struct i2c_client *client)
 }
 
 static const struct i2c_device_id ad5820_id_table[] = {
-	{ AD5820_NAME, 0 },
+	{ "ad5820", 0 },
+	{ "ad5821", 0 },
+	{ "ad5823", 0 },
 	{ }
 };
 MODULE_DEVICE_TABLE(i2c, ad5820_id_table);
 
 static const struct of_device_id ad5820_of_table[] = {
 	{ .compatible = "adi,ad5820" },
+	{ .compatible = "adi,ad5821" },
+	{ .compatible = "adi,ad5823" },
 	{ }
 };
 MODULE_DEVICE_TABLE(of, ad5820_of_table);
@@ -382,7 +384,7 @@ static SIMPLE_DEV_PM_OPS(ad5820_pm, ad5820_suspend, ad5820_resume);
 
 static struct i2c_driver ad5820_i2c_driver = {
 	.driver		= {
-		.name	= AD5820_NAME,
+		.name	= "ad5820",
 		.pm	= &ad5820_pm,
 		.of_match_table = ad5820_of_table,
 	},
-- 
2.19.0
