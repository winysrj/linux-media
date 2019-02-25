Return-Path: <SRS0=o7tn=RA=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 81F51C43381
	for <linux-media@archiver.kernel.org>; Mon, 25 Feb 2019 22:22:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4DE202147C
	for <linux-media@archiver.kernel.org>; Mon, 25 Feb 2019 22:22:28 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="R3iUdtnV"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728029AbfBYWW1 (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Mon, 25 Feb 2019 17:22:27 -0500
Received: from mail-wr1-f67.google.com ([209.85.221.67]:44485 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727801AbfBYWW1 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 25 Feb 2019 17:22:27 -0500
Received: by mail-wr1-f67.google.com with SMTP id w2so11689328wrt.11
        for <linux-media@vger.kernel.org>; Mon, 25 Feb 2019 14:22:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=heYc5STj/DtjwMTB1aRdzi/H1gIEy4dN2wTw1s5CEaI=;
        b=R3iUdtnVE98bl54jHlqTdiqPZY2yTbRuRONTEpCrHem45FhdcXXMdETqhUQsO9OYAy
         IZvTOXfsHXFNkFojOkWUyYJkHRvQ3KTrsA9vFRykySkBdWPAaeN2znyckoKlz08xddMj
         agP0/xM9nVu97DDDEe66FJyzg2dS7b1HYEDsROaL5sQPTH9Es2Tzmc0HSWHFLxlxUAWa
         ///V1kXcRLJmE1Xn/F42CLluD3mL9w60xqH4/snQ75a1oTrANUsiLSojbI/B4OO4Op5r
         Zds4O2I8whPVTKURCbT7jh6Sc/zNN/0YGCVffn360otTNU4FeY9NJJ0t6qHKrpSIzKOv
         xVSQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=heYc5STj/DtjwMTB1aRdzi/H1gIEy4dN2wTw1s5CEaI=;
        b=HPaCZ+8UNmFseMgjbUC0GKKchJbrsUuRyEDtF57rQYg19HF161g/8imR1ubvrz2qaC
         3sPXKePikc/wx6df34lGvm3hppVk8y3KmJNV9vhWsXWxf8YV9pK7508OC8QPBP3VBugn
         SJpnkWJtXqXd++ux20wSKGsTqLGukadZwjhTdZOnFGjRZTnd9Ubu6lC2uqGJk2bBdx5s
         BR++VUXcgTwGwOTrhO64aq20wkuar5+GKpaOowDaUNGypuJhC/ltiZyZnoMIZH1nQp0h
         p7vIGpCBMRaOSTl0Qboh0RAnTf+zLgxB2IZMfY+JDRW47Ck0XjIK4jDlx7lkJlZGPhp7
         Pmgw==
X-Gm-Message-State: AHQUAuYTD0WuAGMWCEkPA5dwuBaYDUvPPFahzlRhBNTuVgv/LMUSNxbe
        hpbr2wvZyimVCtSw+V59l1oaGIzFTV4=
X-Google-Smtp-Source: AHgI3IYYZ6CF3dmx1CE4KArrm++Il0TwTaL7v2Wewq3zynLDY+27K4PRr7z5fN8w+AaTgppbSZW+mA==
X-Received: by 2002:adf:dd12:: with SMTP id a18mr13166617wrm.4.1551133344877;
        Mon, 25 Feb 2019 14:22:24 -0800 (PST)
Received: from ubuntu.home ([77.127.107.32])
        by smtp.gmail.com with ESMTPSA id d206sm16981422wmc.11.2019.02.25.14.22.23
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 25 Feb 2019 14:22:24 -0800 (PST)
From:   Dafna Hirschfeld <dafna3@gmail.com>
To:     linux-media@vger.kernel.org
Cc:     hverkuil@xs4all.nl, helen.koike@collabora.com,
        Dafna Hirschfeld <dafna3@gmail.com>
Subject: [PATCH v4 14/21] media: vicodec: rename v4l2_fwht_default_fmt to v4l2_fwht_find_nth_fmt
Date:   Mon, 25 Feb 2019 14:22:05 -0800
Message-Id: <20190225222210.121713-5-dafna3@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190225222210.121713-1-dafna3@gmail.com>
References: <20190225222210.121713-1-dafna3@gmail.com>
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

