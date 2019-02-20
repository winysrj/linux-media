Return-Path: <SRS0=tJec=Q3=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CC52AC43381
	for <linux-media@archiver.kernel.org>; Wed, 20 Feb 2019 00:06:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8F77E21738
	for <linux-media@archiver.kernel.org>; Wed, 20 Feb 2019 00:06:16 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Qj5l7UYC"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726405AbfBTAFg (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Tue, 19 Feb 2019 19:05:36 -0500
Received: from mail-pf1-f194.google.com ([209.85.210.194]:41281 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729908AbfBTAFg (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 19 Feb 2019 19:05:36 -0500
Received: by mail-pf1-f194.google.com with SMTP id d25so2634849pfn.8;
        Tue, 19 Feb 2019 16:05:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=PkbTgyhRaMGFHjnDfnhQ8iJ0W1fozZfXO5YRJxGME50=;
        b=Qj5l7UYCR0ZCmazb57JpBmCZ/vssQ8UQ/eRhR4usyJeofdvqnJHBDrhfwR5j/sLpnu
         7RQEnidk1ixVToxNrs875Djk0nS4DO1v1ZTp9arKQ7Zl36skDpfpBRYQrdZgGakviZeW
         aMS4ErHV1ujmXpcMAJhiKYzOil/GahpHipZ0t+pliBe55vDIXRMxE5VfYKxvzuVE++06
         mmws866GC+nRsPBBHvsuLvNJfvFVA9B3jpG94xh7b3L/0PpizFn2yQaIbRYrQ+IJY/f6
         TE8x9CGicdqCaGYBFpuO9IQW/a4MxZHcnaZHMtWAC8c0HrPZaJQHjiR2ndWgdaBDoIpj
         uQhQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=PkbTgyhRaMGFHjnDfnhQ8iJ0W1fozZfXO5YRJxGME50=;
        b=f5n0cDpybhHcW1Eb9gLqXoGeX+NLCHBJQQ2rpasvt1hvZAznbmosbs/U9ZdonG75yl
         BBzsUVb/R0k7GQGAkE/SuXBP5vZNsrLTN/NwG2tC33yckflTvtSW4PFLv4ZFVBO3PbQZ
         ZIBKLDttzY56OpawvfDGxZhmsvQjCgGw2CXHWdDmUB2U1/oUvScAjTbzvMepjqzeYsm1
         HwcJeHbn+5SO0NORh7KmG+H2ViyaXeBHjeVj8nO8+oll+K9x7h7ng0P7vPgCfwhkpqy4
         P2w4YGIjlyUuGh0n05axHXY4KKC6lwa8UdxWWM0o0yuyIEe1TBloRIM+GR+sYcdEjnsw
         ikxA==
X-Gm-Message-State: AHQUAuYlGtDxWmiz3Zjym/9+MguLBsTEAS0v3Bx018iOT0dSYc5mrwUg
        X4RS+5KhEYJLlEMJmeeoDoYnqPkQ
X-Google-Smtp-Source: AHgI3IZ5aGYXc12QPDpdRAxavdyQK85yst3keKlf38lBWnkaQFditnD/HqLuBAFwXgsEQaV96ZpWmw==
X-Received: by 2002:a63:4d4f:: with SMTP id n15mr26481764pgl.327.1550621134828;
        Tue, 19 Feb 2019 16:05:34 -0800 (PST)
Received: from majic.sklembedded.com (c-73-202-231-77.hsd1.ca.comcast.net. [73.202.231.77])
        by smtp.googlemail.com with ESMTPSA id f14sm19159083pgv.23.2019.02.19.16.05.33
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 19 Feb 2019 16:05:34 -0800 (PST)
From:   Steve Longerbeam <slongerbeam@gmail.com>
To:     linux-media@vger.kernel.org
Cc:     Tim Harvey <tharvey@gateworks.com>,
        Steve Longerbeam <slongerbeam@gmail.com>,
        stable@vger.kernel.org, Philipp Zabel <p.zabel@pengutronix.de>,
        dri-devel@lists.freedesktop.org (open list:DRM DRIVERS FOR FREESCALE
        IMX), linux-kernel@vger.kernel.org (open list)
Subject: [PATCH v5 2/7] gpu: ipu-v3: ipu-ic: Fix BT.601 coefficients
Date:   Tue, 19 Feb 2019 16:05:16 -0800
Message-Id: <20190220000521.31130-3-slongerbeam@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190220000521.31130-1-slongerbeam@gmail.com>
References: <20190220000521.31130-1-slongerbeam@gmail.com>
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

The ycbcr2rgb and inverse rgb2ycbcr tables define the BT.601 Y'CbCr
encoding coefficients.

The rgb2ycbcr table specifically describes the BT.601 encoding from
full range RGB to full range YUV. Add table comments to make this more
clear.

The ycbcr2rgb inverse table describes encoding YUV limited range to RGB
full range. To be consistent with the rgb2ycbcr table, convert this to
YUV full range to RGB full range, and adjust/expand on the comments.

The ic_csc_rgb2rgb table is just an identity matrix, so rename to
ic_encode_identity.

Fixes: 1aa8ea0d2bd5d ("gpu: ipu-v3: Add Image Converter unit")

Suggested-by: Philipp Zabel <p.zabel@pengutronix.de>
Signed-off-by: Steve Longerbeam <slongerbeam@gmail.com>
Cc: stable@vger.kernel.org
---
 drivers/gpu/ipu-v3/ipu-ic.c | 63 ++++++++++++++++++++++---------------
 1 file changed, 38 insertions(+), 25 deletions(-)

diff --git a/drivers/gpu/ipu-v3/ipu-ic.c b/drivers/gpu/ipu-v3/ipu-ic.c
index 18816ccf600e..71a0409093e6 100644
--- a/drivers/gpu/ipu-v3/ipu-ic.c
+++ b/drivers/gpu/ipu-v3/ipu-ic.c
@@ -175,7 +175,7 @@ static inline void ipu_ic_write(struct ipu_ic *ic, u32 value, unsigned offset)
 	writel(value, ic->priv->base + offset);
 }
 
-struct ic_csc_params {
+struct ic_encode_coeff {
 	s16 coeff[3][3];	/* signed 9-bit integer coefficients */
 	s16 offset[3];		/* signed 11+2-bit fixed point offset */
 	u8 scale:2;		/* scale coefficients * 2^(scale-1) */
@@ -183,22 +183,27 @@ struct ic_csc_params {
 };
 
 /*
- * Y = R *  .299 + G *  .587 + B *  .114;
- * U = R * -.169 + G * -.332 + B *  .500 + 128.;
- * V = R *  .500 + G * -.419 + B * -.0813 + 128.;
+ * BT.601 encoding from RGB full range to YUV full range:
+ *
+ * Y =  .2990 * R + .5870 * G + .1140 * B
+ * U = -.1687 * R - .3313 * G + .5000 * B + 128
+ * V =  .5000 * R - .4187 * G - .0813 * B + 128
  */
-static const struct ic_csc_params ic_csc_rgb2ycbcr = {
+static const struct ic_encode_coeff ic_encode_rgb2ycbcr_601 = {
 	.coeff = {
-		{ 77, 150, 29 },
-		{ 469, 427, 128 },
+		{  76, 150,  29 },
+		{ 469, 428, 128 },
 		{ 128, 405, 491 },
 	},
 	.offset = { 0, 512, 512 },
 	.scale = 1,
 };
 
-/* transparent RGB->RGB matrix for graphics combining */
-static const struct ic_csc_params ic_csc_rgb2rgb = {
+/*
+ * identity matrix, used for transparent RGB->RGB graphics
+ * combining.
+ */
+static const struct ic_encode_coeff ic_encode_identity = {
 	.coeff = {
 		{ 128, 0, 0 },
 		{ 0, 128, 0 },
@@ -208,17 +213,25 @@ static const struct ic_csc_params ic_csc_rgb2rgb = {
 };
 
 /*
- * R = (1.164 * (Y - 16)) + (1.596 * (Cr - 128));
- * G = (1.164 * (Y - 16)) - (0.392 * (Cb - 128)) - (0.813 * (Cr - 128));
- * B = (1.164 * (Y - 16)) + (2.017 * (Cb - 128);
+ * Inverse BT.601 encoding from YUV full range to RGB full range:
+ *
+ * R = 1. * Y +      0 * (Cb - 128) + 1.4020 * (Cr - 128)
+ * G = 1. * Y -  .3442 * (Cb - 128) - 0.7142 * (Cr - 128)
+ * B = 1. * Y + 1.7720 * (Cb - 128) +      0 * (Cr - 128)
+ *
+ * equivalently (factoring out the offsets):
+ *
+ * R = 1. * Y  +      0 * Cb + 1.4020 * Cr - 179.456
+ * G = 1. * Y  -  .3442 * Cb - 0.7142 * Cr + 135.475
+ * B = 1. * Y  + 1.7720 * Cb +      0 * Cr - 226.816
  */
-static const struct ic_csc_params ic_csc_ycbcr2rgb = {
+static const struct ic_encode_coeff ic_encode_ycbcr2rgb_601 = {
 	.coeff = {
-		{ 149, 0, 204 },
-		{ 149, 462, 408 },
-		{ 149, 255, 0 },
+		{ 128,   0, 179 },
+		{ 128, 468, 421 },
+		{ 128, 226,   0 },
 	},
-	.offset = { -446, 266, -554 },
+	.offset = { -359, 271, -454 },
 	.scale = 2,
 };
 
@@ -228,7 +241,7 @@ static int init_csc(struct ipu_ic *ic,
 		    int csc_index)
 {
 	struct ipu_ic_priv *priv = ic->priv;
-	const struct ic_csc_params *params;
+	const struct ic_encode_coeff *coeff;
 	u32 __iomem *base;
 	const u16 (*c)[3];
 	const u16 *a;
@@ -238,26 +251,26 @@ static int init_csc(struct ipu_ic *ic,
 		(priv->tpmem_base + ic->reg->tpmem_csc[csc_index]);
 
 	if (inf == IPUV3_COLORSPACE_YUV && outf == IPUV3_COLORSPACE_RGB)
-		params = &ic_csc_ycbcr2rgb;
+		coeff = &ic_encode_ycbcr2rgb_601;
 	else if (inf == IPUV3_COLORSPACE_RGB && outf == IPUV3_COLORSPACE_YUV)
-		params = &ic_csc_rgb2ycbcr;
+		coeff = &ic_encode_rgb2ycbcr_601;
 	else if (inf == IPUV3_COLORSPACE_RGB && outf == IPUV3_COLORSPACE_RGB)
-		params = &ic_csc_rgb2rgb;
+		coeff = &ic_encode_identity;
 	else {
 		dev_err(priv->ipu->dev, "Unsupported color space conversion\n");
 		return -EINVAL;
 	}
 
 	/* Cast to unsigned */
-	c = (const u16 (*)[3])params->coeff;
-	a = (const u16 *)params->offset;
+	c = (const u16 (*)[3])coeff->coeff;
+	a = (const u16 *)coeff->offset;
 
 	param = ((a[0] & 0x1f) << 27) | ((c[0][0] & 0x1ff) << 18) |
 		((c[1][1] & 0x1ff) << 9) | (c[2][2] & 0x1ff);
 	writel(param, base++);
 
-	param = ((a[0] & 0x1fe0) >> 5) | (params->scale << 8) |
-		(params->sat << 10);
+	param = ((a[0] & 0x1fe0) >> 5) | (coeff->scale << 8) |
+		(coeff->sat << 10);
 	writel(param, base++);
 
 	param = ((a[1] & 0x1f) << 27) | ((c[0][1] & 0x1ff) << 18) |
-- 
2.17.1

