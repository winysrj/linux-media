Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.nokia.com ([147.243.128.24]:41473 "EHLO mgw-da01.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933947Ab2AKV1S (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 11 Jan 2012 16:27:18 -0500
From: Sakari Ailus <sakari.ailus@iki.fi>
To: linux-media@vger.kernel.org
Cc: laurent.pinchart@ideasonboard.com, hverkuil@xs4all.nl,
	teturtia@gmail.com, dacohen@gmail.com, snjw23@gmail.com,
	andriy.shevchenko@linux.intel.com, t.stanislaws@samsung.com,
	tuukkat76@gmail.com, k.debski@gmail.com, riverful@gmail.com
Subject: [PATCH 15/23] omap3isp: Do not attempt to walk the pipeline outside the ISP
Date: Wed, 11 Jan 2012 23:26:52 +0200
Message-Id: <1326317220-15339-15-git-send-email-sakari.ailus@iki.fi>
In-Reply-To: <4F0DFE92.80102@iki.fi>
References: <4F0DFE92.80102@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Do not attempt to walk the pipeline outside of the ISP. The external subdevs
will handle this internally.

Signed-off-by: Sakari Ailus <sakari.ailus@iki.fi>
---
 drivers/media/video/omap3isp/isp.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/drivers/media/video/omap3isp/isp.c b/drivers/media/video/omap3isp/isp.c
index d268d55..3338176 100644
--- a/drivers/media/video/omap3isp/isp.c
+++ b/drivers/media/video/omap3isp/isp.c
@@ -767,7 +767,8 @@ static int isp_pipeline_enable(struct isp_pipeline *pipe,
 
 		/*
 		 * Configure CCDC pixel clock. host_priv != NULL so
-		 * this one is a sensor.
+		 * this one is a sensor. We may also quit now since we
+		 * wouldn't encounter more ISP subdevs anymore.
 		 */
 		if (subdev->host_priv) {
 			struct v4l2_ext_controls ctrls;
@@ -791,6 +792,7 @@ static int isp_pipeline_enable(struct isp_pipeline *pipe,
 			}
 
 			isp_set_pixel_clock(isp, ctrl.value64);
+			break;
 		}
 
 		if (subdev == &isp->isp_ccdc.subdev) {
-- 
1.7.2.5

