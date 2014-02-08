Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:53530 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751462AbaBHObT (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 8 Feb 2014 09:31:19 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: Tomi Valkeinen <tomi.valkeinen@ti.com>
Subject: [PATCH] omap_vout: Add DVI display type support
Date: Sat,  8 Feb 2014 15:32:15 +0100
Message-Id: <1391869935-10495-1-git-send-email-laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Since the introduction of the new OMAP DSS DVI connector driver in
commit 348077b154357eec595068a3336ef6beb870e6f3 ("OMAPDSS: Add new DVI
Connector driver"), DVI outputs report a new display type of
OMAP_DISPLAY_TYPE_DVI instead of OMAP_DISPLAY_TYPE_DPI. Handle the new
type in the IRQ handler.

Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 drivers/media/platform/omap/omap_vout.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/media/platform/omap/omap_vout.c b/drivers/media/platform/omap/omap_vout.c
index dfd0a21..9a726ea 100644
--- a/drivers/media/platform/omap/omap_vout.c
+++ b/drivers/media/platform/omap/omap_vout.c
@@ -601,6 +601,7 @@ static void omap_vout_isr(void *arg, unsigned int irqstatus)
 	switch (cur_display->type) {
 	case OMAP_DISPLAY_TYPE_DSI:
 	case OMAP_DISPLAY_TYPE_DPI:
+	case OMAP_DISPLAY_TYPE_DVI:
 		if (mgr_id == OMAP_DSS_CHANNEL_LCD)
 			irq = DISPC_IRQ_VSYNC;
 		else if (mgr_id == OMAP_DSS_CHANNEL_LCD2)
-- 
Regards,

Laurent Pinchart

