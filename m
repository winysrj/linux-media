Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:39260 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752073AbbJJNgX (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 10 Oct 2015 09:36:23 -0400
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	Joe Perches <joe@perches.com>,
	Dan Carpenter <dan.carpenter@oracle.com>,
	Vaishali Thakkar <vthakkar1994@gmail.com>,
	"Eric W. Biederman" <ebiederm@xmission.com>,
	Stefan Richter <stefanr@s5r6.in-berlin.de>,
	Fabian Frederick <fabf@skynet.be>
Subject: [PATCH 15/26] [media] dvb: get rid of enum dmx_success
Date: Sat, 10 Oct 2015 10:35:58 -0300
Message-Id: <2f684b239cdbfcc1160392645a8fc056a68847ca.1444483819.git.mchehab@osg.samsung.com>
In-Reply-To: <cover.1444483819.git.mchehab@osg.samsung.com>
References: <cover.1444483819.git.mchehab@osg.samsung.com>
In-Reply-To: <cover.1444483819.git.mchehab@osg.samsung.com>
References: <cover.1444483819.git.mchehab@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This enum is not actually used anymore. The only value used from
the enum is DMX_OK, passed as a parameter on two callbacks.

Yet, this value is not used anywhere. So, just remove it.

Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>

diff --git a/Documentation/DocBook/media/dvb/kdapi.xml b/Documentation/DocBook/media/dvb/kdapi.xml
index 6efc3ab7944e..1acae6730151 100644
--- a/Documentation/DocBook/media/dvb/kdapi.xml
+++ b/Documentation/DocBook/media/dvb/kdapi.xml
@@ -11,20 +11,6 @@ DVB device driver writers. The header file for this API is named <constant>demux
 <title>Kernel Demux Data Types</title>
 
 
-<section id="dmx_success_t">
-<title>dmx_success_t</title>
- <programlisting>
- typedef enum {
-   DMX_OK = 0, /&#x22C6; Received Ok &#x22C6;/
-   DMX_LENGTH_ERROR, /&#x22C6; Incorrect length &#x22C6;/
-   DMX_OVERRUN_ERROR, /&#x22C6; Receiver ring buffer overrun &#x22C6;/
-   DMX_CRC_ERROR, /&#x22C6; Incorrect CRC &#x22C6;/
-   DMX_FRAME_ERROR, /&#x22C6; Frame alignment error &#x22C6;/
-   DMX_FIFO_ERROR, /&#x22C6; Receiver FIFO overrun &#x22C6;/
-   DMX_MISSED_ERROR /&#x22C6; Receiver missed packet &#x22C6;/
- } dmx_success_t;
-</programlisting>
-
 </section>
 <section id="ts_filter_types">
 <title>TS filter types</title>
@@ -143,22 +129,19 @@ should be kept identical) to the types in the demux device.
 			    size_t buffer1_length,
 			    __u8 &#x22C6; buffer2,
 			    size_t buffer2_length,
-			    dmx_ts_feed_t&#x22C6; source,
-			    dmx_success_t success);
+			    dmx_ts_feed_t&#x22C6; source)
 
  typedef int (&#x22C6;dmx_section_cb) ( __u8 &#x22C6; buffer1,
 				 size_t buffer1_len,
 				 __u8 &#x22C6; buffer2,
 				 size_t buffer2_len,
-				 dmx_section_filter_t &#x22C6; source,
-				 dmx_success_t success);
+				 dmx_section_filter_t &#x22C6; source);
 
  typedef int (&#x22C6;dmx_pes_cb) ( __u8 &#x22C6; buffer1,
 			     size_t buffer1_len,
 			     __u8 &#x22C6; buffer2,
 			     size_t buffer2_len,
-			     dmx_pes_filter_t&#x22C6; source,
-			     dmx_success_t success);
+			     dmx_pes_filter_t&#x22C6; source);
 
  /&#x22C6;--------------------------------------------------------------------------&#x22C6;/
  /&#x22C6; DVB Front-End &#x22C6;/
@@ -523,7 +506,7 @@ role="subsection"><title>dmx_ts_cb()</title>
  align="char">
 <para>int dmx_ts_cb(__u8&#x22C6; buffer1, size_t buffer1_length,
  __u8&#x22C6; buffer2, size_t buffer2_length, dmx_ts_feed_t&#x22C6;
- source, dmx_success_t success);</para>
+ source);</para>
 </entry>
  </row></tbody></tgroup></informaltable>
 <para>PARAMETERS
@@ -564,14 +547,6 @@ role="subsection"><title>dmx_ts_cb()</title>
  align="char">
 <para>Indicates which TS feed is the source of the callback.</para>
 </entry>
- </row><row><entry
- align="char">
-<para>dmx_success_t
- success</para>
-</entry><entry
- align="char">
-<para>Indicates if there was an error in TS reception.</para>
-</entry>
  </row></tbody></tgroup></informaltable>
 <para>RETURNS
 </para>
@@ -623,8 +598,7 @@ role="subsection"><title>dmx_section_cb()</title>
  align="char">
 <para>int dmx_section_cb(__u8&#x22C6; buffer1, size_t
  buffer1_length, __u8&#x22C6; buffer2, size_t
- buffer2_length, dmx_section_filter_t&#x22C6; source,
- dmx_success_t success);</para>
+ buffer2_length, dmx_section_filter_t&#x22C6; source);</para>
 </entry>
  </row></tbody></tgroup></informaltable>
 <para>PARAMETERS
@@ -669,14 +643,6 @@ role="subsection"><title>dmx_section_cb()</title>
  align="char">
 <para>Indicates the filter that triggered the callback.</para>
 </entry>
- </row><row><entry
- align="char">
-<para>dmx_success_t
- success</para>
-</entry><entry
- align="char">
-<para>Indicates if there was an error in section reception.</para>
-</entry>
  </row></tbody></tgroup></informaltable>
 <para>RETURNS
 </para>
diff --git a/drivers/media/dvb-core/demux.h b/drivers/media/dvb-core/demux.h
index b045a598fb2d..2d036b36f551 100644
--- a/drivers/media/dvb-core/demux.h
+++ b/drivers/media/dvb-core/demux.h
@@ -55,21 +55,6 @@
 #define DMX_MAX_SECFEED_SIZE (DMX_MAX_SECTION_SIZE + 188)
 #endif
 
-
-/*
- * enum dmx_success: Success codes for the Demux Callback API.
- */
-
-enum dmx_success {
-  DMX_OK = 0, /* Received Ok */
-  DMX_LENGTH_ERROR, /* Incorrect length */
-  DMX_OVERRUN_ERROR, /* Receiver ring buffer overrun */
-  DMX_CRC_ERROR, /* Incorrect CRC */
-  DMX_FRAME_ERROR, /* Frame alignment error */
-  DMX_FIFO_ERROR, /* Receiver FIFO overrun */
-  DMX_MISSED_ERROR /* Receiver missed packet */
-} ;
-
 /*--------------------------------------------------------------------------*/
 /* TS packet reception */
 /*--------------------------------------------------------------------------*/
@@ -141,15 +126,13 @@ typedef int (*dmx_ts_cb) ( const u8 * buffer1,
 			   size_t buffer1_length,
 			   const u8 * buffer2,
 			   size_t buffer2_length,
-			   struct dmx_ts_feed* source,
-			   enum dmx_success success);
+			   struct dmx_ts_feed* source);
 
 typedef int (*dmx_section_cb) (	const u8 * buffer1,
 				size_t buffer1_len,
 				const u8 * buffer2,
 				size_t buffer2_len,
-				struct dmx_section_filter * source,
-				enum dmx_success success);
+				struct dmx_section_filter * source);
 
 /*--------------------------------------------------------------------------*/
 /* DVB Front-End */
diff --git a/drivers/media/dvb-core/dmxdev.c b/drivers/media/dvb-core/dmxdev.c
index 86a987ef13e1..ea9abde902e9 100644
--- a/drivers/media/dvb-core/dmxdev.c
+++ b/drivers/media/dvb-core/dmxdev.c
@@ -352,8 +352,7 @@ static void dvb_dmxdev_filter_timer(struct dmxdev_filter *dmxdevfilter)
 
 static int dvb_dmxdev_section_callback(const u8 *buffer1, size_t buffer1_len,
 				       const u8 *buffer2, size_t buffer2_len,
-				       struct dmx_section_filter *filter,
-				       enum dmx_success success)
+				       struct dmx_section_filter *filter)
 {
 	struct dmxdev_filter *dmxdevfilter = filter->priv;
 	int ret;
@@ -386,8 +385,7 @@ static int dvb_dmxdev_section_callback(const u8 *buffer1, size_t buffer1_len,
 
 static int dvb_dmxdev_ts_callback(const u8 *buffer1, size_t buffer1_len,
 				  const u8 *buffer2, size_t buffer2_len,
-				  struct dmx_ts_feed *feed,
-				  enum dmx_success success)
+				  struct dmx_ts_feed *feed)
 {
 	struct dmxdev_filter *dmxdevfilter = feed->priv;
 	struct dvb_ringbuffer *buffer;
diff --git a/drivers/media/dvb-core/dvb_demux.c b/drivers/media/dvb-core/dvb_demux.c
index 6c7ff0cdcd32..0cc5e935166c 100644
--- a/drivers/media/dvb-core/dvb_demux.c
+++ b/drivers/media/dvb-core/dvb_demux.c
@@ -130,7 +130,7 @@ static inline int dvb_dmx_swfilter_payload(struct dvb_demux_feed *feed,
 
 	feed->peslen += count;
 
-	return feed->cb.ts(&buf[p], count, NULL, 0, &feed->feed.ts, DMX_OK);
+	return feed->cb.ts(&buf[p], count, NULL, 0, &feed->feed.ts);
 }
 
 static int dvb_dmx_swfilter_sectionfilter(struct dvb_demux_feed *feed,
@@ -152,7 +152,7 @@ static int dvb_dmx_swfilter_sectionfilter(struct dvb_demux_feed *feed,
 		return 0;
 
 	return feed->cb.sec(feed->feed.sec.secbuf, feed->feed.sec.seclen,
-			    NULL, 0, &f->filter, DMX_OK);
+			    NULL, 0, &f->filter);
 }
 
 static inline int dvb_dmx_swfilter_section_feed(struct dvb_demux_feed *feed)
@@ -367,8 +367,7 @@ static inline void dvb_dmx_swfilter_packet_type(struct dvb_demux_feed *feed,
 			if (feed->ts_type & TS_PAYLOAD_ONLY)
 				dvb_dmx_swfilter_payload(feed, buf);
 			else
-				feed->cb.ts(buf, 188, NULL, 0, &feed->feed.ts,
-					    DMX_OK);
+				feed->cb.ts(buf, 188, NULL, 0, &feed->feed.ts);
 		}
 		if (feed->ts_type & TS_DECODER)
 			if (feed->demux->write_to_decoder)
@@ -469,7 +468,7 @@ static void dvb_dmx_swfilter_packet(struct dvb_demux *demux, const u8 *buf)
 		if (feed->pid == pid)
 			dvb_dmx_swfilter_packet_type(feed, buf);
 		else if (feed->pid == 0x2000)
-			feed->cb.ts(buf, 188, NULL, 0, &feed->feed.ts, DMX_OK);
+			feed->cb.ts(buf, 188, NULL, 0, &feed->feed.ts);
 	}
 }
 
@@ -588,7 +587,7 @@ void dvb_dmx_swfilter_raw(struct dvb_demux *demux, const u8 *buf, size_t count)
 
 	spin_lock_irqsave(&demux->lock, flags);
 
-	demux->feed->cb.ts(buf, count, NULL, 0, &demux->feed->feed.ts, DMX_OK);
+	demux->feed->cb.ts(buf, count, NULL, 0, &demux->feed->feed.ts);
 
 	spin_unlock_irqrestore(&demux->lock, flags);
 }
diff --git a/drivers/media/dvb-core/dvb_net.c b/drivers/media/dvb-core/dvb_net.c
index b81e026edab3..ce4332e80a91 100644
--- a/drivers/media/dvb-core/dvb_net.c
+++ b/drivers/media/dvb-core/dvb_net.c
@@ -761,7 +761,7 @@ static void dvb_net_ule( struct net_device *dev, const u8 *buf, size_t buf_len )
 
 static int dvb_net_ts_callback(const u8 *buffer1, size_t buffer1_len,
 			       const u8 *buffer2, size_t buffer2_len,
-			       struct dmx_ts_feed *feed, enum dmx_success success)
+			       struct dmx_ts_feed *feed)
 {
 	struct net_device *dev = feed->priv;
 
@@ -870,8 +870,7 @@ static void dvb_net_sec(struct net_device *dev,
 
 static int dvb_net_sec_callback(const u8 *buffer1, size_t buffer1_len,
 		 const u8 *buffer2, size_t buffer2_len,
-		 struct dmx_section_filter *filter,
-		 enum dmx_success success)
+		 struct dmx_section_filter *filter)
 {
 	struct net_device *dev = filter->priv;
 
diff --git a/drivers/media/pci/ttpci/av7110.c b/drivers/media/pci/ttpci/av7110.c
index 3f24fce74fc1..f89364951ebd 100644
--- a/drivers/media/pci/ttpci/av7110.c
+++ b/drivers/media/pci/ttpci/av7110.c
@@ -303,7 +303,6 @@ static int arm_thread(void *data)
 static int DvbDmxFilterCallback(u8 *buffer1, size_t buffer1_len,
 				u8 *buffer2, size_t buffer2_len,
 				struct dvb_demux_filter *dvbdmxfilter,
-				enum dmx_success success,
 				struct av7110 *av7110)
 {
 	if (!dvbdmxfilter->feed->demux->dmx.frontend)
@@ -329,16 +328,14 @@ static int DvbDmxFilterCallback(u8 *buffer1, size_t buffer1_len,
 		}
 		return dvbdmxfilter->feed->cb.sec(buffer1, buffer1_len,
 						  buffer2, buffer2_len,
-						  &dvbdmxfilter->filter,
-						  DMX_OK);
+						  &dvbdmxfilter->filter);
 	case DMX_TYPE_TS:
 		if (!(dvbdmxfilter->feed->ts_type & TS_PACKET))
 			return 0;
 		if (dvbdmxfilter->feed->ts_type & TS_PAYLOAD_ONLY)
 			return dvbdmxfilter->feed->cb.ts(buffer1, buffer1_len,
 							 buffer2, buffer2_len,
-							 &dvbdmxfilter->feed->feed.ts,
-							 DMX_OK);
+							 &dvbdmxfilter->feed->feed.ts);
 		else
 			av7110_p2t_write(buffer1, buffer1_len,
 					 dvbdmxfilter->feed->pid,
@@ -422,7 +419,7 @@ static void debiirq(unsigned long cookie)
 			DvbDmxFilterCallback((u8 *)av7110->debi_virt,
 					     av7110->debilen, NULL, 0,
 					     av7110->handle2filter[handle],
-					     DMX_OK, av7110);
+					     av7110);
 		xfer = RX_BUFF;
 		break;
 
diff --git a/drivers/media/pci/ttpci/av7110_av.c b/drivers/media/pci/ttpci/av7110_av.c
index 9544cfc06601..9ed1ec7d3551 100644
--- a/drivers/media/pci/ttpci/av7110_av.c
+++ b/drivers/media/pci/ttpci/av7110_av.c
@@ -102,7 +102,7 @@ int av7110_record_cb(struct dvb_filter_pes2ts *p2t, u8 *buf, size_t len)
 		buf[4] = buf[5] = 0;
 	if (dvbdmxfeed->ts_type & TS_PAYLOAD_ONLY)
 		return dvbdmxfeed->cb.ts(buf, len, NULL, 0,
-					 &dvbdmxfeed->feed.ts, DMX_OK);
+					 &dvbdmxfeed->feed.ts);
 	else
 		return dvb_filter_pes2ts(p2t, buf, len, 1);
 }
@@ -112,7 +112,7 @@ static int dvb_filter_pes2ts_cb(void *priv, unsigned char *data)
 	struct dvb_demux_feed *dvbdmxfeed = (struct dvb_demux_feed *) priv;
 
 	dvbdmxfeed->cb.ts(data, 188, NULL, 0,
-			  &dvbdmxfeed->feed.ts, DMX_OK);
+			  &dvbdmxfeed->feed.ts);
 	return 0;
 }
 
@@ -815,7 +815,7 @@ static void p_to_t(u8 const *buf, long int length, u16 pid, u8 *counter,
 			memcpy(obuf + l, buf + c, TS_SIZE - l);
 			c = length;
 		}
-		feed->cb.ts(obuf, 188, NULL, 0, &feed->feed.ts, DMX_OK);
+		feed->cb.ts(obuf, 188, NULL, 0, &feed->feed.ts);
 		pes_start = 0;
 	}
 }
diff --git a/drivers/media/usb/ttusb-dec/ttusb_dec.c b/drivers/media/usb/ttusb-dec/ttusb_dec.c
index 7c3a7c55d969..a5de46f04247 100644
--- a/drivers/media/usb/ttusb-dec/ttusb_dec.c
+++ b/drivers/media/usb/ttusb-dec/ttusb_dec.c
@@ -375,8 +375,7 @@ static int ttusb_dec_audio_pes2ts_cb(void *priv, unsigned char *data)
 	struct ttusb_dec *dec = priv;
 
 	dec->audio_filter->feed->cb.ts(data, 188, NULL, 0,
-				       &dec->audio_filter->feed->feed.ts,
-				       DMX_OK);
+				       &dec->audio_filter->feed->feed.ts);
 
 	return 0;
 }
@@ -386,8 +385,7 @@ static int ttusb_dec_video_pes2ts_cb(void *priv, unsigned char *data)
 	struct ttusb_dec *dec = priv;
 
 	dec->video_filter->feed->cb.ts(data, 188, NULL, 0,
-				       &dec->video_filter->feed->feed.ts,
-				       DMX_OK);
+				       &dec->video_filter->feed->feed.ts);
 
 	return 0;
 }
@@ -439,7 +437,7 @@ static void ttusb_dec_process_pva(struct ttusb_dec *dec, u8 *pva, int length)
 
 		if (output_pva) {
 			dec->video_filter->feed->cb.ts(pva, length, NULL, 0,
-				&dec->video_filter->feed->feed.ts, DMX_OK);
+				&dec->video_filter->feed->feed.ts);
 			return;
 		}
 
@@ -500,7 +498,7 @@ static void ttusb_dec_process_pva(struct ttusb_dec *dec, u8 *pva, int length)
 	case 0x02:		/* MainAudioStream */
 		if (output_pva) {
 			dec->audio_filter->feed->cb.ts(pva, length, NULL, 0,
-				&dec->audio_filter->feed->feed.ts, DMX_OK);
+				&dec->audio_filter->feed->feed.ts);
 			return;
 		}
 
@@ -538,7 +536,7 @@ static void ttusb_dec_process_filter(struct ttusb_dec *dec, u8 *packet,
 
 	if (filter)
 		filter->feed->cb.sec(&packet[2], length - 2, NULL, 0,
-				     &filter->filter, DMX_OK);
+				     &filter->filter);
 }
 
 static void ttusb_dec_process_packet(struct ttusb_dec *dec)
-- 
2.4.3


