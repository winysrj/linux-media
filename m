Return-path: <mchehab@pedra>
Received: from devils.ext.ti.com ([198.47.26.153]:39893 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754845Ab1FGOrx (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 7 Jun 2011 10:47:53 -0400
Received: from dlep36.itg.ti.com ([157.170.170.91])
	by devils.ext.ti.com (8.13.7/8.13.7) with ESMTP id p57Elr6f002443
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-media@vger.kernel.org>; Tue, 7 Jun 2011 09:47:53 -0500
Received: from dlep26.itg.ti.com (smtp-le.itg.ti.com [157.170.170.27])
	by dlep36.itg.ti.com (8.13.8/8.13.8) with ESMTP id p57ElrSA022463
	for <linux-media@vger.kernel.org>; Tue, 7 Jun 2011 09:47:53 -0500 (CDT)
From: Amber Jain <amber@ti.com>
To: <linux-media@vger.kernel.org>
CC: <hvaibhav@ti.com>, <sumit.semwal@ti.com>,
	Amber Jain <amber@ti.com>, Samreen <samreen@ti.com>
Subject: [PATCH 3/6] V4L2: OMAP: VOUT: Adapt to Multiplanar APIs
Date: Tue, 7 Jun 2011 20:17:35 +0530
Message-ID: <1307458058-29030-4-git-send-email-amber@ti.com>
In-Reply-To: <1307458058-29030-1-git-send-email-amber@ti.com>
References: <1307458058-29030-1-git-send-email-amber@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Adapting the omap_vout driver for multiplanar API support.

Signed-off-by: Amber Jain <amber@ti.com>
Signed-off-by: Samreen <samreen@ti.com>
---
 drivers/media/video/omap/omap_vout.c |   19 ++++++++++---------
 1 files changed, 10 insertions(+), 9 deletions(-)

diff --git a/drivers/media/video/omap/omap_vout.c b/drivers/media/video/omap/omap_vout.c
index 435fe65..70fb45e 100644
--- a/drivers/media/video/omap/omap_vout.c
+++ b/drivers/media/video/omap/omap_vout.c
@@ -1014,12 +1014,13 @@ static int vidioc_querycap(struct file *file, void *fh,
 	strlcpy(cap->driver, VOUT_NAME, sizeof(cap->driver));
 	strlcpy(cap->card, vout->vfd->name, sizeof(cap->card));
 	cap->bus_info[0] = '\0';
-	cap->capabilities = V4L2_CAP_STREAMING | V4L2_CAP_VIDEO_OUTPUT;
+	cap->capabilities = V4L2_CAP_STREAMING | V4L2_CAP_VIDEO_OUTPUT |
+				V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE;
 
 	return 0;
 }
 
-static int vidioc_enum_fmt_vid_out(struct file *file, void *fh,
+static int vidioc_enum_fmt_vid_out_mplane(struct file *file, void *fh,
 			struct v4l2_fmtdesc *fmt)
 {
 	int index = fmt->index;
@@ -1038,7 +1039,7 @@ static int vidioc_enum_fmt_vid_out(struct file *file, void *fh,
 	return 0;
 }
 
-static int vidioc_g_fmt_vid_out(struct file *file, void *fh,
+static int vidioc_g_fmt_vid_out_mplane(struct file *file, void *fh,
 			struct v4l2_format *f)
 {
 	struct omap_vout_device *vout = fh;
@@ -1048,7 +1049,7 @@ static int vidioc_g_fmt_vid_out(struct file *file, void *fh,
 
 }
 
-static int vidioc_try_fmt_vid_out(struct file *file, void *fh,
+static int vidioc_try_fmt_vid_out_mplane(struct file *file, void *fh,
 			struct v4l2_format *f)
 {
 	struct omap_overlay *ovl;
@@ -1071,7 +1072,7 @@ static int vidioc_try_fmt_vid_out(struct file *file, void *fh,
 	return 0;
 }
 
-static int vidioc_s_fmt_vid_out(struct file *file, void *fh,
+static int vidioc_s_fmt_vid_out_mplane(struct file *file, void *fh,
 			struct v4l2_format *f)
 {
 	int ret, bpp;
@@ -1817,10 +1818,10 @@ static int vidioc_g_fbuf(struct file *file, void *fh,
 
 static const struct v4l2_ioctl_ops vout_ioctl_ops = {
 	.vidioc_querycap      			= vidioc_querycap,
-	.vidioc_enum_fmt_vid_out 		= vidioc_enum_fmt_vid_out,
-	.vidioc_g_fmt_vid_out			= vidioc_g_fmt_vid_out,
-	.vidioc_try_fmt_vid_out			= vidioc_try_fmt_vid_out,
-	.vidioc_s_fmt_vid_out			= vidioc_s_fmt_vid_out,
+	.vidioc_enum_fmt_vid_out_mplane		= vidioc_enum_fmt_vid_out_mplane,
+	.vidioc_g_fmt_vid_out_mplane		= vidioc_g_fmt_vid_out_mplane,
+	.vidioc_try_fmt_vid_out_mplane		= vidioc_try_fmt_vid_out_mplane,
+	.vidioc_s_fmt_vid_out_mplane		= vidioc_s_fmt_vid_out_mplane,
 	.vidioc_queryctrl    			= vidioc_queryctrl,
 	.vidioc_g_ctrl       			= vidioc_g_ctrl,
 	.vidioc_s_fbuf				= vidioc_s_fbuf,
-- 
1.7.1

