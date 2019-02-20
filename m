Return-Path: <SRS0=tJec=Q3=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F3759C43381
	for <linux-media@archiver.kernel.org>; Wed, 20 Feb 2019 00:06:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BACFC21738
	for <linux-media@archiver.kernel.org>; Wed, 20 Feb 2019 00:06:11 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="iveaGDog"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730103AbfBTAFl (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Tue, 19 Feb 2019 19:05:41 -0500
Received: from mail-pl1-f194.google.com ([209.85.214.194]:38857 "EHLO
        mail-pl1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730062AbfBTAFk (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 19 Feb 2019 19:05:40 -0500
Received: by mail-pl1-f194.google.com with SMTP id e5so11225915plb.5;
        Tue, 19 Feb 2019 16:05:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=YMJ6Z/OI+JwxOvQ/XgxaTgw9XsPGx3EOUms81JPt9UA=;
        b=iveaGDogIOgbGfnhozf96pLKX2ZZKTeoy5C6+l/I3uCjGR+qkmQDoSXLK6F3+pSwPB
         2Y8BOyJLVcEOb2QGUTc2jmE8mL9v99zuYNNo4j2PDT8rj1HSdJl8A+Rvkw+1wTOM4QY4
         4R0t9ugIHa6fbMUcLUH/tg+JZ47woGure0PxUyld8ZM3UNsI3dKSvxzc0xy9oI9eqjIz
         mx83Iohq2hAY2dp6apj5QsuuuQnhPNTpFMW4dGvWYKKcT9e/J3D4rpDtqMmQpm2NQoy7
         FF6CsZk0jVbKvTTA6Otk6H2c8b2nitrI61P98b7Cm3SIfJ+GANdgrM/TgY90fnv59xU+
         w66w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=YMJ6Z/OI+JwxOvQ/XgxaTgw9XsPGx3EOUms81JPt9UA=;
        b=j9xlsdFI07V1QGI9KcPxHO7NQXVA31W3VsDkAsKkDN4hE/LPAJ85QmweI6OAjcr94t
         bV6fdN/xGPPssTmSRn2CFvg2Q2zCtPpNjuEXtqS2oFLcG0ZwM5pR7lx8FYNPx/6yFC+L
         xYM1Z+YbzsKKUFupXhdBIHKqj3Ec644S76pTJRYeT2hJmc27kBz8BDOGk/LIR+EX2Nv6
         qmN1/bT8ZWLu4xYCsW4uWaTxYE2U9hFWQJOuDn4ub4rKSiAsmbEXSJm8BYRtq5mWG2qx
         yzys6kvfEZ9wGQgQmYlyHMoBoesErtYRyeLjU0G7vwDuDmdf0MTGbQgVf2v6THx9RNHc
         9PWw==
X-Gm-Message-State: AHQUAubs1NoTGiYItZG/UKuFkmnpW2hk/rcnkm5uhFLBuhDbeEVilyLm
        cQIv00Mczh5Ob35EJ0xrjIxx8BKt
X-Google-Smtp-Source: AHgI3IYHzz//jCFUJhXPyHiKH5eiMCkyatxt0LFpOuFJ0DXLcfDJzeCvYQTMHeUtx262coMUB8Xo9g==
X-Received: by 2002:a17:902:780a:: with SMTP id p10mr34399164pll.54.1550621138398;
        Tue, 19 Feb 2019 16:05:38 -0800 (PST)
Received: from majic.sklembedded.com (c-73-202-231-77.hsd1.ca.comcast.net. [73.202.231.77])
        by smtp.googlemail.com with ESMTPSA id f14sm19159083pgv.23.2019.02.19.16.05.37
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 19 Feb 2019 16:05:37 -0800 (PST)
From:   Steve Longerbeam <slongerbeam@gmail.com>
To:     linux-media@vger.kernel.org
Cc:     Tim Harvey <tharvey@gateworks.com>,
        Steve Longerbeam <slongerbeam@gmail.com>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        dri-devel@lists.freedesktop.org (open list:DRM DRIVERS FOR FREESCALE
        IMX), linux-kernel@vger.kernel.org (open list)
Subject: [PATCH v5 4/7] gpu: ipu-v3: ipu-ic: Add support for Rec.709 encoding
Date:   Tue, 19 Feb 2019 16:05:18 -0800
Message-Id: <20190220000521.31130-5-slongerbeam@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190220000521.31130-1-slongerbeam@gmail.com>
References: <20190220000521.31130-1-slongerbeam@gmail.com>
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Add support for Rec.709 encoding and inverse encoding.

The determination of the CSC coefficients based on the input/output
colorspace parameters are moved to a new function calc_csc_coeffs().

Reported-by: Tim Harvey <tharvey@gateworks.com>
Signed-off-by: Steve Longerbeam <slongerbeam@gmail.com>
---
Changes in v5:
- moved API changes to a previous patch.
- moved CSC coeff calc to new function calc_csc_coeffs().
Changes in v4:
- fix compile error.
Chnges in v3:
- none.
Changes in v2:
- only return "Unsupported YCbCr encoding" error if inf != outf,
  since if inf == outf, the identity matrix can be used. Reported
  by Tim Harvey.
---
 drivers/gpu/ipu-v3/ipu-ic.c | 120 ++++++++++++++++++++++++++++--------
 1 file changed, 94 insertions(+), 26 deletions(-)

diff --git a/drivers/gpu/ipu-v3/ipu-ic.c b/drivers/gpu/ipu-v3/ipu-ic.c
index 02043f23f411..012ea2239e97 100644
--- a/drivers/gpu/ipu-v3/ipu-ic.c
+++ b/drivers/gpu/ipu-v3/ipu-ic.c
@@ -214,6 +214,23 @@ static const struct ic_encode_coeff ic_encode_identity = {
 	.scale = 2,
 };
 
+/*
+ * REC.709 encoding from RGB full range to YUV full range:
+ *
+ * Y =  .2126 * R + .7152 * G + .0722 * B
+ * U = -.1146 * R - .3854 * G + .5000 * B + 128
+ * V =  .5000 * R - .4542 * G - .0458 * B + 128
+ */
+static const struct ic_encode_coeff ic_encode_rgb2ycbcr_709 = {
+	.coeff = {
+		{  54, 183,  19 },
+		{ 483, 413, 128 },
+		{ 128, 396, 500 },
+	},
+	.offset = { 0, 512, 512 },
+	.scale = 1,
+};
+
 /*
  * Inverse BT.601 encoding from YUV full range to RGB full range:
  *
@@ -237,28 +254,42 @@ static const struct ic_encode_coeff ic_encode_ycbcr2rgb_601 = {
 	.scale = 2,
 };
 
-static int init_csc(struct ipu_ic *ic,
-		    const struct ipu_ic_colorspace *in,
-		    const struct ipu_ic_colorspace *out,
-		    int csc_index)
+/*
+ * Inverse REC.709 encoding from YUV full range to RGB full range:
+ *
+ * R = 1. * Y +      0 * (Cb - 128) + 1.5748 * (Cr - 128)
+ * G = 1. * Y -  .1873 * (Cb - 128) -  .4681 * (Cr - 128)
+ * B = 1. * Y + 1.8556 * (Cb - 128) +      0 * (Cr - 128)
+ *
+ * equivalently (factoring out the offsets):
+ *
+ * R = 1. * Y  +      0 * Cb + 1.5748 * Cr - 201.574
+ * G = 1. * Y  -  .1873 * Cb -  .4681 * Cr +  83.891
+ * B = 1. * Y  + 1.8556 * Cb +      0 * Cr - 237.517
+ */
+static const struct ic_encode_coeff ic_encode_ycbcr2rgb_709 = {
+	.coeff = {
+		{  128,   0, 202 },
+		{  128, 488, 452 },
+		{  128, 238,   0 },
+	},
+	.offset = { -403, 168, -475 },
+	.scale = 2,
+};
+
+static int calc_csc_coeffs(struct ipu_ic_priv *priv,
+			   struct ic_encode_coeff *coeff_out,
+			   const struct ipu_ic_colorspace *in,
+			   const struct ipu_ic_colorspace *out)
 {
-	struct ipu_ic_priv *priv = ic->priv;
-	const struct ic_encode_coeff *coeff;
-	u32 __iomem *base;
-	const u16 (*c)[3];
-	const u16 *a;
-	u32 param;
+	const struct ic_encode_coeff *encode_coeff;
+	bool inverse_encode;
 
 	if (in->colorspace != out->colorspace) {
 		dev_err(priv->ipu->dev, "Cannot convert colorspaces\n");
 		return -ENOTSUPP;
 	}
 
-	if (out->enc != V4L2_YCBCR_ENC_601) {
-		dev_err(priv->ipu->dev, "Only BT.601 encoding supported\n");
-		return -ENOTSUPP;
-	}
-
 	if ((in->cs == IPUV3_COLORSPACE_YUV &&
 	     in->quant != V4L2_QUANTIZATION_FULL_RANGE) ||
 	    (out->cs == IPUV3_COLORSPACE_YUV &&
@@ -275,26 +306,63 @@ static int init_csc(struct ipu_ic *ic,
 		return -ENOTSUPP;
 	}
 
+	if (in->cs == out->cs) {
+		*coeff_out = ic_encode_identity;
+
+		return 0;
+	}
+
+	inverse_encode = (in->cs == IPUV3_COLORSPACE_YUV);
+
+	switch (out->enc) {
+	case V4L2_YCBCR_ENC_601:
+		encode_coeff = inverse_encode ?
+			&ic_encode_ycbcr2rgb_601 : &ic_encode_rgb2ycbcr_601;
+		break;
+	case V4L2_YCBCR_ENC_709:
+		encode_coeff = inverse_encode ?
+			&ic_encode_ycbcr2rgb_709 : &ic_encode_rgb2ycbcr_709;
+		break;
+	default:
+		dev_err(priv->ipu->dev, "Unsupported YCbCr encoding\n");
+		return -ENOTSUPP;
+	}
+
+	*coeff_out = *encode_coeff;
+
+	return 0;
+}
+
+static int init_csc(struct ipu_ic *ic,
+		    const struct ipu_ic_colorspace *in,
+		    const struct ipu_ic_colorspace *out,
+		    int csc_index)
+{
+	struct ipu_ic_priv *priv = ic->priv;
+	struct ic_encode_coeff coeff;
+	u32 __iomem *base;
+	const u16 (*c)[3];
+	const u16 *a;
+	u32 param;
+	int ret;
+
+	ret = calc_csc_coeffs(priv, &coeff, in, out);
+	if (ret)
+		return ret;
+
 	base = (u32 __iomem *)
 		(priv->tpmem_base + ic->reg->tpmem_csc[csc_index]);
 
-	if (in->cs == out->cs)
-		coeff = &ic_encode_identity;
-	else if (in->cs == IPUV3_COLORSPACE_YUV)
-		coeff = &ic_encode_ycbcr2rgb_601;
-	else
-		coeff = &ic_encode_rgb2ycbcr_601;
-
 	/* Cast to unsigned */
-	c = (const u16 (*)[3])coeff->coeff;
-	a = (const u16 *)coeff->offset;
+	c = (const u16 (*)[3])coeff.coeff;
+	a = (const u16 *)coeff.offset;
 
 	param = ((a[0] & 0x1f) << 27) | ((c[0][0] & 0x1ff) << 18) |
 		((c[1][1] & 0x1ff) << 9) | (c[2][2] & 0x1ff);
 	writel(param, base++);
 
-	param = ((a[0] & 0x1fe0) >> 5) | (coeff->scale << 8) |
-		(coeff->sat << 10);
+	param = ((a[0] & 0x1fe0) >> 5) | (coeff.scale << 8) |
+		(coeff.sat << 10);
 	writel(param, base++);
 
 	param = ((a[1] & 0x1f) << 27) | ((c[0][1] & 0x1ff) << 18) |
-- 
2.17.1

