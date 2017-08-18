Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:51656 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1751243AbdHRLXU (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 18 Aug 2017 07:23:20 -0400
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: linux-media@vger.kernel.org
Cc: niklas.soderlund@ragnatech.se, robh@kernel.org, hverkuil@xs4all.nl,
        laurent.pinchart@ideasonboard.com, devicetree@vger.kernel.org
Subject: [PATCH v3 1/3] omap3isp: Drop redundant isp->subdevs field and ISP_MAX_SUBDEVS
Date: Fri, 18 Aug 2017 14:23:15 +0300
Message-Id: <20170818112317.30933-2-sakari.ailus@linux.intel.com>
In-Reply-To: <20170818112317.30933-1-sakari.ailus@linux.intel.com>
References: <20170818112317.30933-1-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

struct omap3isp.subdevs field and ISP_MAX_SUBDEVS macro are both unused.
Remove them.

Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
---
 drivers/media/platform/omap3isp/isp.h | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/media/platform/omap3isp/isp.h b/drivers/media/platform/omap3isp/isp.h
index e528df6efc09..848cd96b67ca 100644
--- a/drivers/media/platform/omap3isp/isp.h
+++ b/drivers/media/platform/omap3isp/isp.h
@@ -220,9 +220,6 @@ struct isp_device {
 
 	unsigned int sbl_resources;
 	unsigned int subclk_resources;
-
-#define ISP_MAX_SUBDEVS		8
-	struct v4l2_subdev *subdevs[ISP_MAX_SUBDEVS];
 };
 
 struct isp_async_subdev {
-- 
2.11.0
