Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga03.intel.com ([134.134.136.65]:50408 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752377AbdLSVAB (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 19 Dec 2017 16:00:01 -0500
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: Alan Cox <alan@linux.intel.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        linux-media@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        devel@driverdev.osuosl.org, Kristian Beilke <beilke@posteo.de>
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: [PATCH v1 02/10] staging: atomisp: Remove duplicate NULL-check
Date: Tue, 19 Dec 2017 22:59:49 +0200
Message-Id: <20171219205957.10933-2-andriy.shevchenko@linux.intel.com>
In-Reply-To: <20171219205957.10933-1-andriy.shevchenko@linux.intel.com>
References: <20171219205957.10933-1-andriy.shevchenko@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

GPIO framework checks for NULL pointer when gpiod_set_value() is called.

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
---
 .../staging/media/atomisp/platform/intel-mid/atomisp_gmin_platform.c  | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/media/atomisp/platform/intel-mid/atomisp_gmin_platform.c b/drivers/staging/media/atomisp/platform/intel-mid/atomisp_gmin_platform.c
index a5d0dd88a8bc..8fb5147531a5 100644
--- a/drivers/staging/media/atomisp/platform/intel-mid/atomisp_gmin_platform.c
+++ b/drivers/staging/media/atomisp/platform/intel-mid/atomisp_gmin_platform.c
@@ -394,7 +394,7 @@ static int gmin_gpio0_ctrl(struct v4l2_subdev *subdev, int on)
 {
 	struct gmin_subdev *gs = find_gmin_subdev(subdev);
 
-	if (gs && gs->gpio0) {
+	if (gs) {
 		gpiod_set_value(gs->gpio0, on);
 		return 0;
 	}
@@ -405,7 +405,7 @@ static int gmin_gpio1_ctrl(struct v4l2_subdev *subdev, int on)
 {
 	struct gmin_subdev *gs = find_gmin_subdev(subdev);
 
-	if (gs && gs->gpio1) {
+	if (gs) {
 		gpiod_set_value(gs->gpio1, on);
 		return 0;
 	}
-- 
2.15.1
