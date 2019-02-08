Return-Path: <SRS0=EeSY=QP=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 83F24C169C4
	for <linux-media@archiver.kernel.org>; Fri,  8 Feb 2019 19:19:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5503A2177B
	for <linux-media@archiver.kernel.org>; Fri,  8 Feb 2019 19:19:38 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="fwH0P+KH"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727422AbfBHTTh (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Fri, 8 Feb 2019 14:19:37 -0500
Received: from mail-pf1-f194.google.com ([209.85.210.194]:36709 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727417AbfBHTTh (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 8 Feb 2019 14:19:37 -0500
Received: by mail-pf1-f194.google.com with SMTP id d22so2094969pfo.3;
        Fri, 08 Feb 2019 11:19:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=9JhHL5/aksfCmH9dx827g1mYpbbDSTWhMDYItxweaDE=;
        b=fwH0P+KH+AnXBQX9gQKdRgiLAPihtgoDmiPzLKxYB0yoWh72BnAUhPSfwDV1SzdG0z
         Be7p2AYs3KpzTQLzNJagmOBOgUEEQqLmSx4Bhs59FdU3NHh8EDTOArfdPMx2KeZycl8C
         Qbd2R2ZT/zOPVl5on7uTn5k9l1NU/lLelyyW1DxMomyIj62uu/gpDwoVpbLyoNTlNtkD
         U9rRuLqRs4/5vACabF1lj9LiKS9UFPD8lOaqg+FJmORXMF0qy2gxcrytLjqR0RvRbaBQ
         AFFEykW60pR3rxpM8hw1fxVHWEan0lTu0X4CDFwh6tvwA3huSN+pOqDh8v5jALe5pqrx
         eOsA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=9JhHL5/aksfCmH9dx827g1mYpbbDSTWhMDYItxweaDE=;
        b=oMjHKmjDYYfuVEAy3QKBUJs8TyJ8Bke2TkGnuyg0rp9XYpamSyGaAn0O6PGwhkWxLM
         DmdnpiJYneNc0KEIvwYgEgbPXfTTwnWnR6dFM8z6C9NsXkWzzbF/0l6/z3pot7C6gXNo
         TvBzpV6ka3lNVW9VXuT/NwXr6Qab3Jj3JLJbPdjjGsFW3d6A1ozsbNK2l7m2g7SrBYc5
         dhkpL2kGflGZOaz/wvHCTtsbjP+2WCux9C/hLi4vQvmozJgz66Q6fpH2WXwjZXUhuelp
         j6Ds2itHKBl0SLeVSu9ANh45r3XYII6lKN5TEEDbhUQi/GcAD+Xn8+iJrLHyVMd+nlLG
         Masw==
X-Gm-Message-State: AHQUAubyckr1SdQNRwWol/OqnvhhTca1A74/6mlbdSSNAqXnqmVIGhs6
        lA5nlrYMzyMxEoYRWd3aVeeejOyc
X-Google-Smtp-Source: AHgI3IYN71jIZ/yGMj6QsDbb2Eu4vTRwKJZHUjVca+DC6pD2I+PTR6O/zg3L3m2vTlQubpsHnru5xQ==
X-Received: by 2002:a63:fc59:: with SMTP id r25mr6725871pgk.302.1549653576047;
        Fri, 08 Feb 2019 11:19:36 -0800 (PST)
Received: from majic.sklembedded.com (c-73-202-231-77.hsd1.ca.comcast.net. [73.202.231.77])
        by smtp.googlemail.com with ESMTPSA id o5sm4761817pgm.68.2019.02.08.11.19.34
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 08 Feb 2019 11:19:35 -0800 (PST)
From:   Steve Longerbeam <slongerbeam@gmail.com>
X-Google-Original-From: Steve Longerbeam <steve_longerbeam@mentor.com>
To:     linux-media@vger.kernel.org
Cc:     Tim Harvey <tharvey@gateworks.com>,
        Steve Longerbeam <slongerbeam@gmail.com>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        dri-devel@lists.freedesktop.org (open list:DRM DRIVERS FOR FREESCALE
        IMX), linux-kernel@vger.kernel.org (open list)
Subject: [PATCH v2 1/4] gpu: ipu-v3: ipu-ic: Rename yuv2rgb encoding matrices
Date:   Fri,  8 Feb 2019 11:19:25 -0800
Message-Id: <20190208191928.13273-2-steve_longerbeam@mentor.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190208191928.13273-1-steve_longerbeam@mentor.com>
References: <20190208191928.13273-1-steve_longerbeam@mentor.com>
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

From: Steve Longerbeam <slongerbeam@gmail.com>

The ycbcr2rgb and inverse rgb2ycbcr matrices define the BT.601 encoding
coefficients, so rename them to indicate that. And add some comments
to make clear these are BT.601 coefficients encoding between YUV limited
range and RGB full range. The ic_csc_rgb2rgb matrix is just an identity
matrix, so rename to ic_csc_identity. No functional changes.

Signed-off-by: Steve Longerbeam <slongerbeam@gmail.com>
---
Changes in v2:
- rename ic_csc_rgb2rgb matrix to ic_csc_identity.
---
 drivers/gpu/ipu-v3/ipu-ic.c | 21 ++++++++++++++-------
 1 file changed, 14 insertions(+), 7 deletions(-)

diff --git a/drivers/gpu/ipu-v3/ipu-ic.c b/drivers/gpu/ipu-v3/ipu-ic.c
index 594c3cbc8291..3ef61f0b509b 100644
--- a/drivers/gpu/ipu-v3/ipu-ic.c
+++ b/drivers/gpu/ipu-v3/ipu-ic.c
@@ -183,11 +183,13 @@ struct ic_csc_params {
 };
 
 /*
+ * BT.601 encoding from RGB full range to YUV limited range:
+ *
  * Y = R *  .299 + G *  .587 + B *  .114;
  * U = R * -.169 + G * -.332 + B *  .500 + 128.;
  * V = R *  .500 + G * -.419 + B * -.0813 + 128.;
  */
-static const struct ic_csc_params ic_csc_rgb2ycbcr = {
+static const struct ic_csc_params ic_csc_rgb2ycbcr_bt601 = {
 	.coeff = {
 		{ 77, 150, 29 },
 		{ 469, 427, 128 },
@@ -197,8 +199,11 @@ static const struct ic_csc_params ic_csc_rgb2ycbcr = {
 	.scale = 1,
 };
 
-/* transparent RGB->RGB matrix for graphics combining */
-static const struct ic_csc_params ic_csc_rgb2rgb = {
+/*
+ * identity matrix, used for transparent RGB->RGB graphics
+ * combining.
+ */
+static const struct ic_csc_params ic_csc_identity = {
 	.coeff = {
 		{ 128, 0, 0 },
 		{ 0, 128, 0 },
@@ -208,11 +213,13 @@ static const struct ic_csc_params ic_csc_rgb2rgb = {
 };
 
 /*
+ * Inverse BT.601 encoding from YUV limited range to RGB full range:
+ *
  * R = (1.164 * (Y - 16)) + (1.596 * (Cr - 128));
  * G = (1.164 * (Y - 16)) - (0.392 * (Cb - 128)) - (0.813 * (Cr - 128));
  * B = (1.164 * (Y - 16)) + (2.017 * (Cb - 128);
  */
-static const struct ic_csc_params ic_csc_ycbcr2rgb = {
+static const struct ic_csc_params ic_csc_ycbcr2rgb_bt601 = {
 	.coeff = {
 		{ 149, 0, 204 },
 		{ 149, 462, 408 },
@@ -238,11 +245,11 @@ static int init_csc(struct ipu_ic *ic,
 		(priv->tpmem_base + ic->reg->tpmem_csc[csc_index]);
 
 	if (inf == IPUV3_COLORSPACE_YUV && outf == IPUV3_COLORSPACE_RGB)
-		params = &ic_csc_ycbcr2rgb;
+		params = &ic_csc_ycbcr2rgb_bt601;
 	else if (inf == IPUV3_COLORSPACE_RGB && outf == IPUV3_COLORSPACE_YUV)
-		params = &ic_csc_rgb2ycbcr;
+		params = &ic_csc_rgb2ycbcr_bt601;
 	else if (inf == IPUV3_COLORSPACE_RGB && outf == IPUV3_COLORSPACE_RGB)
-		params = &ic_csc_rgb2rgb;
+		params = &ic_csc_identity;
 	else {
 		dev_err(priv->ipu->dev, "Unsupported color space conversion\n");
 		return -EINVAL;
-- 
2.17.1

