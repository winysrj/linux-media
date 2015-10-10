Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:39218 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752018AbbJJNgS (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 10 Oct 2015 09:36:18 -0400
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Subject: [PATCH 18/26] [media] demux.h: make checkpatch.ph happy
Date: Sat, 10 Oct 2015 10:36:01 -0300
Message-Id: <abfc97f722348032c9b6b2cd8f464446aaac6a72.1444483819.git.mchehab@osg.samsung.com>
In-Reply-To: <cover.1444483819.git.mchehab@osg.samsung.com>
References: <cover.1444483819.git.mchehab@osg.samsung.com>
In-Reply-To: <cover.1444483819.git.mchehab@osg.samsung.com>
References: <cover.1444483819.git.mchehab@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

There are lots of CodingStyle violations here. Now that we're
touching a log on this header files, adding the documentation
here, make sure that this will follow the Kernel CodingStyle.

Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>

diff --git a/drivers/media/dvb-core/demux.h b/drivers/media/dvb-core/demux.h
index b344cad096cd..7405d6e2297d 100644
--- a/drivers/media/dvb-core/demux.h
+++ b/drivers/media/dvb-core/demux.h
@@ -32,9 +32,9 @@
 #include <linux/time.h>
 #include <linux/dvb/dmx.h>
 
-/*--------------------------------------------------------------------------*/
-/* Common definitions */
-/*--------------------------------------------------------------------------*/
+/*
+ * Common definitions
+ */
 
 /*
  * DMX_MAX_FILTER_SIZE: Maximum length (in bytes) of a section/PES filter.
@@ -45,7 +45,8 @@
 #endif
 
 /*
- * DMX_MAX_SECFEED_SIZE: Maximum length (in bytes) of a private section feed filter.
+ * DMX_MAX_SECFEED_SIZE: Maximum length (in bytes) of a private section feed
+ * filter.
  */
 
 #ifndef DMX_MAX_SECTION_SIZE
@@ -55,18 +56,30 @@
 #define DMX_MAX_SECFEED_SIZE (DMX_MAX_SECTION_SIZE + 188)
 #endif
 
-/*--------------------------------------------------------------------------*/
-/* TS packet reception */
-/*--------------------------------------------------------------------------*/
+/*
+ * TS packet reception
+ */
 
 /* TS filter type for set() */
 
-#define TS_PACKET       1   /* send TS packets (188 bytes) to callback (default) */
-#define	TS_PAYLOAD_ONLY 2   /* in case TS_PACKET is set, only send the TS
-			       payload (<=184 bytes per packet) to callback */
-#define TS_DECODER      4   /* send stream to built-in decoder (if present) */
-#define TS_DEMUX        8   /* in case TS_PACKET is set, send the TS to
-			       the demux device, not to the dvr device */
+#define TS_PACKET       1   /*
+			     * send TS packets (188 bytes) to callback
+			     * (default)
+			     */
+
+#define	TS_PAYLOAD_ONLY 2   /*
+			     * in case TS_PACKET is set, only send the TS
+			     * payload (<=184 bytes per packet) to callback
+			     */
+
+#define TS_DECODER      4   /*
+			     * send stream to built-in decoder (if present)
+			     */
+
+#define TS_DEMUX        8   /*
+			     * in case TS_PACKET is set, send the TS to
+			     * the demux device, not to the dvr device
+			     */
 
 /**
  * struct dmx_ts_feed - Structure that contains a TS feed filter
@@ -86,19 +99,19 @@ struct dmx_ts_feed {
 	int is_filtering;
 	struct dmx_demux *parent;
 	void *priv;
-	int (*set) (struct dmx_ts_feed *feed,
-		    u16 pid,
-		    int type,
-		    enum dmx_ts_pes pes_type,
-		    size_t circular_buffer_size,
-		    struct timespec timeout);
-	int (*start_filtering) (struct dmx_ts_feed* feed);
-	int (*stop_filtering) (struct dmx_ts_feed* feed);
+	int (*set)(struct dmx_ts_feed *feed,
+		   u16 pid,
+		   int type,
+		   enum dmx_ts_pes pes_type,
+		   size_t circular_buffer_size,
+		   struct timespec timeout);
+	int (*start_filtering)(struct dmx_ts_feed *feed);
+	int (*stop_filtering)(struct dmx_ts_feed *feed);
 };
 
-/*--------------------------------------------------------------------------*/
-/* Section reception */
-/*--------------------------------------------------------------------------*/
+/*
+ * Section reception
+ */
 
 /**
  * struct dmx_section_filter - Structure that describes a section filter
@@ -119,11 +132,11 @@ struct dmx_ts_feed {
  * equal to filter_value in all the tested bit positions.
  */
 struct dmx_section_filter {
-	u8 filter_value [DMX_MAX_FILTER_SIZE];
-	u8 filter_mask [DMX_MAX_FILTER_SIZE];
-	u8 filter_mode [DMX_MAX_FILTER_SIZE];
-	struct dmx_section_feed* parent; /* Back-pointer */
-	void* priv; /* Pointer to private data of the API client */
+	u8 filter_value[DMX_MAX_FILTER_SIZE];
+	u8 filter_mask[DMX_MAX_FILTER_SIZE];
+	u8 filter_mode[DMX_MAX_FILTER_SIZE];
+	struct dmx_section_feed *parent; /* Back-pointer */
+	void *priv; /* Pointer to private data of the API client */
 };
 
 /**
@@ -139,7 +152,7 @@ struct dmx_section_filter {
  *			is in progress on this section feed. If a filter cannot
  *			be allocated, the function fails with -ENOSPC.
  * @release_filter:	This function releases all the resources of a
- * 			previously allocated section filter. The function
+ *			previously allocated section filter. The function
  *			should not be called while filtering is in progress
  *			on this section feed. After calling this function,
  *			the caller should not try to dereference the filter
@@ -153,8 +166,8 @@ struct dmx_section_filter {
  */
 struct dmx_section_feed {
 	int is_filtering;
-	struct dmx_demux* parent;
-	void* priv;
+	struct dmx_demux *parent;
+	void *priv;
 
 	int check_crc;
 
@@ -166,33 +179,33 @@ struct dmx_section_feed {
 	u16 secbufp, seclen, tsfeedp;
 
 	/* public: */
-	int (*set) (struct dmx_section_feed* feed,
-		    u16 pid,
-		    size_t circular_buffer_size,
-		    int check_crc);
-	int (*allocate_filter) (struct dmx_section_feed* feed,
-				struct dmx_section_filter** filter);
-	int (*release_filter) (struct dmx_section_feed* feed,
-			       struct dmx_section_filter* filter);
-	int (*start_filtering) (struct dmx_section_feed* feed);
-	int (*stop_filtering) (struct dmx_section_feed* feed);
+	int (*set)(struct dmx_section_feed *feed,
+		   u16 pid,
+		   size_t circular_buffer_size,
+		   int check_crc);
+	int (*allocate_filter)(struct dmx_section_feed *feed,
+			       struct dmx_section_filter **filter);
+	int (*release_filter)(struct dmx_section_feed *feed,
+			      struct dmx_section_filter *filter);
+	int (*start_filtering)(struct dmx_section_feed *feed);
+	int (*stop_filtering)(struct dmx_section_feed *feed);
 };
 
-/*--------------------------------------------------------------------------*/
-/* Callback functions */
-/*--------------------------------------------------------------------------*/
+/*
+ * Callback functions
+ */
 
-typedef int (*dmx_ts_cb) ( const u8 * buffer1,
-			   size_t buffer1_length,
-			   const u8 * buffer2,
-			   size_t buffer2_length,
-			   struct dmx_ts_feed* source);
+typedef int (*dmx_ts_cb)(const u8 *buffer1,
+			 size_t buffer1_length,
+			 const u8 *buffer2,
+			 size_t buffer2_length,
+			 struct dmx_ts_feed *source);
 
-typedef int (*dmx_section_cb) (	const u8 * buffer1,
-				size_t buffer1_len,
-				const u8 * buffer2,
-				size_t buffer2_len,
-				struct dmx_section_filter * source);
+typedef int (*dmx_section_cb)(const u8 *buffer1,
+			      size_t buffer1_len,
+			      const u8 *buffer2,
+			      size_t buffer2_len,
+			     struct dmx_section_filter *source);
 
 /*--------------------------------------------------------------------------*/
 /* DVB Front-End */
@@ -229,9 +242,9 @@ struct dmx_frontend {
 	enum dmx_frontend_source source;
 };
 
-/*--------------------------------------------------------------------------*/
-/* MPEG-2 TS Demux */
-/*--------------------------------------------------------------------------*/
+/*
+ * MPEG-2 TS Demux
+ */
 
 /*
  * Flags OR'ed in the capabilities field of struct dmx_demux.
@@ -255,7 +268,8 @@ struct dmx_frontend {
  *.
 */
 
-#define DMX_FE_ENTRY(list) list_entry(list, struct dmx_frontend, connectivity_list)
+#define DMX_FE_ENTRY(list) \
+	list_entry(list, struct dmx_frontend, connectivity_list)
 
 /**
  * struct dmx_demux - Structure that contains the demux capabilities and
@@ -269,7 +283,7 @@ struct dmx_frontend {
  *
  * @open: This function reserves the demux for use by the caller and, if
  *	necessary, initializes the demux. When the demux is no longer needed,
- * 	the function @close should be called. It should be possible for
+ *	the function @close should be called. It should be possible for
  *	multiple clients to access the demux at the same time. Thus, the
  *	function implementation should increment the demux usage count when
  *	@open is called and decrement it when @close is called.
@@ -277,7 +291,7 @@ struct dmx_frontend {
  *	instance data.
  *	It returns
  *		0 on success;
- * 		-EUSERS, if maximum usage count was reached;
+ *		-EUSERS, if maximum usage count was reached;
  *		-EINVAL, on bad parameter.
  *
  * @close: This function reserves the demux for use by the caller and, if
@@ -408,7 +422,7 @@ struct dmx_frontend {
  *	call can be used as a parameter for @connect_frontend. The include
  *	file demux.h contains the macro DMX_FE_ENTRY() for converting an
  *	element of the generic type struct &list_head * to the type
- * 	struct &dmx_frontend *. The caller must not free the memory of any of
+ *	struct &dmx_frontend *. The caller must not free the memory of any of
  *	the elements obtained via this function call.
  *	The @demux function parameter contains a pointer to the demux API and
  *	instance data.
@@ -450,44 +464,45 @@ struct dmx_frontend {
 
 struct dmx_demux {
 	u32 capabilities;
-	struct dmx_frontend* frontend;
-	void* priv;
-	int (*open) (struct dmx_demux* demux);
-	int (*close) (struct dmx_demux* demux);
-	int (*write) (struct dmx_demux* demux, const char __user *buf, size_t count);
-	int (*allocate_ts_feed) (struct dmx_demux* demux,
-				 struct dmx_ts_feed** feed,
-				 dmx_ts_cb callback);
-	int (*release_ts_feed) (struct dmx_demux* demux,
-				struct dmx_ts_feed* feed);
-	int (*allocate_section_feed) (struct dmx_demux* demux,
-				      struct dmx_section_feed** feed,
-				      dmx_section_cb callback);
-	int (*release_section_feed) (struct dmx_demux* demux,
-				     struct dmx_section_feed* feed);
-	int (*add_frontend) (struct dmx_demux* demux,
-			     struct dmx_frontend* frontend);
-	int (*remove_frontend) (struct dmx_demux* demux,
-				struct dmx_frontend* frontend);
-	struct list_head* (*get_frontends) (struct dmx_demux* demux);
-	int (*connect_frontend) (struct dmx_demux* demux,
-				 struct dmx_frontend* frontend);
-	int (*disconnect_frontend) (struct dmx_demux* demux);
+	struct dmx_frontend *frontend;
+	void *priv;
+	int (*open)(struct dmx_demux *demux);
+	int (*close)(struct dmx_demux *demux);
+	int (*write)(struct dmx_demux *demux, const char __user *buf,
+		     size_t count);
+	int (*allocate_ts_feed)(struct dmx_demux *demux,
+				struct dmx_ts_feed **feed,
+				dmx_ts_cb callback);
+	int (*release_ts_feed)(struct dmx_demux *demux,
+			       struct dmx_ts_feed *feed);
+	int (*allocate_section_feed)(struct dmx_demux *demux,
+				     struct dmx_section_feed **feed,
+				     dmx_section_cb callback);
+	int (*release_section_feed)(struct dmx_demux *demux,
+				    struct dmx_section_feed *feed);
+	int (*add_frontend)(struct dmx_demux *demux,
+			    struct dmx_frontend *frontend);
+	int (*remove_frontend)(struct dmx_demux *demux,
+			       struct dmx_frontend *frontend);
+	struct list_head *(*get_frontends)(struct dmx_demux *demux);
+	int (*connect_frontend)(struct dmx_demux *demux,
+				struct dmx_frontend *frontend);
+	int (*disconnect_frontend)(struct dmx_demux *demux);
 
-	int (*get_pes_pids) (struct dmx_demux* demux, u16 *pids);
+	int (*get_pes_pids)(struct dmx_demux *demux, u16 *pids);
 
 	/* private: Not used upstream and never documented */
 #if 0
-	int (*get_caps) (struct dmx_demux* demux, struct dmx_caps *caps);
-	int (*set_source) (struct dmx_demux* demux, const dmx_source_t *src);
+	int (*get_caps)(struct dmx_demux *demux, struct dmx_caps *caps);
+	int (*set_source)(struct dmx_demux *demux, const dmx_source_t *src);
 #endif
 	/*
 	 * private: Only used at av7110, to read some data from firmware.
 	 *	As this was never documented, we have no clue about what's
-	 * 	there, and its usage on other drivers aren't encouraged.
+	 *	there, and its usage on other drivers aren't encouraged.
 	 */
-	int (*get_stc) (struct dmx_demux* demux, unsigned int num,
-			u64 *stc, unsigned int *base);
+	int (*get_stc)(struct dmx_demux *demux, unsigned int num,
+		       u64 *stc, unsigned int *base);
 };
 
 #endif /* #ifndef __DEMUX_H */
-- 
2.4.3


