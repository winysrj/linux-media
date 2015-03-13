Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud2.xs4all.net ([194.109.24.25]:46522 "EHLO
	lb2-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S964845AbbCMQ0E (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 13 Mar 2015 12:26:04 -0400
Received: from [127.0.0.1] (localhost [127.0.0.1])
	by tschai.lan (Postfix) with ESMTPSA id 8E7432A002F
	for <linux-media@vger.kernel.org>; Fri, 13 Mar 2015 17:25:53 +0100 (CET)
Message-ID: <55030F91.9080304@xs4all.nl>
Date: Fri, 13 Mar 2015 17:25:53 +0100
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH] v4l2-dev: disable selection ioctls for non-video devices
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The selection/cropping ioctls are only valid for video nodes, not for vbi.

Found by v4l2-compliance when run on a VBI device node.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>

diff --git a/drivers/media/v4l2-core/v4l2-dev.c b/drivers/media/v4l2-core/v4l2-dev.c
index e2b8b3e..71a1b93 100644
--- a/drivers/media/v4l2-core/v4l2-dev.c
+++ b/drivers/media/v4l2-core/v4l2-dev.c
@@ -611,6 +611,14 @@ static void determine_valid_ioctls(struct video_device *vdev)
 		SET_VALID_IOCTL(ops, VIDIOC_TRY_DECODER_CMD, vidioc_try_decoder_cmd);
 		SET_VALID_IOCTL(ops, VIDIOC_ENUM_FRAMESIZES, vidioc_enum_framesizes);
 		SET_VALID_IOCTL(ops, VIDIOC_ENUM_FRAMEINTERVALS, vidioc_enum_frameintervals);
+		if (ops->vidioc_g_crop || ops->vidioc_g_selection)
+			set_bit(_IOC_NR(VIDIOC_G_CROP), valid_ioctls);
+		if (ops->vidioc_s_crop || ops->vidioc_s_selection)
+			set_bit(_IOC_NR(VIDIOC_S_CROP), valid_ioctls);
+		SET_VALID_IOCTL(ops, VIDIOC_G_SELECTION, vidioc_g_selection);
+		SET_VALID_IOCTL(ops, VIDIOC_S_SELECTION, vidioc_s_selection);
+		if (ops->vidioc_cropcap || ops->vidioc_g_selection)
+			set_bit(_IOC_NR(VIDIOC_CROPCAP), valid_ioctls);
 	} else if (is_vbi) {
 		/* vbi specific ioctls */
 		if ((is_rx && (ops->vidioc_g_fmt_vbi_cap ||
@@ -679,14 +687,6 @@ static void determine_valid_ioctls(struct video_device *vdev)
 			SET_VALID_IOCTL(ops, VIDIOC_G_AUDOUT, vidioc_g_audout);
 			SET_VALID_IOCTL(ops, VIDIOC_S_AUDOUT, vidioc_s_audout);
 		}
-		if (ops->vidioc_g_crop || ops->vidioc_g_selection)
-			set_bit(_IOC_NR(VIDIOC_G_CROP), valid_ioctls);
-		if (ops->vidioc_s_crop || ops->vidioc_s_selection)
-			set_bit(_IOC_NR(VIDIOC_S_CROP), valid_ioctls);
-		SET_VALID_IOCTL(ops, VIDIOC_G_SELECTION, vidioc_g_selection);
-		SET_VALID_IOCTL(ops, VIDIOC_S_SELECTION, vidioc_s_selection);
-		if (ops->vidioc_cropcap || ops->vidioc_g_selection)
-			set_bit(_IOC_NR(VIDIOC_CROPCAP), valid_ioctls);
 		if (ops->vidioc_g_parm || (vdev->vfl_type == VFL_TYPE_GRABBER &&
 					ops->vidioc_g_std))
 			set_bit(_IOC_NR(VIDIOC_G_PARM), valid_ioctls);
