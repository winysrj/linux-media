Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.kundenserver.de ([217.72.192.74]:56450 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752785AbdHGK4H (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Mon, 7 Aug 2017 06:56:07 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Alan Cox <alan@linux.intel.com>
Cc: Arnd Bergmann <arnd@arndb.de>,
        JB Van Puyvelde <jbvanpuyvelde@gmail.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Arvind Yadav <arvind.yadav.cs@gmail.com>,
        Ivan Menshykov <ivan.menshykov@gmail.com>,
        linux-media@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] [media] staging: atomisp: imx: remove dead code
Date: Mon,  7 Aug 2017 12:51:47 +0200
Message-Id: <20170807105552.3722799-1-arnd@arndb.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Making some functions 'static' has uncovered a few functions that
have no caller, through the gcc warnings:

atomisp/i2c/imx/imx.c:1111:12: error: 'imx_t_focus_vcm' defined but not used [-Werror=unused-function]
atomisp/i2c/imx/imx.c:1103:12: error: 'imx_vcm_init' defined but not used [-Werror=unused-function]
atomisp/i2c/imx/imx.c:1095:12: error: 'imx_vcm_power_down' defined but not used [-Werror=unused-function]
atomisp/i2c/imx/imx.c:1087:12: error: 'imx_vcm_power_up' defined but not used [-Werror=unused-function]

All four of these can be removed. Since they call indirect functions,
I also looked at how those are used in turn:

- The power_up/power_down callbacks are called from other functions
  and are still needed.

- The t_focus_vcm callbacks pointers are completely unused and can
  be removed in both imx and ov8858. Some of the handlers are called
  directly and can now be marked static, the others are dummy
  implemntations that we can remove.

- vcm_init is unused in imx, but dw9718_vcm_init is used in ov8858,
  but is not used in imx, so that one needs to stay around. The callback
  pointers in imx can be removed.

Fixes: 9a5a6911aa3f ("staging: imx: fix non-static declarations")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 drivers/staging/media/atomisp/i2c/imx/ad5816g.c   | 11 +-------
 drivers/staging/media/atomisp/i2c/imx/drv201.c    | 11 +-------
 drivers/staging/media/atomisp/i2c/imx/dw9714.c    | 14 +---------
 drivers/staging/media/atomisp/i2c/imx/dw9718.c    |  5 ----
 drivers/staging/media/atomisp/i2c/imx/dw9719.c    | 11 --------
 drivers/staging/media/atomisp/i2c/imx/imx.c       | 32 -----------------------
 drivers/staging/media/atomisp/i2c/imx/imx.h       | 29 --------------------
 drivers/staging/media/atomisp/i2c/ov5693/ov5693.c |  2 +-
 drivers/staging/media/atomisp/i2c/ov8858.h        |  3 ---
 drivers/staging/media/atomisp/i2c/ov8858_btns.h   |  3 ---
 10 files changed, 4 insertions(+), 117 deletions(-)

diff --git a/drivers/staging/media/atomisp/i2c/imx/ad5816g.c b/drivers/staging/media/atomisp/i2c/imx/ad5816g.c
index d68ebb49f002..558dcdf135d9 100644
--- a/drivers/staging/media/atomisp/i2c/imx/ad5816g.c
+++ b/drivers/staging/media/atomisp/i2c/imx/ad5816g.c
@@ -136,7 +136,7 @@ int ad5816g_vcm_power_down(struct v4l2_subdev *sd)
 }
 
 
-int ad5816g_t_focus_vcm(struct v4l2_subdev *sd, u16 val)
+static int ad5816g_t_focus_vcm(struct v4l2_subdev *sd, u16 val)
 {
 	struct i2c_client *client = v4l2_get_subdevdata(sd);
 	u16 data = val & VCM_CODE_MASK;
@@ -214,12 +214,3 @@ int ad5816g_t_vcm_timing(struct v4l2_subdev *sd, s32 value)
 {
 	return 0;
 }
-
-int ad5816g_vcm_init(struct v4l2_subdev *sd)
-{
-	ad5816g_dev.platform_data = camera_get_af_platform_data();
-	return (NULL == ad5816g_dev.platform_data) ? -ENODEV : 0;
-
-}
-
-
diff --git a/drivers/staging/media/atomisp/i2c/imx/drv201.c b/drivers/staging/media/atomisp/i2c/imx/drv201.c
index 915e4019cfeb..6d9d4c968722 100644
--- a/drivers/staging/media/atomisp/i2c/imx/drv201.c
+++ b/drivers/staging/media/atomisp/i2c/imx/drv201.c
@@ -128,7 +128,7 @@ int drv201_vcm_power_down(struct v4l2_subdev *sd)
 }
 
 
-int drv201_t_focus_vcm(struct v4l2_subdev *sd, u16 val)
+static int drv201_t_focus_vcm(struct v4l2_subdev *sd, u16 val)
 {
 	struct i2c_client *client = v4l2_get_subdevdata(sd);
 	u16 data = val & VCM_CODE_MASK;
@@ -207,12 +207,3 @@ int drv201_t_vcm_timing(struct v4l2_subdev *sd, s32 value)
 {
 	return 0;
 }
-
-int drv201_vcm_init(struct v4l2_subdev *sd)
-{
-	drv201_dev.platform_data = camera_get_af_platform_data();
-	return (NULL == drv201_dev.platform_data) ? -ENODEV : 0;
-}
-
-
-
diff --git a/drivers/staging/media/atomisp/i2c/imx/dw9714.c b/drivers/staging/media/atomisp/i2c/imx/dw9714.c
index b7dee1b6bb37..6397a7ee0af6 100644
--- a/drivers/staging/media/atomisp/i2c/imx/dw9714.c
+++ b/drivers/staging/media/atomisp/i2c/imx/dw9714.c
@@ -56,7 +56,7 @@ int dw9714_vcm_power_down(struct v4l2_subdev *sd)
 }
 
 
-int dw9714_t_focus_vcm(struct v4l2_subdev *sd, u16 val)
+static int dw9714_t_focus_vcm(struct v4l2_subdev *sd, u16 val)
 {
 	struct i2c_client *client = v4l2_get_subdevdata(sd);
 	int ret = -EINVAL;
@@ -221,15 +221,3 @@ int dw9714_t_vcm_timing(struct v4l2_subdev *sd, s32 value)
 
 	return 0;
 }
-
-int dw9714_vcm_init(struct v4l2_subdev *sd)
-{
-
-	/* set VCM to home position and vcm mode to direct*/
-	dw9714_dev.vcm_mode = DW9714_DIRECT;
-	dw9714_dev.vcm_settings.update = false;
-	dw9714_dev.platform_data = camera_get_af_platform_data();
-	return (NULL == dw9714_dev.platform_data) ? -ENODEV : 0;
-
-}
-
diff --git a/drivers/staging/media/atomisp/i2c/imx/dw9718.c b/drivers/staging/media/atomisp/i2c/imx/dw9718.c
index 65a1fcf187d5..c02b9f0a2440 100644
--- a/drivers/staging/media/atomisp/i2c/imx/dw9718.c
+++ b/drivers/staging/media/atomisp/i2c/imx/dw9718.c
@@ -204,11 +204,6 @@ int dw9718_q_focus_status(struct v4l2_subdev *sd, s32 *value)
 	return 0;
 }
 
-int dw9718_t_focus_vcm(struct v4l2_subdev *sd, u16 val)
-{
-	return -EINVAL;
-}
-
 int dw9718_t_focus_rel(struct v4l2_subdev *sd, s32 value)
 {
 	return dw9718_t_focus_abs(sd, dw9718_dev.focus + value);
diff --git a/drivers/staging/media/atomisp/i2c/imx/dw9719.c b/drivers/staging/media/atomisp/i2c/imx/dw9719.c
index eca2d7640030..565237796bb4 100644
--- a/drivers/staging/media/atomisp/i2c/imx/dw9719.c
+++ b/drivers/staging/media/atomisp/i2c/imx/dw9719.c
@@ -161,11 +161,6 @@ int dw9719_q_focus_status(struct v4l2_subdev *sd, s32 *value)
 	return 0;
 }
 
-int dw9719_t_focus_vcm(struct v4l2_subdev *sd, u16 val)
-{
-	return -EINVAL;
-}
-
 int dw9719_t_focus_abs(struct v4l2_subdev *sd, s32 value)
 {
 	struct i2c_client *client = v4l2_get_subdevdata(sd);
@@ -201,9 +196,3 @@ int dw9719_t_vcm_timing(struct v4l2_subdev *sd, s32 value)
 {
 	return 0;
 }
-
-int dw9719_vcm_init(struct v4l2_subdev *sd)
-{
-	dw9719_dev.platform_data = camera_get_af_platform_data();
-	return (NULL == dw9719_dev.platform_data) ? -ENODEV : 0;
-}
diff --git a/drivers/staging/media/atomisp/i2c/imx/imx.c b/drivers/staging/media/atomisp/i2c/imx/imx.c
index fb32cb2f2dd1..49ab0af87096 100644
--- a/drivers/staging/media/atomisp/i2c/imx/imx.c
+++ b/drivers/staging/media/atomisp/i2c/imx/imx.c
@@ -1084,38 +1084,6 @@ static int imx_g_bin_factor_y(struct v4l2_subdev *sd, s32 *val)
 	return 0;
 }
 
-static int imx_vcm_power_up(struct v4l2_subdev *sd)
-{
-	struct imx_device *dev = to_imx_sensor(sd);
-	if (dev->vcm_driver && dev->vcm_driver->power_up)
-		return dev->vcm_driver->power_up(sd);
-	return 0;
-}
-
-static int imx_vcm_power_down(struct v4l2_subdev *sd)
-{
-	struct imx_device *dev = to_imx_sensor(sd);
-	if (dev->vcm_driver && dev->vcm_driver->power_down)
-		return dev->vcm_driver->power_down(sd);
-	return 0;
-}
-
-static int imx_vcm_init(struct v4l2_subdev *sd)
-{
-	struct imx_device *dev = to_imx_sensor(sd);
-	if (dev->vcm_driver && dev->vcm_driver->init)
-		return dev->vcm_driver->init(sd);
-	return 0;
-}
-
-static int imx_t_focus_vcm(struct v4l2_subdev *sd, u16 val)
-{
-	struct imx_device *dev = to_imx_sensor(sd);
-	if (dev->vcm_driver && dev->vcm_driver->t_focus_vcm)
-		return dev->vcm_driver->t_focus_vcm(sd, val);
-	return 0;
-}
-
 static int imx_t_focus_abs(struct v4l2_subdev *sd, s32 value)
 {
 	struct imx_device *dev = to_imx_sensor(sd);
diff --git a/drivers/staging/media/atomisp/i2c/imx/imx.h b/drivers/staging/media/atomisp/i2c/imx/imx.h
index 41b4133ca995..30beb2a0ed93 100644
--- a/drivers/staging/media/atomisp/i2c/imx/imx.h
+++ b/drivers/staging/media/atomisp/i2c/imx/imx.h
@@ -222,8 +222,6 @@
 struct imx_vcm {
 	int (*power_up)(struct v4l2_subdev *sd);
 	int (*power_down)(struct v4l2_subdev *sd);
-	int (*init)(struct v4l2_subdev *sd);
-	int (*t_focus_vcm)(struct v4l2_subdev *sd, u16 val);
 	int (*t_focus_abs)(struct v4l2_subdev *sd, s32 value);
 	int (*t_focus_abs_init)(struct v4l2_subdev *sd);
 	int (*t_focus_rel)(struct v4l2_subdev *sd, s32 value);
@@ -549,9 +547,6 @@ static const struct imx_reg imx219_param_update[] = {
 
 extern int ad5816g_vcm_power_up(struct v4l2_subdev *sd);
 extern int ad5816g_vcm_power_down(struct v4l2_subdev *sd);
-extern int ad5816g_vcm_init(struct v4l2_subdev *sd);
-
-extern int ad5816g_t_focus_vcm(struct v4l2_subdev *sd, u16 val);
 extern int ad5816g_t_focus_abs(struct v4l2_subdev *sd, s32 value);
 extern int ad5816g_t_focus_rel(struct v4l2_subdev *sd, s32 value);
 extern int ad5816g_q_focus_status(struct v4l2_subdev *sd, s32 *value);
@@ -561,9 +556,6 @@ extern int ad5816g_t_vcm_timing(struct v4l2_subdev *sd, s32 value);
 
 extern int drv201_vcm_power_up(struct v4l2_subdev *sd);
 extern int drv201_vcm_power_down(struct v4l2_subdev *sd);
-extern int drv201_vcm_init(struct v4l2_subdev *sd);
-
-extern int drv201_t_focus_vcm(struct v4l2_subdev *sd, u16 val);
 extern int drv201_t_focus_abs(struct v4l2_subdev *sd, s32 value);
 extern int drv201_t_focus_rel(struct v4l2_subdev *sd, s32 value);
 extern int drv201_q_focus_status(struct v4l2_subdev *sd, s32 *value);
@@ -573,9 +565,6 @@ extern int drv201_t_vcm_timing(struct v4l2_subdev *sd, s32 value);
 
 extern int dw9714_vcm_power_up(struct v4l2_subdev *sd);
 extern int dw9714_vcm_power_down(struct v4l2_subdev *sd);
-extern int dw9714_vcm_init(struct v4l2_subdev *sd);
-
-extern int dw9714_t_focus_vcm(struct v4l2_subdev *sd, u16 val);
 extern int dw9714_t_focus_abs(struct v4l2_subdev *sd, s32 value);
 extern int dw9714_t_focus_abs_init(struct v4l2_subdev *sd);
 extern int dw9714_t_focus_rel(struct v4l2_subdev *sd, s32 value);
@@ -586,9 +575,6 @@ extern int dw9714_t_vcm_timing(struct v4l2_subdev *sd, s32 value);
 
 extern int dw9719_vcm_power_up(struct v4l2_subdev *sd);
 extern int dw9719_vcm_power_down(struct v4l2_subdev *sd);
-extern int dw9719_vcm_init(struct v4l2_subdev *sd);
-
-extern int dw9719_t_focus_vcm(struct v4l2_subdev *sd, u16 val);
 extern int dw9719_t_focus_abs(struct v4l2_subdev *sd, s32 value);
 extern int dw9719_t_focus_rel(struct v4l2_subdev *sd, s32 value);
 extern int dw9719_q_focus_status(struct v4l2_subdev *sd, s32 *value);
@@ -598,9 +584,6 @@ extern int dw9719_t_vcm_timing(struct v4l2_subdev *sd, s32 value);
 
 extern int dw9718_vcm_power_up(struct v4l2_subdev *sd);
 extern int dw9718_vcm_power_down(struct v4l2_subdev *sd);
-extern int dw9718_vcm_init(struct v4l2_subdev *sd);
-
-extern int dw9718_t_focus_vcm(struct v4l2_subdev *sd, u16 val);
 extern int dw9718_t_focus_abs(struct v4l2_subdev *sd, s32 value);
 extern int dw9718_t_focus_rel(struct v4l2_subdev *sd, s32 value);
 extern int dw9718_q_focus_status(struct v4l2_subdev *sd, s32 *value);
@@ -615,8 +598,6 @@ struct imx_vcm imx_vcms[] = {
 	[IMX175_MERRFLD] = {
 		.power_up = drv201_vcm_power_up,
 		.power_down = drv201_vcm_power_down,
-		.init = drv201_vcm_init,
-		.t_focus_vcm = drv201_t_focus_vcm,
 		.t_focus_abs = drv201_t_focus_abs,
 		.t_focus_abs_init = NULL,
 		.t_focus_rel = drv201_t_focus_rel,
@@ -628,8 +609,6 @@ struct imx_vcm imx_vcms[] = {
 	[IMX175_VALLEYVIEW] = {
 		.power_up = dw9714_vcm_power_up,
 		.power_down = dw9714_vcm_power_down,
-		.init = dw9714_vcm_init,
-		.t_focus_vcm = dw9714_t_focus_vcm,
 		.t_focus_abs = dw9714_t_focus_abs,
 		.t_focus_abs_init = NULL,
 		.t_focus_rel = dw9714_t_focus_rel,
@@ -641,8 +620,6 @@ struct imx_vcm imx_vcms[] = {
 	[IMX135_SALTBAY] = {
 		.power_up = ad5816g_vcm_power_up,
 		.power_down = ad5816g_vcm_power_down,
-		.init = ad5816g_vcm_init,
-		.t_focus_vcm = ad5816g_t_focus_vcm,
 		.t_focus_abs = ad5816g_t_focus_abs,
 		.t_focus_abs_init = NULL,
 		.t_focus_rel = ad5816g_t_focus_rel,
@@ -654,8 +631,6 @@ struct imx_vcm imx_vcms[] = {
 	[IMX135_VICTORIABAY] = {
 		.power_up = dw9719_vcm_power_up,
 		.power_down = dw9719_vcm_power_down,
-		.init = dw9719_vcm_init,
-		.t_focus_vcm = dw9719_t_focus_vcm,
 		.t_focus_abs = dw9719_t_focus_abs,
 		.t_focus_abs_init = NULL,
 		.t_focus_rel = dw9719_t_focus_rel,
@@ -667,8 +642,6 @@ struct imx_vcm imx_vcms[] = {
 	[IMX134_VALLEYVIEW] = {
 		.power_up = dw9714_vcm_power_up,
 		.power_down = dw9714_vcm_power_down,
-		.init = dw9714_vcm_init,
-		.t_focus_vcm = dw9714_t_focus_vcm,
 		.t_focus_abs = dw9714_t_focus_abs,
 		.t_focus_abs_init = dw9714_t_focus_abs_init,
 		.t_focus_rel = dw9714_t_focus_rel,
@@ -680,8 +653,6 @@ struct imx_vcm imx_vcms[] = {
 	[IMX219_MFV0_PRH] = {
 		.power_up = dw9718_vcm_power_up,
 		.power_down = dw9718_vcm_power_down,
-		.init = dw9718_vcm_init,
-		.t_focus_vcm = dw9718_t_focus_vcm,
 		.t_focus_abs = dw9718_t_focus_abs,
 		.t_focus_abs_init = NULL,
 		.t_focus_rel = dw9718_t_focus_rel,
diff --git a/drivers/staging/media/atomisp/i2c/ov5693/ov5693.c b/drivers/staging/media/atomisp/i2c/ov5693/ov5693.c
index d9f278bcf926..123642557aa8 100644
--- a/drivers/staging/media/atomisp/i2c/ov5693/ov5693.c
+++ b/drivers/staging/media/atomisp/i2c/ov5693/ov5693.c
@@ -913,7 +913,7 @@ static int ov5693_q_exposure(struct v4l2_subdev *sd, s32 *value)
 	return ret;
 }
 
-int ad5823_t_focus_vcm(struct v4l2_subdev *sd, u16 val)
+static int ad5823_t_focus_vcm(struct v4l2_subdev *sd, u16 val)
 {
 	struct i2c_client *client = v4l2_get_subdevdata(sd);
 	int ret = -EINVAL;
diff --git a/drivers/staging/media/atomisp/i2c/ov8858.h b/drivers/staging/media/atomisp/i2c/ov8858.h
index d3fde200c013..638d1a803a2b 100644
--- a/drivers/staging/media/atomisp/i2c/ov8858.h
+++ b/drivers/staging/media/atomisp/i2c/ov8858.h
@@ -164,7 +164,6 @@ struct ov8858_vcm {
 	int (*power_up)(struct v4l2_subdev *sd);
 	int (*power_down)(struct v4l2_subdev *sd);
 	int (*init)(struct v4l2_subdev *sd);
-	int (*t_focus_vcm)(struct v4l2_subdev *sd, u16 val);
 	int (*t_focus_abs)(struct v4l2_subdev *sd, s32 value);
 	int (*t_focus_rel)(struct v4l2_subdev *sd, s32 value);
 	int (*q_focus_status)(struct v4l2_subdev *sd, s32 *value);
@@ -312,7 +311,6 @@ static const struct ov8858_reg ov8858_param_update[] = {
 extern int dw9718_vcm_power_up(struct v4l2_subdev *sd);
 extern int dw9718_vcm_power_down(struct v4l2_subdev *sd);
 extern int dw9718_vcm_init(struct v4l2_subdev *sd);
-extern int dw9718_t_focus_vcm(struct v4l2_subdev *sd, u16 val);
 extern int dw9718_t_focus_abs(struct v4l2_subdev *sd, s32 value);
 extern int dw9718_t_focus_rel(struct v4l2_subdev *sd, s32 value);
 extern int dw9718_q_focus_status(struct v4l2_subdev *sd, s32 *value);
@@ -328,7 +326,6 @@ static struct ov8858_vcm ov8858_vcms[] = {
 		.power_up = dw9718_vcm_power_up,
 		.power_down = dw9718_vcm_power_down,
 		.init = dw9718_vcm_init,
-		.t_focus_vcm = dw9718_t_focus_vcm,
 		.t_focus_abs = dw9718_t_focus_abs,
 		.t_focus_rel = dw9718_t_focus_rel,
 		.q_focus_status = dw9718_q_focus_status,
diff --git a/drivers/staging/media/atomisp/i2c/ov8858_btns.h b/drivers/staging/media/atomisp/i2c/ov8858_btns.h
index f9a3cf8fbf1a..7d74a8899fae 100644
--- a/drivers/staging/media/atomisp/i2c/ov8858_btns.h
+++ b/drivers/staging/media/atomisp/i2c/ov8858_btns.h
@@ -164,7 +164,6 @@ struct ov8858_vcm {
 	int (*power_up)(struct v4l2_subdev *sd);
 	int (*power_down)(struct v4l2_subdev *sd);
 	int (*init)(struct v4l2_subdev *sd);
-	int (*t_focus_vcm)(struct v4l2_subdev *sd, u16 val);
 	int (*t_focus_abs)(struct v4l2_subdev *sd, s32 value);
 	int (*t_focus_rel)(struct v4l2_subdev *sd, s32 value);
 	int (*q_focus_status)(struct v4l2_subdev *sd, s32 *value);
@@ -312,7 +311,6 @@ static const struct ov8858_reg ov8858_param_update[] = {
 extern int dw9718_vcm_power_up(struct v4l2_subdev *sd);
 extern int dw9718_vcm_power_down(struct v4l2_subdev *sd);
 extern int dw9718_vcm_init(struct v4l2_subdev *sd);
-extern int dw9718_t_focus_vcm(struct v4l2_subdev *sd, u16 val);
 extern int dw9718_t_focus_abs(struct v4l2_subdev *sd, s32 value);
 extern int dw9718_t_focus_rel(struct v4l2_subdev *sd, s32 value);
 extern int dw9718_q_focus_status(struct v4l2_subdev *sd, s32 *value);
@@ -328,7 +326,6 @@ static struct ov8858_vcm ov8858_vcms[] = {
 		.power_up = dw9718_vcm_power_up,
 		.power_down = dw9718_vcm_power_down,
 		.init = dw9718_vcm_init,
-		.t_focus_vcm = dw9718_t_focus_vcm,
 		.t_focus_abs = dw9718_t_focus_abs,
 		.t_focus_rel = dw9718_t_focus_rel,
 		.q_focus_status = dw9718_q_focus_status,
-- 
2.9.0
