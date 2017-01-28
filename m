Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f65.google.com ([74.125.82.65]:32933 "EHLO
        mail-wm0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751401AbdA1SKQ (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 28 Jan 2017 13:10:16 -0500
From: Avraham Shukron <avraham.shukron@gmail.com>
To: laurent.pinchart@ideasonboard.com, mchehab@kernel.org,
        gregkh@linuxfoundation.org
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] Staging: omap4iss: fix coding style issues
Date: Sat, 28 Jan 2017 20:00:08 +0200
Message-Id: <1485626408-9768-1-git-send-email-avraham.shukron@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is a patch that fixes checkpatch.pl issues in omap4iss/iss_video.c
Specifically, it fixes "line over 80 characters" issues

Signed-off-by: Avraham Shukron <avraham.shukron@gmail.com>

---
 drivers/staging/media/omap4iss/iss_video.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/media/omap4iss/iss_video.c b/drivers/staging/media/omap4iss/iss_video.c
index c16927a..cdab053 100644
--- a/drivers/staging/media/omap4iss/iss_video.c
+++ b/drivers/staging/media/omap4iss/iss_video.c
@@ -298,7 +298,8 @@ iss_video_check_format(struct iss_video *video, struct iss_video_fh *vfh)
 
 static int iss_video_queue_setup(struct vb2_queue *vq,
 				 unsigned int *count, unsigned int *num_planes,
-				 unsigned int sizes[], struct device *alloc_devs[])
+				 unsigned int sizes[],
+				 struct device *alloc_devs[])
 {
 	struct iss_video_fh *vfh = vb2_get_drv_priv(vq);
 	struct iss_video *video = vfh->video;
@@ -678,8 +679,8 @@ iss_video_get_selection(struct file *file, void *fh, struct v4l2_selection *sel)
 	if (subdev == NULL)
 		return -EINVAL;
 
-	/* Try the get selection operation first and fallback to get format if not
-	 * implemented.
+	/* Try the get selection operation first and fallback to get format if
+	 * not implemented.
 	 */
 	sdsel.pad = pad;
 	ret = v4l2_subdev_call(subdev, pad, get_selection, NULL, &sdsel);
-- 
2.7.4

