Return-path: <linux-media-owner@vger.kernel.org>
Received: from devils.ext.ti.com ([198.47.26.153]:58292 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752943Ab1IZL70 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 26 Sep 2011 07:59:26 -0400
From: Archit Taneja <archit@ti.com>
To: <hvaibhav@ti.com>
CC: <tomi.valkeinen@ti.com>, <linux-omap@vger.kernel.org>,
	<sumit.semwal@ti.com>, <linux-media@vger.kernel.org>,
	Archit Taneja <archit@ti.com>
Subject: [PATCH v3 2/4] OMAP_VOUT: CLEANUP: Remove redundant code from omap_vout_isr
Date: Mon, 26 Sep 2011 17:29:23 +0530
Message-ID: <1317038365-30650-3-git-send-email-archit@ti.com>
In-Reply-To: <1317038365-30650-1-git-send-email-archit@ti.com>
References: <1317038365-30650-1-git-send-email-archit@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Currently, there is a lot of redundant code is between DPI and VENC panels, this
can be made common by moving out field/interlace specific code to a separate
function called omapvid_handle_interlace_display(). There is no functional
change made.

Signed-off-by: Archit Taneja <archit@ti.com>
---
 drivers/media/video/omap/omap_vout.c |  172 ++++++++++++++++------------------
 1 files changed, 82 insertions(+), 90 deletions(-)

diff --git a/drivers/media/video/omap/omap_vout.c b/drivers/media/video/omap/omap_vout.c
index 16ebff6..01c24a4 100644
--- a/drivers/media/video/omap/omap_vout.c
+++ b/drivers/media/video/omap/omap_vout.c
@@ -524,10 +524,50 @@ static int omapvid_apply_changes(struct omap_vout_device *vout)
 	return 0;
 }
 
+static int omapvid_handle_interlace_display(struct omap_vout_device *vout,
+		unsigned int irqstatus, struct timeval timevalue)
+{
+	u32 fid;
+
+	if (vout->first_int) {
+		vout->first_int = 0;
+		goto err;
+	}
+
+	if (irqstatus & DISPC_IRQ_EVSYNC_ODD)
+		fid = 1;
+	else if (irqstatus & DISPC_IRQ_EVSYNC_EVEN)
+		fid = 0;
+	else
+		goto err;
+
+	vout->field_id ^= 1;
+	if (fid != vout->field_id) {
+		if (fid == 0)
+			vout->field_id = fid;
+	} else if (0 == fid) {
+		if (vout->cur_frm == vout->next_frm)
+			goto err;
+
+		vout->cur_frm->ts = timevalue;
+		vout->cur_frm->state = VIDEOBUF_DONE;
+		wake_up_interruptible(&vout->cur_frm->done);
+		vout->cur_frm = vout->next_frm;
+	} else {
+		if (list_empty(&vout->dma_queue) ||
+				(vout->cur_frm != vout->next_frm))
+			goto err;
+	}
+
+	return vout->field_id;
+err:
+	return 0;
+}
+
 static void omap_vout_isr(void *arg, unsigned int irqstatus)
 {
-	int ret;
-	u32 addr, fid;
+	int ret, fid;
+	u32 addr;
 	struct omap_overlay *ovl;
 	struct timeval timevalue;
 	struct omapvideo_info *ovid;
@@ -548,107 +588,59 @@ static void omap_vout_isr(void *arg, unsigned int irqstatus)
 	spin_lock(&vout->vbq_lock);
 	do_gettimeofday(&timevalue);
 
-	if (cur_display->type != OMAP_DISPLAY_TYPE_VENC) {
-		switch (cur_display->type) {
-		case OMAP_DISPLAY_TYPE_DPI:
-			if (!(irqstatus & (DISPC_IRQ_VSYNC | DISPC_IRQ_VSYNC2)))
-				goto vout_isr_err;
-			break;
-		case OMAP_DISPLAY_TYPE_HDMI:
-			if (!(irqstatus & DISPC_IRQ_EVSYNC_EVEN))
-				goto vout_isr_err;
-			break;
-		default:
+	switch (cur_display->type) {
+	case OMAP_DISPLAY_TYPE_DPI:
+		if (!(irqstatus & (DISPC_IRQ_VSYNC | DISPC_IRQ_VSYNC2)))
 			goto vout_isr_err;
-		}
-		if (!vout->first_int && (vout->cur_frm != vout->next_frm)) {
-			vout->cur_frm->ts = timevalue;
-			vout->cur_frm->state = VIDEOBUF_DONE;
-			wake_up_interruptible(&vout->cur_frm->done);
-			vout->cur_frm = vout->next_frm;
-		}
-		vout->first_int = 0;
-		if (list_empty(&vout->dma_queue))
+		break;
+	case OMAP_DISPLAY_TYPE_VENC:
+		fid = omapvid_handle_interlace_display(vout, irqstatus,
+				timevalue);
+		if (!fid)
 			goto vout_isr_err;
+		break;
+	case OMAP_DISPLAY_TYPE_HDMI:
+		if (!(irqstatus & DISPC_IRQ_EVSYNC_EVEN))
+			goto vout_isr_err;
+		break;
+	default:
+		goto vout_isr_err;
+	}
 
-		vout->next_frm = list_entry(vout->dma_queue.next,
-				struct videobuf_buffer, queue);
-		list_del(&vout->next_frm->queue);
-
-		vout->next_frm->state = VIDEOBUF_ACTIVE;
-
-		addr = (unsigned long) vout->queued_buf_addr[vout->next_frm->i]
-			+ vout->cropped_offset;
+	if (!vout->first_int && (vout->cur_frm != vout->next_frm)) {
+		vout->cur_frm->ts = timevalue;
+		vout->cur_frm->state = VIDEOBUF_DONE;
+		wake_up_interruptible(&vout->cur_frm->done);
+		vout->cur_frm = vout->next_frm;
+	}
 
-		/* First save the configuration in ovelray structure */
-		ret = omapvid_init(vout, addr);
-		if (ret)
-			printk(KERN_ERR VOUT_NAME
-				"failed to set overlay info\n");
-		/* Enable the pipeline and set the Go bit */
-		ret = omapvid_apply_changes(vout);
-		if (ret)
-			printk(KERN_ERR VOUT_NAME "failed to change mode\n");
-	} else {
+	vout->first_int = 0;
+	if (list_empty(&vout->dma_queue))
+		goto vout_isr_err;
 
-		if (vout->first_int) {
-			vout->first_int = 0;
-			goto vout_isr_err;
-		}
-		if (irqstatus & DISPC_IRQ_EVSYNC_ODD)
-			fid = 1;
-		else if (irqstatus & DISPC_IRQ_EVSYNC_EVEN)
-			fid = 0;
-		else
-			goto vout_isr_err;
+	vout->next_frm = list_entry(vout->dma_queue.next,
+			struct videobuf_buffer, queue);
+	list_del(&vout->next_frm->queue);
 
-		vout->field_id ^= 1;
-		if (fid != vout->field_id) {
-			if (0 == fid)
-				vout->field_id = fid;
+	vout->next_frm->state = VIDEOBUF_ACTIVE;
 
-			goto vout_isr_err;
-		}
-		if (0 == fid) {
-			if (vout->cur_frm == vout->next_frm)
-				goto vout_isr_err;
-
-			vout->cur_frm->ts = timevalue;
-			vout->cur_frm->state = VIDEOBUF_DONE;
-			wake_up_interruptible(&vout->cur_frm->done);
-			vout->cur_frm = vout->next_frm;
-		} else if (1 == fid) {
-			if (list_empty(&vout->dma_queue) ||
-					(vout->cur_frm != vout->next_frm))
-				goto vout_isr_err;
-
-			vout->next_frm = list_entry(vout->dma_queue.next,
-					struct videobuf_buffer, queue);
-			list_del(&vout->next_frm->queue);
-
-			vout->next_frm->state = VIDEOBUF_ACTIVE;
-			addr = (unsigned long)
-				vout->queued_buf_addr[vout->next_frm->i] +
-				vout->cropped_offset;
-			/* First save the configuration in ovelray structure */
-			ret = omapvid_init(vout, addr);
-			if (ret)
-				printk(KERN_ERR VOUT_NAME
-						"failed to set overlay info\n");
-			/* Enable the pipeline and set the Go bit */
-			ret = omapvid_apply_changes(vout);
-			if (ret)
-				printk(KERN_ERR VOUT_NAME
-						"failed to change mode\n");
-		}
+	addr = (unsigned long) vout->queued_buf_addr[vout->next_frm->i]
+		+ vout->cropped_offset;
 
-	}
+	/* First save the configuration in ovelray structure */
+	ret = omapvid_init(vout, addr);
+	if (ret)
+		printk(KERN_ERR VOUT_NAME
+			"failed to set overlay info\n");
+	/* Enable the pipeline and set the Go bit */
+	ret = omapvid_apply_changes(vout);
+	if (ret)
+		printk(KERN_ERR VOUT_NAME "failed to change mode\n");
 
 vout_isr_err:
 	spin_unlock(&vout->vbq_lock);
 }
 
-
 /* Video buffer call backs */
 
 /*
-- 
1.7.1

