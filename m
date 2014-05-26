Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:49832 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751830AbaEZTuE (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 26 May 2014 15:50:04 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: Julien BERAUD <julien.beraud@parrot.com>,
	Boris Todorov <boris.st.todorov@gmail.com>,
	Gary Thomas <gary@mlbassoc.com>,
	Enrico <ebutera@users.berlios.de>,
	Stefan Herbrechtsmeier <sherbrec@cit-ec.uni-bielefeld.de>,
	Javier Martinez Canillas <martinez.javier@gmail.com>,
	Chris Whittenburg <whittenburg@gmail.com>,
	Sakari Ailus <sakari.ailus@iki.fi>
Subject: [PATCH 05/11] omap3isp: Default to progressive field order when setting the format
Date: Mon, 26 May 2014 21:50:06 +0200
Message-Id: <1401133812-8745-6-git-send-email-laurent.pinchart@ideasonboard.com>
In-Reply-To: <1401133812-8745-1-git-send-email-laurent.pinchart@ideasonboard.com>
References: <1401133812-8745-1-git-send-email-laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

If the requested field order is not supported default to progressive as
we can't guess how the user will configure the pipeline later on.

Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 drivers/media/platform/omap3isp/ispvideo.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/drivers/media/platform/omap3isp/ispvideo.c b/drivers/media/platform/omap3isp/ispvideo.c
index 2876f34..2fe1c46 100644
--- a/drivers/media/platform/omap3isp/ispvideo.c
+++ b/drivers/media/platform/omap3isp/ispvideo.c
@@ -631,6 +631,15 @@ isp_video_set_format(struct file *file, void *fh, struct v4l2_format *format)
 	if (format->type != video->type)
 		return -EINVAL;
 
+	/* Default to the progressive field order if the requested value is not
+	 * supported (or set to ANY). The only supported orders are progressive
+	 * (available on all video nodes) and alternate (available on capture
+	 * nodes only).
+	 */
+	if (format->fmt.pix.field != V4L2_FIELD_ALTERNATE ||
+	    video->type == V4L2_BUF_TYPE_VIDEO_OUTPUT)
+		format->fmt.pix.field = V4L2_FIELD_NONE;
+
 	/* Fill the bytesperline and sizeimage fields by converting to media bus
 	 * format and back to pixel format.
 	 */
-- 
1.8.5.5

