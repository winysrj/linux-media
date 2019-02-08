Return-Path: <SRS0=EeSY=QP=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CF8C0C169C4
	for <linux-media@archiver.kernel.org>; Fri,  8 Feb 2019 19:20:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 937272177B
	for <linux-media@archiver.kernel.org>; Fri,  8 Feb 2019 19:20:00 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="GF2uiZ9g"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727605AbfBHTT7 (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Fri, 8 Feb 2019 14:19:59 -0500
Received: from mail-pg1-f196.google.com ([209.85.215.196]:37098 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727480AbfBHTTl (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 8 Feb 2019 14:19:41 -0500
Received: by mail-pg1-f196.google.com with SMTP id c25so2001927pgb.4;
        Fri, 08 Feb 2019 11:19:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=YabknfUBWKDakYKaYZSCxJoQF69XtL+rIW7dOLCWsyo=;
        b=GF2uiZ9gJWomLrhnQqchMQV8IyWxd3gcNrVEkdGoxJXrDHmHVGV2A+ylv7KfTBGIz1
         PKFR8Od9SHTV4C3/2uZuiR6cip0Khk9N/h9HRsF9SwOihhXq6ew8HUArcgV7KB5zOcBt
         VhG5Pk3/TD25SGIM4KRE6DD09x2jDHea90ebNudVRARcUDGqb3RQmO0H4NN1cAM0oyL8
         jVXOdy2+VWaiaUgbofRu98dQUlE7svyGKClVJHaw2tJjweKm0QbWC8QhASTPZ5J7WHKZ
         pWnjrclYPZHCoXsjjHSQsp1YdLCWkSfwKobG2pQ4/aolh/5IRVWRiQuSzpT5UgHbugLg
         MHwA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=YabknfUBWKDakYKaYZSCxJoQF69XtL+rIW7dOLCWsyo=;
        b=AEEgDVtEpaZpbWsCKc/Nkzql83HfxOdu0HwThm0hfJO0uLPjhssTk4OrnfBmbCivKN
         mamvEK+I54U1TUb1rTgFZ4i+59dKaSicP9PhGv5fHdBiMcR1PWUgrtg3IqwUPbQO7egQ
         UTweAQ+ZvV7KQisOTExvqvS4223F+hInoodR7wAJYoTadbqqv+aomEUNPBAdruXLQXXl
         XSee+15tJOaHm3q/ZvMewClGfUb/YPhDHTdIWvzRlUp8rvXyj6O/FGfGCNLmi/7q95+0
         ZIr6zBg0dTXCupyJbRh7VXbTdnygK6EDMLUC+xfM76+GISdF1Xy4xJgrjUIyxBkQK4Vi
         giCg==
X-Gm-Message-State: AHQUAubQajblFJOw1SFPTldcQIosMeRQ8Cb4EfJV32Yv5C9WQqsnHST3
        zABwOe4KGQvpXVG7QP4/DjwrW82w
X-Google-Smtp-Source: AHgI3IbUiivXujc3T5H8n7Tjxcdk/fsBh8tSd0BZj6QnHduBmB1F3NH+IvCSpOOrFPvUG4TauQQ1TA==
X-Received: by 2002:a63:2263:: with SMTP id t35mr12013056pgm.69.1549653579354;
        Fri, 08 Feb 2019 11:19:39 -0800 (PST)
Received: from majic.sklembedded.com (c-73-202-231-77.hsd1.ca.comcast.net. [73.202.231.77])
        by smtp.googlemail.com with ESMTPSA id o5sm4761817pgm.68.2019.02.08.11.19.37
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 08 Feb 2019 11:19:38 -0800 (PST)
From:   Steve Longerbeam <slongerbeam@gmail.com>
X-Google-Original-From: Steve Longerbeam <steve_longerbeam@mentor.com>
To:     linux-media@vger.kernel.org
Cc:     Tim Harvey <tharvey@gateworks.com>,
        Steve Longerbeam <slongerbeam@gmail.com>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        dri-devel@lists.freedesktop.org (open list:DRM DRIVERS FOR FREESCALE
        IMX), linux-kernel@vger.kernel.org (open list),
        devel@driverdev.osuosl.org (open list:STAGING SUBSYSTEM),
        linux-fbdev@vger.kernel.org (open list:FRAMEBUFFER LAYER)
Subject: [PATCH v2 3/4] gpu: ipu-v3: ipu-ic: Add support for BT.709 encoding
Date:   Fri,  8 Feb 2019 11:19:27 -0800
Message-Id: <20190208191928.13273-4-steve_longerbeam@mentor.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190208191928.13273-1-steve_longerbeam@mentor.com>
References: <20190208191928.13273-1-steve_longerbeam@mentor.com>
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

From: Steve Longerbeam <slongerbeam@gmail.com>

Pass v4l2 encoding enum to the ipu_ic task init functions, and add
support for the BT.709 encoding and inverse encoding matrices.

Reported-by: Tim Harvey <tharvey@gateworks.com>
Signed-off-by: Steve Longerbeam <slongerbeam@gmail.com>
---
Changes in v2:
- only return "Unsupported YCbCr encoding" error if inf != outf,
  since if inf == outf, the identity matrix can be used. Reported
  by Tim Harvey.
---
 drivers/gpu/ipu-v3/ipu-ic.c                 | 71 +++++++++++++++++++--
 drivers/gpu/ipu-v3/ipu-image-convert.c      |  1 +
 drivers/staging/media/imx/imx-ic-prpencvf.c |  4 +-
 include/video/imx-ipu-v3.h                  |  5 +-
 4 files changed, 71 insertions(+), 10 deletions(-)

diff --git a/drivers/gpu/ipu-v3/ipu-ic.c b/drivers/gpu/ipu-v3/ipu-ic.c
index e459615a49a1..0d57ca7ba18e 100644
--- a/drivers/gpu/ipu-v3/ipu-ic.c
+++ b/drivers/gpu/ipu-v3/ipu-ic.c
@@ -212,6 +212,23 @@ static const struct ic_csc_params ic_csc_identity = {
 	.scale = 2,
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
 /*
  * Inverse BT.601 encoding from YUV limited range to RGB full range:
  *
@@ -229,12 +246,31 @@ static const struct ic_csc_params ic_csc_ycbcr2rgb_bt601 = {
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
@@ -244,12 +280,30 @@ static int init_csc(struct ipu_ic *ic,
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
+		if (inf != outf) {
+			dev_err(priv->ipu->dev,
+				"Unsupported YCbCr encoding\n");
+			return -EINVAL;
+		}
+		break;
+	}
+
 	if (inf == outf)
 		params = &ic_csc_identity;
 	else if (inf == IPUV3_COLORSPACE_YUV)
-		params = &ic_csc_ycbcr2rgb_bt601;
+		params = &ic_csc_ycbcr2rgb;
 	else
-		params = &ic_csc_rgb2ycbcr_bt601;
+		params = &ic_csc_rgb2ycbcr;
 
 	/* Cast to unsigned */
 	c = (const u16 (*)[3])params->coeff;
@@ -390,6 +444,7 @@ EXPORT_SYMBOL_GPL(ipu_ic_task_disable);
 
 int ipu_ic_task_graphics_init(struct ipu_ic *ic,
 			      enum ipu_color_space in_g_cs,
+			      enum v4l2_ycbcr_encoding encoding,
 			      bool galpha_en, u32 galpha,
 			      bool colorkey_en, u32 colorkey)
 {
@@ -408,7 +463,7 @@ int ipu_ic_task_graphics_init(struct ipu_ic *ic,
 	if (!(ic_conf & ic->bit->ic_conf_csc1_en)) {
 		/* need transparent CSC1 conversion */
 		ret = init_csc(ic, IPUV3_COLORSPACE_RGB,
-			       IPUV3_COLORSPACE_RGB, 0);
+			       IPUV3_COLORSPACE_RGB, encoding, 0);
 		if (ret)
 			goto unlock;
 	}
@@ -416,7 +471,7 @@ int ipu_ic_task_graphics_init(struct ipu_ic *ic,
 	ic->g_in_cs = in_g_cs;
 
 	if (ic->g_in_cs != ic->out_cs) {
-		ret = init_csc(ic, ic->g_in_cs, ic->out_cs, 1);
+		ret = init_csc(ic, ic->g_in_cs, ic->out_cs, encoding, 1);
 		if (ret)
 			goto unlock;
 	}
@@ -450,6 +505,7 @@ int ipu_ic_task_init_rsc(struct ipu_ic *ic,
 			 int out_width, int out_height,
 			 enum ipu_color_space in_cs,
 			 enum ipu_color_space out_cs,
+			 enum v4l2_ycbcr_encoding encoding,
 			 u32 rsc)
 {
 	struct ipu_ic_priv *priv = ic->priv;
@@ -485,7 +541,7 @@ int ipu_ic_task_init_rsc(struct ipu_ic *ic,
 	ic->out_cs = out_cs;
 
 	if (ic->in_cs != ic->out_cs) {
-		ret = init_csc(ic, ic->in_cs, ic->out_cs, 0);
+		ret = init_csc(ic, ic->in_cs, ic->out_cs, encoding, 0);
 		if (ret)
 			goto unlock;
 	}
@@ -499,10 +555,11 @@ int ipu_ic_task_init(struct ipu_ic *ic,
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
index 376b504e8a42..60ecf5809cc1 100644
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

