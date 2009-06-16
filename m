Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-px0-f189.google.com ([209.85.216.189]:35269 "EHLO
	mail-px0-f189.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756090AbZFPQba (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 16 Jun 2009 12:31:30 -0400
Received: by pxi27 with SMTP id 27so1068415pxi.33
        for <linux-media@vger.kernel.org>; Tue, 16 Jun 2009 09:31:32 -0700 (PDT)
Subject: [PATCH v3]poll method lose race condition
From: "Figo.zhang" <figo1802@gmail.com>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Content-Type: text/plain
Date: Wed, 17 Jun 2009 00:31:29 +0800
Message-Id: <1245169889.6397.7.camel@myhost>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

 bttv-driver.c,cx23885-video.c,cx88-video.c: poll method lose race condition for capture video.
 
 In v2, use the clear logic.Thanks to Trent Piepho's help.

 In v3, fix a hold mutex locked issue.

Signed-off-by: Figo.zhang <figo1802@gmail.com>
--- 
 drivers/media/video/bt8xx/bttv-driver.c     |   11 +++++++----
 drivers/media/video/cx23885/cx23885-video.c |   14 ++++++++++----
 drivers/media/video/cx88/cx88-video.c       |   14 ++++++++++----
 3 files changed, 27 insertions(+), 12 deletions(-)

diff --git a/drivers/media/video/bt8xx/bttv-driver.c b/drivers/media/video/bt8xx/bttv-driver.c
index 23b7499..3688b6e 100644
--- a/drivers/media/video/bt8xx/bttv-driver.c
+++ b/drivers/media/video/bt8xx/bttv-driver.c
@@ -3152,6 +3152,7 @@ static unsigned int bttv_poll(struct file *file, poll_table *wait)
 	struct bttv_fh *fh = file->private_data;
 	struct bttv_buffer *buf;
 	enum v4l2_field field;
+	unsigned int rc = POLLERR;
 
 	if (V4L2_BUF_TYPE_VBI_CAPTURE == fh->type) {
 		if (!check_alloc_btres(fh->btv,fh,RESOURCE_VBI))
@@ -3160,9 +3161,10 @@ static unsigned int bttv_poll(struct file *file, poll_table *wait)
 	}
 
 	if (check_btres(fh,RESOURCE_VIDEO_STREAM)) {
+		mutex_lock(&fh->cap.vb_lock);
 		/* streaming capture */
 		if (list_empty(&fh->cap.stream))
-			return POLLERR;
+			goto err;
 		buf = list_entry(fh->cap.stream.next,struct bttv_buffer,vb.stream);
 	} else {
 		/* read() capture */
@@ -3191,11 +3193,12 @@ static unsigned int bttv_poll(struct file *file, poll_table *wait)
 	poll_wait(file, &buf->vb.done, wait);
 	if (buf->vb.state == VIDEOBUF_DONE ||
 	    buf->vb.state == VIDEOBUF_ERROR)
-		return POLLIN|POLLRDNORM;
-	return 0;
+		rc =  POLLIN|POLLRDNORM;
+	else
+		rc = 0;
 err:
 	mutex_unlock(&fh->cap.vb_lock);
-	return POLLERR;
+	return rc;
 }
 
 static int bttv_open(struct file *file)
diff --git a/drivers/media/video/cx23885/cx23885-video.c b/drivers/media/video/cx23885/cx23885-video.c
index 68068c6..66bbd2e 100644
--- a/drivers/media/video/cx23885/cx23885-video.c
+++ b/drivers/media/video/cx23885/cx23885-video.c
@@ -796,6 +796,7 @@ static unsigned int video_poll(struct file *file,
 {
 	struct cx23885_fh *fh = file->private_data;
 	struct cx23885_buffer *buf;
+	unsigned int rc = POLLERR;
 
 	if (V4L2_BUF_TYPE_VBI_CAPTURE == fh->type) {
 		if (!res_get(fh->dev, fh, RESOURCE_VBI))
@@ -803,23 +804,28 @@ static unsigned int video_poll(struct file *file,
 		return videobuf_poll_stream(file, &fh->vbiq, wait);
 	}
 
+	mutex_lock(&fh->vidq.vb_lock);
 	if (res_check(fh, RESOURCE_VIDEO)) {
 		/* streaming capture */
 		if (list_empty(&fh->vidq.stream))
-			return POLLERR;
+			goto done;
 		buf = list_entry(fh->vidq.stream.next,
 			struct cx23885_buffer, vb.stream);
 	} else {
 		/* read() capture */
 		buf = (struct cx23885_buffer *)fh->vidq.read_buf;
 		if (NULL == buf)
-			return POLLERR;
+			goto done;
 	}
 	poll_wait(file, &buf->vb.done, wait);
 	if (buf->vb.state == VIDEOBUF_DONE ||
 	    buf->vb.state == VIDEOBUF_ERROR)
-		return POLLIN|POLLRDNORM;
-	return 0;
+		rc =  POLLIN|POLLRDNORM;
+	else
+		rc = 0;
+done:
+	mutex_unlock(&fh->vidq.vb_lock);
+	return rc;
 }
 
 static int video_release(struct file *file)
diff --git a/drivers/media/video/cx88/cx88-video.c b/drivers/media/video/cx88/cx88-video.c
index b993d42..97545a0 100644
--- a/drivers/media/video/cx88/cx88-video.c
+++ b/drivers/media/video/cx88/cx88-video.c
@@ -869,6 +869,7 @@ video_poll(struct file *file, struct poll_table_struct *wait)
 {
 	struct cx8800_fh *fh = file->private_data;
 	struct cx88_buffer *buf;
+	unsigned int rc = POLLERR;
 
 	if (V4L2_BUF_TYPE_VBI_CAPTURE == fh->type) {
 		if (!res_get(fh->dev,fh,RESOURCE_VBI))
@@ -876,22 +877,27 @@ video_poll(struct file *file, struct poll_table_struct *wait)
 		return videobuf_poll_stream(file, &fh->vbiq, wait);
 	}
 
+	mutex_lock(&fh->vidq.vb_lock);
 	if (res_check(fh,RESOURCE_VIDEO)) {
 		/* streaming capture */
 		if (list_empty(&fh->vidq.stream))
-			return POLLERR;
+			goto done;
 		buf = list_entry(fh->vidq.stream.next,struct cx88_buffer,vb.stream);
 	} else {
 		/* read() capture */
 		buf = (struct cx88_buffer*)fh->vidq.read_buf;
 		if (NULL == buf)
-			return POLLERR;
+			goto done;
 	}
 	poll_wait(file, &buf->vb.done, wait);
 	if (buf->vb.state == VIDEOBUF_DONE ||
 	    buf->vb.state == VIDEOBUF_ERROR)
-		return POLLIN|POLLRDNORM;
-	return 0;
+		rc = POLLIN|POLLRDNORM;
+	else
+		rc = 0;
+done:
+	mutex_unlock(&fh->vidq.vb_lock);
+	return rc;
 }
 
 static int video_release(struct file *file)


