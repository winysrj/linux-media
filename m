Return-path: <linux-media-owner@vger.kernel.org>
Received: from osg.samsung.com ([64.30.133.232]:56374 "EHLO osg.samsung.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754085AbdJIKTr (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 9 Oct 2017 06:19:47 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>,
        Jonathan Corbet <corbet@lwn.net>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Linux Doc Mailing List <linux-doc@vger.kernel.org>
Subject: [PATCH 03/24] media: v4l2-mediabus: use BIT() macro for flags
Date: Mon,  9 Oct 2017 07:19:09 -0300
Message-Id: <6a5f7e450dbb613e47bef21af9119bf09ef35762.1507544011.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1507544011.git.mchehab@s-opensource.com>
References: <cover.1507544011.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1507544011.git.mchehab@s-opensource.com>
References: <cover.1507544011.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Instead of using (1 << n) for bits, use the BIT() macro,
as it makes them better documented.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 include/media/v4l2-mediabus.h | 50 ++++++++++++++++++++++---------------------
 1 file changed, 26 insertions(+), 24 deletions(-)

diff --git a/include/media/v4l2-mediabus.h b/include/media/v4l2-mediabus.h
index 93f8afcb7a22..e5281e1086c4 100644
--- a/include/media/v4l2-mediabus.h
+++ b/include/media/v4l2-mediabus.h
@@ -12,6 +12,8 @@
 #define V4L2_MEDIABUS_H
 
 #include <linux/v4l2-mediabus.h>
+#include <linux/bitops.h>
+
 
 /* Parallel flags */
 /*
@@ -20,44 +22,44 @@
  * horizontal and vertical synchronisation. In "Slave mode" the host is
  * providing these signals to the slave.
  */
-#define V4L2_MBUS_MASTER			(1 << 0)
-#define V4L2_MBUS_SLAVE				(1 << 1)
+#define V4L2_MBUS_MASTER			BIT(0)
+#define V4L2_MBUS_SLAVE				BIT(1)
 /*
  * Signal polarity flags
  * Note: in BT.656 mode HSYNC, FIELD, and VSYNC are unused
  * V4L2_MBUS_[HV]SYNC* flags should be also used for specifying
  * configuration of hardware that uses [HV]REF signals
  */
-#define V4L2_MBUS_HSYNC_ACTIVE_HIGH		(1 << 2)
-#define V4L2_MBUS_HSYNC_ACTIVE_LOW		(1 << 3)
-#define V4L2_MBUS_VSYNC_ACTIVE_HIGH		(1 << 4)
-#define V4L2_MBUS_VSYNC_ACTIVE_LOW		(1 << 5)
-#define V4L2_MBUS_PCLK_SAMPLE_RISING		(1 << 6)
-#define V4L2_MBUS_PCLK_SAMPLE_FALLING		(1 << 7)
-#define V4L2_MBUS_DATA_ACTIVE_HIGH		(1 << 8)
-#define V4L2_MBUS_DATA_ACTIVE_LOW		(1 << 9)
+#define V4L2_MBUS_HSYNC_ACTIVE_HIGH		BIT(2)
+#define V4L2_MBUS_HSYNC_ACTIVE_LOW		BIT(3)
+#define V4L2_MBUS_VSYNC_ACTIVE_HIGH		BIT(4)
+#define V4L2_MBUS_VSYNC_ACTIVE_LOW		BIT(5)
+#define V4L2_MBUS_PCLK_SAMPLE_RISING		BIT(6)
+#define V4L2_MBUS_PCLK_SAMPLE_FALLING		BIT(7)
+#define V4L2_MBUS_DATA_ACTIVE_HIGH		BIT(8)
+#define V4L2_MBUS_DATA_ACTIVE_LOW		BIT(9)
 /* FIELD = 0/1 - Field1 (odd)/Field2 (even) */
-#define V4L2_MBUS_FIELD_EVEN_HIGH		(1 << 10)
+#define V4L2_MBUS_FIELD_EVEN_HIGH		BIT(10)
 /* FIELD = 1/0 - Field1 (odd)/Field2 (even) */
-#define V4L2_MBUS_FIELD_EVEN_LOW		(1 << 11)
+#define V4L2_MBUS_FIELD_EVEN_LOW		BIT(11)
 /* Active state of Sync-on-green (SoG) signal, 0/1 for LOW/HIGH respectively. */
-#define V4L2_MBUS_VIDEO_SOG_ACTIVE_HIGH	(1 << 12)
-#define V4L2_MBUS_VIDEO_SOG_ACTIVE_LOW		(1 << 13)
+#define V4L2_MBUS_VIDEO_SOG_ACTIVE_HIGH		BIT(12)
+#define V4L2_MBUS_VIDEO_SOG_ACTIVE_LOW		BIT(13)
 
 /* Serial flags */
 /* How many lanes the client can use */
-#define V4L2_MBUS_CSI2_1_LANE			(1 << 0)
-#define V4L2_MBUS_CSI2_2_LANE			(1 << 1)
-#define V4L2_MBUS_CSI2_3_LANE			(1 << 2)
-#define V4L2_MBUS_CSI2_4_LANE			(1 << 3)
+#define V4L2_MBUS_CSI2_1_LANE			BIT(0)
+#define V4L2_MBUS_CSI2_2_LANE			BIT(1)
+#define V4L2_MBUS_CSI2_3_LANE			BIT(2)
+#define V4L2_MBUS_CSI2_4_LANE			BIT(3)
 /* On which channels it can send video data */
-#define V4L2_MBUS_CSI2_CHANNEL_0		(1 << 4)
-#define V4L2_MBUS_CSI2_CHANNEL_1		(1 << 5)
-#define V4L2_MBUS_CSI2_CHANNEL_2		(1 << 6)
-#define V4L2_MBUS_CSI2_CHANNEL_3		(1 << 7)
+#define V4L2_MBUS_CSI2_CHANNEL_0		BIT(4)
+#define V4L2_MBUS_CSI2_CHANNEL_1		BIT(5)
+#define V4L2_MBUS_CSI2_CHANNEL_2		BIT(6)
+#define V4L2_MBUS_CSI2_CHANNEL_3		BIT(7)
 /* Does it support only continuous or also non-continuous clock mode */
-#define V4L2_MBUS_CSI2_CONTINUOUS_CLOCK		(1 << 8)
-#define V4L2_MBUS_CSI2_NONCONTINUOUS_CLOCK	(1 << 9)
+#define V4L2_MBUS_CSI2_CONTINUOUS_CLOCK		BIT(8)
+#define V4L2_MBUS_CSI2_NONCONTINUOUS_CLOCK	BIT(9)
 
 #define V4L2_MBUS_CSI2_LANES		(V4L2_MBUS_CSI2_1_LANE | V4L2_MBUS_CSI2_2_LANE | \
 					 V4L2_MBUS_CSI2_3_LANE | V4L2_MBUS_CSI2_4_LANE)
-- 
2.13.6
