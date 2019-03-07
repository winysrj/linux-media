Return-Path: <SRS0=yxRx=RK=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CCFE0C43381
	for <linux-media@archiver.kernel.org>; Thu,  7 Mar 2019 23:34:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 86BE820675
	for <linux-media@archiver.kernel.org>; Thu,  7 Mar 2019 23:34:48 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="cb0cSPq9"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726476AbfCGXem (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Thu, 7 Mar 2019 18:34:42 -0500
Received: from mail-pg1-f193.google.com ([209.85.215.193]:40353 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726234AbfCGXeS (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Thu, 7 Mar 2019 18:34:18 -0500
Received: by mail-pg1-f193.google.com with SMTP id u9so12514984pgo.7;
        Thu, 07 Mar 2019 15:34:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=awniDW2yRx7HDyAsi7S/aqrqpwLEo6aGmU5U05hKru8=;
        b=cb0cSPq9WeCsBk8iqKNVTSir/5cZ978p39vhDKMvIqIMZtVLcxTKtThHmBJBCjbrAR
         s6foPkas+I3R8Em/imCpGjFEbGxSzo3gcVnwMbwPSQHR/OZWK1dvYS0D+8Zbuy2q4765
         T9GWRYPrxA/q+c4Dbh8pY497FmIcpD/pfVTE487yVJS35tjie3qRB8fopmoVTdF/Z7+a
         0a7KTBe66baLdCu5FH9UAyL9zS6Lwd1IDXMTG665HJP59O4yeR065uJq6wp4hibJPrTy
         aNv8UL7TOKjNeVVcys3YwZ4BHvMiaDeBJKishbXsmLMQBQIKQ/IF7mtyeXfwenZgYZCn
         Tzzg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=awniDW2yRx7HDyAsi7S/aqrqpwLEo6aGmU5U05hKru8=;
        b=p/QFe/IG+rp9PkhMLdIhZ3m4QHBme+JsaODt6mE0m27yOxqaiAMzoVU5m+yHRI1yYf
         4We50vazdnC8v2jh9CbFwq4dUHP3y+Ro8HJZKaV/Td7QDGEtxOCHGZFaVpet8Qoh2pV2
         eeUyG8DQfFLLxTJ2egxd8oGfz8fz/cW43MBn5EMzdm6FDk2n9AS/6GJnasftyIP5H1Rf
         wvzcU3szwSbwEWA9xx0FzieWPSHQptVFZy+xMniiTfDsrEq647qZ0DkRcJ+bxPtLzGN1
         FuIq2VUyJXB0peqORE1PGVDp3RNYPG2sitwZn1G1g0gtxvFVLY/O1jIVAh2NLuFQLKGg
         Dnag==
X-Gm-Message-State: APjAAAWpzMbr4wl1CxjN5xjlA5eUIfkv3DDwO/DB7RJimB7X/Oi56MM1
        m+z9Y8KkugDwWKwGKaXCZ6kyw113
X-Google-Smtp-Source: APXvYqyojiBQFthHZ2HvPoDZmF7kZKbQdU0+IdK42MN7bMJK2J3DmcpOIUuxYcCMazLrUBLUH6C8hA==
X-Received: by 2002:a17:902:b58c:: with SMTP id a12mr15613377pls.102.1552001656651;
        Thu, 07 Mar 2019 15:34:16 -0800 (PST)
Received: from localhost.localdomain ([2605:e000:d445:6a00:2097:f23b:3b8f:e255])
        by smtp.gmail.com with ESMTPSA id m21sm8684866pfa.14.2019.03.07.15.34.15
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 07 Mar 2019 15:34:16 -0800 (PST)
From:   Steve Longerbeam <slongerbeam@gmail.com>
To:     linux-media@vger.kernel.org
Cc:     Tim Harvey <tharvey@gateworks.com>,
        Steve Longerbeam <slongerbeam@gmail.com>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        dri-devel@lists.freedesktop.org (open list:DRM DRIVERS FOR FREESCALE
        IMX), linux-kernel@vger.kernel.org (open list)
Subject: [PATCH v6 4/7] gpu: ipu-v3: ipu-ic: Add support for Rec.709 encoding
Date:   Thu,  7 Mar 2019 15:33:53 -0800
Message-Id: <20190307233356.23748-5-slongerbeam@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190307233356.23748-1-slongerbeam@gmail.com>
References: <20190307233356.23748-1-slongerbeam@gmail.com>
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Add support for Rec.709 encoding and inverse encoding.

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
 drivers/gpu/ipu-v3/ipu-ic.c | 63 ++++++++++++++++++++++++++++++++-----
 1 file changed, 56 insertions(+), 7 deletions(-)

diff --git a/drivers/gpu/ipu-v3/ipu-ic.c b/drivers/gpu/ipu-v3/ipu-ic.c
index c4048c921801..1460901af9b5 100644
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
@@ -237,11 +254,35 @@ static const struct ic_encode_coeff ic_encode_ycbcr2rgb_601 = {
 	.scale = 2,
 };
 
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
 static int calc_csc_coeffs(struct ipu_ic_priv *priv,
 			   struct ic_encode_coeff *coeff_out,
 			   const struct ipu_ic_colorspace *in,
 			   const struct ipu_ic_colorspace *out)
 {
+	const struct ic_encode_coeff *encode_coeff;
 	bool inverse_encode;
 
 	if (in->colorspace != out->colorspace) {
@@ -249,11 +290,6 @@ static int calc_csc_coeffs(struct ipu_ic_priv *priv,
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
@@ -278,8 +314,21 @@ static int calc_csc_coeffs(struct ipu_ic_priv *priv,
 
 	inverse_encode = (in->cs == IPUV3_COLORSPACE_YUV);
 
-	*coeff_out = inverse_encode ?
-		ic_encode_ycbcr2rgb_601 : ic_encode_rgb2ycbcr_601;
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
 
 	return 0;
 }
-- 
2.17.1

