Return-path: <mchehab@pedra>
Received: from mail2.matrix-vision.com ([85.214.244.251]:38393 "EHLO
	mail2.matrix-vision.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755923Ab1CVM4D (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 22 Mar 2011 08:56:03 -0400
Message-ID: <4D889C61.905@matrix-vision.de>
Date: Tue, 22 Mar 2011 13:56:01 +0100
From: Michael Jones <michael.jones@matrix-vision.de>
MIME-Version: 1.0
To: Linux Media Mailing List <linux-media@vger.kernel.org>
CC: =?ISO-8859-1?Q?Lo=EFc_Akue?= <akue.loic@gmail.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Subject: [PATCH] omap3isp: implement ENUM_FMT
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

>From dccbd4a0a717ee72a3271075b1e3456a9c67ca0e Mon Sep 17 00:00:00 2001
From: Michael Jones <michael.jones@matrix-vision.de>
Date: Tue, 22 Mar 2011 11:47:22 +0100
Subject: [PATCH] omap3isp: implement ENUM_FMT

Whatever format is currently being delivered will be declared as the only
possible format

Signed-off-by: Michael Jones <michael.jones@matrix-vision.de>
---

Some V4L2 apps require ENUM_FMT, which is a mandatory ioctl for V4L2.
This patch doesn't enumerate all of the formats which could possibly be
set (as is intended by ENUM_FMT), but at least it reports the one that
is currently set.

This patch applies to Laurent's 'media-2.6.38-0001-omap3isp' branch.

 drivers/media/video/omap3isp/ispvideo.c |   23 +++++++++++++++++++++++
 1 files changed, 23 insertions(+), 0 deletions(-)

diff --git a/drivers/media/video/omap3isp/ispvideo.c b/drivers/media/video/omap3isp/ispvideo.c
index a0bb5db..8e25f47 100644
--- a/drivers/media/video/omap3isp/ispvideo.c
+++ b/drivers/media/video/omap3isp/ispvideo.c
@@ -642,6 +642,28 @@ isp_video_get_format(struct file *file, void *fh, struct v4l2_format *format)
 }
 
 static int
+isp_video_enum_format(struct file *file, void *fh, struct v4l2_fmtdesc *fmtdesc)
+{
+	struct isp_video_fh *vfh = to_isp_video_fh(fh);
+	struct isp_video *video = video_drvdata(file);
+
+	if (fmtdesc->index)
+		return -EINVAL;
+
+	if (fmtdesc->type != video->type)
+		return -EINVAL;
+
+	fmtdesc->flags = 0;
+	fmtdesc->description[0] = 0;
+
+	mutex_lock(&video->mutex);
+	fmtdesc->pixelformat = vfh->format.fmt.pix.pixelformat;
+	mutex_unlock(&video->mutex);
+
+	return 0;
+}
+
+static int
 isp_video_set_format(struct file *file, void *fh, struct v4l2_format *format)
 {
 	struct isp_video_fh *vfh = to_isp_video_fh(fh);
@@ -1059,6 +1081,7 @@ isp_video_s_input(struct file *file, void *fh, unsigned int input)
 
 static const struct v4l2_ioctl_ops isp_video_ioctl_ops = {
 	.vidioc_querycap		= isp_video_querycap,
+	.vidioc_enum_fmt_vid_cap	= isp_video_enum_format,
 	.vidioc_g_fmt_vid_cap		= isp_video_get_format,
 	.vidioc_s_fmt_vid_cap		= isp_video_set_format,
 	.vidioc_try_fmt_vid_cap		= isp_video_try_format,
-- 
1.7.4.1


MATRIX VISION GmbH, Talstrasse 16, DE-71570 Oppenweiler
Registergericht: Amtsgericht Stuttgart, HRB 271090
Geschaeftsfuehrer: Gerhard Thullner, Werner Armingeon, Uwe Furtner
