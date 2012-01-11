Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.nokia.com ([147.243.128.24]:41462 "EHLO mgw-da01.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933979Ab2AKV1R (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 11 Jan 2012 16:27:17 -0500
From: Sakari Ailus <sakari.ailus@iki.fi>
To: linux-media@vger.kernel.org
Cc: laurent.pinchart@ideasonboard.com, hverkuil@xs4all.nl,
	teturtia@gmail.com, dacohen@gmail.com, snjw23@gmail.com,
	andriy.shevchenko@linux.intel.com, t.stanislaws@samsung.com,
	tuukkat76@gmail.com, k.debski@gmail.com, riverful@gmail.com
Subject: [PATCH 11/23] omap3isp: Move definitions required by board code under include/media.
Date: Wed, 11 Jan 2012 23:26:48 +0200
Message-Id: <1326317220-15339-11-git-send-email-sakari.ailus@iki.fi>
In-Reply-To: <4F0DFE92.80102@iki.fi>
References: <4F0DFE92.80102@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

XCLK definitions are often required by the board code. Move them to public
include file.

Signed-off-by: Sakari Ailus <sakari.ailus@iki.fi>
---
 drivers/media/video/omap3isp/isp.h |    4 ----
 include/media/omap3isp.h           |    4 ++++
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/media/video/omap3isp/isp.h b/drivers/media/video/omap3isp/isp.h
index 705946e..ff1c422 100644
--- a/drivers/media/video/omap3isp/isp.h
+++ b/drivers/media/video/omap3isp/isp.h
@@ -239,10 +239,6 @@ void omap3isp_configure_bridge(struct isp_device *isp,
 			       const struct isp_parallel_platform_data *pdata,
 			       unsigned int shift);
 
-#define ISP_XCLK_NONE			0
-#define ISP_XCLK_A			1
-#define ISP_XCLK_B			2
-
 struct isp_device *omap3isp_get(struct isp_device *isp);
 void omap3isp_put(struct isp_device *isp);
 
diff --git a/include/media/omap3isp.h b/include/media/omap3isp.h
index e917b1d..9c1a001 100644
--- a/include/media/omap3isp.h
+++ b/include/media/omap3isp.h
@@ -29,6 +29,10 @@
 struct i2c_board_info;
 struct isp_device;
 
+#define ISP_XCLK_NONE			0
+#define ISP_XCLK_A			1
+#define ISP_XCLK_B			2
+
 enum isp_interface_type {
 	ISP_INTERFACE_PARALLEL,
 	ISP_INTERFACE_CSI2A_PHY2,
-- 
1.7.2.5

