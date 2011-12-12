Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.w1.samsung.com ([210.118.77.13]:41577 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753635Ab1LLRpJ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 12 Dec 2011 12:45:09 -0500
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: TEXT/PLAIN
Received: from euspt2 ([210.118.77.13]) by mailout3.w1.samsung.com
 (Sun Java(tm) System Messaging Server 6.3-8.04 (built Jul 29 2009; 32bit))
 with ESMTP id <0LW300DC4QN3CU90@mailout3.w1.samsung.com> for
 linux-media@vger.kernel.org; Mon, 12 Dec 2011 17:45:03 +0000 (GMT)
Received: from linux.samsung.com ([106.116.38.10])
 by spt2.w1.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14
 2004)) with ESMTPA id <0LW3001DUQN2FG@spt2.w1.samsung.com> for
 linux-media@vger.kernel.org; Mon, 12 Dec 2011 17:45:03 +0000 (GMT)
Date: Mon, 12 Dec 2011 18:44:52 +0100
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: [PATCH 08/14] m5mols: Change the end of frame v4l2_subdev notification
 id
In-reply-to: <1323711898-17162-1-git-send-email-s.nawrocki@samsung.com>
To: linux-media@vger.kernel.org
Cc: m.szyprowski@samsung.com, riverful.kim@samsung.com,
	sw0312.kim@samsung.com, s.nawrocki@samsung.com,
	Kyungmin Park <kyungmin.park@samsung.com>
Message-id: <1323711898-17162-9-git-send-email-s.nawrocki@samsung.com>
References: <1323711898-17162-1-git-send-email-s.nawrocki@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Change the v4l2_device notifications id to S5P_FIMC_TX_END_NOTIFY.

Moreover, when frame capture fails, send an 'end of frame' notification
with size set to 0 to let the host driver return a buffer back to the
user and prevent applications waiting forever on DQBUF.

The notification is needed only for the s5p-fimc driver.

Acked-by: HeungJun Kim <riverful.kim@samsung.com>
Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/media/video/m5mols/m5mols_capture.c |   13 +++++++++++--
 1 files changed, 11 insertions(+), 2 deletions(-)

diff --git a/drivers/media/video/m5mols/m5mols_capture.c b/drivers/media/video/m5mols/m5mols_capture.c
index 8bb284d..038b349 100644
--- a/drivers/media/video/m5mols/m5mols_capture.c
+++ b/drivers/media/video/m5mols/m5mols_capture.c
@@ -1,3 +1,4 @@
+
 /*
  * The Capture code for Fujitsu M-5MOLS ISP
  *
@@ -25,6 +26,7 @@
 #include <media/v4l2-device.h>
 #include <media/v4l2-subdev.h>
 #include <media/m5mols.h>
+#include <media/s5p_fimc.h>
 
 #include "m5mols.h"
 #include "m5mols_reg.h"
@@ -142,13 +144,20 @@ int m5mols_start_capture(struct m5mols_info *info)
 	if (!ret)
 		ret = m5mols_write(sd, CAPC_START, REG_CAP_START_MAIN);
 	if (!ret) {
+		bool captured = false;
+		unsigned int size;
+
 		/* Wait for the capture completion interrupt */
 		ret = m5mols_wait_interrupt(sd, REG_INT_CAPTURE, 2000);
 		if (!ret) {
+			captured = true;
 			ret = m5mols_capture_info(info);
-			if (!ret)
-				v4l2_subdev_notify(sd, 0, &info->cap.total);
 		}
+		size = captured ? info->cap.main : 0;
+		v4l2_dbg(1, m5mols_debug, sd, "%s: size: %d, thumb.: %d B\n",
+			 __func__, size, info->cap.thumb);
+
+		v4l2_subdev_notify(sd, S5P_FIMC_TX_END_NOTIFY, &size);
 	}
 
 	return ret;
-- 
1.7.8

