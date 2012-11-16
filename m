Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr8.xs4all.nl ([194.109.24.28]:1369 "EHLO
	smtp-vbr8.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752550Ab2KPQDu (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 16 Nov 2012 11:03:50 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Prabhakar Lad <prabhakar.csengg@gmail.com>,
	DLOS <davinci-linux-open-source@linux.davincidsp.com>,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [RFCv1 PATCH 2/2] vpif_display: protect dma_queue by a spin_lock.
Date: Fri, 16 Nov 2012 17:03:07 +0100
Message-Id: <efc928a057f0cbcf18cb5c844e4819bd5c450a5c.1353081640.git.hans.verkuil@cisco.com>
In-Reply-To: <1353081787-7010-1-git-send-email-hverkuil@xs4all.nl>
References: <1353081787-7010-1-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <4d1abc522b7eb1d930105a1f37085324b86ec69c.1353081640.git.hans.verkuil@cisco.com>
References: <4d1abc522b7eb1d930105a1f37085324b86ec69c.1353081640.git.hans.verkuil@cisco.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

The dma_queue list is accessed by both the interrupt handler and by normal
code. It needs to be protected by a lock to prevent possible list corruption.

Corruption has been observed in 'real-life' conditions. Adding this lock made
it go away.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/platform/davinci/vpif_display.c |   22 ++++++++++++++++++++--
 1 file changed, 20 insertions(+), 2 deletions(-)

diff --git a/drivers/media/platform/davinci/vpif_display.c b/drivers/media/platform/davinci/vpif_display.c
index b716fbd..a8c6bd3 100644
--- a/drivers/media/platform/davinci/vpif_display.c
+++ b/drivers/media/platform/davinci/vpif_display.c
@@ -177,11 +177,14 @@ static void vpif_buffer_queue(struct vb2_buffer *vb)
 				struct vpif_disp_buffer, vb);
 	struct channel_obj *ch = fh->channel;
 	struct common_obj *common;
+	unsigned long flags;
 
 	common = &ch->common[VPIF_VIDEO_INDEX];
 
 	/* add the buffer to the DMA queue */
+	spin_lock_irqsave(&common->irqlock, flags);
 	list_add_tail(&buf->list, &common->dma_queue);
+	spin_unlock_irqrestore(&common->irqlock, flags);
 }
 
 /*
@@ -246,10 +249,13 @@ static int vpif_start_streaming(struct vb2_queue *vq, unsigned int count)
 	struct common_obj *common = &ch->common[VPIF_VIDEO_INDEX];
 	struct vpif_params *vpif = &ch->vpifparams;
 	unsigned long addr = 0;
+	unsigned long flags;
 	int ret;
 
 	/* If buffer queue is empty, return error */
+	spin_lock_irqsave(&common->irqlock, flags);
 	if (list_empty(&common->dma_queue)) {
+		spin_unlock_irqrestore(&common->irqlock, flags);
 		vpif_err("buffer queue is empty\n");
 		return -EIO;
 	}
@@ -260,6 +266,7 @@ static int vpif_start_streaming(struct vb2_queue *vq, unsigned int count)
 				       struct vpif_disp_buffer, list);
 
 	list_del(&common->cur_frm->list);
+	spin_unlock_irqrestore(&common->irqlock, flags);
 	/* Mark state of the current frame to active */
 	common->cur_frm->vb.state = VB2_BUF_STATE_ACTIVE;
 
@@ -330,6 +337,7 @@ static int vpif_stop_streaming(struct vb2_queue *vq)
 	struct vpif_fh *fh = vb2_get_drv_priv(vq);
 	struct channel_obj *ch = fh->channel;
 	struct common_obj *common;
+	unsigned long flags;
 
 	if (!vb2_is_streaming(vq))
 		return 0;
@@ -337,12 +345,14 @@ static int vpif_stop_streaming(struct vb2_queue *vq)
 	common = &ch->common[VPIF_VIDEO_INDEX];
 
 	/* release all active buffers */
+	spin_lock_irqsave(&common->irqlock, flags);
 	while (!list_empty(&common->dma_queue)) {
 		common->next_frm = list_entry(common->dma_queue.next,
 						struct vpif_disp_buffer, list);
 		list_del(&common->next_frm->list);
 		vb2_buffer_done(&common->next_frm->vb, VB2_BUF_STATE_ERROR);
 	}
+	spin_unlock_irqrestore(&common->irqlock, flags);
 
 	return 0;
 }
@@ -363,11 +373,13 @@ static void process_progressive_mode(struct common_obj *common)
 {
 	unsigned long addr = 0;
 
+	spin_lock(&common->irqlock);
 	/* Get the next buffer from buffer queue */
 	common->next_frm = list_entry(common->dma_queue.next,
 				struct vpif_disp_buffer, list);
 	/* Remove that buffer from the buffer queue */
 	list_del(&common->next_frm->list);
+	spin_unlock(&common->irqlock);
 	/* Mark status of the buffer as active */
 	common->next_frm->vb.state = VB2_BUF_STATE_ACTIVE;
 
@@ -398,16 +410,18 @@ static void process_interlaced_mode(int fid, struct common_obj *common)
 		common->cur_frm = common->next_frm;
 
 	} else if (1 == fid) {	/* odd field */
+		spin_lock(&common->irqlock);
 		if (list_empty(&common->dma_queue)
 		    || (common->cur_frm != common->next_frm)) {
+			spin_unlock(&common->irqlock);
 			return;
 		}
+		spin_unlock(&common->irqlock);
 		/* one field is displayed configure the next
 		 * frame if it is available else hold on current
 		 * frame */
 		/* Get next from the buffer queue */
 		process_progressive_mode(common);
-
 	}
 }
 
@@ -437,8 +451,12 @@ static irqreturn_t vpif_channel_isr(int irq, void *dev_id)
 			continue;
 
 		if (1 == ch->vpifparams.std_info.frm_fmt) {
-			if (list_empty(&common->dma_queue))
+			spin_lock(&common->irqlock);
+			if (list_empty(&common->dma_queue)) {
+				spin_unlock(&common->irqlock);
 				continue;
+			}
+			spin_unlock(&common->irqlock);
 
 			/* Progressive mode */
 			if (!channel_first_int[i][channel_id]) {
-- 
1.7.10.4

