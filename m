Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pa0-f67.google.com ([209.85.220.67]:36855 "EHLO
        mail-pa0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750946AbcJAVBF (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Sat, 1 Oct 2016 17:01:05 -0400
From: Harman Kalra <harman4linux@gmail.com>
To: laurent.pinchart@ideasonboard.com, mchehab@kernel.org
Cc: gregkh@linuxfoundation.org, linux-media@vger.kernel.org,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Harman Kalra <harman4linux@gmail.com>
Subject: [PATCH] [media] : Removing warnings caught by checkpatch.pl
Date: Sun,  2 Oct 2016 02:30:45 +0530
Message-Id: <1475355646-6378-1-git-send-email-harman4linux@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Removing warnings caught by checkpatch.pl

Signed-off-by: Harman Kalra <harman4linux@gmail.com>
---
 drivers/staging/media/omap4iss/iss_video.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/media/omap4iss/iss_video.c b/drivers/staging/media/omap4iss/iss_video.c
index c16927a..7cc1691 100644
--- a/drivers/staging/media/omap4iss/iss_video.c
+++ b/drivers/staging/media/omap4iss/iss_video.c
@@ -297,8 +297,8 @@ static void iss_video_pix_to_mbus(const struct v4l2_pix_format *pix,
  */

 static int iss_video_queue_setup(struct vb2_queue *vq,
-				 unsigned int *count, unsigned int *num_planes,
-				 unsigned int sizes[], struct device *alloc_devs[])
+			unsigned int *count, unsigned int *num_planes,
+			unsigned int sizes[], struct device *alloc_devs[])
 {
 	struct iss_video_fh *vfh = vb2_get_drv_priv(vq);
 	struct iss_video *video = vfh->video;
@@ -678,8 +678,8 @@ void omap4iss_video_cancel_stream(struct iss_video *video)
 	if (subdev == NULL)
 		return -EINVAL;

-	/* Try the get selection operation first and fallback to get format if not
-	 * implemented.
+	/* Try the get selection operation first and
+	 * fallback to get format if not implemented.
 	 */
 	sdsel.pad = pad;
 	ret = v4l2_subdev_call(subdev, pad, get_selection, NULL, &sdsel);
--
1.7.9.5

