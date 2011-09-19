Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.w1.samsung.com ([210.118.77.13]:62957 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756727Ab1ISQlq (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 19 Sep 2011 12:41:46 -0400
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: TEXT/PLAIN
Received: from euspt1 ([210.118.77.13]) by mailout3.w1.samsung.com
 (Sun Java(tm) System Messaging Server 6.3-8.04 (built Jul 29 2009; 32bit))
 with ESMTP id <0LRS000WZ3PJ8360@mailout3.w1.samsung.com> for
 linux-media@vger.kernel.org; Mon, 19 Sep 2011 17:41:43 +0100 (BST)
Received: from linux.samsung.com ([106.116.38.10])
 by spt1.w1.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14
 2004)) with ESMTPA id <0LRS00IJD3PJNL@spt1.w1.samsung.com> for
 linux-media@vger.kernel.org; Mon, 19 Sep 2011 17:41:43 +0100 (BST)
Date: Mon, 19 Sep 2011 18:41:36 +0200
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: [PATCH v2 1/2] v4l2: Add the polarity flags for parallel camera bus
 FIELD signal
In-reply-to: <1316450497-6723-1-git-send-email-s.nawrocki@samsung.com>
To: linux-media@vger.kernel.org
Cc: m.szyprowski@samsung.com, laurent.pinchart@ideasonboard.com,
	kyungmin.park@samsung.com, g.liakhovetski@gmx.de,
	sw0312.kim@samsung.com, riverful.kim@samsung.com,
	Sylwester Nawrocki <s.nawrocki@samsung.com>
Message-id: <1316450497-6723-2-git-send-email-s.nawrocki@samsung.com>
References: <alpine.DEB.2.00.1109171423460.28766@axis700.grange>
 <1316450497-6723-1-git-send-email-s.nawrocki@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

FIELD is an Even/Odd field selection signal, as specified in ITU-R BT.601
standard. Add corresponding flag for configuring the FIELD signal polarity.
Also add a comment about usage of V4L2_MBUS_[HV]SYNC* flags for the hardware
that uses [HV]REF signals.

Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 include/media/v4l2-mediabus.h |   11 +++++++++--
 1 files changed, 9 insertions(+), 2 deletions(-)

diff --git a/include/media/v4l2-mediabus.h b/include/media/v4l2-mediabus.h
index 6114007..586fc44 100644
--- a/include/media/v4l2-mediabus.h
+++ b/include/media/v4l2-mediabus.h
@@ -22,8 +22,12 @@
  */
 #define V4L2_MBUS_MASTER			(1 << 0)
 #define V4L2_MBUS_SLAVE				(1 << 1)
-/* Which signal polarities it supports */
-/* Note: in BT.656 mode HSYNC and VSYNC are unused */
+/*
+ * Signal polarity flags
+ * Note: in BT.656 mode HSYNC, FIELD, and VSYNC are unused
+ * V4L2_MBUS_[HV]SYNC_* flags should be also used for specifying
+ * configuration of hardware that uses [HV]REF signals
+ */
 #define V4L2_MBUS_HSYNC_ACTIVE_HIGH		(1 << 2)
 #define V4L2_MBUS_HSYNC_ACTIVE_LOW		(1 << 3)
 #define V4L2_MBUS_VSYNC_ACTIVE_HIGH		(1 << 4)
@@ -32,6 +36,9 @@
 #define V4L2_MBUS_PCLK_SAMPLE_FALLING		(1 << 7)
 #define V4L2_MBUS_DATA_ACTIVE_HIGH		(1 << 8)
 #define V4L2_MBUS_DATA_ACTIVE_LOW		(1 << 9)
+/* Field selection signal for interlaced scan mode */
+#define V4L2_MBUS_FIELD_ACTIVE_HIGH		(1 << 12)
+#define V4L2_MBUS_FIELD_ACTIVE_LOW		(1 << 13)
 
 /* Serial flags */
 /* How many lanes the client can use */
-- 
1.7.6.3

