Return-Path: <SRS0=d4St=Q7=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9FDB1C43381
	for <linux-media@archiver.kernel.org>; Sun, 24 Feb 2019 09:03:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6A7AA20652
	for <linux-media@archiver.kernel.org>; Sun, 24 Feb 2019 09:03:11 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="g5isDTVI"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728216AbfBXJDK (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Sun, 24 Feb 2019 04:03:10 -0500
Received: from mail-wr1-f67.google.com ([209.85.221.67]:46120 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728171AbfBXJDJ (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sun, 24 Feb 2019 04:03:09 -0500
Received: by mail-wr1-f67.google.com with SMTP id i16so6640951wrs.13
        for <linux-media@vger.kernel.org>; Sun, 24 Feb 2019 01:03:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=AYEBhkP1dkE6ls6X0HedOdFesY0vxFEcctcgT7NJZdM=;
        b=g5isDTVI2/bViYvFqBXG7S7N3bNUjpni1SkjlWjKmJuOeKu3eRuclfRsyvCvElbkhS
         ZCGFDAMtQpfoK5zfPXBB8kzMS9x3s/6XGXYecBPnjBETbebf1XrygiwUZOcL92yZEryC
         r2Z+3axEGyECTErTQrOB55vy2nqJlavqJyFDnvvrTAWahPmwgIa3KP67E/p3IC1GoCHZ
         6MTUTl12b0lPPAlini85RrB3ax9BRaKsBX7gP5SQlB3RQwvzCBdWGF+17mgAVwNVwK8h
         5hLCYuLFOzWNDYIIC/GWq69AIp/1Bm949PN1f98H3TurOSkO7AsmLOwVwHiKGODHPon3
         mRIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=AYEBhkP1dkE6ls6X0HedOdFesY0vxFEcctcgT7NJZdM=;
        b=npMpRvtQ3jBNf39ejDdAYvghbMErkplDL1YcX+ntw3HBbHoy09D1JxqwnSbaZ94ol7
         7N34Vq01RlCG+nzRAgEUiKpKJtNwRpYbOwZWpds5i5PAJSrjWi0sZzTd3arrLUj4b8fa
         WKVE/SzPLMZIXa2G6Kpf9HXWYzW3l8t9F9AnkXrSeBVzAO0G4Y/30/hP6o/xpVSiNl/t
         boxl0GWd1v608xT+DtS1aJLz/3xBC2ZT57WOi4TotnVwkzw975HhHwg4VCSgXc1vbyit
         SWlc2kNz22/aF8cMEfpF/MaJXvaySRMZ22BISIks9Euq/j8p/BRIruqPpLRDid7IeTnF
         CzTg==
X-Gm-Message-State: AHQUAuYT9qiD92DrEbkgqNaKRYid516S0knwA5ghwB5syvpGtru4brTo
        VO493/w2S9bDDBfVMM04yOlYKyiIk4c=
X-Google-Smtp-Source: AHgI3IYbKyEAJQtv3cG48i5CEz+ed1n77wSwfMl3g5lwm1VLqM0qv8MANYqodXsIeciMqY58dSa1Mg==
X-Received: by 2002:adf:dd86:: with SMTP id x6mr8588464wrl.250.1550998988042;
        Sun, 24 Feb 2019 01:03:08 -0800 (PST)
Received: from ubuntu.home ([77.127.107.32])
        by smtp.gmail.com with ESMTPSA id e75sm8701971wmg.32.2019.02.24.01.03.06
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 24 Feb 2019 01:03:07 -0800 (PST)
From:   Dafna Hirschfeld <dafna3@gmail.com>
To:     linux-media@vger.kernel.org
Cc:     hverkuil@xs4all.nl, helen.koike@collabora.com,
        Dafna Hirschfeld <dafna3@gmail.com>
Subject: [PATCH v3 13/18] media: vicodec: rename v4l2_fwht_default_fmt to v4l2_fwht_find_nth_fmt
Date:   Sun, 24 Feb 2019 01:02:30 -0800
Message-Id: <20190224090234.19723-14-dafna3@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190224090234.19723-1-dafna3@gmail.com>
References: <20190224090234.19723-1-dafna3@gmail.com>
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
index 55b003de43a3..d20e829274ae 100644
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

