Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:51396 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751134Ab3KDKEQ (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 4 Nov 2013 05:04:16 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: Sergio Aguirre <sergio.a.aguirre@gmail.com>,
	Sakari Ailus <sakari.ailus@iki.fi>
Subject: [PATCH v2 21/18] v4l: omap4iss: Move code out of mutex-protected section
Date: Mon,  4 Nov 2013 11:04:41 +0100
Message-Id: <1383559481-9960-1-git-send-email-laurent.pinchart@ideasonboard.com>
In-Reply-To: <1383523603-3907-1-git-send-email-laurent.pinchart@ideasonboard.com>
References: <1383523603-3907-1-git-send-email-laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The pad::get_fmt call must be protected by a mutex, but preparing its
arguments doesn't need to be. Move the non-critical code out of the
mutex-protected section.

Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 drivers/staging/media/omap4iss/iss_video.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/media/omap4iss/iss_video.c b/drivers/staging/media/omap4iss/iss_video.c
index 63419b3..6800623 100644
--- a/drivers/staging/media/omap4iss/iss_video.c
+++ b/drivers/staging/media/omap4iss/iss_video.c
@@ -243,12 +243,11 @@ __iss_video_get_format(struct iss_video *video, struct v4l2_format *format)
 	if (subdev == NULL)
 		return -EINVAL;
 
-	mutex_lock(&video->mutex);
-
 	fmt.pad = pad;
 	fmt.which = V4L2_SUBDEV_FORMAT_ACTIVE;
-	ret = v4l2_subdev_call(subdev, pad, get_fmt, NULL, &fmt);
 
+	mutex_lock(&video->mutex);
+	ret = v4l2_subdev_call(subdev, pad, get_fmt, NULL, &fmt);
 	mutex_unlock(&video->mutex);
 
 	if (ret)
-- 
1.8.1.5

