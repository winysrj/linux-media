Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:33792 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752633AbdLSVBF (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 19 Dec 2017 16:01:05 -0500
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: Alan Cox <alan@linux.intel.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        linux-media@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        devel@driverdev.osuosl.org, Kristian Beilke <beilke@posteo.de>
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: [PATCH v1 09/10] staging: atomisp: Use standard DMI match table
Date: Tue, 19 Dec 2017 22:59:56 +0200
Message-Id: <20171219205957.10933-9-andriy.shevchenko@linux.intel.com>
In-Reply-To: <20171219205957.10933-1-andriy.shevchenko@linux.intel.com>
References: <20171219205957.10933-1-andriy.shevchenko@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The traditional pattern is to use DMI matching table and provide a
corresponding driver_data in it.

Convert driver to use DMI matching table.

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
---
 .../platform/intel-mid/atomisp_gmin_platform.c     | 109 +++++++++++++--------
 1 file changed, 70 insertions(+), 39 deletions(-)

diff --git a/drivers/staging/media/atomisp/platform/intel-mid/atomisp_gmin_platform.c b/drivers/staging/media/atomisp/platform/intel-mid/atomisp_gmin_platform.c
index 0f859bb714bf..8408a58ed764 100644
--- a/drivers/staging/media/atomisp/platform/intel-mid/atomisp_gmin_platform.c
+++ b/drivers/staging/media/atomisp/platform/intel-mid/atomisp_gmin_platform.c
@@ -209,7 +209,7 @@ struct gmin_cfg_var {
 	const char *name, *val;
 };
 
-static const struct gmin_cfg_var ffrd8_vars[] = {
+static struct gmin_cfg_var ffrd8_vars[] = {
 	{ "INTCF1B:00_ImxId",    "0x134" },
 	{ "INTCF1B:00_CsiPort",  "1" },
 	{ "INTCF1B:00_CsiLanes", "4" },
@@ -220,14 +220,14 @@ static const struct gmin_cfg_var ffrd8_vars[] = {
 /* Cribbed from MCG defaults in the mt9m114 driver, not actually verified
  * vs. T100 hardware
  */
-static const struct gmin_cfg_var t100_vars[] = {
+static struct gmin_cfg_var t100_vars[] = {
 	{ "INT33F0:00_CsiPort",  "0" },
 	{ "INT33F0:00_CsiLanes", "1" },
 	{ "INT33F0:00_CamClk",   "1" },
 	{},
 };
 
-static const struct gmin_cfg_var mrd7_vars[] = {
+static struct gmin_cfg_var mrd7_vars[] = {
 	{"INT33F8:00_CamType", "1"},
 	{"INT33F8:00_CsiPort", "1"},
 	{"INT33F8:00_CsiLanes", "2"},
@@ -243,7 +243,7 @@ static const struct gmin_cfg_var mrd7_vars[] = {
 	{},
 };
 
-static const struct gmin_cfg_var ecs7_vars[] = {
+static struct gmin_cfg_var ecs7_vars[] = {
 	{"INT33BE:00_CsiPort", "1"},
 	{"INT33BE:00_CsiLanes", "2"},
 	{"INT33BE:00_CsiFmt", "13"},
@@ -258,8 +258,7 @@ static const struct gmin_cfg_var ecs7_vars[] = {
 	{},
 };
 
-
-static const struct gmin_cfg_var i8880_vars[] = {
+static struct gmin_cfg_var i8880_vars[] = {
 	{"XXOV2680:00_CsiPort", "1"},
 	{"XXOV2680:00_CsiLanes", "1"},
 	{"XXOV2680:00_CamClk", "0"},
@@ -269,18 +268,45 @@ static const struct gmin_cfg_var i8880_vars[] = {
 	{},
 };
 
-static const struct {
-	const char *dmi_board_name;
-	const struct gmin_cfg_var *vars;
-} hard_vars[] = {
-	{ "BYT-T FFD8", ffrd8_vars },
-	{ "T100TA", t100_vars },
-	{ "MRD7", mrd7_vars },
-	{ "ST70408", ecs7_vars },
-	{ "VTA0803", i8880_vars },
+static const struct dmi_system_id gmin_vars[] = {
+	{
+		.ident = "BYT-T FFD8",
+		.matches = {
+			DMI_MATCH(DMI_BOARD_NAME, "BYT-T FFD8"),
+		},
+		.driver_data = ffrd8_vars,
+	},
+	{
+		.ident = "T100TA",
+		.matches = {
+			DMI_MATCH(DMI_BOARD_NAME, "T100TA"),
+		},
+		.driver_data = t100_vars,
+	},
+	{
+		.ident = "MRD7",
+		.matches = {
+			DMI_MATCH(DMI_BOARD_NAME, "MRD7"),
+		},
+		.driver_data = mrd7_vars,
+	},
+	{
+		.ident = "ST70408",
+		.matches = {
+			DMI_MATCH(DMI_BOARD_NAME, "ST70408"),
+		},
+		.driver_data = ecs7_vars,
+	},
+	{
+		.ident = "VTA0803",
+		.matches = {
+			DMI_MATCH(DMI_BOARD_NAME, "VTA0803"),
+		},
+		.driver_data = i8880_vars,
+	},
+	{}
 };
 
-
 #define GMIN_CFG_VAR_EFI_GUID EFI_GUID(0xecb54cd9, 0xe5ae, 0x4fdc, \
 				       0xa9, 0x71, 0xe8, 0x77,	   \
 				       0x75, 0x60, 0x68, 0xf7)
@@ -604,6 +630,29 @@ int atomisp_gmin_register_vcm_control(struct camera_vcm_control *vcmCtrl)
 }
 EXPORT_SYMBOL_GPL(atomisp_gmin_register_vcm_control);
 
+static int gmin_get_hardcoded_var(struct gmin_cfg_var *varlist,
+				  const char *var8, char *out, size_t *out_len)
+{
+	struct gmin_cfg_var *gv;
+
+	for (gv = varlist; gv->name; gv++) {
+		size_t vl;
+
+		if (strcmp(var8, gv->name))
+			continue;
+
+		vl = strlen(gv->val);
+		if (vl > *out_len - 1)
+			return -ENOSPC;
+
+		strcpy(out, gv->val);
+		*out_len = vl;
+		return 0;
+	}
+
+	return -EINVAL;
+}
+
 /* Retrieves a device-specific configuration variable.  The dev
  * argument should be a device with an ACPI companion, as all
  * configuration is based on firmware ID.
@@ -614,7 +663,8 @@ static int gmin_get_config_var(struct device *dev, const char *var,
 	char var8[CFG_VAR_NAME_MAX];
 	efi_char16_t var16[CFG_VAR_NAME_MAX];
 	struct efivar_entry *ev;
-	int i, j, ret;
+	const struct dmi_system_id *id;
+	int i, ret;
 
 	if (dev && ACPI_COMPANION(dev))
 		dev = &ACPI_COMPANION(dev)->dev;
@@ -631,28 +681,9 @@ static int gmin_get_config_var(struct device *dev, const char *var,
 	 * Some device firmwares lack the ability to set EFI variables at
 	 * runtime.
 	 */
-	for (i = 0; i < ARRAY_SIZE(hard_vars); i++) {
-		if (dmi_match(DMI_BOARD_NAME, hard_vars[i].dmi_board_name)) {
-			for (j = 0; hard_vars[i].vars[j].name; j++) {
-				size_t vl;
-				const struct gmin_cfg_var *gv;
-
-				gv = &hard_vars[i].vars[j];
-				vl = strlen(gv->val);
-
-				if (strcmp(var8, gv->name))
-					continue;
-				if (vl > *out_len - 1)
-					return -ENOSPC;
-
-				memcpy(out, gv->val, min(*out_len, vl+1));
-				out[*out_len-1] = 0;
-				*out_len = vl;
-
-				return 0;
-			}
-		}
-	}
+	id = dmi_first_match(gmin_vars);
+	if (id)
+		return gmin_get_hardcoded_var(id->driver_data, var8, out, out_len);
 
 	/* Our variable names are ASCII by construction, but EFI names
 	 * are wide chars.  Convert and zero-pad.
-- 
2.15.1
