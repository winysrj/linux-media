Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:49826 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751466AbaEZTuF (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 26 May 2014 15:50:05 -0400
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
Subject: [PATCH 06/11] omap3isp: video: Validate the video node field order
Date: Mon, 26 May 2014 21:50:07 +0200
Message-Id: <1401133812-8745-7-git-send-email-laurent.pinchart@ideasonboard.com>
In-Reply-To: <1401133812-8745-1-git-send-email-laurent.pinchart@ideasonboard.com>
References: <1401133812-8745-1-git-send-email-laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The field order requested on the video node must match the field order
at the connected subdevice source pad.

Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 drivers/media/platform/omap3isp/ispvideo.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/media/platform/omap3isp/ispvideo.c b/drivers/media/platform/omap3isp/ispvideo.c
index 2fe1c46..756c162 100644
--- a/drivers/media/platform/omap3isp/ispvideo.c
+++ b/drivers/media/platform/omap3isp/ispvideo.c
@@ -309,10 +309,11 @@ isp_video_check_format(struct isp_video *video, struct isp_video_fh *vfh)
 	    vfh->format.fmt.pix.height != format.fmt.pix.height ||
 	    vfh->format.fmt.pix.width != format.fmt.pix.width ||
 	    vfh->format.fmt.pix.bytesperline != format.fmt.pix.bytesperline ||
-	    vfh->format.fmt.pix.sizeimage != format.fmt.pix.sizeimage)
+	    vfh->format.fmt.pix.sizeimage != format.fmt.pix.sizeimage ||
+	    vfh->format.fmt.pix.field != format.fmt.pix.field)
 		return -EINVAL;
 
-	return ret;
+	return 0;
 }
 
 /* -----------------------------------------------------------------------------
-- 
1.8.5.5

