Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:39213 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752013AbbJJNgS (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 10 Oct 2015 09:36:18 -0400
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Subject: [PATCH 21/26] [media] DocBook: document typedef dmx_ts_cb at demux.h
Date: Sat, 10 Oct 2015 10:36:04 -0300
Message-Id: <0cf35e8420dd26fac4ba08c67fab92076ea81809.1444483819.git.mchehab@osg.samsung.com>
In-Reply-To: <cover.1444483819.git.mchehab@osg.samsung.com>
References: <cover.1444483819.git.mchehab@osg.samsung.com>
MIME-Version: 1.0
In-Reply-To: <cover.1444483819.git.mchehab@osg.samsung.com>
References: <cover.1444483819.git.mchehab@osg.samsung.com>
Content-Type: text/plain; charset=true
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The dvb/kdapi.tmpl has already an extensive documentation about
this callback. Now that we've added function typedefs at kernel-doc,
add such documentation at demux.h, for it to appear at device-drivers
DocBook.

Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>

diff --git a/drivers/media/dvb-core/demux.h b/drivers/media/dvb-core/demux.h
index 7405d6e2297d..39e644113350 100644
--- a/drivers/media/dvb-core/demux.h
+++ b/drivers/media/dvb-core/demux.h
@@ -195,6 +195,61 @@ struct dmx_section_feed {
  * Callback functions
  */
 
+/**
+ * typedef dmx_ts_cb - DVB demux TS filter callback function prototype
+ *
+ * @buffer1:		Pointer to the start of the filtered TS packets.
+ * @buffer1_length:	Length of the TS data in buffer1.
+ * @buffer2:		Pointer to the tail of the filtered TS packets, or NULL.
+ * @buffer2_length:	Length of the TS data in buffer2.
+ * @source:		Indicates which TS feed is the source of the callback.
+ *
+ * This function callback prototype, provided by the client of the demux API,
+ * is called from the demux code. The function is only called when filtering
+ * on ae TS feed has been enabled using the start_filtering() function at
+ * the &dmx_demux.
+ * Any TS packets that match the filter settings are copied to a circular
+ * buffer. The filtered TS packets are delivered to the client using this
+ * callback function. The size of the circular buffer is controlled by the
+ * circular_buffer_size parameter of the &dmx_ts_feed.@set function.
+ * It is expected that the @buffer1 and @buffer2 callback parameters point to
+ * addresses within the circular buffer, but other implementations are also
+ * possible. Note that the called party should not try to free the memory
+ * the @buffer1 and @buffer2 parameters point to.
+ *
+ * When this function is called, the @buffer1 parameter typically points to
+ * the start of the first undelivered TS packet within a circular buffer.
+ * The @buffer2 buffer parameter is normally NULL, except when the received
+ * TS packets have crossed the last address of the circular buffer and
+ * ”wrapped” to the beginning of the buffer. In the latter case the @buffer1
+ * parameter would contain an address within the circular buffer, while the
+ * @buffer2 parameter would contain the first address of the circular buffer.
+ * The number of bytes delivered with this function (i.e. @buffer1_length +
+ * @buffer2_length) is usually equal to the value of callback_length parameter
+ * given in the set() function, with one exception: if a timeout occurs before
+ * receiving callback_length bytes of TS data, any undelivered packets are
+ * immediately delivered to the client by calling this function. The timeout
+ * duration is controlled by the set() function in the TS Feed API.
+ *
+ * If a TS packet is received with errors that could not be fixed by the
+ * TS-level forward error correction (FEC), the Transport_error_indicator
+ * flag of the TS packet header should be set. The TS packet should not be
+ * discarded, as the error can possibly be corrected by a higher layer
+ * protocol. If the called party is slow in processing the callback, it
+ * is possible that the circular buffer eventually fills up. If this happens,
+ * the demux driver should discard any TS packets received while the buffer
+ * is full and return -EOVERFLOW.
+ *
+ * The type of data returned to the callback can be selected by the
+ * &dmx_ts_feed.@set function. The type parameter decides if the raw
+ * TS packet (TS_PACKET) or just the payload (TS_PACKET|TS_PAYLOAD_ONLY)
+ * should be returned. If additionally the TS_DECODER bit is set the stream
+ * will also be sent to the hardware MPEG decoder.
+ *
+ * Return:
+ * 	0, on success;
+ * 	-EOVERFLOW, on buffer overflow.
+ */
 typedef int (*dmx_ts_cb)(const u8 *buffer1,
 			 size_t buffer1_length,
 			 const u8 *buffer2,
-- 
2.4.3


