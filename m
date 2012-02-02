Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.nokia.com ([147.243.128.26]:44540 "EHLO mgw-da02.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754999Ab2BBXzE (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 2 Feb 2012 18:55:04 -0500
From: Sakari Ailus <sakari.ailus@iki.fi>
To: linux-media@vger.kernel.org
Cc: laurent.pinchart@ideasonboard.com, dacohen@gmail.com,
	snjw23@gmail.com, andriy.shevchenko@linux.intel.com,
	t.stanislaws@samsung.com, tuukkat76@gmail.com,
	k.debski@samsung.com, riverful@gmail.com, hverkuil@xs4all.nl,
	teturtia@gmail.com
Subject: [PATCH v2 28/31] omap3isp: Add resizer data rate configuration to resizer_set_stream
Date: Fri,  3 Feb 2012 01:54:48 +0200
Message-Id: <1328226891-8968-28-git-send-email-sakari.ailus@iki.fi>
In-Reply-To: <20120202235231.GC841@valkosipuli.localdomain>
References: <20120202235231.GC841@valkosipuli.localdomain>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Sakari Ailus <sakari.ailus@iki.fi>
---
 drivers/media/video/omap3isp/ispresizer.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/drivers/media/video/omap3isp/ispresizer.c b/drivers/media/video/omap3isp/ispresizer.c
index 6ce2349..81e1bc4 100644
--- a/drivers/media/video/omap3isp/ispresizer.c
+++ b/drivers/media/video/omap3isp/ispresizer.c
@@ -1147,9 +1147,13 @@ static int resizer_set_stream(struct v4l2_subdev *sd, int enable)
 	struct device *dev = to_device(res);
 
 	if (res->state == ISP_PIPELINE_STREAM_STOPPED) {
+		struct isp_pipeline *pipe = to_isp_pipeline(&sd->entity);
+
 		if (enable == ISP_PIPELINE_STREAM_STOPPED)
 			return 0;
 
+		omap3isp_resizer_max_rate(res, &pipe->max_rate);
+
 		omap3isp_subclk_enable(isp, OMAP3_ISP_SUBCLK_RESIZER);
 		resizer_configure(res);
 		resizer_print_status(res);
-- 
1.7.2.5

