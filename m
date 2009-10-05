Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:34686 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1758524AbZJEIL4 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 5 Oct 2009 04:11:56 -0400
Received: from lyakh (helo=localhost)
	by axis700.grange with local-esmtp (Exim 4.63)
	(envelope-from <g.liakhovetski@gmx.de>)
	id 1Muif5-0001ME-2S
	for linux-media@vger.kernel.org; Mon, 05 Oct 2009 10:11:15 +0200
Date: Mon, 5 Oct 2009 10:11:15 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH] fix use-after-free Oops, resulting from a driver-core API
 change
Message-ID: <Pine.LNX.4.64.0910051005490.4337@axis700.grange>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Commit b4028437876866aba4747a655ede00f892089e14 has broken again re-use of 
device objects across device_register() / device_unregister() cycles. Fix 
soc-camera by nullifying the struct after device_unregister().

Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
---
diff --git a/drivers/media/video/soc_camera.c b/drivers/media/video/soc_camera.c
index 59aa7a3..36e617b 100644
--- a/drivers/media/video/soc_camera.c
+++ b/drivers/media/video/soc_camera.c
@@ -1160,13 +1160,15 @@ void soc_camera_host_unregister(struct soc_camera_host *ici)
 		if (icd->iface == ici->nr) {
 			/* The bus->remove will be called */
 			device_unregister(&icd->dev);
-			/* Not before device_unregister(), .remove
-			 * needs parent to call ici->ops->remove() */
-			icd->dev.parent = NULL;
-
-			/* If the host module is loaded again, device_register()
-			 * would complain "already initialised" */
-			memset(&icd->dev.kobj, 0, sizeof(icd->dev.kobj));
+			/*
+			 * Not before device_unregister(), .remove
+			 * needs parent to call ici->ops->remove().
+			 * If the host module is loaded again, device_register()
+			 * would complain "already initialised," since 2.6.32
+			 * this is also needed to prevent use-after-free of the
+			 * device private data.
+			 */
+			memset(&icd->dev, 0, sizeof(icd->dev));
 		}
 	}
 
