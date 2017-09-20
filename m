Return-path: <linux-media-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:50349
        "EHLO osg.samsung.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751000AbdITTL7 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 20 Sep 2017 15:11:59 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Sakari Ailus <sakari.ailus@linux.intel.com>
Subject: [PATCH 16/25] media: dvb_demux: document dvb_demux_filter and dvb_demux_feed
Date: Wed, 20 Sep 2017 16:11:41 -0300
Message-Id: <62f7a0009464a5d54ab7d16e77f03b8703112802.1505933919.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1505933919.git.mchehab@s-opensource.com>
References: <cover.1505933919.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1505933919.git.mchehab@s-opensource.com>
References: <cover.1505933919.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Document those two structs using kernel-doc markups.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 drivers/media/dvb-core/dvb_demux.h | 49 ++++++++++++++++++++++++++++++++++++--
 1 file changed, 47 insertions(+), 2 deletions(-)

diff --git a/drivers/media/dvb-core/dvb_demux.h b/drivers/media/dvb-core/dvb_demux.h
index c9e94bc3a2e5..5b05e6320e33 100644
--- a/drivers/media/dvb-core/dvb_demux.h
+++ b/drivers/media/dvb-core/dvb_demux.h
@@ -60,6 +60,21 @@ enum dvb_dmx_state {
 
 #define SPEED_PKTS_INTERVAL 50000
 
+/**
+ * struct dvb_demux_filter - Describes a DVB demux section filter.
+ *
+ * @filter:		Section filter as defined by &struct dmx_section_filter.
+ * @maskandmode:	logical ``and`` bit mask.
+ * @maskandnotmode:	logical ``and not`` bit mask.
+ * @doneq:		flag that indicates when a filter is ready.
+ * @next:		pointer to the next section filter.
+ * @feed:		&struct dvb_demux_feed pointer.
+ * @index:		index of the used demux filter.
+ * @state:		state of the filter as described by &enum dvb_dmx_state.
+ * @type:		type of the filter as described
+ *			by &enum dvb_dmx_filter_type.
+ */
+
 struct dvb_demux_filter {
 	struct dmx_section_filter filter;
 	u8 maskandmode[DMX_MAX_FILTER_SIZE];
@@ -72,9 +87,39 @@ struct dvb_demux_filter {
 	enum dvb_dmx_state state;
 	enum dvb_dmx_filter_type type;
 
+	/* private: used only by av7110 */
 	u16 hw_handle;
 };
 
+/**
+ * struct dvb_demux_feed - describes a DVB field
+ *
+ * @feed:	a digital TV feed. It can either be a TS or a section feed:
+ *		  - if the feed is TS, it contains &struct dvb_ts_feed;
+ *		  - if the feed is section, it contains
+ *		    &struct dmx_section_feed.
+ * @cb:		digital TV callbacks. depending on the feed type, it can be:
+ *		  - if the feed is TS, it contains a dmx_ts_cb() callback;
+ *		  - if the feed is section, it contains a dmx_section_cb() callback.
+ *
+ * @demux:	pointer to &struct dvb_demux.
+ * @priv:	private data for the filter handling routine.
+ * @type:	type of the filter, as defined by &enum dvb_dmx_filter_type.
+ * @state:	state of the filter as defined by &enum dvb_dmx_state.
+ * @pid:	PID to be filtered.
+ * @timeout:	feed timeout.
+ * @filter:	pointer to &struct dvb_demux_filter.
+ * @ts_type:	type of TS, as defined by &enum ts_filter_type.
+ * @pes_type:	type of PES, as defined by &enum dmx_ts_pes.
+ * @cc:		MPEG-TS packet continuity counter
+ * @pusi_seen:	if true, indicates that a discontinuity was detected.
+ *		it is used to prevent feeding of garbage from previous section.
+ * @peslen:	length of the PES (Packet Elementary Stream).
+ * @list_head:	head for the list of digital TV demux feeds.
+ * @index:	a unique index for each feed. Can be used as hardware
+ * 		pid filter index.
+ *
+ */
 struct dvb_demux_feed {
 	union {
 		struct dmx_ts_feed ts;
@@ -99,12 +144,12 @@ struct dvb_demux_feed {
 	enum dmx_ts_pes pes_type;
 
 	int cc;
-	bool pusi_seen;		/* prevents feeding of garbage from previous section */
+	bool pusi_seen;
 
 	u16 peslen;
 
 	struct list_head list_head;
-	unsigned int index;	/* a unique index for each feed (can be used as hardware pid filter index) */
+	unsigned int index;
 };
 
 struct dvb_demux {
-- 
2.13.5
