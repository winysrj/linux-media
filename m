Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kolorific.com ([61.63.28.39]:34876 "EHLO
	mail.kolorific.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751403AbZESCOu (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 18 May 2009 22:14:50 -0400
Subject: [PATCH  v2]saa7134-video.c: poll method lose race condition for
 capture video
From: "figo.zhang" <figo.zhang@kolorific.com>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: linux-media@vger.kernel.org, figo1802@126.com, kraxel@bytesex.org,
	Hans Verkuil <hverkuil@xs4all.nl>,
	=?UTF-8?Q?Old=C5=99ich_Jedli=C4=8Dka?= <oldium.pro@seznam.cz>
Content-Type: text/plain
Date: Tue, 19 May 2009 10:14:30 +0800
Message-Id: <1242699272.3436.6.camel@myhost>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

saa7134-video.c: poll method lose race condition for capture video.

In v2, when buf == NULL, it will goto err, return  "PULLERR"
immediately.

Signed-off-by: Figo.zhang <figo.zhang@kolorific.com>
---  
drivers/media/video/saa7134/saa7134-video.c |    9 ++++++---
 1 files changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/media/video/saa7134/saa7134-video.c b/drivers/media/video/saa7134/saa7134-video.c
index 493cad9..b1c2dbd 100644
--- a/drivers/media/video/saa7134/saa7134-video.c
+++ b/drivers/media/video/saa7134/saa7134-video.c
@@ -1423,11 +1423,13 @@ video_poll(struct file *file, struct poll_table_struct *wait)
 {
 	struct saa7134_fh *fh = file->private_data;
 	struct videobuf_buffer *buf = NULL;
+	unsigned int rc = 0;
 
 	if (V4L2_BUF_TYPE_VBI_CAPTURE == fh->type)
 		return videobuf_poll_stream(file, &fh->vbi, wait);
 
 	if (res_check(fh,RESOURCE_VIDEO)) {
+		mutex_lock(&fh->cap.vb_lock);
 		if (!list_empty(&fh->cap.stream))
 			buf = list_entry(fh->cap.stream.next, struct videobuf_buffer, stream);
 	} else {
@@ -1446,13 +1448,14 @@ video_poll(struct file *file, struct poll_table_struct *wait)
 	}
 
 	if (!buf)
-		return POLLERR;
+		goto err;
 
 	poll_wait(file, &buf->done, wait);
 	if (buf->state == VIDEOBUF_DONE ||
 	    buf->state == VIDEOBUF_ERROR)
-		return POLLIN|POLLRDNORM;
-	return 0;
+		rc =  POLLIN|POLLRDNORM;
+	mutex_unlock(&fh->cap.vb_lock);
+	return rc;
 
 err:
 	mutex_unlock(&fh->cap.vb_lock);


