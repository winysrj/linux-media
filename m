Return-path: <linux-media-owner@vger.kernel.org>
Received: from lelnx194.ext.ti.com ([198.47.27.80]:14826 "EHLO
        lelnx194.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753535AbcKRXVP (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 18 Nov 2016 18:21:15 -0500
From: Benoit Parrot <bparrot@ti.com>
To: <linux-media@vger.kernel.org>, Hans Verkuil <hverkuil@xs4all.nl>
CC: <linux-kernel@vger.kernel.org>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>,
        Jyri Sarha <jsarha@ti.com>,
        Peter Ujfalusi <peter.ujfalusi@ti.com>,
        Benoit Parrot <bparrot@ti.com>
Subject: [Patch v2 22/35] media: ti-vpe: vpdma: RGB data type yield inverted data
Date: Fri, 18 Nov 2016 17:20:32 -0600
Message-ID: <20161118232045.24665-23-bparrot@ti.com>
In-Reply-To: <20161118232045.24665-1-bparrot@ti.com>
References: <20161118232045.24665-1-bparrot@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The VPDMA RGB data type definition have been updated
to match with Errata i839.

But some of the ARGB definition appeared to be wrong
in the document also. As they would yield RGBA instead.
They have been corrected based on experimentation.

Signed-off-by: Benoit Parrot <bparrot@ti.com>
Acked-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/platform/ti-vpe/vpdma_priv.h | 49 ++++++++++++++++++------------
 1 file changed, 29 insertions(+), 20 deletions(-)

diff --git a/drivers/media/platform/ti-vpe/vpdma_priv.h b/drivers/media/platform/ti-vpe/vpdma_priv.h
index f974a803fa27..72c7f13b4a9d 100644
--- a/drivers/media/platform/ti-vpe/vpdma_priv.h
+++ b/drivers/media/platform/ti-vpe/vpdma_priv.h
@@ -101,26 +101,35 @@
 #define DATA_TYPE_CBY422			0x27
 #define DATA_TYPE_CRY422			0x37
 
-#define DATA_TYPE_RGB16_565			0x0
-#define DATA_TYPE_ARGB_1555			0x1
-#define DATA_TYPE_ARGB_4444			0x2
-#define DATA_TYPE_RGBA_5551			0x3
-#define DATA_TYPE_RGBA_4444			0x4
-#define DATA_TYPE_ARGB24_6666			0x5
-#define DATA_TYPE_RGB24_888			0x6
-#define DATA_TYPE_ARGB32_8888			0x7
-#define DATA_TYPE_RGBA24_6666			0x8
-#define DATA_TYPE_RGBA32_8888			0x9
-#define DATA_TYPE_BGR16_565			0x10
-#define DATA_TYPE_ABGR_1555			0x11
-#define DATA_TYPE_ABGR_4444			0x12
-#define DATA_TYPE_BGRA_5551			0x13
-#define DATA_TYPE_BGRA_4444			0x14
-#define DATA_TYPE_ABGR24_6666			0x15
-#define DATA_TYPE_BGR24_888			0x16
-#define DATA_TYPE_ABGR32_8888			0x17
-#define DATA_TYPE_BGRA24_6666			0x18
-#define DATA_TYPE_BGRA32_8888			0x19
+/*
+ * The RGB data type definition below are defined
+ * to follow Errata i819.
+ * The initial values were taken from:
+ * VPDMA_data_type_mapping_v0.2vayu_c.pdf
+ * But some of the ARGB definition appeared to be wrong
+ * in the document also. As they would yield RGBA instead.
+ * They have been corrected based on experimentation.
+ */
+#define DATA_TYPE_RGB16_565			0x10
+#define DATA_TYPE_ARGB_1555			0x13
+#define DATA_TYPE_ARGB_4444			0x14
+#define DATA_TYPE_RGBA_5551			0x11
+#define DATA_TYPE_RGBA_4444			0x12
+#define DATA_TYPE_ARGB24_6666			0x18
+#define DATA_TYPE_RGB24_888			0x16
+#define DATA_TYPE_ARGB32_8888			0x17
+#define DATA_TYPE_RGBA24_6666			0x15
+#define DATA_TYPE_RGBA32_8888			0x19
+#define DATA_TYPE_BGR16_565			0x0
+#define DATA_TYPE_ABGR_1555			0x3
+#define DATA_TYPE_ABGR_4444			0x4
+#define DATA_TYPE_BGRA_5551			0x1
+#define DATA_TYPE_BGRA_4444			0x2
+#define DATA_TYPE_ABGR24_6666			0x8
+#define DATA_TYPE_BGR24_888			0x6
+#define DATA_TYPE_ABGR32_8888			0x7
+#define DATA_TYPE_BGRA24_6666			0x5
+#define DATA_TYPE_BGRA32_8888			0x9
 
 #define DATA_TYPE_MV				0x3
 
-- 
2.9.0

