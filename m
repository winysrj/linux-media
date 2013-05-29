Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr14.xs4all.nl ([194.109.24.34]:4934 "EHLO
	smtp-vbr14.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965694Ab3E2LBI (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 29 May 2013 07:01:08 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>,
	Prabhakar Lad <prabhakar.csengg@gmail.com>
Subject: [PATCHv1 28/38] vpbe_display: drop g/s_register ioctls.
Date: Wed, 29 May 2013 13:00:01 +0200
Message-Id: <1369825211-29770-29-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1369825211-29770-1-git-send-email-hverkuil@xs4all.nl>
References: <1369825211-29770-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

These are no longer needed: register access to subdevices no longer needs
the bridge driver to forward them.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
Cc: Prabhakar Lad <prabhakar.csengg@gmail.com>
---
 drivers/media/platform/davinci/vpbe_display.c |   29 -------------------------
 1 file changed, 29 deletions(-)

diff --git a/drivers/media/platform/davinci/vpbe_display.c b/drivers/media/platform/davinci/vpbe_display.c
index 1c4ba89..48cb0da 100644
--- a/drivers/media/platform/davinci/vpbe_display.c
+++ b/drivers/media/platform/davinci/vpbe_display.c
@@ -1578,31 +1578,6 @@ static int vpbe_display_release(struct file *file)
 	return 0;
 }
 
-#ifdef CONFIG_VIDEO_ADV_DEBUG
-static int vpbe_display_g_register(struct file *file, void *priv,
-			struct v4l2_dbg_register *reg)
-{
-	struct v4l2_dbg_match *match = &reg->match;
-	struct vpbe_fh *fh = file->private_data;
-	struct vpbe_device *vpbe_dev = fh->disp_dev->vpbe_dev;
-
-	if (match->type >= 2) {
-		v4l2_subdev_call(vpbe_dev->venc,
-				 core,
-				 g_register,
-				 reg);
-	}
-
-	return 0;
-}
-
-static int vpbe_display_s_register(struct file *file, void *priv,
-			const struct v4l2_dbg_register *reg)
-{
-	return 0;
-}
-#endif
-
 /* vpbe capture ioctl operations */
 static const struct v4l2_ioctl_ops vpbe_ioctl_ops = {
 	.vidioc_querycap	 = vpbe_display_querycap,
@@ -1629,10 +1604,6 @@ static const struct v4l2_ioctl_ops vpbe_ioctl_ops = {
 	.vidioc_s_dv_timings	 = vpbe_display_s_dv_timings,
 	.vidioc_g_dv_timings	 = vpbe_display_g_dv_timings,
 	.vidioc_enum_dv_timings	 = vpbe_display_enum_dv_timings,
-#ifdef CONFIG_VIDEO_ADV_DEBUG
-	.vidioc_g_register	 = vpbe_display_g_register,
-	.vidioc_s_register	 = vpbe_display_s_register,
-#endif
 };
 
 static struct v4l2_file_operations vpbe_fops = {
-- 
1.7.10.4

