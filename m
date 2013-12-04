Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:44099 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755881Ab3LDA4j (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 3 Dec 2013 19:56:39 -0500
Received: from avalon.ideasonboard.com (unknown [91.177.177.98])
	by perceval.ideasonboard.com (Postfix) with ESMTPSA id 03A1D366A7
	for <linux-media@vger.kernel.org>; Wed,  4 Dec 2013 01:55:40 +0100 (CET)
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Subject: [PATCH 19/25] v4l: omap4iss: Add enum_fmt_vid_cap ioctl support
Date: Wed,  4 Dec 2013 01:56:19 +0100
Message-Id: <1386118585-12449-20-git-send-email-laurent.pinchart@ideasonboard.com>
In-Reply-To: <1386118585-12449-1-git-send-email-laurent.pinchart@ideasonboard.com>
References: <1386118585-12449-1-git-send-email-laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

List the pixel formats compatible with the active format currently
configured on the connected pad.

Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 drivers/staging/media/omap4iss/iss_video.c | 36 ++++++++++++++++++++++++++++++
 1 file changed, 36 insertions(+)

diff --git a/drivers/staging/media/omap4iss/iss_video.c b/drivers/staging/media/omap4iss/iss_video.c
index 5dbd774..68eab6e 100644
--- a/drivers/staging/media/omap4iss/iss_video.c
+++ b/drivers/staging/media/omap4iss/iss_video.c
@@ -496,6 +496,41 @@ iss_video_querycap(struct file *file, void *fh, struct v4l2_capability *cap)
 }
 
 static int
+iss_video_enum_format(struct file *file, void *fh, struct v4l2_fmtdesc *f)
+{
+	struct iss_video *video = video_drvdata(file);
+	struct v4l2_mbus_framefmt format;
+	unsigned int index = f->index;
+	unsigned int i;
+	int ret;
+
+	if (f->type != video->type)
+		return -EINVAL;
+
+	ret = __iss_video_get_format(video, &format);
+	if (ret < 0)
+		return ret;
+
+	for (i = 0; i < ARRAY_SIZE(formats); ++i) {
+		const struct iss_format_info *info = &formats[i];
+
+		if (format.code != info->code)
+			continue;
+
+		if (index == 0) {
+			f->pixelformat = info->pixelformat;
+			strlcpy(f->description, info->description,
+				sizeof(f->description));
+			return 0;
+		}
+
+		index--;
+	}
+
+	return -EINVAL;
+}
+
+static int
 iss_video_get_format(struct file *file, void *fh, struct v4l2_format *format)
 {
 	struct iss_video_fh *vfh = to_iss_video_fh(fh);
@@ -918,6 +953,7 @@ iss_video_s_input(struct file *file, void *fh, unsigned int input)
 
 static const struct v4l2_ioctl_ops iss_video_ioctl_ops = {
 	.vidioc_querycap		= iss_video_querycap,
+	.vidioc_enum_fmt_vid_cap        = iss_video_enum_format,
 	.vidioc_g_fmt_vid_cap		= iss_video_get_format,
 	.vidioc_s_fmt_vid_cap		= iss_video_set_format,
 	.vidioc_try_fmt_vid_cap		= iss_video_try_format,
-- 
1.8.3.2

