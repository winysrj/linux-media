Return-path: <linux-media-owner@vger.kernel.org>
Received: from arroyo.ext.ti.com ([192.94.94.40]:35253 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751138AbZFVLIV (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 22 Jun 2009 07:08:21 -0400
From: Chaithrika U S <chaithrika@ti.com>
To: linux-media@vger.kernel.org
Cc: davinci-linux-open-source@linux.davincidsp.com, hverkuil@xs4all.nl,
	Chaithrika U S <chaithrika@ti.com>
Subject: [PATCH] ARM: DaVinci: DM646x Video: Fix compile time warnings for mutex locking
Date: Mon, 22 Jun 2009 06:25:12 -0400
Message-Id: <1245666312-31388-1-git-send-email-chaithrika@ti.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

mutex_lock_interruptible return value has to be handled properly to indicate
the status to the higher layers of the kernel.

Signed-off-by: Chaithrika U S <chaithrika@ti.com>
---
Applies to v4l-dvb-dm646x repo maintained by Hans Verkuil
at http://linuxtv.org/hg/~hverkuil/v4l-dvb-dm646x/

 drivers/media/video/davinci/vpif_display.c |   31 ++++++++++++++++++++-------
 1 files changed, 23 insertions(+), 8 deletions(-)

diff --git a/drivers/media/video/davinci/vpif_display.c b/drivers/media/video/davinci/vpif_display.c
index 5e2b86b..969d4b3 100644
--- a/drivers/media/video/davinci/vpif_display.c
+++ b/drivers/media/video/davinci/vpif_display.c
@@ -636,7 +636,9 @@ static int vpif_release(struct file *filep)
 	struct channel_obj *ch = fh->channel;
 	struct common_obj *common = &ch->common[VPIF_VIDEO_INDEX];
 
-	mutex_lock_interruptible(&common->lock);
+	if (mutex_lock_interruptible(&common->lock))
+		return -ERESTARTSYS;
+
 	/* if this instance is doing IO */
 	if (fh->io_allowed[VPIF_VIDEO_INDEX]) {
 		/* Reset io_usrs member of channel object */
@@ -720,7 +722,9 @@ static int vpif_g_fmt_vid_out(struct file *file, void *priv,
 		return -EINVAL;
 
 	/* Fill in the information about format */
-	mutex_lock_interruptible(&common->lock);
+	if (mutex_lock_interruptible(&common->lock))
+		return -ERESTARTSYS;
+
 	if (vpif_get_std_info(ch)) {
 		vpif_err("Error getting the standard info\n");
 		return -EINVAL;
@@ -768,7 +772,9 @@ static int vpif_s_fmt_vid_out(struct file *file, void *priv,
 	/* store the pix format in the channel object */
 	common->fmt.fmt.pix = *pixfmt;
 	/* store the format in the channel object */
-	mutex_lock_interruptible(&common->lock);
+	if (mutex_lock_interruptible(&common->lock))
+		return -ERESTARTSYS;
+
 	common->fmt = *fmt;
 	mutex_unlock(&common->lock);
 
@@ -819,7 +825,9 @@ static int vpif_reqbufs(struct file *file, void *priv,
 	index = VPIF_VIDEO_INDEX;
 
 	common = &ch->common[index];
-	mutex_lock_interruptible(&common->lock);
+	if (mutex_lock_interruptible(&common->lock))
+		return -ERESTARTSYS;
+
 	if (common->fmt.type != reqbuf->type) {
 		ret = -EINVAL;
 		goto reqbuf_exit;
@@ -979,7 +987,8 @@ static int vpif_s_std(struct file *file, void *priv, v4l2_std_id *std_id)
 	}
 
 	/* Call encoder subdevice function to set the standard */
-	mutex_lock_interruptible(&common->lock);
+	if (mutex_lock_interruptible(&common->lock))
+		return -ERESTARTSYS;
 
 	ch->video.stdid = *std_id;
 	/* Get the information about the standard */
@@ -1085,7 +1094,9 @@ static int vpif_streamon(struct file *file, void *priv,
 		return ret;
 	}
 
-	mutex_lock_interruptible(&common->lock);
+	if (mutex_lock_interruptible(&common->lock))
+		return -ERESTARTSYS;
+
 	/* If buffer queue is empty, return error */
 	if (list_empty(&common->dma_queue)) {
 		vpif_err("buffer queue is empty\n");
@@ -1185,7 +1196,9 @@ static int vpif_streamoff(struct file *file, void *priv,
 		return -EINVAL;
 	}
 
-	mutex_lock_interruptible(&common->lock);
+	if (mutex_lock_interruptible(&common->lock))
+		return -ERESTARTSYS;
+
 	if (buftype == V4L2_BUF_TYPE_VIDEO_OUTPUT) {
 		/* disable channel */
 		if (VPIF_CHANNEL2_VIDEO == ch->channel_id) {
@@ -1248,7 +1261,9 @@ static int vpif_s_output(struct file *file, void *priv, unsigned int i)
 	struct common_obj *common = &ch->common[VPIF_VIDEO_INDEX];
 	int ret = 0;
 
-	mutex_lock_interruptible(&common->lock);
+	if (mutex_lock_interruptible(&common->lock))
+		return -ERESTARTSYS;
+
 	if (common->started) {
 		vpif_err("Streaming in progress\n");
 		ret = -EBUSY;
-- 
1.5.6

