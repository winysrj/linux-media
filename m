Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lf1-f66.google.com ([209.85.167.66]:45539 "EHLO
        mail-lf1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726128AbeIUCdU (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 20 Sep 2018 22:33:20 -0400
From: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
To: Pavel Machek <pavel@ucw.cz>, Sakari Ailus <sakari.ailus@iki.fi>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
Subject: [PATCH v4 4/7] [media] ad5820: Add support for of-autoload
Date: Thu, 20 Sep 2018 22:47:48 +0200
Message-Id: <20180920204751.29117-4-ricardo.ribalda@gmail.com>
In-Reply-To: <20180920204751.29117-1-ricardo.ribalda@gmail.com>
References: <20180920204751.29117-1-ricardo.ribalda@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Since kernel 4.16, i2c devices with DT compatible tag are modprobed
using their DT modalias.
Without this patch, if this driver is build as module it would never
be autoprobed.

Signed-off-by: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
Acked-by: Pavel Machek <pavel@ucw.cz>
---
 drivers/media/i2c/ad5820.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/drivers/media/i2c/ad5820.c b/drivers/media/i2c/ad5820.c
index 625867472929..e461d36201a4 100644
--- a/drivers/media/i2c/ad5820.c
+++ b/drivers/media/i2c/ad5820.c
@@ -372,12 +372,21 @@ static const struct i2c_device_id ad5820_id_table[] = {
 };
 MODULE_DEVICE_TABLE(i2c, ad5820_id_table);
 
+#ifdef CONFIG_OF
+static const struct of_device_id ad5820_of_table[] = {
+	{ .compatible = "adi,ad5820" },
+	{ }
+};
+MODULE_DEVICE_TABLE(of, ad5820_of_table);
+#endif
+
 static SIMPLE_DEV_PM_OPS(ad5820_pm, ad5820_suspend, ad5820_resume);
 
 static struct i2c_driver ad5820_i2c_driver = {
 	.driver		= {
 		.name	= AD5820_NAME,
 		.pm	= &ad5820_pm,
+		.of_match_table = of_match_ptr(ad5820_of_table),
 	},
 	.probe		= ad5820_probe,
 	.remove		= ad5820_remove,
-- 
2.18.0
