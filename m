Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pd0-f176.google.com ([209.85.192.176]:55519 "EHLO
	mail-pd0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753007Ab3EZMDL (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 26 May 2013 08:03:11 -0400
From: Prabhakar Lad <prabhakar.csengg@gmail.com>
To: Hans Verkuil <hans.verkuil@cisco.com>,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	LMML <linux-media@vger.kernel.org>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: DLOS <davinci-linux-open-source@linux.davincidsp.com>,
	LKML <linux-kernel@vger.kernel.org>,
	"Lad, Prabhakar" <prabhakar.csengg@gmail.com>
Subject: [PATCH v3 7/9] media: davinci: vpif_display: move the freeing of irq and global variables to remove()
Date: Sun, 26 May 2013 17:30:10 +0530
Message-Id: <1369569612-30915-8-git-send-email-prabhakar.csengg@gmail.com>
In-Reply-To: <1369569612-30915-1-git-send-email-prabhakar.csengg@gmail.com>
References: <1369569612-30915-1-git-send-email-prabhakar.csengg@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Lad, Prabhakar <prabhakar.csengg@gmail.com>

Ideally the freeing of irq's and the global variables needs to be
done in the remove() rather than module_exit(), this patch moves
the freeing up of irq's and freeing the memory allocated to channel
objects to remove() callback of struct platform_driver.

Signed-off-by: Lad, Prabhakar <prabhakar.csengg@gmail.com>
---
 drivers/media/platform/davinci/vpif_display.c |   32 +++++++++++--------------
 1 files changed, 14 insertions(+), 18 deletions(-)

diff --git a/drivers/media/platform/davinci/vpif_display.c b/drivers/media/platform/davinci/vpif_display.c
index 5b6f906..9c308e7 100644
--- a/drivers/media/platform/davinci/vpif_display.c
+++ b/drivers/media/platform/davinci/vpif_display.c
@@ -1894,11 +1894,23 @@ vpif_int_err:
  */
 static int vpif_remove(struct platform_device *device)
 {
+	struct platform_device *pdev;
 	struct channel_obj *ch;
-	int i;
+	struct resource *res;
+	int irq_num;
+	int i = 0;
+
+	pdev = container_of(vpif_dev, struct platform_device, dev);
+	while ((res = platform_get_resource(pdev, IORESOURCE_IRQ, i))) {
+		for (irq_num = res->start; irq_num <= res->end; irq_num++)
+			free_irq(irq_num,
+				 (void *)(&vpif_obj.dev[i]->channel_id));
+		i++;
+	}
 
 	v4l2_device_unregister(&vpif_obj.v4l2_dev);
 
+	kfree(vpif_obj.sd);
 	/* un-register device */
 	for (i = 0; i < VPIF_DISPLAY_MAX_DEVICES; i++) {
 		/* Get the pointer to the channel object */
@@ -1907,6 +1919,7 @@ static int vpif_remove(struct platform_device *device)
 		video_unregister_device(ch->video_dev);
 
 		ch->video_dev = NULL;
+		kfree(vpif_obj.dev[i]);
 	}
 
 	return 0;
@@ -2004,24 +2017,7 @@ static __init int vpif_init(void)
  */
 static void vpif_cleanup(void)
 {
-	struct platform_device *pdev;
-	struct resource *res;
-	int irq_num;
-	int i = 0;
-
-	pdev = container_of(vpif_dev, struct platform_device, dev);
-
-	while ((res = platform_get_resource(pdev, IORESOURCE_IRQ, i))) {
-		for (irq_num = res->start; irq_num <= res->end; irq_num++)
-			free_irq(irq_num,
-				 (void *)(&vpif_obj.dev[i]->channel_id));
-		i++;
-	}
-
 	platform_driver_unregister(&vpif_driver);
-	kfree(vpif_obj.sd);
-	for (i = 0; i < VPIF_DISPLAY_MAX_DEVICES; i++)
-		kfree(vpif_obj.dev[i]);
 }
 
 module_init(vpif_init);
-- 
1.7.0.4

