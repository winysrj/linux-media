Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:49826 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751826AbaEZTuE (ORCPT
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
Subject: [PATCH 04/11] omap3isp: Move non-critical code out of the mutex-protected section
Date: Mon, 26 May 2014 21:50:05 +0200
Message-Id: <1401133812-8745-5-git-send-email-laurent.pinchart@ideasonboard.com>
In-Reply-To: <1401133812-8745-1-git-send-email-laurent.pinchart@ideasonboard.com>
References: <1401133812-8745-1-git-send-email-laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The isp_video_pix_to_mbus() and isp_video_mbus_to_pix() calls in
isp_video_set_format() only access static fields of the isp_video
structure. They don't need to be protected by a mutex.

Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 drivers/media/platform/omap3isp/ispvideo.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/media/platform/omap3isp/ispvideo.c b/drivers/media/platform/omap3isp/ispvideo.c
index 04d45e7..2876f34 100644
--- a/drivers/media/platform/omap3isp/ispvideo.c
+++ b/drivers/media/platform/omap3isp/ispvideo.c
@@ -631,17 +631,16 @@ isp_video_set_format(struct file *file, void *fh, struct v4l2_format *format)
 	if (format->type != video->type)
 		return -EINVAL;
 
-	mutex_lock(&video->mutex);
-
 	/* Fill the bytesperline and sizeimage fields by converting to media bus
 	 * format and back to pixel format.
 	 */
 	isp_video_pix_to_mbus(&format->fmt.pix, &fmt);
 	isp_video_mbus_to_pix(video, &fmt, &format->fmt.pix);
 
+	mutex_lock(&video->mutex);
 	vfh->format = *format;
-
 	mutex_unlock(&video->mutex);
+
 	return 0;
 }
 
-- 
1.8.5.5

