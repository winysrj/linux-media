Return-path: <linux-media-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:50372
        "EHLO osg.samsung.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751738AbdITTMB (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 20 Sep 2017 15:12:01 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Sakari Ailus <sakari.ailus@linux.intel.com>
Subject: [PATCH 22/25] media: dmxdev.h: add kernel-doc markups for data types and functions
Date: Wed, 20 Sep 2017 16:11:47 -0300
Message-Id: <ae11b2c87851068072d5d000b8ec2625c5901af2.1505933919.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1505933919.git.mchehab@s-opensource.com>
References: <cover.1505933919.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1505933919.git.mchehab@s-opensource.com>
References: <cover.1505933919.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Despite being used by DVB drivers, this header was not documented.

Document it.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 drivers/media/dvb-core/dmxdev.h | 90 ++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 88 insertions(+), 2 deletions(-)

diff --git a/drivers/media/dvb-core/dmxdev.h b/drivers/media/dvb-core/dmxdev.h
index 054fd4eb6192..9aa3ce3fc407 100644
--- a/drivers/media/dvb-core/dmxdev.h
+++ b/drivers/media/dvb-core/dmxdev.h
@@ -36,12 +36,33 @@
 #include "demux.h"
 #include "dvb_ringbuffer.h"
 
+/**
+ * enum dmxdev_type - type of demux filter type.
+ *
+ * @DMXDEV_TYPE_NONE:	no filter set.
+ * @DMXDEV_TYPE_SEC:	section filter.
+ * @DMXDEV_TYPE_PES:	Program Elementary Stream (PES) filter.
+ */
 enum dmxdev_type {
 	DMXDEV_TYPE_NONE,
 	DMXDEV_TYPE_SEC,
 	DMXDEV_TYPE_PES,
 };
 
+/**
+ * enum dmxdev_state - state machine for the dmxdev.
+ *
+ * @DMXDEV_STATE_FREE:		indicates that the filter is freed.
+ * @DMXDEV_STATE_ALLOCATED:	indicates that the filter was allocated
+ *				to be used.
+ * @DMXDEV_STATE_SET:		indicates that the filter parameters are set.
+ * @DMXDEV_STATE_GO:		indicates that the filter is running.
+ * @DMXDEV_STATE_DONE:		indicates that a packet was already filtered
+ * 				and the filter is now disabled.
+ * 				Set only if %DMX_ONESHOT. See
+ *				&dmx_sct_filter_params.
+ * @DMXDEV_STATE_TIMEDOUT:	Indicates a timeout condition.
+ */
 enum dmxdev_state {
 	DMXDEV_STATE_FREE,
 	DMXDEV_STATE_ALLOCATED,
@@ -51,12 +72,49 @@ enum dmxdev_state {
 	DMXDEV_STATE_TIMEDOUT
 };
 
+/**
+ * struct dmxdev_feed - digital TV dmxdev feed
+ *
+ * @pid:	Program ID to be filtered
+ * @ts:		pointer to &struct dmx_ts_feed
+ * @next:	&struct list_head pointing to the next feed.
+ */
+
 struct dmxdev_feed {
 	u16 pid;
 	struct dmx_ts_feed *ts;
 	struct list_head next;
 };
 
+/**
+ * struct dmxdev_filter - digital TV dmxdev filter
+ *
+ * @filter:	a dmxdev filter. Currently used only for section filter:
+ *		if the filter is Section, it contains a
+ *		&struct dmx_section_filter @sec pointer.
+ * @feed:	a dmxdev feed. Depending on the feed type, it can be:
+ *		for TS feed: a &struct list_head @ts list of TS and PES
+ *		feeds;
+ *		for section feed: a &struct dmx_section_feed @sec pointer.
+ * @params:	dmxdev filter parameters. Depending on the feed type, it
+ *		can be:
+ *		for section filter: a &struct dmx_sct_filter_params @sec
+ *		embedded struct;
+ *		for a TS filter: a &struct dmx_pes_filter_params @pes
+ *		embedded struct.
+ * @type:	type of the dmxdev filter, as defined by &enum dmxdev_type.
+ * @state:	state of the dmxdev filter, as defined by &enum dmxdev_state.
+ * @dev:	pointer to &struct dmxdev.
+ * @buffer:	an embedded &struct dvb_ringbuffer buffer.
+ * @mutex:	protects the access to &struct dmxdev_filter.
+ * @timer:	&struct timer_list embedded timer, used to check for
+ *		feed timeouts.
+ * 		Only for section filter.
+ * @todo:	index for the @secheader.
+ * 		Only for section filter.
+ * @secheader:	buffer cache to parse the section header.
+ * 		Only for section filter.
+ */
 struct dmxdev_filter {
 	union {
 		struct dmx_section_filter *sec;
@@ -86,7 +144,23 @@ struct dmxdev_filter {
 	u8 secheader[3];
 };
 
-
+/**
+ * struct dmxdev - Describes a digital TV demux device.
+ *
+ * @dvbdev:		pointer to &struct dvb_device associated with
+ *			the demux device node.
+ * @dvr_dvbdev:		pointer to &struct dvb_device associated with
+ *			the dvr device node.
+ * @filter:		pointer to &struct dmxdev_filter.
+ * @demux:		pointer to &struct dmx_demux.
+ * @filternum:		number of filters.
+ * @capabilities:	demux capabilities as defined by &enum dmx_demux_caps.
+ * @exit:		flag to indicate that the demux is being released.
+ * @dvr_orig_fe:	pointer to &struct dmx_frontend.
+ * @dvr_buffer:		embedded &struct dvb_ringbuffer for DVB output.
+ * @mutex:		protects the usage of this structure.
+ * @lock:		protects access to &dmxdev->filter->data.
+ */
 struct dmxdev {
 	struct dvb_device *dvbdev;
 	struct dvb_device *dvr_dvbdev;
@@ -108,8 +182,20 @@ struct dmxdev {
 	spinlock_t lock;
 };
 
+/**
+ * dvb_dmxdev_init - initializes a digital TV demux and registers both demux
+ * 	and DVR devices.
+ *
+ * @dmxdev: pointer to &struct dmxdev.
+ * @adap: pointer to &struct dvb_adapter.
+ */
+int dvb_dmxdev_init(struct dmxdev *dmxdev, struct dvb_adapter *adap);
 
-int dvb_dmxdev_init(struct dmxdev *dmxdev, struct dvb_adapter *);
+/**
+ * dvb_dmxdev_release - releases a digital TV demux and unregisters it.
+ *
+ * @dmxdev: pointer to &struct dmxdev.
+ */
 void dvb_dmxdev_release(struct dmxdev *dmxdev);
 
 #endif /* _DMXDEV_H_ */
-- 
2.13.5
