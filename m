Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:39210 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751966AbbJJNgS (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 10 Oct 2015 09:36:18 -0400
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Subject: [PATCH 23/26] [media] demux.h: Convert TS filter type into enum
Date: Sat, 10 Oct 2015 10:36:06 -0300
Message-Id: <0e6f2d1533bdd1ea08a15648e35ff4f8e0fcc612.1444483819.git.mchehab@osg.samsung.com>
In-Reply-To: <cover.1444483819.git.mchehab@osg.samsung.com>
References: <cover.1444483819.git.mchehab@osg.samsung.com>
In-Reply-To: <cover.1444483819.git.mchehab@osg.samsung.com>
References: <cover.1444483819.git.mchehab@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The usage of #define at the kABI is fine, but it doesn't
allow adding a proper description. As those defines deserve
a proper documentation, let's convert them into an enum and
document them at device-drivers DocBook.

Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>

diff --git a/drivers/media/dvb-core/demux.h b/drivers/media/dvb-core/demux.h
index 576e30fc5c18..98bff5cc4ff4 100644
--- a/drivers/media/dvb-core/demux.h
+++ b/drivers/media/dvb-core/demux.h
@@ -60,26 +60,22 @@
  * TS packet reception
  */
 
-/* TS filter type for set() */
-
-#define TS_PACKET       1   /*
-			     * send TS packets (188 bytes) to callback
-			     * (default)
-			     */
-
-#define	TS_PAYLOAD_ONLY 2   /*
-			     * in case TS_PACKET is set, only send the TS
-			     * payload (<=184 bytes per packet) to callback
-			     */
-
-#define TS_DECODER      4   /*
-			     * send stream to built-in decoder (if present)
-			     */
-
-#define TS_DEMUX        8   /*
-			     * in case TS_PACKET is set, send the TS to
-			     * the demux device, not to the dvr device
-			     */
+/**
+ * enum ts_filter_type - filter type bitmap for dmx_ts_feed.set()
+ *
+ * @TS_PACKET:		Send TS packets (188 bytes) to callback (default).
+ * @TS_PAYLOAD_ONLY:	In case TS_PACKET is set, only send the TS payload
+ *			(<=184 bytes per packet) to callback
+ * @TS_DECODER:		Send stream to built-in decoder (if present).
+ * @TS_DEMUX:		In case TS_PACKET is set, send the TS to the demux
+ *			device, not to the dvr device
+ */
+enum ts_filter_type {
+	TS_PACKET = 1,
+	TS_PAYLOAD_ONLY = 2,
+	TS_DECODER = 4,
+	TS_DEMUX = 8,
+};
 
 /**
  * struct dmx_ts_feed - Structure that contains a TS feed filter
-- 
2.4.3


