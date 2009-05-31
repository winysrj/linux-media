Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-px0-f191.google.com ([209.85.216.191]:44500 "EHLO
	mail-px0-f191.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751494AbZEaGcY (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 31 May 2009 02:32:24 -0400
Received: by pxi29 with SMTP id 29so2207998pxi.33
        for <linux-media@vger.kernel.org>; Sat, 30 May 2009 23:32:26 -0700 (PDT)
Subject: [PATCH] bttv-driver.c :poll method lose race condition for capture
 video
From: "Figo.zhang" <figo1802@gmail.com>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: linux-media@vger.kernel.org, kraxel@bytesex.org,
	Hans Verkuil <hverkuil@xs4all.nl>,
	=?UTF-8?Q?Old=C5=99ich_Jedli=C4=8Dka?= <oldium.pro@seznam.cz>
Content-Type: text/plain
Date: Sun, 31 May 2009 14:32:18 +0800
Message-Id: <1243751538.3425.6.camel@myhost>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

bttv-driver.c,cx23885-video.c,cx88-video.c: poll method lose race condition for capture video.

Signed-off-by: Figo.zhang <figo1802@gmail.com>
--- 
 drivers/media/video/bt8xx/bttv-driver.c     |    7 +++++--
 drivers/media/video/cx23885/cx23885-video.c |   15 +++++++++++----
 drivers/media/video/cx88/cx88-video.c       |   13 ++++++++++---
 3 files changed, 26 insertions(+), 9 deletions(-)

diff --git a/drivers/media/video/bt8xx/bttv-driver.c b/drivers/media/video/bt8xx/bttv-driver.c
index 23b7499..9cadfcc 100644
--- a/drivers/media/video/bt8xx/bttv-driver.c
+++ b/drivers/media/video/bt8xx/bttv-driver.c
@@ -3152,6 +3152,7 @@ static unsigned int bttv_poll(struct file *file, poll_table *wait)
 	struct bttv_fh *fh = file->private_data;
 	struct bttv_buffer *buf;
 	enum v4l2_field field;
+	unsigned int rc = 0;
 
 	if (V4L2_BUF_TYPE_VBI_CAPTURE == fh->type) {
 		if (!check_alloc_btres(fh->btv,fh,RESOURCE_VBI))
@@ -3160,6 +3161,7 @@ static unsigned int bttv_poll(struct file *file, poll_table *wait)
 	}
 
 	if (check_btres(fh,RESOURCE_VIDEO_STREAM)) {
+		mutex_lock(&fh->cap.vb_lock);
 		/* streaming capture */
 		if (list_empty(&fh->cap.stream))
 			return POLLERR;
@@ -3191,8 +3193,9 @@ static unsigned int bttv_poll(struct file *file, poll_table *wait)
 	poll_wait(file, &buf->vb.done, wait);
 	if (buf->vb.state == VIDEOBUF_DONE ||
 	    buf->vb.state == VIDEOBUF_ERROR)
-		return POLLIN|POLLRDNORM;
-	return 0;
+		rc = POLLIN|POLLRDNORM;
+	mutex_unlock(&fh->cap.vb_lock);
+	return rc;
 err:
 	mutex_unlock(&fh->cap.vb_lock);
 	return POLLERR;
diff --git a/drivers/media/video/cx23885/cx23885-video.c b/drivers/media/video/cx23885/cx23885-video.c
index 68068c6..386ad86 100644
--- a/drivers/media/video/cx23885/cx23885-video.c
+++ b/drivers/media/video/cx23885/cx23885-video.c
@@ -796,6 +796,7 @@ static unsigned int video_poll(struct file *file,
 {
 	struct cx23885_fh *fh = file->private_data;
 	struct cx23885_buffer *buf;
+	unsigned int rc = 0;
 
 	if (V4L2_BUF_TYPE_VBI_CAPTURE == fh->type) {
 		if (!res_get(fh->dev, fh, RESOURCE_VBI))
@@ -803,23 +804,29 @@ static unsigned int video_poll(struct file *file,
 		return videobuf_poll_stream(file, &fh->vbiq, wait);
 	}
 
+	mutex_lock(&fh->vidq.vb_lock);
 	if (res_check(fh, RESOURCE_VIDEO)) {
 		/* streaming capture */
 		if (list_empty(&fh->vidq.stream))
-			return POLLERR;
+			goto err;
 		buf = list_entry(fh->vidq.stream.next,
 			struct cx23885_buffer, vb.stream);
 	} else {
 		/* read() capture */
 		buf = (struct cx23885_buffer *)fh->vidq.read_buf;
 		if (NULL == buf)
-			return POLLERR;
+			goto err;
 	}
 	poll_wait(file, &buf->vb.done, wait);
 	if (buf->vb.state == VIDEOBUF_DONE ||
 	    buf->vb.state == VIDEOBUF_ERROR)
-		return POLLIN|POLLRDNORM;
-	return 0;
+		rc = POLLIN|POLLRDNORM;
+	mutex_unlock(&fh->vidq.vb_lock);
+	return rc;
+
+err:
+	mutex_unlock(&fh->vidq.vb_lock);
+	return POLLERR;
 }
 
 static int video_release(struct file *file)
diff --git a/drivers/media/video/cx88/cx88-video.c b/drivers/media/video/cx88/cx88-video.c
index b993d42..f778d15 100644
--- a/drivers/media/video/cx88/cx88-video.c
+++ b/drivers/media/video/cx88/cx88-video.c
@@ -869,6 +869,7 @@ video_poll(struct file *file, struct poll_table_struct *wait)
 {
 	struct cx8800_fh *fh = file->private_data;
 	struct cx88_buffer *buf;
+	unsigned int rc = 0;
 
 	if (V4L2_BUF_TYPE_VBI_CAPTURE == fh->type) {
 		if (!res_get(fh->dev,fh,RESOURCE_VBI))
@@ -876,22 +877,28 @@ video_poll(struct file *file, struct poll_table_struct *wait)
 		return videobuf_poll_stream(file, &fh->vbiq, wait);
 	}
 
+	mutex_lock(&fh->vidq.vb_lock);
 	if (res_check(fh,RESOURCE_VIDEO)) {
 		/* streaming capture */
 		if (list_empty(&fh->vidq.stream))
-			return POLLERR;
+			goto err;
 		buf = list_entry(fh->vidq.stream.next,struct cx88_buffer,vb.stream);
 	} else {
 		/* read() capture */
 		buf = (struct cx88_buffer*)fh->vidq.read_buf;
 		if (NULL == buf)
-			return POLLERR;
+			goto err;
 	}
 	poll_wait(file, &buf->vb.done, wait);
 	if (buf->vb.state == VIDEOBUF_DONE ||
 	    buf->vb.state == VIDEOBUF_ERROR)
-		return POLLIN|POLLRDNORM;
+		rc = POLLIN|POLLRDNORM;
+	mutex_unlock(&fh->vidq.vb_lock);
 	return 0;
+
+err:
+	mutex_unlock(&fh->vidq.vb_lock);
+	return POLLERR;
 }
 
 static int video_release(struct file *file)


