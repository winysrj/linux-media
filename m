Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ig0-f178.google.com ([209.85.213.178]:56329 "EHLO
	mail-ig0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751728AbbBSCSa (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 18 Feb 2015 21:18:30 -0500
Received: by mail-ig0-f178.google.com with SMTP id hl2so6313446igb.5
        for <linux-media@vger.kernel.org>; Wed, 18 Feb 2015 18:18:30 -0800 (PST)
Message-ID: <54E547F4.6090309@chromium.org>
Date: Wed, 18 Feb 2015 18:18:28 -0800
From: Miguel Casas-Sanchez <mcasas@chromium.org>
MIME-Version: 1.0
To: linux-media@vger.kernel.org, hverkuil@xs4all.nl, pawel@osciak.com
Subject: [PATCH v2] Adding NV{12,21} and Y{U,V}12 pixel formats support.
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


This is the second attempt at creating a patch doing
that while respecting the pattern movements, crops,
and other artifacts that can be added to the generated
frames. 

Hope it addresses Hans' comments on the first patch.
It should create properly moving patterns, border,
square and noise. SAV/EAV are left out for the new
formats, but can be pulled in if deemed interesting/
necessary. New formats' descriptions are shorter.
Needless to say, previous formats should work 100% 
the same as before.

Text is, still, printed as Y only. I think the 
goal of the text is not pixel-value-based comparisons,
but human reading. Please let me know otherwise.

It needed quite some refactoring of the original
tpg_fillbuffer() function:
- the internal code generating the video buffer
  line-by-line are factored out into a function
  tpg_fill_oneline(). const added wherever it made
  sense.
- this new tpg_fill_oneline() is used by both
  new functions tpg_fillbuffer_packed() and
  tpg_fillbuffer_planar().
- tpg_fillbuffer_packed() does the non-planar
  formats' buffer composition, so it does, or should
  do, pretty much the same as vivid did before this
  patch.

Tested via both guvcview and qv4l2, checking formats,
patterns, pattern movements, box and frame checkboxes.

Hope I managed to get the patch correctly into the mail
i.e. no spurious wraparounds, no whitespaces etc :)

Signed-off-by: Miguel Casas-Sanchez <mcasas@chromium.org>
---
 drivers/media/platform/vivid/vivid-kthread-cap.c |   6 +-
 drivers/media/platform/vivid/vivid-tpg.c         | 481 ++++++++++++++++-------
 drivers/media/platform/vivid/vivid-tpg.h         |  24 +-
 drivers/media/platform/vivid/vivid-vid-common.c  |  28 ++
 4 files changed, 383 insertions(+), 156 deletions(-)

diff --git a/drivers/media/platform/vivid/vivid-kthread-cap.c b/drivers/media/platform/vivid/vivid-kthread-cap.c
index 39a67cf..93c6ca3 100644
--- a/drivers/media/platform/vivid/vivid-kthread-cap.c
+++ b/drivers/media/platform/vivid/vivid-kthread-cap.c
@@ -669,8 +669,7 @@ static void vivid_thread_vid_cap_tick(struct vivid_dev *dev, int dropped_bufs)
 	if (vid_cap_buf) {
 		/* Fill buffer */
 		vivid_fillbuff(dev, vid_cap_buf);
-		dprintk(dev, 1, "filled buffer %d\n",
-			vid_cap_buf->vb.v4l2_buf.index);
+		dprintk(dev, 1, "filled buffer %d\n", vid_cap_buf->vb.v4l2_buf.index);
 
 		/* Handle overlay */
 		if (dev->overlay_cap_owner && dev->fb_cap.base &&
@@ -679,8 +678,7 @@ static void vivid_thread_vid_cap_tick(struct vivid_dev *dev, int dropped_bufs)
 
 		vb2_buffer_done(&vid_cap_buf->vb, dev->dqbuf_error ?
 				VB2_BUF_STATE_ERROR : VB2_BUF_STATE_DONE);
-		dprintk(dev, 2, "vid_cap buffer %d done\n",
-				vid_cap_buf->vb.v4l2_buf.index);
+		dprintk(dev, 2, "vid_cap buffer %d done\n", vid_cap_buf->vb.v4l2_buf.index);
 	}
 
 	if (vbi_cap_buf) {
diff --git a/drivers/media/platform/vivid/vivid-tpg.c b/drivers/media/platform/vivid/vivid-tpg.c
index 34493f4..802ba2c 100644
--- a/drivers/media/platform/vivid/vivid-tpg.c
+++ b/drivers/media/platform/vivid/vivid-tpg.c
@@ -140,6 +140,10 @@ int tpg_alloc(struct tpg_data *tpg, unsigned max_w)
 		if (!tpg->random_line[plane])
 			return -ENOMEM;
 	}
+	tpg->scratchpad_line = vzalloc(max_w * 2);
+	if (!tpg->scratchpad_line)
+		return -ENOMEM;
+
 	return 0;
 }
 
@@ -193,6 +197,10 @@ bool tpg_s_fourcc(struct tpg_data *tpg, u32 fourcc)
 	case V4L2_PIX_FMT_UYVY:
 	case V4L2_PIX_FMT_YVYU:
 	case V4L2_PIX_FMT_VYUY:
+	case V4L2_PIX_FMT_NV12:
+	case V4L2_PIX_FMT_NV21:
+	case V4L2_PIX_FMT_YUV420:
+	case V4L2_PIX_FMT_YVU420:
 		tpg->is_yuv = true;
 		break;
 	default:
@@ -224,12 +232,32 @@ bool tpg_s_fourcc(struct tpg_data *tpg, u32 fourcc)
 	case V4L2_PIX_FMT_ABGR32:
 		tpg->twopixelsize[0] = 2 * 4;
 		break;
+	case V4L2_PIX_FMT_NV12:
+	case V4L2_PIX_FMT_NV21:
+	case V4L2_PIX_FMT_YUV420:
+	case V4L2_PIX_FMT_YVU420:
+		tpg->twopixelsize[0] = 3;
+		break;
 	case V4L2_PIX_FMT_NV16M:
 	case V4L2_PIX_FMT_NV61M:
 		tpg->twopixelsize[0] = 2;
 		tpg->twopixelsize[1] = 2;
 		break;
 	}
+
+	switch (fourcc) {
+	case V4L2_PIX_FMT_NV12:
+	case V4L2_PIX_FMT_NV21:
+	case V4L2_PIX_FMT_YUV420:
+	case V4L2_PIX_FMT_YVU420:
+		tpg->vertical_downsampling = 2;
+		tpg->horizontal_downsampling = 2;
+		break;
+	default:
+		tpg->vertical_downsampling = 0;
+		tpg->horizontal_downsampling = 0;
+	}
+
 	return true;
 }
 
@@ -271,6 +299,12 @@ void tpg_reset_source(struct tpg_data *tpg, unsigned width, unsigned height,
 	tpg->recalc_square_border = true;
 }
 
+/* Vertically downsampled pixel formats use YUYV as intermediate. */
+static unsigned tpg_get_packed_twopixsize(struct tpg_data *tpg, unsigned p)
+{
+	return tpg->vertical_downsampling ? 4 : tpg->twopixelsize[p];
+}
+
 static enum tpg_color tpg_get_textbg_color(struct tpg_data *tpg)
 {
 	switch (tpg->pattern) {
@@ -673,7 +707,15 @@ static void gen_twopix(struct tpg_data *tpg,
 		buf[0][offset] = r_y;
 		buf[1][offset] = odd ? g_u : b_v;
 		break;
-
+	/*
+	 * For these cases we compose a YUYV macropixel. They will be verticallly
+	 * downsampled later on.
+	 */
+	case V4L2_PIX_FMT_NV12:
+	case V4L2_PIX_FMT_NV21:
+	case V4L2_PIX_FMT_YUV420:
+	case V4L2_PIX_FMT_YVU420:
+		offset = odd * tpg_get_packed_twopixsize(tpg, 0) / 2;
 	case V4L2_PIX_FMT_YUYV:
 		buf[0][offset] = r_y;
 		buf[0][offset + 1] = odd ? b_v : g_u;
@@ -1000,9 +1042,8 @@ static void tpg_precalculate_line(struct tpg_data *tpg)
 			gen_twopix(tpg, pix, tpg->hflip ? color2 : color1, 0);
 			gen_twopix(tpg, pix, tpg->hflip ? color1 : color2, 1);
 			for (p = 0; p < tpg->planes; p++) {
-				unsigned twopixsize = tpg->twopixelsize[p];
+				const unsigned twopixsize = tpg_get_packed_twopixsize(tpg, p);
 				u8 *pos = tpg->lines[pat][p] + x * twopixsize / 2;
-
 				memcpy(pos, pix[p], twopixsize);
 			}
 		}
@@ -1013,7 +1054,7 @@ static void tpg_precalculate_line(struct tpg_data *tpg)
 		gen_twopix(tpg, pix, contrast, 0);
 		gen_twopix(tpg, pix, contrast, 1);
 		for (p = 0; p < tpg->planes; p++) {
-			unsigned twopixsize = tpg->twopixelsize[p];
+			const unsigned twopixsize = tpg_get_packed_twopixsize(tpg, p);
 			u8 *pos = tpg->contrast_line[p] + x * twopixsize / 2;
 
 			memcpy(pos, pix[p], twopixsize);
@@ -1025,9 +1066,8 @@ static void tpg_precalculate_line(struct tpg_data *tpg)
 		gen_twopix(tpg, pix, TPG_COLOR_100_BLACK, 0);
 		gen_twopix(tpg, pix, TPG_COLOR_100_BLACK, 1);
 		for (p = 0; p < tpg->planes; p++) {
-			unsigned twopixsize = tpg->twopixelsize[p];
+			const unsigned twopixsize = tpg_get_packed_twopixsize(tpg, p);
 			u8 *pos = tpg->black_line[p] + x * twopixsize / 2;
-
 			memcpy(pos, pix[p], twopixsize);
 		}
 	}
@@ -1037,7 +1077,7 @@ static void tpg_precalculate_line(struct tpg_data *tpg)
 		gen_twopix(tpg, pix, TPG_COLOR_RANDOM, 0);
 		gen_twopix(tpg, pix, TPG_COLOR_RANDOM, 1);
 		for (p = 0; p < tpg->planes; p++) {
-			unsigned twopixsize = tpg->twopixelsize[p];
+			const unsigned twopixsize = tpg_get_packed_twopixsize(tpg, p);
 			u8 *pos = tpg->random_line[p] + x * twopixsize / 2;
 
 			memcpy(pos, pix[p], twopixsize);
@@ -1083,8 +1123,8 @@ void tpg_gen_text(struct tpg_data *tpg, u8 *basep[TPG_MAX_PLANES][2],
 		div = 2;
 
 	for (p = 0; p < tpg->planes; p++) {
-		/* Print stream time */
-#define PRINTSTR(PIXTYPE) do {	\
+		/* Print text */
+#define PRINTSTR(PIXTYPE, dst_ptr, stride) do {	\
 	PIXTYPE fg;	\
 	PIXTYPE bg;	\
 	memcpy(&fg, tpg->textfg[p], sizeof(PIXTYPE));	\
@@ -1092,32 +1132,31 @@ void tpg_gen_text(struct tpg_data *tpg, u8 *basep[TPG_MAX_PLANES][2],
 	\
 	for (line = first; line < 16; line += step) {	\
 		int l = tpg->vflip ? 15 - line : line; \
-		PIXTYPE *pos = (PIXTYPE *)(basep[p][line & 1] + \
-			       ((y * step + l) / div) * tpg->bytesperline[p] + \
+		PIXTYPE *pos = (PIXTYPE *)((dst_ptr)[line & 1] +	\
+			       ((y * step + l) / div) * stride + \
 			       x * sizeof(PIXTYPE));	\
-		unsigned s;	\
 	\
+		unsigned s;	\
 		for (s = 0; s < len; s++) {	\
 			u8 chr = font8x16[text[s] * 16 + line];	\
-	\
 			if (tpg->hflip) { \
-				pos[7] = (chr & (0x01 << 7) ? fg : bg);	\
-				pos[6] = (chr & (0x01 << 6) ? fg : bg);	\
-				pos[5] = (chr & (0x01 << 5) ? fg : bg);	\
-				pos[4] = (chr & (0x01 << 4) ? fg : bg);	\
-				pos[3] = (chr & (0x01 << 3) ? fg : bg);	\
-				pos[2] = (chr & (0x01 << 2) ? fg : bg);	\
-				pos[1] = (chr & (0x01 << 1) ? fg : bg);	\
-				pos[0] = (chr & (0x01 << 0) ? fg : bg);	\
+				pos[7] = (chr & (0x01 << 7) ? fg : bg); \
+				pos[6] = (chr & (0x01 << 6) ? fg : bg); \
+				pos[5] = (chr & (0x01 << 5) ? fg : bg); \
+				pos[4] = (chr & (0x01 << 4) ? fg : bg); \
+				pos[3] = (chr & (0x01 << 3) ? fg : bg); \
+				pos[2] = (chr & (0x01 << 2) ? fg : bg); \
+				pos[1] = (chr & (0x01 << 1) ? fg : bg); \
+				pos[0] = (chr & (0x01 << 0) ? fg : bg); \
 			} else { \
-				pos[0] = (chr & (0x01 << 7) ? fg : bg);	\
-				pos[1] = (chr & (0x01 << 6) ? fg : bg);	\
-				pos[2] = (chr & (0x01 << 5) ? fg : bg);	\
-				pos[3] = (chr & (0x01 << 4) ? fg : bg);	\
-				pos[4] = (chr & (0x01 << 3) ? fg : bg);	\
-				pos[5] = (chr & (0x01 << 2) ? fg : bg);	\
-				pos[6] = (chr & (0x01 << 1) ? fg : bg);	\
-				pos[7] = (chr & (0x01 << 0) ? fg : bg);	\
+				pos[0] = (chr & (0x01 << 7) ? fg : bg); \
+				pos[1] = (chr & (0x01 << 6) ? fg : bg); \
+				pos[2] = (chr & (0x01 << 5) ? fg : bg); \
+				pos[3] = (chr & (0x01 << 4) ? fg : bg); \
+				pos[4] = (chr & (0x01 << 3) ? fg : bg); \
+				pos[5] = (chr & (0x01 << 2) ? fg : bg); \
+				pos[6] = (chr & (0x01 << 1) ? fg : bg); \
+				pos[7] = (chr & (0x01 << 0) ? fg : bg); \
 			} \
 	\
 			pos += tpg->hflip ? -8 : 8;	\
@@ -1125,15 +1164,25 @@ void tpg_gen_text(struct tpg_data *tpg, u8 *basep[TPG_MAX_PLANES][2],
 	}	\
 } while (0)
 
-		switch (tpg->twopixelsize[p]) {
-		case 2:
-			PRINTSTR(u8); break;
-		case 4:
-			PRINTSTR(u16); break;
-		case 6:
-			PRINTSTR(x24); break;
-		case 8:
-			PRINTSTR(u32); break;
+		if (!tpg->vertical_downsampling) {
+			switch (tpg->twopixelsize[p]) {
+			case 2:
+				PRINTSTR(u8, basep[p], tpg->bytesperline[p]); break;
+			case 4:
+				PRINTSTR(u16, basep[p], tpg->bytesperline[p]); break;
+			case 6:
+				PRINTSTR(x24, basep[p], tpg->bytesperline[p]); break;
+			case 8:
+				PRINTSTR(u32, basep[p], tpg->bytesperline[p]); break;
+			}
+		} else {
+			/* tpg->twopixelsize[p] is 3 for the defined formats so far. */
+			if (tpg->twopixelsize[p] != 3) {
+				printk(KERN_WARNING "Unsupported twopixelsize");
+				return;
+			}
+			PRINTSTR(u8, basep[p], tpg->compose.width);
+			/* TODO(mcasas): figure out what to do with Chroma planes. */
 		}
 	}
 }
@@ -1294,41 +1343,54 @@ void tpg_calc_text_basep(struct tpg_data *tpg,
 		basep[p][0] += tpg->buf_height * stride / 2;
 }
 
-void tpg_fillbuffer(struct tpg_data *tpg, v4l2_std_id std, unsigned p, u8 *vbuf)
+/* Wrapper around memcpy, signifying a blit == an actual pixel drawing. */
+static inline void tpg_blit(u8 * const buf, const unsigned buf_line,
+		const unsigned stride, const unsigned offset, const u8 *src,
+		const unsigned src_length) {
+	memcpy(buf + buf_line * stride + offset, src, src_length);
+}
+
+/*
+ * Fills a single |buf_line| of |vbuf| with whatever |tpg| describes. |p| refers
+ * to the plane. |src| is an in-out variable used as accumulator between calls
+ * for certain pattern tricks.
+ */
+static bool tpg_fill_oneline(struct tpg_data *tpg, const v4l2_std_id std,
+		const unsigned p, u8 *vbuf, const unsigned buf_line, unsigned *src)
 {
-	bool is_tv = std;
-	bool is_60hz = is_tv && (std & V4L2_STD_525_60);
+
+	const bool is_tv = std;
+	const bool is_60hz = is_tv && (std & V4L2_STD_525_60);
+	const unsigned mv_vert_old = tpg->mv_vert_count % tpg->src_height;
+	const unsigned mv_vert_new = (tpg->mv_vert_count + tpg->mv_vert_step) % tpg->src_height;
+
+	const int hmax = (tpg->compose.height * tpg->perc_fill) / 100;
+	const unsigned twopixsize = tpg_get_packed_twopixsize(tpg, p);
+	const unsigned img_width = tpg->compose.width * twopixsize / 2;
+
+	const unsigned stride = tpg->bytesperline[p];
+	const unsigned factor = V4L2_FIELD_HAS_T_OR_B(tpg->field) ? 2 : 1;
+
+	/* Coarse scaling with Bresenham */
+	const unsigned int_part = (tpg->crop.height / factor) / tpg->compose.height;
+	const unsigned fract_part = (tpg->crop.height / factor) % tpg->compose.height;
+
 	unsigned mv_hor_old = tpg->mv_hor_count % tpg->src_width;
 	unsigned mv_hor_new = (tpg->mv_hor_count + tpg->mv_hor_step) % tpg->src_width;
-	unsigned mv_vert_old = tpg->mv_vert_count % tpg->src_height;
-	unsigned mv_vert_new = (tpg->mv_vert_count + tpg->mv_vert_step) % tpg->src_height;
-	unsigned wss_width;
-	unsigned f;
-	int hmax = (tpg->compose.height * tpg->perc_fill) / 100;
-	int h;
-	unsigned twopixsize = tpg->twopixelsize[p];
-	unsigned img_width = tpg->compose.width * twopixsize / 2;
+	unsigned wss_width = tpg->crop.left < tpg->src_width / 2 ?
+			tpg->src_width / 2 - tpg->crop.left : 0;
 	unsigned line_offset;
 	unsigned left_pillar_width = 0;
 	unsigned right_pillar_start = img_width;
-	unsigned stride = tpg->bytesperline[p];
-	unsigned factor = V4L2_FIELD_HAS_T_OR_B(tpg->field) ? 2 : 1;
-	u8 *orig_vbuf = vbuf;
-
-	/* Coarse scaling with Bresenham */
-	unsigned int_part = (tpg->crop.height / factor) / tpg->compose.height;
-	unsigned fract_part = (tpg->crop.height / factor) % tpg->compose.height;
-	unsigned src_y = 0;
+	unsigned src_y = *src;
 	unsigned error = 0;
 
 	tpg_recalc(tpg);
 
 	mv_hor_old = (mv_hor_old * tpg->scaled_width / tpg->src_width) & ~1;
 	mv_hor_new = (mv_hor_new * tpg->scaled_width / tpg->src_width) & ~1;
-	wss_width = tpg->crop.left < tpg->src_width / 2 ?
-			tpg->src_width / 2 - tpg->crop.left : 0;
-	if (wss_width > tpg->crop.width)
-		wss_width = tpg->crop.width;
+
+	wss_width = min(wss_width, tpg->crop.width);
 	wss_width = wss_width * tpg->scaled_width / tpg->src_width;
 
 	vbuf += tpg->compose.left * twopixsize / 2;
@@ -1336,8 +1398,8 @@ void tpg_fillbuffer(struct tpg_data *tpg, v4l2_std_id std, unsigned p, u8 *vbuf)
 	line_offset = (line_offset & ~1) * twopixsize / 2;
 	if (tpg->crop.left < tpg->border.left) {
 		left_pillar_width = tpg->border.left - tpg->crop.left;
-		if (left_pillar_width > tpg->crop.width)
-			left_pillar_width = tpg->crop.width;
+		left_pillar_width = min(left_pillar_width, tpg->crop.width);
+
 		left_pillar_width = (left_pillar_width * tpg->scaled_width) / tpg->src_width;
 		left_pillar_width = (left_pillar_width & ~1) * twopixsize / 2;
 	}
@@ -1345,27 +1407,23 @@ void tpg_fillbuffer(struct tpg_data *tpg, v4l2_std_id std, unsigned p, u8 *vbuf)
 		right_pillar_start = tpg->border.left + tpg->border.width - tpg->crop.left;
 		right_pillar_start = (right_pillar_start * tpg->scaled_width) / tpg->src_width;
 		right_pillar_start = (right_pillar_start & ~1) * twopixsize / 2;
-		if (right_pillar_start > img_width)
-			right_pillar_start = img_width;
+		right_pillar_start = min(right_pillar_start, img_width);
 	}
 
-	f = tpg->field == (is_60hz ? V4L2_FIELD_TOP : V4L2_FIELD_BOTTOM);
-
-	for (h = 0; h < tpg->compose.height; h++) {
-		bool even;
-		bool fill_blank = false;
-		unsigned frame_line;
-		unsigned buf_line;
+	{
+		unsigned frame_line = tpg_calc_frameline(tpg, src_y, tpg->field);
+		const bool even = !(frame_line & 1);
 		unsigned pat_line_old;
 		unsigned pat_line_new;
+		bool fill_blank = false;
 		u8 *linestart_older;
 		u8 *linestart_newer;
 		u8 *linestart_top;
 		u8 *linestart_bottom;
+		const struct v4l2_rect *sq = &tpg->square;
+		const struct v4l2_rect *b = &tpg->border;
+		const struct v4l2_rect *c = &tpg->crop;
 
-		frame_line = tpg_calc_frameline(tpg, src_y, tpg->field);
-		even = !(frame_line & 1);
-		buf_line = tpg_calc_buffer_line(tpg, h, tpg->field);
 		src_y += int_part;
 		error += fract_part;
 		if (error >= tpg->compose.height) {
@@ -1373,11 +1431,11 @@ void tpg_fillbuffer(struct tpg_data *tpg, v4l2_std_id std, unsigned p, u8 *vbuf)
 			src_y++;
 		}
 
-		if (h >= hmax) {
+		if (buf_line >= hmax) {
 			if (hmax == tpg->compose.height)
-				continue;
+				return false;
 			if (!tpg->perc_fill_blank)
-				continue;
+				return false;
 			fill_blank = true;
 		}
 
@@ -1387,9 +1445,8 @@ void tpg_fillbuffer(struct tpg_data *tpg, v4l2_std_id std, unsigned p, u8 *vbuf)
 		if (fill_blank) {
 			linestart_older = tpg->contrast_line[p];
 			linestart_newer = tpg->contrast_line[p];
-		} else if (tpg->qual != TPG_QUAL_NOISE &&
-			   (frame_line < tpg->border.top ||
-			    frame_line >= tpg->border.top + tpg->border.height)) {
+		} else if (tpg->qual != TPG_QUAL_NOISE && (frame_line < tpg->border.top ||
+				frame_line >= tpg->border.top + tpg->border.height)) {
 			linestart_older = tpg->black_line[p];
 			linestart_newer = tpg->black_line[p];
 		} else if (tpg->pattern == TPG_PAT_NOISE || tpg->qual == TPG_QUAL_NOISE) {
@@ -1403,9 +1460,9 @@ void tpg_fillbuffer(struct tpg_data *tpg, v4l2_std_id std, unsigned p, u8 *vbuf)
 			pat_line_new = tpg_get_pat_line(tpg,
 						(frame_line + mv_vert_new) % tpg->src_height);
 			linestart_older = tpg->lines[pat_line_old][p] +
-					  mv_hor_old * twopixsize / 2;
+					mv_hor_old * twopixsize / 2;
 			linestart_newer = tpg->lines[pat_line_new][p] +
-					  mv_hor_new * twopixsize / 2;
+					mv_hor_new * twopixsize / 2;
 			linestart_older += line_offset;
 			linestart_newer += line_offset;
 		}
@@ -1423,25 +1480,25 @@ void tpg_fillbuffer(struct tpg_data *tpg, v4l2_std_id std, unsigned p, u8 *vbuf)
 		case V4L2_FIELD_SEQ_TB:
 		case V4L2_FIELD_SEQ_BT:
 			if (even)
-				memcpy(vbuf + buf_line * stride, linestart_top, img_width);
+				tpg_blit(vbuf, buf_line, stride, 0, linestart_top, img_width);
 			else
-				memcpy(vbuf + buf_line * stride, linestart_bottom, img_width);
+				tpg_blit(vbuf, buf_line, stride, 0, linestart_bottom, img_width);
 			break;
 		case V4L2_FIELD_INTERLACED_BT:
 			if (even)
-				memcpy(vbuf + buf_line * stride, linestart_bottom, img_width);
+				tpg_blit(vbuf, buf_line, stride, 0, linestart_bottom, img_width);
 			else
-				memcpy(vbuf + buf_line * stride, linestart_top, img_width);
+				tpg_blit(vbuf, buf_line, stride, 0, linestart_top, img_width);
 			break;
 		case V4L2_FIELD_TOP:
-			memcpy(vbuf + buf_line * stride, linestart_top, img_width);
+			tpg_blit(vbuf, buf_line, stride, 0, linestart_top, img_width);
 			break;
 		case V4L2_FIELD_BOTTOM:
-			memcpy(vbuf + buf_line * stride, linestart_bottom, img_width);
+			tpg_blit(vbuf, buf_line, stride, 0, linestart_bottom, img_width);
 			break;
 		case V4L2_FIELD_NONE:
 		default:
-			memcpy(vbuf + buf_line * stride, linestart_older, img_width);
+			tpg_blit(vbuf, buf_line, stride, 0, linestart_older, img_width);
 			break;
 		}
 
@@ -1452,28 +1509,11 @@ void tpg_fillbuffer(struct tpg_data *tpg, v4l2_std_id std, unsigned p, u8 *vbuf)
 			 */
 			u8 *wss = tpg->random_line[p] +
 				  twopixsize * prandom_u32_max(tpg->src_width / 2);
-
-			memcpy(vbuf + buf_line * stride, wss, wss_width * twopixsize / 2);
+			tpg_blit(vbuf, buf_line, stride, 0, wss, wss_width * twopixsize / 2);
 		}
-	}
-
-	vbuf = orig_vbuf;
-	vbuf += tpg->compose.left * twopixsize / 2;
-	src_y = 0;
-	error = 0;
-	for (h = 0; h < tpg->compose.height; h++) {
-		unsigned frame_line = tpg_calc_frameline(tpg, src_y, tpg->field);
-		unsigned buf_line = tpg_calc_buffer_line(tpg, h, tpg->field);
-		const struct v4l2_rect *sq = &tpg->square;
-		const struct v4l2_rect *b = &tpg->border;
-		const struct v4l2_rect *c = &tpg->crop;
 
-		src_y += int_part;
-		error += fract_part;
-		if (error >= tpg->compose.height) {
-			error -= tpg->compose.height;
-			src_y++;
-		}
+		/* Rewind the frame_line */
+		frame_line = tpg_calc_frameline(tpg, src_y, tpg->field);
 
 		if (tpg->show_border && frame_line >= b->top &&
 		    frame_line < b->top + b->height) {
@@ -1483,24 +1523,24 @@ void tpg_fillbuffer(struct tpg_data *tpg, v4l2_std_id std, unsigned p, u8 *vbuf)
 
 			if (frame_line == b->top || frame_line == b->top + 1 ||
 			    frame_line == bottom || frame_line == bottom - 1) {
-				memcpy(vbuf + buf_line * stride + left, tpg->contrast_line[p],
-						right - left);
+				tpg_blit(vbuf, buf_line, stride, left,
+					tpg->contrast_line[p], right - left);
 			} else {
-				if (b->left >= c->left &&
-				    b->left < c->left + c->width)
-					memcpy(vbuf + buf_line * stride + left,
+				if (b->left >= c->left && b->left < c->left + c->width)
+					tpg_blit(vbuf, buf_line, stride, left,
 						tpg->contrast_line[p], twopixsize);
 				if (b->left + b->width > c->left &&
 				    b->left + b->width <= c->left + c->width)
-					memcpy(vbuf + buf_line * stride + right - twopixsize,
+					tpg_blit(vbuf, buf_line, stride, right - twopixsize,
 						tpg->contrast_line[p], twopixsize);
 			}
 		}
 		if (tpg->qual != TPG_QUAL_NOISE && frame_line >= b->top &&
 		    frame_line < b->top + b->height) {
-			memcpy(vbuf + buf_line * stride, tpg->black_line[p], left_pillar_width);
-			memcpy(vbuf + buf_line * stride + right_pillar_start, tpg->black_line[p],
-			       img_width - right_pillar_start);
+			tpg_blit(vbuf, buf_line, stride, 0, tpg->black_line[p],
+				left_pillar_width);
+			tpg_blit(vbuf, buf_line, stride, right_pillar_start, tpg->black_line[p],
+				img_width - right_pillar_start);
 		}
 		if (tpg->show_square && frame_line >= sq->top &&
 		    frame_line < sq->top + sq->height &&
@@ -1520,35 +1560,187 @@ void tpg_fillbuffer(struct tpg_data *tpg, v4l2_std_id std, unsigned p, u8 *vbuf)
 			left = (left & ~1) * twopixsize / 2;
 			width = (width * tpg->scaled_width) / tpg->src_width;
 			width = (width & ~1) * twopixsize / 2;
-			memcpy(vbuf + buf_line * stride + left, tpg->contrast_line[p], width);
+			tpg_blit(vbuf, buf_line, stride, left, tpg->contrast_line[p], width);
 		}
-		if (tpg->insert_sav) {
-			unsigned offset = (tpg->compose.width / 6) * twopixsize;
-			u8 *p = vbuf + buf_line * stride + offset;
-			unsigned vact = 0, hact = 0;
-
-			p[0] = 0xff;
-			p[1] = 0;
-			p[2] = 0;
-			p[3] = 0x80 | (f << 6) | (vact << 5) | (hact << 4) |
-				((hact ^ vact) << 3) |
-				((hact ^ f) << 2) |
-				((f ^ vact) << 1) |
-				(hact ^ vact ^ f);
-		}
-		if (tpg->insert_eav) {
-			unsigned offset = (tpg->compose.width / 6) * 2 * twopixsize;
-			u8 *p = vbuf + buf_line * stride + offset;
-			unsigned vact = 0, hact = 1;
-
-			p[0] = 0xff;
-			p[1] = 0;
-			p[2] = 0;
-			p[3] = 0x80 | (f << 6) | (vact << 5) | (hact << 4) |
-				((hact ^ vact) << 3) |
-				((hact ^ f) << 2) |
-				((f ^ vact) << 1) |
+	}
+
+	*src = src_y;
+	return true;
+}
+
+/*
+ * Constructs a full video frame in vbuf, for any packed format.
+ */
+static void tpg_fillbuffer_packed(struct tpg_data *tpg, const v4l2_std_id std,
+		const unsigned p, u8 * const vbuf)
+{
+	int line = 0;
+	unsigned src_ = 0;
+
+	for (line = 0; line < tpg->compose.height; ++line) {
+		/* Draw one line at a time in the appropriate offset of vbuf. */
+		const unsigned buf_line = tpg_calc_buffer_line(tpg, line, tpg->field);
+
+		if (!tpg_fill_oneline(tpg, std, p, vbuf, buf_line, &src_))
+			continue;
+
+		/* SAV and EAV have slightly different treatment. */
+		{
+			const unsigned twopixsize = tpg->twopixelsize[p];
+			const unsigned buf_line = tpg_calc_buffer_line(tpg, line, tpg->field);
+			const unsigned stride = tpg->bytesperline[p];
+			const bool is_60hz = std && (std & V4L2_STD_525_60);
+			const unsigned f = (is_60hz ? V4L2_FIELD_TOP : V4L2_FIELD_BOTTOM);
+
+			if (tpg->insert_sav) {
+				unsigned offset = (tpg->compose.width / 6) * twopixsize;
+				u8 *p = vbuf + buf_line * stride + offset;
+				unsigned vact = 0, hact = 0;
+
+				p[0] = 0xff;
+				p[1] = 0;
+				p[2] = 0;
+				p[3] = 0x80 | (f << 6) | (vact << 5) | (hact << 4) |
+					((hact ^ vact) << 3) |
+					((hact ^ f) << 2) |
+					((f ^ vact) << 1) |
+					(hact ^ vact ^ f);
+			}
+			if (tpg->insert_eav) {
+				unsigned offset = (tpg->compose.width / 6) * 2 * twopixsize;
+				u8 *p = vbuf + buf_line * stride + offset;
+				unsigned vact = 0, hact = 1;
+
+				p[0] = 0xff;
+				p[1] = 0;
+				p[2] = 0;
+				p[3] = 0x80 | (f << 6) | (vact << 5) | (hact << 4) |
+					((hact ^ vact) << 3) |
+					((hact ^ f) << 2) |
+					((f ^ vact) << 1) |
 				(hact ^ vact ^ f);
+			}
+	  }
+	}
+}
+
+/*
+ * Fill a buffer with a downsampled planar format. Internally it generates each
+ * line internally as a packed YUYVe, that is then unpacked in the appropriate plane
+ * locations, which depend on the concrete format and its planarity and chroma
+ * packaging.
+ */
+static void tpg_fillbuffer_planar(struct tpg_data * const tpg,
+		const v4l2_std_id std, const unsigned p, u8 * const vbuf)
+{
+	u8 *y_ptr = vbuf;
+	u8 *const chromas_start = y_ptr + (tpg->compose.height * tpg->compose.width);
+	u8 *u_ptr;
+	u8 *v_ptr;
+	u8 u_ptr_step = 1;
+	u8 v_ptr_step = 1;
+	int y;
+
+	unsigned src_index = 0;
+
+	if (tpg->vertical_downsampling == 0)
+		return;
+	if (tpg->vertical_downsampling > 2) {
+		printk(KERN_WARNING "Vertical downsampling > 2 not implemented\n");
+		return;
+	}
+	if (tpg->horizontal_downsampling > 2) {
+		printk(KERN_WARNING "Horizontal downsampling > 2 not implemented\n");
+		return;
+	}
+	if (tpg->planes > 1) {
+		printk(KERN_WARNING "Mplane vertical downsampling not implemented\n");
+		return;
+	}
+
+	switch (tpg->fourcc) {
+	case V4L2_PIX_FMT_YUV420:
+		u_ptr = chromas_start;
+		v_ptr = chromas_start +
+			(tpg->compose.height * tpg->compose.width) /
+			(2 * tpg->horizontal_downsampling);
+		break;
+	case V4L2_PIX_FMT_YVU420:
+		v_ptr = chromas_start;
+		u_ptr = chromas_start +
+			(tpg->compose.height * tpg->compose.width) /
+			(2 * tpg->horizontal_downsampling);
+		break;
+	case V4L2_PIX_FMT_NV12:  /* NV{21,21} have interleaved chromas. */
+		u_ptr = chromas_start;
+		v_ptr = u_ptr + 1;
+		u_ptr_step = v_ptr_step = 2;
+		break;
+	case V4L2_PIX_FMT_NV21:
+		v_ptr = chromas_start;
+		u_ptr = v_ptr + 1;
+		u_ptr_step = v_ptr_step = 2;
+		break;
+	default:
+		printk(KERN_ERR "Unknown vertically downsampled format\n");
+		return;
+	}
+
+	/*
+	 * Per line: fetch the pattern line to use in packed YUYV in a scratchpad_line
+	 * then unpack it in the dst buffers. Only supported vertical downsampling
+	 * here is 2: average as-many-rows of Chroma components. Since we use YUYV as
+	 * starting point, horizontal downsampling of 2 is a natural match; 4 would
+	 * need hoops.
+	 */
+	for (y = 0; y < tpg->compose.height; y += tpg->vertical_downsampling) {
+		u8 *src_ptr = tpg->scratchpad_line;
+		unsigned buf_line;
+		unsigned downsampling_idx = 0;
+
+		for (; downsampling_idx < tpg->vertical_downsampling; ++downsampling_idx) {
+			int x;
+			/* Fetch the input line to use in packed YUYV, leave it in src_ptr. */
+			buf_line = tpg_calc_buffer_line(tpg, y + downsampling_idx, tpg->field);
+			tpg_fill_oneline(tpg, std, 0, src_ptr, 0, &src_index);
+
+			if ((downsampling_idx % tpg->vertical_downsampling) == 0) {
+				/* Unpack yuyv macropixel. _Set_ the Chroma planes. */
+				for (x = 0; x < 2 * tpg->compose.width; x += 4) {
+					*y_ptr++ = *src_ptr++;
+					*u_ptr = *src_ptr++ / tpg->vertical_downsampling;
+					u_ptr += u_ptr_step;
+					*y_ptr++ = *src_ptr++;
+					*v_ptr = *src_ptr++ / tpg->vertical_downsampling;
+					v_ptr += v_ptr_step;
+				}
+			} else {
+				/* Rewind U, V pointers. */
+				u_ptr -= (u_ptr_step * tpg->compose.width /
+						tpg->horizontal_downsampling);
+				v_ptr -= (v_ptr_step * tpg->compose.width /
+						tpg->horizontal_downsampling);
+				/* Unpack yuyv macropixel. _Accumulate_ the Chroma planes. */
+				for (x = 0; x < 2 * tpg->compose.width; x += 4) {
+					*y_ptr++ = *src_ptr++;
+					*u_ptr += *src_ptr++ / tpg->vertical_downsampling;
+					u_ptr += u_ptr_step;
+					*y_ptr++ = *src_ptr++;
+					*v_ptr += *src_ptr++ / tpg->vertical_downsampling;
+					v_ptr += v_ptr_step;
+				}
+			}
 		}
 	}
 }
+
+void tpg_fillbuffer(struct tpg_data *tpg, const v4l2_std_id std,
+	const unsigned p, u8 *vbuf)
+{
+	/* It so happens that vertical_downsampling is a proxy for packed/planar. */
+	if (tpg->vertical_downsampling == 0)
+		tpg_fillbuffer_packed(tpg, std, p, vbuf);
+	else
+		tpg_fillbuffer_planar(tpg, std, p, vbuf);
+}
+
diff --git a/drivers/media/platform/vivid/vivid-tpg.h b/drivers/media/platform/vivid/vivid-tpg.h
index bd8b1c7..0b6d959 100644
--- a/drivers/media/platform/vivid/vivid-tpg.h
+++ b/drivers/media/platform/vivid/vivid-tpg.h
@@ -141,6 +141,15 @@ struct tpg_data {
 	/* size in bytes for two pixels in each plane */
 	unsigned			twopixelsize[TPG_MAX_PLANES];
 	unsigned			bytesperline[TPG_MAX_PLANES];
+	/*
+	 * Vertical and horizontal downsample factors. Only applies to YUV formats,
+	 * concretely Chroma components (not the Luma), and implies that the format
+	 * is planar (2 or 3 planes). Only even numbers are allowed. Typical values
+	 * include 0 for no downsampling and 2 (like in 4:2:0 formats, e.g. YUV420).
+	 */
+	unsigned      vertical_downsampling;
+	unsigned      horizontal_downsampling;
+	u8				*scratchpad_line;
 
 	/* Configuration */
 	enum tpg_pattern		pattern;
@@ -165,7 +174,10 @@ struct tpg_data {
 	bool				recalc_lines;
 	bool				recalc_square_border;
 
-	/* Used to store TPG_MAX_PAT_LINES lines, each with up to two planes */
+	/*
+	 *  Used to store TPG_MAX_PAT_LINES lines, each with up to TPG_MAX_PLANES
+	 *  planes
+	 */
 	unsigned			max_line_width;
 	u8				*lines[TPG_MAX_PAT_LINES][TPG_MAX_PLANES];
 	u8				*random_line[TPG_MAX_PLANES];
@@ -176,18 +188,18 @@ struct tpg_data {
 void tpg_init(struct tpg_data *tpg, unsigned w, unsigned h);
 int tpg_alloc(struct tpg_data *tpg, unsigned max_w);
 void tpg_free(struct tpg_data *tpg);
+bool tpg_s_fourcc(struct tpg_data *tpg, u32 fourcc);
+void tpg_s_crop_compose(struct tpg_data *tpg, const struct v4l2_rect *crop,
+		const struct v4l2_rect *compose);
 void tpg_reset_source(struct tpg_data *tpg, unsigned width, unsigned height,
 		       u32 field);
-
 void tpg_set_font(const u8 *f);
 void tpg_gen_text(struct tpg_data *tpg,
 		u8 *basep[TPG_MAX_PLANES][2], int y, int x, char *text);
 void tpg_calc_text_basep(struct tpg_data *tpg,
 		u8 *basep[TPG_MAX_PLANES][2], unsigned p, u8 *vbuf);
-void tpg_fillbuffer(struct tpg_data *tpg, v4l2_std_id std, unsigned p, u8 *vbuf);
-bool tpg_s_fourcc(struct tpg_data *tpg, u32 fourcc);
-void tpg_s_crop_compose(struct tpg_data *tpg, const struct v4l2_rect *crop,
-		const struct v4l2_rect *compose);
+void tpg_fillbuffer(struct tpg_data *tpg, const v4l2_std_id std,
+		const unsigned p, u8 *vbuf);
 
 static inline void tpg_s_pattern(struct tpg_data *tpg, enum tpg_pattern pattern)
 {
diff --git a/drivers/media/platform/vivid/vivid-vid-common.c b/drivers/media/platform/vivid/vivid-vid-common.c
index 6bef1e6..a610e14 100644
--- a/drivers/media/platform/vivid/vivid-vid-common.c
+++ b/drivers/media/platform/vivid/vivid-vid-common.c
@@ -73,7 +73,34 @@ struct vivid_fmt vivid_formats[] = {
 		.planes   = 1,
 	},
 	{
+		.name     = "YUV 4:2:0 biplanar.",
+		.fourcc   = V4L2_PIX_FMT_NV12,
+		.depth    = 12,
+		.is_yuv   = true,
+		.planes   = 1,
+	},
+	{
+		.name     = "YVU 4:2:0 biplanar.",
+		.fourcc   = V4L2_PIX_FMT_NV21,
+		.depth    = 12,
+		.is_yuv   = true,
+		.planes   = 1,
+	},
+	{
+		.name     = "YUV 4:2:0 triplanar",
+		.fourcc   = V4L2_PIX_FMT_YUV420,
+		.depth    = 12,
+		.is_yuv   = true,
+		.planes   = 1,
+	},
+	{
+		.name     = "YVU 4:2:0 triplanar",
+		.fourcc   = V4L2_PIX_FMT_YVU420,
+		.depth    = 12,
+		.is_yuv   = true,
+		.planes   = 1,
+	},
+	{
 		.name     = "RGB565 (LE)",
 		.fourcc   = V4L2_PIX_FMT_RGB565, /* gggbbbbb rrrrrggg */
 		.depth    = 16,
-- 
2.2.0.rc0.207.ga3a616c

