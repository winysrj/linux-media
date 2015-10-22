Return-path: <linux-media-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:32620 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754669AbbJVJJW (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 22 Oct 2015 05:09:22 -0400
Date: Thu, 22 Oct 2015 12:09:05 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	linux-media@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [patch] [media] uvcvideo: small cleanup in uvc_video_clock_update()
Message-ID: <20151022090905.GB9202@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Smatch is not smart enough to see that "&stream->clock.lock" and
"&clock->lock" are the same thing so it complains about the locking
here.  Let's make it more consistent.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

diff --git a/drivers/media/usb/uvc/uvc_video.c b/drivers/media/usb/uvc/uvc_video.c
index 2b276ab..4abe3e9 100644
--- a/drivers/media/usb/uvc/uvc_video.c
+++ b/drivers/media/usb/uvc/uvc_video.c
@@ -709,7 +709,7 @@ void uvc_video_clock_update(struct uvc_streaming *stream,
 	vbuf->timestamp.tv_usec = ts.tv_nsec / NSEC_PER_USEC;
 
 done:
-	spin_unlock_irqrestore(&stream->clock.lock, flags);
+	spin_unlock_irqrestore(&clock->lock, flags);
 }
 
 /* ------------------------------------------------------------------------
