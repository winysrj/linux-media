Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:58901 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932196AbcLLKhP (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 12 Dec 2016 05:37:15 -0500
From: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
To: jacopo@jmondi.org
Cc: linux-media@vger.kernel.org
Subject: [PATCH] v4l: vsp1: Add VIDIOC_EXPBUF support
Date: Mon, 12 Dec 2016 12:37:42 +0200
Message-Id: <1481539062-23179-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Use the vb2 ioctl handler directly.

Signed-off-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
---
 drivers/media/platform/vsp1/vsp1_video.c | 1 +
 1 file changed, 1 insertion(+)

Jacopo,

Does this fix your issue ?

diff --git a/drivers/media/platform/vsp1/vsp1_video.c b/drivers/media/platform/vsp1/vsp1_video.c
index fd3acf1a98a6..0113a55b19c9 100644
--- a/drivers/media/platform/vsp1/vsp1_video.c
+++ b/drivers/media/platform/vsp1/vsp1_video.c
@@ -1021,6 +1021,7 @@ static const struct v4l2_ioctl_ops vsp1_video_ioctl_ops = {
 	.vidioc_querybuf		= vb2_ioctl_querybuf,
 	.vidioc_qbuf			= vb2_ioctl_qbuf,
 	.vidioc_dqbuf			= vb2_ioctl_dqbuf,
+	.vidioc_expbuf			= vb2_ioctl_expbuf,
 	.vidioc_create_bufs		= vb2_ioctl_create_bufs,
 	.vidioc_prepare_buf		= vb2_ioctl_prepare_buf,
 	.vidioc_streamon		= vsp1_video_streamon,
-- 
Regards,

Laurent Pinchart

