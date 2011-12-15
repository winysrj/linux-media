Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.nokia.com ([147.243.1.47]:45282 "EHLO mgw-sa01.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756195Ab1LOJuj (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 15 Dec 2011 04:50:39 -0500
From: Sakari Ailus <sakari.ailus@iki.fi>
To: linux-media@vger.kernel.org
Cc: laurent.pinchart@ideasonboard.com
Subject: [RFC 1/4] omap3isp: Implement validate_pipeline
Date: Thu, 15 Dec 2011 11:50:32 +0200
Message-Id: <1323942635-13058-1-git-send-email-sakari.ailus@iki.fi>
In-Reply-To: <20111215095015.GC3677@valkosipuli.localdomain>
References: <20111215095015.GC3677@valkosipuli.localdomain>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Validate pipeline of any external entity connected to the ISP driver.
The validation of the pipeline for the part that involves links inside the
domain of another driver must be done by that very driver.

Signed-off-by: Sakari Ailus <sakari.ailus@iki.fi>
---
 drivers/media/video/omap3isp/ispvideo.c |   12 ++++++++++++
 1 files changed, 12 insertions(+), 0 deletions(-)

diff --git a/drivers/media/video/omap3isp/ispvideo.c b/drivers/media/video/omap3isp/ispvideo.c
index f229057..17bc03c 100644
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
+			if (IS_ERR_VALUE(ret))
+				return -EPIPE;
+			break;
+		}
+
 		if (shifter_link) {
 			unsigned int parallel_shift = 0;
 			if (isp->isp_ccdc.input == CCDC_INPUT_PARALLEL) {
-- 
1.7.2.5

