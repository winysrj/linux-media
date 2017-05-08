Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f68.google.com ([74.125.82.68]:32961 "EHLO
        mail-wm0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754706AbdEHRIu (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Mon, 8 May 2017 13:08:50 -0400
From: Gideon Sheril <elmocia@gmail.com>
To: mchehab@kernel.org, gregkh@linuxfoundation.org,
        rvarsha016@gmail.com, julia.lawall@lip6.fr, alan@linux.intel.com,
        dan.carpenter@oracle.com, linux-media@vger.kernel.org,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Cc: Gideon Sheril <elmocia@gmail.com>
Subject: [PATCH v3] staging: media: atomisp: Fix indentation to tabs
Date: Mon,  8 May 2017 20:08:25 +0300
Message-Id: <1494263306-7428-1-git-send-email-elmocia@gmail.com>
In-Reply-To: <20170507055240.562dz4hzjllicto7@mwanda>
References: <20170507055240.562dz4hzjllicto7@mwanda>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Fixing following checkpatch warnnings/errors:
ERROR: code indent should use tabs where possible
WARNING: please, no spaces at the start of a line

Signed-off-by: Gideon Sheril <elmocia@gmail.com>
---
 Changed from previuos version:
  - Fixed alignment issues
  - Verified no new warning or errors appear after patch

 .../platform/intel-mid/atomisp_gmin_platform.c     | 150 ++++++++++-----------
 1 file changed, 75 insertions(+), 75 deletions(-)

diff --git a/drivers/staging/media/atomisp/platform/intel-mid/atomisp_gmin_platform.c b/drivers/staging/media/atomisp/platform/intel-mid/atomisp_gmin_platform.c
index 5b4506a..4eb0c91 100644
--- a/drivers/staging/media/atomisp/platform/intel-mid/atomisp_gmin_platform.c
+++ b/drivers/staging/media/atomisp/platform/intel-mid/atomisp_gmin_platform.c
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
 
@@ -361,8 +361,8 @@ static struct gmin_subdev *gmin_subdev_add(struct v4l2_subdev *subdev)
 		return NULL;
 
 	dev_info(dev,
-		"gmin: initializing atomisp module subdev data.PMIC ID %d\n",
-		pmic_id);
+		 "gmin: initializing atomisp module subdev data.PMIC ID %d\n",
+		 pmic_id);
 
 	gmin_subdevs[i].subdev = subdev;
 	gmin_subdevs[i].clock_num = gmin_get_var_int(dev, "CamClk", 0);
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
 
-- 
2.7.4
