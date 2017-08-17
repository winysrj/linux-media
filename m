Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:57255 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750988AbdHQNpR (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 17 Aug 2017 09:45:17 -0400
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: linux-media@vger.kernel.org
Cc: devicetree@vger.kernel.org, rajmohan.mani@intel.com
Subject: [PATCH 3/3] dw9714: Remove ACPI match tables, convert to use probe_new
Date: Thu, 17 Aug 2017 16:42:56 +0300
Message-Id: <1502977376-22836-4-git-send-email-sakari.ailus@linux.intel.com>
In-Reply-To: <1502977376-22836-1-git-send-email-sakari.ailus@linux.intel.com>
References: <1502977376-22836-1-git-send-email-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The ACPI match table is empty. Remove it.

Also convert the drive to use probe_new callback in struct i2c_driver.

Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
---
 drivers/media/i2c/dw9714.c | 19 ++++---------------
 1 file changed, 4 insertions(+), 15 deletions(-)

diff --git a/drivers/media/i2c/dw9714.c b/drivers/media/i2c/dw9714.c
index bcf64ef..95af4fc 100644
--- a/drivers/media/i2c/dw9714.c
+++ b/drivers/media/i2c/dw9714.c
@@ -11,7 +11,6 @@
  * GNU General Public License for more details.
  */
 
-#include <linux/acpi.h>
 #include <linux/delay.h>
 #include <linux/i2c.h>
 #include <linux/module.h>
@@ -147,8 +146,7 @@ static int dw9714_init_controls(struct dw9714_device *dev_vcm)
 	return hdl->error;
 }
 
-static int dw9714_probe(struct i2c_client *client,
-			const struct i2c_device_id *devid)
+static int dw9714_probe(struct i2c_client *client)
 {
 	struct dw9714_device *dw9714_dev;
 	int rval;
@@ -250,18 +248,10 @@ static int  __maybe_unused dw9714_vcm_resume(struct device *dev)
 	return 0;
 }
 
-#ifdef CONFIG_ACPI
-static const struct acpi_device_id dw9714_acpi_match[] = {
-	{},
-};
-MODULE_DEVICE_TABLE(acpi, dw9714_acpi_match);
-#endif
-
 static const struct i2c_device_id dw9714_id_table[] = {
-	{DW9714_NAME, 0},
-	{}
+	{ DW9714_NAME, 0 },
+	{ { 0 } }
 };
-
 MODULE_DEVICE_TABLE(i2c, dw9714_id_table);
 
 static const struct of_device_id dw9714_of_table[] = {
@@ -279,10 +269,9 @@ static struct i2c_driver dw9714_i2c_driver = {
 	.driver = {
 		.name = DW9714_NAME,
 		.pm = &dw9714_pm_ops,
-		.acpi_match_table = ACPI_PTR(dw9714_acpi_match),
 		.of_match_table = dw9714_of_table,
 	},
-	.probe = dw9714_probe,
+	.probe_new = dw9714_probe,
 	.remove = dw9714_remove,
 	.id_table = dw9714_id_table,
 };
-- 
2.7.4
