Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga06.intel.com ([134.134.136.31]:52398 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752086AbdI0SZT (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 27 Sep 2017 14:25:19 -0400
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-media@vger.kernel.org, Alan Cox <alan@linux.intel.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: [PATCH v1 12/13] staging: atomisp: Remove duplicate declaration in header
Date: Wed, 27 Sep 2017 21:25:07 +0300
Message-Id: <20170927182508.52119-13-andriy.shevchenko@linux.intel.com>
In-Reply-To: <20170927182508.52119-1-andriy.shevchenko@linux.intel.com>
References: <20170927182508.52119-1-andriy.shevchenko@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

There are 3 declarations that are present in atomisp_platform.h and
atomisp_gmin_platform.h. Remove duplications from the latter.

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
---
 drivers/staging/media/atomisp/include/linux/atomisp_gmin_platform.h | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/staging/media/atomisp/include/linux/atomisp_gmin_platform.h b/drivers/staging/media/atomisp/include/linux/atomisp_gmin_platform.h
index 5390b97ac6e7..7e3ca12dd4e9 100644
--- a/drivers/staging/media/atomisp/include/linux/atomisp_gmin_platform.h
+++ b/drivers/staging/media/atomisp/include/linux/atomisp_gmin_platform.h
@@ -17,9 +17,6 @@
 
 #include "atomisp_platform.h"
 
-const struct atomisp_camera_caps *atomisp_get_default_camera_caps(void);
-const struct atomisp_platform_data *atomisp_get_platform_data(void);
-const struct camera_af_platform_data *camera_get_af_platform_data(void);
 int atomisp_register_i2c_module(struct v4l2_subdev *subdev,
                                 struct camera_sensor_platform_data *plat_data,
                                 enum intel_v4l2_subdev_type type);
-- 
2.14.1
