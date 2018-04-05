Return-path: <linux-media-owner@vger.kernel.org>
Received: from osg.samsung.com ([64.30.133.232]:34659 "EHLO osg.samsung.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751417AbeDERyW (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 5 Apr 2018 13:54:22 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH 08/16] media: mmp-camera.h: add missing platform data
Date: Thu,  5 Apr 2018 13:54:08 -0400
Message-Id: <74a49040af24a1632e094e367f1b9f8fe42faf56.1522949748.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1522949748.git.mchehab@s-opensource.com>
References: <cover.1522949748.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1522949748.git.mchehab@s-opensource.com>
References: <cover.1522949748.git.mchehab@s-opensource.com>
To: unlisted-recipients:; (no To-header on input)@bombadil.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Those definitions used to be part of the original patch:
	https://patchwork.kernel.org/patch/2815221/

But, somehow, nobody ever noticed until today. Years later,
Arnd discovered that mmp-camera driver doesn't build and make
it depend on BROKEN.

Add the missing bits here, in order to remove BROKEN dependency.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 include/linux/platform_data/media/mmp-camera.h | 19 +++++++++++++++++++
 1 file changed, 19 insertions(+)

diff --git a/include/linux/platform_data/media/mmp-camera.h b/include/linux/platform_data/media/mmp-camera.h
index 83804028115c..d2d3a443eedf 100644
--- a/include/linux/platform_data/media/mmp-camera.h
+++ b/include/linux/platform_data/media/mmp-camera.h
@@ -3,8 +3,27 @@
  * Information for the Marvell Armada MMP camera
  */
 
+#include <media/v4l2-mediabus.h>
+
+enum dphy3_algo {
+	DPHY3_ALGO_DEFAULT = 0,
+	DPHY3_ALGO_PXA910,
+	DPHY3_ALGO_PXA2128
+};
+
 struct mmp_camera_platform_data {
 	struct platform_device *i2c_device;
 	int sensor_power_gpio;
 	int sensor_reset_gpio;
+	enum v4l2_mbus_type bus_type;
+	int mclk_min;	/* The minimal value of MCLK */
+	int mclk_src;	/* which clock source the MCLK derives from */
+	int mclk_div;	/* Clock Divider Value for MCLK */
+	/*
+	 * MIPI support
+	 */
+	int dphy[3];		/* DPHY: CSI2_DPHY3, CSI2_DPHY5, CSI2_DPHY6 */
+	enum dphy3_algo dphy3_algo;	/* algos for calculate CSI2_DPHY3 */
+	int lane;		/* ccic used lane number; 0 means DVP mode */
+	int lane_clk;
 };
-- 
2.14.3
