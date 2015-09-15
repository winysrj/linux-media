Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.kundenserver.de ([212.227.17.13]:55970 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753375AbbIOPtf (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 15 Sep 2015 11:49:35 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-media@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, y2038@lists.linaro.org,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	linux-api@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
	Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH 1/7] [media] dvb: use ktime_t for internal timeout
Date: Tue, 15 Sep 2015 17:49:02 +0200
Message-Id: <1442332148-488079-2-git-send-email-arnd@arndb.de>
In-Reply-To: <1442332148-488079-1-git-send-email-arnd@arndb.de>
References: <1442332148-488079-1-git-send-email-arnd@arndb.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The dvb demuxer code uses a 'struct timespec' to pass a timeout
as absolute time. This will cause problems on 32-bit architectures
in 2038 when time_t overflows, and it is racy with a concurrent
settimeofday() call.

This patch changes the code to use ktime_get() instead, using
the monotonic time base to avoid both the race and the overflow.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 drivers/media/dvb-core/demux.h     |  2 +-
 drivers/media/dvb-core/dmxdev.c    |  2 +-
 drivers/media/dvb-core/dvb_demux.c | 17 ++++++-----------
 drivers/media/dvb-core/dvb_demux.h |  4 ++--
 drivers/media/dvb-core/dvb_net.c   |  2 +-
 5 files changed, 11 insertions(+), 16 deletions(-)

diff --git a/drivers/media/dvb-core/demux.h b/drivers/media/dvb-core/demux.h
index 833191bcd810..d8e2b1213bef 100644
--- a/drivers/media/dvb-core/demux.h
+++ b/drivers/media/dvb-core/demux.h
@@ -92,7 +92,7 @@ struct dmx_ts_feed {
 		    int type,
 		    enum dmx_ts_pes pes_type,
 		    size_t circular_buffer_size,
-		    struct timespec timeout);
+		    ktime_t timeout);
 	int (*start_filtering) (struct dmx_ts_feed* feed);
 	int (*stop_filtering) (struct dmx_ts_feed* feed);
 };
diff --git a/drivers/media/dvb-core/dmxdev.c b/drivers/media/dvb-core/dmxdev.c
index d0e3f9d85f34..0d20b379eeec 100644
--- a/drivers/media/dvb-core/dmxdev.c
+++ b/drivers/media/dvb-core/dmxdev.c
@@ -558,7 +558,7 @@ static int dvb_dmxdev_start_feed(struct dmxdev *dmxdev,
 				 struct dmxdev_filter *filter,
 				 struct dmxdev_feed *feed)
 {
-	struct timespec timeout = { 0 };
+	ktime_t timeout = ktime_set(0, 0);
 	struct dmx_pes_filter_params *para = &filter->params.pes;
 	dmx_output_t otype;
 	int ret;
diff --git a/drivers/media/dvb-core/dvb_demux.c b/drivers/media/dvb-core/dvb_demux.c
index 6c7ff0cdcd32..d83dd0eb5757 100644
--- a/drivers/media/dvb-core/dvb_demux.c
+++ b/drivers/media/dvb-core/dvb_demux.c
@@ -399,28 +399,23 @@ static void dvb_dmx_swfilter_packet(struct dvb_demux *demux, const u8 *buf)
 	int dvr_done = 0;
 
 	if (dvb_demux_speedcheck) {
-		struct timespec cur_time, delta_time;
+		ktime_t cur_time;
 		u64 speed_bytes, speed_timedelta;
 
 		demux->speed_pkts_cnt++;
 
 		/* show speed every SPEED_PKTS_INTERVAL packets */
 		if (!(demux->speed_pkts_cnt % SPEED_PKTS_INTERVAL)) {
-			cur_time = current_kernel_time();
+			cur_time = ktime_get();
 
-			if (demux->speed_last_time.tv_sec != 0 &&
-					demux->speed_last_time.tv_nsec != 0) {
-				delta_time = timespec_sub(cur_time,
-						demux->speed_last_time);
+			if (ktime_to_ns(demux->speed_last_time) == 0) {
 				speed_bytes = (u64)demux->speed_pkts_cnt
 					* 188 * 8;
 				/* convert to 1024 basis */
 				speed_bytes = 1000 * div64_u64(speed_bytes,
 						1024);
-				speed_timedelta =
-					(u64)timespec_to_ns(&delta_time);
-				speed_timedelta = div64_u64(speed_timedelta,
-						1000000); /* nsec -> usec */
+				speed_timedelta = ktime_ms_delta(cur_time,
+							demux->speed_last_time);
 				printk(KERN_INFO "TS speed %llu Kbits/sec \n",
 						div64_u64(speed_bytes,
 							speed_timedelta));
@@ -667,7 +662,7 @@ out:
 
 static int dmx_ts_feed_set(struct dmx_ts_feed *ts_feed, u16 pid, int ts_type,
 			   enum dmx_ts_pes pes_type,
-			   size_t circular_buffer_size, struct timespec timeout)
+			   size_t circular_buffer_size, ktime_t timeout)
 {
 	struct dvb_demux_feed *feed = (struct dvb_demux_feed *)ts_feed;
 	struct dvb_demux *demux = feed->demux;
diff --git a/drivers/media/dvb-core/dvb_demux.h b/drivers/media/dvb-core/dvb_demux.h
index ae7fc33c3231..5ed3cab4ad28 100644
--- a/drivers/media/dvb-core/dvb_demux.h
+++ b/drivers/media/dvb-core/dvb_demux.h
@@ -83,7 +83,7 @@ struct dvb_demux_feed {
 	u8 *buffer;
 	int buffer_size;
 
-	struct timespec timeout;
+	ktime_t timeout;
 	struct dvb_demux_filter *filter;
 
 	int ts_type;
@@ -134,7 +134,7 @@ struct dvb_demux {
 
 	uint8_t *cnt_storage; /* for TS continuity check */
 
-	struct timespec speed_last_time; /* for TS speed check */
+	ktime_t speed_last_time; /* for TS speed check */
 	uint32_t speed_pkts_cnt; /* for TS speed check */
 };
 
diff --git a/drivers/media/dvb-core/dvb_net.c b/drivers/media/dvb-core/dvb_net.c
index b81e026edab3..df3ba15c007e 100644
--- a/drivers/media/dvb-core/dvb_net.c
+++ b/drivers/media/dvb-core/dvb_net.c
@@ -998,7 +998,7 @@ static int dvb_net_feed_start(struct net_device *dev)
 		netdev_dbg(dev, "start filtering\n");
 		priv->secfeed->start_filtering(priv->secfeed);
 	} else if (priv->feedtype == DVB_NET_FEEDTYPE_ULE) {
-		struct timespec timeout = { 0, 10000000 }; // 10 msec
+		ktime_t timeout = ns_to_ktime(10 * NSEC_PER_MSEC);
 
 		/* we have payloads encapsulated in TS */
 		netdev_dbg(dev, "alloc tsfeed\n");
-- 
2.1.0.rc2

