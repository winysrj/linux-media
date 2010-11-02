Return-path: <mchehab@gaivota>
Received: from d1.icnet.pl ([212.160.220.21]:55808 "EHLO d1.icnet.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753681Ab0KBPbP (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 2 Nov 2010 11:31:15 -0400
From: Janusz Krzysztofik <jkrzyszt@tis.icnet.pl>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Subject: [PATCH] SOC Camera: OMAP1: typo fix
Date: Tue, 2 Nov 2010 16:30:48 +0100
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <201011021630.49706.jkrzyszt@tis.icnet.pl>
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

Fix an outstanding typo in the recently added driver, as requested by 
the subsystem maintainer.

Created against linux-2.6.37-rc1.

Signed-off-by: Janusz Krzysztofik <jkrzyszt@tis.icnet.pl>
---

 drivers/media/video/omap1_camera.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- linux-2.6.37-rc1/drivers/media/video/omap1_camera.c.orig	2010-11-01 23:55:26.000000000 +0100
+++ linux-2.6.37-rc1/drivers/media/video/omap1_camera.c	2010-11-02 01:48:55.000000000 +0100
@@ -504,7 +504,7 @@ static void omap1_videobuf_queue(struct 
 		 * empty. Since the transfer of the DMA programming register set
 		 * content to the DMA working register set is done automatically
 		 * by the DMA hardware, this can pretty well happen while we
-		 * are keeping the lock here. Levae fetching it from the queue
+		 * are keeping the lock here. Leave fetching it from the queue
 		 * to be done when a next DMA interrupt occures instead.
 		 */
 		return;
