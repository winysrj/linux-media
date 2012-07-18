Return-path: <linux-media-owner@vger.kernel.org>
Received: from ams-iport-3.cisco.com ([144.254.224.146]:30729 "EHLO
	ams-iport-3.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751867Ab2GRNfY (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 18 Jul 2012 09:35:24 -0400
Received: from cobaltpc1.localnet (dhcp-10-54-92-107.cisco.com [10.54.92.107])
	by ams-core-3.cisco.com (8.14.5/8.14.5) with ESMTP id q6IDZNul016924
	for <linux-media@vger.kernel.org>; Wed, 18 Jul 2012 13:35:23 GMT
From: Hans Verkuil <hverkuil@xs4all.nl>
To: "linux-media" <linux-media@vger.kernel.org>
Subject: [PATCH] Fix VIDIOC_TRY_EXT_CTRLS regression
Date: Wed, 18 Jul 2012 15:34:59 +0200
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201207181534.59499.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi all,

This patch fixes an omission in the new v4l2_ioctls table: VIDIOC_TRY_EXT_CTRLS
must get the INFO_FL_CTRL flag, just like all the other control related ioctls.

Otherwise the ioctl core won't know it also has to check whether v4l2_fh->ctrl_handler
is non-zero before it can decide that this ioctl is not implemented.

Caught by v4l2-compliance while I was testing the mem2mem_testdev driver.

Regards,

	Hans

diff --git a/drivers/media/video/v4l2-ioctl.c b/drivers/media/video/v4l2-ioctl.c
index 70e0efb..17dff31 100644
--- a/drivers/media/video/v4l2-ioctl.c
+++ b/drivers/media/video/v4l2-ioctl.c
@@ -1900,7 +1900,7 @@ static struct v4l2_ioctl_info v4l2_ioctls[] = {
 	IOCTL_INFO_FNC(VIDIOC_LOG_STATUS, v4l_log_status, v4l_print_newline, 0),
 	IOCTL_INFO_FNC(VIDIOC_G_EXT_CTRLS, v4l_g_ext_ctrls, v4l_print_ext_controls, INFO_FL_CTRL),
 	IOCTL_INFO_FNC(VIDIOC_S_EXT_CTRLS, v4l_s_ext_ctrls, v4l_print_ext_controls, INFO_FL_PRIO | INFO_FL_CTRL),
-	IOCTL_INFO_FNC(VIDIOC_TRY_EXT_CTRLS, v4l_try_ext_ctrls, v4l_print_ext_controls, 0),
+	IOCTL_INFO_FNC(VIDIOC_TRY_EXT_CTRLS, v4l_try_ext_ctrls, v4l_print_ext_controls, INFO_FL_CTRL),
 	IOCTL_INFO_STD(VIDIOC_ENUM_FRAMESIZES, vidioc_enum_framesizes, v4l_print_frmsizeenum, INFO_FL_CLEAR(v4l2_frmsizeenum, pixel_format)),
 	IOCTL_INFO_STD(VIDIOC_ENUM_FRAMEINTERVALS, vidioc_enum_frameintervals, v4l_print_frmivalenum, INFO_FL_CLEAR(v4l2_frmivalenum, height)),
 	IOCTL_INFO_STD(VIDIOC_G_ENC_INDEX, vidioc_g_enc_index, v4l_print_enc_idx, 0),
