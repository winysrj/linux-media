Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:39205 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751965AbbJJNgS (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 10 Oct 2015 09:36:18 -0400
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Subject: [PATCH 24/26] [media] demux.h: Convert MPEG-TS demux caps to an enum
Date: Sat, 10 Oct 2015 10:36:07 -0300
Message-Id: <9be91db2efcf749eb159c674915d38e5ac14682a.1444483819.git.mchehab@osg.samsung.com>
In-Reply-To: <cover.1444483819.git.mchehab@osg.samsung.com>
References: <cover.1444483819.git.mchehab@osg.samsung.com>
In-Reply-To: <cover.1444483819.git.mchehab@osg.samsung.com>
References: <cover.1444483819.git.mchehab@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

While we can't document #defines, documenting enums are
well supported by kernel-doc. So, convert the bitmap defines
into an enum.

Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>

diff --git a/drivers/media/dvb-core/demux.h b/drivers/media/dvb-core/demux.h
index 98bff5cc4ff4..ccc1f43cb9a9 100644
--- a/drivers/media/dvb-core/demux.h
+++ b/drivers/media/dvb-core/demux.h
@@ -332,16 +332,20 @@ struct dmx_frontend {
  * MPEG-2 TS Demux
  */
 
-/*
- * Flags OR'ed in the capabilities field of struct dmx_demux.
+/**
+ * enum dmx_demux_caps - MPEG-2 TS Demux capabilities bitmap
+ *
+ * @DMX_TS_FILTERING:		set if TS filtering is supported;
+ * @DMX_SECTION_FILTERING:	set if section filtering is supported;
+ * @DMX_MEMORY_BASED_FILTERING:	set if write() available.
+ *
+ * Those flags are OR'ed in the &dmx_demux.&capabilities field
  */
-
-#define DMX_TS_FILTERING                        1
-#define DMX_PES_FILTERING                       2
-#define DMX_SECTION_FILTERING                   4
-#define DMX_MEMORY_BASED_FILTERING              8    /* write() available */
-#define DMX_CRC_CHECKING                        16
-#define DMX_TS_DESCRAMBLING                     32
+enum dmx_demux_caps {
+	DMX_TS_FILTERING = 1,
+	DMX_SECTION_FILTERING = 4,
+	DMX_MEMORY_BASED_FILTERING = 8,
+};
 
 /*
  * Demux resource type identifier.
@@ -361,7 +365,7 @@ struct dmx_frontend {
  * struct dmx_demux - Structure that contains the demux capabilities and
  *		      callbacks.
  *
- * @capabilities: Bitfield of capability flags
+ * @capabilities: Bitfield of capability flags.
  *
  * @frontend: Front-end connected to the demux
  *
@@ -549,7 +553,7 @@ struct dmx_frontend {
  */
 
 struct dmx_demux {
-	u32 capabilities;
+	enum dmx_demux_caps capabilities;
 	struct dmx_frontend *frontend;
 	void *priv;
 	int (*open)(struct dmx_demux *demux);
-- 
2.4.3


