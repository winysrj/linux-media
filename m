Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.w1.samsung.com ([210.118.77.13]:29858 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752810AbbIROWB (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 18 Sep 2015 10:22:01 -0400
From: Andrzej Pietrasiewicz <andrzej.p@samsung.com>
To: linux-samsung-soc@vger.kernel.org, linux-media@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org
Cc: Andrzej Pietrasiewicz <andrzej.p@samsung.com>,
	Jacek Anaszewski <j.anaszewski@samsung.com>,
	Kukjin Kim <kgene@kernel.org>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Krzysztof Kozlowski <k.kozlowski@samsung.com>
Subject: [PATCH 2/4] s5p-jpeg: add support for 5433
Date: Fri, 18 Sep 2015 16:20:58 +0200
Message-id: <1442586060-23657-3-git-send-email-andrzej.p@samsung.com>
In-reply-to: <1442586060-23657-1-git-send-email-andrzej.p@samsung.com>
References: <1442586060-23657-1-git-send-email-andrzej.p@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

JPEG IP found in Exynos5433 is similar to what is in Exynos4, but
there are some subtle differences which this patch takes into account.

The most important difference is in what is processed by the JPEG IP and
what has to be provided to it. In case of 5433 the IP does not parse
Huffman and quantisation tables, so this has to be performed with the CPU
and the majority of the code in this patch does that.

A small but important difference is in what address is passed to the JPEG
IP. In case of 5433 it is the SOS (start of scan) position, which is
natural, because the headers must be parsed elsewhere.

There is also a difference in how the hardware is put to work in
device_run.

Data structures are extended as appropriate to accommodate the above
changes.

Signed-off-by: Andrzej Pietrasiewicz <andrzej.p@samsung.com>
---
 .../bindings/media/exynos-jpeg-codec.txt           |   3 +-
 drivers/media/platform/s5p-jpeg/jpeg-core.c        | 378 +++++++++++++++++++--
 drivers/media/platform/s5p-jpeg/jpeg-core.h        |  31 ++
 drivers/media/platform/s5p-jpeg/jpeg-hw-exynos4.c  |  80 ++++-
 drivers/media/platform/s5p-jpeg/jpeg-hw-exynos4.h  |  11 +-
 drivers/media/platform/s5p-jpeg/jpeg-regs.h        |  85 +++--
 6 files changed, 522 insertions(+), 66 deletions(-)

diff --git a/Documentation/devicetree/bindings/media/exynos-jpeg-codec.txt b/Documentation/devicetree/bindings/media/exynos-jpeg-codec.txt
index 4ef4563..38941db 100644
--- a/Documentation/devicetree/bindings/media/exynos-jpeg-codec.txt
+++ b/Documentation/devicetree/bindings/media/exynos-jpeg-codec.txt
@@ -4,7 +4,8 @@ Required properties:
 
 - compatible	: should be one of:
 		  "samsung,s5pv210-jpeg", "samsung,exynos4210-jpeg",
-		  "samsung,exynos3250-jpeg", "samsung,exynos5420-jpeg";
+		  "samsung,exynos3250-jpeg", "samsung,exynos5420-jpeg",
+		  "samsung,exynos5433-jpeg";
 - reg		: address and length of the JPEG codec IP register set;
 - interrupts	: specifies the JPEG codec IP interrupt;
 - clock-names   : should contain:
diff --git a/drivers/media/platform/s5p-jpeg/jpeg-core.c b/drivers/media/platform/s5p-jpeg/jpeg-core.c
index 03d0904..bc5505a 100644
--- a/drivers/media/platform/s5p-jpeg/jpeg-core.c
+++ b/drivers/media/platform/s5p-jpeg/jpeg-core.c
@@ -626,6 +626,7 @@ static int s5p_jpeg_to_user_subsampling(struct s5p_jpeg_ctx *ctx)
 			return V4L2_JPEG_CHROMA_SUBSAMPLING_411;
 		return exynos3250_decoded_subsampling[ctx->subsampling];
 	case SJPEG_EXYNOS4:
+	case SJPEG_EXYNOS5433:
 		if (ctx->subsampling > 2)
 			return V4L2_JPEG_CHROMA_SUBSAMPLING_420;
 		return exynos4x12_decoded_subsampling[ctx->subsampling];
@@ -750,6 +751,211 @@ static void exynos4_jpeg_set_huff_tbl(void __iomem *base)
 							ARRAY_SIZE(hactblg0));
 }
 
+static inline int __exynos4_huff_tbl(int class, int id, bool lenval)
+{
+	/*
+	 * class: 0 - DC, 1 - AC
+	 * id: 0 - Y, 1 - Cb/Cr
+	 */
+	if (class) {
+		if (id)
+			return lenval ? EXYNOS4_HUFF_TBL_HACCL :
+				EXYNOS4_HUFF_TBL_HACCV;
+		return lenval ? EXYNOS4_HUFF_TBL_HACLL : EXYNOS4_HUFF_TBL_HACLV;
+
+	}
+	/* class == 0 */
+	if (id)
+		return lenval ? EXYNOS4_HUFF_TBL_HDCCL : EXYNOS4_HUFF_TBL_HDCCV;
+
+	return lenval ? EXYNOS4_HUFF_TBL_HDCLL : EXYNOS4_HUFF_TBL_HDCLV;
+}
+
+static inline int exynos4_huff_tbl_len(int class, int id)
+{
+	return __exynos4_huff_tbl(class, id, true);
+}
+
+static inline int exynos4_huff_tbl_val(int class, int id)
+{
+	return __exynos4_huff_tbl(class, id, false);
+}
+
+static int get_byte(struct s5p_jpeg_buffer *buf);
+static int get_word_be(struct s5p_jpeg_buffer *buf, unsigned int *word);
+static void skip(struct s5p_jpeg_buffer *buf, long len);
+
+static void exynos4_jpeg_parse_decode_h_tbl(struct s5p_jpeg_ctx *ctx)
+{
+	struct s5p_jpeg *jpeg = ctx->jpeg;
+	struct vb2_buffer *vb = v4l2_m2m_next_src_buf(ctx->fh.m2m_ctx);
+	struct s5p_jpeg_buffer jpeg_buffer;
+	unsigned int word;
+	int c, x, components;
+
+	jpeg_buffer.size = 2; /* Ls */
+	jpeg_buffer.data =
+		(unsigned long)vb2_plane_vaddr(vb, 0) + ctx->out_q.sos + 2;
+	jpeg_buffer.curr = 0;
+
+	word = 0;
+
+	if (get_word_be(&jpeg_buffer, &word))
+		return;
+	jpeg_buffer.size = (long)word - 2;
+	jpeg_buffer.data += 2;
+	jpeg_buffer.curr = 0;
+
+	components = get_byte(&jpeg_buffer);
+	if (components == -1)
+		return;
+	while (components--) {
+		c = get_byte(&jpeg_buffer);
+		if (c == -1)
+			return;
+		x = get_byte(&jpeg_buffer);
+		if (x == -1)
+			return;
+		exynos4_jpeg_select_dec_h_tbl(jpeg->regs, c,
+					(((x >> 4) & 0x1) << 1) | (x & 0x1));
+	}
+
+}
+
+static void exynos4_jpeg_parse_huff_tbl(struct s5p_jpeg_ctx *ctx)
+{
+	struct s5p_jpeg *jpeg = ctx->jpeg;
+	struct vb2_buffer *vb = v4l2_m2m_next_src_buf(ctx->fh.m2m_ctx);
+	struct s5p_jpeg_buffer jpeg_buffer;
+	unsigned int word;
+	int c, i, n, j;
+
+	for (j = 0; j < ctx->out_q.dht.n; ++j) {
+		jpeg_buffer.size = ctx->out_q.dht.len[j];
+		jpeg_buffer.data = (unsigned long)vb2_plane_vaddr(vb, 0) +
+				   ctx->out_q.dht.marker[j];
+		jpeg_buffer.curr = 0;
+
+		word = 0;
+		while (jpeg_buffer.curr < jpeg_buffer.size) {
+			char id, class;
+
+			c = get_byte(&jpeg_buffer);
+			if (c == -1)
+				return;
+			id = c & 0xf;
+			class = (c >> 4) & 0xf;
+			n = 0;
+			for (i = 0; i < 16; ++i) {
+				c = get_byte(&jpeg_buffer);
+				if (c == -1)
+					return;
+				word |= c << ((i % 4) * 8);
+				if ((i + 1) % 4 == 0) {
+					writel(word, jpeg->regs +
+					exynos4_huff_tbl_len(class, id) +
+					(i / 4) * 4);
+					word = 0;
+				}
+				n += c;
+			}
+			word = 0;
+			for (i = 0; i < n; ++i) {
+				c = get_byte(&jpeg_buffer);
+				if (c == -1)
+					return;
+				word |= c << ((i % 4) * 8);
+				if ((i + 1) % 4 == 0) {
+					writel(word, jpeg->regs +
+					exynos4_huff_tbl_val(class, id) +
+					(i / 4) * 4);
+					word = 0;
+				}
+			}
+			if (i % 4) {
+				writel(word, jpeg->regs +
+				exynos4_huff_tbl_val(class, id) + (i / 4) * 4);
+			}
+			word = 0;
+		}
+	}
+}
+
+static void exynos4_jpeg_parse_decode_q_tbl(struct s5p_jpeg_ctx *ctx)
+{
+	struct s5p_jpeg *jpeg = ctx->jpeg;
+	struct vb2_buffer *vb = v4l2_m2m_next_src_buf(ctx->fh.m2m_ctx);
+	struct s5p_jpeg_buffer jpeg_buffer;
+	unsigned int word;
+	int c, x, components;
+
+	jpeg_buffer.size = ctx->out_q.sof_len;
+	jpeg_buffer.data =
+		(unsigned long)vb2_plane_vaddr(vb, 0) + ctx->out_q.sof;
+	jpeg_buffer.curr = 0;
+
+	word = 0;
+
+	skip(&jpeg_buffer, 5); /* P, Y, X */
+	components = get_byte(&jpeg_buffer);
+	if (components == -1)
+		return;
+
+	exynos4_jpeg_set_dec_components(jpeg->regs, components);
+
+	while (components--) {
+		c = get_byte(&jpeg_buffer);
+		if (c == -1)
+			return;
+		skip(&jpeg_buffer, 1);
+		x = get_byte(&jpeg_buffer);
+		if (x == -1)
+			return;
+		exynos4_jpeg_select_dec_q_tbl(jpeg->regs, c, x);
+	}
+}
+
+static void exynos4_jpeg_parse_q_tbl(struct s5p_jpeg_ctx *ctx)
+{
+	struct s5p_jpeg *jpeg = ctx->jpeg;
+	struct vb2_buffer *vb = v4l2_m2m_next_src_buf(ctx->fh.m2m_ctx);
+	struct s5p_jpeg_buffer jpeg_buffer;
+	unsigned int word;
+	int c, i, j;
+
+	for (j = 0; j < ctx->out_q.dqt.n; ++j) {
+		jpeg_buffer.size = ctx->out_q.dqt.len[j];
+		jpeg_buffer.data = (unsigned long)vb2_plane_vaddr(vb, 0) +
+				   ctx->out_q.dqt.marker[j];
+		jpeg_buffer.curr = 0;
+
+		word = 0;
+		while (jpeg_buffer.size - jpeg_buffer.curr >= 65) {
+			char id;
+
+			c = get_byte(&jpeg_buffer);
+			if (c == -1)
+				return;
+			id = c & 0xf;
+			/* nonzero means extended mode - not supported */
+			if ((c >> 4) & 0xf)
+				return;
+			for (i = 0; i < 64; ++i) {
+				c = get_byte(&jpeg_buffer);
+				if (c == -1)
+					return;
+				word |= c << ((i % 4) * 8);
+				if ((i + 1) % 4 == 0) {
+					writel(word, jpeg->regs +
+					EXYNOS4_QTBL_CONTENT(id) + (i / 4) * 4);
+					word = 0;
+				}
+			}
+			word = 0;
+		}
+	}
+}
+
 /*
  * ============================================================================
  * Device file operations
@@ -894,8 +1100,11 @@ static bool s5p_jpeg_parse_hdr(struct s5p_jpeg_q_data *result,
 			       unsigned long buffer, unsigned long size,
 			       struct s5p_jpeg_ctx *ctx)
 {
-	int c, components = 0, notfound;
-	unsigned int height, width, word, subsampling = 0;
+	int c, components = 0, notfound, n_dht = 0, n_dqt = 0;
+	unsigned int height, width, word, subsampling = 0, sos = 0, sof = 0,
+		     sof_len = 0;
+	unsigned int dht[S5P_JPEG_MAX_MARKER], dht_len[S5P_JPEG_MAX_MARKER],
+		     dqt[S5P_JPEG_MAX_MARKER], dqt_len[S5P_JPEG_MAX_MARKER];
 	long length;
 	struct s5p_jpeg_buffer jpeg_buffer;
 
@@ -904,7 +1113,7 @@ static bool s5p_jpeg_parse_hdr(struct s5p_jpeg_q_data *result,
 	jpeg_buffer.curr = 0;
 
 	notfound = 1;
-	while (notfound) {
+	while (notfound || !sos) {
 		c = get_byte(&jpeg_buffer);
 		if (c == -1)
 			return false;
@@ -923,6 +1132,11 @@ static bool s5p_jpeg_parse_hdr(struct s5p_jpeg_q_data *result,
 		case SOF0:
 			if (get_word_be(&jpeg_buffer, &word))
 				break;
+			length = (long)word - 2;
+			if (!length)
+				return false;
+			sof = jpeg_buffer.curr; /* after 0xffc0 */
+			sof_len = length;
 			if (get_byte(&jpeg_buffer) == -1)
 				break;
 			if (get_word_be(&jpeg_buffer, &height))
@@ -932,7 +1146,6 @@ static bool s5p_jpeg_parse_hdr(struct s5p_jpeg_q_data *result,
 			components = get_byte(&jpeg_buffer);
 			if (components == -1)
 				break;
-			notfound = 0;
 
 			if (components == 1) {
 				subsampling = 0x33;
@@ -941,8 +1154,40 @@ static bool s5p_jpeg_parse_hdr(struct s5p_jpeg_q_data *result,
 				subsampling = get_byte(&jpeg_buffer);
 				skip(&jpeg_buffer, 1);
 			}
-
+			if (components > 3)
+				return false;
 			skip(&jpeg_buffer, components * 2);
+			notfound = 0;
+			break;
+
+		case DQT:
+			if (get_word_be(&jpeg_buffer, &word))
+				break;
+			length = (long)word - 2;
+			if (!length)
+				return false;
+			if (n_dqt >= S5P_JPEG_MAX_MARKER)
+				return false;
+			dqt[n_dqt] = jpeg_buffer.curr; /* after 0xffdb */
+			dqt_len[n_dqt++] = length;
+			skip(&jpeg_buffer, length);
+			break;
+
+		case DHT:
+			if (get_word_be(&jpeg_buffer, &word))
+				break;
+			length = (long)word - 2;
+			if (!length)
+				return false;
+			if (n_dht >= S5P_JPEG_MAX_MARKER)
+				return false;
+			dht[n_dht] = jpeg_buffer.curr; /* after 0xffc4 */
+			dht_len[n_dht++] = length;
+			skip(&jpeg_buffer, length);
+			break;
+
+		case SOS:
+			sos = jpeg_buffer.curr - 2; /* 0xffda */
 			break;
 
 		/* skip payload-less markers */
@@ -963,7 +1208,20 @@ static bool s5p_jpeg_parse_hdr(struct s5p_jpeg_q_data *result,
 	}
 	result->w = width;
 	result->h = height;
-	result->size = components;
+	result->sos = sos;
+	result->dht.n = n_dht;
+	while (n_dht--) {
+		result->dht.marker[n_dht] = dht[n_dht];
+		result->dht.len[n_dht] = dht_len[n_dht];
+	}
+	result->dqt.n = n_dqt;
+	while (n_dqt--) {
+		result->dqt.marker[n_dqt] = dqt[n_dqt];
+		result->dqt.len[n_dqt] = dqt_len[n_dqt];
+	}
+	result->sof = sof;
+	result->sof_len = sof_len;
+	result->size = result->components = components;
 
 	switch (subsampling) {
 	case 0x11:
@@ -982,7 +1240,7 @@ static bool s5p_jpeg_parse_hdr(struct s5p_jpeg_q_data *result,
 		return false;
 	}
 
-	return !notfound;
+	return !notfound && sos;
 }
 
 static int s5p_jpeg_querycap(struct file *file, void *priv,
@@ -1226,8 +1484,7 @@ static int s5p_jpeg_try_fmt_vid_cap(struct file *file, void *priv,
 		return -EINVAL;
 	}
 
-	if ((ctx->jpeg->variant->version != SJPEG_EXYNOS4) ||
-	    (ctx->mode != S5P_JPEG_DECODE))
+	if (!ctx->jpeg->variant->hw_ex4_compat || ctx->mode != S5P_JPEG_DECODE)
 		goto exit;
 
 	/*
@@ -1350,7 +1607,7 @@ static int s5p_jpeg_s_fmt(struct s5p_jpeg_ctx *ct, struct v4l2_format *f)
 		 * the JPEG_IMAGE_SIZE register. In order to avoid sysmmu
 		 * page fault calculate proper buffer size in such a case.
 		 */
-		if (ct->jpeg->variant->version == SJPEG_EXYNOS4 &&
+		if (ct->jpeg->variant->hw_ex4_compat &&
 		    f_type == FMT_TYPE_OUTPUT && ct->mode == S5P_JPEG_ENCODE)
 			q_data->size = exynos4_jpeg_get_output_buffer_size(ct,
 							f,
@@ -1889,9 +2146,36 @@ static void exynos4_jpeg_set_jpeg_addr(struct s5p_jpeg_ctx *ctx)
 		vb = v4l2_m2m_next_src_buf(ctx->fh.m2m_ctx);
 
 	jpeg_addr = vb2_dma_contig_plane_dma_addr(vb, 0);
+	if (jpeg->variant->version == SJPEG_EXYNOS5433 &&
+	    ctx->mode == S5P_JPEG_DECODE)
+		jpeg_addr += ctx->out_q.sos;
 	exynos4_jpeg_set_stream_buf_address(jpeg->regs, jpeg_addr);
 }
 
+static inline void exynos4_jpeg_set_img_fmt(void __iomem *base,
+					    unsigned int img_fmt)
+{
+	__exynos4_jpeg_set_img_fmt(base, img_fmt, SJPEG_EXYNOS4);
+}
+
+static inline void exynos5433_jpeg_set_img_fmt(void __iomem *base,
+					       unsigned int img_fmt)
+{
+	__exynos4_jpeg_set_img_fmt(base, img_fmt, SJPEG_EXYNOS5433);
+}
+
+static inline void exynos4_jpeg_set_enc_out_fmt(void __iomem *base,
+						unsigned int out_fmt)
+{
+	__exynos4_jpeg_set_enc_out_fmt(base, out_fmt, SJPEG_EXYNOS4);
+}
+
+static inline void exynos5433_jpeg_set_enc_out_fmt(void __iomem *base,
+						   unsigned int out_fmt)
+{
+	__exynos4_jpeg_set_enc_out_fmt(base, out_fmt, SJPEG_EXYNOS5433);
+}
+
 static void exynos4_jpeg_device_run(void *priv)
 {
 	struct s5p_jpeg_ctx *ctx = priv;
@@ -1899,11 +2183,11 @@ static void exynos4_jpeg_device_run(void *priv)
 	unsigned int bitstream_size;
 	unsigned long flags;
 
-	spin_lock_irqsave(&ctx->jpeg->slock, flags);
+	spin_lock_irqsave(&jpeg->slock, flags);
 
 	if (ctx->mode == S5P_JPEG_ENCODE) {
 		exynos4_jpeg_sw_reset(jpeg->regs);
-		exynos4_jpeg_set_interrupt(jpeg->regs);
+		exynos4_jpeg_set_interrupt(jpeg->regs, jpeg->variant->version);
 		exynos4_jpeg_set_huf_table_enable(jpeg->regs, 1);
 
 		exynos4_jpeg_set_huff_tbl(jpeg->regs);
@@ -1920,27 +2204,56 @@ static void exynos4_jpeg_device_run(void *priv)
 		exynos4_jpeg_set_stream_size(jpeg->regs, ctx->cap_q.w,
 							ctx->cap_q.h);
 
-		exynos4_jpeg_set_enc_out_fmt(jpeg->regs, ctx->subsampling);
-		exynos4_jpeg_set_img_fmt(jpeg->regs, ctx->out_q.fmt->fourcc);
+		if (ctx->jpeg->variant->version == SJPEG_EXYNOS4) {
+			exynos4_jpeg_set_enc_out_fmt(jpeg->regs,
+						     ctx->subsampling);
+			exynos4_jpeg_set_img_fmt(jpeg->regs,
+						 ctx->out_q.fmt->fourcc);
+		} else {
+			exynos5433_jpeg_set_enc_out_fmt(jpeg->regs,
+							ctx->subsampling);
+			exynos5433_jpeg_set_img_fmt(jpeg->regs,
+						    ctx->out_q.fmt->fourcc);
+		}
 		exynos4_jpeg_set_img_addr(ctx);
 		exynos4_jpeg_set_jpeg_addr(ctx);
 		exynos4_jpeg_set_encode_hoff_cnt(jpeg->regs,
 							ctx->out_q.fmt->fourcc);
 	} else {
 		exynos4_jpeg_sw_reset(jpeg->regs);
-		exynos4_jpeg_set_interrupt(jpeg->regs);
+		exynos4_jpeg_set_interrupt(jpeg->regs,
+					   jpeg->variant->version);
 		exynos4_jpeg_set_img_addr(ctx);
 		exynos4_jpeg_set_jpeg_addr(ctx);
-		exynos4_jpeg_set_img_fmt(jpeg->regs, ctx->cap_q.fmt->fourcc);
 
-		bitstream_size = DIV_ROUND_UP(ctx->out_q.size, 32);
+		if (jpeg->variant->version == SJPEG_EXYNOS5433) {
+			exynos4_jpeg_parse_huff_tbl(ctx);
+			exynos4_jpeg_parse_decode_h_tbl(ctx);
+
+			exynos4_jpeg_parse_q_tbl(ctx);
+			exynos4_jpeg_parse_decode_q_tbl(ctx);
+
+			exynos4_jpeg_set_huf_table_enable(jpeg->regs, 1);
+
+			exynos4_jpeg_set_stream_size(jpeg->regs, ctx->cap_q.w,
+					ctx->cap_q.h);
+			exynos5433_jpeg_set_enc_out_fmt(jpeg->regs,
+							ctx->subsampling);
+			exynos5433_jpeg_set_img_fmt(jpeg->regs,
+						    ctx->cap_q.fmt->fourcc);
+			bitstream_size = DIV_ROUND_UP(ctx->out_q.size, 16);
+		} else {
+			exynos4_jpeg_set_img_fmt(jpeg->regs,
+						 ctx->cap_q.fmt->fourcc);
+			bitstream_size = DIV_ROUND_UP(ctx->out_q.size, 32);
+		}
 
 		exynos4_jpeg_set_dec_bitstream_size(jpeg->regs, bitstream_size);
 	}
 
 	exynos4_jpeg_set_enc_dec_mode(jpeg->regs, ctx->mode);
 
-	spin_unlock_irqrestore(&ctx->jpeg->slock, flags);
+	spin_unlock_irqrestore(&jpeg->slock, flags);
 }
 
 static void exynos3250_jpeg_set_img_addr(struct s5p_jpeg_ctx *ctx)
@@ -2187,6 +2500,17 @@ static void s5p_jpeg_buf_queue(struct vb2_buffer *vb)
 		q_data = &ctx->out_q;
 		q_data->w = tmp.w;
 		q_data->h = tmp.h;
+		q_data->sos = tmp.sos;
+		memcpy(q_data->dht.marker, tmp.dht.marker,
+		       sizeof(tmp.dht.marker));
+		memcpy(q_data->dht.len, tmp.dht.len, sizeof(tmp.dht.len));
+		q_data->dht.n = tmp.dht.n;
+		memcpy(q_data->dqt.marker, tmp.dqt.marker,
+		       sizeof(tmp.dqt.marker));
+		memcpy(q_data->dqt.len, tmp.dqt.len, sizeof(tmp.dqt.len));
+		q_data->dqt.n = tmp.dqt.n;
+		q_data->sof = tmp.sof;
+		q_data->sof_len = tmp.sof_len;
 
 		q_data = &ctx->cap_q;
 		q_data->w = tmp.w;
@@ -2373,7 +2697,8 @@ static irqreturn_t exynos4_jpeg_irq(int irq, void *priv)
 	}
 
 	v4l2_m2m_job_finish(jpeg->m2m_dev, curr_ctx->fh.m2m_ctx);
-	curr_ctx->subsampling = exynos4_jpeg_get_frame_fmt(jpeg->regs);
+	if (jpeg->variant->version == SJPEG_EXYNOS4)
+		curr_ctx->subsampling = exynos4_jpeg_get_frame_fmt(jpeg->regs);
 
 	spin_unlock(&jpeg->slock);
 	return IRQ_HANDLED;
@@ -2731,6 +3056,7 @@ static struct s5p_jpeg_variant exynos4_jpeg_drvdata = {
 	.htbl_reinit	= 1,
 	.clk_names	= {"jpeg"},
 	.num_clocks	= 1,
+	.hw_ex4_compat	= 1,
 };
 
 static struct s5p_jpeg_variant exynos5420_jpeg_drvdata = {
@@ -2744,6 +3070,17 @@ static struct s5p_jpeg_variant exynos5420_jpeg_drvdata = {
 	.num_clocks	= 1,
 };
 
+static struct s5p_jpeg_variant exynos5433_jpeg_drvdata = {
+	.version	= SJPEG_EXYNOS5433,
+	.jpeg_irq	= exynos4_jpeg_irq,
+	.m2m_ops	= &exynos4_jpeg_m2m_ops,
+	.fmt_ver_flag	= SJPEG_FMT_FLAG_EXYNOS4,
+	.htbl_reinit	= 1,
+	.clk_names	= {"pclk", "aclk", "aclk_xiu", "sclk"},
+	.num_clocks	= 4,
+	.hw_ex4_compat	= 1,
+};
+
 static const struct of_device_id samsung_jpeg_match[] = {
 	{
 		.compatible = "samsung,s5pv210-jpeg",
@@ -2760,6 +3097,9 @@ static const struct of_device_id samsung_jpeg_match[] = {
 	}, {
 		.compatible = "samsung,exynos5420-jpeg",
 		.data = &exynos5420_jpeg_drvdata,
+	}, {
+		.compatible = "samsung,exynos5433-jpeg",
+		.data = &exynos5433_jpeg_drvdata,
 	},
 	{},
 };
diff --git a/drivers/media/platform/s5p-jpeg/jpeg-core.h b/drivers/media/platform/s5p-jpeg/jpeg-core.h
index d0076fe..9b1db09 100644
--- a/drivers/media/platform/s5p-jpeg/jpeg-core.h
+++ b/drivers/media/platform/s5p-jpeg/jpeg-core.h
@@ -42,9 +42,12 @@
 /* a selection of JPEG markers */
 #define TEM				0x01
 #define SOF0				0xc0
+#define DHT				0xc4
 #define RST				0xd0
 #define SOI				0xd8
 #define EOI				0xd9
+#define	SOS				0xda
+#define DQT				0xdb
 #define DHP				0xde
 
 /* Flags that indicate a format can be used for capture/output */
@@ -68,12 +71,15 @@
 #define SJPEG_SUBSAMPLING_422	0x21
 #define SJPEG_SUBSAMPLING_420	0x22
 
+#define S5P_JPEG_MAX_MARKER	4
+
 /* Version numbers */
 enum sjpeg_version {
 	SJPEG_S5P,
 	SJPEG_EXYNOS3250,
 	SJPEG_EXYNOS4,
 	SJPEG_EXYNOS5420,
+	SJPEG_EXYNOS5433,
 };
 
 enum exynos4_jpeg_result {
@@ -134,6 +140,7 @@ struct s5p_jpeg_variant {
 	unsigned int		fmt_ver_flag;
 	unsigned int		hw3250_compat:1;
 	unsigned int		htbl_reinit:1;
+	unsigned int		hw_ex4_compat:1;
 	struct v4l2_m2m_ops	*m2m_ops;
 	irqreturn_t		(*jpeg_irq)(int irq, void *priv);
 	const char		*clk_names[JPEG_MAX_CLOCKS];
@@ -163,16 +170,40 @@ struct s5p_jpeg_fmt {
 };
 
 /**
+ * s5p_jpeg_marker - collection of markers from jpeg header
+ * @marker:	markers' positions relative to the buffer beginning
+ * @len:	markers' payload lengths (without length field)
+ * @n:		number of markers in collection
+ */
+struct s5p_jpeg_marker {
+	u32	marker[S5P_JPEG_MAX_MARKER];
+	u32	len[S5P_JPEG_MAX_MARKER];
+	u32	n;
+};
+
+/**
  * s5p_jpeg_q_data - parameters of one queue
  * @fmt:	driver-specific format of this queue
  * @w:		image width
  * @h:		image height
+ * @sos:	SOS marker's position relative to the buffer beginning
+ * @dht:	DHT markers' positions relative to the buffer beginning
+ * @dqt:	DQT markers' positions relative to the buffer beginning
+ * @sof:	SOF0 marker's postition relative to the buffer beginning
+ * @sof_len:	SOF0 marker's payload length (without length field itself)
+ * @components:	number of image components
  * @size:	image buffer size in bytes
  */
 struct s5p_jpeg_q_data {
 	struct s5p_jpeg_fmt	*fmt;
 	u32			w;
 	u32			h;
+	u32			sos;
+	struct s5p_jpeg_marker	dht;
+	struct s5p_jpeg_marker	dqt;
+	u32			sof;
+	u32			sof_len;
+	u32			components;
 	u32			size;
 };
 
diff --git a/drivers/media/platform/s5p-jpeg/jpeg-hw-exynos4.c b/drivers/media/platform/s5p-jpeg/jpeg-hw-exynos4.c
index ab6d6f43..0912d0a 100644
--- a/drivers/media/platform/s5p-jpeg/jpeg-hw-exynos4.c
+++ b/drivers/media/platform/s5p-jpeg/jpeg-hw-exynos4.c
@@ -45,9 +45,20 @@ void exynos4_jpeg_set_enc_dec_mode(void __iomem *base, unsigned int mode)
 	}
 }
 
-void exynos4_jpeg_set_img_fmt(void __iomem *base, unsigned int img_fmt)
+void __exynos4_jpeg_set_img_fmt(void __iomem *base, unsigned int img_fmt,
+				unsigned int version)
 {
 	unsigned int reg;
+	unsigned int exynos4_swap_chroma_cbcr;
+	unsigned int exynos4_swap_chroma_crcb;
+
+	if (version == SJPEG_EXYNOS4) {
+		exynos4_swap_chroma_cbcr = EXYNOS4_SWAP_CHROMA_CBCR;
+		exynos4_swap_chroma_crcb = EXYNOS4_SWAP_CHROMA_CRCB;
+	} else {
+		exynos4_swap_chroma_cbcr = EXYNOS5433_SWAP_CHROMA_CBCR;
+		exynos4_swap_chroma_crcb = EXYNOS5433_SWAP_CHROMA_CRCB;
+	}
 
 	reg = readl(base + EXYNOS4_IMG_FMT_REG) &
 			EXYNOS4_ENC_IN_FMT_MASK; /* clear except enc format */
@@ -67,48 +78,48 @@ void exynos4_jpeg_set_img_fmt(void __iomem *base, unsigned int img_fmt)
 	case V4L2_PIX_FMT_NV24:
 		reg = reg | EXYNOS4_ENC_YUV_444_IMG |
 				EXYNOS4_YUV_444_IP_YUV_444_2P_IMG |
-				EXYNOS4_SWAP_CHROMA_CBCR;
+				exynos4_swap_chroma_cbcr;
 		break;
 	case V4L2_PIX_FMT_NV42:
 		reg = reg | EXYNOS4_ENC_YUV_444_IMG |
 				EXYNOS4_YUV_444_IP_YUV_444_2P_IMG |
-				EXYNOS4_SWAP_CHROMA_CRCB;
+				exynos4_swap_chroma_crcb;
 		break;
 	case V4L2_PIX_FMT_YUYV:
 		reg = reg | EXYNOS4_DEC_YUV_422_IMG |
 				EXYNOS4_YUV_422_IP_YUV_422_1P_IMG |
-				EXYNOS4_SWAP_CHROMA_CBCR;
+				exynos4_swap_chroma_cbcr;
 		break;
 
 	case V4L2_PIX_FMT_YVYU:
 		reg = reg | EXYNOS4_DEC_YUV_422_IMG |
 				EXYNOS4_YUV_422_IP_YUV_422_1P_IMG |
-				EXYNOS4_SWAP_CHROMA_CRCB;
+				exynos4_swap_chroma_crcb;
 		break;
 	case V4L2_PIX_FMT_NV16:
 		reg = reg | EXYNOS4_DEC_YUV_422_IMG |
 				EXYNOS4_YUV_422_IP_YUV_422_2P_IMG |
-				EXYNOS4_SWAP_CHROMA_CBCR;
+				exynos4_swap_chroma_cbcr;
 		break;
 	case V4L2_PIX_FMT_NV61:
 		reg = reg | EXYNOS4_DEC_YUV_422_IMG |
 				EXYNOS4_YUV_422_IP_YUV_422_2P_IMG |
-				EXYNOS4_SWAP_CHROMA_CRCB;
+				exynos4_swap_chroma_crcb;
 		break;
 	case V4L2_PIX_FMT_NV12:
 		reg = reg | EXYNOS4_DEC_YUV_420_IMG |
 				EXYNOS4_YUV_420_IP_YUV_420_2P_IMG |
-				EXYNOS4_SWAP_CHROMA_CBCR;
+				exynos4_swap_chroma_cbcr;
 		break;
 	case V4L2_PIX_FMT_NV21:
 		reg = reg | EXYNOS4_DEC_YUV_420_IMG |
 				EXYNOS4_YUV_420_IP_YUV_420_2P_IMG |
-				EXYNOS4_SWAP_CHROMA_CRCB;
+				exynos4_swap_chroma_crcb;
 		break;
 	case V4L2_PIX_FMT_YUV420:
 		reg = reg | EXYNOS4_DEC_YUV_420_IMG |
 				EXYNOS4_YUV_420_IP_YUV_420_3P_IMG |
-				EXYNOS4_SWAP_CHROMA_CBCR;
+				exynos4_swap_chroma_cbcr;
 		break;
 	default:
 		break;
@@ -118,12 +129,14 @@ void exynos4_jpeg_set_img_fmt(void __iomem *base, unsigned int img_fmt)
 	writel(reg, base + EXYNOS4_IMG_FMT_REG);
 }
 
-void exynos4_jpeg_set_enc_out_fmt(void __iomem *base, unsigned int out_fmt)
+void __exynos4_jpeg_set_enc_out_fmt(void __iomem *base, unsigned int out_fmt,
+				    unsigned int version)
 {
 	unsigned int reg;
 
 	reg = readl(base + EXYNOS4_IMG_FMT_REG) &
-			~EXYNOS4_ENC_FMT_MASK; /* clear enc format */
+			~(version == SJPEG_EXYNOS4 ? EXYNOS4_ENC_FMT_MASK :
+			  EXYNOS5433_ENC_FMT_MASK); /* clear enc format */
 
 	switch (out_fmt) {
 	case V4L2_JPEG_CHROMA_SUBSAMPLING_GRAY:
@@ -149,9 +162,18 @@ void exynos4_jpeg_set_enc_out_fmt(void __iomem *base, unsigned int out_fmt)
 	writel(reg, base + EXYNOS4_IMG_FMT_REG);
 }
 
-void exynos4_jpeg_set_interrupt(void __iomem *base)
+void exynos4_jpeg_set_interrupt(void __iomem *base, unsigned int version)
 {
-	writel(EXYNOS4_INT_EN_ALL, base + EXYNOS4_INT_EN_REG);
+	unsigned int reg;
+
+	if (version == SJPEG_EXYNOS4) {
+		reg = readl(base + EXYNOS4_INT_EN_REG) & ~EXYNOS4_INT_EN_MASK;
+		writel(reg | EXYNOS4_INT_EN_ALL, base + EXYNOS4_INT_EN_REG);
+	} else {
+		reg = readl(base + EXYNOS4_INT_EN_REG) &
+							~EXYNOS5433_INT_EN_MASK;
+		writel(reg | EXYNOS5433_INT_EN_ALL, base + EXYNOS4_INT_EN_REG);
+	}
 }
 
 unsigned int exynos4_jpeg_get_int_status(void __iomem *base)
@@ -234,6 +256,36 @@ void exynos4_jpeg_set_encode_tbl_select(void __iomem *base,
 	writel(reg, base + EXYNOS4_TBL_SEL_REG);
 }
 
+void exynos4_jpeg_set_dec_components(void __iomem *base, int n)
+{
+	unsigned int	reg;
+
+	reg = readl(base + EXYNOS4_TBL_SEL_REG);
+
+	reg |= EXYNOS4_NF(n);
+	writel(reg, base + EXYNOS4_TBL_SEL_REG);
+}
+
+void exynos4_jpeg_select_dec_q_tbl(void __iomem *base, char c, char x)
+{
+	unsigned int	reg;
+
+	reg = readl(base + EXYNOS4_TBL_SEL_REG);
+
+	reg |= EXYNOS4_Q_TBL_COMP(c, x);
+	writel(reg, base + EXYNOS4_TBL_SEL_REG);
+}
+
+void exynos4_jpeg_select_dec_h_tbl(void __iomem *base, char c, char x)
+{
+	unsigned int	reg;
+
+	reg = readl(base + EXYNOS4_TBL_SEL_REG);
+
+	reg |= EXYNOS4_HUFF_TBL_COMP(c, x);
+	writel(reg, base + EXYNOS4_TBL_SEL_REG);
+}
+
 void exynos4_jpeg_set_encode_hoff_cnt(void __iomem *base, unsigned int fmt)
 {
 	if (fmt == V4L2_PIX_FMT_GREY)
diff --git a/drivers/media/platform/s5p-jpeg/jpeg-hw-exynos4.h b/drivers/media/platform/s5p-jpeg/jpeg-hw-exynos4.h
index c228d28..cf6ec05 100644
--- a/drivers/media/platform/s5p-jpeg/jpeg-hw-exynos4.h
+++ b/drivers/media/platform/s5p-jpeg/jpeg-hw-exynos4.h
@@ -15,10 +15,12 @@
 
 void exynos4_jpeg_sw_reset(void __iomem *base);
 void exynos4_jpeg_set_enc_dec_mode(void __iomem *base, unsigned int mode);
-void exynos4_jpeg_set_img_fmt(void __iomem *base, unsigned int img_fmt);
-void exynos4_jpeg_set_enc_out_fmt(void __iomem *base, unsigned int out_fmt);
+void __exynos4_jpeg_set_img_fmt(void __iomem *base, unsigned int img_fmt,
+				unsigned int version);
+void __exynos4_jpeg_set_enc_out_fmt(void __iomem *base, unsigned int out_fmt,
+				    unsigned int version);
 void exynos4_jpeg_set_enc_tbl(void __iomem *base);
-void exynos4_jpeg_set_interrupt(void __iomem *base);
+void exynos4_jpeg_set_interrupt(void __iomem *base, unsigned int version);
 unsigned int exynos4_jpeg_get_int_status(void __iomem *base);
 void exynos4_jpeg_set_huf_table_enable(void __iomem *base, int value);
 void exynos4_jpeg_set_sys_int_enable(void __iomem *base, int value);
@@ -30,6 +32,9 @@ void exynos4_jpeg_set_frame_buf_address(void __iomem *base,
 				struct s5p_jpeg_addr *jpeg_addr);
 void exynos4_jpeg_set_encode_tbl_select(void __iomem *base,
 		enum exynos4_jpeg_img_quality_level level);
+void exynos4_jpeg_set_dec_components(void __iomem *base, int n);
+void exynos4_jpeg_select_dec_q_tbl(void __iomem *base, char c, char x);
+void exynos4_jpeg_select_dec_h_tbl(void __iomem *base, char c, char x);
 void exynos4_jpeg_set_encode_hoff_cnt(void __iomem *base, unsigned int fmt);
 void exynos4_jpeg_set_dec_bitstream_size(void __iomem *base, unsigned int size);
 unsigned int exynos4_jpeg_get_stream_size(void __iomem *base);
diff --git a/drivers/media/platform/s5p-jpeg/jpeg-regs.h b/drivers/media/platform/s5p-jpeg/jpeg-regs.h
index 050fc44..1870400 100644
--- a/drivers/media/platform/s5p-jpeg/jpeg-regs.h
+++ b/drivers/media/platform/s5p-jpeg/jpeg-regs.h
@@ -231,12 +231,14 @@
 
 /* JPEG INT Register bit */
 #define EXYNOS4_INT_EN_MASK		(0x1f << 0)
+#define EXYNOS5433_INT_EN_MASK		(0x1ff << 0)
 #define EXYNOS4_PROT_ERR_INT_EN		(1 << 0)
 #define EXYNOS4_IMG_COMPLETION_INT_EN	(1 << 1)
 #define EXYNOS4_DEC_INVALID_FORMAT_EN	(1 << 2)
 #define EXYNOS4_MULTI_SCAN_ERROR_EN	(1 << 3)
 #define EXYNOS4_FRAME_ERR_EN		(1 << 4)
 #define EXYNOS4_INT_EN_ALL		(0x1f << 0)
+#define EXYNOS5433_INT_EN_ALL		(0x1b6 << 0)
 
 #define EXYNOS4_MOD_REG_PROC_ENC	(0 << 3)
 #define EXYNOS4_MOD_REG_PROC_DEC	(1 << 3)
@@ -296,6 +298,8 @@
 
 #define EXYNOS4_ENC_FMT_SHIFT			24
 #define EXYNOS4_ENC_FMT_MASK			(3 << EXYNOS4_ENC_FMT_SHIFT)
+#define EXYNOS5433_ENC_FMT_MASK			(7 << EXYNOS4_ENC_FMT_SHIFT)
+
 #define EXYNOS4_ENC_FMT_GRAY			(0 << EXYNOS4_ENC_FMT_SHIFT)
 #define EXYNOS4_ENC_FMT_YUV_444			(1 << EXYNOS4_ENC_FMT_SHIFT)
 #define EXYNOS4_ENC_FMT_YUV_422			(2 << EXYNOS4_ENC_FMT_SHIFT)
@@ -305,6 +309,8 @@
 
 #define EXYNOS4_SWAP_CHROMA_CRCB		(1 << 26)
 #define EXYNOS4_SWAP_CHROMA_CBCR		(0 << 26)
+#define EXYNOS5433_SWAP_CHROMA_CRCB		(1 << 27)
+#define EXYNOS5433_SWAP_CHROMA_CBCR		(0 << 27)
 
 /* JPEG HUFF count Register bit */
 #define EXYNOS4_HUFF_COUNT_MASK			0xffff
@@ -316,35 +322,56 @@
 #define EXYNOS4_DECODED_IMG_FMT_MASK		0x3
 
 /* JPEG TBL SEL Register bit */
-#define EXYNOS4_Q_TBL_COMP1_0		(0 << 0)
-#define EXYNOS4_Q_TBL_COMP1_1		(1 << 0)
-#define EXYNOS4_Q_TBL_COMP1_2		(2 << 0)
-#define EXYNOS4_Q_TBL_COMP1_3		(3 << 0)
-
-#define EXYNOS4_Q_TBL_COMP2_0		(0 << 2)
-#define EXYNOS4_Q_TBL_COMP2_1		(1 << 2)
-#define EXYNOS4_Q_TBL_COMP2_2		(2 << 2)
-#define EXYNOS4_Q_TBL_COMP2_3		(3 << 2)
-
-#define EXYNOS4_Q_TBL_COMP3_0		(0 << 4)
-#define EXYNOS4_Q_TBL_COMP3_1		(1 << 4)
-#define EXYNOS4_Q_TBL_COMP3_2		(2 << 4)
-#define EXYNOS4_Q_TBL_COMP3_3		(3 << 4)
-
-#define EXYNOS4_HUFF_TBL_COMP1_AC_0_DC_0	(0 << 6)
-#define EXYNOS4_HUFF_TBL_COMP1_AC_0_DC_1	(1 << 6)
-#define EXYNOS4_HUFF_TBL_COMP1_AC_1_DC_0	(2 << 6)
-#define EXYNOS4_HUFF_TBL_COMP1_AC_1_DC_1	(3 << 6)
-
-#define EXYNOS4_HUFF_TBL_COMP2_AC_0_DC_0	(0 << 8)
-#define EXYNOS4_HUFF_TBL_COMP2_AC_0_DC_1	(1 << 8)
-#define EXYNOS4_HUFF_TBL_COMP2_AC_1_DC_0	(2 << 8)
-#define EXYNOS4_HUFF_TBL_COMP2_AC_1_DC_1	(3 << 8)
-
-#define EXYNOS4_HUFF_TBL_COMP3_AC_0_DC_0	(0 << 10)
-#define EXYNOS4_HUFF_TBL_COMP3_AC_0_DC_1	(1 << 10)
-#define EXYNOS4_HUFF_TBL_COMP3_AC_1_DC_0	(2 << 10)
-#define EXYNOS4_HUFF_TBL_COMP3_AC_1_DC_1	(3 << 10)
+#define EXYNOS4_Q_TBL_COMP(c, n)	((n) << (((c) - 1) << 1))
+
+#define EXYNOS4_Q_TBL_COMP1_0		EXYNOS4_Q_TBL_COMP(1, 0)
+#define EXYNOS4_Q_TBL_COMP1_1		EXYNOS4_Q_TBL_COMP(1, 1)
+#define EXYNOS4_Q_TBL_COMP1_2		EXYNOS4_Q_TBL_COMP(1, 2)
+#define EXYNOS4_Q_TBL_COMP1_3		EXYNOS4_Q_TBL_COMP(1, 3)
+
+#define EXYNOS4_Q_TBL_COMP2_0		EXYNOS4_Q_TBL_COMP(2, 0)
+#define EXYNOS4_Q_TBL_COMP2_1		EXYNOS4_Q_TBL_COMP(2, 1)
+#define EXYNOS4_Q_TBL_COMP2_2		EXYNOS4_Q_TBL_COMP(2, 2)
+#define EXYNOS4_Q_TBL_COMP2_3		EXYNOS4_Q_TBL_COMP(2, 3)
+
+#define EXYNOS4_Q_TBL_COMP3_0		EXYNOS4_Q_TBL_COMP(3, 0)
+#define EXYNOS4_Q_TBL_COMP3_1		EXYNOS4_Q_TBL_COMP(3, 1)
+#define EXYNOS4_Q_TBL_COMP3_2		EXYNOS4_Q_TBL_COMP(3, 2)
+#define EXYNOS4_Q_TBL_COMP3_3		EXYNOS4_Q_TBL_COMP(3, 3)
+
+#define EXYNOS4_HUFF_TBL_COMP(c, n)	((n) << ((((c) - 1) << 1) + 6))
+
+#define EXYNOS4_HUFF_TBL_COMP1_AC_0_DC_0	\
+	EXYNOS4_HUFF_TBL_COMP(1, 0)
+#define EXYNOS4_HUFF_TBL_COMP1_AC_0_DC_1	\
+	EXYNOS4_HUFF_TBL_COMP(1, 1)
+#define EXYNOS4_HUFF_TBL_COMP1_AC_1_DC_0	\
+	EXYNOS4_HUFF_TBL_COMP(1, 2)
+#define EXYNOS4_HUFF_TBL_COMP1_AC_1_DC_1	\
+	EXYNOS4_HUFF_TBL_COMP(1, 3)
+
+#define EXYNOS4_HUFF_TBL_COMP2_AC_0_DC_0	\
+	EXYNOS4_HUFF_TBL_COMP(2, 0)
+#define EXYNOS4_HUFF_TBL_COMP2_AC_0_DC_1	\
+	EXYNOS4_HUFF_TBL_COMP(2, 1)
+#define EXYNOS4_HUFF_TBL_COMP2_AC_1_DC_0	\
+	EXYNOS4_HUFF_TBL_COMP(2, 2)
+#define EXYNOS4_HUFF_TBL_COMP2_AC_1_DC_1	\
+	EXYNOS4_HUFF_TBL_COMP(2, 3)
+
+#define EXYNOS4_HUFF_TBL_COMP3_AC_0_DC_0	\
+	EXYNOS4_HUFF_TBL_COMP(3, 0)
+#define EXYNOS4_HUFF_TBL_COMP3_AC_0_DC_1	\
+	EXYNOS4_HUFF_TBL_COMP(3, 1)
+#define EXYNOS4_HUFF_TBL_COMP3_AC_1_DC_0	\
+	EXYNOS4_HUFF_TBL_COMP(3, 2)
+#define EXYNOS4_HUFF_TBL_COMP3_AC_1_DC_1	\
+	EXYNOS4_HUFF_TBL_COMP(3, 3)
+
+#define EXYNOS4_NF_SHIFT			16
+#define EXYNOS4_NF_MASK				0xff
+#define EXYNOS4_NF(x)				\
+	(((x) << EXYNOS4_NF_SHIFT) & EXYNOS4_NF_MASK)
 
 /* JPEG quantizer table register */
 #define EXYNOS4_QTBL_CONTENT(n)	(0x100 + (n) * 0x40)
-- 
1.9.1

