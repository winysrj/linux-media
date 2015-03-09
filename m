Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud3.xs4all.net ([194.109.24.22]:59117 "EHLO
	lb1-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753760AbbCIVWz (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 9 Mar 2015 17:22:55 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: corbet@lwn.net, Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCH 03/18] marvell-ccic: webcam drivers shouldn't support g/s_std
Date: Mon,  9 Mar 2015 22:22:08 +0100
Message-Id: <1425936143-5658-4-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1425936143-5658-1-git-send-email-hverkuil@xs4all.nl>
References: <1425936143-5658-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

TV standards make no sense for webcam drivers, so drop these dummy
functions. This stops v4l2-compliance from complaining about this.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/platform/marvell-ccic/mcam-core.c | 15 ---------------
 1 file changed, 15 deletions(-)

diff --git a/drivers/media/platform/marvell-ccic/mcam-core.c b/drivers/media/platform/marvell-ccic/mcam-core.c
index e83ca1f..76357cf 100644
--- a/drivers/media/platform/marvell-ccic/mcam-core.c
+++ b/drivers/media/platform/marvell-ccic/mcam-core.c
@@ -1508,7 +1508,6 @@ static int mcam_vidioc_enum_input(struct file *filp, void *priv,
 		return -EINVAL;
 
 	input->type = V4L2_INPUT_TYPE_CAMERA;
-	input->std = V4L2_STD_ALL; /* Not sure what should go here */
 	strcpy(input->name, "Camera");
 	return 0;
 }
@@ -1526,18 +1525,6 @@ static int mcam_vidioc_s_input(struct file *filp, void *priv, unsigned int i)
 	return 0;
 }
 
-/* from vivi.c */
-static int mcam_vidioc_s_std(struct file *filp, void *priv, v4l2_std_id a)
-{
-	return 0;
-}
-
-static int mcam_vidioc_g_std(struct file *filp, void *priv, v4l2_std_id *a)
-{
-	*a = V4L2_STD_NTSC_M;
-	return 0;
-}
-
 /*
  * G/S_PARM.  Most of this is done by the sensor, but we are
  * the level which controls the number of read buffers.
@@ -1666,8 +1653,6 @@ static const struct v4l2_ioctl_ops mcam_v4l_ioctl_ops = {
 	.vidioc_enum_input	= mcam_vidioc_enum_input,
 	.vidioc_g_input		= mcam_vidioc_g_input,
 	.vidioc_s_input		= mcam_vidioc_s_input,
-	.vidioc_s_std		= mcam_vidioc_s_std,
-	.vidioc_g_std		= mcam_vidioc_g_std,
 	.vidioc_reqbufs		= mcam_vidioc_reqbufs,
 	.vidioc_querybuf	= mcam_vidioc_querybuf,
 	.vidioc_qbuf		= mcam_vidioc_qbuf,
-- 
2.1.4

