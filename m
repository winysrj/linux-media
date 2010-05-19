Return-path: <linux-media-owner@vger.kernel.org>
Received: from bear.ext.ti.com ([192.94.94.41]:34304 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753881Ab0ESP5g (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 19 May 2010 11:57:36 -0400
From: <asheeshb@ti.com>
To: <linux-media@vger.kernel.org>
CC: Asheesh Bhardwaj <asheesh@lab1.dmlab>
Subject: [PATCH 4/7] Patch for vpif capture driver to get the right size image for the MMAP buffers
Date: Wed, 19 May 2010 10:56:48 -0500
Message-ID: <1274284611-13432-4-git-send-email-asheeshb@ti.com>
In-Reply-To: <1274284611-13432-3-git-send-email-asheeshb@ti.com>
References: <1274284611-13432-1-git-send-email-asheeshb@ti.com>
 <1274284611-13432-2-git-send-email-asheeshb@ti.com>
 <1274284611-13432-3-git-send-email-asheeshb@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Asheesh Bhardwaj <asheesh@lab1.dmlab>

---
 drivers/media/video/davinci/vpif_capture.c |   13 ++++---------
 1 files changed, 4 insertions(+), 9 deletions(-)

diff --git a/drivers/media/video/davinci/vpif_capture.c b/drivers/media/video/davinci/vpif_capture.c
index 9ba015d..d18a378 100644
--- a/drivers/media/video/davinci/vpif_capture.c
+++ b/drivers/media/video/davinci/vpif_capture.c
@@ -142,7 +142,7 @@ static int vpif_buffer_prepare(struct videobuf_queue *q,
 	if (VIDEOBUF_NEEDS_INIT == vb->state) {
 		vb->width = common->width;
 		vb->height = common->height;
-		vb->size = vb->width * vb->height;
+		vb->size = common->fmt.fmt.pix.sizeimage;
 		vb->field = field;
 
 		ret = videobuf_iolock(q, vb, NULL);
@@ -469,10 +469,8 @@ static void vpif_calculate_offsets(struct channel_obj *ch)
 	} else
 		vid_ch->buf_field = common->fmt.fmt.pix.field;
 
-	if (V4L2_MEMORY_USERPTR == common->memory)
-		sizeimage = common->fmt.fmt.pix.sizeimage;
-	else
-		sizeimage = config_params.channel_bufsize[ch->channel_id];
+	/*sizeimage is same for both user and MMAP allocated buffers*/
+        sizeimage = common->fmt.fmt.pix.sizeimage;
 
 	hpitch = common->fmt.fmt.pix.bytesperline;
 	vpitch = sizeimage / (hpitch * 2);
@@ -630,10 +628,7 @@ static int vpif_check_format(struct channel_obj *ch,
 		goto exit;
 	}
 
-	if (V4L2_MEMORY_USERPTR == common->memory)
-		sizeimage = pixfmt->sizeimage;
-	else
-		sizeimage = config_params.channel_bufsize[ch->channel_id];
+	sizeimage = pixfmt->sizeimage;
 
 	vpitch = sizeimage / (hpitch * 2);
 
-- 
1.6.3.3

