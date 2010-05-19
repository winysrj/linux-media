Return-path: <linux-media-owner@vger.kernel.org>
Received: from devils.ext.ti.com ([198.47.26.153]:45636 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754051Ab0ESQop (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 19 May 2010 12:44:45 -0400
Received: from dlep33.itg.ti.com ([157.170.170.112])
	by devils.ext.ti.com (8.13.7/8.13.7) with ESMTP id o4JGiiPh010733
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-media@vger.kernel.org>; Wed, 19 May 2010 11:44:44 -0500
Received: from dlep26.itg.ti.com (localhost [127.0.0.1])
	by dlep33.itg.ti.com (8.13.7/8.13.7) with ESMTP id o4JGiiB1024950
	for <linux-media@vger.kernel.org>; Wed, 19 May 2010 11:44:44 -0500 (CDT)
Received: from dlee73.ent.ti.com (localhost [127.0.0.1])
	by dlep26.itg.ti.com (8.13.8/8.13.8) with ESMTP id o4JGihG7013188
	for <linux-media@vger.kernel.org>; Wed, 19 May 2010 11:44:44 -0500 (CDT)
From: <asheeshb@ti.com>
To: <linux-media@vger.kernel.org>
CC: Asheesh Bhardwaj <asheeshb@ti.com>
Subject: [PATCH 2/7] Patch for adding imagesize corrected for MMAP buffers
Date: Wed, 19 May 2010 11:44:33 -0500
Message-ID: <1274287478-14661-3-git-send-email-asheeshb@ti.com>
In-Reply-To: <1274287478-14661-2-git-send-email-asheeshb@ti.com>
References: <1274287478-14661-1-git-send-email-asheeshb@ti.com>
 <1274287478-14661-2-git-send-email-asheeshb@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Asheesh Bhardwaj <asheeshb@ti.com>

Behave the same as user allocated buffers. The sizeimage parameter is giving
the wrong size from the driver and it has to be corrected in S_FMT and TRY_FMT
ioctls.
---
 drivers/media/video/davinci/vpif_display.c |   23 ++++++++---------------
 1 files changed, 8 insertions(+), 15 deletions(-)

diff --git a/drivers/media/video/davinci/vpif_display.c b/drivers/media/video/davinci/vpif_display.c
index e10f7c5..a206980 100644
--- a/drivers/media/video/davinci/vpif_display.c
+++ b/drivers/media/video/davinci/vpif_display.c
@@ -151,7 +151,8 @@ static int vpif_buffer_prepare(struct videobuf_queue *q,
 	if (VIDEOBUF_NEEDS_INIT == vb->state) {
 		vb->width	= common->width;
 		vb->height	= common->height;
-		vb->size	= vb->width * vb->height;
+		/* Updating the size based on the application requirement */
+                vb->size        = common->fmt.fmt.pix.sizeimage;
 		vb->field	= field;
 
 		ret = videobuf_iolock(q, vb, NULL);
@@ -440,11 +441,8 @@ static void vpif_calculate_offsets(struct channel_obj *ch)
 	} else {
 		vid_ch->buf_field = common->fmt.fmt.pix.field;
 	}
-
-	if (V4L2_MEMORY_USERPTR == common->memory)
-		sizeimage = common->fmt.fmt.pix.sizeimage;
-	else
-		sizeimage = config_params.channel_bufsize[ch->channel_id];
+	
+        sizeimage = common->fmt.fmt.pix.sizeimage;
 
 	hpitch = common->fmt.fmt.pix.bytesperline;
 	vpitch = sizeimage / (hpitch * 2);
@@ -520,11 +518,9 @@ static int vpif_check_format(struct channel_obj *ch,
 
 	if (pixfmt->bytesperline <= 0)
 		goto invalid_pitch_exit;
-
-	if (V4L2_MEMORY_USERPTR == common->memory)
-		sizeimage = pixfmt->sizeimage;
-	else
-		sizeimage = config_params.channel_bufsize[ch->channel_id];
+	
+        /* sizeimage is same for both MMAP and user allocated buffers, the size is updated for mmap buffers*/
+        sizeimage = pixfmt->sizeimage;
 
 	if (vpif_get_std_info(ch)) {
 		vpif_err("Error getting the standard info\n");
@@ -1067,10 +1063,7 @@ static int vpif_streamon(struct file *file, void *priv,
 		goto streamon_exit;
 	}
 
-	if (common->memory == V4L2_MEMORY_MMAP)
-		sizeimage = config_params.channel_bufsize[ch->channel_id];
-	else
-		sizeimage = common->fmt.fmt.pix.sizeimage;
+	sizeimage = common->fmt.fmt.pix.sizeimage;
 
 	if ((ch->vpifparams.std_info.width *
 		ch->vpifparams.std_info.height * 2) >
-- 
1.6.3.3

