Return-path: <mchehab@pedra>
Received: from moutng.kundenserver.de ([212.227.17.10]:62803 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751511Ab1CUKHf (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 21 Mar 2011 06:07:35 -0400
Received: from localhost (localhost [127.0.0.1])
	by axis700.grange (Postfix) with ESMTP id 6E6D41067E6
	for <linux-media@vger.kernel.org>; Mon, 21 Mar 2011 11:07:30 +0100 (CET)
Date: Mon, 21 Mar 2011 11:07:30 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH] V4L: soc-camera: explicitly require V4L2_BUF_TYPE_VIDEO_CAPTURE
Message-ID: <Pine.LNX.4.64.1103211105160.21013@axis700.grange>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

The soc-camera core accesses the "pix" member of the struct v4l2_format::fmt
union, which is only valid for V4L2_BUF_TYPE_VIDEO_CAPTURE streams. This
patch adds explicit checks for this to {g,s,try}_fmt methods.

Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
---

Trying to quickly rotate this pretty trivial patch through the list to 
hopefully push it for the second 2.6.39 v4l pull request.

 drivers/media/video/soc_camera.c |   16 ++++++++++++----
 1 files changed, 12 insertions(+), 4 deletions(-)

diff --git a/drivers/media/video/soc_camera.c b/drivers/media/video/soc_camera.c
index 07525e7..4628448 100644
--- a/drivers/media/video/soc_camera.c
+++ b/drivers/media/video/soc_camera.c
@@ -144,6 +144,10 @@ static int soc_camera_try_fmt_vid_cap(struct file *file, void *priv,
 
 	WARN_ON(priv != file->private_data);
 
+	/* Only single-plane capture is supported so far */
+	if (f->type != V4L2_BUF_TYPE_VIDEO_CAPTURE)
+		return -EINVAL;
+
 	/* limit format to hardware capabilities */
 	return ici->ops->try_fmt(icd, f);
 }
@@ -396,10 +400,6 @@ static int soc_camera_set_fmt(struct soc_camera_device *icd,
 	if (ici->ops->init_videobuf)
 		icd->vb_vidq.field = pix->field;
 
-	if (f->type != V4L2_BUF_TYPE_VIDEO_CAPTURE)
-		dev_warn(&icd->dev, "Attention! Wrong buf-type %d\n",
-			 f->type);
-
 	dev_dbg(&icd->dev, "set width: %d height: %d\n",
 		icd->user_width, icd->user_height);
 
@@ -618,6 +618,11 @@ static int soc_camera_s_fmt_vid_cap(struct file *file, void *priv,
 
 	WARN_ON(priv != file->private_data);
 
+	if (f->type != V4L2_BUF_TYPE_VIDEO_CAPTURE) {
+		dev_warn(&icd->dev, "Wrong buf-type %d\n", f->type);
+		return -EINVAL;
+	}
+
 	if (icd->streamer && icd->streamer != file)
 		return -EBUSY;
 
@@ -661,6 +666,9 @@ static int soc_camera_g_fmt_vid_cap(struct file *file, void *priv,
 
 	WARN_ON(priv != file->private_data);
 
+	if (f->type != V4L2_BUF_TYPE_VIDEO_CAPTURE)
+		return -EINVAL;
+
 	pix->width		= icd->user_width;
 	pix->height		= icd->user_height;
 	pix->bytesperline	= icd->bytesperline;
-- 
1.7.2.5

