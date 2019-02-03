Return-Path: <SRS0=0n2Q=QK=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E6651C169C4
	for <linux-media@archiver.kernel.org>; Sun,  3 Feb 2019 19:48:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9708721773
	for <linux-media@archiver.kernel.org>; Sun,  3 Feb 2019 19:48:13 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="m8/+7D3V"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727919AbfBCTsM (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Sun, 3 Feb 2019 14:48:12 -0500
Received: from mail-pf1-f196.google.com ([209.85.210.196]:36710 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726637AbfBCTsM (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Sun, 3 Feb 2019 14:48:12 -0500
Received: by mail-pf1-f196.google.com with SMTP id b85so5765861pfc.3;
        Sun, 03 Feb 2019 11:48:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=pHmKXMOajx+sKZCyoTb/XhdLePG+iJ3f6Vh1XpVeYDs=;
        b=m8/+7D3V8tDL9ifZWm5f3bVzq2R/IQX/JYemcNXZ8inL8z/4BwFmddoSc4sSYrR5+J
         wFoQGQF61VsF8OAlBWt9CcWYZfTRVPXUNw1N/KlGJbhWSE/qJ5u+T1q/bh6gKt8Mp0o+
         YRdWeqcovDJxco6Vyyy2oZV7xGBHmwd+JkV50VUoKiY+o1Aj/h+Z7ccyqDPN91DnB+gw
         AfaJpc1WXMwBAK94EWdscBc3c6ox/Nkw7alnrX/Ky1SnfIEJ5OelpBLCaL7v9QdrOZk9
         +bvlLrQo7jfvB/N3X+CgM11QVmCkL7tV6dsUGgaQLlzMlT56EimxRR3EPwl1cTKqtmhu
         glGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=pHmKXMOajx+sKZCyoTb/XhdLePG+iJ3f6Vh1XpVeYDs=;
        b=guEdcJyEocTTpEB5T6e0fFyRoqyYCmDfv8SBmopDrqtr437J6AhEMAwha4cd2bnLoZ
         1Ar0ELN6Xw9knHM5xLlT/aLsNFRlLFDaDNw1E/ECLYZT4TjuUVVRDuy7WSReoQ0UQv/V
         9xAm+X2taehTnbkB5BrLt4HgZwldNOItt/Fp7b6k6HCPsAQy0VlpTs7Lage8E7UjTC1z
         lt8kB7SXCzhoietGJPdL9lQVu8N2tU+FCei3TnkeW5QeIQRC7Ezw5mjxy59rKqTNDY1x
         sj7gvC6aIrZCzYnqgEBRmkwmaNGq3KanBKMAw9nd+ZJQDIj2xdfPjB6oIg8oYudcSwZy
         E4Hg==
X-Gm-Message-State: AHQUAuZNVXPCuMoG2t0dKwrUqkCtOpLbHDGIaHca6IVcXOZlHYbjCzsj
        JWheT3ZOfUd3wNZXJBl5E7sMgjgy
X-Google-Smtp-Source: AHgI3IbsKF2WeAmIU3EXtt/UITniu7WOl8mE4J+KnnW7x2+MQs80SwjwBFBRES2m7LBxj/wWcJU68w==
X-Received: by 2002:a63:8742:: with SMTP id i63mr10328767pge.298.1549223290278;
        Sun, 03 Feb 2019 11:48:10 -0800 (PST)
Received: from mappy.world.mentorg.com (sjewanfw1-nat.mentorg.com. [139.181.7.34])
        by smtp.gmail.com with ESMTPSA id f67sm23487724pff.29.2019.02.03.11.48.03
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 03 Feb 2019 11:48:09 -0800 (PST)
From:   Steve Longerbeam <slongerbeam@gmail.com>
To:     linux-media@vger.kernel.org
Cc:     Tim Harvey <tharvey@gateworks.com>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Steve Longerbeam <slongerbeam@gmail.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        dri-devel@lists.freedesktop.org (open list:DRM DRIVERS FOR FREESCALE
        IMX), linux-kernel@vger.kernel.org (open list),
        devel@driverdev.osuosl.org (open list:STAGING SUBSYSTEM),
        linux-fbdev@vger.kernel.org (open list:FRAMEBUFFER LAYER)
Subject: [PATCH 2/3] gpu: ipu-v3: ipu-ic: Add support for BT.709 encoding
Date:   Sun,  3 Feb 2019 11:47:43 -0800
Message-Id: <20190203194744.11546-3-slongerbeam@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190203194744.11546-1-slongerbeam@gmail.com>
References: <20190203194744.11546-1-slongerbeam@gmail.com>
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Pass v4l2 encoding enum to the ipu_ic task init functions, and add
support for the BT.709 encoding and inverse encoding matrices.

Reported-by: Tim Harvey <tharvey@gateworks.com>
Signed-off-by: Steve Longerbeam <slongerbeam@gmail.com>
---
 drivers/gpu/ipu-v3/ipu-ic.c                 | 67 ++++++++++++++++++---
 drivers/gpu/ipu-v3/ipu-image-convert.c      |  1 +
 drivers/staging/media/imx/imx-ic-prpencvf.c |  4 +-
 include/video/imx-ipu-v3.h                  |  5 +-
 4 files changed, 67 insertions(+), 10 deletions(-)

diff --git a/drivers/gpu/ipu-v3/ipu-ic.c b/drivers/gpu/ipu-v3/ipu-ic.c
index 35ae86ff0585..63362b4fff81 100644
--- a/drivers/gpu/ipu-v3/ipu-ic.c
+++ b/drivers/gpu/ipu-v3/ipu-ic.c
@@ -199,6 +199,23 @@ static const struct ic_csc_params ic_csc_rgb2ycbcr_bt601 = {
 	.scale = 1,
 };
 
+/*
+ * BT.709 encoding from RGB full range to YUV limited range:
+ *
+ * Y = R *  .2126 + G *  .7152 + B *  .0722;
+ * U = R * -.1146 + G * -.3854 + B *  .5000 + 128.;
+ * V = R *  .5000 + G * -.4542 + B * -.0458 + 128.;
+ */
+static const struct ic_csc_params ic_csc_rgb2ycbcr_bt709 = {
+	.coeff = {
+		{ 54, 183, 18 },
+		{ 483, 413, 128 },
+		{ 128, 396, 500 },
+	},
+	.offset = { 0, 512, 512 },
+	.scale = 1,
+};
+
 /* transparent RGB->RGB matrix for graphics combining */
 static const struct ic_csc_params ic_csc_rgb2rgb = {
 	.coeff = {
@@ -226,12 +243,31 @@ static const struct ic_csc_params ic_csc_ycbcr2rgb_bt601 = {
 	.scale = 2,
 };
 
+/*
+ * Inverse BT.709 encoding from YUV limited range to RGB full range:
+ *
+ * R = (1. * (Y - 16)) + (1.5748 * (Cr - 128));
+ * G = (1. * (Y - 16)) - (0.1873 * (Cb - 128)) - (0.4681 * (Cr - 128));
+ * B = (1. * (Y - 16)) + (1.8556 * (Cb - 128);
+ */
+static const struct ic_csc_params ic_csc_ycbcr2rgb_bt709 = {
+	.coeff = {
+		{ 128, 0, 202 },
+		{ 128, 488, 452 },
+		{ 128, 238, 0 },
+	},
+	.offset = { -435, 136, -507 },
+	.scale = 2,
+};
+
 static int init_csc(struct ipu_ic *ic,
 		    enum ipu_color_space inf,
 		    enum ipu_color_space outf,
+		    enum v4l2_ycbcr_encoding encoding,
 		    int csc_index)
 {
 	struct ipu_ic_priv *priv = ic->priv;
+	const struct ic_csc_params *params_rgb2yuv, *params_yuv2rgb;
 	const struct ic_csc_params *params;
 	u32 __iomem *base;
 	const u16 (*c)[3];
@@ -241,10 +277,24 @@ static int init_csc(struct ipu_ic *ic,
 	base = (u32 __iomem *)
 		(priv->tpmem_base + ic->reg->tpmem_csc[csc_index]);
 
+	switch (encoding) {
+	case V4L2_YCBCR_ENC_601:
+		params_rgb2yuv =  &ic_csc_rgb2ycbcr_bt601;
+		params_yuv2rgb = &ic_csc_ycbcr2rgb_bt601;
+		break;
+	case V4L2_YCBCR_ENC_709:
+		params_rgb2yuv =  &ic_csc_rgb2ycbcr_bt709;
+		params_yuv2rgb = &ic_csc_ycbcr2rgb_bt709;
+		break;
+	default:
+		dev_err(priv->ipu->dev, "Unsupported YCbCr encoding\n");
+		return -EINVAL;
+	}
+
 	if (inf == IPUV3_COLORSPACE_YUV && outf == IPUV3_COLORSPACE_RGB)
-		params = &ic_csc_ycbcr2rgb_bt601;
+		params = params_yuv2rgb;
 	else if (inf == IPUV3_COLORSPACE_RGB && outf == IPUV3_COLORSPACE_YUV)
-		params = &ic_csc_rgb2ycbcr_bt601;
+		params = params_rgb2yuv;
 	else if (inf == IPUV3_COLORSPACE_RGB && outf == IPUV3_COLORSPACE_RGB)
 		params = &ic_csc_rgb2rgb;
 	else {
@@ -391,6 +441,7 @@ EXPORT_SYMBOL_GPL(ipu_ic_task_disable);
 
 int ipu_ic_task_graphics_init(struct ipu_ic *ic,
 			      enum ipu_color_space in_g_cs,
+			      enum v4l2_ycbcr_encoding encoding,
 			      bool galpha_en, u32 galpha,
 			      bool colorkey_en, u32 colorkey)
 {
@@ -409,7 +460,7 @@ int ipu_ic_task_graphics_init(struct ipu_ic *ic,
 	if (!(ic_conf & ic->bit->ic_conf_csc1_en)) {
 		/* need transparent CSC1 conversion */
 		ret = init_csc(ic, IPUV3_COLORSPACE_RGB,
-			       IPUV3_COLORSPACE_RGB, 0);
+			       IPUV3_COLORSPACE_RGB, encoding, 0);
 		if (ret)
 			goto unlock;
 	}
@@ -417,7 +468,7 @@ int ipu_ic_task_graphics_init(struct ipu_ic *ic,
 	ic->g_in_cs = in_g_cs;
 
 	if (ic->g_in_cs != ic->out_cs) {
-		ret = init_csc(ic, ic->g_in_cs, ic->out_cs, 1);
+		ret = init_csc(ic, ic->g_in_cs, ic->out_cs, encoding, 1);
 		if (ret)
 			goto unlock;
 	}
@@ -451,6 +502,7 @@ int ipu_ic_task_init_rsc(struct ipu_ic *ic,
 			 int out_width, int out_height,
 			 enum ipu_color_space in_cs,
 			 enum ipu_color_space out_cs,
+			 enum v4l2_ycbcr_encoding encoding,
 			 u32 rsc)
 {
 	struct ipu_ic_priv *priv = ic->priv;
@@ -486,7 +538,7 @@ int ipu_ic_task_init_rsc(struct ipu_ic *ic,
 	ic->out_cs = out_cs;
 
 	if (ic->in_cs != ic->out_cs) {
-		ret = init_csc(ic, ic->in_cs, ic->out_cs, 0);
+		ret = init_csc(ic, ic->in_cs, ic->out_cs, encoding, 0);
 		if (ret)
 			goto unlock;
 	}
@@ -500,10 +552,11 @@ int ipu_ic_task_init(struct ipu_ic *ic,
 		     int in_width, int in_height,
 		     int out_width, int out_height,
 		     enum ipu_color_space in_cs,
-		     enum ipu_color_space out_cs)
+		     enum ipu_color_space out_cs,
+		     enum v4l2_ycbcr_encoding encoding)
 {
 	return ipu_ic_task_init_rsc(ic, in_width, in_height, out_width,
-				    out_height, in_cs, out_cs, 0);
+				    out_height, in_cs, out_cs, encoding, 0);
 }
 EXPORT_SYMBOL_GPL(ipu_ic_task_init);
 
diff --git a/drivers/gpu/ipu-v3/ipu-image-convert.c b/drivers/gpu/ipu-v3/ipu-image-convert.c
index 13103ab86050..8b37daa99f58 100644
--- a/drivers/gpu/ipu-v3/ipu-image-convert.c
+++ b/drivers/gpu/ipu-v3/ipu-image-convert.c
@@ -1358,6 +1358,7 @@ static int convert_start(struct ipu_image_convert_run *run, unsigned int tile)
 			       dest_width,
 			       dest_height,
 			       src_cs, dest_cs,
+			       d_image->base.pix.ycbcr_enc,
 			       rsc);
 	if (ret) {
 		dev_err(priv->ipu->dev, "ipu_ic_task_init failed, %d\n", ret);
diff --git a/drivers/staging/media/imx/imx-ic-prpencvf.c b/drivers/staging/media/imx/imx-ic-prpencvf.c
index 3637693c2bc8..c86d5275db46 100644
--- a/drivers/staging/media/imx/imx-ic-prpencvf.c
+++ b/drivers/staging/media/imx/imx-ic-prpencvf.c
@@ -484,7 +484,7 @@ static int prp_setup_rotation(struct prp_priv *priv)
 	ret = ipu_ic_task_init(priv->ic,
 			       infmt->width, infmt->height,
 			       outfmt->height, outfmt->width,
-			       incc->cs, outcc->cs);
+			       incc->cs, outcc->cs, outfmt->ycbcr_enc);
 	if (ret) {
 		v4l2_err(&ic_priv->sd, "ipu_ic_task_init failed, %d\n", ret);
 		goto free_rot1;
@@ -587,7 +587,7 @@ static int prp_setup_norotation(struct prp_priv *priv)
 	ret = ipu_ic_task_init(priv->ic,
 			       infmt->width, infmt->height,
 			       outfmt->width, outfmt->height,
-			       incc->cs, outcc->cs);
+			       incc->cs, outcc->cs, outfmt->ycbcr_enc);
 	if (ret) {
 		v4l2_err(&ic_priv->sd, "ipu_ic_task_init failed, %d\n", ret);
 		return ret;
diff --git a/include/video/imx-ipu-v3.h b/include/video/imx-ipu-v3.h
index c887f4bee5f8..b19d1e23eece 100644
--- a/include/video/imx-ipu-v3.h
+++ b/include/video/imx-ipu-v3.h
@@ -391,15 +391,18 @@ int ipu_ic_task_init(struct ipu_ic *ic,
 		     int in_width, int in_height,
 		     int out_width, int out_height,
 		     enum ipu_color_space in_cs,
-		     enum ipu_color_space out_cs);
+		     enum ipu_color_space out_cs,
+		     enum v4l2_ycbcr_encoding encoding);
 int ipu_ic_task_init_rsc(struct ipu_ic *ic,
 			 int in_width, int in_height,
 			 int out_width, int out_height,
 			 enum ipu_color_space in_cs,
 			 enum ipu_color_space out_cs,
+			 enum v4l2_ycbcr_encoding encoding,
 			 u32 rsc);
 int ipu_ic_task_graphics_init(struct ipu_ic *ic,
 			      enum ipu_color_space in_g_cs,
+			      enum v4l2_ycbcr_encoding encoding,
 			      bool galpha_en, u32 galpha,
 			      bool colorkey_en, u32 colorkey);
 void ipu_ic_task_enable(struct ipu_ic *ic);
-- 
2.17.1

