Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga07.intel.com ([134.134.136.100]:5093 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752194AbdI0SZd (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 27 Sep 2017 14:25:33 -0400
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-media@vger.kernel.org, Alan Cox <alan@linux.intel.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: [PATCH v1 10/13] staging: atomisp: Remove Gmin dead code #1
Date: Wed, 27 Sep 2017 21:25:05 +0300
Message-Id: <20170927182508.52119-11-andriy.shevchenko@linux.intel.com>
In-Reply-To: <20170927182508.52119-1-andriy.shevchenko@linux.intel.com>
References: <20170927182508.52119-1-andriy.shevchenko@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

struct camera_af_platform_data and bound functions are not used anywhere.

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
---
 .../media/atomisp/include/linux/atomisp_platform.h |  6 ------
 .../platform/intel-mid/atomisp_gmin_platform.c     | 22 ----------------------
 2 files changed, 28 deletions(-)

diff --git a/drivers/staging/media/atomisp/include/linux/atomisp_platform.h b/drivers/staging/media/atomisp/include/linux/atomisp_platform.h
index a8c1825e1d0d..2dae4935ed75 100644
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
index 3f7814a3a5a4..d9db0b13f506 100644
--- a/drivers/staging/media/atomisp/platform/intel-mid/atomisp_gmin_platform.c
+++ b/drivers/staging/media/atomisp/platform/intel-mid/atomisp_gmin_platform.c
@@ -126,28 +126,6 @@ static int af_power_ctrl(struct v4l2_subdev *subdev, int flag)
 	return 0;
 }
 
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
2.14.1
