Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr10.xs4all.nl ([194.109.24.30]:2068 "EHLO
	smtp-vbr10.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751877Ab3DNPhK (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 14 Apr 2013 11:37:10 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Sri Deevi <Srinivasa.Deevi@conexant.com>,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [REVIEW PATCH 26/30] cx25821: group all fmt functions together.
Date: Sun, 14 Apr 2013 17:27:22 +0200
Message-Id: <1365953246-8972-27-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1365953246-8972-1-git-send-email-hverkuil@xs4all.nl>
References: <1365953246-8972-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

No other changes, just function reordering.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/pci/cx25821/cx25821-video.c |   84 +++++++++++++++--------------
 1 file changed, 43 insertions(+), 41 deletions(-)

diff --git a/drivers/media/pci/cx25821/cx25821-video.c b/drivers/media/pci/cx25821/cx25821-video.c
index 8d5d13b..d3cf259 100644
--- a/drivers/media/pci/cx25821/cx25821-video.c
+++ b/drivers/media/pci/cx25821/cx25821-video.c
@@ -551,6 +551,19 @@ static int video_release(struct file *file)
 }
 
 /* VIDEO IOCTLS */
+
+static int cx25821_vidioc_enum_fmt_vid_cap(struct file *file, void *priv,
+			    struct v4l2_fmtdesc *f)
+{
+	if (unlikely(f->index >= ARRAY_SIZE(formats)))
+		return -EINVAL;
+
+	strlcpy(f->description, formats[f->index].name, sizeof(f->description));
+	f->pixelformat = formats[f->index].fourcc;
+
+	return 0;
+}
+
 static int cx25821_vidioc_g_fmt_vid_cap(struct file *file, void *priv,
 				 struct v4l2_format *f)
 {
@@ -607,35 +620,6 @@ static int cx25821_vidioc_try_fmt_vid_cap(struct file *file, void *priv,
 
 	return 0;
 }
-static int vidioc_streamon(struct file *file, void *priv, enum v4l2_buf_type i)
-{
-	struct cx25821_channel *chan = video_drvdata(file);
-
-	if (i != V4L2_BUF_TYPE_VIDEO_CAPTURE)
-		return -EINVAL;
-
-	if (chan->streaming_fh && chan->streaming_fh != priv)
-		return -EBUSY;
-	chan->streaming_fh = priv;
-
-	return videobuf_streamon(&chan->vidq);
-}
-
-static int vidioc_streamoff(struct file *file, void *priv, enum v4l2_buf_type i)
-{
-	struct cx25821_channel *chan = video_drvdata(file);
-
-	if (i != V4L2_BUF_TYPE_VIDEO_CAPTURE)
-		return -EINVAL;
-
-	if (chan->streaming_fh && chan->streaming_fh != priv)
-		return -EBUSY;
-	if (chan->streaming_fh == NULL)
-		return 0;
-
-	chan->streaming_fh = NULL;
-	return videobuf_streamoff(&chan->vidq);
-}
 
 static int vidioc_s_fmt_vid_cap(struct file *file, void *priv,
 				struct v4l2_format *f)
@@ -673,6 +657,36 @@ static int vidioc_s_fmt_vid_cap(struct file *file, void *priv,
 	return 0;
 }
 
+static int vidioc_streamon(struct file *file, void *priv, enum v4l2_buf_type i)
+{
+	struct cx25821_channel *chan = video_drvdata(file);
+
+	if (i != V4L2_BUF_TYPE_VIDEO_CAPTURE)
+		return -EINVAL;
+
+	if (chan->streaming_fh && chan->streaming_fh != priv)
+		return -EBUSY;
+	chan->streaming_fh = priv;
+
+	return videobuf_streamon(&chan->vidq);
+}
+
+static int vidioc_streamoff(struct file *file, void *priv, enum v4l2_buf_type i)
+{
+	struct cx25821_channel *chan = video_drvdata(file);
+
+	if (i != V4L2_BUF_TYPE_VIDEO_CAPTURE)
+		return -EINVAL;
+
+	if (chan->streaming_fh && chan->streaming_fh != priv)
+		return -EBUSY;
+	if (chan->streaming_fh == NULL)
+		return 0;
+
+	chan->streaming_fh = NULL;
+	return videobuf_streamoff(&chan->vidq);
+}
+
 static int vidioc_dqbuf(struct file *file, void *priv, struct v4l2_buffer *p)
 {
 	int ret_val = 0;
@@ -718,18 +732,6 @@ static int cx25821_vidioc_querycap(struct file *file, void *priv,
 	return 0;
 }
 
-static int cx25821_vidioc_enum_fmt_vid_cap(struct file *file, void *priv,
-			    struct v4l2_fmtdesc *f)
-{
-	if (unlikely(f->index >= ARRAY_SIZE(formats)))
-		return -EINVAL;
-
-	strlcpy(f->description, formats[f->index].name, sizeof(f->description));
-	f->pixelformat = formats[f->index].fourcc;
-
-	return 0;
-}
-
 static int cx25821_vidioc_reqbufs(struct file *file, void *priv,
 			   struct v4l2_requestbuffers *p)
 {
-- 
1.7.10.4

