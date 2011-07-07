Return-path: <mchehab@localhost>
Received: from bear.ext.ti.com ([192.94.94.41]:39487 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755675Ab1GGMV0 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 7 Jul 2011 08:21:26 -0400
Received: from dlep33.itg.ti.com ([157.170.170.112])
	by bear.ext.ti.com (8.13.7/8.13.7) with ESMTP id p67CLQka028084
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-media@vger.kernel.org>; Thu, 7 Jul 2011 07:21:26 -0500
Received: from dlep26.itg.ti.com (smtp-le.itg.ti.com [157.170.170.27])
	by dlep33.itg.ti.com (8.13.7/8.13.8) with ESMTP id p67CLQsb006856
	for <linux-media@vger.kernel.org>; Thu, 7 Jul 2011 07:21:26 -0500 (CDT)
Received: from dlee73.ent.ti.com (localhost [127.0.0.1])
	by dlep26.itg.ti.com (8.13.8/8.13.8) with ESMTP id p67CLQI3007571
	for <linux-media@vger.kernel.org>; Thu, 7 Jul 2011 07:21:26 -0500 (CDT)
From: Amber Jain <amber@ti.com>
To: <linux-media@vger.kernel.org>
CC: hvaibhav@ti.com, Amber Jain <amber@ti.com>
Subject: [PATCH v2 1/3] V4L2: OMAP: VOUT: isr handling extended for DPI and HDMI interface
Date: Thu, 7 Jul 2011 17:51:16 +0530
Message-ID: <1310041278-8810-2-git-send-email-amber@ti.com>
In-Reply-To: <1310041278-8810-1-git-send-email-amber@ti.com>
References: <1310041278-8810-1-git-send-email-amber@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@infradead.org>

Extending the omap vout isr handling for:
- secondary lcd over DPI interface,
- HDMI interface.

These are the new interfaces added to OMAP4 DSS.

Signed-off-by: Amber Jain <amber@ti.com>
---
Changes from v1:
- updated commit message to mention that these changes are specifically
  for OMAP4.
 
 drivers/media/video/omap/omap_vout.c |   26 +++++++++++++++++++-------
 1 files changed, 19 insertions(+), 7 deletions(-)

diff --git a/drivers/media/video/omap/omap_vout.c b/drivers/media/video/omap/omap_vout.c
index 343b50c..6cd3622 100644
--- a/drivers/media/video/omap/omap_vout.c
+++ b/drivers/media/video/omap/omap_vout.c
@@ -546,10 +546,20 @@ static void omap_vout_isr(void *arg, unsigned int irqstatus)
 
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
@@ -573,7 +583,7 @@ static void omap_vout_isr(void *arg, unsigned int irqstatus)
 		ret = omapvid_init(vout, addr);
 		if (ret)
 			printk(KERN_ERR VOUT_NAME
-					"failed to set overlay info\n");
+				"failed to set overlay info\n");
 		/* Enable the pipeline and set the Go bit */
 		ret = omapvid_apply_changes(vout);
 		if (ret)
@@ -943,7 +953,7 @@ static int omap_vout_release(struct file *file)
 		u32 mask = 0;
 
 		mask = DISPC_IRQ_VSYNC | DISPC_IRQ_EVSYNC_EVEN |
-			DISPC_IRQ_EVSYNC_ODD;
+			DISPC_IRQ_EVSYNC_ODD | DISPC_IRQ_VSYNC2;
 		omap_dispc_unregister_isr(omap_vout_isr, vout, mask);
 		vout->streaming = 0;
 
@@ -1614,7 +1624,8 @@ static int vidioc_streamon(struct file *file, void *fh, enum v4l2_buf_type i)
 	addr = (unsigned long) vout->queued_buf_addr[vout->cur_frm->i]
 		+ vout->cropped_offset;
 
-	mask = DISPC_IRQ_VSYNC | DISPC_IRQ_EVSYNC_EVEN | DISPC_IRQ_EVSYNC_ODD;
+	mask = DISPC_IRQ_VSYNC | DISPC_IRQ_EVSYNC_EVEN | DISPC_IRQ_EVSYNC_ODD
+		| DISPC_IRQ_VSYNC2;
 
 	omap_dispc_register_isr(omap_vout_isr, vout, mask);
 
@@ -1664,7 +1675,8 @@ static int vidioc_streamoff(struct file *file, void *fh, enum v4l2_buf_type i)
 		return -EINVAL;
 
 	vout->streaming = 0;
-	mask = DISPC_IRQ_VSYNC | DISPC_IRQ_EVSYNC_EVEN | DISPC_IRQ_EVSYNC_ODD;
+	mask = DISPC_IRQ_VSYNC | DISPC_IRQ_EVSYNC_EVEN | DISPC_IRQ_EVSYNC_ODD
+		| DISPC_IRQ_VSYNC2;
 
 	omap_dispc_unregister_isr(omap_vout_isr, vout, mask);
 
-- 
1.7.1

