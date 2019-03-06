Return-Path: <SRS0=KHCC=RJ=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 71374C43381
	for <linux-media@archiver.kernel.org>; Wed,  6 Mar 2019 21:14:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3864F20684
	for <linux-media@archiver.kernel.org>; Wed,  6 Mar 2019 21:14:31 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="pzO+lUzz"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726691AbfCFVOa (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Wed, 6 Mar 2019 16:14:30 -0500
Received: from mail-wr1-f68.google.com ([209.85.221.68]:47100 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726677AbfCFVOa (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Wed, 6 Mar 2019 16:14:30 -0500
Received: by mail-wr1-f68.google.com with SMTP id i16so15013926wrs.13
        for <linux-media@vger.kernel.org>; Wed, 06 Mar 2019 13:14:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=78sfz26EMZOEuWtTPcnE8tD6FrPhvjQZynhZi9cYLn4=;
        b=pzO+lUzzz4O/jhI90c47IOZ/FrxmYRnFM5Y9o8e8mw0oPK4DRvG9ILl0EcFXpjrjMR
         TAvfmiwD8t0Bxiv8aYSgcFsA0fUJf/qb1101XMtl+QXtzHs1+fEMk9gpGE8hXPeuSODZ
         pRgWzAs49Nq1AHGoOlXE4o9fQiUkeSNxnuUUwNqGGheGoY3zb6ZpvLSht0wJbOotx05T
         E7VKUlLWIQx0Iy+xZTnb1K7PxD9AY+2JmmUgsVtgWpvLQuP2KoPP56S7uyMeHlku9hXp
         3R48kj4VyVGigAoF/wmHgcD+QhMlM3rThloJKfkfut85w6k+uoCHAqS8qQ4YNNCMF1hI
         wj8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=78sfz26EMZOEuWtTPcnE8tD6FrPhvjQZynhZi9cYLn4=;
        b=NmTWkl6hLwSZTmwCA/bhCi7EuclDH1xvkVofKEYtleH+LTA4B8pMwZP20XtyEIpadk
         n2DEoyltVEbXBF/Zd/3dfAWLgprOHHQfYR/mvbaYqmJ7dD96m001YJruuNGC/PuAaSeG
         Ii2X4eupGus4xIf1VzDYaVHnCHRT6+HHHGJVXRr7x9URx5Bi6aXslrO9GgxroRUvvJnX
         dOfRyhbzDQfpfSjcC6KAdOfB/iiXVNpHmWpK6Y1DF/P3MFVjFE2HwokyAQL4Wnd0PUal
         Pau8fF/vRhPZ2EbhnZ2mdfdClCrs5p6fEF0CV3JrrUEKYgoIRYTItNqfGcm2+MJb8m/O
         TalQ==
X-Gm-Message-State: APjAAAUAFMiPC8YUvkIlpKu8Ai+IIl5T2/kCB4Tc3Qr/GXLj+FgHXWzT
        X48qV/iFeW1o71ViNouk+INjTl/vi/c=
X-Google-Smtp-Source: APXvYqzWQQZykGQynKmIaUg2WjJ/70Pte1mHT8/JpLi2mrxGD9dxFi0innXuwCgMCoKQWRkBYMJVKg==
X-Received: by 2002:a5d:4090:: with SMTP id o16mr4258120wrp.208.1551906868043;
        Wed, 06 Mar 2019 13:14:28 -0800 (PST)
Received: from ubuntu.home ([77.124.117.239])
        by smtp.gmail.com with ESMTPSA id a9sm1882126wmm.10.2019.03.06.13.14.26
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 06 Mar 2019 13:14:27 -0800 (PST)
From:   Dafna Hirschfeld <dafna3@gmail.com>
To:     linux-media@vger.kernel.org
Cc:     hverkuil@xs4all.nl, helen.koike@collabora.com,
        Dafna Hirschfeld <dafna3@gmail.com>
Subject: [PATCH v5 15/23] media: vicodec: Handle the case that the reference buffer is NULL
Date:   Wed,  6 Mar 2019 13:13:35 -0800
Message-Id: <20190306211343.15302-16-dafna3@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190306211343.15302-1-dafna3@gmail.com>
References: <20190306211343.15302-1-dafna3@gmail.com>
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

In the stateless decoder the reference buffer is null if the
frame is an I-frame (flagged with FWHT_FL_I_FRAME).
Make sure not to dereference it in that case.

Signed-off-by: Dafna Hirschfeld <dafna3@gmail.com>
---
 drivers/media/platform/vicodec/codec-fwht.c      |  9 +++++----
 drivers/media/platform/vicodec/codec-v4l2-fwht.c | 11 +++++++++++
 2 files changed, 16 insertions(+), 4 deletions(-)

diff --git a/drivers/media/platform/vicodec/codec-fwht.c b/drivers/media/platform/vicodec/codec-fwht.c
index 9a0dc739c58c..25992817f45b 100644
--- a/drivers/media/platform/vicodec/codec-fwht.c
+++ b/drivers/media/platform/vicodec/codec-fwht.c
@@ -834,6 +834,7 @@ static bool decode_plane(struct fwht_cframe *cf, const __be16 **rlco,
 	s16 copy[8 * 8];
 	u16 stat;
 	unsigned int i, j;
+	bool is_intra = !ref;
 
 	width = round_up(width, 8);
 	height = round_up(height, 8);
@@ -865,7 +866,7 @@ static bool decode_plane(struct fwht_cframe *cf, const __be16 **rlco,
 
 			if (copies) {
 				memcpy(cf->de_fwht, copy, sizeof(copy));
-				if (stat & PFRAME_BIT)
+				if ((stat & PFRAME_BIT) && !is_intra)
 					add_deltas(cf->de_fwht, refp,
 						   ref_stride, ref_step);
 				fill_decoder_block(dstp, cf->de_fwht,
@@ -877,18 +878,18 @@ static bool decode_plane(struct fwht_cframe *cf, const __be16 **rlco,
 			stat = derlc(rlco, cf->coeffs, end_of_rlco_buf);
 			if (stat & OVERFLOW_BIT)
 				return false;
-			if (stat & PFRAME_BIT)
+			if ((stat & PFRAME_BIT) && !is_intra)
 				dequantize_inter(cf->coeffs);
 			else
 				dequantize_intra(cf->coeffs);
 
 			ifwht(cf->coeffs, cf->de_fwht,
-			      (stat & PFRAME_BIT) ? 0 : 1);
+			      ((stat & PFRAME_BIT) && !is_intra) ? 0 : 1);
 
 			copies = (stat & DUPS_MASK) >> 1;
 			if (copies)
 				memcpy(copy, cf->de_fwht, sizeof(copy));
-			if (stat & PFRAME_BIT)
+			if ((stat & PFRAME_BIT) && !is_intra)
 				add_deltas(cf->de_fwht, refp,
 					   ref_stride, ref_step);
 			fill_decoder_block(dstp, cf->de_fwht, dst_stride,
diff --git a/drivers/media/platform/vicodec/codec-v4l2-fwht.c b/drivers/media/platform/vicodec/codec-v4l2-fwht.c
index 372ed95e1a1f..01e7f09efc4e 100644
--- a/drivers/media/platform/vicodec/codec-v4l2-fwht.c
+++ b/drivers/media/platform/vicodec/codec-v4l2-fwht.c
@@ -99,6 +99,17 @@ static int prepare_raw_frame(struct fwht_raw_frame *rf,
 	rf->alpha = NULL;
 	rf->components_num = info->components_num;
 
+	/*
+	 * The buffer is NULL if it is the reference
+	 * frame of an I-frame in the stateless decoder
+	 */
+	if (!buf) {
+		rf->luma = NULL;
+		rf->cb = NULL;
+		rf->cr = NULL;
+		rf->alpha = NULL;
+		return 0;
+	}
 	switch (info->id) {
 	case V4L2_PIX_FMT_GREY:
 		rf->cb = NULL;
-- 
2.17.1

