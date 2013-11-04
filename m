Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:51400 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751134Ab3KDKE0 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 4 Nov 2013 05:04:26 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: Sergio Aguirre <sergio.a.aguirre@gmail.com>,
	Sakari Ailus <sakari.ailus@iki.fi>
Subject: [PATCH v2 22/18] v4l: omap4iss: Implement VIDIOC_S_INPUT
Date: Mon,  4 Nov 2013 11:04:46 +0100
Message-Id: <1383559486-9997-1-git-send-email-laurent.pinchart@ideasonboard.com>
In-Reply-To: <1383523603-3907-1-git-send-email-laurent.pinchart@ideasonboard.com>
References: <1383523603-3907-1-git-send-email-laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The ioctl is (at least currently) mandatory.

Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 drivers/staging/media/omap4iss/iss_video.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/staging/media/omap4iss/iss_video.c b/drivers/staging/media/omap4iss/iss_video.c
index 6800623..766491e 100644
--- a/drivers/staging/media/omap4iss/iss_video.c
+++ b/drivers/staging/media/omap4iss/iss_video.c
@@ -902,6 +902,12 @@ iss_video_g_input(struct file *file, void *fh, unsigned int *input)
 	return 0;
 }
 
+static int
+iss_video_s_input(struct file *file, void *fh, unsigned int input)
+{
+	return input == 0 ? 0 : -EINVAL;
+}
+
 static const struct v4l2_ioctl_ops iss_video_ioctl_ops = {
 	.vidioc_querycap		= iss_video_querycap,
 	.vidioc_g_fmt_vid_cap		= iss_video_get_format,
@@ -923,6 +929,7 @@ static const struct v4l2_ioctl_ops iss_video_ioctl_ops = {
 	.vidioc_streamoff		= iss_video_streamoff,
 	.vidioc_enum_input		= iss_video_enum_input,
 	.vidioc_g_input			= iss_video_g_input,
+	.vidioc_s_input			= iss_video_s_input,
 };
 
 /* -----------------------------------------------------------------------------
-- 
1.8.1.5

