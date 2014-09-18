Return-path: <linux-media-owner@vger.kernel.org>
Received: from kozue.soulik.info ([108.61.200.231]:39754 "EHLO
	kozue.soulik.info" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753340AbaIRTlh (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 18 Sep 2014 15:41:37 -0400
From: ayaka <ayaka@soulik.info>
To: linux-media@vger.kernel.org
Cc: k.debski@samsung.com, arun.m@samsung.com, arun.kk@samsung.com,
	ayaka <ayaka@soulik.info>
Subject: [PATCH] media: fix enum_fmt for s5p-mfc
Date: Fri, 19 Sep 2014 03:41:12 +0800
Message-Id: <1411069272-16896-2-git-send-email-ayaka@soulik.info>
In-Reply-To: <1411069272-16896-1-git-send-email-ayaka@soulik.info>
References: <1411069272-16896-1-git-send-email-ayaka@soulik.info>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

As the s5p-mfc is a driver which use  multiplanar api, so the
vidioc_enum_fmt_vid serial of ioctl should only for
multiplanar, non-multiplanar shouldn't be implemented at all.

Signed-off-by: ayaka <ayaka@soulik.info>
---
 drivers/media/platform/s5p-mfc/s5p_mfc_dec.c | 24 +++---------------------
 drivers/media/platform/s5p-mfc/s5p_mfc_enc.c | 24 +++---------------------
 2 files changed, 6 insertions(+), 42 deletions(-)

diff --git a/drivers/media/platform/s5p-mfc/s5p_mfc_dec.c b/drivers/media/platform/s5p-mfc/s5p_mfc_dec.c
index 4d93835..6611a7a 100644
--- a/drivers/media/platform/s5p-mfc/s5p_mfc_dec.c
+++ b/drivers/media/platform/s5p-mfc/s5p_mfc_dec.c
@@ -283,17 +283,13 @@ static int vidioc_querycap(struct file *file, void *priv,
 
 /* Enumerate format */
 static int vidioc_enum_fmt(struct file *file, struct v4l2_fmtdesc *f,
-							bool mplane, bool out)
+							bool out)
 {
 	struct s5p_mfc_dev *dev = video_drvdata(file);
 	struct s5p_mfc_fmt *fmt;
 	int i, j = 0;
 
 	for (i = 0; i < ARRAY_SIZE(formats); ++i) {
-		if (mplane && formats[i].num_planes == 1)
-			continue;
-		else if (!mplane && formats[i].num_planes > 1)
-			continue;
 		if (out && formats[i].type != MFC_FMT_DEC)
 			continue;
 		else if (!out && formats[i].type != MFC_FMT_RAW)
@@ -313,28 +309,16 @@ static int vidioc_enum_fmt(struct file *file, struct v4l2_fmtdesc *f,
 	return 0;
 }
 
-static int vidioc_enum_fmt_vid_cap(struct file *file, void *pirv,
-							struct v4l2_fmtdesc *f)
-{
-	return vidioc_enum_fmt(file, f, false, false);
-}
-
 static int vidioc_enum_fmt_vid_cap_mplane(struct file *file, void *pirv,
 							struct v4l2_fmtdesc *f)
 {
-	return vidioc_enum_fmt(file, f, true, false);
-}
-
-static int vidioc_enum_fmt_vid_out(struct file *file, void *priv,
-							struct v4l2_fmtdesc *f)
-{
-	return vidioc_enum_fmt(file, f, false, true);
+	return vidioc_enum_fmt(file, f, false);
 }
 
 static int vidioc_enum_fmt_vid_out_mplane(struct file *file, void *priv,
 							struct v4l2_fmtdesc *f)
 {
-	return vidioc_enum_fmt(file, f, true, true);
+	return vidioc_enum_fmt(file, f, true);
 }
 
 /* Get format */
@@ -878,9 +862,7 @@ static int vidioc_subscribe_event(struct v4l2_fh *fh,
 /* v4l2_ioctl_ops */
 static const struct v4l2_ioctl_ops s5p_mfc_dec_ioctl_ops = {
 	.vidioc_querycap = vidioc_querycap,
-	.vidioc_enum_fmt_vid_cap = vidioc_enum_fmt_vid_cap,
 	.vidioc_enum_fmt_vid_cap_mplane = vidioc_enum_fmt_vid_cap_mplane,
-	.vidioc_enum_fmt_vid_out = vidioc_enum_fmt_vid_out,
 	.vidioc_enum_fmt_vid_out_mplane = vidioc_enum_fmt_vid_out_mplane,
 	.vidioc_g_fmt_vid_cap_mplane = vidioc_g_fmt,
 	.vidioc_g_fmt_vid_out_mplane = vidioc_g_fmt,
diff --git a/drivers/media/platform/s5p-mfc/s5p_mfc_enc.c b/drivers/media/platform/s5p-mfc/s5p_mfc_enc.c
index 3abe468..4725a6f 100644
--- a/drivers/media/platform/s5p-mfc/s5p_mfc_enc.c
+++ b/drivers/media/platform/s5p-mfc/s5p_mfc_enc.c
@@ -953,17 +953,13 @@ static int vidioc_querycap(struct file *file, void *priv,
 }
 
 static int vidioc_enum_fmt(struct file *file, struct v4l2_fmtdesc *f,
-							bool mplane, bool out)
+							bool out)
 {
 	struct s5p_mfc_dev *dev = video_drvdata(file);
 	struct s5p_mfc_fmt *fmt;
 	int i, j = 0;
 
 	for (i = 0; i < ARRAY_SIZE(formats); ++i) {
-		if (mplane && formats[i].num_planes == 1)
-			continue;
-		else if (!mplane && formats[i].num_planes > 1)
-			continue;
 		if (out && formats[i].type != MFC_FMT_RAW)
 			continue;
 		else if (!out && formats[i].type != MFC_FMT_ENC)
@@ -983,28 +979,16 @@ static int vidioc_enum_fmt(struct file *file, struct v4l2_fmtdesc *f,
 	return -EINVAL;
 }
 
-static int vidioc_enum_fmt_vid_cap(struct file *file, void *pirv,
-				   struct v4l2_fmtdesc *f)
-{
-	return vidioc_enum_fmt(file, f, false, false);
-}
-
 static int vidioc_enum_fmt_vid_cap_mplane(struct file *file, void *pirv,
 					  struct v4l2_fmtdesc *f)
 {
-	return vidioc_enum_fmt(file, f, true, false);
-}
-
-static int vidioc_enum_fmt_vid_out(struct file *file, void *prov,
-				   struct v4l2_fmtdesc *f)
-{
-	return vidioc_enum_fmt(file, f, false, true);
+	return vidioc_enum_fmt(file, f, false);
 }
 
 static int vidioc_enum_fmt_vid_out_mplane(struct file *file, void *prov,
 					  struct v4l2_fmtdesc *f)
 {
-	return vidioc_enum_fmt(file, f, true, true);
+	return vidioc_enum_fmt(file, f, true);
 }
 
 static int vidioc_g_fmt(struct file *file, void *priv, struct v4l2_format *f)
@@ -1751,9 +1735,7 @@ static int vidioc_subscribe_event(struct v4l2_fh *fh,
 
 static const struct v4l2_ioctl_ops s5p_mfc_enc_ioctl_ops = {
 	.vidioc_querycap = vidioc_querycap,
-	.vidioc_enum_fmt_vid_cap = vidioc_enum_fmt_vid_cap,
 	.vidioc_enum_fmt_vid_cap_mplane = vidioc_enum_fmt_vid_cap_mplane,
-	.vidioc_enum_fmt_vid_out = vidioc_enum_fmt_vid_out,
 	.vidioc_enum_fmt_vid_out_mplane = vidioc_enum_fmt_vid_out_mplane,
 	.vidioc_g_fmt_vid_cap_mplane = vidioc_g_fmt,
 	.vidioc_g_fmt_vid_out_mplane = vidioc_g_fmt,
-- 
1.9.3

