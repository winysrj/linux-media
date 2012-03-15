Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ee0-f46.google.com ([74.125.83.46]:45132 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750992Ab2COSNe (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 15 Mar 2012 14:13:34 -0400
Received: by eekc41 with SMTP id c41so1823323eek.19
        for <linux-media@vger.kernel.org>; Thu, 15 Mar 2012 11:13:33 -0700 (PDT)
Message-ID: <1331835211.14662.5.camel@flow>
Subject: [PATCH] [media] V4L: pxa_camera: add clk_prepare/clk_unprepare calls
From: Philipp Zabel <philipp.zabel@gmail.com>
To: linux-media@vger.kernel.org
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Robert Jarzmik <robert.jarzmik@free.fr>
Date: Thu, 15 Mar 2012 19:13:31 +0100
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch adds clk_prepare/clk_unprepare calls to the pxa_camera
driver by using the helper functions clk_prepare_enable and
clk_disable_unprepare.

Signed-off-by: Philipp Zabel <philipp.zabel@gmail.com>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: Robert Jarzmik <robert.jarzmik@free.fr>
---
 drivers/media/video/pxa_camera.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/media/video/pxa_camera.c b/drivers/media/video/pxa_camera.c
index 0bd7da2..5a413f4 100644
--- a/drivers/media/video/pxa_camera.c
+++ b/drivers/media/video/pxa_camera.c
@@ -921,12 +921,12 @@ static void pxa_camera_activate(struct pxa_camera_dev *pcdev)
 		/* "Safe default" - 13MHz */
 		recalculate_fifo_timeout(pcdev, 13000000);
 
-	clk_enable(pcdev->clk);
+	clk_prepare_enable(pcdev->clk);
 }
 
 static void pxa_camera_deactivate(struct pxa_camera_dev *pcdev)
 {
-	clk_disable(pcdev->clk);
+	clk_disable_unprepare(pcdev->clk);
 }
 
 static irqreturn_t pxa_camera_irq(int irq, void *data)
-- 
1.7.9.1


