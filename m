Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga05.intel.com ([192.55.52.43]:37265 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751934AbdI0SZO (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 27 Sep 2017 14:25:14 -0400
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-media@vger.kernel.org, Alan Cox <alan@linux.intel.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: [PATCH v1 05/13] staging: atomisp: Do not set GPIO twice
Date: Wed, 27 Sep 2017 21:25:00 +0300
Message-Id: <20170927182508.52119-6-andriy.shevchenko@linux.intel.com>
In-Reply-To: <20170927182508.52119-1-andriy.shevchenko@linux.intel.com>
References: <20170927182508.52119-1-andriy.shevchenko@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

gpiod_get() configures GPIO line at the time of successful request.
Thus, no need to do this explicitly.

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
---
 .../atomisp/platform/intel-mid/atomisp_gmin_platform.c     | 14 ++------------
 1 file changed, 2 insertions(+), 12 deletions(-)

diff --git a/drivers/staging/media/atomisp/platform/intel-mid/atomisp_gmin_platform.c b/drivers/staging/media/atomisp/platform/intel-mid/atomisp_gmin_platform.c
index 17b4cfae5abf..0c5d09bdb93a 100644
--- a/drivers/staging/media/atomisp/platform/intel-mid/atomisp_gmin_platform.c
+++ b/drivers/staging/media/atomisp/platform/intel-mid/atomisp_gmin_platform.c
@@ -408,21 +408,11 @@ static struct gmin_subdev *gmin_subdev_add(struct v4l2_subdev *subdev)
 	if (!ret)
 		clk_disable_unprepare(gmin_subdevs[i].pmc_clk);
 
-	if (!IS_ERR(gmin_subdevs[i].gpio0)) {
-		ret = gpiod_direction_output(gmin_subdevs[i].gpio0, 0);
-		if (ret)
-			dev_err(dev, "gpio0 set output failed: %d\n", ret);
-	} else {
+	if (IS_ERR(gmin_subdevs[i].gpio0))
 		gmin_subdevs[i].gpio0 = NULL;
-	}
 
-	if (!IS_ERR(gmin_subdevs[i].gpio1)) {
-		ret = gpiod_direction_output(gmin_subdevs[i].gpio1, 0);
-		if (ret)
-			dev_err(dev, "gpio1 set output failed: %d\n", ret);
-	} else {
+	if (IS_ERR(gmin_subdevs[i].gpio1))
 		gmin_subdevs[i].gpio1 = NULL;
-	}
 
 	if (pmic_id == PMIC_REGULATOR) {
 		gmin_subdevs[i].v1p8_reg = regulator_get(dev, "V1P8SX");
-- 
2.14.1
