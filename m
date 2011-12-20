Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.nokia.com ([147.243.1.47]:34278 "EHLO mgw-sa01.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752685Ab1LTU2Q (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 20 Dec 2011 15:28:16 -0500
From: Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>
To: linux-media@vger.kernel.org
Cc: laurent.pinchart@ideasonboard.com, dacohen@gmail.com,
	snjw23@gmail.com
Subject: [RFC 11/17] omap3isp: Implement validate_pipeline
Date: Tue, 20 Dec 2011 22:28:03 +0200
Message-Id: <1324412889-17961-11-git-send-email-sakari.ailus@maxwell.research.nokia.com>
In-Reply-To: <4EF0EFC9.6080501@maxwell.research.nokia.com>
References: <4EF0EFC9.6080501@maxwell.research.nokia.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Sakari Ailus <sakari.ailus@iki.fi>

Validate pipeline of any external entity connected to the ISP driver.
The validation of the pipeline for the part that involves links inside the
domain of another driver must be done by that very driver.

Signed-off-by: Sakari Ailus <sakari.ailus@iki.fi>
---
 drivers/media/video/omap3isp/ispvideo.c |   12 ++++++++++++
 1 files changed, 12 insertions(+), 0 deletions(-)

diff --git a/drivers/media/video/omap3isp/ispvideo.c b/drivers/media/video/omap3isp/ispvideo.c
index f229057..0568234 100644
--- a/drivers/media/video/omap3isp/ispvideo.c
+++ b/drivers/media/video/omap3isp/ispvideo.c
@@ -355,6 +355,18 @@ static int isp_video_validate_pipeline(struct isp_pipeline *pipe)
 		    fmt_source.format.height != fmt_sink.format.height)
 			return -EPIPE;
 
+		if (subdev->host_priv) {
+			/*
+			 * host_priv != NULL: this is a sensor. Issue
+			 * validate_pipeline. We're at our end of the
+			 * pipeline so we quit now.
+			 */
+			ret = v4l2_subdev_call(subdev, pad, validate_pipeline);
+			if (ret < 0 && ret != -ENOIOCTLCMD)
+				return -EPIPE;
+			break;
+		}
+
 		if (shifter_link) {
 			unsigned int parallel_shift = 0;
 			if (isp->isp_ccdc.input == CCDC_INPUT_PARALLEL) {
-- 
1.7.2.5

