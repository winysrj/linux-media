Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:48653 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755255AbcJNRrH (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 14 Oct 2016 13:47:07 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCH 14/25] [media] dvb-core: get rid of demux optional circular buffer
Date: Fri, 14 Oct 2016 14:45:52 -0300
Message-Id: <53be51345662a225f5476b40c31daa7708843412.1476466574.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1476466574.git.mchehab@s-opensource.com>
References: <cover.1476466574.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1476466574.git.mchehab@s-opensource.com>
References: <cover.1476466574.git.mchehab@s-opensource.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

There is a provision at the dvb_demux.c to use a vmalloc'ed
circular buffer, enabled via an extra #ifdef option that it
is not at Kconfig. Enabling it will only make the Kernel to
allocate/deallocate such buffer, but no code would actually
use it. So, no practical effect, except for sparing some
memory without any good reason.

So, get rid of such dead code.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 drivers/media/dvb-core/demux.h     |  5 +----
 drivers/media/dvb-core/dmxdev.c    |  4 ++--
 drivers/media/dvb-core/dvb_demux.c | 42 ++------------------------------------
 drivers/media/dvb-core/dvb_demux.h |  2 --
 drivers/media/dvb-core/dvb_net.c   |  3 +--
 5 files changed, 6 insertions(+), 50 deletions(-)

diff --git a/drivers/media/dvb-core/demux.h b/drivers/media/dvb-core/demux.h
index aeda2b64931c..f8adf4506a45 100644
--- a/drivers/media/dvb-core/demux.h
+++ b/drivers/media/dvb-core/demux.h
@@ -103,7 +103,6 @@ struct dmx_ts_feed {
 		   u16 pid,
 		   int type,
 		   enum dmx_ts_pes pes_type,
-		   size_t circular_buffer_size,
 		   ktime_t timeout);
 	int (*start_filtering)(struct dmx_ts_feed *feed);
 	int (*stop_filtering)(struct dmx_ts_feed *feed);
@@ -181,7 +180,6 @@ struct dmx_section_feed {
 	/* public: */
 	int (*set)(struct dmx_section_feed *feed,
 		   u16 pid,
-		   size_t circular_buffer_size,
 		   int check_crc);
 	int (*allocate_filter)(struct dmx_section_feed *feed,
 			       struct dmx_section_filter **filter);
@@ -206,8 +204,7 @@ struct dmx_section_feed {
  * the &dmx_demux.
  * Any TS packets that match the filter settings are copied to a circular
  * buffer. The filtered TS packets are delivered to the client using this
- * callback function. The size of the circular buffer is controlled by the
- * circular_buffer_size parameter of the &dmx_ts_feed.@set function.
+ * callback function.
  * It is expected that the @buffer1 and @buffer2 callback parameters point to
  * addresses within the circular buffer, but other implementations are also
  * possible. Note that the called party should not try to free the memory
diff --git a/drivers/media/dvb-core/dmxdev.c b/drivers/media/dvb-core/dmxdev.c
index 1e96a6f1b6f0..efe55a3e80d0 100644
--- a/drivers/media/dvb-core/dmxdev.c
+++ b/drivers/media/dvb-core/dmxdev.c
@@ -595,7 +595,7 @@ static int dvb_dmxdev_start_feed(struct dmxdev *dmxdev,
 	tsfeed = feed->ts;
 	tsfeed->priv = filter;
 
-	ret = tsfeed->set(tsfeed, feed->pid, ts_type, ts_pes, 32768, timeout);
+	ret = tsfeed->set(tsfeed, feed->pid, ts_type, ts_pes, timeout);
 	if (ret < 0) {
 		dmxdev->demux->release_ts_feed(dmxdev->demux, tsfeed);
 		return ret;
@@ -666,7 +666,7 @@ static int dvb_dmxdev_filter_start(struct dmxdev_filter *filter)
 				return ret;
 			}
 
-			ret = (*secfeed)->set(*secfeed, para->pid, 32768,
+			ret = (*secfeed)->set(*secfeed, para->pid,
 					      (para->flags & DMX_CHECK_CRC) ? 1 : 0);
 			if (ret < 0) {
 				pr_err("DVB (%s): could not set feed\n",
diff --git a/drivers/media/dvb-core/dvb_demux.c b/drivers/media/dvb-core/dvb_demux.c
index 51bf5eb2df49..3ad0b2cd26b1 100644
--- a/drivers/media/dvb-core/dvb_demux.c
+++ b/drivers/media/dvb-core/dvb_demux.c
@@ -36,8 +36,6 @@
 
 #include "dvb_demux.h"
 
-#define NOBUFS
-
 static int dvb_demux_tscheck;
 module_param(dvb_demux_tscheck, int, 0644);
 MODULE_PARM_DESC(dvb_demux_tscheck,
@@ -663,8 +661,7 @@ static void dvb_demux_feed_del(struct dvb_demux_feed *feed)
 }
 
 static int dmx_ts_feed_set(struct dmx_ts_feed *ts_feed, u16 pid, int ts_type,
-			   enum dmx_ts_pes pes_type,
-			   size_t circular_buffer_size, ktime_t timeout)
+			   enum dmx_ts_pes pes_type, ktime_t timeout)
 {
 	struct dvb_demux_feed *feed = (struct dvb_demux_feed *)ts_feed;
 	struct dvb_demux *demux = feed->demux;
@@ -694,23 +691,10 @@ static int dmx_ts_feed_set(struct dmx_ts_feed *ts_feed, u16 pid, int ts_type,
 	dvb_demux_feed_add(feed);
 
 	feed->pid = pid;
-	feed->buffer_size = circular_buffer_size;
 	feed->timeout = timeout;
 	feed->ts_type = ts_type;
 	feed->pes_type = pes_type;
 
-	if (feed->buffer_size) {
-#ifdef NOBUFS
-		feed->buffer = NULL;
-#else
-		feed->buffer = vmalloc(feed->buffer_size);
-		if (!feed->buffer) {
-			mutex_unlock(&demux->mutex);
-			return -ENOMEM;
-		}
-#endif
-	}
-
 	feed->state = DMX_STATE_READY;
 	mutex_unlock(&demux->mutex);
 
@@ -799,7 +783,6 @@ static int dvbdmx_allocate_ts_feed(struct dmx_demux *dmx,
 	feed->demux = demux;
 	feed->pid = 0xffff;
 	feed->peslen = 0xfffa;
-	feed->buffer = NULL;
 
 	(*ts_feed) = &feed->feed.ts;
 	(*ts_feed)->parent = dmx;
@@ -836,10 +819,6 @@ static int dvbdmx_release_ts_feed(struct dmx_demux *dmx,
 		mutex_unlock(&demux->mutex);
 		return -EINVAL;
 	}
-#ifndef NOBUFS
-	vfree(feed->buffer);
-	feed->buffer = NULL;
-#endif
 
 	feed->state = DMX_STATE_FREE;
 	feed->filter->state = DMX_STATE_FREE;
@@ -891,8 +870,7 @@ static int dmx_section_feed_allocate_filter(struct dmx_section_feed *feed,
 }
 
 static int dmx_section_feed_set(struct dmx_section_feed *feed,
-				u16 pid, size_t circular_buffer_size,
-				int check_crc)
+				u16 pid, int check_crc)
 {
 	struct dvb_demux_feed *dvbdmxfeed = (struct dvb_demux_feed *)feed;
 	struct dvb_demux *dvbdmx = dvbdmxfeed->demux;
@@ -906,19 +884,8 @@ static int dmx_section_feed_set(struct dmx_section_feed *feed,
 	dvb_demux_feed_add(dvbdmxfeed);
 
 	dvbdmxfeed->pid = pid;
-	dvbdmxfeed->buffer_size = circular_buffer_size;
 	dvbdmxfeed->feed.sec.check_crc = check_crc;
 
-#ifdef NOBUFS
-	dvbdmxfeed->buffer = NULL;
-#else
-	dvbdmxfeed->buffer = vmalloc(dvbdmxfeed->buffer_size);
-	if (!dvbdmxfeed->buffer) {
-		mutex_unlock(&dvbdmx->mutex);
-		return -ENOMEM;
-	}
-#endif
-
 	dvbdmxfeed->state = DMX_STATE_READY;
 	mutex_unlock(&dvbdmx->mutex);
 	return 0;
@@ -1077,7 +1044,6 @@ static int dvbdmx_allocate_section_feed(struct dmx_demux *demux,
 	dvbdmxfeed->feed.sec.secbufp = dvbdmxfeed->feed.sec.seclen = 0;
 	dvbdmxfeed->feed.sec.tsfeedp = 0;
 	dvbdmxfeed->filter = NULL;
-	dvbdmxfeed->buffer = NULL;
 
 	(*feed) = &dvbdmxfeed->feed.sec;
 	(*feed)->is_filtering = 0;
@@ -1106,10 +1072,6 @@ static int dvbdmx_release_section_feed(struct dmx_demux *demux,
 		mutex_unlock(&dvbdmx->mutex);
 		return -EINVAL;
 	}
-#ifndef NOBUFS
-	vfree(dvbdmxfeed->buffer);
-	dvbdmxfeed->buffer = NULL;
-#endif
 	dvbdmxfeed->state = DMX_STATE_FREE;
 
 	dvb_demux_feed_del(dvbdmxfeed);
diff --git a/drivers/media/dvb-core/dvb_demux.h b/drivers/media/dvb-core/dvb_demux.h
index 5ed3cab4ad28..9235b008ea0a 100644
--- a/drivers/media/dvb-core/dvb_demux.h
+++ b/drivers/media/dvb-core/dvb_demux.h
@@ -80,8 +80,6 @@ struct dvb_demux_feed {
 	int type;
 	int state;
 	u16 pid;
-	u8 *buffer;
-	int buffer_size;
 
 	ktime_t timeout;
 	struct dvb_demux_filter *filter;
diff --git a/drivers/media/dvb-core/dvb_net.c b/drivers/media/dvb-core/dvb_net.c
index 063f63563919..b9a46d5a1bb5 100644
--- a/drivers/media/dvb-core/dvb_net.c
+++ b/drivers/media/dvb-core/dvb_net.c
@@ -969,7 +969,7 @@ static int dvb_net_feed_start(struct net_device *dev)
 			goto error;
 		}
 
-		ret = priv->secfeed->set(priv->secfeed, priv->pid, 32768, 1);
+		ret = priv->secfeed->set(priv->secfeed, priv->pid, 1);
 
 		if (ret<0) {
 			pr_err("%s: could not set section feed\n", dev->name);
@@ -1023,7 +1023,6 @@ static int dvb_net_feed_start(struct net_device *dev)
 					priv->pid, /* pid */
 					TS_PACKET, /* type */
 					DMX_PES_OTHER, /* pes type */
-					32768,     /* circular buffer size */
 					timeout    /* timeout */
 					);
 
-- 
2.7.4


