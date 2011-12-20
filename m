Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.nokia.com ([147.243.1.47]:34304 "EHLO mgw-sa01.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752911Ab1LTU2T (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 20 Dec 2011 15:28:19 -0500
From: Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>
To: linux-media@vger.kernel.org
Cc: laurent.pinchart@ideasonboard.com, dacohen@gmail.com,
	snjw23@gmail.com
Subject: [RFC 15/17] omap3isp: Move definitions required by board code under include/media.
Date: Tue, 20 Dec 2011 22:28:07 +0200
Message-Id: <1324412889-17961-15-git-send-email-sakari.ailus@maxwell.research.nokia.com>
In-Reply-To: <4EF0EFC9.6080501@maxwell.research.nokia.com>
References: <4EF0EFC9.6080501@maxwell.research.nokia.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Sakari Ailus <sakari.ailus@iki.fi>

XCLK definitions are often required by the board code. Move them to public
include file.

Signed-off-by: Sakari Ailus <sakari.ailus@iki.fi>
---
 drivers/media/video/omap3isp/isp.h |    4 ----
 include/media/omap3isp.h           |    4 ++++
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/media/video/omap3isp/isp.h b/drivers/media/video/omap3isp/isp.h
index 7d73a39..dd1b61e 100644
--- a/drivers/media/video/omap3isp/isp.h
+++ b/drivers/media/video/omap3isp/isp.h
@@ -235,10 +235,6 @@ void omap3isp_configure_bridge(struct isp_device *isp,
 			       const struct isp_parallel_platform_data *pdata,
 			       unsigned int shift);
 
-#define ISP_XCLK_NONE			0
-#define ISP_XCLK_A			1
-#define ISP_XCLK_B			2
-
 struct isp_device *omap3isp_get(struct isp_device *isp);
 void omap3isp_put(struct isp_device *isp);
 
diff --git a/include/media/omap3isp.h b/include/media/omap3isp.h
index 8fe0bdf..deb3949 100644
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

