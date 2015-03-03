Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:58336 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754819AbbCCOUO (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 3 Mar 2015 09:20:14 -0500
Received: from avalon.ideasonboard.com (dsl-hkibrasgw3-50ddcc-40.dhcp.inet.fi [80.221.204.40])
	by galahad.ideasonboard.com (Postfix) with ESMTPSA id 6377620066
	for <linux-media@vger.kernel.org>; Tue,  3 Mar 2015 15:19:20 +0100 (CET)
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Subject: [PATCH] staging: media: omap4iss: video: Don't WARN() on unknown pixel formats
Date: Tue,  3 Mar 2015 16:20:11 +0200
Message-Id: <1425392411-26608-1-git-send-email-laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

When mapping from a V4L2 pixel format to a media bus format in the
VIDIOC_TRY_FMT and VIDIOC_S_FMT handlers, the requested format may be
unsupported by the driver. Return a hardcoded default format instead of
WARN()ing in that case.

Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 drivers/staging/media/omap4iss/iss_video.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/media/omap4iss/iss_video.c b/drivers/staging/media/omap4iss/iss_video.c
index 6955044..e949b6f 100644
--- a/drivers/staging/media/omap4iss/iss_video.c
+++ b/drivers/staging/media/omap4iss/iss_video.c
@@ -171,14 +171,14 @@ static void iss_video_pix_to_mbus(const struct v4l2_pix_format *pix,
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

