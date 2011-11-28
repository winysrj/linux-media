Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:53262 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753095Ab1K1Lhc (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 28 Nov 2011 06:37:32 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: sakari.ailus@iki.fi
Subject: [PATCH] omap3isp: video: Don't WARN() on unknown pixel formats
Date: Mon, 28 Nov 2011 12:37:34 +0100
Message-Id: <1322480254-10461-1-git-send-email-laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

When mapping from a V4L2 pixel format to a media bus format in the
VIDIOC_TRY_FMT and VIDIOC_S_FMT handlers, the requested format may be
unsupported by the driver. Return a hardcoded format instead of
WARN()ing in that case.

Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 drivers/media/video/omap3isp/ispvideo.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/media/video/omap3isp/ispvideo.c b/drivers/media/video/omap3isp/ispvideo.c
index d100072..ffe7ce9 100644
--- a/drivers/media/video/omap3isp/ispvideo.c
+++ b/drivers/media/video/omap3isp/ispvideo.c
@@ -210,14 +210,14 @@ static void isp_video_pix_to_mbus(const struct v4l2_pix_format *pix,
 	mbus->width = pix->width;
 	mbus->height = pix->height;
 
-	for (i = 0; i < ARRAY_SIZE(formats); ++i) {
+	/* Skip the last format in the loop so that it will be selected if no
+	 * match is found.
+	 */
+	for (i = 0; i < ARRAY_SIZE(formats) - 1; ++i) {
 		if (formats[i].pixelformat == pix->pixelformat)
 			break;
 	}
 
-	if (WARN_ON(i == ARRAY_SIZE(formats)))
-		return;
-
 	mbus->code = formats[i].code;
 	mbus->colorspace = pix->colorspace;
 	mbus->field = pix->field;
-- 
Regards,

Laurent Pinchart

