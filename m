Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.w1.samsung.com ([210.118.77.12]:15135 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752570Ab1IVQmi (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 22 Sep 2011 12:42:38 -0400
Received: from euspt2 (mailout2.w1.samsung.com [210.118.77.12])
 by mailout2.w1.samsung.com
 (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14 2004))
 with ESMTP id <0LRX00LQ4NR0SF@mailout2.w1.samsung.com> for
 linux-media@vger.kernel.org; Thu, 22 Sep 2011 17:42:36 +0100 (BST)
Received: from linux.samsung.com ([106.116.38.10])
 by spt2.w1.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14
 2004)) with ESMTPA id <0LRX0074GNQZNM@spt2.w1.samsung.com> for
 linux-media@vger.kernel.org; Thu, 22 Sep 2011 17:42:36 +0100 (BST)
Date: Thu, 22 Sep 2011 18:42:30 +0200
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: [PATCH v4 1/2] v4l2: Add polarity flag definitons for parallel bus
 FIELD signal
In-reply-to: <1316709751-29922-1-git-send-email-s.nawrocki@samsung.com>
To: linux-media@vger.kernel.org
Cc: m.szyprowski@samsung.com, laurent.pinchart@ideasonboard.com,
	kyungmin.park@samsung.com, g.liakhovetski@gmx.de,
	sw0312.kim@samsung.com, riverful.kim@samsung.com,
	Sylwester Nawrocki <s.nawrocki@samsung.com>
Message-id: <1316709751-29922-2-git-send-email-s.nawrocki@samsung.com>
MIME-version: 1.0
Content-type: TEXT/PLAIN
Content-transfer-encoding: 7BIT
References: <1316709751-29922-1-git-send-email-s.nawrocki@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

FIELD signal is used for indicating frame field type to the frame grabber
in interlaced scan mode, as specified in ITU-R BT.601 standard.
In normal operation mode FIELD = 0 selects Field1 (odd) and FIELD = 1
selects Field2 (even). When the FIELD signal is inverted it's the other
way around.

Add corresponding flags for configuring the FIELD signal polarity,
V4L2_MBUS_FIELD_EVEN_HIGH for the standard (non-inverted) case and
V4L2_MBUS_FIELD_EVEN_LOW for inverted case.

Also add a comment about usage of V4L2_MBUS_[HV]SYNC* flags for
the hardware that uses [HV]REF signals.

Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 include/media/v4l2-mediabus.h |   12 ++++++++++--
 1 files changed, 10 insertions(+), 2 deletions(-)

diff --git a/include/media/v4l2-mediabus.h b/include/media/v4l2-mediabus.h
index 6114007..83ae07e 100644
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
+ * V4L2_MBUS_[HV]SYNC* flags should be also used for specifying
+ * configuration of hardware that uses [HV]REF signals
+ */
 #define V4L2_MBUS_HSYNC_ACTIVE_HIGH		(1 << 2)
 #define V4L2_MBUS_HSYNC_ACTIVE_LOW		(1 << 3)
 #define V4L2_MBUS_VSYNC_ACTIVE_HIGH		(1 << 4)
@@ -32,6 +36,10 @@
 #define V4L2_MBUS_PCLK_SAMPLE_FALLING		(1 << 7)
 #define V4L2_MBUS_DATA_ACTIVE_HIGH		(1 << 8)
 #define V4L2_MBUS_DATA_ACTIVE_LOW		(1 << 9)
+/* FIELD = 0/1 - Field1 (odd)/Field2 (even) */
+#define V4L2_MBUS_FIELD_EVEN_HIGH		(1 << 10)
+/* FIELD = 1/0 - Field1 (odd)/Field2 (even) */
+#define V4L2_MBUS_FIELD_EVEN_LOW		(1 << 11)
 
 /* Serial flags */
 /* How many lanes the client can use */
-- 
1.7.6.3

