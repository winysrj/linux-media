Return-path: <linux-media-owner@vger.kernel.org>
Received: from osg.samsung.com ([64.30.133.232]:37620 "EHLO osg.samsung.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752314AbeBIS6O (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 9 Feb 2018 13:58:14 -0500
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Inki Dae <inki.dae@samsung.com>,
        Satendra Singh Thakur <satendra.t@samsung.com>,
        Seung-Woo Kim <sw0312.kim@samsung.com>,
        Kees Cook <keescook@chromium.org>,
        Ingo Molnar <mingo@kernel.org>,
        Junghak Sung <jh1009.sung@samsung.com>
Subject: [PATCH 2/3] media: dvb: update buffer mmaped flags and frame counter
Date: Fri,  9 Feb 2018 16:58:04 -0200
Message-Id: <f35f414b63738d246a5c958fb3cf8c59f88a3d22.1518202672.git.mchehab@s-opensource.com>
In-Reply-To: <fc8eaff29d67ff9aa9488942caa92448eb6cfb8a.1518202672.git.mchehab@s-opensource.com>
References: <fc8eaff29d67ff9aa9488942caa92448eb6cfb8a.1518202672.git.mchehab@s-opensource.com>
In-Reply-To: <fc8eaff29d67ff9aa9488942caa92448eb6cfb8a.1518202672.git.mchehab@s-opensource.com>
References: <fc8eaff29d67ff9aa9488942caa92448eb6cfb8a.1518202672.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Now that we have support for a buffer counter and for
error flags, update them at DMX_DQBUF.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 drivers/media/dvb-core/dmxdev.c    | 11 +++--
 drivers/media/dvb-core/dvb_demux.c | 95 ++++++++++++++++++++++++--------------
 drivers/media/dvb-core/dvb_vb2.c   | 14 +++++-
 include/media/demux.h              | 11 +++--
 include/media/dvb_vb2.h            | 15 +++++-
 5 files changed, 101 insertions(+), 45 deletions(-)

diff --git a/drivers/media/dvb-core/dmxdev.c b/drivers/media/dvb-core/dmxdev.c
index 41cacb7b5703..03485a706929 100644
--- a/drivers/media/dvb-core/dmxdev.c
+++ b/drivers/media/dvb-core/dmxdev.c
@@ -399,10 +399,12 @@ static int dvb_dmxdev_section_callback(const u8 *buffer1, size_t buffer1_len,
 	dprintk("section callback %*ph\n", 6, buffer1);
 	if (dvb_vb2_is_streaming(&dmxdevfilter->vb2_ctx)) {
 		ret = dvb_vb2_fill_buffer(&dmxdevfilter->vb2_ctx,
-					  buffer1, buffer1_len);
+					  buffer1, buffer1_len,
+					  &filter->buffer_flags);
 		if (ret == buffer1_len)
 			ret = dvb_vb2_fill_buffer(&dmxdevfilter->vb2_ctx,
-						  buffer2, buffer2_len);
+						  buffer2, buffer2_len,
+						  &filter->buffer_flags);
 	} else {
 		ret = dvb_dmxdev_buffer_write(&dmxdevfilter->buffer,
 					      buffer1, buffer1_len);
@@ -451,9 +453,10 @@ static int dvb_dmxdev_ts_callback(const u8 *buffer1, size_t buffer1_len,
 	}
 
 	if (dvb_vb2_is_streaming(ctx)) {
-		ret = dvb_vb2_fill_buffer(ctx, buffer1, buffer1_len);
+		ret = dvb_vb2_fill_buffer(ctx, buffer1, buffer1_len, NULL);
 		if (ret == buffer1_len)
-			ret = dvb_vb2_fill_buffer(ctx, buffer2, buffer2_len);
+			ret = dvb_vb2_fill_buffer(ctx, buffer2, buffer2_len,
+						  NULL);
 	} else {
 		if (buffer->error) {
 			spin_unlock(&dmxdevfilter->dev->lock);
diff --git a/drivers/media/dvb-core/dvb_demux.c b/drivers/media/dvb-core/dvb_demux.c
index 210eed0269b0..6b82281660ca 100644
--- a/drivers/media/dvb-core/dvb_demux.c
+++ b/drivers/media/dvb-core/dvb_demux.c
@@ -55,6 +55,15 @@ MODULE_PARM_DESC(dvb_demux_feed_err_pkts,
 		dprintk(x);				\
 } while (0)
 
+#ifdef CONFIG_DVB_DEMUX_SECTION_LOSS_LOG
+#  define dprintk_sect_loss(x...) dprintk(x)
+#else
+#  define dprintk_sect_loss(x...)
+#endif
+
+#define set_buf_flags(__feed, __flag) \
+	do { (__feed)->filter->filter.buffer_flags |= (__flag); } while (0)
+
 /******************************************************************************
  * static inlined helper functions
  ******************************************************************************/
@@ -104,24 +113,22 @@ static inline int dvb_dmx_swfilter_payload(struct dvb_demux_feed *feed,
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
@@ -169,8 +176,10 @@ static inline int dvb_dmx_swfilter_section_feed(struct dvb_demux_feed *feed)
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
@@ -187,7 +196,6 @@ static void dvb_dmx_swfilter_section_new(struct dvb_demux_feed *feed)
 {
 	struct dmx_section_feed *sec = &feed->feed.sec;
 
-#ifdef CONFIG_DVB_DEMUX_SECTION_LOSS_LOG
 	if (sec->secbufp < sec->tsfeedp) {
 		int n = sec->tsfeedp - sec->secbufp;
 
@@ -197,12 +205,13 @@ static void dvb_dmx_swfilter_section_new(struct dvb_demux_feed *feed)
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
@@ -237,11 +246,10 @@ static int dvb_dmx_swfilter_section_copy_dump(struct dvb_demux_feed *feed,
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
 
@@ -269,12 +277,13 @@ static int dvb_dmx_swfilter_section_copy_dump(struct dvb_demux_feed *feed,
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
@@ -307,18 +316,22 @@ static int dvb_dmx_swfilter_section_packet(struct dvb_demux_feed *feed,
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
@@ -326,6 +339,7 @@ static int dvb_dmx_swfilter_section_packet(struct dvb_demux_feed *feed,
 		 * FIXME: does it make sense if the MPEG-TS is the one
 		 *	reporting discontinuity?
 		 */
+
 		feed->pusi_seen = false;
 		dvb_dmx_swfilter_section_new(feed);
 	}
@@ -346,10 +360,11 @@ static int dvb_dmx_swfilter_section_packet(struct dvb_demux_feed *feed,
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
@@ -430,6 +445,11 @@ static void dvb_dmx_swfilter_packet(struct dvb_demux *demux, const u8 *buf)
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
@@ -445,6 +465,13 @@ static void dvb_dmx_swfilter_packet(struct dvb_demux *demux, const u8 *buf)
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
diff --git a/drivers/media/dvb-core/dvb_vb2.c b/drivers/media/dvb-core/dvb_vb2.c
index 889abf9becd8..a674e8cce937 100644
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
@@ -283,6 +284,12 @@ int dvb_vb2_fill_buffer(struct dvb_vb2_ctx *ctx,
 
 			ctx->buf = list_entry(ctx->dvb_q.next,
 					      struct dvb_buffer, list);
+			if (buffer_flags) {
+				ctx->flags = *buffer_flags;
+				*buffer_flags = 0;
+			} else {
+				ctx->flags = 0;
+			}
 			ctx->remain = vb2_plane_size(&ctx->buf->vb, 0);
 			ctx->offset = 0;
 		}
@@ -402,7 +409,10 @@ int dvb_vb2_dqbuf(struct dvb_vb2_ctx *ctx, struct dmx_buffer *b)
 		dprintk(1, "[%s] errno=%d\n", ctx->name, ret);
 		return ret;
 	}
-	dprintk(5, "[%s] index=%d\n", ctx->name, b->index);
+	b->count = ctx->count++;
+	b->flags = ctx->flags;
+	dprintk(5, "[%s] index=%d, count=%d, flags=%d\n",
+		ctx->name, b->index, ctx->count, ctx->flags);
 
 	return 0;
 }
diff --git a/include/media/demux.h b/include/media/demux.h
index c4df6cee48e6..95b643f54d26 100644
--- a/include/media/demux.h
+++ b/include/media/demux.h
@@ -117,7 +117,9 @@ struct dmx_ts_feed {
  *		  specified by @filter_value that will be used on the filter
  *		  match logic.
  * @filter_mode:  Contains a 16 bytes (128 bits) filter mode.
- * @parent:	  Pointer to struct dmx_section_feed.
+ * @buffer_flags: Buffer flags used to report discontinuity users via DVB
+ *		  memory mapped API, as defined by &enum dmx_buffer_flags.
+ * @parent:	  Back-pointer to struct dmx_section_feed.
  * @priv:	  Pointer to private data of the API client.
  *
  *
@@ -130,8 +132,11 @@ struct dmx_section_filter {
 	u8 filter_value[DMX_MAX_FILTER_SIZE];
 	u8 filter_mask[DMX_MAX_FILTER_SIZE];
 	u8 filter_mode[DMX_MAX_FILTER_SIZE];
-	struct dmx_section_feed *parent; /* Back-pointer */
-	void *priv; /* Pointer to private data of the API client */
+	struct dmx_section_feed *parent;
+
+	enum dmx_buffer_flags buffer_flags;
+
+	void *priv;
 };
 
 /**
diff --git a/include/media/dvb_vb2.h b/include/media/dvb_vb2.h
index af9aeccb0b41..1b2c6bc587af 100644
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
@@ -155,7 +165,8 @@ int dvb_vb2_is_streaming(struct dvb_vb2_ctx *ctx);
  * @len:	number of bytes to be copied from @src
  */
 int dvb_vb2_fill_buffer(struct dvb_vb2_ctx *ctx,
-			const unsigned char *src, int len);
+			const unsigned char *src, int len,
+			enum dmx_buffer_flags *buffer_flags);
 
 /**
  * dvb_vb2_poll - Wrapper to vb2_core_streamon() for Digital TV
-- 
2.14.3
