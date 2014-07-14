Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr9.xs4all.nl ([194.109.24.29]:3454 "EHLO
	smtp-vbr9.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755284AbaGNM7l (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 14 Jul 2014 08:59:41 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCH 06/12] v4l2-ioctl: clear reserved field of G/S_SELECTION.
Date: Mon, 14 Jul 2014 14:59:06 +0200
Message-Id: <1405342752-46998-7-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1405342752-46998-1-git-send-email-hverkuil@xs4all.nl>
References: <1405342752-46998-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/v4l2-core/v4l2-ioctl.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/media/v4l2-core/v4l2-ioctl.c b/drivers/media/v4l2-core/v4l2-ioctl.c
index 0e90349..ede9b03 100644
--- a/drivers/media/v4l2-core/v4l2-ioctl.c
+++ b/drivers/media/v4l2-core/v4l2-ioctl.c
@@ -2112,8 +2112,8 @@ static struct v4l2_ioctl_info v4l2_ioctls[] = {
 	IOCTL_INFO_FNC(VIDIOC_CROPCAP, v4l_cropcap, v4l_print_cropcap, INFO_FL_CLEAR(v4l2_cropcap, type)),
 	IOCTL_INFO_FNC(VIDIOC_G_CROP, v4l_g_crop, v4l_print_crop, INFO_FL_CLEAR(v4l2_crop, type)),
 	IOCTL_INFO_FNC(VIDIOC_S_CROP, v4l_s_crop, v4l_print_crop, INFO_FL_PRIO),
-	IOCTL_INFO_STD(VIDIOC_G_SELECTION, vidioc_g_selection, v4l_print_selection, 0),
-	IOCTL_INFO_STD(VIDIOC_S_SELECTION, vidioc_s_selection, v4l_print_selection, INFO_FL_PRIO),
+	IOCTL_INFO_STD(VIDIOC_G_SELECTION, vidioc_g_selection, v4l_print_selection, INFO_FL_CLEAR(v4l2_selection, r)),
+	IOCTL_INFO_STD(VIDIOC_S_SELECTION, vidioc_s_selection, v4l_print_selection, INFO_FL_PRIO | INFO_FL_CLEAR(v4l2_selection, r)),
 	IOCTL_INFO_STD(VIDIOC_G_JPEGCOMP, vidioc_g_jpegcomp, v4l_print_jpegcompression, 0),
 	IOCTL_INFO_STD(VIDIOC_S_JPEGCOMP, vidioc_s_jpegcomp, v4l_print_jpegcompression, INFO_FL_PRIO),
 	IOCTL_INFO_FNC(VIDIOC_QUERYSTD, v4l_querystd, v4l_print_std, 0),
-- 
2.0.1

