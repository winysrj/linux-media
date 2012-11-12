Return-path: <linux-media-owner@vger.kernel.org>
Received: from devils.ext.ti.com ([198.47.26.153]:39731 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752666Ab2KLNeD (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 12 Nov 2012 08:34:03 -0500
From: Tomi Valkeinen <tomi.valkeinen@ti.com>
To: <hvaibhav@ti.com>, <linux-media@vger.kernel.org>
CC: Tony Lindgren <tony@atomide.com>, <linux-omap@vger.kernel.org>,
	Archit Taneja <archit@ti.com>,
	Tomi Valkeinen <tomi.valkeinen@ti.com>
Subject: [PATCH 2/2] [media] omap_vout: remove extra include
Date: Mon, 12 Nov 2012 15:33:40 +0200
Message-ID: <1352727220-22540-3-git-send-email-tomi.valkeinen@ti.com>
In-Reply-To: <1352727220-22540-1-git-send-email-tomi.valkeinen@ti.com>
References: <1352727220-22540-1-git-send-email-tomi.valkeinen@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Remove including plat/dma.h which is not needed.

Signed-off-by: Tomi Valkeinen <tomi.valkeinen@ti.com>
---
 drivers/media/platform/omap/omap_vout.c |    1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/media/platform/omap/omap_vout.c b/drivers/media/platform/omap/omap_vout.c
index 7b1afc8..a2cc634 100644
--- a/drivers/media/platform/omap/omap_vout.c
+++ b/drivers/media/platform/omap/omap_vout.c
@@ -44,7 +44,6 @@
 #include <media/v4l2-device.h>
 #include <media/v4l2-ioctl.h>
 
-#include <plat/dma.h>
 #include <video/omapvrfb.h>
 #include <video/omapdss.h>
 
-- 
1.7.10.4

