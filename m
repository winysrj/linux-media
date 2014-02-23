Return-path: <linux-media-owner@vger.kernel.org>
Received: from ns.pmeerw.net ([87.118.82.44]:43565 "EHLO pmeerw.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751260AbaBWRJD (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 23 Feb 2014 12:09:03 -0500
From: Peter Meerwald <pmeerw@pmeerw.net>
To: linux-media@vger.kernel.org
Cc: linux-omap@vger.kernel.org, laurent.pinchart@ideasonboard.com,
	sakari.ailus@iki.fi, Peter Meerwald <pmeerw@pmeerw.net>
Subject: [PATCH] omap3isp: Fix kerneldoc for _module_sync_is_stopping and isp_isr()
Date: Sun, 23 Feb 2014 18:08:55 +0100
Message-Id: <1393175335-15984-1-git-send-email-pmeerw@pmeerw.net>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Peter Meerwald <pmeerw@pmeerw.net>
---
 drivers/media/platform/omap3isp/isp.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/drivers/media/platform/omap3isp/isp.c b/drivers/media/platform/omap3isp/isp.c
index 5807185..d60a4b7 100644
--- a/drivers/media/platform/omap3isp/isp.c
+++ b/drivers/media/platform/omap3isp/isp.c
@@ -588,9 +588,6 @@ static void isp_isr_sbl(struct isp_device *isp)
  * @_isp: Pointer to the OMAP3 ISP device
  *
  * Handles the corresponding callback if plugged in.
- *
- * Returns IRQ_HANDLED when IRQ was correctly handled, or IRQ_NONE when the
- * IRQ wasn't handled.
  */
 static irqreturn_t isp_isr(int irq, void *_isp)
 {
@@ -1420,7 +1417,7 @@ int omap3isp_module_sync_idle(struct media_entity *me, wait_queue_head_t *wait,
 }
 
 /*
- * omap3isp_module_sync_is_stopped - Helper to verify if module was stopping
+ * omap3isp_module_sync_is_stopping - Helper to verify if module was stopping
  * @wait: ISP submodule's wait queue for streamoff/interrupt synchronization
  * @stopping: flag which tells module wants to stop
  *
-- 
1.8.3.2

