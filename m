Return-Path: <SRS0=KHCC=RJ=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9C52EC43381
	for <linux-media@archiver.kernel.org>; Wed,  6 Mar 2019 21:14:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 68F0520684
	for <linux-media@archiver.kernel.org>; Wed,  6 Mar 2019 21:14:29 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="haNlReLo"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726689AbfCFVO2 (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Wed, 6 Mar 2019 16:14:28 -0500
Received: from mail-wr1-f68.google.com ([209.85.221.68]:37013 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726677AbfCFVO2 (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Wed, 6 Mar 2019 16:14:28 -0500
Received: by mail-wr1-f68.google.com with SMTP id w6so15032898wrs.4
        for <linux-media@vger.kernel.org>; Wed, 06 Mar 2019 13:14:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=heYc5STj/DtjwMTB1aRdzi/H1gIEy4dN2wTw1s5CEaI=;
        b=haNlReLowM3UFFJpfiB+d/dvZJUiLvCQvFJlO9lhcbmcA2HcXYemHm1wmak9n4eLuj
         /JR66fGoceweESWHB2mRmYCMD8Wpsq2lxcnw3q7dYzb6eeOEUw//ZY8bVxg0WZKrL+w4
         SNjeYuLAOUH2m3AOYFBiWUYDd5HaByZqnlS2B4inSBh96eQ2JyAP7BqkKDjhGJkAsP+V
         wyqh/vYH5fRRNoApKs4+3S8QO1ypUPjLzA66i40hhSixW9GDSqgqAOZ6843DBPgHKstg
         j9o/mzQDO+iBaZ28QJ8FLAj3S9tX4+1IhyUO8DKckgrb5wbMmCCR+kKow1+mnSXqJ7t7
         D/FA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=heYc5STj/DtjwMTB1aRdzi/H1gIEy4dN2wTw1s5CEaI=;
        b=qg0HfN0yuyVk3umOl6+L2IEvVrPXNcIoZOqi5kBaqBpTpm3ZAxmrl8rF7m3wDszTL3
         YVflFuD0VgE3vmxQl57TKp7yl4bT0ibeY5F8/ZVXCQ3e05U8UsG4iS3bOC+K22ztPLQx
         vvkyoSnOTWoHB1sMHk5hgFCJqHW4US/87+MGQmBURbUlrdjF+VarGSyG1Qhb7uNdfWTh
         8z6QOBpTHsEK4RWdkGcAx3AK8CuTAqqWL5CyRrcR9Pi2QsFg/uTLnotbfDXw2ILPHM9c
         tvcQeNlzYtvG4QmdFLlti+e7WBpSydtO5pN5IC24B+k9lGyoNzJxTPIXr365HQHM/ayl
         y7Gw==
X-Gm-Message-State: APjAAAXDiia8E56JVlWaD0h/1QvepHsMA/Tpnv/dpabRtqFF3JqPT8AW
        SUqIRPDBGWfNAdJtypFTurkb7zwIF4I=
X-Google-Smtp-Source: APXvYqwrBZSTZBGizxX5l0MFV+7mqSNwUAyCXVOD6fzwCbYlJLtI+yfpzonzD/7VCuWSrb5cN1zDfw==
X-Received: by 2002:a5d:4412:: with SMTP id z18mr4299897wrq.111.1551906866291;
        Wed, 06 Mar 2019 13:14:26 -0800 (PST)
Received: from ubuntu.home ([77.124.117.239])
        by smtp.gmail.com with ESMTPSA id a9sm1882126wmm.10.2019.03.06.13.14.24
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 06 Mar 2019 13:14:25 -0800 (PST)
From:   Dafna Hirschfeld <dafna3@gmail.com>
To:     linux-media@vger.kernel.org
Cc:     hverkuil@xs4all.nl, helen.koike@collabora.com,
        Dafna Hirschfeld <dafna3@gmail.com>
Subject: [PATCH v5 14/23] media: vicodec: rename v4l2_fwht_default_fmt to v4l2_fwht_find_nth_fmt
Date:   Wed,  6 Mar 2019 13:13:34 -0800
Message-Id: <20190306211343.15302-15-dafna3@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190306211343.15302-1-dafna3@gmail.com>
References: <20190306211343.15302-1-dafna3@gmail.com>
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

