Return-path: <linux-media-owner@vger.kernel.org>
Received: from arroyo.ext.ti.com ([192.94.94.40]:33562 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754631Ab1I1OtW (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 28 Sep 2011 10:49:22 -0400
From: Archit Taneja <archit@ti.com>
To: <hvaibhav@ti.com>
CC: <tomi.valkeinen@ti.com>, <linux-omap@vger.kernel.org>,
	<sumit.semwal@ti.com>, <linux-media@vger.kernel.org>,
	Archit Taneja <archit@ti.com>
Subject: [PATCH v4 5/5] OMAP_VOUT: Increase MAX_DISPLAYS to a larger value
Date: Wed, 28 Sep 2011 20:19:28 +0530
Message-ID: <1317221368-3301-6-git-send-email-archit@ti.com>
In-Reply-To: <1317221368-3301-1-git-send-email-archit@ti.com>
References: <1317221368-3301-1-git-send-email-archit@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

There is no limit to the number of displays that can registered with DSS2. The
current value of MAX_DISPLAYS is 3, set this to 10 so that the 'displays'
member of omap2video_device struct can store more omap_dss_device pointers.

This fixes a crash seen in omap_vout_probe when DSS2 registers for more than 3
displays.

Signed-off-by: Archit Taneja <archit@ti.com>
---
 drivers/media/video/omap/omap_voutdef.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/media/video/omap/omap_voutdef.h b/drivers/media/video/omap/omap_voutdef.h
index d793501..27a95d2 100644
--- a/drivers/media/video/omap/omap_voutdef.h
+++ b/drivers/media/video/omap/omap_voutdef.h
@@ -25,7 +25,7 @@
 #define MAC_VRFB_CTXS	4
 #define MAX_VOUT_DEV	2
 #define MAX_OVLS	3
-#define MAX_DISPLAYS	3
+#define MAX_DISPLAYS	10
 #define MAX_MANAGERS	3
 
 #define QQVGA_WIDTH		160
-- 
1.7.1

