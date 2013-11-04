Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:51394 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752113Ab3KDKEK (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 4 Nov 2013 05:04:10 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: Sergio Aguirre <sergio.a.aguirre@gmail.com>,
	Sakari Ailus <sakari.ailus@iki.fi>
Subject: [PATCH v2 20/18] v4l: omap4iss: Translate -ENOIOCTLCMD to -ENOTTY
Date: Mon,  4 Nov 2013 11:04:35 +0100
Message-Id: <1383559475-9923-1-git-send-email-laurent.pinchart@ideasonboard.com>
In-Reply-To: <1383523603-3907-1-git-send-email-laurent.pinchart@ideasonboard.com>
References: <1383523603-3907-1-git-send-email-laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Translating -ENOIOCTLCMD to -EINVAL is invalid, the correct ioctl return
value is -ENOTTY.

Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 drivers/staging/media/omap4iss/iss_video.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/media/omap4iss/iss_video.c b/drivers/staging/media/omap4iss/iss_video.c
index 0cb5820..63419b3 100644
--- a/drivers/staging/media/omap4iss/iss_video.c
+++ b/drivers/staging/media/omap4iss/iss_video.c
@@ -571,7 +571,7 @@ iss_video_cropcap(struct file *file, void *fh, struct v4l2_cropcap *cropcap)
 	ret = v4l2_subdev_call(subdev, video, cropcap, cropcap);
 	mutex_unlock(&video->mutex);
 
-	return ret == -ENOIOCTLCMD ? -EINVAL : ret;
+	return ret == -ENOIOCTLCMD ? -ENOTTY : ret;
 }
 
 static int
@@ -598,7 +598,7 @@ iss_video_get_crop(struct file *file, void *fh, struct v4l2_crop *crop)
 	format.which = V4L2_SUBDEV_FORMAT_ACTIVE;
 	ret = v4l2_subdev_call(subdev, pad, get_fmt, NULL, &format);
 	if (ret < 0)
-		return ret == -ENOIOCTLCMD ? -EINVAL : ret;
+		return ret == -ENOIOCTLCMD ? -ENOTTY : ret;
 
 	crop->c.left = 0;
 	crop->c.top = 0;
@@ -623,7 +623,7 @@ iss_video_set_crop(struct file *file, void *fh, const struct v4l2_crop *crop)
 	ret = v4l2_subdev_call(subdev, video, s_crop, crop);
 	mutex_unlock(&video->mutex);
 
-	return ret == -ENOIOCTLCMD ? -EINVAL : ret;
+	return ret == -ENOIOCTLCMD ? -ENOTTY : ret;
 }
 
 static int
-- 
1.8.1.5

