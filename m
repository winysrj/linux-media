Return-path: <mchehab@pedra>
Received: from bear.ext.ti.com ([192.94.94.41]:55060 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753902Ab1FGOrr (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 7 Jun 2011 10:47:47 -0400
Received: from dlep36.itg.ti.com ([157.170.170.91])
	by bear.ext.ti.com (8.13.7/8.13.7) with ESMTP id p57ElkK3013475
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-media@vger.kernel.org>; Tue, 7 Jun 2011 09:47:46 -0500
Received: from dlep26.itg.ti.com (smtp-le.itg.ti.com [157.170.170.27])
	by dlep36.itg.ti.com (8.13.8/8.13.8) with ESMTP id p57ElkE1022426
	for <linux-media@vger.kernel.org>; Tue, 7 Jun 2011 09:47:46 -0500 (CDT)
From: Amber Jain <amber@ti.com>
To: <linux-media@vger.kernel.org>
CC: <hvaibhav@ti.com>, <sumit.semwal@ti.com>, Amber Jain <amber@ti.com>
Subject: [PATCH 1/6] V4L2: OMAP: VOUT: isr handling extended for DPI and HDMI interface
Date: Tue, 7 Jun 2011 20:17:33 +0530
Message-ID: <1307458058-29030-2-git-send-email-amber@ti.com>
In-Reply-To: <1307458058-29030-1-git-send-email-amber@ti.com>
References: <1307458058-29030-1-git-send-email-amber@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Extending the omap vout isr handling for:
- secondary lcd over DPI interface,
- HDMI interface.

Signed-off-by: Amber Jain <amber@ti.com>
---
 drivers/media/video/omap/omap_vout.c |   26 +++++++++++++++++++-------
 1 files changed, 19 insertions(+), 7 deletions(-)

diff --git a/drivers/media/video/omap/omap_vout.c b/drivers/media/video/omap/omap_vout.c
index a831241..6fe7efa 100644
--- a/drivers/media/video/omap/omap_vout.c
+++ b/drivers/media/video/omap/omap_vout.c
@@ -544,10 +544,20 @@ void omap_vout_isr(void *arg, unsigned int irqstatus)
 
 	spin_lock(&vout->vbq_lock);
 	do_gettimeofday(&timevalue);
-	if (cur_display->type == OMAP_DISPLAY_TYPE_DPI) {
-		if (!(irqstatus & DISPC_IRQ_VSYNC))
-			goto vout_isr_err;
 
+	if (cur_display->type != OMAP_DISPLAY_TYPE_VENC) {
+		switch (cur_display->type) {
+		case OMAP_DISPLAY_TYPE_DPI:
+			if (!(irqstatus & (DISPC_IRQ_VSYNC | DISPC_IRQ_VSYNC2)))
+				goto vout_isr_err;
+			break;
+		case OMAP_DISPLAY_TYPE_HDMI:
+			if (!(irqstatus & DISPC_IRQ_EVSYNC_EVEN))
+				goto vout_isr_err;
+			break;
+		default:
+			goto vout_isr_err;
+		}
 		if (!vout->first_int && (vout->cur_frm != vout->next_frm)) {
 			vout->cur_frm->ts = timevalue;
 			vout->cur_frm->state = VIDEOBUF_DONE;
@@ -571,7 +581,7 @@ void omap_vout_isr(void *arg, unsigned int irqstatus)
 		ret = omapvid_init(vout, addr);
 		if (ret)
 			printk(KERN_ERR VOUT_NAME
-					"failed to set overlay info\n");
+				"failed to set overlay info\n");
 		/* Enable the pipeline and set the Go bit */
 		ret = omapvid_apply_changes(vout);
 		if (ret)
@@ -925,7 +935,7 @@ static int omap_vout_release(struct file *file)
 		u32 mask = 0;
 
 		mask = DISPC_IRQ_VSYNC | DISPC_IRQ_EVSYNC_EVEN |
-			DISPC_IRQ_EVSYNC_ODD;
+			DISPC_IRQ_EVSYNC_ODD | DISPC_IRQ_VSYNC2;
 		omap_dispc_unregister_isr(omap_vout_isr, vout, mask);
 		vout->streaming = 0;
 
@@ -1596,7 +1606,8 @@ static int vidioc_streamon(struct file *file, void *fh, enum v4l2_buf_type i)
 	addr = (unsigned long) vout->queued_buf_addr[vout->cur_frm->i]
 		+ vout->cropped_offset;
 
-	mask = DISPC_IRQ_VSYNC | DISPC_IRQ_EVSYNC_EVEN | DISPC_IRQ_EVSYNC_ODD;
+	mask = DISPC_IRQ_VSYNC | DISPC_IRQ_EVSYNC_EVEN | DISPC_IRQ_EVSYNC_ODD
+		| DISPC_IRQ_VSYNC2;
 
 	omap_dispc_register_isr(omap_vout_isr, vout, mask);
 
@@ -1646,7 +1657,8 @@ static int vidioc_streamoff(struct file *file, void *fh, enum v4l2_buf_type i)
 		return -EINVAL;
 
 	vout->streaming = 0;
-	mask = DISPC_IRQ_VSYNC | DISPC_IRQ_EVSYNC_EVEN | DISPC_IRQ_EVSYNC_ODD;
+	mask = DISPC_IRQ_VSYNC | DISPC_IRQ_EVSYNC_EVEN | DISPC_IRQ_EVSYNC_ODD
+		| DISPC_IRQ_VSYNC2;
 
 	omap_dispc_unregister_isr(omap_vout_isr, vout, mask);
 
-- 
1.7.1

