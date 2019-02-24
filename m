Return-Path: <SRS0=d4St=Q7=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 50F7AC43381
	for <linux-media@archiver.kernel.org>; Sun, 24 Feb 2019 08:41:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1F19B206BA
	for <linux-media@archiver.kernel.org>; Sun, 24 Feb 2019 08:41:47 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="aCOrKsE8"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726835AbfBXIlq (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Sun, 24 Feb 2019 03:41:46 -0500
Received: from mail-wm1-f68.google.com ([209.85.128.68]:37643 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725956AbfBXIlq (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sun, 24 Feb 2019 03:41:46 -0500
Received: by mail-wm1-f68.google.com with SMTP id x10so5363402wmg.2
        for <linux-media@vger.kernel.org>; Sun, 24 Feb 2019 00:41:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=zSlL0LY/PtW7ZCs79BGc4JKS0Zbo+XdKqZAibVWK/oQ=;
        b=aCOrKsE82/deehKxFLP12f0Q//6oAywwdwo+WuPlfuMH/vLHyw9e9hcmK28TZXruda
         gweyVODIvGqBDZZi7NCpw5Z5JYTgnVJq7euy5O3vax82aaSqNNL8fO0omLdR5Pors909
         gaB4x2Ndh5j3gtX3x+Uk+c6d9ipxk1nUaBCd0Hjme0j3mq0+zu8rNu/v/XRgHkIaD+yN
         I+pFKJUR03dLJiSaSjoYnwS8aQuFbQ93ATKO88f+TXlGtWRKsE5OYRA7GoscLPoIXAl2
         /nf9opQUKZQvJyvzTPli4LbVv9LA/FxyvwoEtPqv1Xbg9ps23j0SyD4c5HguqHZ1qza9
         97Wg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=zSlL0LY/PtW7ZCs79BGc4JKS0Zbo+XdKqZAibVWK/oQ=;
        b=KFhML50JCaTm+Nmno8N3Aveg90Uu02TVqe2GkLk2MLLIRM1R8MYC9cgzNd+vXMmvV6
         t4OovRh3Ht/DpaGsbRBQyknNppOt86n0TGQ+9Pewm1rd90SRsDa5KmLZB/kTakhnvBhf
         a3sRFTnkic/fw5eSlU5tQqu9K/1VF9mQIBxxIAvqYKcczaWHdGU84MRTt0/odYY7b3ps
         ZfYlZ+/+UL2+yju0tJXkskuKAu0IsPsnorVCrf831X4PwHtiMio4UqXTgSsAFN7/8Ibl
         C4VT/y2RcqzVgI3k7S5xR5ynOVimR7ASxzS7b+9F9zJ3BGw2g9WMc0DZCQ1hW23XLEoI
         5vDw==
X-Gm-Message-State: AHQUAuYF3E9lF9Bw8L77JA1/dQ07VNwS/XragURaOe1xoEgR0lvxFn56
        104vCEyhT8m8MKo17SbIhwjhA93Kg4I=
X-Google-Smtp-Source: AHgI3IYcLPW/ObtfbuZ7ZjQniDvZwoTp8xSHyFtNmUvRLfvja/FDcVh8+kmjJ5p6bjfBxm0fO4ioaA==
X-Received: by 2002:a1c:458:: with SMTP id 85mr6760592wme.97.1550997703979;
        Sun, 24 Feb 2019 00:41:43 -0800 (PST)
Received: from ubuntu.home ([77.127.107.32])
        by smtp.gmail.com with ESMTPSA id x24sm6837465wmi.5.2019.02.24.00.41.42
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 24 Feb 2019 00:41:43 -0800 (PST)
From:   Dafna Hirschfeld <dafna3@gmail.com>
To:     linux-media@vger.kernel.org
Cc:     hverkuil@xs4all.nl, helen.koike@collabora.com,
        Dafna Hirschfeld <dafna3@gmail.com>
Subject: [v4l-utils PATCH v3 1/8] v4l2-ctl: rename variable 'vic_fmt' to 'info'
Date:   Sun, 24 Feb 2019 00:41:19 -0800
Message-Id: <20190224084126.19412-2-dafna3@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190224084126.19412-1-dafna3@gmail.com>
References: <20190224084126.19412-1-dafna3@gmail.com>
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

This is a better name for
'v4l2_fwht_pixfmt_info' type and it is not
confused with 'cv4l_fmt' type.

Signed-off-by: Dafna Hirschfeld <dafna3@gmail.com>
---
 utils/v4l2-ctl/v4l2-ctl-streaming.cpp | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/utils/v4l2-ctl/v4l2-ctl-streaming.cpp b/utils/v4l2-ctl/v4l2-ctl-streaming.cpp
index 766872b5..352b946d 100644
--- a/utils/v4l2-ctl/v4l2-ctl-streaming.cpp
+++ b/utils/v4l2-ctl/v4l2-ctl-streaming.cpp
@@ -753,7 +753,7 @@ static void read_write_padded_frame(cv4l_fmt &fmt, unsigned char *buf,
 				    FILE *fpointer, unsigned &sz,
 				    unsigned &len, bool is_read)
 {
-	const struct v4l2_fwht_pixfmt_info *vic_fmt =
+	const struct v4l2_fwht_pixfmt_info *info =
 			v4l2_fwht_find_pixfmt(fmt.g_pixelformat());
 	unsigned coded_height = fmt.g_height();
 	unsigned real_width;
@@ -770,14 +770,14 @@ static void read_write_padded_frame(cv4l_fmt &fmt, unsigned char *buf,
 	}
 
 	sz = 0;
-	len = real_width * real_height * vic_fmt->sizeimage_mult / vic_fmt->sizeimage_div;
+	len = real_width * real_height * info->sizeimage_mult / info->sizeimage_div;
 
-	for (unsigned plane_idx = 0; plane_idx < vic_fmt->planes_num; plane_idx++) {
+	for (unsigned plane_idx = 0; plane_idx < info->planes_num; plane_idx++) {
 		bool is_chroma_plane = plane_idx == 1 || plane_idx == 2;
-		unsigned h_div = is_chroma_plane ? vic_fmt->height_div : 1;
-		unsigned w_div = is_chroma_plane ? vic_fmt->width_div : 1;
-		unsigned step = is_chroma_plane ? vic_fmt->chroma_step : vic_fmt->luma_alpha_step;
-		unsigned stride_div = (vic_fmt->planes_num == 3 && plane_idx > 0) ? 2 : 1;
+		unsigned h_div = is_chroma_plane ? info->height_div : 1;
+		unsigned w_div = is_chroma_plane ? info->width_div : 1;
+		unsigned step = is_chroma_plane ? info->chroma_step : info->luma_alpha_step;
+		unsigned stride_div = (info->planes_num == 3 && plane_idx > 0) ? 2 : 1;
 
 		row_p = plane_p;
 		for (unsigned i = 0; i < real_height / h_div; i++) {
-- 
2.17.1

