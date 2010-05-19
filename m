Return-path: <linux-media-owner@vger.kernel.org>
Received: from comal.ext.ti.com ([198.47.26.152]:37813 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754045Ab0ESQoo (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 19 May 2010 12:44:44 -0400
Received: from dlep34.itg.ti.com ([157.170.170.115])
	by comal.ext.ti.com (8.13.7/8.13.7) with ESMTP id o4JGii1P012343
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-media@vger.kernel.org>; Wed, 19 May 2010 11:44:44 -0500
Received: from dlep26.itg.ti.com (localhost [127.0.0.1])
	by dlep34.itg.ti.com (8.13.7/8.13.7) with ESMTP id o4JGiiNm010038
	for <linux-media@vger.kernel.org>; Wed, 19 May 2010 11:44:44 -0500 (CDT)
Received: from dlee73.ent.ti.com (localhost [127.0.0.1])
	by dlep26.itg.ti.com (8.13.8/8.13.8) with ESMTP id o4JGii8o013194
	for <linux-media@vger.kernel.org>; Wed, 19 May 2010 11:44:44 -0500 (CDT)
From: <asheeshb@ti.com>
To: <linux-media@vger.kernel.org>
CC: Asheesh Bhardwaj <asheeshb@ti.com>
Subject: [PATCH 4/7] Change vpif capture driver to get the right size image for the MMAP buffers
Date: Wed, 19 May 2010 11:44:35 -0500
Message-ID: <1274287478-14661-5-git-send-email-asheeshb@ti.com>
In-Reply-To: <1274287478-14661-4-git-send-email-asheeshb@ti.com>
References: <1274287478-14661-1-git-send-email-asheeshb@ti.com>
 <1274287478-14661-2-git-send-email-asheeshb@ti.com>
 <1274287478-14661-3-git-send-email-asheeshb@ti.com>
 <1274287478-14661-4-git-send-email-asheeshb@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Asheesh Bhardwaj <asheeshb@ti.com>

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

