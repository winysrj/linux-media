Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:26272 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752605AbdLSVBE (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 19 Dec 2017 16:01:04 -0500
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: Alan Cox <alan@linux.intel.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        linux-media@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        devel@driverdev.osuosl.org, Kristian Beilke <beilke@posteo.de>
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: [PATCH v1 08/10] staging: atomisp: Unexport local function
Date: Tue, 19 Dec 2017 22:59:55 +0200
Message-Id: <20171219205957.10933-8-andriy.shevchenko@linux.intel.com>
In-Reply-To: <20171219205957.10933-1-andriy.shevchenko@linux.intel.com>
References: <20171219205957.10933-1-andriy.shevchenko@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

There is no need to export function which is only used once in
the same module where it's defined.

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
---
 drivers/staging/media/atomisp/include/linux/atomisp_gmin_platform.h  | 1 -
 .../staging/media/atomisp/platform/intel-mid/atomisp_gmin_platform.c | 5 ++---
 2 files changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/media/atomisp/include/linux/atomisp_gmin_platform.h b/drivers/staging/media/atomisp/include/linux/atomisp_gmin_platform.h
index 7e3ca12dd4e9..c52c56a17e17 100644
--- a/drivers/staging/media/atomisp/include/linux/atomisp_gmin_platform.h
+++ b/drivers/staging/media/atomisp/include/linux/atomisp_gmin_platform.h
@@ -23,7 +23,6 @@ int atomisp_register_i2c_module(struct v4l2_subdev *subdev,
 struct v4l2_subdev *atomisp_gmin_find_subdev(struct i2c_adapter *adapter,
 					     struct i2c_board_info *board_info);
 int atomisp_gmin_remove_subdev(struct v4l2_subdev *sd);
-int gmin_get_config_var(struct device *dev, const char *var, char *out, size_t *out_len);
 int gmin_get_var_int(struct device *dev, const char *var, int def);
 int camera_sensor_csi(struct v4l2_subdev *sd, u32 port,
                       u32 lanes, u32 format, u32 bayer_order, int flag);
diff --git a/drivers/staging/media/atomisp/platform/intel-mid/atomisp_gmin_platform.c b/drivers/staging/media/atomisp/platform/intel-mid/atomisp_gmin_platform.c
index 8dcec0e780a1..0f859bb714bf 100644
--- a/drivers/staging/media/atomisp/platform/intel-mid/atomisp_gmin_platform.c
+++ b/drivers/staging/media/atomisp/platform/intel-mid/atomisp_gmin_platform.c
@@ -608,8 +608,8 @@ EXPORT_SYMBOL_GPL(atomisp_gmin_register_vcm_control);
  * argument should be a device with an ACPI companion, as all
  * configuration is based on firmware ID.
  */
-int gmin_get_config_var(struct device *dev, const char *var, char *out,
-			size_t *out_len)
+static int gmin_get_config_var(struct device *dev, const char *var,
+			       char *out, size_t *out_len)
 {
 	char var8[CFG_VAR_NAME_MAX];
 	efi_char16_t var16[CFG_VAR_NAME_MAX];
@@ -691,7 +691,6 @@ int gmin_get_config_var(struct device *dev, const char *var, char *out,
 
 	return ret;
 }
-EXPORT_SYMBOL_GPL(gmin_get_config_var);
 
 int gmin_get_var_int(struct device *dev, const char *var, int def)
 {
-- 
2.15.1
