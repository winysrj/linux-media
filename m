Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f68.google.com ([74.125.82.68]:34433 "EHLO
        mail-wm0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754848AbdEGV6i (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Sun, 7 May 2017 17:58:38 -0400
From: Avraham Shukron <avraham.shukron@gmail.com>
To: mchehab@kernel.org, gregkh@linuxfoundation.org,
        rvarsha016@gmail.com, julia.lawall@lip6.fr,
        dan.carpenter@oracle.com, colin.king@canonical.com,
        alan@linux.intel.com
Cc: linux-media@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] drivers: staging: media: atomisp: fix coding style warnings
Date: Sun,  7 May 2017 20:44:46 +0300
Message-Id: <d519dd1d872a6c26965164fece94d961797fa487.1494178741.git.avraham.shukron@gmail.com>
In-Reply-To: <a2582ddea24b007895ab80530c83a4239f990803.1494178741.git.avraham.shukron@gmail.com>
References: <a2582ddea24b007895ab80530c83a4239f990803.1494178741.git.avraham.shukron@gmail.com>
In-Reply-To: <a2582ddea24b007895ab80530c83a4239f990803.1494178741.git.avraham.shukron@gmail.com>
References: <a2582ddea24b007895ab80530c83a4239f990803.1494178741.git.avraham.shukron@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Fix for warnings reported by checkpatch.pl:
 - Multiline comment style
 - Bare "unsigned"
 - Missing blank line after declarations
 - Un-needed braces around single-statement branch

Signed-off-by: Avraham Shukron <avraham.shukron@gmail.com>
---
 .../platform/intel-mid/atomisp_gmin_platform.c     | 45 ++++++++++++++--------
 .../platform/intel-mid/intel_mid_pcihelpers.c      |  9 +++--
 2 files changed, 35 insertions(+), 19 deletions(-)

diff --git a/drivers/staging/media/atomisp/platform/intel-mid/atomisp_gmin_platform.c b/drivers/staging/media/atomisp/platform/intel-mid/atomisp_gmin_platform.c
index 7ebefb3..fac03a0 100644
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
@@ -531,6 +538,7 @@ int gmin_flisclk_ctrl(struct v4l2_subdev *subdev, int on)
 {
 	int ret = 0;
 	struct gmin_subdev *gs = find_gmin_subdev(subdev);
+
 	if (on)
 		ret = vlv2_plat_set_clock_freq(gs->clock_num, gs->clock_src);
 	if (ret)
@@ -595,6 +603,7 @@ struct camera_sensor_platform_data *gmin_camera_platform_data(
 		enum atomisp_bayer_order csi_bayer)
 {
 	struct gmin_subdev *gs = find_gmin_subdev(subdev);
+
 	gs->csi_fmt = csi_format;
 	gs->csi_bayer = csi_bayer;
 
@@ -617,8 +626,10 @@ EXPORT_SYMBOL_GPL(atomisp_gmin_register_vcm_control);
 
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
@@ -640,7 +651,8 @@ int gmin_get_config_var(struct device *dev, const char *var, char *out, size_t *
 
 	/* First check a hard-coded list of board-specific variables.
 	 * Some device firmwares lack the ability to set EFI variables at
-	 * runtime. */
+	 * runtime.
+	 */
 	for (i = 0; i < ARRAY_SIZE(hard_vars); i++) {
 		if (dmi_match(DMI_BOARD_NAME, hard_vars[i].dmi_board_name)) {
 			for (j = 0; hard_vars[i].vars[j].name; j++) {
@@ -665,7 +677,8 @@ int gmin_get_config_var(struct device *dev, const char *var, char *out, size_t *
 	}
 
 	/* Our variable names are ASCII by construction, but EFI names
-	 * are wide chars.  Convert and zero-pad. */
+	 * are wide chars.  Convert and zero-pad.
+	 */
 	memset(var16, 0, sizeof(var16));
 	for (i = 0; i < sizeof(var8) && var8[i]; i++)
 		var16[i] = var8[i];
@@ -678,7 +691,8 @@ int gmin_get_config_var(struct device *dev, const char *var, char *out, size_t *
 	 * implementation simply uses VariableName and VendorGuid from
 	 * the struct and ignores the rest, but it seems like there
 	 * ought to be an "official" efivar_entry registered
-	 * somewhere? */
+	 * somewhere?
+	 */
 	ev = kzalloc(sizeof(*ev), GFP_KERNEL);
 	if (!ev)
 		return -ENOMEM;
@@ -749,7 +763,8 @@ EXPORT_SYMBOL_GPL(camera_sensor_csi);
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
index b84fe9c..28afc76 100644
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
@@ -136,8 +137,8 @@ u32 intel_mid_msgbus_read32(u8 port, u32 addr)
 
 	return data;
 }
-
 EXPORT_SYMBOL(intel_mid_msgbus_read32);
+
 void intel_mid_msgbus_write32(u8 port, u32 addr, u32 data)
 {
 	unsigned long irq_flags;
@@ -171,8 +172,8 @@ EXPORT_SYMBOL(intel_mid_soc_stepping);
 
 static bool is_south_complex_device(struct pci_dev *dev)
 {
-	unsigned base_class = dev->class >> 16;
-	unsigned sub_class  = (dev->class & SUB_CLASS_MASK) >> 8;
+	unsigned int base_class = dev->class >> 16;
+	unsigned int sub_class  = (dev->class & SUB_CLASS_MASK) >> 8;
 
 	/* other than camera, pci bridges and display,
 	 * everything else are south complex devices.
-- 
2.7.4
