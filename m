Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-vc0-f173.google.com ([209.85.220.173]:50730 "EHLO
	mail-vc0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753484AbbBKSjS (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 11 Feb 2015 13:39:18 -0500
Received: by mail-vc0-f173.google.com with SMTP id hy4so1872051vcb.4
        for <linux-media@vger.kernel.org>; Wed, 11 Feb 2015 10:39:17 -0800 (PST)
Received: from mail-vc0-f175.google.com (mail-vc0-f175.google.com. [209.85.220.175])
        by mx.google.com with ESMTPSA id i11sm199022vdt.17.2015.02.11.10.39.16
        for <linux-media@vger.kernel.org>
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 11 Feb 2015 10:39:16 -0800 (PST)
Received: by mail-vc0-f175.google.com with SMTP id hq12so1852281vcb.6
        for <linux-media@vger.kernel.org>; Wed, 11 Feb 2015 10:39:15 -0800 (PST)
MIME-Version: 1.0
Date: Wed, 11 Feb 2015 10:39:15 -0800
Message-ID: <CAPUS084EM0QMVapYxt8pDOn7=M+JK0BQMwufXsH94vD+bMDMgw@mail.gmail.com>
Subject: [PATCH] media: vivid test device: Add NV{12,21} and Y{U,V}12 pixel format.
From: Miguel Casas-Sanchez <mcasas@chromium.org>
To: linux-media@vger.kernel.org, hverkuil@xs4all.nl, pawel@osciak.com,
	Miguel Casas-Sanchez <mcasas@chromium.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add support for vertical + horizontal subsampled formats to vivid and use it to
generate YU12, YV12, NV12, NV21 as defined in [1,2]. These formats are tightly
packed N planar, because they provide chroma(s) as a separate array, but they
are not mplanar yet, as discussed in the list.

The modus operandi is to let tpg_fillbuffer() create a YUYV packed format per
pattern line as usual and apply downsampling if needed immediately afterwards,
in a new function called tpg_apply_downsampling(). This one will unpack as
needed, and average the chroma samples (note that luma samples are never
downsampled). (Some provisions for horizontal downsampling are made, so it can
be followed up with e.g. YUV410 etc formats, please understand in this context).
Writing the text information on top of the produced pattern also needs a bit of
a retouch.

[1] http://linuxtv.org/downloads/v4l-dvb-apis/re30.html
[2] http://linuxtv.org/downloads/v4l-dvb-apis/re24.html

Signed-off-by: Miguel Casas-Sanchez <mcasas@chromium.org>
---
 drivers/media/platform/vivid/vivid-kthread-cap.c |   6 +-
 drivers/media/platform/vivid/vivid-tpg.c         | 232 +++++++++++++++++++----
 drivers/media/platform/vivid/vivid-tpg.h         |  15 +-
 drivers/media/platform/vivid/vivid-vid-common.c  |  28 +++
 4 files changed, 238 insertions(+), 43 deletions(-)

diff --git a/drivers/media/platform/vivid/vivid-kthread-cap.c
b/drivers/media/platform/vivid/vivid-kthread-cap.c
index 39a67cf..93c6ca3 100644
--- a/drivers/media/platform/vivid/vivid-kthread-cap.c
+++ b/drivers/media/platform/vivid/vivid-kthread-cap.c
@@ -669,8 +669,7 @@ static void vivid_thread_vid_cap_tick(struct
vivid_dev *dev, int dropped_bufs)
        if (vid_cap_buf) {
                /* Fill buffer */
                vivid_fillbuff(dev, vid_cap_buf);
-               dprintk(dev, 1, "filled buffer %d\n",
-                       vid_cap_buf->vb.v4l2_buf.index);
+               dprintk(dev, 1, "filled buffer %d\n",
vid_cap_buf->vb.v4l2_buf.index);

                /* Handle overlay */
                if (dev->overlay_cap_owner && dev->fb_cap.base &&
@@ -679,8 +678,7 @@ static void vivid_thread_vid_cap_tick(struct
vivid_dev *dev, int dropped_bufs)

                vb2_buffer_done(&vid_cap_buf->vb, dev->dqbuf_error ?
                                VB2_BUF_STATE_ERROR : VB2_BUF_STATE_DONE);
-               dprintk(dev, 2, "vid_cap buffer %d done\n",
-                               vid_cap_buf->vb.v4l2_buf.index);
+               dprintk(dev, 2, "vid_cap buffer %d done\n",
vid_cap_buf->vb.v4l2_buf.index);
        }

        if (vbi_cap_buf) {
diff --git a/drivers/media/platform/vivid/vivid-tpg.c
b/drivers/media/platform/vivid/vivid-tpg.c
index 34493f4..d72e19a 100644
--- a/drivers/media/platform/vivid/vivid-tpg.c
+++ b/drivers/media/platform/vivid/vivid-tpg.c
@@ -193,6 +193,10 @@ bool tpg_s_fourcc(struct tpg_data *tpg, u32 fourcc)
        case V4L2_PIX_FMT_UYVY:
        case V4L2_PIX_FMT_YVYU:
        case V4L2_PIX_FMT_VYUY:
+       case V4L2_PIX_FMT_NV12:
+       case V4L2_PIX_FMT_NV21:
+       case V4L2_PIX_FMT_YUV420:
+       case V4L2_PIX_FMT_YVU420:
                tpg->is_yuv = true;
                break;
        default:
@@ -224,12 +228,32 @@ bool tpg_s_fourcc(struct tpg_data *tpg, u32 fourcc)
        case V4L2_PIX_FMT_ABGR32:
                tpg->twopixelsize[0] = 2 * 4;
                break;
+       case V4L2_PIX_FMT_NV12:
+       case V4L2_PIX_FMT_NV21:
+       case V4L2_PIX_FMT_YUV420:
+       case V4L2_PIX_FMT_YVU420:
+               tpg->twopixelsize[0] = 3;
+               break;
        case V4L2_PIX_FMT_NV16M:
        case V4L2_PIX_FMT_NV61M:
                tpg->twopixelsize[0] = 2;
                tpg->twopixelsize[1] = 2;
                break;
        }
+
+       switch (fourcc) {
+       case V4L2_PIX_FMT_NV12:
+       case V4L2_PIX_FMT_NV21:
+       case V4L2_PIX_FMT_YUV420:
+       case V4L2_PIX_FMT_YVU420:
+               tpg->vertical_downsampling = 2;
+               tpg->horizontal_downsampling = 2;
+               break;
+       default:
+               tpg->vertical_downsampling = 0;
+               tpg->horizontal_downsampling = 0;
+       }
+
        return true;
 }

@@ -271,6 +295,12 @@ void tpg_reset_source(struct tpg_data *tpg,
unsigned width, unsigned height,
        tpg->recalc_square_border = true;
 }

+/* Vertically downsampled pixel formats use YUYV as intermediate. */
+static unsigned tpg_get_packed_twopixsize(struct tpg_data *tpg, unsigned p)
+{
+       return tpg->vertical_downsampling ? 4 : tpg->twopixelsize[p];
+}
+
 static enum tpg_color tpg_get_textbg_color(struct tpg_data *tpg)
 {
        switch (tpg->pattern) {
@@ -673,7 +703,15 @@ static void gen_twopix(struct tpg_data *tpg,
                buf[0][offset] = r_y;
                buf[1][offset] = odd ? g_u : b_v;
                break;
-
+       /*
+        * For these cases we compose a YUYV macropixel. They will be
verticallly
+        * downsampled later on.
+        */
+       case V4L2_PIX_FMT_NV12:
+       case V4L2_PIX_FMT_NV21:
+       case V4L2_PIX_FMT_YUV420:
+       case V4L2_PIX_FMT_YVU420:
+               offset = odd * tpg_get_packed_twopixsize(tpg, 0) / 2;
        case V4L2_PIX_FMT_YUYV:
                buf[0][offset] = r_y;
                buf[0][offset + 1] = odd ? b_v : g_u;
@@ -1000,9 +1038,8 @@ static void tpg_precalculate_line(struct tpg_data *tpg)
                        gen_twopix(tpg, pix, tpg->hflip ? color2 : color1, 0);
                        gen_twopix(tpg, pix, tpg->hflip ? color1 : color2, 1);
                        for (p = 0; p < tpg->planes; p++) {
-                               unsigned twopixsize = tpg->twopixelsize[p];
+                               const unsigned twopixsize =
tpg_get_packed_twopixsize(tpg, p);
                                u8 *pos = tpg->lines[pat][p] + x *
twopixsize / 2;
-
                                memcpy(pos, pix[p], twopixsize);
                        }
                }
@@ -1013,7 +1050,7 @@ static void tpg_precalculate_line(struct tpg_data *tpg)
                gen_twopix(tpg, pix, contrast, 0);
                gen_twopix(tpg, pix, contrast, 1);
                for (p = 0; p < tpg->planes; p++) {
-                       unsigned twopixsize = tpg->twopixelsize[p];
+                       const unsigned twopixsize =
tpg_get_packed_twopixsize(tpg, p);
                        u8 *pos = tpg->contrast_line[p] + x * twopixsize / 2;

                        memcpy(pos, pix[p], twopixsize);
@@ -1025,9 +1062,8 @@ static void tpg_precalculate_line(struct tpg_data *tpg)
                gen_twopix(tpg, pix, TPG_COLOR_100_BLACK, 0);
                gen_twopix(tpg, pix, TPG_COLOR_100_BLACK, 1);
                for (p = 0; p < tpg->planes; p++) {
-                       unsigned twopixsize = tpg->twopixelsize[p];
+                       const unsigned twopixsize =
tpg_get_packed_twopixsize(tpg, p);
                        u8 *pos = tpg->black_line[p] + x * twopixsize / 2;
-
                        memcpy(pos, pix[p], twopixsize);
                }
        }
@@ -1037,7 +1073,7 @@ static void tpg_precalculate_line(struct tpg_data *tpg)
                gen_twopix(tpg, pix, TPG_COLOR_RANDOM, 0);
                gen_twopix(tpg, pix, TPG_COLOR_RANDOM, 1);
                for (p = 0; p < tpg->planes; p++) {
-                       unsigned twopixsize = tpg->twopixelsize[p];
+                       const unsigned twopixsize =
tpg_get_packed_twopixsize(tpg, p);
                        u8 *pos = tpg->random_line[p] + x * twopixsize / 2;

                        memcpy(pos, pix[p], twopixsize);
@@ -1083,8 +1119,8 @@ void tpg_gen_text(struct tpg_data *tpg, u8
*basep[TPG_MAX_PLANES][2],
                div = 2;

        for (p = 0; p < tpg->planes; p++) {
-               /* Print stream time */
-#define PRINTSTR(PIXTYPE) do { \
+               /* Print text */
+#define PRINTSTR(PIXTYPE, dst_ptr, stride) do {        \
        PIXTYPE fg;     \
        PIXTYPE bg;     \
        memcpy(&fg, tpg->textfg[p], sizeof(PIXTYPE));   \
@@ -1092,32 +1128,31 @@ void tpg_gen_text(struct tpg_data *tpg, u8
*basep[TPG_MAX_PLANES][2],
        \
        for (line = first; line < 16; line += step) {   \
                int l = tpg->vflip ? 15 - line : line; \
-               PIXTYPE *pos = (PIXTYPE *)(basep[p][line & 1] + \
-                              ((y * step + l) / div) * tpg->bytesperline[p] + \
+               PIXTYPE *pos = (PIXTYPE *)((dst_ptr)[line & 1] +        \
+                              ((y * step + l) / div) * stride + \
                               x * sizeof(PIXTYPE));    \
-               unsigned s;     \
        \
+               unsigned s;     \
                for (s = 0; s < len; s++) {     \
                        u8 chr = font8x16[text[s] * 16 + line]; \
-       \
                        if (tpg->hflip) { \
-                               pos[7] = (chr & (0x01 << 7) ? fg : bg); \
-                               pos[6] = (chr & (0x01 << 6) ? fg : bg); \
-                               pos[5] = (chr & (0x01 << 5) ? fg : bg); \
-                               pos[4] = (chr & (0x01 << 4) ? fg : bg); \
-                               pos[3] = (chr & (0x01 << 3) ? fg : bg); \
-                               pos[2] = (chr & (0x01 << 2) ? fg : bg); \
-                               pos[1] = (chr & (0x01 << 1) ? fg : bg); \
-                               pos[0] = (chr & (0x01 << 0) ? fg : bg); \
+                               pos[7] = (chr & (0x01 << 7) ? fg : bg); \
+                               pos[6] = (chr & (0x01 << 6) ? fg : bg); \
+                               pos[5] = (chr & (0x01 << 5) ? fg : bg); \
+                               pos[4] = (chr & (0x01 << 4) ? fg : bg); \
+                               pos[3] = (chr & (0x01 << 3) ? fg : bg); \
+                               pos[2] = (chr & (0x01 << 2) ? fg : bg); \
+                               pos[1] = (chr & (0x01 << 1) ? fg : bg); \
+                               pos[0] = (chr & (0x01 << 0) ? fg : bg); \
                        } else { \
-                               pos[0] = (chr & (0x01 << 7) ? fg : bg); \
-                               pos[1] = (chr & (0x01 << 6) ? fg : bg); \
-                               pos[2] = (chr & (0x01 << 5) ? fg : bg); \
-                               pos[3] = (chr & (0x01 << 4) ? fg : bg); \
-                               pos[4] = (chr & (0x01 << 3) ? fg : bg); \
-                               pos[5] = (chr & (0x01 << 2) ? fg : bg); \
-                               pos[6] = (chr & (0x01 << 1) ? fg : bg); \
-                               pos[7] = (chr & (0x01 << 0) ? fg : bg); \
+                               pos[0] = (chr & (0x01 << 7) ? fg : bg); \
+                               pos[1] = (chr & (0x01 << 6) ? fg : bg); \
+                               pos[2] = (chr & (0x01 << 5) ? fg : bg); \
+                               pos[3] = (chr & (0x01 << 4) ? fg : bg); \
+                               pos[4] = (chr & (0x01 << 3) ? fg : bg); \
+                               pos[5] = (chr & (0x01 << 2) ? fg : bg); \
+                               pos[6] = (chr & (0x01 << 1) ? fg : bg); \
+                               pos[7] = (chr & (0x01 << 0) ? fg : bg); \
                        } \
        \
                        pos += tpg->hflip ? -8 : 8;     \
@@ -1125,15 +1160,25 @@ void tpg_gen_text(struct tpg_data *tpg, u8
*basep[TPG_MAX_PLANES][2],
        }       \
 } while (0)

-               switch (tpg->twopixelsize[p]) {
-               case 2:
-                       PRINTSTR(u8); break;
-               case 4:
-                       PRINTSTR(u16); break;
-               case 6:
-                       PRINTSTR(x24); break;
-               case 8:
-                       PRINTSTR(u32); break;
+               if (!tpg->vertical_downsampling) {
+                       switch (tpg->twopixelsize[p]) {
+                       case 2:
+                               PRINTSTR(u8, basep[p],
tpg->bytesperline[p]); break;
+                       case 4:
+                               PRINTSTR(u16, basep[p],
tpg->bytesperline[p]); break;
+                       case 6:
+                               PRINTSTR(x24, basep[p],
tpg->bytesperline[p]); break;
+                       case 8:
+                               PRINTSTR(u32, basep[p],
tpg->bytesperline[p]); break;
+                       }
+               } else {
+                       /* tpg->twopixelsize[p] is 3 for the defined
formats so far. */
+                       if (tpg->twopixelsize[p] != 3) {
+                               printk(KERN_WARNING "Unsupported twopixelsize");
+                               return;
+                       }
+                       PRINTSTR(u8, basep[p], tpg->compose.width);
+                       /* TODO(mcasas): Do the same for Chroma
planes, not urgently needed. */
                }
        }
 }
@@ -1551,4 +1596,115 @@ void tpg_fillbuffer(struct tpg_data *tpg,
v4l2_std_id std, unsigned p, u8 *vbuf)
                                (hact ^ vact ^ f);
                }
        }
+
+  tpg_apply_downsampling(tpg, std, p, vbuf);
+}
+
+/*
+ * Apply downsampling(s). Assumes that pattern lines have been generated in
+ * packed YUYV and written in tpg->lines: we unpack them in the appropriate
+ * plane locations, which depend on the concrete format and its planarity
+ * and chroma packaging.
+ */
+void tpg_apply_downsampling(struct tpg_data *tpg, v4l2_std_id std, unsigned p,
+               u8 *vbuf)
+{
+       u8 *y_ptr = vbuf;
+       u8 *chromas_start = y_ptr + (tpg->compose.height * tpg->compose.width);
+       u8 *u_ptr;
+       u8 *v_ptr;
+       u8 u_ptr_step = 1;
+       u8 v_ptr_step = 1;
+       int y;
+
+       if (tpg->vertical_downsampling == 0)
+               return;
+       if (tpg->vertical_downsampling > 2) {
+               printk(KERN_WARNING "Vertical downsampling by > 2 not
implemented\n");
+               return;
+       }
+       if (tpg->horizontal_downsampling > 2) {
+               printk(KERN_WARNING "Horizontal downsampling by > 2
not implemented\n");
+               return;
+       }
+       if (tpg->planes > 1) {
+               printk(KERN_WARNING "Mplane vertically downsampling
not implemented\n");
+               return;
+       }
+
+       switch (tpg->fourcc) {
+       case V4L2_PIX_FMT_YUV420:
+               u_ptr = chromas_start;
+               v_ptr = chromas_start +
+                       (tpg->compose.height * tpg->compose.width) /
+                       (2 * tpg->horizontal_downsampling);
+               break;
+       case V4L2_PIX_FMT_YVU420:
+               v_ptr = chromas_start;
+               u_ptr = chromas_start +
+                       (tpg->compose.height * tpg->compose.width) /
+                       (2 * tpg->horizontal_downsampling);
+               break;
+       case V4L2_PIX_FMT_NV12:  /* N{21,21} are special: interleaved
chromas. */
+               u_ptr = chromas_start;
+               v_ptr = u_ptr + 1;
+               u_ptr_step = v_ptr_step = 2;
+               break;
+       case V4L2_PIX_FMT_NV21:
+               v_ptr = chromas_start;
+               u_ptr = v_ptr + 1;
+               u_ptr_step = v_ptr_step = 2;
+               break;
+       default:
+               printk(KERN_ERR "Unknown vertically downsampled format\n");
+               return;
+       }
+
+       /*
+        * Per line: fetch the pattern line to use in packed YUYV,
then unpack in
+        * the dst buffers. Vertical downsampling can only be 2 or 4
here: average
+        * as-many-rows of Chroma components. Since we use YUYV as
starting point,
+        * horizontal downsampling of 2 is a natural match; 4 would need hoops.
+        */
+       for (y = 0; y < tpg->compose.height; y += 2) {
+               u8 *src_ptr;
+               unsigned buf_line;
+               unsigned downsampling_index = 0;
+
+               for (; downsampling_index < tpg->vertical_downsampling;
+                       ++downsampling_index) {
+                       int x;
+
+                       /* Fetch the pattern line to use in packed YUYV. */
+                       buf_line = tpg_calc_buffer_line(tpg, y +
downsampling_index,
+                               tpg->field);
+                       src_ptr = tpg->lines[tpg_get_pat_line(tpg,
buf_line)][0];
+                       if ((downsampling_index %
tpg->vertical_downsampling) == 0) {
+                               /* Unpack yuyv macropixel. _Set_ the
Chroma planes. */
+                               for (x = 0; x < 2 *
tpg->compose.width; x += 4) {
+                                       *y_ptr++ = *src_ptr++;
+                                       *u_ptr = *src_ptr++ /
tpg->vertical_downsampling;
+                                       u_ptr += u_ptr_step;
+                                       *y_ptr++ = *src_ptr++;
+                                       *v_ptr = *src_ptr++ /
tpg->vertical_downsampling;
+                                       v_ptr += v_ptr_step;
+                               }
+                       } else {
+                               /* Rewind U, V pointers. */
+                               u_ptr -= (u_ptr_step * tpg->compose.width /
+                                               tpg->horizontal_downsampling);
+                               v_ptr -= (v_ptr_step * tpg->compose.width /
+                                               tpg->horizontal_downsampling);
+                               /* Unpack yuyv macropixel.
_Accumulate_ the Chroma planes. */
+                               for (x = 0; x < 2 *
tpg->compose.width; x += 4) {
+                                       *y_ptr++ = *src_ptr++;
+                                       *u_ptr += *src_ptr++ /
tpg->vertical_downsampling;
+                                       u_ptr += u_ptr_step;
+                                       *y_ptr++ = *src_ptr++;
+                                       *v_ptr += *src_ptr++ /
tpg->vertical_downsampling;
+                                       v_ptr += v_ptr_step;
+                               }
+                       }
+               }
+       }
 }
diff --git a/drivers/media/platform/vivid/vivid-tpg.h
b/drivers/media/platform/vivid/vivid-tpg.h
index bd8b1c7..ac374f1 100644
--- a/drivers/media/platform/vivid/vivid-tpg.h
+++ b/drivers/media/platform/vivid/vivid-tpg.h
@@ -141,6 +141,14 @@ struct tpg_data {
        /* size in bytes for two pixels in each plane */
        unsigned                        twopixelsize[TPG_MAX_PLANES];
        unsigned                        bytesperline[TPG_MAX_PLANES];
+       /*
+        * Vertical and horizontal downsample factors. Only applies to
YUV formats,
+        * concretely Chroma components (not the Luma), and implies
that the format
+        * is planar (2 or 3 planes). Only even numbers are allowed.
Typical values
+        * include 0 for no downsampling and 2 (like in 4:2:0 formats,
e.g. YUV420).
+        */
+       unsigned      vertical_downsampling;
+       unsigned      horizontal_downsampling;

        /* Configuration */
        enum tpg_pattern                pattern;
@@ -165,7 +173,10 @@ struct tpg_data {
        bool                            recalc_lines;
        bool                            recalc_square_border;

-       /* Used to store TPG_MAX_PAT_LINES lines, each with up to two planes */
+       /*
+        *  Used to store TPG_MAX_PAT_LINES lines, each with up to
TPG_MAX_PLANES
+        *  planes
+        */
        unsigned                        max_line_width;
        u8
*lines[TPG_MAX_PAT_LINES][TPG_MAX_PLANES];
        u8                              *random_line[TPG_MAX_PLANES];
@@ -185,6 +196,8 @@ void tpg_gen_text(struct tpg_data *tpg,
 void tpg_calc_text_basep(struct tpg_data *tpg,
                u8 *basep[TPG_MAX_PLANES][2], unsigned p, u8 *vbuf);
 void tpg_fillbuffer(struct tpg_data *tpg, v4l2_std_id std, unsigned
p, u8 *vbuf);
+void tpg_apply_downsampling(struct tpg_data *tpg, v4l2_std_id std, unsigned p,
+               u8 *vbuf);
 bool tpg_s_fourcc(struct tpg_data *tpg, u32 fourcc);
 void tpg_s_crop_compose(struct tpg_data *tpg, const struct v4l2_rect *crop,
                const struct v4l2_rect *compose);
diff --git a/drivers/media/platform/vivid/vivid-vid-common.c
b/drivers/media/platform/vivid/vivid-vid-common.c
index 6bef1e6..99e0d22 100644
--- a/drivers/media/platform/vivid/vivid-vid-common.c
+++ b/drivers/media/platform/vivid/vivid-vid-common.c
@@ -73,6 +73,34 @@ struct vivid_fmt vivid_formats[] = {
                .planes   = 1,
        },
        {
+               .name     = "YUV 4:2:0, planar, 1 Chroma plane",
+               .fourcc   = V4L2_PIX_FMT_NV12,
+               .depth    = 12,
+               .is_yuv   = true,
+               .planes   = 1,
+       },
+       {
+               .name     = "YVU 4:2:0, planar, 1 Chroma plane",
+               .fourcc   = V4L2_PIX_FMT_NV21,
+               .depth    = 12,
+               .is_yuv   = true,
+               .planes   = 1,
+       },
+       {
+               .name     = "YUV 4:2:0, planar, 2 Chroma planes",
+               .fourcc   = V4L2_PIX_FMT_YUV420,
+               .depth    = 12,
+               .is_yuv   = true,
+               .planes   = 1,
+       },
+       {
+               .name     = "YVU 4:2:0, planar, 2 Chroma planes",
+               .fourcc   = V4L2_PIX_FMT_YVU420,
+               .depth    = 12,
+               .is_yuv   = true,
+               .planes   = 1,
+       },
+       {
                .name     = "RGB565 (LE)",
                .fourcc   = V4L2_PIX_FMT_RGB565, /* gggbbbbb rrrrrggg */
                .depth    = 16,

--
2.2.0.rc0.207.ga3a616c
