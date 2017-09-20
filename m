Return-path: <linux-media-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:50308
        "EHLO osg.samsung.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751000AbdITTL5 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 20 Sep 2017 15:11:57 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Ingo Molnar <mingo@kernel.org>,
        Sakari Ailus <sakari.ailus@linux.intel.com>
Subject: [PATCH 19/25] media: dvb_demux.h: document structs defined on it
Date: Wed, 20 Sep 2017 16:11:44 -0300
Message-Id: <ae53cc160e5f8d6de1c41ef609d8662d216d8cdb.1505933919.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1505933919.git.mchehab@s-opensource.com>
References: <cover.1505933919.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1505933919.git.mchehab@s-opensource.com>
References: <cover.1505933919.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

There are three structs defined inside dvb_demux.h. None
of them are currently documented.

Add documentation for them.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 drivers/media/dvb-core/dvb_demux.c |  1 +
 drivers/media/dvb-core/dvb_demux.h | 58 ++++++++++++++++++++++++++++++++------
 2 files changed, 50 insertions(+), 9 deletions(-)

diff --git a/drivers/media/dvb-core/dvb_demux.c b/drivers/media/dvb-core/dvb_demux.c
index b9360cbc3519..acade7543b82 100644
--- a/drivers/media/dvb-core/dvb_demux.c
+++ b/drivers/media/dvb-core/dvb_demux.c
@@ -367,6 +367,7 @@ static inline void dvb_dmx_swfilter_packet_type(struct dvb_demux_feed *feed,
 			else
 				feed->cb.ts(buf, 188, NULL, 0, &feed->feed.ts);
 		}
+		/* Used only on full-featured devices */
 		if (feed->ts_type & TS_DECODER)
 			if (feed->demux->write_to_decoder)
 				feed->demux->write_to_decoder(feed, buf, 188);
diff --git a/drivers/media/dvb-core/dvb_demux.h b/drivers/media/dvb-core/dvb_demux.h
index 5b05e6320e33..43b0cab2e932 100644
--- a/drivers/media/dvb-core/dvb_demux.h
+++ b/drivers/media/dvb-core/dvb_demux.h
@@ -95,15 +95,16 @@ struct dvb_demux_filter {
  * struct dvb_demux_feed - describes a DVB field
  *
  * @feed:	a digital TV feed. It can either be a TS or a section feed:
- *		  - if the feed is TS, it contains &struct dvb_ts_feed;
- *		  - if the feed is section, it contains
- *		    &struct dmx_section_feed.
+ *		if the feed is TS, it contains &struct dvb_ts_feed @ts;
+ *		if the feed is section, it contains
+ *		&struct dmx_section_feed @sec.
  * @cb:		digital TV callbacks. depending on the feed type, it can be:
- *		  - if the feed is TS, it contains a dmx_ts_cb() callback;
- *		  - if the feed is section, it contains a dmx_section_cb() callback.
+ *		if the feed is TS, it contains a dmx_ts_cb() @ts callback;
+ *		if the feed is section, it contains a dmx_section_cb() @sec
+ * 		callback.
  *
  * @demux:	pointer to &struct dvb_demux.
- * @priv:	private data for the filter handling routine.
+ * @priv:	private data that can optionally be used by a DVB driver.
  * @type:	type of the filter, as defined by &enum dvb_dmx_filter_type.
  * @state:	state of the filter as defined by &enum dvb_dmx_state.
  * @pid:	PID to be filtered.
@@ -118,7 +119,6 @@ struct dvb_demux_filter {
  * @list_head:	head for the list of digital TV demux feeds.
  * @index:	a unique index for each feed. Can be used as hardware
  * 		pid filter index.
- *
  */
 struct dvb_demux_feed {
 	union {
@@ -152,6 +152,44 @@ struct dvb_demux_feed {
 	unsigned int index;
 };
 
+/**
+ * struct dvb_demux - represents a digital TV demux
+ * @dmx:		embedded &struct dmx_demux with demux capabilities
+ *			and callbacks.
+ * @priv:		private data that can optionally be used by
+ *			a DVB driver.
+ * @filternum:		maximum amount of DVB filters.
+ * @feednum:		maximum amount of DVB feeds.
+ * @start_feed:		callback routine to be called in order to start
+ *			a DVB feed.
+ * @stop_feed:		callback routine to be called in order to stop
+ *			a DVB feed.
+ * @write_to_decoder:	callback routine to be called if the feed is TS and
+ *			it is routed to an A/V decoder, when a new TS packet
+ *			is received.
+ *			Used only on av7110-av.c.
+ * @check_crc32:	callback routine to check CRC. If not initialized,
+ *			dvb_demux will use an internal one.
+ * @memcopy:		callback routine to memcopy received data.
+ *			If not initialized, dvb_demux will default to memcpy().
+ * @users:		counter for the number of demux opened file descriptors.
+ *			Currently, it is limited to 10 users.
+ * @filter:		pointer to &struct dvb_demux_filter.
+ * @feed:		pointer to &struct dvb_demux_feed.
+ * @frontend_list:	&struct list_head with frontends used by the demux.
+ * @pesfilter:		array of &struct dvb_demux_feed with the PES types
+ *			that will be filtered.
+ * @pids:		list of filtered program IDs.
+ * @feed_list:		&struct list_head with feeds.
+ * @tsbuf:		temporary buffer used internally to store TS packets.
+ * @tsbufp:		temporary buffer index used internally.
+ * @mutex:		pointer to &struct mutex used to protect feed set
+ *			logic.
+ * @lock:		pointer to &spinlock_t, used to protect buffer handling.
+ * @cnt_storage:	buffer used for TS/TEI continuity check.
+ * @speed_last_time:	&ktime_t used for TS speed check.
+ * @speed_pkts_cnt:	packets count used for TS speed check.
+ */
 struct dvb_demux {
 	struct dmx_demux dmx;
 	void *priv;
@@ -175,8 +213,6 @@ struct dvb_demux {
 
 	struct dvb_demux_feed *pesfilter[DMX_PES_OTHER];
 	u16 pids[DMX_PES_OTHER];
-	int playing;
-	int recording;
 
 #define DMX_MAX_PID 0x2000
 	struct list_head feed_list;
@@ -190,6 +226,10 @@ struct dvb_demux {
 
 	ktime_t speed_last_time; /* for TS speed check */
 	uint32_t speed_pkts_cnt; /* for TS speed check */
+
+	/* private: used only on av7110 */
+	int playing;
+	int recording;
 };
 
 int dvb_dmx_init(struct dvb_demux *dvbdemux);
-- 
2.13.5
