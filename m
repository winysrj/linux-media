Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga14.intel.com ([192.55.52.115]:47711 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751561AbdJ0RRI (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 27 Oct 2017 13:17:08 -0400
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: linux-media@vger.kernel.org
Cc: alan@linux.intel.com,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: [PATCH v1.1 10/13] staging: atomisp: Remove Gmin dead code #1
Date: Fri, 27 Oct 2017 20:16:54 +0300
Message-Id: <1509124614-30505-1-git-send-email-sakari.ailus@linux.intel.com>
In-Reply-To: <20170927182508.52119-11-andriy.shevchenko@linux.intel.com>
References: <20170927182508.52119-11-andriy.shevchenko@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>

struct camera_af_platform_data and bound functions are not used anywhere.

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
---
since v1:

- Remove af_power_ctrl which is now unused.

 .../media/atomisp/include/linux/atomisp_platform.h |  6 ---
 .../platform/intel-mid/atomisp_gmin_platform.c     | 43 ----------------------
 2 files changed, 49 deletions(-)

diff --git a/drivers/staging/media/atomisp/include/linux/atomisp_platform.h b/drivers/staging/media/atomisp/include/linux/atomisp_platform.h
index a8c1825..2dae493 100644
--- a/drivers/staging/media/atomisp/include/linux/atomisp_platform.h
+++ b/drivers/staging/media/atomisp/include/linux/atomisp_platform.h
@@ -221,12 +221,6 @@ struct camera_sensor_platform_data {
 						    char *module_id);
 };
 
-struct camera_af_platform_data {
-	int (*power_ctrl)(struct v4l2_subdev *subdev, int flag);
-};
-
-const struct camera_af_platform_data *camera_get_af_platform_data(void);
-
 struct camera_mipi_info {
 	enum atomisp_camera_port        port;
 	unsigned int                    num_lanes;
diff --git a/drivers/staging/media/atomisp/platform/intel-mid/atomisp_gmin_platform.c b/drivers/staging/media/atomisp/platform/intel-mid/atomisp_gmin_platform.c
index 129608a..bf9f34b 100644
--- a/drivers/staging/media/atomisp/platform/intel-mid/atomisp_gmin_platform.c
+++ b/drivers/staging/media/atomisp/platform/intel-mid/atomisp_gmin_platform.c
@@ -106,49 +106,6 @@ const struct atomisp_platform_data *atomisp_get_platform_data(void)
 }
 EXPORT_SYMBOL_GPL(atomisp_get_platform_data);
 
-static int af_power_ctrl(struct v4l2_subdev *subdev, int flag)
-{
-	struct gmin_subdev *gs = find_gmin_subdev(subdev);
-
-	if (gs && gs->v2p8_vcm_on == flag)
-		return 0;
-	gs->v2p8_vcm_on = flag;
-
-	/*
-	 * The power here is used for dw9817,
-	 * regulator is from rear sensor
-	 */
-	if (gs->v2p8_vcm_reg) {
-		if (flag)
-			return regulator_enable(gs->v2p8_vcm_reg);
-		else
-			return regulator_disable(gs->v2p8_vcm_reg);
-	}
-	return 0;
-}
-
-/*
- * Used in a handful of modules.  Focus motor control, I think.  Note
- * that there is no configurability in the API, so this needs to be
- * fixed where it is used.
- *
- * struct camera_af_platform_data {
- *     int (*power_ctrl)(struct v4l2_subdev *subdev, int flag);
- * };
- *
- * Note that the implementation in MCG platform_camera.c is stubbed
- * out anyway (i.e. returns zero from the callback) on BYT.  So
- * neither needed on gmin platforms or supported upstream.
- */
-const struct camera_af_platform_data *camera_get_af_platform_data(void)
-{
-	static struct camera_af_platform_data afpd = {
-		.power_ctrl = af_power_ctrl,
-	};
-	return &afpd;
-}
-EXPORT_SYMBOL_GPL(camera_get_af_platform_data);
-
 int atomisp_register_i2c_module(struct v4l2_subdev *subdev,
 				struct camera_sensor_platform_data *plat_data,
 				enum intel_v4l2_subdev_type type)
-- 
2.7.4
