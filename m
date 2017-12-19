Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga07.intel.com ([134.134.136.100]:7274 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753127AbdLSVIS (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 19 Dec 2017 16:08:18 -0500
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: Alan Cox <alan@linux.intel.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        linux-media@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        devel@driverdev.osuosl.org, Kristian Beilke <beilke@posteo.de>
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: [PATCH v1 01/10] staging: atomisp: Don't leak GPIO resources if clk_get() failed
Date: Tue, 19 Dec 2017 22:59:48 +0200
Message-Id: <20171219205957.10933-1-andriy.shevchenko@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

In case devm_clk_get() call fails the previously requested GPIOs are
left requested.

Fix this by moving GPIO request code after devm_clk_get() call.

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
---
 .../staging/media/atomisp/platform/intel-mid/atomisp_gmin_platform.c  | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/media/atomisp/platform/intel-mid/atomisp_gmin_platform.c b/drivers/staging/media/atomisp/platform/intel-mid/atomisp_gmin_platform.c
index bf9f34b7ad72..a5d0dd88a8bc 100644
--- a/drivers/staging/media/atomisp/platform/intel-mid/atomisp_gmin_platform.c
+++ b/drivers/staging/media/atomisp/platform/intel-mid/atomisp_gmin_platform.c
@@ -322,8 +322,6 @@ static struct gmin_subdev *gmin_subdev_add(struct v4l2_subdev *subdev)
 							VLV2_CLK_PLL_19P2MHZ);
 	gmin_subdevs[i].csi_port = gmin_get_var_int(dev, "CsiPort", 0);
 	gmin_subdevs[i].csi_lanes = gmin_get_var_int(dev, "CsiLanes", 1);
-	gmin_subdevs[i].gpio0 = gpiod_get_index(dev, NULL, 0, GPIOD_OUT_LOW);
-	gmin_subdevs[i].gpio1 = gpiod_get_index(dev, NULL, 1, GPIOD_OUT_LOW);
 
 	/* get PMC clock with clock framework */
 	snprintf(gmin_pmc_clk_name,
@@ -356,9 +354,11 @@ static struct gmin_subdev *gmin_subdev_add(struct v4l2_subdev *subdev)
 	if (!ret)
 		clk_disable_unprepare(gmin_subdevs[i].pmc_clk);
 
+	gmin_subdevs[i].gpio0 = gpiod_get_index(dev, NULL, 0, GPIOD_OUT_LOW);
 	if (IS_ERR(gmin_subdevs[i].gpio0))
 		gmin_subdevs[i].gpio0 = NULL;
 
+	gmin_subdevs[i].gpio1 = gpiod_get_index(dev, NULL, 1, GPIOD_OUT_LOW);
 	if (IS_ERR(gmin_subdevs[i].gpio1))
 		gmin_subdevs[i].gpio1 = NULL;
 
-- 
2.15.1
