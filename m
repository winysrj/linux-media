Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr19.xs4all.nl ([194.109.24.39]:2296 "EHLO
	smtp-vbr19.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751869Ab2KPQDt (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 16 Nov 2012 11:03:49 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Prabhakar Lad <prabhakar.csengg@gmail.com>,
	DLOS <davinci-linux-open-source@linux.davincidsp.com>,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [RFCv1 PATCH 1/2] vpif_capture: protect dma_queue by a spin_lock.
Date: Fri, 16 Nov 2012 17:03:06 +0100
Message-Id: <4d1abc522b7eb1d930105a1f37085324b86ec69c.1353081640.git.hans.verkuil@cisco.com>
In-Reply-To: <1353081787-7010-1-git-send-email-hverkuil@xs4all.nl>
References: <1353081787-7010-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

The dma_queue list is accessed by both the interrupt handler and by normal
code. It needs to be protected by a lock to prevent possible list corruption.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/platform/davinci/vpif_capture.c |   26 ++++++++++++++++++++++---
 1 file changed, 23 insertions(+), 3 deletions(-)

diff --git a/drivers/media/platform/davinci/vpif_capture.c b/drivers/media/platform/davinci/vpif_capture.c
index fcabc02..f4f15f1 100644
--- a/drivers/media/platform/davinci/vpif_capture.c
+++ b/drivers/media/platform/davinci/vpif_capture.c
@@ -201,13 +201,16 @@ static void vpif_buffer_queue(struct vb2_buffer *vb)
 	struct vpif_cap_buffer *buf = container_of(vb,
 				struct vpif_cap_buffer, vb);
 	struct common_obj *common;
+	unsigned long flags;
 
 	common = &ch->common[VPIF_VIDEO_INDEX];
 
 	vpif_dbg(2, debug, "vpif_buffer_queue\n");
 
+	spin_lock_irqsave(&common->irqlock, flags);
 	/* add the buffer to the DMA queue */
 	list_add_tail(&buf->list, &common->dma_queue);
+	spin_unlock_irqrestore(&common->irqlock, flags);
 }
 
 /**
@@ -278,10 +281,13 @@ static int vpif_start_streaming(struct vb2_queue *vq, unsigned int count)
 	struct common_obj *common = &ch->common[VPIF_VIDEO_INDEX];
 	struct vpif_params *vpif = &ch->vpifparams;
 	unsigned long addr = 0;
+	unsigned long flags;
 	int ret;
 
-		/* If buffer queue is empty, return error */
+	/* If buffer queue is empty, return error */
+	spin_lock_irqsave(&common->irqlock, flags);
 	if (list_empty(&common->dma_queue)) {
+		spin_unlock_irqrestore(&common->irqlock, flags);
 		vpif_dbg(1, debug, "buffer queue is empty\n");
 		return -EIO;
 	}
@@ -291,6 +297,7 @@ static int vpif_start_streaming(struct vb2_queue *vq, unsigned int count)
 				    struct vpif_cap_buffer, list);
 	/* Remove buffer from the buffer queue */
 	list_del(&common->cur_frm->list);
+	spin_unlock_irqrestore(&common->irqlock, flags);
 	/* Mark state of the current frame to active */
 	common->cur_frm->vb.state = VB2_BUF_STATE_ACTIVE;
 	/* Initialize field_id and started member */
@@ -362,6 +369,7 @@ static int vpif_stop_streaming(struct vb2_queue *vq)
 	struct vpif_fh *fh = vb2_get_drv_priv(vq);
 	struct channel_obj *ch = fh->channel;
 	struct common_obj *common;
+	unsigned long flags;
 
 	if (!vb2_is_streaming(vq))
 		return 0;
@@ -369,12 +377,14 @@ static int vpif_stop_streaming(struct vb2_queue *vq)
 	common = &ch->common[VPIF_VIDEO_INDEX];
 
 	/* release all active buffers */
+	spin_lock_irqsave(&common->irqlock, flags);
 	while (!list_empty(&common->dma_queue)) {
 		common->next_frm = list_entry(common->dma_queue.next,
 						struct vpif_cap_buffer, list);
 		list_del(&common->next_frm->list);
 		vb2_buffer_done(&common->next_frm->vb, VB2_BUF_STATE_ERROR);
 	}
+	spin_unlock_irqrestore(&common->irqlock, flags);
 
 	return 0;
 }
@@ -420,10 +430,12 @@ static void vpif_schedule_next_buffer(struct common_obj *common)
 {
 	unsigned long addr = 0;
 
+	spin_lock(&common->irqlock);
 	common->next_frm = list_entry(common->dma_queue.next,
 				     struct vpif_cap_buffer, list);
 	/* Remove that buffer from the buffer queue */
 	list_del(&common->next_frm->list);
+	spin_unlock(&common->irqlock);
 	common->next_frm->vb.state = VB2_BUF_STATE_ACTIVE;
 	addr = vb2_dma_contig_plane_dma_addr(&common->next_frm->vb, 0);
 
@@ -468,8 +480,12 @@ static irqreturn_t vpif_channel_isr(int irq, void *dev_id)
 		/* Check the field format */
 		if (1 == ch->vpifparams.std_info.frm_fmt) {
 			/* Progressive mode */
-			if (list_empty(&common->dma_queue))
+			spin_lock(&common->irqlock);
+			if (list_empty(&common->dma_queue)) {
+				spin_unlock(&common->irqlock);
 				continue;
+			}
+			spin_unlock(&common->irqlock);
 
 			if (!channel_first_int[i][channel_id])
 				vpif_process_buffer_complete(common);
@@ -513,9 +529,13 @@ static irqreturn_t vpif_channel_isr(int irq, void *dev_id)
 				vpif_process_buffer_complete(common);
 			} else if (1 == fid) {
 				/* odd field */
+				spin_lock(&common->irqlock);
 				if (list_empty(&common->dma_queue) ||
-				    (common->cur_frm != common->next_frm))
+				    (common->cur_frm != common->next_frm)) {
+					spin_unlock(&common->irqlock);
 					continue;
+				}
+				spin_unlock(&common->irqlock);
 
 				vpif_schedule_next_buffer(common);
 			}
-- 
1.7.10.4

