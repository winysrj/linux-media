Return-path: <linux-media-owner@vger.kernel.org>
Received: from ams-iport-1.cisco.com ([144.254.224.140]:62348 "EHLO
	ams-iport-1.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756835Ab2INK57 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 14 Sep 2012 06:57:59 -0400
Received: from cobaltpc1.cisco.com (dhcp-10-54-92-107.cisco.com [10.54.92.107])
	by ams-core-3.cisco.com (8.14.5/8.14.5) with ESMTP id q8EAvqBg013688
	for <linux-media@vger.kernel.org>; Fri, 14 Sep 2012 10:57:55 GMT
From: Hans Verkuil <hans.verkuil@cisco.com>
To: linux-media@vger.kernel.org
Subject: [RFCv3 API PATCH 11/31] v4l2-core: tvnorms may be 0 for a given input, handle that case.
Date: Fri, 14 Sep 2012 12:57:26 +0200
Message-Id: <1ee0dab3d7403c0de9a04cf66b4e1a3f09a44761.1347619766.git.hans.verkuil@cisco.com>
In-Reply-To: <1347620266-13767-1-git-send-email-hans.verkuil@cisco.com>
References: <1347620266-13767-1-git-send-email-hans.verkuil@cisco.com>
In-Reply-To: <7447a305817a5e6c63f089c2e1e948533f1d57ea.1347619765.git.hans.verkuil@cisco.com>
References: <7447a305817a5e6c63f089c2e1e948533f1d57ea.1347619765.git.hans.verkuil@cisco.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Currently the core code looks at tvnorms to see whether ENUMSTD
or G_PARM should be enabled. This is not a good check for drivers
that support the STD API on one input and the DV Timings API on another.

In that case tvnorms may be 0.

Instead check whether s_std is present (for ENUMSTD) or whether g_std or
current_norm is present for g_parm.

Also, in the enumstd core function return ENODATA if tvnorms is 0,
because in that case the current input does not support the STD API
and ENUMSTD should return ENODATA for that.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/v4l2-core/v4l2-dev.c   |    4 ++--
 drivers/media/v4l2-core/v4l2-ioctl.c |    5 +++++
 2 files changed, 7 insertions(+), 2 deletions(-)

diff --git a/drivers/media/v4l2-core/v4l2-dev.c b/drivers/media/v4l2-core/v4l2-dev.c
index 95f92ea..498049f 100644
--- a/drivers/media/v4l2-core/v4l2-dev.c
+++ b/drivers/media/v4l2-core/v4l2-dev.c
@@ -609,7 +609,7 @@ static void determine_valid_ioctls(struct video_device *vdev)
 	SET_VALID_IOCTL(ops, VIDIOC_S_FBUF, vidioc_s_fbuf);
 	SET_VALID_IOCTL(ops, VIDIOC_STREAMON, vidioc_streamon);
 	SET_VALID_IOCTL(ops, VIDIOC_STREAMOFF, vidioc_streamoff);
-	if (vdev->tvnorms)
+	if (ops->vidioc_s_std)
 		set_bit(_IOC_NR(VIDIOC_ENUMSTD), valid_ioctls);
 	if (ops->vidioc_g_std || vdev->current_norm)
 		set_bit(_IOC_NR(VIDIOC_G_STD), valid_ioctls);
@@ -663,7 +663,7 @@ static void determine_valid_ioctls(struct video_device *vdev)
 	SET_VALID_IOCTL(ops, VIDIOC_DECODER_CMD, vidioc_decoder_cmd);
 	SET_VALID_IOCTL(ops, VIDIOC_TRY_DECODER_CMD, vidioc_try_decoder_cmd);
 	if (ops->vidioc_g_parm || (vdev->vfl_type == VFL_TYPE_GRABBER &&
-					(ops->vidioc_g_std || vdev->tvnorms)))
+					(ops->vidioc_g_std || vdev->current_norm)))
 		set_bit(_IOC_NR(VIDIOC_G_PARM), valid_ioctls);
 	SET_VALID_IOCTL(ops, VIDIOC_S_PARM, vidioc_s_parm);
 	SET_VALID_IOCTL(ops, VIDIOC_G_TUNER, vidioc_g_tuner);
diff --git a/drivers/media/v4l2-core/v4l2-ioctl.c b/drivers/media/v4l2-core/v4l2-ioctl.c
index 449ca9c..4ee9158 100644
--- a/drivers/media/v4l2-core/v4l2-ioctl.c
+++ b/drivers/media/v4l2-core/v4l2-ioctl.c
@@ -1302,6 +1302,11 @@ static int v4l_enumstd(const struct v4l2_ioctl_ops *ops,
 	unsigned int index = p->index, i, j = 0;
 	const char *descr = "";
 
+	/* Return -ENODATA if the tvnorms for the current input
+	   or output is 0, meaning that it doesn't support this API. */
+	if (id == 0)
+		return -ENODATA;
+
 	/* Return norm array in a canonical way */
 	for (i = 0; i <= index && id; i++) {
 		/* last std value in the standards array is 0, so this
-- 
1.7.10.4

