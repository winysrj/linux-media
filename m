Return-path: <linux-media-owner@vger.kernel.org>
Received: from osg.samsung.com ([64.30.133.232]:38196 "EHLO osg.samsung.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753087AbeBKL07 (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Sun, 11 Feb 2018 06:26:59 -0500
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Inki Dae <inki.dae@samsung.com>, Arnd Bergmann <arnd@arndb.de>,
        Kees Cook <keescook@chromium.org>,
        Satendra Singh Thakur <satendra.t@samsung.com>,
        Ingo Molnar <mingo@kernel.org>,
        Johannes Berg <johannes.berg@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Stephen Hemminger <stephen@networkplumber.org>,
        Junghak Sung <jh1009.sung@samsung.com>,
        Geunyoung Kim <nenggun.kim@samsung.com>,
        Seung-Woo Kim <sw0312.kim@samsung.com>
Subject: [PATCH v2 4/4] media: dvb: update buffer mmaped flags and frame counter
Date: Sun, 11 Feb 2018 09:26:50 -0200
Message-Id: <36c766b58a881579e6d0b02de7a8a37295ef5aff.1518347588.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1518347588.git.mchehab@s-opensource.com>
References: <cover.1518347588.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1518347588.git.mchehab@s-opensource.com>
References: <cover.1518347588.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Now that we have support for a buffer counter and for
error flags, update them at DMX_DQBUF.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 drivers/media/dvb-core/dmxdev.c    |  24 +++++---
 drivers/media/dvb-core/dvb_demux.c | 113 ++++++++++++++++++++++++-------------
 drivers/media/dvb-core/dvb_net.c   |   5 +-
 drivers/media/dvb-core/dvb_vb2.c   |  31 +++++++---
 include/media/demux.h              |  21 +++++--
 include/media/dvb_demux.h          |   4 ++
 include/media/dvb_vb2.h            |  18 +++++-
 7 files changed, 150 insertions(+), 66 deletions(-)

diff --git a/drivers/media/dvb-core/dmxdev.c b/drivers/media/dvb-core/dmxdev.c
index ad349fe26aa2..34f54d443d08 100644
--- a/drivers/media/dvb-core/dmxdev.c
+++ b/drivers/media/dvb-core/dmxdev.c
@@ -385,7 +385,8 @@ static void dvb_dmxdev_filter_timer(struct dmxdev_filter *dmxdevfilter)
 
 static int dvb_dmxdev_section_callback(const u8 *buffer1, size_t buffer1_len,
 				       const u8 *buffer2, size_t buffer2_len,
-				       struct dmx_section_filter *filter)
+				       struct dmx_section_filter *filter,
+				       u32 *buffer_flags)
 {
 	struct dmxdev_filter *dmxdevfilter = filter->priv;
 	int ret;
@@ -404,10 +405,12 @@ static int dvb_dmxdev_section_callback(const u8 *buffer1, size_t buffer1_len,
 	dprintk("section callback %*ph\n", 6, buffer1);
 	if (dvb_vb2_is_streaming(&dmxdevfilter->vb2_ctx)) {
 		ret = dvb_vb2_fill_buffer(&dmxdevfilter->vb2_ctx,
-					  buffer1, buffer1_len);
+					  buffer1, buffer1_len,
+					  buffer_flags);
 		if (ret == buffer1_len)
 			ret = dvb_vb2_fill_buffer(&dmxdevfilter->vb2_ctx,
-						  buffer2, buffer2_len);
+						  buffer2, buffer2_len,
+						  buffer_flags);
 	} else {
 		ret = dvb_dmxdev_buffer_write(&dmxdevfilter->buffer,
 					      buffer1, buffer1_len);
@@ -427,7 +430,8 @@ static int dvb_dmxdev_section_callback(const u8 *buffer1, size_t buffer1_len,
 
 static int dvb_dmxdev_ts_callback(const u8 *buffer1, size_t buffer1_len,
 				  const u8 *buffer2, size_t buffer2_len,
-				  struct dmx_ts_feed *feed)
+				  struct dmx_ts_feed *feed,
+				  u32 *buffer_flags)
 {
 	struct dmxdev_filter *dmxdevfilter = feed->priv;
 	struct dvb_ringbuffer *buffer;
@@ -456,9 +460,11 @@ static int dvb_dmxdev_ts_callback(const u8 *buffer1, size_t buffer1_len,
 	}
 
 	if (dvb_vb2_is_streaming(ctx)) {
-		ret = dvb_vb2_fill_buffer(ctx, buffer1, buffer1_len);
+		ret = dvb_vb2_fill_buffer(ctx, buffer1, buffer1_len,
+					  buffer_flags);
 		if (ret == buffer1_len)
-			ret = dvb_vb2_fill_buffer(ctx, buffer2, buffer2_len);
+			ret = dvb_vb2_fill_buffer(ctx, buffer2, buffer2_len,
+						  buffer_flags);
 	} else {
 		if (buffer->error) {
 			spin_unlock(&dmxdevfilter->dev->lock);
@@ -1218,7 +1224,7 @@ static int dvb_demux_mmap(struct file *file, struct vm_area_struct *vma)
 	int ret;
 
 	if (!dmxdev->may_do_mmap)
-		return -EOPNOTSUPP;
+		return -ENOTTY;
 
 	if (mutex_lock_interruptible(&dmxdev->mutex))
 		return -ERESTARTSYS;
@@ -1318,7 +1324,7 @@ static int dvb_dvr_do_ioctl(struct file *file,
 		break;
 #endif
 	default:
-		ret = -EINVAL;
+		ret = -ENOTTY;
 		break;
 	}
 	mutex_unlock(&dmxdev->mutex);
@@ -1367,7 +1373,7 @@ static int dvb_dvr_mmap(struct file *file, struct vm_area_struct *vma)
 	int ret;
 
 	if (!dmxdev->may_do_mmap)
-		return -EOPNOTSUPP;
+		return -ENOTTY;
 
 	if (dmxdev->exit)
 		return -ENODEV;
diff --git a/drivers/media/dvb-core/dvb_demux.c b/drivers/media/dvb-core/dvb_demux.c
index 210eed0269b0..86afdec13922 100644
--- a/drivers/media/dvb-core/dvb_demux.c
+++ b/drivers/media/dvb-core/dvb_demux.c
@@ -55,6 +55,17 @@ MODULE_PARM_DESC(dvb_demux_feed_err_pkts,
 		dprintk(x);				\
 } while (0)
 
+#ifdef CONFIG_DVB_DEMUX_SECTION_LOSS_LOG
+#  define dprintk_sect_loss(x...) dprintk(x)
+#else
+#  define dprintk_sect_loss(x...)
+#endif
+
+#define set_buf_flags(__feed, __flag)			\
+	do {						\
+		(__feed)->buffer_flags |= (__flag);	\
+	} while (0)
+
 /******************************************************************************
  * static inlined helper functions
  ******************************************************************************/
@@ -104,31 +115,30 @@ static inline int dvb_dmx_swfilter_payload(struct dvb_demux_feed *feed,
 {
 	int count = payload(buf);
 	int p;
-#ifdef CONFIG_DVB_DEMUX_SECTION_LOSS_LOG
 	int ccok;
 	u8 cc;
-#endif
 
 	if (count == 0)
 		return -1;
 
 	p = 188 - count;
 
-#ifdef CONFIG_DVB_DEMUX_SECTION_LOSS_LOG
 	cc = buf[3] & 0x0f;
 	ccok = ((feed->cc + 1) & 0x0f) == cc;
 	feed->cc = cc;
-	if (!ccok)
-		dprintk("missed packet: %d instead of %d!\n",
-			cc, (feed->cc + 1) & 0x0f);
-#endif
+	if (!ccok) {
+		set_buf_flags(feed, DMX_BUFFER_FLAG_DISCONTINUITY_DETECTED);
+		dprintk_sect_loss("missed packet: %d instead of %d!\n",
+				  cc, (feed->cc + 1) & 0x0f);
+	}
 
 	if (buf[1] & 0x40)	// PUSI ?
 		feed->peslen = 0xfffa;
 
 	feed->peslen += count;
 
-	return feed->cb.ts(&buf[p], count, NULL, 0, &feed->feed.ts);
+	return feed->cb.ts(&buf[p], count, NULL, 0, &feed->feed.ts,
+			   &feed->buffer_flags);
 }
 
 static int dvb_dmx_swfilter_sectionfilter(struct dvb_demux_feed *feed,
@@ -150,7 +160,7 @@ static int dvb_dmx_swfilter_sectionfilter(struct dvb_demux_feed *feed,
 		return 0;
 
 	return feed->cb.sec(feed->feed.sec.secbuf, feed->feed.sec.seclen,
-			    NULL, 0, &f->filter);
+			    NULL, 0, &f->filter, &feed->buffer_flags);
 }
 
 static inline int dvb_dmx_swfilter_section_feed(struct dvb_demux_feed *feed)
@@ -169,8 +179,10 @@ static inline int dvb_dmx_swfilter_section_feed(struct dvb_demux_feed *feed)
 	if (sec->check_crc) {
 		section_syntax_indicator = ((sec->secbuf[1] & 0x80) != 0);
 		if (section_syntax_indicator &&
-		    demux->check_crc32(feed, sec->secbuf, sec->seclen))
+		    demux->check_crc32(feed, sec->secbuf, sec->seclen)) {
+			set_buf_flags(feed, DMX_BUFFER_FLAG_HAD_CRC32_DISCARD);
 			return -1;
+		}
 	}
 
 	do {
@@ -187,7 +199,6 @@ static void dvb_dmx_swfilter_section_new(struct dvb_demux_feed *feed)
 {
 	struct dmx_section_feed *sec = &feed->feed.sec;
 
-#ifdef CONFIG_DVB_DEMUX_SECTION_LOSS_LOG
 	if (sec->secbufp < sec->tsfeedp) {
 		int n = sec->tsfeedp - sec->secbufp;
 
@@ -197,12 +208,13 @@ static void dvb_dmx_swfilter_section_new(struct dvb_demux_feed *feed)
 		 * but just first and last.
 		 */
 		if (sec->secbuf[0] != 0xff || sec->secbuf[n - 1] != 0xff) {
-			dprintk("section ts padding loss: %d/%d\n",
-			       n, sec->tsfeedp);
-			dprintk("pad data: %*ph\n", n, sec->secbuf);
+			set_buf_flags(feed,
+				      DMX_BUFFER_FLAG_DISCONTINUITY_DETECTED);
+			dprintk_sect_loss("section ts padding loss: %d/%d\n",
+					  n, sec->tsfeedp);
+			dprintk_sect_loss("pad data: %*ph\n", n, sec->secbuf);
 		}
 	}
-#endif
 
 	sec->tsfeedp = sec->secbufp = sec->seclen = 0;
 	sec->secbuf = sec->secbuf_base;
@@ -237,11 +249,10 @@ static int dvb_dmx_swfilter_section_copy_dump(struct dvb_demux_feed *feed,
 		return 0;
 
 	if (sec->tsfeedp + len > DMX_MAX_SECFEED_SIZE) {
-#ifdef CONFIG_DVB_DEMUX_SECTION_LOSS_LOG
-		dprintk("section buffer full loss: %d/%d\n",
-			sec->tsfeedp + len - DMX_MAX_SECFEED_SIZE,
-			DMX_MAX_SECFEED_SIZE);
-#endif
+		set_buf_flags(feed, DMX_BUFFER_FLAG_DISCONTINUITY_DETECTED);
+		dprintk_sect_loss("section buffer full loss: %d/%d\n",
+				  sec->tsfeedp + len - DMX_MAX_SECFEED_SIZE,
+				  DMX_MAX_SECFEED_SIZE);
 		len = DMX_MAX_SECFEED_SIZE - sec->tsfeedp;
 	}
 
@@ -269,12 +280,13 @@ static int dvb_dmx_swfilter_section_copy_dump(struct dvb_demux_feed *feed,
 		sec->seclen = seclen;
 		sec->crc_val = ~0;
 		/* dump [secbuf .. secbuf+seclen) */
-		if (feed->pusi_seen)
+		if (feed->pusi_seen) {
 			dvb_dmx_swfilter_section_feed(feed);
-#ifdef CONFIG_DVB_DEMUX_SECTION_LOSS_LOG
-		else
-			dprintk("pusi not seen, discarding section data\n");
-#endif
+		} else {
+			set_buf_flags(feed,
+				      DMX_BUFFER_FLAG_DISCONTINUITY_DETECTED);
+			dprintk_sect_loss("pusi not seen, discarding section data\n");
+		}
 		sec->secbufp += seclen;	/* secbufp and secbuf moving together is */
 		sec->secbuf += seclen;	/* redundant but saves pointer arithmetic */
 	}
@@ -307,18 +319,22 @@ static int dvb_dmx_swfilter_section_packet(struct dvb_demux_feed *feed,
 	}
 
 	if (!ccok || dc_i) {
-#ifdef CONFIG_DVB_DEMUX_SECTION_LOSS_LOG
-		if (dc_i)
-			dprintk("%d frame with disconnect indicator\n",
+		if (dc_i) {
+			set_buf_flags(feed,
+				      DMX_BUFFER_FLAG_DISCONTINUITY_INDICATOR);
+			dprintk_sect_loss("%d frame with disconnect indicator\n",
 				cc);
-		else
-			dprintk("discontinuity: %d instead of %d. %d bytes lost\n",
+		} else {
+			set_buf_flags(feed,
+				      DMX_BUFFER_FLAG_DISCONTINUITY_DETECTED);
+			dprintk_sect_loss("discontinuity: %d instead of %d. %d bytes lost\n",
 				cc, (feed->cc + 1) & 0x0f, count + 4);
+		}
 		/*
-		 * those bytes under sume circumstances will again be reported
+		 * those bytes under some circumstances will again be reported
 		 * in the following dvb_dmx_swfilter_section_new
 		 */
-#endif
+
 		/*
 		 * Discontinuity detected. Reset pusi_seen to
 		 * stop feeding of suspicious data until next PUSI=1 arrives
@@ -326,6 +342,7 @@ static int dvb_dmx_swfilter_section_packet(struct dvb_demux_feed *feed,
 		 * FIXME: does it make sense if the MPEG-TS is the one
 		 *	reporting discontinuity?
 		 */
+
 		feed->pusi_seen = false;
 		dvb_dmx_swfilter_section_new(feed);
 	}
@@ -346,10 +363,11 @@ static int dvb_dmx_swfilter_section_packet(struct dvb_demux_feed *feed,
 			dvb_dmx_swfilter_section_copy_dump(feed, after,
 							   after_len);
 		}
-#ifdef CONFIG_DVB_DEMUX_SECTION_LOSS_LOG
-		else if (count > 0)
-			dprintk("PUSI=1 but %d bytes lost\n", count);
-#endif
+		else if (count > 0) {
+			set_buf_flags(feed,
+				      DMX_BUFFER_FLAG_DISCONTINUITY_DETECTED);
+			dprintk_sect_loss("PUSI=1 but %d bytes lost\n", count);
+		}
 	} else {
 		/* PUSI=0 (is not set), no section boundary */
 		dvb_dmx_swfilter_section_copy_dump(feed, &buf[p], count);
@@ -369,7 +387,8 @@ static inline void dvb_dmx_swfilter_packet_type(struct dvb_demux_feed *feed,
 			if (feed->ts_type & TS_PAYLOAD_ONLY)
 				dvb_dmx_swfilter_payload(feed, buf);
 			else
-				feed->cb.ts(buf, 188, NULL, 0, &feed->feed.ts);
+				feed->cb.ts(buf, 188, NULL, 0, &feed->feed.ts,
+					    &feed->buffer_flags);
 		}
 		/* Used only on full-featured devices */
 		if (feed->ts_type & TS_DECODER)
@@ -430,6 +449,11 @@ static void dvb_dmx_swfilter_packet(struct dvb_demux *demux, const u8 *buf)
 	}
 
 	if (buf[1] & 0x80) {
+		list_for_each_entry(feed, &demux->feed_list, list_head) {
+			if ((feed->pid != pid) && (feed->pid != 0x2000))
+				continue;
+			set_buf_flags(feed, DMX_BUFFER_FLAG_TEI);
+		}
 		dprintk_tscheck("TEI detected. PID=0x%x data1=0x%x\n",
 				pid, buf[1]);
 		/* data in this packet can't be trusted - drop it unless
@@ -445,6 +469,13 @@ static void dvb_dmx_swfilter_packet(struct dvb_demux *demux, const u8 *buf)
 						(demux->cnt_storage[pid] + 1) & 0xf;
 
 				if ((buf[3] & 0xf) != demux->cnt_storage[pid]) {
+					list_for_each_entry(feed, &demux->feed_list, list_head) {
+						if ((feed->pid != pid) && (feed->pid != 0x2000))
+							continue;
+						set_buf_flags(feed,
+							      DMX_BUFFER_PKT_COUNTER_MISMATCH);
+					}
+
 					dprintk_tscheck("TS packet counter mismatch. PID=0x%x expected 0x%x got 0x%x\n",
 							pid, demux->cnt_storage[pid],
 							buf[3] & 0xf);
@@ -466,7 +497,8 @@ static void dvb_dmx_swfilter_packet(struct dvb_demux *demux, const u8 *buf)
 		if (feed->pid == pid)
 			dvb_dmx_swfilter_packet_type(feed, buf);
 		else if (feed->pid == 0x2000)
-			feed->cb.ts(buf, 188, NULL, 0, &feed->feed.ts);
+			feed->cb.ts(buf, 188, NULL, 0, &feed->feed.ts,
+				    &feed->buffer_flags);
 	}
 }
 
@@ -585,7 +617,8 @@ void dvb_dmx_swfilter_raw(struct dvb_demux *demux, const u8 *buf, size_t count)
 
 	spin_lock_irqsave(&demux->lock, flags);
 
-	demux->feed->cb.ts(buf, count, NULL, 0, &demux->feed->feed.ts);
+	demux->feed->cb.ts(buf, count, NULL, 0, &demux->feed->feed.ts,
+			   &demux->feed->buffer_flags);
 
 	spin_unlock_irqrestore(&demux->lock, flags);
 }
@@ -785,6 +818,7 @@ static int dvbdmx_allocate_ts_feed(struct dmx_demux *dmx,
 	feed->demux = demux;
 	feed->pid = 0xffff;
 	feed->peslen = 0xfffa;
+	feed->buffer_flags = 0;
 
 	(*ts_feed) = &feed->feed.ts;
 	(*ts_feed)->parent = dmx;
@@ -1042,6 +1076,7 @@ static int dvbdmx_allocate_section_feed(struct dmx_demux *demux,
 	dvbdmxfeed->cb.sec = callback;
 	dvbdmxfeed->demux = dvbdmx;
 	dvbdmxfeed->pid = 0xffff;
+	dvbdmxfeed->buffer_flags = 0;
 	dvbdmxfeed->feed.sec.secbuf = dvbdmxfeed->feed.sec.secbuf_base;
 	dvbdmxfeed->feed.sec.secbufp = dvbdmxfeed->feed.sec.seclen = 0;
 	dvbdmxfeed->feed.sec.tsfeedp = 0;
diff --git a/drivers/media/dvb-core/dvb_net.c b/drivers/media/dvb-core/dvb_net.c
index b6c7eec863b9..ba39f9942e1d 100644
--- a/drivers/media/dvb-core/dvb_net.c
+++ b/drivers/media/dvb-core/dvb_net.c
@@ -883,7 +883,8 @@ static void dvb_net_ule(struct net_device *dev, const u8 *buf, size_t buf_len)
 
 static int dvb_net_ts_callback(const u8 *buffer1, size_t buffer1_len,
 			       const u8 *buffer2, size_t buffer2_len,
-			       struct dmx_ts_feed *feed)
+			       struct dmx_ts_feed *feed,
+			       u32 *buffer_flags)
 {
 	struct net_device *dev = feed->priv;
 
@@ -992,7 +993,7 @@ static void dvb_net_sec(struct net_device *dev,
 
 static int dvb_net_sec_callback(const u8 *buffer1, size_t buffer1_len,
 		 const u8 *buffer2, size_t buffer2_len,
-		 struct dmx_section_filter *filter)
+		 struct dmx_section_filter *filter, u32 *buffer_flags)
 {
 	struct net_device *dev = filter->priv;
 
diff --git a/drivers/media/dvb-core/dvb_vb2.c b/drivers/media/dvb-core/dvb_vb2.c
index 889abf9becd8..09993e9243f7 100644
--- a/drivers/media/dvb-core/dvb_vb2.c
+++ b/drivers/media/dvb-core/dvb_vb2.c
@@ -256,7 +256,8 @@ int dvb_vb2_is_streaming(struct dvb_vb2_ctx *ctx)
 }
 
 int dvb_vb2_fill_buffer(struct dvb_vb2_ctx *ctx,
-			const unsigned char *src, int len)
+			const unsigned char *src, int len,
+			enum dmx_buffer_flags *buffer_flags)
 {
 	unsigned long flags = 0;
 	void *vbuf = NULL;
@@ -264,15 +265,17 @@ int dvb_vb2_fill_buffer(struct dvb_vb2_ctx *ctx,
 	unsigned char *psrc = (unsigned char *)src;
 	int ll = 0;
 
-	dprintk(3, "[%s] %d bytes are rcvd\n", ctx->name, len);
-	if (!src) {
-		dprintk(3, "[%s]:NULL pointer src\n", ctx->name);
-		/**normal case: This func is called twice from demux driver
-		 * once with valid src pointer, second time with NULL pointer
-		 */
+	/*
+	 * normal case: This func is called twice from demux driver
+	 * one with valid src pointer, second time with NULL pointer
+	 */
+	if (!src || !len)
 		return 0;
-	}
 	spin_lock_irqsave(&ctx->slock, flags);
+	if (buffer_flags && *buffer_flags) {
+		ctx->flags |= *buffer_flags;
+		*buffer_flags = 0;
+	}
 	while (todo) {
 		if (!ctx->buf) {
 			if (list_empty(&ctx->dvb_q)) {
@@ -395,6 +398,7 @@ int dvb_vb2_qbuf(struct dvb_vb2_ctx *ctx, struct dmx_buffer *b)
 
 int dvb_vb2_dqbuf(struct dvb_vb2_ctx *ctx, struct dmx_buffer *b)
 {
+	unsigned long flags;
 	int ret;
 
 	ret = vb2_core_dqbuf(&ctx->vb_q, &b->index, b, ctx->nonblocking);
@@ -402,7 +406,16 @@ int dvb_vb2_dqbuf(struct dvb_vb2_ctx *ctx, struct dmx_buffer *b)
 		dprintk(1, "[%s] errno=%d\n", ctx->name, ret);
 		return ret;
 	}
-	dprintk(5, "[%s] index=%d\n", ctx->name, b->index);
+
+	spin_lock_irqsave(&ctx->slock, flags);
+	b->count = ctx->count++;
+	b->flags = ctx->flags;
+	ctx->flags = 0;
+	spin_unlock_irqrestore(&ctx->slock, flags);
+
+	dprintk(5, "[%s] index=%d, count=%d, flags=%d\n",
+		ctx->name, b->index, ctx->count, b->flags);
+
 
 	return 0;
 }
diff --git a/include/media/demux.h b/include/media/demux.h
index c4df6cee48e6..d58c43f64d55 100644
--- a/include/media/demux.h
+++ b/include/media/demux.h
@@ -117,7 +117,7 @@ struct dmx_ts_feed {
  *		  specified by @filter_value that will be used on the filter
  *		  match logic.
  * @filter_mode:  Contains a 16 bytes (128 bits) filter mode.
- * @parent:	  Pointer to struct dmx_section_feed.
+ * @parent:	  Back-pointer to struct dmx_section_feed.
  * @priv:	  Pointer to private data of the API client.
  *
  *
@@ -130,8 +130,9 @@ struct dmx_section_filter {
 	u8 filter_value[DMX_MAX_FILTER_SIZE];
 	u8 filter_mask[DMX_MAX_FILTER_SIZE];
 	u8 filter_mode[DMX_MAX_FILTER_SIZE];
-	struct dmx_section_feed *parent; /* Back-pointer */
-	void *priv; /* Pointer to private data of the API client */
+	struct dmx_section_feed *parent;
+
+	void *priv;
 };
 
 /**
@@ -193,6 +194,10 @@ struct dmx_section_feed {
  * @buffer2:		Pointer to the tail of the filtered TS packets, or NULL.
  * @buffer2_length:	Length of the TS data in buffer2.
  * @source:		Indicates which TS feed is the source of the callback.
+ * @buffer_flags:	Address where buffer flags are stored. Those are
+ * 			used to report discontinuity users via DVB
+ *			memory mapped API, as defined by
+ *			&enum dmx_buffer_flags.
  *
  * This function callback prototype, provided by the client of the demux API,
  * is called from the demux code. The function is only called when filtering
@@ -245,7 +250,8 @@ typedef int (*dmx_ts_cb)(const u8 *buffer1,
 			 size_t buffer1_length,
 			 const u8 *buffer2,
 			 size_t buffer2_length,
-			 struct dmx_ts_feed *source);
+			 struct dmx_ts_feed *source,
+			 u32 *buffer_flags);
 
 /**
  * typedef dmx_section_cb - DVB demux TS filter callback function prototype
@@ -261,6 +267,10 @@ typedef int (*dmx_ts_cb)(const u8 *buffer1,
  *			including headers and CRC.
  * @source:		Indicates which section feed is the source of the
  *			callback.
+ * @buffer_flags:	Address where buffer flags are stored. Those are
+ * 			used to report discontinuity users via DVB
+ *			memory mapped API, as defined by
+ *			&enum dmx_buffer_flags.
  *
  * This function callback prototype, provided by the client of the demux API,
  * is called from the demux code. The function is only called when
@@ -286,7 +296,8 @@ typedef int (*dmx_section_cb)(const u8 *buffer1,
 			      size_t buffer1_len,
 			      const u8 *buffer2,
 			      size_t buffer2_len,
-			      struct dmx_section_filter *source);
+			      struct dmx_section_filter *source,
+			      u32 *buffer_flags);
 
 /*
  * DVB Front-End
diff --git a/include/media/dvb_demux.h b/include/media/dvb_demux.h
index b07092038f4b..3b6aeca7a49e 100644
--- a/include/media/dvb_demux.h
+++ b/include/media/dvb_demux.h
@@ -115,6 +115,8 @@ struct dvb_demux_filter {
  * @pid:	PID to be filtered.
  * @timeout:	feed timeout.
  * @filter:	pointer to &struct dvb_demux_filter.
+ * @buffer_flags: Buffer flags used to report discontinuity users via DVB
+ *		  memory mapped API, as defined by &enum dmx_buffer_flags.
  * @ts_type:	type of TS, as defined by &enum ts_filter_type.
  * @pes_type:	type of PES, as defined by &enum dmx_ts_pes.
  * @cc:		MPEG-TS packet continuity counter
@@ -145,6 +147,8 @@ struct dvb_demux_feed {
 	ktime_t timeout;
 	struct dvb_demux_filter *filter;
 
+	u32 buffer_flags;
+
 	enum ts_filter_type ts_type;
 	enum dmx_ts_pes pes_type;
 
diff --git a/include/media/dvb_vb2.h b/include/media/dvb_vb2.h
index af9aeccb0b41..c10c163963e3 100644
--- a/include/media/dvb_vb2.h
+++ b/include/media/dvb_vb2.h
@@ -85,6 +85,12 @@ struct dvb_buffer {
  * @nonblocking:
  *		If different than zero, device is operating on non-blocking
  *		mode.
+ * @flags:	buffer flags as defined by &enum dmx_buffer_flags.
+ *		Filled only at &DMX_DQBUF. &DMX_QBUF should zero this field.
+ * @count:	monotonic counter for filled buffers. Helps to identify
+ *		data stream loses. Filled only at &DMX_DQBUF. &DMX_QBUF should
+ *		zero this field.
+ *
  * @name:	name of the device type. Currently, it can either be
  *		"dvr" or "demux_filter".
  */
@@ -100,6 +106,10 @@ struct dvb_vb2_ctx {
 	int	buf_siz;
 	int	buf_cnt;
 	int	nonblocking;
+
+	enum dmx_buffer_flags flags;
+	u32	count;
+
 	char	name[DVB_VB2_NAME_MAX + 1];
 };
 
@@ -114,7 +124,7 @@ static inline int dvb_vb2_release(struct dvb_vb2_ctx *ctx)
 	return 0;
 };
 #define dvb_vb2_is_streaming(ctx) (0)
-#define dvb_vb2_fill_buffer(ctx, file, wait) (0)
+#define dvb_vb2_fill_buffer(ctx, file, wait, flags) (0)
 
 static inline unsigned int dvb_vb2_poll(struct dvb_vb2_ctx *ctx,
 					struct file *file,
@@ -153,9 +163,13 @@ int dvb_vb2_is_streaming(struct dvb_vb2_ctx *ctx);
  * @ctx:	control struct for VB2 handler
  * @src:	place where the data is stored
  * @len:	number of bytes to be copied from @src
+ * @buffer_flags:
+ *		pointer to buffer flags as defined by &enum dmx_buffer_flags.
+ *		can be NULL.
  */
 int dvb_vb2_fill_buffer(struct dvb_vb2_ctx *ctx,
-			const unsigned char *src, int len);
+			const unsigned char *src, int len,
+			enum dmx_buffer_flags *buffer_flags);
 
 /**
  * dvb_vb2_poll - Wrapper to vb2_core_streamon() for Digital TV
-- 
2.14.3
