Return-path: <linux-media-owner@vger.kernel.org>
Received: from arroyo.ext.ti.com ([192.94.94.40]:52479 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752943Ab1IZL7b (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 26 Sep 2011 07:59:31 -0400
From: Archit Taneja <archit@ti.com>
To: <hvaibhav@ti.com>
CC: <tomi.valkeinen@ti.com>, <linux-omap@vger.kernel.org>,
	<sumit.semwal@ti.com>, <linux-media@vger.kernel.org>,
	Archit Taneja <archit@ti.com>
Subject: [PATCH v3 3/4] OMAP_VOUT: Add support for DSI panels
Date: Mon, 26 Sep 2011 17:29:24 +0530
Message-ID: <1317038365-30650-4-git-send-email-archit@ti.com>
In-Reply-To: <1317038365-30650-1-git-send-email-archit@ti.com>
References: <1317038365-30650-1-git-send-email-archit@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add support for DSI panels. DSI video mode panels will work directly. For
command mode panels, we will need to trigger updates regularly. This isn't done
by the omap_vout driver currently. It can still be supported if we connect a
framebuffer device to the panel and configure it in auto update mode.

Signed-off-by: Archit Taneja <archit@ti.com>
---
 drivers/media/video/omap/omap_vout.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/media/video/omap/omap_vout.c b/drivers/media/video/omap/omap_vout.c
index 01c24a4..7b8e87a 100644
--- a/drivers/media/video/omap/omap_vout.c
+++ b/drivers/media/video/omap/omap_vout.c
@@ -589,6 +589,7 @@ static void omap_vout_isr(void *arg, unsigned int irqstatus)
 	do_gettimeofday(&timevalue);
 
 	switch (cur_display->type) {
+	case OMAP_DISPLAY_TYPE_DSI:
 	case OMAP_DISPLAY_TYPE_DPI:
 		if (!(irqstatus & (DISPC_IRQ_VSYNC | DISPC_IRQ_VSYNC2)))
 			goto vout_isr_err;
-- 
1.7.1

