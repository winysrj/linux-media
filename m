Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:51390 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752113Ab3KDKEF (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 4 Nov 2013 05:04:05 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: Sergio Aguirre <sergio.a.aguirre@gmail.com>,
	Sakari Ailus <sakari.ailus@iki.fi>
Subject: [PATCH v2 19/18] v4l: omap4iss: Don't check for missing get_fmt op on remote subdev
Date: Mon,  4 Nov 2013 11:04:29 +0100
Message-Id: <1383559469-9886-1-git-send-email-laurent.pinchart@ideasonboard.com>
In-Reply-To: <1383523603-3907-1-git-send-email-laurent.pinchart@ideasonboard.com>
References: <1383523603-3907-1-git-send-email-laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The remote subdev of any video node in the OMAP4 ISS is an internal
subdev that is guaranteed to implement get_fmt. Don't check the return
value for -ENOIOCTLCMD, as this can't happen.

Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 drivers/staging/media/omap4iss/iss_video.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/staging/media/omap4iss/iss_video.c b/drivers/staging/media/omap4iss/iss_video.c
index a527330..0cb5820 100644
--- a/drivers/staging/media/omap4iss/iss_video.c
+++ b/drivers/staging/media/omap4iss/iss_video.c
@@ -248,8 +248,6 @@ __iss_video_get_format(struct iss_video *video, struct v4l2_format *format)
 	fmt.pad = pad;
 	fmt.which = V4L2_SUBDEV_FORMAT_ACTIVE;
 	ret = v4l2_subdev_call(subdev, pad, get_fmt, NULL, &fmt);
-	if (ret == -ENOIOCTLCMD)
-		ret = -EINVAL;
 
 	mutex_unlock(&video->mutex);
 
@@ -552,7 +550,7 @@ iss_video_try_format(struct file *file, void *fh, struct v4l2_format *format)
 	fmt.which = V4L2_SUBDEV_FORMAT_ACTIVE;
 	ret = v4l2_subdev_call(subdev, pad, get_fmt, NULL, &fmt);
 	if (ret)
-		return ret == -ENOIOCTLCMD ? -EINVAL : ret;
+		return ret;
 
 	iss_video_mbus_to_pix(video, &fmt.format, &format->fmt.pix);
 	return 0;
-- 
1.8.1.5

