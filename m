Return-Path: <SRS0=tJec=Q3=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 79E16C43381
	for <linux-media@archiver.kernel.org>; Wed, 20 Feb 2019 00:06:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 33FB721738
	for <linux-media@archiver.kernel.org>; Wed, 20 Feb 2019 00:06:09 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="eWWJ5Tfl"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730240AbfBTAGC (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Tue, 19 Feb 2019 19:06:02 -0500
Received: from mail-pg1-f193.google.com ([209.85.215.193]:34306 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728164AbfBTAFm (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 19 Feb 2019 19:05:42 -0500
Received: by mail-pg1-f193.google.com with SMTP id i130so10917867pgd.1;
        Tue, 19 Feb 2019 16:05:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=sgbC6WisCelZOgDnEPuGaK5syAx8/FPS1ZXA5k/W8ZI=;
        b=eWWJ5Tflxd2ffqEEEWvkmdE5riY4AM25Y04L+MKO7P12m2xlz6PoxjM0Uyp2jb1rab
         BzAJcGEQ209X5ncYlMk3Rs57wPgtMwO57eND8A2Wr0oDUlf4cBeL0eGwtiEscMMfEOXF
         LO7XB5ii8Q0caAda80TFSuQ/t57VWYxi01NZtQODGNXB1ygVlAs3p71vQrPCxcyZ8i7K
         QyBDLMM/W9SIO5lsxYYzil+mBg76RTZtKDocCnEqNx3dKngwEbHXAMtR2Qd09WqcECbR
         FWvvcABaMqECl9YMEuZAvwBMuHdYrQNuNzAEOHq/wXK000rep/0TshbfpXX+x9RV3Phc
         1p0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=sgbC6WisCelZOgDnEPuGaK5syAx8/FPS1ZXA5k/W8ZI=;
        b=Oc26p0ctVLNDI4F917uiAmNuJDtZdCZf5FYki7ZnVzev6cC7qkpIHzSDgHvwCN9SHP
         LIQO6PZII8OK3fxHvRihQDKQqIVwoA+Mi6/CQYn4duOLUdJ8XUEng0ztI74r102YhRgy
         h1XJAuiwqrw/yYBaNeL+sqGRxL72kLxtOM8qQ5Kt7fQh9zp1huFYgCyDKhK01oLVJZSY
         gLyE6R9JZp5z65tkfUp0MB6laPJV1iUoQg83wfn3rtn9vuUZnvyeaH5OECOKuamS7yUV
         YBOrVbaPm2ujDvjGIr+P79R57eWNmvLaonb4ECFnb3tabVbirC9qauiQM0YWqpXZPWat
         w3Cg==
X-Gm-Message-State: AHQUAuZxnMMePkbrWZ2iQFVL2ZarfUFKES/llFXpuBy2P91slL1ZIMLO
        WcE1tMx17W8eFsaBPn2MGg+55ZW5
X-Google-Smtp-Source: AHgI3IYo7bV0VdCQNeUaAsecxPhLhXYG+4KEPNHn+NZStWynoqAU/6lJh0vt3P1tvIkQmyx6uThv2w==
X-Received: by 2002:a63:20e:: with SMTP id 14mr26380684pgc.161.1550621139822;
        Tue, 19 Feb 2019 16:05:39 -0800 (PST)
Received: from majic.sklembedded.com (c-73-202-231-77.hsd1.ca.comcast.net. [73.202.231.77])
        by smtp.googlemail.com with ESMTPSA id f14sm19159083pgv.23.2019.02.19.16.05.38
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 19 Feb 2019 16:05:39 -0800 (PST)
From:   Steve Longerbeam <slongerbeam@gmail.com>
To:     linux-media@vger.kernel.org
Cc:     Tim Harvey <tharvey@gateworks.com>,
        Steve Longerbeam <slongerbeam@gmail.com>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        dri-devel@lists.freedesktop.org (open list:DRM DRIVERS FOR FREESCALE
        IMX), linux-kernel@vger.kernel.org (open list)
Subject: [PATCH v5 5/7] gpu: ipu-v3: ipu-ic: Add support for limited range encoding
Date:   Tue, 19 Feb 2019 16:05:19 -0800
Message-Id: <20190220000521.31130-6-slongerbeam@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190220000521.31130-1-slongerbeam@gmail.com>
References: <20190220000521.31130-1-slongerbeam@gmail.com>
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Add support for the following conversions:

- YUV full-range to YUV limited-range
- YUV limited-range to YUV full-range
- YUV limited-range to RGB full-range
- RGB full-range to YUV limited-range

The last two conversions require operating on the YUV full-range
encoding and inverse encoding coefficients, with the YUV-to-YUV
limited<->full coefficients. The formula to convert is

M_c = M_a * M_b
O_c = M_a * O_b + O_a

For calculating the RGB full-range to YUV limited-range coefficients:

[M_a, O_a] = YUV full-range to YUV limited-range coefficients.
[M_b, O_b] = RGB full-range to YUV full-range coefficients.

For calculating the YUV limited-range to RGB full-range coefficients:

[M_a, O_a] = YUV full-range to RGB full-range coefficients.
[M_b, O_b] = YUV limited-range to YUV full-range coefficients.

The calculation of [M_c, O_c] is carried out by the function
transform_coeffs().

In the future if RGB limited range encoding is required, the same
function can be used. And cascaded to create all combinations of
encoding for YUV limited/full range <-> RGB limited/full range,
passing the output coefficients from one call as the input for the
next.

For example, to create YUV full-range to RGB limited-range coefficients:

[M_a, O_a] = RGB full-range to RGB limited-range coefficients.
[M_b, O_b] = YUV full-range to RGB full-range coefficients.

and that output sent as input to create YUV limited-range to RGB
limited-range coefficients:

[M_a, O_a] = YUV full-range to RGB limited-range coefficients.
[M_b, O_b] = YUV limited-range to YUV full-range coefficients.

Signed-off-by: Steve Longerbeam <slongerbeam@gmail.com>
---
 drivers/gpu/ipu-v3/ipu-ic.c | 281 +++++++++++++++++++++++++++++++++---
 1 file changed, 263 insertions(+), 18 deletions(-)

diff --git a/drivers/gpu/ipu-v3/ipu-ic.c b/drivers/gpu/ipu-v3/ipu-ic.c
index 012ea2239e97..861f43556df4 100644
--- a/drivers/gpu/ipu-v3/ipu-ic.c
+++ b/drivers/gpu/ipu-v3/ipu-ic.c
@@ -178,10 +178,10 @@ static inline void ipu_ic_write(struct ipu_ic *ic, u32 value, unsigned offset)
 }
 
 struct ic_encode_coeff {
-	s16 coeff[3][3];	/* signed 9-bit integer coefficients */
-	s16 offset[3];		/* signed 11+2-bit fixed point offset */
-	u8 scale:2;		/* scale coefficients * 2^(scale-1) */
-	bool sat:1;		/* saturate to (16, 235(Y) / 240(U, V)) */
+	int coeff[3][3];	/* signed 9-bit integer coefficients */
+	int offset[3];		/* signed 13-bit integer offset */
+	int scale;		/* scale coefficients * 2^(scale-1) */
+	bool sat;		/* saturate to (16, 235(Y) / 240(U, V)) */
 };
 
 /*
@@ -277,6 +277,231 @@ static const struct ic_encode_coeff ic_encode_ycbcr2rgb_709 = {
 	.scale = 2,
 };
 
+/*
+ * YUV full range to YUV limited range:
+ *
+ * Y_lim  = 0.8588 * Y_full + 16
+ * Cb_lim = 0.8784 * (Cb_full - 128) + 128
+ * Cr_lim = 0.8784 * (Cr_full - 128) + 128
+ */
+static const struct ic_encode_coeff ic_encode_ycbcr_full2lim = {
+	.coeff = {
+		{ 219, 0, 0 },
+		{ 0, 224, 0 },
+		{ 0, 0, 224 },
+	},
+	.offset = { 64, 62, 62 },
+	.scale = 1,
+};
+
+/*
+ * YUV limited range to YUV full range:
+ *
+ * Y_full  = 1.1644 * (Y_lim - 16)
+ * Cb_full = 1.1384 * (Cb_lim - 128) + 128
+ * Cr_full = 1.1384 * (Cr_lim - 128) + 128
+ */
+static const struct ic_encode_coeff ic_encode_ycbcr_lim2full = {
+	.coeff = {
+		{ 149, 0, 0 },
+		{ 0, 145, 0 },
+		{ 0, 0, 145 },
+	},
+	.offset = { -37, -35, -35 },
+	.scale = 2,
+};
+
+/*
+ * RGB full range to RGB limited range:
+ *
+ * R_lim = 0.8588 * R_full + 16
+ * G_lim = 0.8588 * G_full + 16
+ * B_lim = 0.8588 * B_full + 16
+ */
+static const struct ic_encode_coeff
+ic_encode_rgb_full2lim __maybe_unused = {
+	.coeff = {
+		{ 219, 0, 0 },
+		{ 0, 219, 0 },
+		{ 0, 0, 219 },
+	},
+	.offset = { 64, 64, 64 },
+	.scale = 1,
+};
+
+/*
+ * RGB limited range to RGB full range:
+ *
+ * R_full = 1.1644 * (R_lim - 16)
+ * G_full = 1.1644 * (G_lim - 16)
+ * B_full = 1.1644 * (B_lim - 16)
+ */
+static const struct ic_encode_coeff
+ic_encode_rgb_lim2full __maybe_unused = {
+	.coeff = {
+		{ 149, 0, 0 },
+		{ 0, 149, 0 },
+		{ 0, 0, 149 },
+	},
+	.offset = { -37, -37, -37 },
+	.scale = 2,
+};
+
+/*
+ * Convert a coefficient and scale value in TPMEM register format
+ * to a signed int times 256 (fix the radix point). The TPMEM register
+ * coefficient format is a signed 9-bit value (sign bit at bit 8,
+ * mantissa = coeff * 2 ^ (8 - scale - 1)).
+ */
+static int coeff_fix(int coeff, int scale)
+{
+	if (coeff >= 256)
+		coeff -= 512;
+	if (scale == 0)
+		return DIV_ROUND_CLOSEST(coeff, 2);
+	return coeff << (scale - 1);
+}
+
+/*
+ * Convert a signed int coefficient times 256 to TPMEM register
+ * format, given a scale value = TPMEM scale - 1.
+ */
+static int coeff_normalize(int coeff, int scale)
+{
+	coeff = DIV_ROUND_CLOSEST(coeff, 1 << scale);
+	if (coeff < 0)
+		coeff += 512;
+	return coeff;
+}
+
+/*
+ * Convert an offset and scale value in TPMEM register format to a
+ * signed int times 256 (fix the radix point). The TPMEM register
+ * offset format is a signed 13-bit value (sign bit at bit 12,
+ * mantissa = offset * 2 ^ (2 - (scale - 1)).
+ */
+static int offset_fix(int offset, int scale)
+{
+	return offset << (8 - (2 - (scale - 1)));
+}
+
+/*
+ * Convert a signed int offset times 256 to TPMEM register
+ * format, given a scale value = TPMEM scale - 1.
+ */
+static int offset_normalize(int off, int scale)
+{
+	return DIV_ROUND_CLOSEST(off, 1 << (8 - (2 - scale)));
+}
+
+/*
+ * Find the scale value that fits the given coefficient within
+ * the 8-bit TPMEM mantissa.
+ */
+static int get_coeff_scale(int coeff)
+{
+	int scale = 0;
+
+	while (abs(coeff) >= 256 && scale <= 2) {
+		coeff = DIV_ROUND_CLOSEST(coeff, 2);
+		scale++;
+	}
+
+	return scale;
+}
+
+/*
+ * The above defined encoding coefficients all encode between
+ * full-range RGB and full-range YCbCr.
+ *
+ * This function calculates a matrix M_c and offset vector O_c, given
+ * input matrices M_a, M_b and offset vectors O_a, O_b, such that:
+ *
+ * M_c = M_a * M_b
+ * O_c = M_a * O_b + O_a
+ *
+ * This operation will transform the full-range coefficients to
+ * coefficients that encode to or from limited range YCbCr or RGB.
+ *
+ * For example, to transform ic_encode_rgb2ycbcr_601 to encode to
+ * limited-range YCbCr:
+ *
+ * [M_a, O_a] = ic_encode_ycbcr_full2lim
+ * [M_b, O_b] = ic_encode_rgb2ycbcr_601
+ *
+ * To transform the inverse coefficients ic_encode_ycbcr2rgb_601 to
+ * encode from limited-range YCbCr:
+ *
+ * [M_a, O_a] = ic_encode_ycbcr2rgb_601
+ * [M_b, O_b] = ic_encode_ycbcr_lim2full
+ *
+ * The function can also be used to create RGB limited range
+ * coefficients, and cascaded to create all combinations of
+ * encodings between YCbCr limited/full range <-> RGB limited/full
+ * range.
+ */
+static void transform_coeffs(struct ic_encode_coeff *out,
+			     const struct ic_encode_coeff *a,
+			     const struct ic_encode_coeff *b)
+{
+	int c_a, c_b, c_out;
+	int o_a, o_b, o_out;
+	int outscale = 0;
+	int i, j, k;
+
+	for (i = 0; i < 3; i++) {
+		o_out = 0;
+		for (j = 0; j < 3; j++) {
+			int scale;
+
+			/* M_c[i,j] = M_a[i,k] * M_b[k,j] */
+			c_out = 0;
+			for (k = 0; k < 3; k++) {
+				c_a = coeff_fix(a->coeff[i][k], a->scale);
+				c_b = coeff_fix(b->coeff[k][j], b->scale);
+				c_out += c_a * c_b;
+			}
+
+			c_out = DIV_ROUND_CLOSEST(c_out, 1 << 8);
+			out->coeff[i][j] = c_out;
+
+			/*
+			 * get scale for this coefficient and update
+			 * final output scale.
+			 */
+			scale = get_coeff_scale(c_out);
+			outscale = max(outscale, scale);
+
+			/* M_a[i,j] * O_b[j] */
+			c_a = coeff_fix(a->coeff[i][j], a->scale);
+			o_b = offset_fix(b->offset[j], b->scale);
+			o_out += DIV_ROUND_CLOSEST(c_a * o_b, 1 << 8);
+		}
+
+		/* O_c[i] = (M_a * O_b)[i] + O_a[i] */
+		o_a = offset_fix(a->offset[i], a->scale);
+		o_out += o_a;
+
+		out->offset[i] = o_out;
+	}
+
+	/*
+	 * normalize output coefficients and offsets to TPMEM
+	 * register format.
+	 */
+	for (i = 0; i < 3; i++) {
+		for (j = 0; j < 3; j++) {
+			c_out = out->coeff[i][j];
+			out->coeff[i][j] = coeff_normalize(c_out, outscale);
+		}
+
+		o_out = out->offset[i];
+		out->offset[i] = offset_normalize(o_out, outscale);
+	}
+
+	out->scale = outscale + 1;
+}
+
 static int calc_csc_coeffs(struct ipu_ic_priv *priv,
 			   struct ic_encode_coeff *coeff_out,
 			   const struct ipu_ic_colorspace *in,
@@ -290,14 +515,6 @@ static int calc_csc_coeffs(struct ipu_ic_priv *priv,
 		return -ENOTSUPP;
 	}
 
-	if ((in->cs == IPUV3_COLORSPACE_YUV &&
-	     in->quant != V4L2_QUANTIZATION_FULL_RANGE) ||
-	    (out->cs == IPUV3_COLORSPACE_YUV &&
-	     out->quant != V4L2_QUANTIZATION_FULL_RANGE)) {
-		dev_err(priv->ipu->dev, "Limited range YUV not supported\n");
-		return -ENOTSUPP;
-	}
-
 	if ((in->cs == IPUV3_COLORSPACE_RGB &&
 	     in->quant != V4L2_QUANTIZATION_FULL_RANGE) ||
 	    (out->cs == IPUV3_COLORSPACE_RGB &&
@@ -307,7 +524,18 @@ static int calc_csc_coeffs(struct ipu_ic_priv *priv,
 	}
 
 	if (in->cs == out->cs) {
-		*coeff_out = ic_encode_identity;
+		if (in->quant == out->quant) {
+			*coeff_out = ic_encode_identity;
+		} else if (in->quant == V4L2_QUANTIZATION_FULL_RANGE) {
+			/* YUV full-range to YUV limited-range */
+			*coeff_out = ic_encode_ycbcr_full2lim;
+
+			/* set saturation bit for YUV limited-range output */
+			coeff_out->sat = true;
+		} else {
+			/* YUV limited-range to YUV full-range */
+			*coeff_out = ic_encode_ycbcr_lim2full;
+		}
 
 		return 0;
 	}
@@ -328,7 +556,24 @@ static int calc_csc_coeffs(struct ipu_ic_priv *priv,
 		return -ENOTSUPP;
 	}
 
-	*coeff_out = *encode_coeff;
+	if (in->quant == out->quant) {
+		/*
+		 * YUV full-range to RGB full-range, or
+		 * RGB full-range to YUV full-range.
+		 */
+		*coeff_out = *encode_coeff;
+	} else if (inverse_encode) {
+		/* YUV limited-range to RGB full-range */
+		transform_coeffs(coeff_out, encode_coeff,
+				 &ic_encode_ycbcr_lim2full);
+	} else {
+		/* RGB full-range to YUV limited-range */
+		transform_coeffs(coeff_out, &ic_encode_ycbcr_full2lim,
+				 encode_coeff);
+
+		/* set saturation bit for YUV limited-range output */
+		coeff_out->sat = true;
+	}
 
 	return 0;
 }
@@ -340,9 +585,9 @@ static int init_csc(struct ipu_ic *ic,
 {
 	struct ipu_ic_priv *priv = ic->priv;
 	struct ic_encode_coeff coeff;
+	const unsigned int (*c)[3];
+	const unsigned int *a;
 	u32 __iomem *base;
-	const u16 (*c)[3];
-	const u16 *a;
 	u32 param;
 	int ret;
 
@@ -354,8 +599,8 @@ static int init_csc(struct ipu_ic *ic,
 		(priv->tpmem_base + ic->reg->tpmem_csc[csc_index]);
 
 	/* Cast to unsigned */
-	c = (const u16 (*)[3])coeff.coeff;
-	a = (const u16 *)coeff.offset;
+	c = (const unsigned int (*)[3])coeff.coeff;
+	a = (const unsigned int *)coeff.offset;
 
 	param = ((a[0] & 0x1f) << 27) | ((c[0][0] & 0x1ff) << 18) |
 		((c[1][1] & 0x1ff) << 9) | (c[2][2] & 0x1ff);
-- 
2.17.1

