Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wr0-f193.google.com ([209.85.128.193]:34020 "EHLO
        mail-wr0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752144AbdEGVpL (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Sun, 7 May 2017 17:45:11 -0400
From: Avraham Shukron <avraham.shukron@gmail.com>
To: mchehab@kernel.org, gregkh@linuxfoundation.org,
        rvarsha016@gmail.com, julia.lawall@lip6.fr,
        dan.carpenter@oracle.com, colin.king@canonical.com,
        alan@linux.intel.com
Cc: linux-media@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] drivers: staging: media: atomisp: fixed coding style errors
Date: Sun,  7 May 2017 20:44:45 +0300
Message-Id: <a2582ddea24b007895ab80530c83a4239f990803.1494178741.git.avraham.shukron@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Fix for error (not warnings) reported by checkpatch.pl
Specifically:
 - missing whitespace around "=" and after ","
 - indentation with spaces instead of tabs
 - lines starting with a whitespace

This patch does not affect the compiled code in any way.

Signed-off-by: Avraham Shukron <avraham.shukron@gmail.com>
---
 .../platform/intel-mid/atomisp_gmin_platform.c     | 156 ++++++++++-----------
 .../platform/intel-mid/intel_mid_pcihelpers.c      |   2 +-
 2 files changed, 79 insertions(+), 79 deletions(-)

diff --git a/drivers/staging/media/atomisp/platform/intel-mid/atomisp_gmin_platform.c b/drivers/staging/media/atomisp/platform/intel-mid/atomisp_gmin_platform.c
index 5b4506a..7ebefb3 100644
--- a/drivers/staging/media/atomisp/platform/intel-mid/atomisp_gmin_platform.c
+++ b/drivers/staging/media/atomisp/platform/intel-mid/atomisp_gmin_platform.c
@@ -51,7 +51,7 @@ struct gmin_subdev {
 
 static struct gmin_subdev gmin_subdevs[MAX_SUBDEVS];
 
-static enum { PMIC_UNSET = 0, PMIC_REGULATOR, PMIC_AXP, PMIC_TI ,
+static enum { PMIC_UNSET = 0, PMIC_REGULATOR, PMIC_AXP, PMIC_TI,
 	PMIC_CRYSTALCOVE } pmic_id;
 
 /* The atomisp uses type==0 for the end-of-list marker, so leave space. */
@@ -152,13 +152,13 @@ const struct camera_af_platform_data *camera_get_af_platform_data(void)
 EXPORT_SYMBOL_GPL(camera_get_af_platform_data);
 
 int atomisp_register_i2c_module(struct v4l2_subdev *subdev,
-                                struct camera_sensor_platform_data *plat_data,
-                                enum intel_v4l2_subdev_type type)
+				struct camera_sensor_platform_data *plat_data,
+				enum intel_v4l2_subdev_type type)
 {
 	int i;
 	struct i2c_board_info *bi;
 	struct gmin_subdev *gs;
-        struct i2c_client *client = v4l2_get_subdevdata(subdev);
+	struct i2c_client *client = v4l2_get_subdevdata(subdev);
 	struct acpi_device *adev;
 
 	dev_info(&client->dev, "register atomisp i2c module type %d\n", type);
@@ -172,7 +172,7 @@ int atomisp_register_i2c_module(struct v4l2_subdev *subdev,
 	if (adev)
 		adev->power.flags.power_resources = 0;
 
-	for (i=0; i < MAX_SUBDEVS; i++)
+	for (i = 0; i < MAX_SUBDEVS; i++)
 		if (!pdata.subdevs[i].type)
 			break;
 
@@ -206,7 +206,7 @@ struct v4l2_subdev *atomisp_gmin_find_subdev(struct i2c_adapter *adapter,
 					     struct i2c_board_info *board_info)
 {
 	int i;
-	for (i=0; i < MAX_SUBDEVS && pdata.subdevs[i].type; i++) {
+	for (i = 0; i < MAX_SUBDEVS && pdata.subdevs[i].type; i++) {
 		struct intel_v4l2_subdev_table *sd = &pdata.subdevs[i];
 		if (sd->v4l2_subdev.i2c_adapter_id == adapter->nr &&
 		    sd->v4l2_subdev.board_info.addr == board_info->addr)
@@ -270,45 +270,45 @@ static const struct gmin_cfg_var t100_vars[] = {
 };
 
 static const struct gmin_cfg_var mrd7_vars[] = {
-        {"INT33F8:00_CamType", "1"},
-        {"INT33F8:00_CsiPort", "1"},
-        {"INT33F8:00_CsiLanes","2"},
-        {"INT33F8:00_CsiFmt","13"},
-        {"INT33F8:00_CsiBayer", "0"},
-        {"INT33F8:00_CamClk", "0"},
-        {"INT33F9:00_CamType", "1"},
-        {"INT33F9:00_CsiPort", "0"},
-        {"INT33F9:00_CsiLanes","1"},
-        {"INT33F9:00_CsiFmt","13"},
-        {"INT33F9:00_CsiBayer", "0"},
-        {"INT33F9:00_CamClk", "1"},
-        {},
+	{"INT33F8:00_CamType", "1"},
+	{"INT33F8:00_CsiPort", "1"},
+	{"INT33F8:00_CsiLanes", "2"},
+	{"INT33F8:00_CsiFmt", "13"},
+	{"INT33F8:00_CsiBayer", "0"},
+	{"INT33F8:00_CamClk", "0"},
+	{"INT33F9:00_CamType", "1"},
+	{"INT33F9:00_CsiPort", "0"},
+	{"INT33F9:00_CsiLanes", "1"},
+	{"INT33F9:00_CsiFmt", "13"},
+	{"INT33F9:00_CsiBayer", "0"},
+	{"INT33F9:00_CamClk", "1"},
+	{},
 };
 
 static const struct gmin_cfg_var ecs7_vars[] = {
-        {"INT33BE:00_CsiPort", "1"},
-        {"INT33BE:00_CsiLanes","2"},
-        {"INT33BE:00_CsiFmt","13"},
-        {"INT33BE:00_CsiBayer", "2"},
-        {"INT33BE:00_CamClk", "0"},
-        {"INT33F0:00_CsiPort", "0"},
-        {"INT33F0:00_CsiLanes","1"},
-        {"INT33F0:00_CsiFmt","13"},
-        {"INT33F0:00_CsiBayer", "0"},
-        {"INT33F0:00_CamClk", "1"},
-        {"gmin_V2P8GPIO","402"},
-        {},
+	{"INT33BE:00_CsiPort", "1"},
+	{"INT33BE:00_CsiLanes", "2"},
+	{"INT33BE:00_CsiFmt", "13"},
+	{"INT33BE:00_CsiBayer", "2"},
+	{"INT33BE:00_CamClk", "0"},
+	{"INT33F0:00_CsiPort", "0"},
+	{"INT33F0:00_CsiLanes", "1"},
+	{"INT33F0:00_CsiFmt", "13"},
+	{"INT33F0:00_CsiBayer", "0"},
+	{"INT33F0:00_CamClk", "1"},
+	{"gmin_V2P8GPIO", "402"},
+	{},
 };
 
 
 static const struct gmin_cfg_var i8880_vars[] = {
-        {"XXOV2680:00_CsiPort", "1"},
-        {"XXOV2680:00_CsiLanes","1"},
-        {"XXOV2680:00_CamClk","0"},
-        {"XXGC0310:00_CsiPort", "0"},
-        {"XXGC0310:00_CsiLanes", "1"},
-        {"XXGC0310:00_CamClk", "1"},
-        {},
+	{"XXOV2680:00_CsiPort", "1"},
+	{"XXOV2680:00_CsiLanes", "1"},
+	{"XXOV2680:00_CamClk", "0"},
+	{"XXGC0310:00_CsiPort", "0"},
+	{"XXGC0310:00_CsiLanes", "1"},
+	{"XXGC0310:00_CamClk", "1"},
+	{},
 };
 
 static const struct {
@@ -317,9 +317,9 @@ static const struct {
 } hard_vars[] = {
 	{ "BYT-T FFD8", ffrd8_vars },
 	{ "T100TA", t100_vars },
-        { "MRD7", mrd7_vars },
-        { "ST70408", ecs7_vars },
-        { "VTA0803", i8880_vars },
+	{ "MRD7", mrd7_vars },
+	{ "ST70408", ecs7_vars },
+	{ "VTA0803", i8880_vars },
 };
 
 
@@ -343,7 +343,7 @@ static struct gmin_subdev *gmin_subdev_add(struct v4l2_subdev *subdev)
 {
 	int i, ret;
 	struct device *dev;
-        struct i2c_client *client = v4l2_get_subdevdata(subdev);
+	struct i2c_client *client = v4l2_get_subdevdata(subdev);
 
 	if (!pmic_id) {
 
@@ -355,7 +355,7 @@ static struct gmin_subdev *gmin_subdev_add(struct v4l2_subdev *subdev)
 
 	dev = &client->dev;
 
-	for (i=0; i < MAX_SUBDEVS && gmin_subdevs[i].subdev; i++)
+	for (i = 0; i < MAX_SUBDEVS && gmin_subdevs[i].subdev; i++)
 		;
 	if (i >= MAX_SUBDEVS)
 		return NULL;
@@ -410,7 +410,7 @@ static struct gmin_subdev *gmin_subdev_add(struct v4l2_subdev *subdev)
 static struct gmin_subdev *find_gmin_subdev(struct v4l2_subdev *subdev)
 {
 	int i;
-	for (i=0; i < MAX_SUBDEVS; i++)
+	for (i = 0; i < MAX_SUBDEVS; i++)
 		if (gmin_subdevs[i].subdev == subdev)
 			return &gmin_subdevs[i];
 	return gmin_subdev_add(subdev);
@@ -481,7 +481,7 @@ int gmin_v1p8_ctrl(struct v4l2_subdev *subdev, int on)
 		gpio_set_value(v1p8_gpio, on);
 
 	if (gs->v1p8_reg) {
-           regulator_set_voltage(gs->v1p8_reg, 1800000, 1800000);
+		regulator_set_voltage(gs->v1p8_reg, 1800000, 1800000);
 		if (on)
 			return regulator_enable(gs->v1p8_reg);
 		else
@@ -517,7 +517,7 @@ int gmin_v2p8_ctrl(struct v4l2_subdev *subdev, int on)
 		gpio_set_value(v2p8_gpio, on);
 
 	if (gs->v2p8_reg) {
-           regulator_set_voltage(gs->v2p8_reg, 2900000, 2900000);
+		regulator_set_voltage(gs->v2p8_reg, 2900000, 2900000);
 		if (on)
 			return regulator_enable(gs->v2p8_reg);
 		else
@@ -627,13 +627,13 @@ int gmin_get_config_var(struct device *dev, const char *var, char *out, size_t *
 	int i, j, ret;
 	unsigned long efilen;
 
-        if (dev && ACPI_COMPANION(dev))
-                dev = &ACPI_COMPANION(dev)->dev;
+	if (dev && ACPI_COMPANION(dev))
+		dev = &ACPI_COMPANION(dev)->dev;
 
-        if (dev)
-                ret = snprintf(var8, sizeof(var8), "%s_%s", dev_name(dev), var);
-        else
-                ret = snprintf(var8, sizeof(var8), "gmin_%s", var);
+	if (dev)
+		ret = snprintf(var8, sizeof(var8), "%s_%s", dev_name(dev), var);
+	else
+		ret = snprintf(var8, sizeof(var8), "gmin_%s", var);
 
 	if (ret < 0 || ret >= sizeof(var8) - 1)
 		return -EINVAL;
@@ -692,7 +692,7 @@ int gmin_get_config_var(struct device *dev, const char *var, char *out, size_t *
 	*out_len = efilen;
 
 	if (ret)
- 		dev_warn(dev, "Failed to find gmin variable %s\n", var8);
+		dev_warn(dev, "Failed to find gmin variable %s\n", var8);
 
 	return ret;
 }
@@ -718,31 +718,31 @@ EXPORT_SYMBOL_GPL(gmin_get_var_int);
 int camera_sensor_csi(struct v4l2_subdev *sd, u32 port,
 		      u32 lanes, u32 format, u32 bayer_order, int flag)
 {
-        struct i2c_client *client = v4l2_get_subdevdata(sd);
-        struct camera_mipi_info *csi = NULL;
-
-        if (flag) {
-                csi = kzalloc(sizeof(*csi), GFP_KERNEL);
-                if (!csi) {
-                        dev_err(&client->dev, "out of memory\n");
-                        return -ENOMEM;
-                }
-                csi->port = port;
-                csi->num_lanes = lanes;
-                csi->input_format = format;
-                csi->raw_bayer_order = bayer_order;
-                v4l2_set_subdev_hostdata(sd, (void *)csi);
-                csi->metadata_format = ATOMISP_INPUT_FORMAT_EMBEDDED;
-                csi->metadata_effective_width = NULL;
-                dev_info(&client->dev,
-                         "camera pdata: port: %d lanes: %d order: %8.8x\n",
-                         port, lanes, bayer_order);
-        } else {
-                csi = v4l2_get_subdev_hostdata(sd);
-                kfree(csi);
-        }
-
-        return 0;
+	struct i2c_client *client = v4l2_get_subdevdata(sd);
+	struct camera_mipi_info *csi = NULL;
+
+	if (flag) {
+		csi = kzalloc(sizeof(*csi), GFP_KERNEL);
+		if (!csi) {
+			dev_err(&client->dev, "out of memory\n");
+			return -ENOMEM;
+		}
+		csi->port = port;
+		csi->num_lanes = lanes;
+		csi->input_format = format;
+		csi->raw_bayer_order = bayer_order;
+		v4l2_set_subdev_hostdata(sd, (void *)csi);
+		csi->metadata_format = ATOMISP_INPUT_FORMAT_EMBEDDED;
+		csi->metadata_effective_width = NULL;
+		dev_info(&client->dev,
+			 "camera pdata: port: %d lanes: %d order: %8.8x\n",
+			 port, lanes, bayer_order);
+	} else {
+		csi = v4l2_get_subdev_hostdata(sd);
+		kfree(csi);
+	}
+
+	return 0;
 }
 EXPORT_SYMBOL_GPL(camera_sensor_csi);
 
diff --git a/drivers/staging/media/atomisp/platform/intel-mid/intel_mid_pcihelpers.c b/drivers/staging/media/atomisp/platform/intel-mid/intel_mid_pcihelpers.c
index a6c0f5f..b84fe9c 100644
--- a/drivers/staging/media/atomisp/platform/intel-mid/intel_mid_pcihelpers.c
+++ b/drivers/staging/media/atomisp/platform/intel-mid/intel_mid_pcihelpers.c
@@ -22,7 +22,7 @@
 #endif
 static inline int platform_is(u8 model)
 {
-        return (boot_cpu_data.x86_model == model);
+	return (boot_cpu_data.x86_model == model);
 }
 
 #include "../../include/asm/intel_mid_pcihelpers.h"
-- 
2.7.4
