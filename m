Return-path: <mchehab@pedra>
Received: from dakia2.marvell.com ([65.219.4.35]:35668 "EHLO
	dakia2.marvell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755746Ab1AGDFT (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 6 Jan 2011 22:05:19 -0500
From: Qing Xu <qingx@marvell.com>
To: g.liakhovetski@gmx.de
Cc: linux-media@vger.kernel.org, Qing Xu <qingx@marvell.com>,
	Kassey Lee <ygli@marvell.com>
Subject: [PATCH] [media] v4l: soc-camera: add enum-frame-size ioctl
Date: Fri,  7 Jan 2011 10:49:55 +0800
Message-Id: <1294368595-2518-1-git-send-email-qingx@marvell.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

pass VIDIOC_ENUM_FRAMESIZES down to sub device drivers. So far no
special handling in soc-camera core.

Signed-off-by: Kassey Lee <ygli@marvell.com>
Signed-off-by: Qing Xu <qingx@marvell.com>
---
 drivers/media/video/soc_camera.c |   11 +++++++++++
 1 files changed, 11 insertions(+), 0 deletions(-)

diff --git a/drivers/media/video/soc_camera.c b/drivers/media/video/soc_camera.c
index 052bd6d..11715fb 100644
--- a/drivers/media/video/soc_camera.c
+++ b/drivers/media/video/soc_camera.c
@@ -145,6 +145,16 @@ static int soc_camera_s_std(struct file *file, void *priv, v4l2_std_id *a)
 	return v4l2_subdev_call(sd, core, s_std, *a);
 }
 
+static int soc_camera_enum_framesizes(struct file *file, void *fh,
+					 struct v4l2_frmsizeenum *fsize)
+{
+	struct soc_camera_device *icd = file->private_data;
+	struct v4l2_subdev *sd = soc_camera_to_subdev(icd);
+
+	return v4l2_subdev_call(sd, video, enum_framesizes, fsize);
+}
+
+
 static int soc_camera_reqbufs(struct file *file, void *priv,
 			      struct v4l2_requestbuffers *p)
 {
@@ -1302,6 +1312,7 @@ static const struct v4l2_ioctl_ops soc_camera_ioctl_ops = {
 	.vidioc_g_input		 = soc_camera_g_input,
 	.vidioc_s_input		 = soc_camera_s_input,
 	.vidioc_s_std		 = soc_camera_s_std,
+	.vidioc_enum_framesizes  = soc_camera_enum_framesizes,
 	.vidioc_reqbufs		 = soc_camera_reqbufs,
 	.vidioc_try_fmt_vid_cap  = soc_camera_try_fmt_vid_cap,
 	.vidioc_querybuf	 = soc_camera_querybuf,
-- 
1.6.3.3

