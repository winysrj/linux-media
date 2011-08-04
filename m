Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.126.171]:52803 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752055Ab1HDHOa (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 4 Aug 2011 03:14:30 -0400
From: Thierry Reding <thierry.reding@avionic-design.de>
To: linux-media@vger.kernel.org
Subject: [PATCH 17/21] [staging] tm6000: Do not use video buffers in radio mode.
Date: Thu,  4 Aug 2011 09:14:15 +0200
Message-Id: <1312442059-23935-18-git-send-email-thierry.reding@avionic-design.de>
In-Reply-To: <1312442059-23935-1-git-send-email-thierry.reding@avionic-design.de>
References: <1312442059-23935-1-git-send-email-thierry.reding@avionic-design.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

If the radio device is opened there is no need to initialize the video
buffer queue because it is not used.
---
 drivers/staging/tm6000/tm6000-video.c |   18 ++++++++++--------
 1 files changed, 10 insertions(+), 8 deletions(-)

diff --git a/drivers/staging/tm6000/tm6000-video.c b/drivers/staging/tm6000/tm6000-video.c
index b59a0da..bb39c91 100644
--- a/drivers/staging/tm6000/tm6000-video.c
+++ b/drivers/staging/tm6000/tm6000-video.c
@@ -1539,13 +1539,13 @@ static int tm6000_open(struct file *file)
 		dev->mode = TM6000_MODE_ANALOG;
 	}
 
-	videobuf_queue_vmalloc_init(&fh->vb_vidq, &tm6000_video_qops,
-			NULL, &dev->slock,
-			fh->type,
-			V4L2_FIELD_INTERLACED,
-			sizeof(struct tm6000_buffer), fh, &dev->lock);
-
-	if (fh->radio) {
+	if (!fh->radio) {
+		videobuf_queue_vmalloc_init(&fh->vb_vidq, &tm6000_video_qops,
+				NULL, &dev->slock,
+				fh->type,
+				V4L2_FIELD_INTERLACED,
+				sizeof(struct tm6000_buffer), fh, &dev->lock);
+	} else {
 		dprintk(dev, V4L2_DEBUG_OPEN, "video_open: setting radio device\n");
 		dev->input = 5;
 		tm6000_set_audio_rinput(dev);
@@ -1617,7 +1617,9 @@ static int tm6000_release(struct file *file)
 		int err;
 
 		tm6000_uninit_isoc(dev);
-		videobuf_mmap_free(&fh->vb_vidq);
+
+		if (!fh->radio)
+			videobuf_mmap_free(&fh->vb_vidq);
 
 		err = tm6000_reset(dev);
 		if (err < 0)
-- 
1.7.6

