Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:57255 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751369AbdHQNpS (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 17 Aug 2017 09:45:18 -0400
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: linux-media@vger.kernel.org
Cc: devicetree@vger.kernel.org, rajmohan.mani@intel.com
Subject: [PATCH 2/3] dw9714: Add Devicetree support
Date: Thu, 17 Aug 2017 16:42:55 +0300
Message-Id: <1502977376-22836-3-git-send-email-sakari.ailus@linux.intel.com>
In-Reply-To: <1502977376-22836-1-git-send-email-sakari.ailus@linux.intel.com>
References: <1502977376-22836-1-git-send-email-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
---
 drivers/media/i2c/dw9714.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/media/i2c/dw9714.c b/drivers/media/i2c/dw9714.c
index 6a607d7..bcf64ef 100644
--- a/drivers/media/i2c/dw9714.c
+++ b/drivers/media/i2c/dw9714.c
@@ -264,6 +264,12 @@ static const struct i2c_device_id dw9714_id_table[] = {
 
 MODULE_DEVICE_TABLE(i2c, dw9714_id_table);
 
+static const struct of_device_id dw9714_of_table[] = {
+	{ .compatible = "dongwoon,dw9714" },
+	{ { 0 } }
+};
+MODULE_DEVICE_TABLE(of, dw9714_of_table);
+
 static const struct dev_pm_ops dw9714_pm_ops = {
 	SET_SYSTEM_SLEEP_PM_OPS(dw9714_vcm_suspend, dw9714_vcm_resume)
 	SET_RUNTIME_PM_OPS(dw9714_vcm_suspend, dw9714_vcm_resume, NULL)
@@ -274,6 +280,7 @@ static struct i2c_driver dw9714_i2c_driver = {
 		.name = DW9714_NAME,
 		.pm = &dw9714_pm_ops,
 		.acpi_match_table = ACPI_PTR(dw9714_acpi_match),
+		.of_match_table = dw9714_of_table,
 	},
 	.probe = dw9714_probe,
 	.remove = dw9714_remove,
-- 
2.7.4
