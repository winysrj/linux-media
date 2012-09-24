Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout4.samsung.com ([203.254.224.34]:59010 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751181Ab2IXKEZ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 24 Sep 2012 06:04:25 -0400
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
To: linux-media@vger.kernel.org
Cc: t.stanislaws@samsung.com, hverkuil@xs4all.nl,
	kyungmin.park@samsung.com, sw0312.kim@samsung.com,
	linux-samsung-soc@vger.kernel.org,
	Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: [PATCH RFC] s5p-tv: Report only multi-plane capabilities in
 vidioc_querycap
Date: Mon, 24 Sep 2012 12:04:09 +0200
Message-id: <1348481049-19145-1-git-send-email-s.nawrocki@samsung.com>
In-reply-to: <201209211207.46679.hverkuil@xs4all.nl>
References: <201209211207.46679.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The mixer video node supports only multi-planar API so the driver
should not be setting V4L2_CAP_VIDEO_OUTPUT flags. Fix this and
also switch to device_caps. Additionally fix the VIDIOC_ENUM_FMT
ioctl handler which now works for V4L2_BUF_TYPE_CAPTURE, rather
than expected V4L2_BUF_TYPE_CAPTURE_MPLANE.

Cc: Tomasz Stanislawski <t.stanislaws@samsung.com>
Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/media/platform/s5p-tv/mixer_video.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/media/platform/s5p-tv/mixer_video.c b/drivers/media/platform/s5p-tv/mixer_video.c
index 8649de01..9876bd9 100644
--- a/drivers/media/platform/s5p-tv/mixer_video.c
+++ b/drivers/media/platform/s5p-tv/mixer_video.c
@@ -164,9 +164,8 @@ static int mxr_querycap(struct file *file, void *priv,
 	strlcpy(cap->driver, MXR_DRIVER_NAME, sizeof cap->driver);
 	strlcpy(cap->card, layer->vfd.name, sizeof cap->card);
 	sprintf(cap->bus_info, "%d", layer->idx);
-	cap->version = KERNEL_VERSION(0, 1, 0);
-	cap->capabilities = V4L2_CAP_STREAMING |
-		V4L2_CAP_VIDEO_OUTPUT | V4L2_CAP_VIDEO_OUTPUT_MPLANE;
+	cap->device_caps = V4L2_CAP_STREAMING | V4L2_CAP_VIDEO_OUTPUT_MPLANE;
+	cap->capabilities = cap->device_caps | V4L2_CAP_DEVICE_CAPS;

 	return 0;
 }
@@ -727,7 +726,7 @@ static int mxr_streamoff(struct file *file, void *priv, enum v4l2_buf_type i)
 static const struct v4l2_ioctl_ops mxr_ioctl_ops = {
 	.vidioc_querycap = mxr_querycap,
 	/* format handling */
-	.vidioc_enum_fmt_vid_out = mxr_enum_fmt,
+	.vidioc_enum_fmt_vid_out_mplane = mxr_enum_fmt,
 	.vidioc_s_fmt_vid_out_mplane = mxr_s_fmt,
 	.vidioc_g_fmt_vid_out_mplane = mxr_g_fmt,
 	/* buffer control */
--
1.7.11.3

