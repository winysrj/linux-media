Return-path: <linux-media-owner@vger.kernel.org>
Received: from arroyo.ext.ti.com ([192.94.94.40]:40590 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752572Ab2AYPFl (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 25 Jan 2012 10:05:41 -0500
Received: from dbdp20.itg.ti.com ([172.24.170.38])
	by arroyo.ext.ti.com (8.13.7/8.13.7) with ESMTP id q0PF5dGM020856
	for <linux-media@vger.kernel.org>; Wed, 25 Jan 2012 09:05:40 -0600
From: Manjunath Hadli <manjunath.hadli@ti.com>
To: LMML <linux-media@vger.kernel.org>
CC: dlos <davinci-linux-open-source@linux.davincidsp.com>,
	Manjunath Hadli <manjunath.hadli@ti.com>
Subject: [PATCH 3/4] davinci: vpif: make request_irq flags as shared
Date: Wed, 25 Jan 2012 20:35:33 +0530
Message-ID: <1327503934-28186-4-git-send-email-manjunath.hadli@ti.com>
In-Reply-To: <1327503934-28186-1-git-send-email-manjunath.hadli@ti.com>
References: <1327503934-28186-1-git-send-email-manjunath.hadli@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

omap-l138 shares the interrupt between capture and display.
Make sure we are able to request for the same irq number
by making a shared irq request.

Signed-off-by: Manjunath Hadli <manjunath.hadli@ti.com>
---
 drivers/media/video/davinci/vpif_capture.c |    2 +-
 drivers/media/video/davinci/vpif_display.c |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/media/video/davinci/vpif_capture.c b/drivers/media/video/davinci/vpif_capture.c
index 010cce4..ad933e0 100644
--- a/drivers/media/video/davinci/vpif_capture.c
+++ b/drivers/media/video/davinci/vpif_capture.c
@@ -2191,7 +2191,7 @@ static __init int vpif_probe(struct platform_device *pdev)
 	k = 0;
 	while ((res = platform_get_resource(pdev, IORESOURCE_IRQ, k))) {
 		for (i = res->start; i <= res->end; i++) {
-			if (request_irq(i, vpif_channel_isr, IRQF_DISABLED,
+			if (request_irq(i, vpif_channel_isr, IRQF_SHARED,
 					"VPIF_Capture",
 				(void *)(&vpif_obj.dev[k]->channel_id))) {
 				err = -EBUSY;
diff --git a/drivers/media/video/davinci/vpif_display.c b/drivers/media/video/davinci/vpif_display.c
index 6f3eabb..c876c10 100644
--- a/drivers/media/video/davinci/vpif_display.c
+++ b/drivers/media/video/davinci/vpif_display.c
@@ -1713,7 +1713,7 @@ static __init int vpif_probe(struct platform_device *pdev)
 	k = 0;
 	while ((res = platform_get_resource(pdev, IORESOURCE_IRQ, k))) {
 		for (i = res->start; i <= res->end; i++) {
-			if (request_irq(i, vpif_channel_isr, IRQF_DISABLED,
+			if (request_irq(i, vpif_channel_isr, IRQF_SHARED,
 					"VPIF_Display",
 				(void *)(&vpif_obj.dev[k]->channel_id))) {
 				err = -EBUSY;
-- 
1.6.2.4

