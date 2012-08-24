Return-path: <linux-media-owner@vger.kernel.org>
Received: from oproxy6-pub.bluehost.com ([67.222.54.6]:53463 "HELO
	oproxy6-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755831Ab2HXPy3 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 24 Aug 2012 11:54:29 -0400
From: Federico Fuga <fuga@studiofuga.com>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: linux-media@vger.kernel.org, Federico Fuga <fuga@studiofuga.com>
Subject: [PATCH] Corrected Oops on omap_vout when no manager is connected
Date: Fri, 24 Aug 2012 17:54:11 +0200
Message-Id: <1345823651-19800-1-git-send-email-fuga@studiofuga.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

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

