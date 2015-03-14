Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud3.xs4all.net ([194.109.24.26]:52325 "EHLO
	lb2-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751379AbbCNMiH (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 14 Mar 2015 08:38:07 -0400
Received: from [127.0.0.1] (localhost [127.0.0.1])
	by tschai.lan (Postfix) with ESMTPSA id 2FB272A0081
	for <linux-media@vger.kernel.org>; Sat, 14 Mar 2015 13:37:56 +0100 (CET)
Message-ID: <55042BA4.1060105@xs4all.nl>
Date: Sat, 14 Mar 2015 13:37:56 +0100
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH 40/40] vivid: add support for 8-bit Bayer formats
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add support for: PIX_FMT_SBGGR8, SGBRG8, SGRBG8 and SRGGB8.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/platform/vivid/vivid-tpg.c        | 57 +++++++++++++++++++++++--
 drivers/media/platform/vivid/vivid-tpg.h        | 17 +++++---
 drivers/media/platform/vivid/vivid-vid-common.c | 32 ++++++++++++++
 3 files changed, 97 insertions(+), 9 deletions(-)

diff --git a/drivers/media/platform/vivid/vivid-tpg.c b/drivers/media/platform/vivid/vivid-tpg.c
index 246c3e7..142b3c0 100644
--- a/drivers/media/platform/vivid/vivid-tpg.c
+++ b/drivers/media/platform/vivid/vivid-tpg.c
@@ -181,6 +181,7 @@ bool tpg_s_fourcc(struct tpg_data *tpg, u32 fourcc)
 	tpg->planes = 1;
 	tpg->buffers = 1;
 	tpg->recalc_colors = true;
+	tpg->interleaved = false;
 	tpg->vdownsampling[0] = 1;
 	tpg->hdownsampling[0] = 1;
 	tpg->hmask[0] = ~0;
@@ -188,6 +189,15 @@ bool tpg_s_fourcc(struct tpg_data *tpg, u32 fourcc)
 	tpg->hmask[2] = ~0;
 
 	switch (fourcc) {
+	case V4L2_PIX_FMT_SBGGR8:
+	case V4L2_PIX_FMT_SGBRG8:
+	case V4L2_PIX_FMT_SGRBG8:
+	case V4L2_PIX_FMT_SRGGB8:
+		tpg->interleaved = true;
+		tpg->vdownsampling[1] = 1;
+		tpg->hdownsampling[1] = 1;
+		tpg->planes = 2;
+		/* fall through */
 	case V4L2_PIX_FMT_RGB332:
 	case V4L2_PIX_FMT_RGB565:
 	case V4L2_PIX_FMT_RGB565X:
@@ -326,13 +336,14 @@ bool tpg_s_fourcc(struct tpg_data *tpg, u32 fourcc)
 	case V4L2_PIX_FMT_NV21:
 	case V4L2_PIX_FMT_NV12M:
 	case V4L2_PIX_FMT_NV21M:
-		tpg->twopixelsize[0] = 2;
-		tpg->twopixelsize[1] = 2;
-		break;
 	case V4L2_PIX_FMT_NV16:
 	case V4L2_PIX_FMT_NV61:
 	case V4L2_PIX_FMT_NV16M:
 	case V4L2_PIX_FMT_NV61M:
+	case V4L2_PIX_FMT_SBGGR8:
+	case V4L2_PIX_FMT_SGBRG8:
+	case V4L2_PIX_FMT_SGRBG8:
+	case V4L2_PIX_FMT_SRGGB8:
 		tpg->twopixelsize[0] = 2;
 		tpg->twopixelsize[1] = 2;
 		break;
@@ -1011,6 +1022,35 @@ static void gen_twopix(struct tpg_data *tpg,
 		buf[0][offset + 2] = r_y;
 		buf[0][offset + 3] = alpha;
 		break;
+	case V4L2_PIX_FMT_SBGGR8:
+		buf[0][offset] = odd ? g_u : b_v;
+		buf[1][offset] = odd ? r_y : g_u;
+		break;
+	case V4L2_PIX_FMT_SGBRG8:
+		buf[0][offset] = odd ? b_v : g_u;
+		buf[1][offset] = odd ? g_u : r_y;
+		break;
+	case V4L2_PIX_FMT_SGRBG8:
+		buf[0][offset] = odd ? r_y : g_u;
+		buf[1][offset] = odd ? g_u : b_v;
+		break;
+	case V4L2_PIX_FMT_SRGGB8:
+		buf[0][offset] = odd ? g_u : r_y;
+		buf[1][offset] = odd ? b_v : g_u;
+		break;
+	}
+}
+
+unsigned tpg_g_interleaved_plane(const struct tpg_data *tpg, unsigned buf_line)
+{
+	switch (tpg->fourcc) {
+	case V4L2_PIX_FMT_SBGGR8:
+	case V4L2_PIX_FMT_SGBRG8:
+	case V4L2_PIX_FMT_SGRBG8:
+	case V4L2_PIX_FMT_SRGGB8:
+		return buf_line & 1;
+	default:
+		return 0;
 	}
 }
 
@@ -1610,6 +1650,8 @@ void tpg_calc_text_basep(struct tpg_data *tpg,
 		basep[p][1] += h * stride / 2;
 	else if (tpg->field == V4L2_FIELD_SEQ_BT)
 		basep[p][0] += h * stride / 2;
+	if (p == 0 && tpg->interleaved)
+		tpg_calc_text_basep(tpg, basep, 1, vbuf);
 }
 
 static int tpg_pattern_avg(const struct tpg_data *tpg,
@@ -1986,6 +2028,13 @@ void tpg_fill_plane_buffer(struct tpg_data *tpg, v4l2_std_id std,
 			src_y++;
 		}
 
+		/*
+		 * For line-interleaved formats determine the 'plane'
+		 * based on the buffer line.
+		 */
+		if (tpg_g_interleaved(tpg))
+			p = tpg_g_interleaved_plane(tpg, buf_line);
+
 		if (tpg->vdownsampling[p] > 1) {
 			/*
 			 * When doing vertical downsampling the field setting
@@ -2032,7 +2081,7 @@ void tpg_fillbuffer(struct tpg_data *tpg, v4l2_std_id std, unsigned p, u8 *vbuf)
 		return;
 	}
 
-	for (i = 0; i < tpg->planes; i++) {
+	for (i = 0; i < tpg_g_planes(tpg); i++) {
 		tpg_fill_plane_buffer(tpg, std, i, vbuf + offset);
 		offset += tpg_calc_plane_size(tpg, i);
 	}
diff --git a/drivers/media/platform/vivid/vivid-tpg.h b/drivers/media/platform/vivid/vivid-tpg.h
index 82ce9bf..a50cd2e 100644
--- a/drivers/media/platform/vivid/vivid-tpg.h
+++ b/drivers/media/platform/vivid/vivid-tpg.h
@@ -140,6 +140,7 @@ struct tpg_data {
 	unsigned			real_rgb_range;
 	unsigned			buffers;
 	unsigned			planes;
+	bool				interleaved;
 	u8				vdownsampling[TPG_MAX_PLANES];
 	u8				hdownsampling[TPG_MAX_PLANES];
 	/*
@@ -197,6 +198,7 @@ void tpg_gen_text(const struct tpg_data *tpg,
 		u8 *basep[TPG_MAX_PLANES][2], int y, int x, char *text);
 void tpg_calc_text_basep(struct tpg_data *tpg,
 		u8 *basep[TPG_MAX_PLANES][2], unsigned p, u8 *vbuf);
+unsigned tpg_g_interleaved_plane(const struct tpg_data *tpg, unsigned buf_line);
 void tpg_fill_plane_buffer(struct tpg_data *tpg, v4l2_std_id std,
 			   unsigned p, u8 *vbuf);
 void tpg_fillbuffer(struct tpg_data *tpg, v4l2_std_id std,
@@ -346,7 +348,12 @@ static inline unsigned tpg_g_buffers(const struct tpg_data *tpg)
 
 static inline unsigned tpg_g_planes(const struct tpg_data *tpg)
 {
-	return tpg->planes;
+	return tpg->interleaved ? 1 : tpg->planes;
+}
+
+static inline bool tpg_g_interleaved(const struct tpg_data *tpg)
+{
+	return tpg->interleaved;
 }
 
 static inline unsigned tpg_g_twopixelsize(const struct tpg_data *tpg, unsigned plane)
@@ -386,7 +393,7 @@ static inline void tpg_s_bytesperline(struct tpg_data *tpg, unsigned plane, unsi
 		return;
 	}
 
-	for (p = 0; p < tpg->planes; p++) {
+	for (p = 0; p < tpg_g_planes(tpg); p++) {
 		unsigned plane_w = bpl * tpg->twopixelsize[p] / tpg->twopixelsize[0];
 
 		tpg->bytesperline[p] = plane_w / tpg->hdownsampling[p];
@@ -401,7 +408,7 @@ static inline unsigned tpg_g_line_width(const struct tpg_data *tpg, unsigned pla
 
 	if (tpg->buffers > 1)
 		return tpg_g_bytesperline(tpg, plane);
-	for (p = 0; p < tpg->planes; p++) {
+	for (p = 0; p < tpg_g_planes(tpg); p++) {
 		unsigned plane_w = tpg_g_bytesperline(tpg, p);
 
 		w += plane_w / tpg->vdownsampling[p];
@@ -417,7 +424,7 @@ static inline unsigned tpg_calc_line_width(const struct tpg_data *tpg,
 
 	if (tpg->buffers > 1)
 		return bpl;
-	for (p = 0; p < tpg->planes; p++) {
+	for (p = 0; p < tpg_g_planes(tpg); p++) {
 		unsigned plane_w = bpl * tpg->twopixelsize[p] / tpg->twopixelsize[0];
 
 		plane_w /= tpg->hdownsampling[p];
@@ -428,7 +435,7 @@ static inline unsigned tpg_calc_line_width(const struct tpg_data *tpg,
 
 static inline unsigned tpg_calc_plane_size(const struct tpg_data *tpg, unsigned plane)
 {
-	if (plane >= tpg->planes)
+	if (plane >= tpg_g_planes(tpg))
 		return 0;
 
 	return tpg_g_bytesperline(tpg, plane) * tpg->buf_height /
diff --git a/drivers/media/platform/vivid/vivid-vid-common.c b/drivers/media/platform/vivid/vivid-vid-common.c
index 8f0910d..283b2e8 100644
--- a/drivers/media/platform/vivid/vivid-vid-common.c
+++ b/drivers/media/platform/vivid/vivid-vid-common.c
@@ -384,6 +384,38 @@ struct vivid_fmt vivid_formats[] = {
 		.alpha_mask = 0xff000000,
 	},
 	{
+		.name     = "Bayer BG/GR",
+		.fourcc   = V4L2_PIX_FMT_SBGGR8, /* Bayer BG/GR */
+		.vdownsampling = { 1 },
+		.bit_depth = { 8 },
+		.planes   = 1,
+		.buffers = 1,
+	},
+	{
+		.name     = "Bayer GB/RG",
+		.fourcc   = V4L2_PIX_FMT_SGBRG8, /* Bayer GB/RG */
+		.vdownsampling = { 1 },
+		.bit_depth = { 8 },
+		.planes   = 1,
+		.buffers = 1,
+	},
+	{
+		.name     = "Bayer GR/BG",
+		.fourcc   = V4L2_PIX_FMT_SGRBG8, /* Bayer GR/BG */
+		.vdownsampling = { 1 },
+		.bit_depth = { 8 },
+		.planes   = 1,
+		.buffers = 1,
+	},
+	{
+		.name     = "Bayer RG/GB",
+		.fourcc   = V4L2_PIX_FMT_SRGGB8, /* Bayer RG/GB */
+		.vdownsampling = { 1 },
+		.bit_depth = { 8 },
+		.planes   = 1,
+		.buffers = 1,
+	},
+	{
 		.name     = "4:2:2, biplanar, YUV",
 		.fourcc   = V4L2_PIX_FMT_NV16M,
 		.vdownsampling = { 1, 1 },
-- 
2.1.4

