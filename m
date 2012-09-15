Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:2520 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750942Ab2IOQGi (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 15 Sep 2012 12:06:38 -0400
Date: Sat, 15 Sep 2012 13:06:33 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
To: Prabhakar Lad <prabhakar.lad@ti.com>
Cc: LMML <linux-media@vger.kernel.org>
Subject: Fw: [PATCH] Corrected Oops on omap_vout when no manager is
 connected
Message-ID: <20120915130633.01414d71@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Prabhakar,

Please review.

Thanks!
Mauro

Forwarded message:

Date: Fri, 24 Aug 2012 17:54:11 +0200
From: Federico Fuga <fuga@studiofuga.com>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: linux-media@vger.kernel.org, Federico Fuga <fuga@studiofuga.com>
Subject: [PATCH] Corrected Oops on omap_vout when no manager is connected


If no manager is connected to the vout device, the omapvid_init() function
fails. No error condition is checked, and the device is started. Later on,
when irq is serviced, a NULL pointer dereference occurs.
Also, the isr routine must be registered only if no error occurs, otherwise
the isr triggers without the proper setup, and the kernel oops again.
To prevent this, the error condition is checked, and the streamon function
exits with error. Also the isr registration call is moved after the setup
procedure is completed.
---
 drivers/media/video/omap/omap_vout.c |   14 ++++++++++----
 1 file changed, 10 insertions(+), 4 deletions(-)

diff --git a/drivers/media/video/omap/omap_vout.c b/drivers/media/video/omap/omap_vout.c
index 15c5f4d..f456587 100644
--- a/drivers/media/video/omap/omap_vout.c
+++ b/drivers/media/video/omap/omap_vout.c
@@ -650,9 +650,12 @@ static void omap_vout_isr(void *arg, unsigned int irqstatus)
 
 	/* First save the configuration in ovelray structure */
 	ret = omapvid_init(vout, addr);
-	if (ret)
+	if (ret) {
 		printk(KERN_ERR VOUT_NAME
 			"failed to set overlay info\n");
+		goto vout_isr_err;
+	}
+
 	/* Enable the pipeline and set the Go bit */
 	ret = omapvid_apply_changes(vout);
 	if (ret)
@@ -1678,13 +1681,16 @@ static int vidioc_streamon(struct file *file, void *fh, enum v4l2_buf_type i)
 	mask = DISPC_IRQ_VSYNC | DISPC_IRQ_EVSYNC_EVEN | DISPC_IRQ_EVSYNC_ODD
 		| DISPC_IRQ_VSYNC2;
 
-	omap_dispc_register_isr(omap_vout_isr, vout, mask);
-
 	/* First save the configuration in ovelray structure */
 	ret = omapvid_init(vout, addr);
-	if (ret)
+	if (ret) {
 		v4l2_err(&vout->vid_dev->v4l2_dev,
 				"failed to set overlay info\n");
+		goto streamon_err1;
+	}
+
+	omap_dispc_register_isr(omap_vout_isr, vout, mask);
+
 	/* Enable the pipeline and set the Go bit */
 	ret = omapvid_apply_changes(vout);
 	if (ret)
-- 
1.7.9.5

--
To unsubscribe from this list: send the line "unsubscribe linux-media" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html


-- 
Regards,
Mauro
