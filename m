Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lf1-f65.google.com ([209.85.167.65]:36425 "EHLO
        mail-lf1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726128AbeIUCbR (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 20 Sep 2018 22:31:17 -0400
From: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
To: Pavel Machek <pavel@ucw.cz>, Sakari Ailus <sakari.ailus@iki.fi>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
Subject: [[PATCH v3] 4/6] [media] ad5820: Add support for acpi autoload
Date: Thu, 20 Sep 2018 22:45:38 +0200
Message-Id: <20180920204540.28832-4-ricardo.ribalda@gmail.com>
In-Reply-To: <20180920204540.28832-1-ricardo.ribalda@gmail.com>
References: <20180920204540.28832-1-ricardo.ribalda@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Allow module autoloading of ad5820 ACPI devices.

Signed-off-by: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
---
 drivers/media/i2c/ad5820.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/drivers/media/i2c/ad5820.c b/drivers/media/i2c/ad5820.c
index e461d36201a4..5d1185e7f78d 100644
--- a/drivers/media/i2c/ad5820.c
+++ b/drivers/media/i2c/ad5820.c
@@ -22,6 +22,7 @@
  * General Public License for more details.
  */
 
+#include <linux/acpi.h>
 #include <linux/errno.h>
 #include <linux/i2c.h>
 #include <linux/kernel.h>
@@ -380,6 +381,15 @@ static const struct of_device_id ad5820_of_table[] = {
 MODULE_DEVICE_TABLE(of, ad5820_of_table);
 #endif
 
+#ifdef CONFIG_ACPI
+static const struct acpi_device_id ad5820_acpi_ids[] = {
+	{ "AD5820" },
+	{ }
+};
+
+MODULE_DEVICE_TABLE(acpi, ad5820_acpi_ids);
+#endif
+
 static SIMPLE_DEV_PM_OPS(ad5820_pm, ad5820_suspend, ad5820_resume);
 
 static struct i2c_driver ad5820_i2c_driver = {
@@ -387,6 +397,7 @@ static struct i2c_driver ad5820_i2c_driver = {
 		.name	= AD5820_NAME,
 		.pm	= &ad5820_pm,
 		.of_match_table = of_match_ptr(ad5820_of_table),
+		.acpi_match_table = ACPI_PTR(ad5820_acpi_ids),
 	},
 	.probe		= ad5820_probe,
 	.remove		= ad5820_remove,
-- 
2.18.0
