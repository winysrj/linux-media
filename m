Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:43848 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755367AbdERNvh (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 18 May 2017 09:51:37 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: mchehab@s-opensource.com, alan@linux.intel.com
Cc: Avraham Shukron <avraham.shukron@gmail.com>,
        linux-media@vger.kernel.org, devel@driverdev.osuosl.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH 07/13] staging: media: atomisp: fix coding style warnings
Date: Thu, 18 May 2017 15:50:16 +0200
Message-Id: <20170518135022.6069-8-gregkh@linuxfoundation.org>
In-Reply-To: <20170518135022.6069-1-gregkh@linuxfoundation.org>
References: <20170518135022.6069-1-gregkh@linuxfoundation.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Avraham Shukron <avraham.shukron@gmail.com>

Fix for warnings reported by checkpatch.pl:
 - Multiline comment style
 - Bare "unsigned"
 - Missing blank line after declarations
 - Un-needed braces around single-statement branch

Signed-off-by: Avraham Shukron <avraham.shukron@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 .../platform/intel-mid/atomisp_gmin_platform.c     | 45 ++++++++++++++--------
 .../platform/intel-mid/intel_mid_pcihelpers.c      |  9 +++--
 2 files changed, 35 insertions(+), 19 deletions(-)

diff --git a/drivers/staging/media/atomisp/platform/intel-mid/atomisp_gmin_platform.c b/drivers/staging/media/atomisp/platform/intel-mid/atomisp_gmin_platform.c
index 2a819ac6f9e2..d68e9cf33aa7 100644
--- a/drivers/staging/media/atomisp/platform/intel-mid/atomisp_gmin_platform.c
+++ b/drivers/staging/media/atomisp/platform/intel-mid/atomisp_gmin_platform.c
@@ -119,7 +119,7 @@ static int af_power_ctrl(struct v4l2_subdev *subdev, int flag)
 	/*
 	 * The power here is used for dw9817,
 	 * regulator is from rear sensor
-	*/
+	 */
 	if (gs->v2p8_vcm_reg) {
 		if (flag)
 			return regulator_enable(gs->v2p8_vcm_reg);
@@ -167,7 +167,8 @@ int atomisp_register_i2c_module(struct v4l2_subdev *subdev,
 	 * uses ACPI runtime power management for camera devices, but
 	 * we don't.  Disable it, or else the rails will be needlessly
 	 * tickled during suspend/resume.  This has caused power and
-	 * performance issues on multiple devices. */
+	 * performance issues on multiple devices.
+	 */
 	adev = ACPI_COMPANION(&client->dev);
 	if (adev)
 		adev->power.flags.power_resources = 0;
@@ -182,7 +183,8 @@ int atomisp_register_i2c_module(struct v4l2_subdev *subdev,
 	/* Note subtlety of initialization order: at the point where
 	 * this registration API gets called, the platform data
 	 * callbacks have probably already been invoked, so the
-	 * gmin_subdev struct is already initialized for us. */
+	 * gmin_subdev struct is already initialized for us.
+	 */
 	gs = find_gmin_subdev(subdev);
 
 	pdata.subdevs[i].type = type;
@@ -206,8 +208,10 @@ struct v4l2_subdev *atomisp_gmin_find_subdev(struct i2c_adapter *adapter,
 					     struct i2c_board_info *board_info)
 {
 	int i;
+
 	for (i = 0; i < MAX_SUBDEVS && pdata.subdevs[i].type; i++) {
 		struct intel_v4l2_subdev_table *sd = &pdata.subdevs[i];
+
 		if (sd->v4l2_subdev.i2c_adapter_id == adapter->nr &&
 		    sd->v4l2_subdev.board_info.addr == board_info->addr)
 			return sd->subdev;
@@ -261,7 +265,8 @@ static const struct gmin_cfg_var ffrd8_vars[] = {
 };
 
 /* Cribbed from MCG defaults in the mt9m114 driver, not actually verified
- * vs. T100 hardware */
+ * vs. T100 hardware
+ */
 static const struct gmin_cfg_var t100_vars[] = {
 	{ "INT33F0:00_CsiPort",  "0" },
 	{ "INT33F0:00_CsiLanes", "1" },
@@ -345,10 +350,8 @@ static struct gmin_subdev *gmin_subdev_add(struct v4l2_subdev *subdev)
 	struct device *dev;
 	struct i2c_client *client = v4l2_get_subdevdata(subdev);
 
-	if (!pmic_id) {
-
-			pmic_id = PMIC_REGULATOR;
-	}
+	if (!pmic_id)
+		pmic_id = PMIC_REGULATOR;
 
 	if (!client)
 		return NULL;
@@ -401,7 +404,8 @@ static struct gmin_subdev *gmin_subdev_add(struct v4l2_subdev *subdev)
 		 * API is broken with the current drivers, returning
 		 * "1" for a regulator that will then emit a
 		 * "unbalanced disable" WARNing if we try to disable
-		 * it. */
+		 * it.
+		 */
 	}
 
 	return &gmin_subdevs[i];
@@ -410,6 +414,7 @@ static struct gmin_subdev *gmin_subdev_add(struct v4l2_subdev *subdev)
 static struct gmin_subdev *find_gmin_subdev(struct v4l2_subdev *subdev)
 {
 	int i;
+
 	for (i = 0; i < MAX_SUBDEVS; i++)
 		if (gmin_subdevs[i].subdev == subdev)
 			return &gmin_subdevs[i];
@@ -419,6 +424,7 @@ static struct gmin_subdev *find_gmin_subdev(struct v4l2_subdev *subdev)
 static int gmin_gpio0_ctrl(struct v4l2_subdev *subdev, int on)
 {
 	struct gmin_subdev *gs = find_gmin_subdev(subdev);
+
 	if (gs && gs->gpio0) {
 		gpiod_set_value(gs->gpio0, on);
 		return 0;
@@ -429,6 +435,7 @@ static int gmin_gpio0_ctrl(struct v4l2_subdev *subdev, int on)
 static int gmin_gpio1_ctrl(struct v4l2_subdev *subdev, int on)
 {
 	struct gmin_subdev *gs = find_gmin_subdev(subdev);
+
 	if (gs && gs->gpio1) {
 		gpiod_set_value(gs->gpio1, on);
 		return 0;
@@ -532,6 +539,7 @@ static int gmin_flisclk_ctrl(struct v4l2_subdev *subdev, int on)
 {
 	int ret = 0;
 	struct gmin_subdev *gs = find_gmin_subdev(subdev);
+
 	if (on)
 		ret = vlv2_plat_set_clock_freq(gs->clock_num, gs->clock_src);
 	if (ret)
@@ -596,6 +604,7 @@ struct camera_sensor_platform_data *gmin_camera_platform_data(
 		enum atomisp_bayer_order csi_bayer)
 {
 	struct gmin_subdev *gs = find_gmin_subdev(subdev);
+
 	gs->csi_fmt = csi_format;
 	gs->csi_bayer = csi_bayer;
 
@@ -618,8 +627,10 @@ EXPORT_SYMBOL_GPL(atomisp_gmin_register_vcm_control);
 
 /* Retrieves a device-specific configuration variable.  The dev
  * argument should be a device with an ACPI companion, as all
- * configuration is based on firmware ID. */
-int gmin_get_config_var(struct device *dev, const char *var, char *out, size_t *out_len)
+ * configuration is based on firmware ID.
+ */
+int gmin_get_config_var(struct device *dev, const char *var, char *out,
+			size_t *out_len)
 {
 	char var8[CFG_VAR_NAME_MAX];
 	efi_char16_t var16[CFG_VAR_NAME_MAX];
@@ -641,7 +652,8 @@ int gmin_get_config_var(struct device *dev, const char *var, char *out, size_t *
 
 	/* First check a hard-coded list of board-specific variables.
 	 * Some device firmwares lack the ability to set EFI variables at
-	 * runtime. */
+	 * runtime.
+	 */
 	for (i = 0; i < ARRAY_SIZE(hard_vars); i++) {
 		if (dmi_match(DMI_BOARD_NAME, hard_vars[i].dmi_board_name)) {
 			for (j = 0; hard_vars[i].vars[j].name; j++) {
@@ -666,7 +678,8 @@ int gmin_get_config_var(struct device *dev, const char *var, char *out, size_t *
 	}
 
 	/* Our variable names are ASCII by construction, but EFI names
-	 * are wide chars.  Convert and zero-pad. */
+	 * are wide chars.  Convert and zero-pad.
+	 */
 	memset(var16, 0, sizeof(var16));
 	for (i = 0; i < sizeof(var8) && var8[i]; i++)
 		var16[i] = var8[i];
@@ -679,7 +692,8 @@ int gmin_get_config_var(struct device *dev, const char *var, char *out, size_t *
 	 * implementation simply uses VariableName and VendorGuid from
 	 * the struct and ignores the rest, but it seems like there
 	 * ought to be an "official" efivar_entry registered
-	 * somewhere? */
+	 * somewhere?
+	 */
 	ev = kzalloc(sizeof(*ev), GFP_KERNEL);
 	if (!ev)
 		return -ENOMEM;
@@ -750,7 +764,8 @@ EXPORT_SYMBOL_GPL(camera_sensor_csi);
 /* PCI quirk: The BYT ISP advertises PCI runtime PM but it doesn't
  * work.  Disable so the kernel framework doesn't hang the device
  * trying.  The driver itself does direct calls to the PUNIT to manage
- * ISP power. */
+ * ISP power.
+ */
 static void isp_pm_cap_fixup(struct pci_dev *dev)
 {
 	dev_info(&dev->dev, "Disabling PCI power management on camera ISP\n");
diff --git a/drivers/staging/media/atomisp/platform/intel-mid/intel_mid_pcihelpers.c b/drivers/staging/media/atomisp/platform/intel-mid/intel_mid_pcihelpers.c
index c9eea71ece2c..cd452cc20fea 100644
--- a/drivers/staging/media/atomisp/platform/intel-mid/intel_mid_pcihelpers.c
+++ b/drivers/staging/media/atomisp/platform/intel-mid/intel_mid_pcihelpers.c
@@ -5,7 +5,8 @@
 
 /* G-Min addition: "platform_is()" lives in intel_mid_pm.h in the MCG
  * tree, but it's just platform ID info and we don't want to pull in
- * the whole SFI-based PM architecture. */
+ * the whole SFI-based PM architecture.
+ */
 #define INTEL_ATOM_MRST 0x26
 #define INTEL_ATOM_MFLD 0x27
 #define INTEL_ATOM_CLV 0x35
@@ -135,8 +136,8 @@ u32 intel_mid_msgbus_read32(u8 port, u32 addr)
 
 	return data;
 }
-
 EXPORT_SYMBOL(intel_mid_msgbus_read32);
+
 void intel_mid_msgbus_write32(u8 port, u32 addr, u32 data)
 {
 	unsigned long irq_flags;
@@ -170,8 +171,8 @@ EXPORT_SYMBOL(intel_mid_soc_stepping);
 
 static bool is_south_complex_device(struct pci_dev *dev)
 {
-	unsigned base_class = dev->class >> 16;
-	unsigned sub_class  = (dev->class & SUB_CLASS_MASK) >> 8;
+	unsigned int base_class = dev->class >> 16;
+	unsigned int sub_class  = (dev->class & SUB_CLASS_MASK) >> 8;
 
 	/* other than camera, pci bridges and display,
 	 * everything else are south complex devices.
-- 
2.13.0
