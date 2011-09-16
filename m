Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.w1.samsung.com ([210.118.77.13]:51961 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752566Ab1IPR2u (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 16 Sep 2011 13:28:50 -0400
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: TEXT/PLAIN
Received: from euspt1 ([210.118.77.13]) by mailout3.w1.samsung.com
 (Sun Java(tm) System Messaging Server 6.3-8.04 (built Jul 29 2009; 32bit))
 with ESMTP id <0LRM00KT0LW09Y50@mailout3.w1.samsung.com> for
 linux-media@vger.kernel.org; Fri, 16 Sep 2011 18:28:48 +0100 (BST)
Received: from linux.samsung.com ([106.116.38.10])
 by spt1.w1.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14
 2004)) with ESMTPA id <0LRM00BJRLVY4A@spt1.w1.samsung.com> for
 linux-media@vger.kernel.org; Fri, 16 Sep 2011 18:28:48 +0100 (BST)
Date: Fri, 16 Sep 2011 19:28:42 +0200
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: [PATCH/RFC 1/2] v4l2: Add the parallel bus HREF signal polarity flags
In-reply-to: <1316194123-21185-1-git-send-email-s.nawrocki@samsung.com>
To: linux-media@vger.kernel.org
Cc: m.szyprowski@samsung.com, kyungmin.park@samsung.com,
	g.liakhovetski@gmx.de, sw0312.kim@samsung.com,
	riverful.kim@samsung.com,
	Sylwester Nawrocki <s.nawrocki@samsung.com>
Message-id: <1316194123-21185-2-git-send-email-s.nawrocki@samsung.com>
References: <1316194123-21185-1-git-send-email-s.nawrocki@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

HREF is a signal indicating valid data during single line transmission.
Add corresponding flags for this signal to the set of mediabus signal
polarity flags.

Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 include/media/v4l2-mediabus.h |   14 ++++++++------
 1 files changed, 8 insertions(+), 6 deletions(-)

diff --git a/include/media/v4l2-mediabus.h b/include/media/v4l2-mediabus.h
index 6114007..41d8771 100644
--- a/include/media/v4l2-mediabus.h
+++ b/include/media/v4l2-mediabus.h
@@ -26,12 +26,14 @@
 /* Note: in BT.656 mode HSYNC and VSYNC are unused */
 #define V4L2_MBUS_HSYNC_ACTIVE_HIGH		(1 << 2)
 #define V4L2_MBUS_HSYNC_ACTIVE_LOW		(1 << 3)
-#define V4L2_MBUS_VSYNC_ACTIVE_HIGH		(1 << 4)
-#define V4L2_MBUS_VSYNC_ACTIVE_LOW		(1 << 5)
-#define V4L2_MBUS_PCLK_SAMPLE_RISING		(1 << 6)
-#define V4L2_MBUS_PCLK_SAMPLE_FALLING		(1 << 7)
-#define V4L2_MBUS_DATA_ACTIVE_HIGH		(1 << 8)
-#define V4L2_MBUS_DATA_ACTIVE_LOW		(1 << 9)
+#define V4L2_MBUS_HREF_ACTIVE_HIGH		(1 << 4)
+#define V4L2_MBUS_HREF_ACTIVE_LOW		(1 << 5)
+#define V4L2_MBUS_VSYNC_ACTIVE_HIGH		(1 << 6)
+#define V4L2_MBUS_VSYNC_ACTIVE_LOW		(1 << 7)
+#define V4L2_MBUS_PCLK_SAMPLE_RISING		(1 << 8)
+#define V4L2_MBUS_PCLK_SAMPLE_FALLING		(1 << 9)
+#define V4L2_MBUS_DATA_ACTIVE_HIGH		(1 << 10)
+#define V4L2_MBUS_DATA_ACTIVE_LOW		(1 << 11)
 
 /* Serial flags */
 /* How many lanes the client can use */
-- 
1.7.6

