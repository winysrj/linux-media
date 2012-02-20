Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.nokia.com ([147.243.128.24]:30372 "EHLO mgw-da01.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753212Ab2BTB7b (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 19 Feb 2012 20:59:31 -0500
From: Sakari Ailus <sakari.ailus@iki.fi>
To: linux-media@vger.kernel.org
Cc: laurent.pinchart@ideasonboard.com, hverkuil@xs4all.nl,
	teturtia@gmail.com, dacohen@gmail.com, snjw23@gmail.com,
	andriy.shevchenko@linux.intel.com, t.stanislaws@samsung.com,
	tuukkat76@gmail.com, k.debski@gmail.com, riverful@gmail.com
Subject: [PATCH v3 24/33] omap3isp: Add information on external subdev to struct isp_pipeline
Date: Mon, 20 Feb 2012 03:57:03 +0200
Message-Id: <1329703032-31314-24-git-send-email-sakari.ailus@iki.fi>
In-Reply-To: <20120220015605.GI7784@valkosipuli.localdomain>
References: <20120220015605.GI7784@valkosipuli.localdomain>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add pointer to external subdev, pixel rate of the external subdev and bpp of
the format to struct isp_pipeline.

Signed-off-by: Sakari Ailus <sakari.ailus@iki.fi>
---
 drivers/media/video/omap3isp/ispvideo.h |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/drivers/media/video/omap3isp/ispvideo.h b/drivers/media/video/omap3isp/ispvideo.h
index d91bdb9..b198723 100644
--- a/drivers/media/video/omap3isp/ispvideo.h
+++ b/drivers/media/video/omap3isp/ispvideo.h
@@ -102,6 +102,9 @@ struct isp_pipeline {
 	bool do_propagation; /* of frame number */
 	bool error;
 	struct v4l2_fract max_timeperframe;
+	struct v4l2_subdev *external;
+	unsigned int external_rate;
+	int external_bpp;
 };
 
 #define to_isp_pipeline(__e) \
-- 
1.7.2.5

