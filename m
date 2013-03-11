Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr8.xs4all.nl ([194.109.24.28]:2186 "EHLO
	smtp-vbr8.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754156Ab3CKLrM (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 11 Mar 2013 07:47:12 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Volokh Konstantin <volokh84@gmail.com>,
	Pete Eberlein <pete@sensoray.com>,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [REVIEW PATCH 36/42] go7007: remove cropping functions
Date: Mon, 11 Mar 2013 12:46:14 +0100
Message-Id: <7185b0cabd7c82d0ef47c3a5dc6b0ece179e285f.1363000605.git.hans.verkuil@cisco.com>
In-Reply-To: <1363002380-19825-1-git-send-email-hverkuil@xs4all.nl>
References: <1363002380-19825-1-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <38bc3cc42d0c021432afd29c2c1e22cf380b06e0.1363000605.git.hans.verkuil@cisco.com>
References: <38bc3cc42d0c021432afd29c2c1e22cf380b06e0.1363000605.git.hans.verkuil@cisco.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Remove these dummy cropping functions: cropping was never implemented.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/staging/media/go7007/go7007-v4l2.c |   92 ----------------------------
 1 file changed, 92 deletions(-)

diff --git a/drivers/staging/media/go7007/go7007-v4l2.c b/drivers/staging/media/go7007/go7007-v4l2.c
index 2e5bc02..24d93b4 100644
--- a/drivers/staging/media/go7007/go7007-v4l2.c
+++ b/drivers/staging/media/go7007/go7007-v4l2.c
@@ -842,95 +842,6 @@ static int vidioc_log_status(struct file *file, void *priv)
 	return call_all(&go->v4l2_dev, core, log_status);
 }
 
-static int vidioc_cropcap(struct file *file, void *priv,
-					struct v4l2_cropcap *cropcap)
-{
-	struct go7007 *go = video_drvdata(file);
-
-	if (cropcap->type != V4L2_BUF_TYPE_VIDEO_CAPTURE)
-		return -EINVAL;
-
-	/* These specify the raw input of the sensor */
-	switch (go->standard) {
-	case GO7007_STD_NTSC:
-		cropcap->bounds.top = 0;
-		cropcap->bounds.left = 0;
-		cropcap->bounds.width = 720;
-		cropcap->bounds.height = 480;
-		cropcap->defrect.top = 0;
-		cropcap->defrect.left = 0;
-		cropcap->defrect.width = 720;
-		cropcap->defrect.height = 480;
-		break;
-	case GO7007_STD_PAL:
-		cropcap->bounds.top = 0;
-		cropcap->bounds.left = 0;
-		cropcap->bounds.width = 720;
-		cropcap->bounds.height = 576;
-		cropcap->defrect.top = 0;
-		cropcap->defrect.left = 0;
-		cropcap->defrect.width = 720;
-		cropcap->defrect.height = 576;
-		break;
-	case GO7007_STD_OTHER:
-		cropcap->bounds.top = 0;
-		cropcap->bounds.left = 0;
-		cropcap->bounds.width = go->board_info->sensor_width;
-		cropcap->bounds.height = go->board_info->sensor_height;
-		cropcap->defrect.top = 0;
-		cropcap->defrect.left = 0;
-		cropcap->defrect.width = go->board_info->sensor_width;
-		cropcap->defrect.height = go->board_info->sensor_height;
-		break;
-	}
-
-	return 0;
-}
-
-static int vidioc_g_crop(struct file *file, void *priv, struct v4l2_crop *crop)
-{
-	struct go7007 *go = video_drvdata(file);
-
-	if (crop->type != V4L2_BUF_TYPE_VIDEO_CAPTURE)
-		return -EINVAL;
-
-	crop->type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
-
-	/* These specify the raw input of the sensor */
-	switch (go->standard) {
-	case GO7007_STD_NTSC:
-		crop->c.top = 0;
-		crop->c.left = 0;
-		crop->c.width = 720;
-		crop->c.height = 480;
-		break;
-	case GO7007_STD_PAL:
-		crop->c.top = 0;
-		crop->c.left = 0;
-		crop->c.width = 720;
-		crop->c.height = 576;
-		break;
-	case GO7007_STD_OTHER:
-		crop->c.top = 0;
-		crop->c.left = 0;
-		crop->c.width = go->board_info->sensor_width;
-		crop->c.height = go->board_info->sensor_height;
-		break;
-	}
-
-	return 0;
-}
-
-/* FIXME: vidioc_s_crop is not really implemented!!!
- */
-static int vidioc_s_crop(struct file *file, void *priv, const struct v4l2_crop *crop)
-{
-	if (crop->type != V4L2_BUF_TYPE_VIDEO_CAPTURE)
-		return -EINVAL;
-
-	return 0;
-}
-
 /* FIXME:
 	Those ioctls are private, and not needed, since several standard
 	extended controls already provide streaming control.
@@ -1006,9 +917,6 @@ static const struct v4l2_ioctl_ops video_ioctl_ops = {
 	.vidioc_s_parm            = vidioc_s_parm,
 	.vidioc_enum_framesizes   = vidioc_enum_framesizes,
 	.vidioc_enum_frameintervals = vidioc_enum_frameintervals,
-	.vidioc_cropcap           = vidioc_cropcap,
-	.vidioc_g_crop            = vidioc_g_crop,
-	.vidioc_s_crop            = vidioc_s_crop,
 	.vidioc_log_status        = vidioc_log_status,
 	.vidioc_subscribe_event   = v4l2_ctrl_subscribe_event,
 	.vidioc_unsubscribe_event = v4l2_event_unsubscribe,
-- 
1.7.10.4

