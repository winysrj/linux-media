Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud2.xs4all.net ([194.109.24.21]:50628 "EHLO
	lb1-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753062AbaKQORV (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 17 Nov 2014 09:17:21 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Subject: [RFCv1 PATCH 6/8] vivid-tpg: improve colorspace support
Date: Mon, 17 Nov 2014 15:16:52 +0100
Message-Id: <1416233814-40579-7-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1416233814-40579-1-git-send-email-hverkuil@xs4all.nl>
References: <1416233814-40579-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Add support for the new AdobeRGB and BT.2020 colorspaces. Also support
explicit Y'CbCr and quantization settings.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/platform/vivid/vivid-tpg.c | 327 +++++++++++++++++++++----------
 drivers/media/platform/vivid/vivid-tpg.h |  38 ++++
 2 files changed, 258 insertions(+), 107 deletions(-)

diff --git a/drivers/media/platform/vivid/vivid-tpg.c b/drivers/media/platform/vivid/vivid-tpg.c
index cbcd625..fe61b6c 100644
--- a/drivers/media/platform/vivid/vivid-tpg.c
+++ b/drivers/media/platform/vivid/vivid-tpg.c
@@ -296,127 +296,193 @@ static enum tpg_color tpg_get_textfg_color(struct tpg_data *tpg)
 	}
 }
 
-static u16 color_to_y(struct tpg_data *tpg, int r, int g, int b)
+static inline int rec709_to_linear(int v)
 {
-	switch (tpg->colorspace) {
-	case V4L2_COLORSPACE_SMPTE170M:
-	case V4L2_COLORSPACE_470_SYSTEM_M:
-	case V4L2_COLORSPACE_470_SYSTEM_BG:
-		return ((16829 * r + 33039 * g + 6416 * b + 16 * 32768) >> 16) + (16 << 4);
-	case V4L2_COLORSPACE_SMPTE240M:
-		return ((11932 * r + 39455 * g + 4897 * b + 16 * 32768) >> 16) + (16 << 4);
-	case V4L2_COLORSPACE_REC709:
-	case V4L2_COLORSPACE_SRGB:
-	default:
-		return ((11966 * r + 40254 * g + 4064 * b + 16 * 32768) >> 16) + (16 << 4);
-	}
+	v = clamp(v, 0, 0xff0);
+	return tpg_rec709_to_linear[v];
 }
 
-static u16 color_to_cb(struct tpg_data *tpg, int r, int g, int b)
+static inline int linear_to_rec709(int v)
 {
-	switch (tpg->colorspace) {
-	case V4L2_COLORSPACE_SMPTE170M:
-	case V4L2_COLORSPACE_470_SYSTEM_M:
-	case V4L2_COLORSPACE_470_SYSTEM_BG:
-		return ((-9714 * r - 19070 * g + 28784 * b + 16 * 32768) >> 16) + (128 << 4);
-	case V4L2_COLORSPACE_SMPTE240M:
-		return ((-6684 * r - 22100 * g + 28784 * b + 16 * 32768) >> 16) + (128 << 4);
-	case V4L2_COLORSPACE_REC709:
-	case V4L2_COLORSPACE_SRGB:
-	default:
-		return ((-6596 * r - 22189 * g + 28784 * b + 16 * 32768) >> 16) + (128 << 4);
-	}
+	v = clamp(v, 0, 0xff0);
+	return tpg_linear_to_rec709[v];
 }
 
-static u16 color_to_cr(struct tpg_data *tpg, int r, int g, int b)
+static void rgb2ycbcr(const int m[3][3], int r, int g, int b,
+			int y_offset, int *y, int *cb, int *cr)
 {
-	switch (tpg->colorspace) {
-	case V4L2_COLORSPACE_SMPTE170M:
-	case V4L2_COLORSPACE_470_SYSTEM_M:
-	case V4L2_COLORSPACE_470_SYSTEM_BG:
-		return ((28784 * r - 24103 * g - 4681 * b + 16 * 32768) >> 16) + (128 << 4);
-	case V4L2_COLORSPACE_SMPTE240M:
-		return ((28784 * r - 25606 * g - 3178 * b + 16 * 32768) >> 16) + (128 << 4);
-	case V4L2_COLORSPACE_REC709:
-	case V4L2_COLORSPACE_SRGB:
-	default:
-		return ((28784 * r - 26145 * g - 2639 * b + 16 * 32768) >> 16) + (128 << 4);
-	}
+	*y  = ((m[0][0] * r + m[0][1] * g + m[0][2] * b) >> 16) + (y_offset << 4);
+	*cb = ((m[1][0] * r + m[1][1] * g + m[1][2] * b) >> 16) + (128 << 4);
+	*cr = ((m[2][0] * r + m[2][1] * g + m[2][2] * b) >> 16) + (128 << 4);
 }
 
-static u16 ycbcr_to_r(struct tpg_data *tpg, int y, int cb, int cr)
+static void color_to_ycbcr(struct tpg_data *tpg, int r, int g, int b,
+			   int *y, int *cb, int *cr)
 {
-	int r;
+#define COEFF(v, r) ((int)(0.5 + (v) * (r) * 256.0))
 
-	y -= 16 << 4;
-	cb -= 128 << 4;
-	cr -= 128 << 4;
-	switch (tpg->colorspace) {
-	case V4L2_COLORSPACE_SMPTE170M:
-	case V4L2_COLORSPACE_470_SYSTEM_M:
-	case V4L2_COLORSPACE_470_SYSTEM_BG:
-		r = 4769 * y + 6537 * cr;
+	static const int bt601[3][3] = {
+		{ COEFF(0.299, 219),  COEFF(0.587, 219),  COEFF(0.114, 219)  },
+		{ COEFF(-0.169, 224), COEFF(-0.331, 224), COEFF(0.5, 224)    },
+		{ COEFF(0.5, 224),    COEFF(-0.419, 224), COEFF(-0.081, 224) },
+	};
+	static const int bt601_full[3][3] = {
+		{ COEFF(0.299, 255),  COEFF(0.587, 255),  COEFF(0.114, 255)  },
+		{ COEFF(-0.169, 255), COEFF(-0.331, 255), COEFF(0.5, 255)    },
+		{ COEFF(0.5, 255),    COEFF(-0.419, 255), COEFF(-0.081, 255) },
+	};
+	static const int rec709[3][3] = {
+		{ COEFF(0.2126, 219),  COEFF(0.7152, 219),  COEFF(0.0722, 219)  },
+		{ COEFF(-0.1146, 224), COEFF(-0.3854, 224), COEFF(0.5, 224)     },
+		{ COEFF(0.5, 224),     COEFF(-0.4542, 224), COEFF(-0.0458, 224) },
+	};
+	static const int rec709_full[3][3] = {
+		{ COEFF(0.2126, 255),  COEFF(0.7152, 255),  COEFF(0.0722, 255)  },
+		{ COEFF(-0.1146, 255), COEFF(-0.3854, 255), COEFF(0.5, 255)     },
+		{ COEFF(0.5, 255),     COEFF(-0.4542, 255), COEFF(-0.0458, 255) },
+	};
+	static const int smpte240m[3][3] = {
+		{ COEFF(0.212, 219),  COEFF(0.701, 219),  COEFF(0.087, 219)  },
+		{ COEFF(-0.116, 224), COEFF(-0.384, 224), COEFF(0.5, 224)    },
+		{ COEFF(0.5, 224),    COEFF(-0.445, 224), COEFF(-0.055, 224) },
+	};
+	static const int bt2020[3][3] = {
+		{ COEFF(0.2726, 219),  COEFF(0.6780, 219),  COEFF(0.0593, 219)  },
+		{ COEFF(-0.1396, 224), COEFF(-0.3604, 224), COEFF(0.5, 224)     },
+		{ COEFF(0.5, 224),     COEFF(-0.4629, 224), COEFF(-0.0405, 224) },
+	};
+	bool full = tpg->real_quantization == V4L2_QUANTIZATION_FULL_RANGE;
+	int lin_y, yc;
+
+	switch (tpg->real_ycbcr_enc) {
+	case V4L2_YCBCR_ENC_601:
+	case V4L2_YCBCR_ENC_XV601:
+	case V4L2_YCBCR_ENC_SYCC:
+		rgb2ycbcr(full ? bt601_full : bt601, r, g, b, 16, y, cb, cr);
+		break;
+	case V4L2_YCBCR_ENC_BT2020NC:
+		rgb2ycbcr(bt2020, r, g, b, 16, y, cb, cr);
 		break;
-	case V4L2_COLORSPACE_SMPTE240M:
-		r = 4769 * y + 7376 * cr;
+	case V4L2_YCBCR_ENC_BT2020C:
+		lin_y = (COEFF(0.2627, 255) * rec709_to_linear(r) +
+			 COEFF(0.6780, 255) * rec709_to_linear(g) +
+			 COEFF(0.0593, 255) * rec709_to_linear(b)) >> 16;
+		yc = linear_to_rec709(lin_y);
+		*y = (yc * 219) / 255 + (16 << 4);
+		if (b <= yc)
+			*cb = (((b - yc) * COEFF(1.0 / 1.9404, 224)) >> 16) + (128 << 4);
+		else
+			*cb = (((b - yc) * COEFF(1.0 / 1.5816, 224)) >> 16) + (128 << 4);
+		if (r <= yc)
+			*cr = (((r - yc) * COEFF(1.0 / 1.7184, 224)) >> 16) + (128 << 4);
+		else
+			*cr = (((r - yc) * COEFF(1.0 / 0.9936, 224)) >> 16) + (128 << 4);
 		break;
-	case V4L2_COLORSPACE_REC709:
-	case V4L2_COLORSPACE_SRGB:
+	case V4L2_YCBCR_ENC_SMPTE240M:
+		rgb2ycbcr(smpte240m, r, g, b, 16, y, cb, cr);
+		break;
+	case V4L2_YCBCR_ENC_709:
+	case V4L2_YCBCR_ENC_XV709:
 	default:
-		r = 4769 * y + 7343 * cr;
+		rgb2ycbcr(full ? rec709_full : rec709, r, g, b, 0, y, cb, cr);
 		break;
 	}
-	return clamp(r >> 12, 0, 0xff0);
 }
 
-static u16 ycbcr_to_g(struct tpg_data *tpg, int y, int cb, int cr)
+static void ycbcr2rgb(const int m[3][3], int y, int cb, int cr,
+			int y_offset, int *r, int *g, int *b)
 {
-	int g;
-
-	y -= 16 << 4;
+	y -= y_offset << 4;
 	cb -= 128 << 4;
 	cr -= 128 << 4;
-	switch (tpg->colorspace) {
-	case V4L2_COLORSPACE_SMPTE170M:
-	case V4L2_COLORSPACE_470_SYSTEM_M:
-	case V4L2_COLORSPACE_470_SYSTEM_BG:
-		g = 4769 * y - 1605 * cb - 3330 * cr;
-		break;
-	case V4L2_COLORSPACE_SMPTE240M:
-		g = 4769 * y - 1055 * cb - 2341 * cr;
-		break;
-	case V4L2_COLORSPACE_REC709:
-	case V4L2_COLORSPACE_SRGB:
-	default:
-		g = 4769 * y - 873 * cb - 2183 * cr;
-		break;
-	}
-	return clamp(g >> 12, 0, 0xff0);
+	*r = m[0][0] * y + m[0][1] * cb + m[0][2] * cr;
+	*g = m[1][0] * y + m[1][1] * cb + m[1][2] * cr;
+	*b = m[2][0] * y + m[2][1] * cb + m[2][2] * cr;
+	*r = clamp(*r >> 12, 0, 0xff0);
+	*g = clamp(*g >> 12, 0, 0xff0);
+	*b = clamp(*b >> 12, 0, 0xff0);
 }
 
-static u16 ycbcr_to_b(struct tpg_data *tpg, int y, int cb, int cr)
+static void ycbcr_to_color(struct tpg_data *tpg, int y, int cb, int cr,
+			   int *r, int *g, int *b)
 {
-	int b;
+#undef COEFF
+#define COEFF(v, r) ((int)(0.5 + (v) * ((255.0 * 255.0 * 16.0) / (r))))
+	static const int bt601[3][3] = {
+		{ COEFF(1, 219), COEFF(0, 224),       COEFF(1.4020, 224)  },
+		{ COEFF(1, 219), COEFF(-0.3441, 224), COEFF(-0.7141, 224) },
+		{ COEFF(1, 219), COEFF(1.7720, 224),  COEFF(0, 224)       },
+	};
+	static const int bt601_full[3][3] = {
+		{ COEFF(1, 255), COEFF(0, 255),       COEFF(1.4020, 255)  },
+		{ COEFF(1, 255), COEFF(-0.3441, 255), COEFF(-0.7141, 255) },
+		{ COEFF(1, 255), COEFF(1.7720, 255),  COEFF(0, 255)       },
+	};
+	static const int rec709[3][3] = {
+		{ COEFF(1, 219), COEFF(0, 224),       COEFF(1.5748, 224)  },
+		{ COEFF(1, 219), COEFF(-0.1873, 224), COEFF(-0.4681, 224) },
+		{ COEFF(1, 219), COEFF(1.8556, 224),  COEFF(0, 224)       },
+	};
+	static const int rec709_full[3][3] = {
+		{ COEFF(1, 255), COEFF(0, 255),       COEFF(1.5748, 255)  },
+		{ COEFF(1, 255), COEFF(-0.1873, 255), COEFF(-0.4681, 255) },
+		{ COEFF(1, 255), COEFF(1.8556, 255),  COEFF(0, 255)       },
+	};
+	static const int smpte240m[3][3] = {
+		{ COEFF(1, 219), COEFF(0, 224),       COEFF(1.5756, 224)  },
+		{ COEFF(1, 219), COEFF(-0.2253, 224), COEFF(-0.4767, 224) },
+		{ COEFF(1, 219), COEFF(1.8270, 224),  COEFF(0, 224)       },
+	};
+	static const int bt2020[3][3] = {
+		{ COEFF(1, 219), COEFF(0, 224),       COEFF(1.4746, 224)  },
+		{ COEFF(1, 219), COEFF(-0.1646, 224), COEFF(-0.5714, 224) },
+		{ COEFF(1, 219), COEFF(1.8814, 224),  COEFF(0, 224)       },
+	};
+	bool full = tpg->real_quantization == V4L2_QUANTIZATION_FULL_RANGE;
+	int lin_r, lin_g, lin_b, lin_y;
+
+	switch (tpg->real_ycbcr_enc) {
+	case V4L2_YCBCR_ENC_601:
+	case V4L2_YCBCR_ENC_XV601:
+	case V4L2_YCBCR_ENC_SYCC:
+		ycbcr2rgb(full ? bt601_full : bt601, y, cb, cr, 16, r, g, b);
+		break;
+	case V4L2_YCBCR_ENC_BT2020NC:
+		ycbcr2rgb(bt2020, y, cb, cr, 16, r, g, b);
+		break;
+	case V4L2_YCBCR_ENC_BT2020C:
+		y -= 16 << 4;
+		cb -= 128 << 4;
+		cr -= 128 << 4;
 
-	y -= 16 << 4;
-	cb -= 128 << 4;
-	cr -= 128 << 4;
-	switch (tpg->colorspace) {
-	case V4L2_COLORSPACE_SMPTE170M:
-	case V4L2_COLORSPACE_470_SYSTEM_M:
-	case V4L2_COLORSPACE_470_SYSTEM_BG:
-		b = 4769 * y + 7343 * cb;
+		if (cb <= 0)
+			*b = COEFF(1.0, 219) * y + COEFF(1.9404, 224) * cb;
+		else
+			*b = COEFF(1.0, 219) * y + COEFF(1.5816, 224) * cb;
+		*b = *b >> 12;
+		if (cr <= 0)
+			*r = COEFF(1.0, 219) * y + COEFF(1.7184, 224) * cr;
+		else
+			*r = COEFF(1.0, 219) * y + COEFF(0.9936, 224) * cr;
+		*r = *r >> 12;
+		lin_r = rec709_to_linear(*r);
+		lin_b = rec709_to_linear(*b);
+		lin_y = rec709_to_linear((y * 255) / 219);
+
+		lin_g = COEFF(1.0 / 0.6780, 255) * lin_y -
+			COEFF(0.2627 / 0.6780, 255) * lin_r -
+			COEFF(0.0593 / 0.6780, 255) * lin_b;
+		*g = linear_to_rec709(lin_g >> 12);
 		break;
-	case V4L2_COLORSPACE_SMPTE240M:
-		b = 4769 * y + 8552 * cb;
+	case V4L2_YCBCR_ENC_SMPTE240M:
+		ycbcr2rgb(smpte240m, y, cb, cr, 16, r, g, b);
 		break;
-	case V4L2_COLORSPACE_REC709:
-	case V4L2_COLORSPACE_SRGB:
+	case V4L2_YCBCR_ENC_709:
+	case V4L2_YCBCR_ENC_XV709:
 	default:
-		b = 4769 * y + 8652 * cb;
+		ycbcr2rgb(full ? rec709_full : rec709, y, cb, cr, 16, r, g, b);
 		break;
 	}
-	return clamp(b >> 12, 0, 0xff0);
 }
 
 /* precalculate color bar values to speed up rendering */
@@ -456,18 +522,17 @@ static void precalculate_color(struct tpg_data *tpg, int k)
 		g <<= 4;
 		b <<= 4;
 	}
-	if (tpg->qual == TPG_QUAL_GRAY)
-		r = g = b = color_to_y(tpg, r, g, b);
+	if (tpg->qual == TPG_QUAL_GRAY) {
+		/* Rec. 709 Luma function */
+		/* (0.2126, 0.7152, 0.0722) * (255 * 256) */
+		r = g = b = ((13879 * r + 46688 * g + 4713 * b) >> 16) + (16 << 4);
+	}
 
 	/*
 	 * The assumption is that the RGB output is always full range,
 	 * so only if the rgb_range overrides the 'real' rgb range do
 	 * we need to convert the RGB values.
 	 *
-	 * Currently there is no way of signalling to userspace if you
-	 * are actually giving it limited range RGB (or full range
-	 * YUV for that matter).
-	 *
 	 * Remember that r, g and b are still in the 0 - 0xff0 range.
 	 */
 	if (tpg->real_rgb_range == V4L2_DV_RGB_RANGE_LIMITED &&
@@ -497,12 +562,12 @@ static void precalculate_color(struct tpg_data *tpg, int k)
 	if (tpg->brightness != 128 || tpg->contrast != 128 ||
 	    tpg->saturation != 128 || tpg->hue) {
 		/* Implement these operations */
+		int y, cb, cr;
+		int tmp_cb, tmp_cr;
 
 		/* First convert to YCbCr */
-		int y = color_to_y(tpg, r, g, b);	/* Luma */
-		int cb = color_to_cb(tpg, r, g, b);	/* Cb */
-		int cr = color_to_cr(tpg, r, g, b);	/* Cr */
-		int tmp_cb, tmp_cr;
+
+		color_to_ycbcr(tpg, r, g, b, &y, &cb, &cr);
 
 		y = (16 << 4) + ((y - (16 << 4)) * tpg->contrast) / 128;
 		y += (tpg->brightness << 4) - (128 << 4);
@@ -520,21 +585,29 @@ static void precalculate_color(struct tpg_data *tpg, int k)
 			tpg->colors[k][2] = clamp(cr >> 4, 1, 254);
 			return;
 		}
-		r = ycbcr_to_r(tpg, y, cb, cr);
-		g = ycbcr_to_g(tpg, y, cb, cr);
-		b = ycbcr_to_b(tpg, y, cb, cr);
+		ycbcr_to_color(tpg, y, cb, cr, &r, &g, &b);
 	}
 
 	if (tpg->is_yuv) {
 		/* Convert to YCbCr */
-		u16 y = color_to_y(tpg, r, g, b);	/* Luma */
-		u16 cb = color_to_cb(tpg, r, g, b);	/* Cb */
-		u16 cr = color_to_cr(tpg, r, g, b);	/* Cr */
+		int y, cb, cr;
+
+		color_to_ycbcr(tpg, r, g, b, &y, &cb, &cr);
 
+		if (tpg->real_quantization == V4L2_QUANTIZATION_LIM_RANGE) {
+			y = clamp(y, 16 << 4, 235 << 4);
+			cb = clamp(cb, 16 << 4, 240 << 4);
+			cr = clamp(cr, 16 << 4, 240 << 4);
+		}
 		tpg->colors[k][0] = clamp(y >> 4, 1, 254);
 		tpg->colors[k][1] = clamp(cb >> 4, 1, 254);
 		tpg->colors[k][2] = clamp(cr >> 4, 1, 254);
 	} else {
+		if (tpg->real_quantization == V4L2_QUANTIZATION_LIM_RANGE) {
+			r = (r * 219) / 255 + (16 << 4);
+			g = (g * 219) / 255 + (16 << 4);
+			b = (b * 219) / 255 + (16 << 4);
+		}
 		switch (tpg->fourcc) {
 		case V4L2_PIX_FMT_RGB565:
 		case V4L2_PIX_FMT_RGB565X:
@@ -1152,6 +1225,46 @@ static void tpg_recalc(struct tpg_data *tpg)
 	if (tpg->recalc_colors) {
 		tpg->recalc_colors = false;
 		tpg->recalc_lines = true;
+		tpg->real_ycbcr_enc = tpg->ycbcr_enc;
+		tpg->real_quantization = tpg->quantization;
+		if (tpg->ycbcr_enc == V4L2_YCBCR_ENC_DEFAULT) {
+			switch (tpg->colorspace) {
+			case V4L2_COLORSPACE_REC709:
+				tpg->real_ycbcr_enc = V4L2_YCBCR_ENC_709;
+				break;
+			case V4L2_COLORSPACE_SRGB:
+				tpg->real_ycbcr_enc = V4L2_YCBCR_ENC_SYCC;
+				break;
+			case V4L2_COLORSPACE_BT2020:
+				tpg->real_ycbcr_enc = V4L2_YCBCR_ENC_BT2020NC;
+				break;
+			case V4L2_COLORSPACE_SMPTE240M:
+				tpg->real_ycbcr_enc = V4L2_YCBCR_ENC_SMPTE240M;
+				break;
+			case V4L2_COLORSPACE_SMPTE170M:
+			case V4L2_COLORSPACE_470_SYSTEM_M:
+			case V4L2_COLORSPACE_470_SYSTEM_BG:
+			case V4L2_COLORSPACE_ADOBERGB:
+			default:
+				tpg->real_ycbcr_enc = V4L2_YCBCR_ENC_601;
+				break;
+			}
+		}
+		if (tpg->quantization == V4L2_QUANTIZATION_DEFAULT) {
+			tpg->real_quantization = V4L2_QUANTIZATION_FULL_RANGE;
+			if (tpg->is_yuv) {
+				switch (tpg->real_ycbcr_enc) {
+				case V4L2_YCBCR_ENC_SYCC:
+				case V4L2_YCBCR_ENC_XV601:
+				case V4L2_YCBCR_ENC_XV709:
+					break;
+				default:
+					tpg->real_quantization =
+						V4L2_QUANTIZATION_LIM_RANGE;
+					break;
+				}
+			}
+		}
 		tpg_precalculate_colors(tpg);
 	}
 	if (tpg->recalc_square_border) {
diff --git a/drivers/media/platform/vivid/vivid-tpg.h b/drivers/media/platform/vivid/vivid-tpg.h
index 8ef3e52..9dc463a4 100644
--- a/drivers/media/platform/vivid/vivid-tpg.h
+++ b/drivers/media/platform/vivid/vivid-tpg.h
@@ -119,6 +119,18 @@ struct tpg_data {
 	u32				fourcc;
 	bool				is_yuv;
 	u32				colorspace;
+	u32				ycbcr_enc;
+	/*
+	 * Stores the actual Y'CbCr encoding, i.e. will never be
+	 * V4L2_YCBCR_ENC_DEFAULT.
+	 */
+	u32				real_ycbcr_enc;
+	u32				quantization;
+	/*
+	 * Stores the actual quantization, i.e. will never be
+	 * V4L2_QUANTIZATION_DEFAULT.
+	 */
+	u32				real_quantization;
 	enum tpg_video_aspect		vid_aspect;
 	enum tpg_pixel_aspect		pix_aspect;
 	unsigned			rgb_range;
@@ -286,6 +298,32 @@ static inline u32 tpg_g_colorspace(const struct tpg_data *tpg)
 	return tpg->colorspace;
 }
 
+static inline void tpg_s_ycbcr_enc(struct tpg_data *tpg, u32 ycbcr_enc)
+{
+	if (tpg->ycbcr_enc == ycbcr_enc)
+		return;
+	tpg->ycbcr_enc = ycbcr_enc;
+	tpg->recalc_colors = true;
+}
+
+static inline u32 tpg_g_ycbcr_enc(const struct tpg_data *tpg)
+{
+	return tpg->ycbcr_enc;
+}
+
+static inline void tpg_s_quantization(struct tpg_data *tpg, u32 quantization)
+{
+	if (tpg->quantization == quantization)
+		return;
+	tpg->quantization = quantization;
+	tpg->recalc_colors = true;
+}
+
+static inline u32 tpg_g_quantization(const struct tpg_data *tpg)
+{
+	return tpg->quantization;
+}
+
 static inline unsigned tpg_g_planes(const struct tpg_data *tpg)
 {
 	return tpg->planes;
-- 
2.1.1

