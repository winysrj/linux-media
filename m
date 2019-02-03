Return-Path: <SRS0=0n2Q=QK=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.2 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,UNWANTED_LANGUAGE_BODY,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D10DFC282DA
	for <linux-media@archiver.kernel.org>; Sun,  3 Feb 2019 19:48:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9F52B21773
	for <linux-media@archiver.kernel.org>; Sun,  3 Feb 2019 19:48:08 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ZdnPZGKI"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727502AbfBCTsE (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Sun, 3 Feb 2019 14:48:04 -0500
Received: from mail-pf1-f196.google.com ([209.85.210.196]:46830 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726637AbfBCTsE (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Sun, 3 Feb 2019 14:48:04 -0500
Received: by mail-pf1-f196.google.com with SMTP id c73so5734478pfe.13;
        Sun, 03 Feb 2019 11:48:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=7lxqbLiE+uIi/LoSq4/IqkPXxqEo9I5bwA9g+I5eDek=;
        b=ZdnPZGKIEA3v89NWtXxpCl/iUJ1VLiKY/zDd+qDGoAO0v2KdjcJiIrTbGslWIhhk2D
         wF2wesSS+drUw4G56h1ltBuc/05ELgm7RkSse/1PMYNkhF+yQaUqPL67BoKjZ/zdQmPM
         aKU33AmiZdFdIJ3HxscOeFfDFfFEURicoqy+M6PjCK3dm9ExdUIlQf/SY05/f0uDDLkw
         eEzMGGf8CgInjvSj0/DjP/QUI7bo6A3x2gruBRx0JzoT7C8/HXtq3AG7Z+/+ih5n1P6C
         JhC3PTM85H+0TwlCdo/YyQtlGEN/1eF4jch0h+8qlyu36DzLG93EhaaQqLaH5VDVMDSZ
         HBJw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=7lxqbLiE+uIi/LoSq4/IqkPXxqEo9I5bwA9g+I5eDek=;
        b=k+QhOgekWmHzR+ie559xUbRA1yKiYuJWCR3w5H/CuSeiOVtMevgPIQb67WYJey/Kn1
         QMt6+1TMunDwsfg36BwChhxKHo5BWpPtikc4s0IHal2fjNWgZ5KetZc4Q90uaaXLeqWc
         DLP6ZxuZW6U5GdzSUhNjVm7bZwn91d8Jo7Z5ryUblValKrestGde5vpno9a5bZ0tsvlO
         jeXQclcxQoceHXxWBh0F69q/WXEWDz+5ERnTRwZBadj8gpeqZEkzIoxqUx/DFNHRdQrm
         dZUFcq47hqq19Zz+ssNnPdRU8l7mxQJooPGHbPte2EhKfy2FIrtuXwM3GR7OwicKGwIe
         iviA==
X-Gm-Message-State: AHQUAuYtRyc7KxE3K398ZTLxbOq9F7fP52xcjPeyFgAeOvalPbCUmAc0
        rYR5GDnAGBtz8VT2nLPVGgXHP9zh
X-Google-Smtp-Source: AHgI3IYZaCWA9gzHCO4wVaXjPR43e8cqRbPC4Vxo/whUSSfQOL0cxxWhyeVowc8NBTLR3IFEKL5aTg==
X-Received: by 2002:a63:bd1a:: with SMTP id a26mr10361787pgf.121.1549223283149;
        Sun, 03 Feb 2019 11:48:03 -0800 (PST)
Received: from mappy.world.mentorg.com (sjewanfw1-nat.mentorg.com. [139.181.7.34])
        by smtp.gmail.com with ESMTPSA id f67sm23487724pff.29.2019.02.03.11.47.58
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 03 Feb 2019 11:48:02 -0800 (PST)
From:   Steve Longerbeam <slongerbeam@gmail.com>
To:     linux-media@vger.kernel.org
Cc:     Tim Harvey <tharvey@gateworks.com>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Steve Longerbeam <slongerbeam@gmail.com>,
        dri-devel@lists.freedesktop.org (open list:DRM DRIVERS FOR FREESCALE
        IMX), linux-kernel@vger.kernel.org (open list)
Subject: [PATCH 1/3] gpu: ipu-v3: ipu-ic: Rename yuv2rgb encoding matrices
Date:   Sun,  3 Feb 2019 11:47:42 -0800
Message-Id: <20190203194744.11546-2-slongerbeam@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190203194744.11546-1-slongerbeam@gmail.com>
References: <20190203194744.11546-1-slongerbeam@gmail.com>
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

The ycbcr2rgb and inverse rgb2ycbcr matrices define the BT.601 encoding
coefficients, so rename them to indicate that. And add some comments
to make clear these are BT.601 coefficients encoding between YUV limited
range and RGB full range. No functional changes.

Signed-off-by: Steve Longerbeam <slongerbeam@gmail.com>
---
 drivers/gpu/ipu-v3/ipu-ic.c | 12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/drivers/gpu/ipu-v3/ipu-ic.c b/drivers/gpu/ipu-v3/ipu-ic.c
index 594c3cbc8291..35ae86ff0585 100644
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
@@ -208,11 +210,13 @@ static const struct ic_csc_params ic_csc_rgb2rgb = {
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
@@ -238,9 +242,9 @@ static int init_csc(struct ipu_ic *ic,
 		(priv->tpmem_base + ic->reg->tpmem_csc[csc_index]);
 
 	if (inf == IPUV3_COLORSPACE_YUV && outf == IPUV3_COLORSPACE_RGB)
-		params = &ic_csc_ycbcr2rgb;
+		params = &ic_csc_ycbcr2rgb_bt601;
 	else if (inf == IPUV3_COLORSPACE_RGB && outf == IPUV3_COLORSPACE_YUV)
-		params = &ic_csc_rgb2ycbcr;
+		params = &ic_csc_rgb2ycbcr_bt601;
 	else if (inf == IPUV3_COLORSPACE_RGB && outf == IPUV3_COLORSPACE_RGB)
 		params = &ic_csc_rgb2rgb;
 	else {
-- 
2.17.1

