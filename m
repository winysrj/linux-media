Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:39212 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751999AbbJJNgS (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 10 Oct 2015 09:36:18 -0400
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Subject: [PATCH 22/26] [media] DocBook: document typedef dmx_section_cb at demux.h
Date: Sat, 10 Oct 2015 10:36:05 -0300
Message-Id: <4be45fb467e1dd57255056527191d61d8d16e1b3.1444483819.git.mchehab@osg.samsung.com>
In-Reply-To: <cover.1444483819.git.mchehab@osg.samsung.com>
References: <cover.1444483819.git.mchehab@osg.samsung.com>
In-Reply-To: <cover.1444483819.git.mchehab@osg.samsung.com>
References: <cover.1444483819.git.mchehab@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The dvb/kdapi.tmpl has already an extensive documentation about
this callback. Now that we've added function typedefs at kernel-doc,
add such documentation at demux.h, for it to appear at device-drivers
DocBook.

Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>

diff --git a/drivers/media/dvb-core/demux.h b/drivers/media/dvb-core/demux.h
index 39e644113350..576e30fc5c18 100644
--- a/drivers/media/dvb-core/demux.h
+++ b/drivers/media/dvb-core/demux.h
@@ -256,11 +256,46 @@ typedef int (*dmx_ts_cb)(const u8 *buffer1,
 			 size_t buffer2_length,
 			 struct dmx_ts_feed *source);
 
+/**
+ * typedef dmx_section_cb - DVB demux TS filter callback function prototype
+ *
+ * @buffer1:		Pointer to the start of the filtered section, e.g.
+ *			within the circular buffer of the demux driver.
+ * @buffer1_len:	Length of the filtered section data in @buffer1,
+ *			including headers and CRC.
+ * @buffer2:		Pointer to the tail of the filtered section data,
+ *			or NULL. Useful to handle the wrapping of a
+ *			circular buffer.
+ * @buffer2_len:	Length of the filtered section data in @buffer2,
+ *			including headers and CRC.
+ * @source:		Indicates which section feed is the source of the
+ *			callback.
+ *
+ * This function callback prototype, provided by the client of the demux API,
+ * is called from the demux code. The function is only called when
+ * filtering of sections has been enabled using the function
+ * &dmx_ts_feed.@start_filtering. When the demux driver has received a
+ * complete section that matches at least one section filter, the client
+ * is notified via this callback function. Normally this function is called
+ * for each received section; however, it is also possible to deliver
+ * multiple sections with one callback, for example when the system load
+ * is high. If an error occurs while receiving a section, this
+ * function should be called with the corresponding error type set in the
+ * success field, whether or not there is data to deliver. The Section Feed
+ * implementation should maintain a circular buffer for received sections.
+ * However, this is not necessary if the Section Feed API is implemented as
+ * a client of the TS Feed API, because the TS Feed implementation then
+ * buffers the received data. The size of the circular buffer can be
+ * configured using the &dmx_ts_feed.@set function in the Section Feed API.
+ * If there is no room in the circular buffer when a new section is received,
+ * the section must be discarded. If this happens, the value of the success
+ * parameter should be DMX_OVERRUN_ERROR on the next callback.
+ */
 typedef int (*dmx_section_cb)(const u8 *buffer1,
 			      size_t buffer1_len,
 			      const u8 *buffer2,
 			      size_t buffer2_len,
-			     struct dmx_section_filter *source);
+			      struct dmx_section_filter *source);
 
 /*--------------------------------------------------------------------------*/
 /* DVB Front-End */
-- 
2.4.3


