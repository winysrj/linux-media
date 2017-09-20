Return-path: <linux-media-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:50308
        "EHLO osg.samsung.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751692AbdITTL6 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 20 Sep 2017 15:11:58 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Sakari Ailus <sakari.ailus@linux.intel.com>
Subject: [PATCH 10/25] media: dvb_demux.h: add an enum for DMX_STATE_* and document
Date: Wed, 20 Sep 2017 16:11:35 -0300
Message-Id: <46a55228ad3b749ddc56e52126ee586846a69346.1505933919.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1505933919.git.mchehab@s-opensource.com>
References: <cover.1505933919.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1505933919.git.mchehab@s-opensource.com>
References: <cover.1505933919.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

kernel-doc allows documenting enums. Also, it makes clearer
about the meaning of each field on structures.

So, convert DMX_STATE_* to an enum.

While here, get rid of the unused DMX_STATE_SET.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 drivers/media/dvb-core/dvb_demux.h | 25 ++++++++++++++++++-------
 1 file changed, 18 insertions(+), 7 deletions(-)

diff --git a/drivers/media/dvb-core/dvb_demux.h b/drivers/media/dvb-core/dvb_demux.h
index 6bc4b27dbff3..b24d69b5a20f 100644
--- a/drivers/media/dvb-core/dvb_demux.h
+++ b/drivers/media/dvb-core/dvb_demux.h
@@ -37,11 +37,22 @@ enum dvb_dmx_filter_type {
 	DMX_TYPE_SEC,
 };
 
-#define DMX_STATE_FREE      0
-#define DMX_STATE_ALLOCATED 1
-#define DMX_STATE_SET       2
-#define DMX_STATE_READY     3
-#define DMX_STATE_GO        4
+/**
+ * enum dvb_dmx_state - state machine for a demux filter.
+ *
+ * @DMX_STATE_FREE:		indicates that the filter is freed.
+ * @DMX_STATE_ALLOCATED:	indicates that the filter was allocated
+ *				to be used.
+ * @DMX_STATE_READY:		indicates that the filter is ready
+ *				to be used.
+ * @DMX_STATE_GO:		indicates that the filter is running.
+ */
+enum dvb_dmx_state {
+	DMX_STATE_FREE,
+	DMX_STATE_ALLOCATED,
+	DMX_STATE_READY,
+	DMX_STATE_GO,
+};
 
 #define DVB_DEMUX_MASK_MAX 18
 
@@ -58,7 +69,7 @@ struct dvb_demux_filter {
 	struct dvb_demux_filter *next;
 	struct dvb_demux_feed *feed;
 	int index;
-	int state;
+	enum dvb_dmx_state state;
 	enum dvb_dmx_filter_type type;
 
 	u16 hw_handle;
@@ -81,7 +92,7 @@ struct dvb_demux_feed {
 	struct dvb_demux *demux;
 	void *priv;
 	enum dvb_dmx_filter_type type;
-	int state;
+	enum dvb_dmx_state state;
 	u16 pid;
 
 	ktime_t timeout;
-- 
2.13.5
