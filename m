Return-path: <mchehab@pedra>
Received: from mailout-de.gmx.net ([213.165.64.22]:41868 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1750762Ab0JTNOm (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 20 Oct 2010 09:14:42 -0400
Received: from lyakh (helo=localhost)
	by axis700.grange with local-esmtp (Exim 4.63)
	(envelope-from <g.liakhovetski@gmx.de>)
	id 1P8YVN-000089-8C
	for linux-media@vger.kernel.org; Wed, 20 Oct 2010 15:14:57 +0200
Date: Wed, 20 Oct 2010 15:14:57 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH] soc-camera: fix static build of the sh_mobile_csi2.c driver
Message-ID: <Pine.LNX.4.64.1010201513550.29312@axis700.grange>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

The test for driver->owner != NULL in sh_mobile_ceu_camera.c is unneeded and it
breaks the static build of sh_mobile_csi2.c. Remove it.

Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
---
 drivers/media/video/sh_mobile_ceu_camera.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/media/video/sh_mobile_ceu_camera.c b/drivers/media/video/sh_mobile_ceu_camera.c
index fdaadde..29374a5 100644
--- a/drivers/media/video/sh_mobile_ceu_camera.c
+++ b/drivers/media/video/sh_mobile_ceu_camera.c
@@ -1968,7 +1968,7 @@ static int __devinit sh_mobile_ceu_probe(struct platform_device *pdev)
 		 * we complete the completion.
 		 */
 
-		if (!csi2->driver || !csi2->driver->owner) {
+		if (!csi2->driver) {
 			complete(&wait.completion);
 			/* Either too late, or probing failed */
 			bus_unregister_notifier(&platform_bus_type, &wait.notifier);
-- 
1.7.1

