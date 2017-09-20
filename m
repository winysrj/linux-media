Return-path: <linux-media-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:50298
        "EHLO osg.samsung.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751462AbdITTL4 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 20 Sep 2017 15:11:56 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Sakari Ailus <sakari.ailus@linux.intel.com>
Subject: [PATCH 09/25] media: dvb_demux.h: add an enum for DMX_TYPE_* and document
Date: Wed, 20 Sep 2017 16:11:34 -0300
Message-Id: <d42c16fad6a35dbeec01b3c70fd2fb35a64d55b0.1505933919.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1505933919.git.mchehab@s-opensource.com>
References: <cover.1505933919.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1505933919.git.mchehab@s-opensource.com>
References: <cover.1505933919.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

kernel-doc allows documenting enums. Also, it makes clearer
about the meaning of each field on structures.

So, convert DMX_TYPE_* to an enum.

While here, get rid of the unused DMX_TYPE_PES.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 drivers/media/dvb-core/dvb_demux.h | 17 ++++++++++++-----
 1 file changed, 12 insertions(+), 5 deletions(-)

diff --git a/drivers/media/dvb-core/dvb_demux.h b/drivers/media/dvb-core/dvb_demux.h
index 6f572ca8d339..6bc4b27dbff3 100644
--- a/drivers/media/dvb-core/dvb_demux.h
+++ b/drivers/media/dvb-core/dvb_demux.h
@@ -26,9 +26,16 @@
 
 #include "demux.h"
 
-#define DMX_TYPE_TS  0
-#define DMX_TYPE_SEC 1
-#define DMX_TYPE_PES 2
+/**
+ * enum dvb_dmx_filter_type - type of demux feed.
+ *
+ * @DMX_TYPE_TS:	feed is in TS mode.
+ * @DMX_TYPE_SEC:	feed is in Section mode.
+ */
+enum dvb_dmx_filter_type {
+	DMX_TYPE_TS,
+	DMX_TYPE_SEC,
+};
 
 #define DMX_STATE_FREE      0
 #define DMX_STATE_ALLOCATED 1
@@ -52,7 +59,7 @@ struct dvb_demux_filter {
 	struct dvb_demux_feed *feed;
 	int index;
 	int state;
-	int type;
+	enum dvb_dmx_filter_type type;
 
 	u16 hw_handle;
 	struct timer_list timer;
@@ -73,7 +80,7 @@ struct dvb_demux_feed {
 
 	struct dvb_demux *demux;
 	void *priv;
-	int type;
+	enum dvb_dmx_filter_type type;
 	int state;
 	u16 pid;
 
-- 
2.13.5
