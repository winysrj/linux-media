Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:39216 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752016AbbJJNgS (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 10 Oct 2015 09:36:18 -0400
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Subject: [PATCH 17/26] [media] DocBook: document the other structs/enums of demux.h
Date: Sat, 10 Oct 2015 10:36:00 -0300
Message-Id: <548e5ae0bd572509ee49e3684a20a3fa696181cb.1444483819.git.mchehab@osg.samsung.com>
In-Reply-To: <cover.1444483819.git.mchehab@osg.samsung.com>
References: <cover.1444483819.git.mchehab@osg.samsung.com>
In-Reply-To: <cover.1444483819.git.mchehab@osg.samsung.com>
References: <cover.1444483819.git.mchehab@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Document the following data types:
	struct dmx_ts_feed
	struct dmx_section_filter
	struct dmx_section_feed
	enum dmx_frontend_source
	struct dmx_frontend

Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>

diff --git a/drivers/media/dvb-core/demux.h b/drivers/media/dvb-core/demux.h
index 15b79bdee465..b344cad096cd 100644
--- a/drivers/media/dvb-core/demux.h
+++ b/drivers/media/dvb-core/demux.h
@@ -68,10 +68,24 @@
 #define TS_DEMUX        8   /* in case TS_PACKET is set, send the TS to
 			       the demux device, not to the dvr device */
 
+/**
+ * struct dmx_ts_feed - Structure that contains a TS feed filter
+ *
+ * @is_filtering:	Set to non-zero when filtering in progress
+ * @parent:		pointer to struct dmx_demux
+ * @priv:		pointer to private data of the API client
+ * @set:		sets the TS filter
+ * @start_filtering:	starts TS filtering
+ * @stop_filtering:	stops TS filtering
+ *
+ * A TS feed is typically mapped to a hardware PID filter on the demux chip.
+ * Using this API, the client can set the filtering properties to start/stop
+ * filtering TS packets on a particular TS feed.
+ */
 struct dmx_ts_feed {
-	int is_filtering; /* Set to non-zero when filtering in progress */
-	struct dmx_demux *parent; /* Back-pointer */
-	void *priv; /* Pointer to private data of the API client */
+	int is_filtering;
+	struct dmx_demux *parent;
+	void *priv;
 	int (*set) (struct dmx_ts_feed *feed,
 		    u16 pid,
 		    int type,
@@ -86,6 +100,24 @@ struct dmx_ts_feed {
 /* Section reception */
 /*--------------------------------------------------------------------------*/
 
+/**
+ * struct dmx_section_filter - Structure that describes a section filter
+ *
+ * @filter_value: Contains up to 16 bytes (128 bits) of the TS section header
+ *		  that will be matched by the section filter
+ * @filter_mask:  Contains a 16 bytes (128 bits) filter mask with the bits
+ *		  specified by @filter_value that will be used on the filter
+ *		  match logic.
+ * @filter_mode:  Contains a 16 bytes (128 bits) filter mode.
+ * @parent:	  Pointer to struct dmx_section_feed.
+ * @priv:	  Pointer to private data of the API client.
+ *
+ *
+ * The @filter_mask controls which bits of @filter_value are compared with
+ * the section headers/payload. On a binary value of 1 in filter_mask, the
+ * corresponding bits are compared. The filter only accepts sections that are
+ * equal to filter_value in all the tested bit positions.
+ */
 struct dmx_section_filter {
 	u8 filter_value [DMX_MAX_FILTER_SIZE];
 	u8 filter_mask [DMX_MAX_FILTER_SIZE];
@@ -94,18 +126,46 @@ struct dmx_section_filter {
 	void* priv; /* Pointer to private data of the API client */
 };
 
+/**
+ * struct dmx_section_feed - Structure that contains a section feed filter
+ *
+ * @is_filtering:	Set to non-zero when filtering in progress
+ * @parent:		pointer to struct dmx_demux
+ * @priv:		pointer to private data of the API client
+ * @check_crc:		If non-zero, check the CRC values of filtered sections.
+ * @set:		sets the section filter
+ * @allocate_filter:	This function is used to allocate a section filter on
+ *			the demux. It should only be called when no filtering
+ *			is in progress on this section feed. If a filter cannot
+ *			be allocated, the function fails with -ENOSPC.
+ * @release_filter:	This function releases all the resources of a
+ * 			previously allocated section filter. The function
+ *			should not be called while filtering is in progress
+ *			on this section feed. After calling this function,
+ *			the caller should not try to dereference the filter
+ *			pointer.
+ * @start_filtering:	starts section filtering
+ * @stop_filtering:	stops section filtering
+ *
+ * A TS feed is typically mapped to a hardware PID filter on the demux chip.
+ * Using this API, the client can set the filtering properties to start/stop
+ * filtering TS packets on a particular TS feed.
+ */
 struct dmx_section_feed {
-	int is_filtering; /* Set to non-zero when filtering in progress */
-	struct dmx_demux* parent; /* Back-pointer */
-	void* priv; /* Pointer to private data of the API client */
+	int is_filtering;
+	struct dmx_demux* parent;
+	void* priv;
 
 	int check_crc;
+
+	/* private: Used internally at dvb_demux.c */
 	u32 crc_val;
 
 	u8 *secbuf;
 	u8 secbuf_base[DMX_MAX_SECFEED_SIZE];
 	u16 secbufp, seclen, tsfeedp;
 
+	/* public: */
 	int (*set) (struct dmx_section_feed* feed,
 		    u16 pid,
 		    size_t circular_buffer_size,
@@ -138,15 +198,34 @@ typedef int (*dmx_section_cb) (	const u8 * buffer1,
 /* DVB Front-End */
 /*--------------------------------------------------------------------------*/
 
+/**
+ * enum dmx_frontend_source - Used to identify the type of frontend
+ *
+ * @DMX_MEMORY_FE:	The source of the demux is memory. It means that
+ *			the MPEG-TS to be filtered comes from userspace,
+ *			via write() syscall.
+ *
+ * @DMX_FRONTEND_0:	The source of the demux is a frontend connected
+ *			to the demux.
+ */
 enum dmx_frontend_source {
 	DMX_MEMORY_FE,
 	DMX_FRONTEND_0,
 };
 
+/**
+ * struct dmx_frontend - Structure that lists the frontends associated with
+ *			 a demux
+ *
+ * @connectivity_list:	List of front-ends that can be connected to a
+ *			particular demux;
+ * @source:		Type of the frontend.
+ *
+ * FIXME: this structure should likely be replaced soon by some
+ *	media-controller based logic.
+ */
 struct dmx_frontend {
-	struct list_head connectivity_list; /* List of front-ends that can
-					       be connected to a particular
-					       demux */
+	struct list_head connectivity_list;
 	enum dmx_frontend_source source;
 };
 
-- 
2.4.3


