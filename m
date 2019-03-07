Return-Path: <SRS0=yxRx=RK=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 030DFC43381
	for <linux-media@archiver.kernel.org>; Thu,  7 Mar 2019 23:34:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BA52C20675
	for <linux-media@archiver.kernel.org>; Thu,  7 Mar 2019 23:34:49 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="vYYTd8jr"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726298AbfCGXeO (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Thu, 7 Mar 2019 18:34:14 -0500
Received: from mail-pf1-f193.google.com ([209.85.210.193]:45627 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726172AbfCGXeN (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Thu, 7 Mar 2019 18:34:13 -0500
Received: by mail-pf1-f193.google.com with SMTP id v21so12652470pfm.12;
        Thu, 07 Mar 2019 15:34:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=BxTJVyo12zxZjrDQ66qVuf0dF8xlB+Qw4EySadCp4cE=;
        b=vYYTd8jrhAAtk3m8yGBrTo92TBqIxlXv0WEOKIBhknt6p6sziP7iyy2jyarokUL+iV
         zthcEUaeNNtmt+mXw5TC16kp+38rRjHqYRz/JO7IzwO0S16CIqzx90ZjHgsJPQprA8dO
         60016X5zrYE9VuViU1/InbvlwYf18gXP75psz4V5Dig+qvHapO9XkZLCaR+OLkmiMPAn
         ZJkMDLHOHX/GNNaHdbnzJC7IQVfLlYuyg5WGgdpPbuG5uWmyG2ZwU/3SrL9nAfJlRMRP
         PrWlQpdYkTvZ5SYTKh1V3oMZIRR8nJu73QwAc2ULJ/QtYukgmIlTe4CSHw9alOzF076o
         RpPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=BxTJVyo12zxZjrDQ66qVuf0dF8xlB+Qw4EySadCp4cE=;
        b=fa0GmrR3Q7EYGloGwguIan4aHSsLRcDN0KUOTGHZJ+AHd0Q0remmYsWi5cYaG55+FQ
         muobWZqYMAbJbEOmtqOI2R3Rhtl/JHwHbj2A5I3Y5CHva9JwgB+t6aU7KWH3D0onFX01
         QkB60hUTlgqXwnbxk5WBK1xpGjxWy5k3FwPdhe9WITOJfUftKI4rG8qNzjepvqBnVVwZ
         Plr/zLnykelvIAodiDoAHDMcmgHfolYx6ETObAUQlYn+qbfYVenxKjcxmhROYB4lNdtE
         P+9Awm8Vu7mC6tt0yQo4sIEXhypfQZAH5AALZgtGkck6mjvJeVu0JBNbWjXNz4UHyia5
         ZMHg==
X-Gm-Message-State: APjAAAWXSxY+CpqOC9FSmDBKMrCiItClIJ5cVlBkPwD0yhd1/YRU5rTq
        fRxWmwf83Afmu+JnsB344+xG3pvf
X-Google-Smtp-Source: APXvYqzs23+cR9oeLcpD1hoNRZ3M+kNEQKHlrdRsMqrmYZKf8Qhayb/Zg29rJbjehbLwTEy7i6yE2w==
X-Received: by 2002:a65:64d5:: with SMTP id t21mr13584525pgv.266.1552001651760;
        Thu, 07 Mar 2019 15:34:11 -0800 (PST)
Received: from localhost.localdomain ([2605:e000:d445:6a00:2097:f23b:3b8f:e255])
        by smtp.gmail.com with ESMTPSA id m21sm8684866pfa.14.2019.03.07.15.34.09
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 07 Mar 2019 15:34:11 -0800 (PST)
From:   Steve Longerbeam <slongerbeam@gmail.com>
To:     linux-media@vger.kernel.org
Cc:     Tim Harvey <tharvey@gateworks.com>,
        Steve Longerbeam <slongerbeam@gmail.com>,
        stable@vger.kernel.org, Philipp Zabel <p.zabel@pengutronix.de>,
        dri-devel@lists.freedesktop.org (open list:DRM DRIVERS FOR FREESCALE
        IMX), linux-kernel@vger.kernel.org (open list)
Subject: [PATCH v6 2/7] gpu: ipu-v3: ipu-ic: Fix BT.601 coefficients
Date:   Thu,  7 Mar 2019 15:33:51 -0800
Message-Id: <20190307233356.23748-3-slongerbeam@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190307233356.23748-1-slongerbeam@gmail.com>
References: <20190307233356.23748-1-slongerbeam@gmail.com>
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
 drivers/gpu/ipu-v3/ipu-ic.c | 61 ++++++++++++++++++++++---------------
 1 file changed, 37 insertions(+), 24 deletions(-)

diff --git a/drivers/gpu/ipu-v3/ipu-ic.c b/drivers/gpu/ipu-v3/ipu-ic.c
index 18816ccf600e..b63a2826b629 100644
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
@@ -183,13 +183,15 @@ struct ic_csc_params {
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
+		{  77, 150,  29 },
 		{ 469, 427, 128 },
 		{ 128, 405, 491 },
 	},
@@ -197,8 +199,11 @@ static const struct ic_csc_params ic_csc_rgb2ycbcr = {
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
+		{ 128, 227,   0 },
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

