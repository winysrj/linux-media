Return-path: <linux-media-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:50364
        "EHLO osg.samsung.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751693AbdITTMB (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 20 Sep 2017 15:12:01 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Sakari Ailus <sakari.ailus@linux.intel.com>
Subject: [PATCH 20/25] media: dvb_demux.h: document functions
Date: Wed, 20 Sep 2017 16:11:45 -0300
Message-Id: <45c0bfe2e8e4f3d953b39d92ceb5d1a01a8fbc68.1505933919.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1505933919.git.mchehab@s-opensource.com>
References: <cover.1505933919.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1505933919.git.mchehab@s-opensource.com>
References: <cover.1505933919.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The functions used on dvb_demux.h are largely used on DVB drivers.
Yet, none of them are documented.

No functional changes.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 drivers/media/dvb-core/dvb_demux.h | 106 +++++++++++++++++++++++++++++++++++--
 1 file changed, 103 insertions(+), 3 deletions(-)

diff --git a/drivers/media/dvb-core/dvb_demux.h b/drivers/media/dvb-core/dvb_demux.h
index 43b0cab2e932..15ee2ea23efe 100644
--- a/drivers/media/dvb-core/dvb_demux.h
+++ b/drivers/media/dvb-core/dvb_demux.h
@@ -232,13 +232,113 @@ struct dvb_demux {
 	int recording;
 };
 
-int dvb_dmx_init(struct dvb_demux *dvbdemux);
-void dvb_dmx_release(struct dvb_demux *dvbdemux);
-void dvb_dmx_swfilter_packets(struct dvb_demux *dvbdmx, const u8 *buf,
+/**
+ * dvb_dmx_init - initialize a digital TV demux struct.
+ *
+ * @demux: &struct dvb_demux to be initialized.
+ *
+ * Before being able to register a digital TV demux struct, drivers
+ * should call this routine. On its typical usage, some fields should
+ * be initialized at the driver before calling it.
+ *
+ * A typical usecase is::
+ *
+ *	dvb->demux.dmx.capabilities =
+ *		DMX_TS_FILTERING | DMX_SECTION_FILTERING |
+ *		DMX_MEMORY_BASED_FILTERING;
+ *	dvb->demux.priv       = dvb;
+ *	dvb->demux.filternum  = 256;
+ *	dvb->demux.feednum    = 256;
+ *	dvb->demux.start_feed = driver_start_feed;
+ *	dvb->demux.stop_feed  = driver_stop_feed;
+ *	ret = dvb_dmx_init(&dvb->demux);
+ *	if (ret < 0)
+ *		return ret;
+ */
+int dvb_dmx_init(struct dvb_demux *demux);
+
+/**
+ * dvb_dmx_release - releases a digital TV demux internal buffers.
+ *
+ * @demux: &struct dvb_demux to be released.
+ *
+ * The DVB core internally allocates data at @demux. This routine
+ * releases those data. Please notice that the struct itelf is not
+ * released, as it can be embedded on other structs.
+ */
+void dvb_dmx_release(struct dvb_demux *demux);
+
+/**
+ * dvb_dmx_swfilter_packets - use dvb software filter for a buffer with
+ *	multiple MPEG-TS packets with 188 bytes each.
+ *
+ * @demux: pointer to &struct dvb_demux
+ * @buf: buffer with data to be filtered
+ * @count: number of MPEG-TS packets with size of 188.
+ *
+ * The routine will discard a DVB packet that don't start with 0x47.
+ *
+ * Use this routine if the DVB demux fills MPEG-TS buffers that are
+ * already aligned.
+ *
+ * NOTE: The @buf size should have size equal to ``count * 188``.
+ */
+void dvb_dmx_swfilter_packets(struct dvb_demux *demux, const u8 *buf,
 			      size_t count);
+
+/**
+ * dvb_dmx_swfilter -  use dvb software filter for a buffer with
+ *	multiple MPEG-TS packets with 188 bytes each.
+ *
+ * @demux: pointer to &struct dvb_demux
+ * @buf: buffer with data to be filtered
+ * @count: number of MPEG-TS packets with size of 188.
+ *
+ * If a DVB packet doesn't start with 0x47, it will seek for the first
+ * byte that starts with 0x47.
+ *
+ * Use this routine if the DVB demux fill buffers that may not start with
+ * a packet start mark (0x47).
+ *
+ * NOTE: The @buf size should have size equal to ``count * 188``.
+ */
 void dvb_dmx_swfilter(struct dvb_demux *demux, const u8 *buf, size_t count);
+
+/**
+ * dvb_dmx_swfilter_204 -  use dvb software filter for a buffer with
+ *	multiple MPEG-TS packets with 204 bytes each.
+ *
+ * @demux: pointer to &struct dvb_demux
+ * @buf: buffer with data to be filtered
+ * @count: number of MPEG-TS packets with size of 204.
+ *
+ * If a DVB packet doesn't start with 0x47, it will seek for the first
+ * byte that starts with 0x47.
+ *
+ * Use this routine if the DVB demux fill buffers that may not start with
+ * a packet start mark (0x47).
+ *
+ * NOTE: The @buf size should have size equal to ``count * 204``.
+ */
 void dvb_dmx_swfilter_204(struct dvb_demux *demux, const u8 *buf,
 			  size_t count);
+
+/**
+ * dvb_dmx_swfilter_raw -  make the raw data available to userspace without
+ * 	filtering
+ *
+ * @demux: pointer to &struct dvb_demux
+ * @buf: buffer with data
+ * @count: number of packets to be passed. The actual size of each packet
+ *	depends on the &dvb_demux->feed->cb.ts logic.
+ *
+ * Use it if the driver needs to deliver the raw payload to userspace without
+ * passing through the kernel demux. That is meant to support some
+ * delivery systems that aren't based on MPEG-TS.
+ *
+ * This function relies on &dvb_demux->feed->cb.ts to actually handle the
+ * buffer.
+ */
 void dvb_dmx_swfilter_raw(struct dvb_demux *demux, const u8 *buf,
 			  size_t count);
 
-- 
2.13.5
