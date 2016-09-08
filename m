Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:44178 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S941753AbcIHME0 (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Thu, 8 Sep 2016 08:04:26 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Markus Heiser <markus.heiser@darmarit.de>,
        Jonathan Corbet <corbet@lwn.net>, linux-doc@vger.kernel.org,
        Jani Nikula <jani.nikula@linux.intel.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
Subject: [PATCH 08/47] [media] demux.h: Fix a few documentation issues
Date: Thu,  8 Sep 2016 09:03:30 -0300
Message-Id: <8295a9d926bb3fe701426e1478538240bd49f725.1473334905.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1473334905.git.mchehab@s-opensource.com>
References: <cover.1473334905.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1473334905.git.mchehab@s-opensource.com>
References: <cover.1473334905.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

demux.h was lacking documentation for the DMX_FE_ENTRY macro:
	./drivers/media/dvb-core/demux.h:511: WARNING: c:func reference target not found: DMX_FE_ENTRY

While here, get rid of unused parameters and fix a few minor issues
at the header file.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 drivers/media/dvb-core/demux.h | 36 ++++++++++++++++--------------------
 1 file changed, 16 insertions(+), 20 deletions(-)

diff --git a/drivers/media/dvb-core/demux.h b/drivers/media/dvb-core/demux.h
index 4b4c1da20f4b..0d9c53518be2 100644
--- a/drivers/media/dvb-core/demux.h
+++ b/drivers/media/dvb-core/demux.h
@@ -202,7 +202,7 @@ struct dmx_section_feed {
  *
  * This function callback prototype, provided by the client of the demux API,
  * is called from the demux code. The function is only called when filtering
- * on ae TS feed has been enabled using the start_filtering() function at
+ * on a TS feed has been enabled using the start_filtering\(\) function at
  * the &dmx_demux.
  * Any TS packets that match the filter settings are copied to a circular
  * buffer. The filtered TS packets are delivered to the client using this
@@ -243,8 +243,10 @@ struct dmx_section_feed {
  * will also be sent to the hardware MPEG decoder.
  *
  * Return:
- * 	0, on success;
- * 	-EOVERFLOW, on buffer overflow.
+ *
+ * - 0, on success;
+ *
+ * - -EOVERFLOW, on buffer overflow.
  */
 typedef int (*dmx_ts_cb)(const u8 *buffer1,
 			 size_t buffer1_length,
@@ -293,9 +295,9 @@ typedef int (*dmx_section_cb)(const u8 *buffer1,
 			      size_t buffer2_len,
 			      struct dmx_section_filter *source);
 
-/*--------------------------------------------------------------------------*/
-/* DVB Front-End */
-/*--------------------------------------------------------------------------*/
+/*
+ * DVB Front-End
+ */
 
 /**
  * enum dmx_frontend_source - Used to identify the type of frontend
@@ -349,15 +351,15 @@ enum dmx_demux_caps {
 
 /*
  * Demux resource type identifier.
-*/
-
-/*
- * DMX_FE_ENTRY(): Casts elements in the list of registered
- * front-ends from the generic type struct list_head
- * to the type * struct dmx_frontend
- *.
-*/
+ */
 
+/**
+ * DMX_FE_ENTRY - Casts elements in the list of registered
+ *		  front-ends from the generic type struct list_head
+ *		  to the type * struct dmx_frontend
+ *
+ * @list: list of struct dmx_frontend
+ */
 #define DMX_FE_ENTRY(list) \
 	list_entry(list, struct dmx_frontend, connectivity_list)
 
@@ -551,7 +553,6 @@ enum dmx_demux_caps {
  *	0 on success;
  *	-EINVAL on bad parameter.
  */
-
 struct dmx_demux {
 	enum dmx_demux_caps capabilities;
 	struct dmx_frontend *frontend;
@@ -581,11 +582,6 @@ struct dmx_demux {
 
 	int (*get_pes_pids)(struct dmx_demux *demux, u16 *pids);
 
-	/* private: Not used upstream and never documented */
-#if 0
-	int (*get_caps)(struct dmx_demux *demux, struct dmx_caps *caps);
-	int (*set_source)(struct dmx_demux *demux, const dmx_source_t *src);
-#endif
 	/*
 	 * private: Only used at av7110, to read some data from firmware.
 	 *	As this was never documented, we have no clue about what's
-- 
2.7.4


