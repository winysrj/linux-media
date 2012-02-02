Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.nokia.com ([147.243.128.24]:50938 "EHLO mgw-da01.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754425Ab2BBXzD (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 2 Feb 2012 18:55:03 -0500
From: Sakari Ailus <sakari.ailus@iki.fi>
To: linux-media@vger.kernel.org
Cc: laurent.pinchart@ideasonboard.com, dacohen@gmail.com,
	snjw23@gmail.com, andriy.shevchenko@linux.intel.com,
	t.stanislaws@samsung.com, tuukkat76@gmail.com,
	k.debski@samsung.com, riverful@gmail.com, hverkuil@xs4all.nl,
	teturtia@gmail.com
Subject: [PATCH v2 18/31] omap3isp: Move definitions required by board code under include/media.
Date: Fri,  3 Feb 2012 01:54:38 +0200
Message-Id: <1328226891-8968-18-git-send-email-sakari.ailus@iki.fi>
In-Reply-To: <20120202235231.GC841@valkosipuli.localdomain>
References: <20120202235231.GC841@valkosipuli.localdomain>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

XCLK definitions are often required by the board code. Move them to public
include file.

Signed-off-by: Sakari Ailus <sakari.ailus@iki.fi>
Acked-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 drivers/media/video/omap3isp/isp.h |    4 ----
 include/media/omap3isp.h           |    4 ++++
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/media/video/omap3isp/isp.h b/drivers/media/video/omap3isp/isp.h
index d96603e..2e78041 100644
--- a/drivers/media/video/omap3isp/isp.h
+++ b/drivers/media/video/omap3isp/isp.h
@@ -237,10 +237,6 @@ void omap3isp_configure_bridge(struct isp_device *isp,
 			       const struct isp_parallel_platform_data *pdata,
 			       unsigned int shift);
 
-#define ISP_XCLK_NONE			0
-#define ISP_XCLK_A			1
-#define ISP_XCLK_B			2
-
 struct isp_device *omap3isp_get(struct isp_device *isp);
 void omap3isp_put(struct isp_device *isp);
 
diff --git a/include/media/omap3isp.h b/include/media/omap3isp.h
index 042849a..3f4928d 100644
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

