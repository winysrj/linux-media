Return-Path: <SRS0=99fO=RB=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DCC06C43381
	for <linux-media@archiver.kernel.org>; Tue, 26 Feb 2019 17:05:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id AA53F20C01
	for <linux-media@archiver.kernel.org>; Tue, 26 Feb 2019 17:05:53 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="JXOIQL/H"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728632AbfBZRFx (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Tue, 26 Feb 2019 12:05:53 -0500
Received: from mail-wm1-f66.google.com ([209.85.128.66]:36034 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727416AbfBZRFw (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 26 Feb 2019 12:05:52 -0500
Received: by mail-wm1-f66.google.com with SMTP id j125so2973421wmj.1
        for <linux-media@vger.kernel.org>; Tue, 26 Feb 2019 09:05:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=heYc5STj/DtjwMTB1aRdzi/H1gIEy4dN2wTw1s5CEaI=;
        b=JXOIQL/HsoHmTi0uxHLUcajVcntBP3QZ8sjyRBYVIiyucHihYwuG4acPBIJVGpNt+I
         cedrZV//6I8K09elW/k8WpPaClFDKs1kCZrNROpXwPlgp3qS3yDBW3Co2jjLyUec1Iip
         bCltfu2gwAofJSftmQQI5806+H+I9uvhZu+Yy/78+nMDeBq6xgsrBvtCvfp1m4QrCc1P
         Th+QGCKbw40N6FGqxlTS/lHfR3/DgR79Qy19J4uRfqIm0SmX9MVVQUe2zomttP24zzTT
         RuU8cyDvEdk6YpYo8VEq11QXARDFyoeSrz9VQ8zgL1HYr6MzUyx2qmpsBxqYCUKwbhrz
         n00Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=heYc5STj/DtjwMTB1aRdzi/H1gIEy4dN2wTw1s5CEaI=;
        b=XCpO3dFDFN1jSiS1bf79bgJYx74JuYT3KBrEOIMnPUHE9w4decUjwfKsXQjtTI3+g1
         GCK+ddzgCF8h2Zl+6WZHAWI0xTkcmoZ9ZfFg3xuPmy96BnyGw94EVYNKkJHp3yZ2Xm/B
         1gNmQIw6x05OzuyitVAftR4pkdpuB1enBniRYNbwyhn694gsYXx3XbdLI63qswZ6YJMC
         qqx7Ic3ExP945SIjuGXuaTaqbS/W/UDmkw4ICTvto84RoIFczqIMxpcCZV3jpQ7v/VrD
         Jdc7qePW5Fy8mcNyzA0CjM3QGAhvnNmanmYiq8JCevht56mLIj4sT54SvKy4SChZNOa8
         h1NQ==
X-Gm-Message-State: AHQUAuan+jvC7NIDfcoQULQWSr4xG00iEk1CumPIxI8PVaNto8MKaT4S
        pBevVfU0oG17OBa07lAAwGj6sDNRvec=
X-Google-Smtp-Source: AHgI3IapeyZNBA954rH5c1+E9THU16Xdu2xBWO2gdBykx8z7uRk85cpQmxLvO94jpjHr3M04r47rnw==
X-Received: by 2002:a1c:67c2:: with SMTP id b185mr3376356wmc.68.1551200750271;
        Tue, 26 Feb 2019 09:05:50 -0800 (PST)
Received: from ubuntu.home ([77.127.107.32])
        by smtp.gmail.com with ESMTPSA id w4sm21024486wrk.85.2019.02.26.09.05.49
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 26 Feb 2019 09:05:49 -0800 (PST)
From:   Dafna Hirschfeld <dafna3@gmail.com>
To:     linux-media@vger.kernel.org
Cc:     hverkuil@xs4all.nl, helen.koike@collabora.com,
        Dafna Hirschfeld <dafna3@gmail.com>
Subject: [PATCH v5 14/21] media: vicodec: rename v4l2_fwht_default_fmt to v4l2_fwht_find_nth_fmt
Date:   Tue, 26 Feb 2019 09:05:07 -0800
Message-Id: <20190226170514.86127-15-dafna3@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190226170514.86127-1-dafna3@gmail.com>
References: <20190226170514.86127-1-dafna3@gmail.com>
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Rename 'v4l2_fwht_default_fmt' to 'v4l2_fwht_find_nth_fmt'
and add a function 'v4l2_fwht_validate_fmt' to check if
a format info matches the parameters.
This function will also be used to validate the stateless
params when adding support for stateless codecs.

Signed-off-by: Dafna Hirschfeld <dafna3@gmail.com>
---
 .../media/platform/vicodec/codec-v4l2-fwht.c  | 22 ++++++++++++++-----
 .../media/platform/vicodec/codec-v4l2-fwht.h  |  5 ++++-
 drivers/media/platform/vicodec/vicodec-core.c |  4 ++--
 3 files changed, 23 insertions(+), 8 deletions(-)

diff --git a/drivers/media/platform/vicodec/codec-v4l2-fwht.c b/drivers/media/platform/vicodec/codec-v4l2-fwht.c
index f15d76fae45c..372ed95e1a1f 100644
--- a/drivers/media/platform/vicodec/codec-v4l2-fwht.c
+++ b/drivers/media/platform/vicodec/codec-v4l2-fwht.c
@@ -37,7 +37,19 @@ static const struct v4l2_fwht_pixfmt_info v4l2_fwht_pixfmts[] = {
 	{ V4L2_PIX_FMT_GREY,    1, 1, 1, 1, 0, 1, 1, 1, 1, FWHT_FL_PIXENC_RGB},
 };
 
-const struct v4l2_fwht_pixfmt_info *v4l2_fwht_default_fmt(u32 width_div,
+bool v4l2_fwht_validate_fmt(const struct v4l2_fwht_pixfmt_info *info,
+			    u32 width_div, u32 height_div, u32 components_num,
+			    u32 pixenc)
+{
+	if (info->width_div == width_div &&
+	    info->height_div == height_div &&
+	    (!pixenc || info->pixenc == pixenc) &&
+	    info->components_num == components_num)
+		return true;
+	return false;
+}
+
+const struct v4l2_fwht_pixfmt_info *v4l2_fwht_find_nth_fmt(u32 width_div,
 							  u32 height_div,
 							  u32 components_num,
 							  u32 pixenc,
@@ -46,10 +58,10 @@ const struct v4l2_fwht_pixfmt_info *v4l2_fwht_default_fmt(u32 width_div,
 	unsigned int i;
 
 	for (i = 0; i < ARRAY_SIZE(v4l2_fwht_pixfmts); i++) {
-		if (v4l2_fwht_pixfmts[i].width_div == width_div &&
-		    v4l2_fwht_pixfmts[i].height_div == height_div &&
-		    (!pixenc || v4l2_fwht_pixfmts[i].pixenc == pixenc) &&
-		    v4l2_fwht_pixfmts[i].components_num == components_num) {
+		bool is_valid = v4l2_fwht_validate_fmt(&v4l2_fwht_pixfmts[i],
+						       width_div, height_div,
+						       components_num, pixenc);
+		if (is_valid) {
 			if (start_idx == 0)
 				return v4l2_fwht_pixfmts + i;
 			start_idx--;
diff --git a/drivers/media/platform/vicodec/codec-v4l2-fwht.h b/drivers/media/platform/vicodec/codec-v4l2-fwht.h
index 53eba97ebc83..b59503d4049a 100644
--- a/drivers/media/platform/vicodec/codec-v4l2-fwht.h
+++ b/drivers/media/platform/vicodec/codec-v4l2-fwht.h
@@ -48,7 +48,10 @@ struct v4l2_fwht_state {
 
 const struct v4l2_fwht_pixfmt_info *v4l2_fwht_find_pixfmt(u32 pixelformat);
 const struct v4l2_fwht_pixfmt_info *v4l2_fwht_get_pixfmt(u32 idx);
-const struct v4l2_fwht_pixfmt_info *v4l2_fwht_default_fmt(u32 width_div,
+bool v4l2_fwht_validate_fmt(const struct v4l2_fwht_pixfmt_info *info,
+			    u32 width_div, u32 height_div, u32 components_num,
+			    u32 pixenc);
+const struct v4l2_fwht_pixfmt_info *v4l2_fwht_find_nth_fmt(u32 width_div,
 							  u32 height_div,
 							  u32 components_num,
 							  u32 pixenc,
diff --git a/drivers/media/platform/vicodec/vicodec-core.c b/drivers/media/platform/vicodec/vicodec-core.c
index d051f9901409..15dfdd99be3a 100644
--- a/drivers/media/platform/vicodec/vicodec-core.c
+++ b/drivers/media/platform/vicodec/vicodec-core.c
@@ -402,7 +402,7 @@ info_from_header(const struct fwht_cframe_hdr *p_hdr)
 				FWHT_FL_COMPONENTS_NUM_OFFSET);
 		pixenc = (flags & FWHT_FL_PIXENC_MSK);
 	}
-	return v4l2_fwht_default_fmt(width_div, height_div,
+	return v4l2_fwht_find_nth_fmt(width_div, height_div,
 				     components_num, pixenc, 0);
 }
 
@@ -623,7 +623,7 @@ static int enum_fmt(struct v4l2_fmtdesc *f, struct vicodec_ctx *ctx,
 		if (!info || ctx->is_enc)
 			info = v4l2_fwht_get_pixfmt(f->index);
 		else
-			info = v4l2_fwht_default_fmt(info->width_div,
+			info = v4l2_fwht_find_nth_fmt(info->width_div,
 						     info->height_div,
 						     info->components_num,
 						     info->pixenc,
-- 
2.17.1

