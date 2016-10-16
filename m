Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lf0-f67.google.com ([209.85.215.67]:35296 "EHLO
        mail-lf0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756602AbcJPPU0 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sun, 16 Oct 2016 11:20:26 -0400
From: Hector Roussille <hector.roussille@gmail.com>
To: laurent.pinchart@ideasonboard.com
Cc: mchehab@kernel.org, gregkh@linuxfoundation.org,
        linux-media@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org,
        Hector Roussille <hector.roussille@gmail.com>
Subject: [PATCH] Staging: media: omap4iss: fixed coding style issues
Date: Sun, 16 Oct 2016 17:18:56 +0200
Message-Id: <20161016151856.19209-1-hector.roussille@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Fixed coding style issues

Signed-off-by: Hector Roussille <hector.roussille@gmail.com>
---
 drivers/staging/media/omap4iss/iss_video.c | 11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/media/omap4iss/iss_video.c b/drivers/staging/media/omap4iss/iss_video.c
index c16927a..8f2d374 100644
--- a/drivers/staging/media/omap4iss/iss_video.c
+++ b/drivers/staging/media/omap4iss/iss_video.c
@@ -297,8 +297,10 @@ iss_video_check_format(struct iss_video *video, struct iss_video_fh *vfh)
  */
 
 static int iss_video_queue_setup(struct vb2_queue *vq,
-				 unsigned int *count, unsigned int *num_planes,
-				 unsigned int sizes[], struct device *alloc_devs[])
+				 unsigned int *count,
+				 unsigned int *num_planes,
+				 unsigned int sizes[],
+				 struct device *alloc_devs[])
 {
 	struct iss_video_fh *vfh = vb2_get_drv_priv(vq);
 	struct iss_video *video = vfh->video;
@@ -678,9 +680,10 @@ iss_video_get_selection(struct file *file, void *fh, struct v4l2_selection *sel)
 	if (subdev == NULL)
 		return -EINVAL;
 
-	/* Try the get selection operation first and fallback to get format if not
-	 * implemented.
+	/* Try the get selection operation first and fallback to
+	 * get format if not implemented.
 	 */
+
 	sdsel.pad = pad;
 	ret = v4l2_subdev_call(subdev, pad, get_selection, NULL, &sdsel);
 	if (!ret)
-- 
2.10.0

