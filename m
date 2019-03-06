Return-Path: <SRS0=KHCC=RJ=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3C928C10F00
	for <linux-media@archiver.kernel.org>; Wed,  6 Mar 2019 21:18:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0D32120661
	for <linux-media@archiver.kernel.org>; Wed,  6 Mar 2019 21:18:05 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="QuvZoIAc"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726195AbfCFVSE (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Wed, 6 Mar 2019 16:18:04 -0500
Received: from mail-wm1-f66.google.com ([209.85.128.66]:34181 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725793AbfCFVSE (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Wed, 6 Mar 2019 16:18:04 -0500
Received: by mail-wm1-f66.google.com with SMTP id o10so5312614wmc.1
        for <linux-media@vger.kernel.org>; Wed, 06 Mar 2019 13:18:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=fYNZwgQ6sI3JOZRshOTInAinKACUoWtKfmbXGzDGtLs=;
        b=QuvZoIAcoQ/Hgaqa5GGMDSHa1yKKtY3WX6+SsLQK/tjZATk1aPb06e222t0xG2yYzH
         YjkBPrExYsDVqleoFhpxpBzh46k2gMpoc6UfDuyB59Hfwc2neOVQrO6xWyT0+pbzdwts
         LyWhzAy9sVl1x7jUwswlOrXlmFPXAGM3rVwMgvvfyCKhcR2e/74IkDVaqx25Ec+a2tBx
         0tnbqkyyOimV+qgfL0NdnaVcCMz23eVA1NNiwVjNwoqUqCAfvirNa2HdmuynQMngjKcs
         sAD4L5bLTCgbAwT/E9FSsKWs+U2ncE4IDbqH4Uo1DwGavxwuRFOiXqc/6+IfZxP3lRCq
         rmsg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=fYNZwgQ6sI3JOZRshOTInAinKACUoWtKfmbXGzDGtLs=;
        b=bUu5tbksL8a3SO90HLBr7oDHkF/clQfTZTedEPq+lZF9OxBeQnt/cUdNdic63+dvzT
         cwLS4WVj+2W9Tnoa3qla6H3Jay2dLmCIKijOz72IoEqIwtK7e1wUKtjNrlUF6CiA1IGa
         Y9PWTzKAuEgUbvl/krnVVTFUJOoW5U0y2J4N6bzcbhYOgOM32zQH0krbOfljvEmYL+zx
         /4VsVYD2NLmtVIqvEazZpH0dlfSsI0GF3k8gP8XA4HNtDMb9RWWESHHIH/1pps9r28aX
         4e/YlMjFwyDN/EdY2k1AZ/cs9mlE98/hvDg8nAyEluHwGekD2iIa7pyk8mAxGMiWNhag
         M9Qw==
X-Gm-Message-State: APjAAAX86WeAG0RKKaa4NmXDUfYL4HRyFIQXspIf2qzQzDOCh5QoUHO+
        0B0SOS1YEBUtMnGnRr2jOTIUZBVPLzg=
X-Google-Smtp-Source: APXvYqy+vHVgnh4Y3w0rEAsaFj3rlm44p+ZbQt+l6Y72U2Y4j8X530MBgtvBk7euuxamcebbbvEzpg==
X-Received: by 2002:a1c:eb17:: with SMTP id j23mr3488573wmh.86.1551907082280;
        Wed, 06 Mar 2019 13:18:02 -0800 (PST)
Received: from ubuntu.home ([77.124.117.239])
        by smtp.gmail.com with ESMTPSA id c2sm5252495wrt.93.2019.03.06.13.18.00
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 06 Mar 2019 13:18:01 -0800 (PST)
From:   Dafna Hirschfeld <dafna3@gmail.com>
To:     linux-media@vger.kernel.org
Cc:     hverkuil@xs4all.nl, helen.koike@collabora.com,
        Dafna Hirschfeld <dafna3@gmail.com>
Subject: [v4l-utils PATCH v5 2/6] v4l2-ctl: check that the size read/write fit the buffer size
Date:   Wed,  6 Mar 2019 13:17:48 -0800
Message-Id: <20190306211752.15531-2-dafna3@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190306211752.15531-1-dafna3@gmail.com>
References: <20190306211752.15531-1-dafna3@gmail.com>
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

'read_write_padded_frame' should check that the
expected size to read/write is not larger than
the size of the buffer.

Signed-off-by: Dafna Hirschfeld <dafna3@gmail.com>
---
 utils/v4l2-ctl/v4l2-ctl-streaming.cpp | 41 ++++++++++++++++-----------
 1 file changed, 24 insertions(+), 17 deletions(-)

diff --git a/utils/v4l2-ctl/v4l2-ctl-streaming.cpp b/utils/v4l2-ctl/v4l2-ctl-streaming.cpp
index ee84abbe..465ba50c 100644
--- a/utils/v4l2-ctl/v4l2-ctl-streaming.cpp
+++ b/utils/v4l2-ctl/v4l2-ctl-streaming.cpp
@@ -749,9 +749,10 @@ void streaming_cmd(int ch, char *optarg)
 	}
 }
 
-static void read_write_padded_frame(cv4l_fmt &fmt, unsigned char *buf,
+static bool read_write_padded_frame(cv4l_fmt &fmt, unsigned char *buf,
 				    FILE *fpointer, unsigned &sz,
-				    unsigned &len, bool is_read)
+				    unsigned &expected_len, unsigned buf_len,
+				    bool is_read)
 {
 	const struct v4l2_fwht_pixfmt_info *info =
 			v4l2_fwht_find_pixfmt(fmt.g_pixelformat());
@@ -771,8 +772,9 @@ static void read_write_padded_frame(cv4l_fmt &fmt, unsigned char *buf,
 	}
 
 	sz = 0;
-	len = real_width * real_height * info->sizeimage_mult / info->sizeimage_div;
-
+	expected_len = real_width * real_height * info->sizeimage_mult / info->sizeimage_div;
+	if (expected_len > buf_len)
+		return false;
 	for (unsigned plane_idx = 0; plane_idx < info->planes_num; plane_idx++) {
 		bool is_chroma_plane = plane_idx == 1 || plane_idx == 2;
 		unsigned h_div = is_chroma_plane ? info->height_div : 1;
@@ -800,7 +802,7 @@ static void read_write_padded_frame(cv4l_fmt &fmt, unsigned char *buf,
 				break;
 			if (wsz != consume_sz) {
 				fprintf(stderr, "padding: needed %u bytes, got %u\n", consume_sz, wsz);
-				return;
+				return true;
 			}
 			sz += wsz;
 			row_p += stride;
@@ -809,6 +811,7 @@ static void read_write_padded_frame(cv4l_fmt &fmt, unsigned char *buf,
 		if (sz == 0)
 			break;
 	}
+	return true;
 }
 
 static bool fill_buffer_from_file(cv4l_fd &fd, cv4l_queue &q, cv4l_buffer &b,
@@ -929,26 +932,30 @@ restart:
 
 	for (unsigned j = 0; j < q.g_num_planes(); j++) {
 		void *buf = q.g_dataptr(b.g_index(), j);
-		unsigned len = q.g_length(j);
+		unsigned buf_len = q.g_length(j);
+		unsigned expected_len = q.g_length(j);
 		unsigned sz;
 		cv4l_fmt fmt;
 
 		fd.g_fmt(fmt, q.g_type());
 		if (from_with_hdr) {
-			len = read_u32(fin);
-			if (len > q.g_length(j)) {
+			expected_len = read_u32(fin);
+			if (expected_len > q.g_length(j)) {
 				fprintf(stderr, "plane size is too large (%u > %u)\n",
-					len, q.g_length(j));
+					expected_len, q.g_length(j));
 				return false;
 			}
 		}
 
-		if (support_out_crop && v4l2_fwht_find_pixfmt(fmt.g_pixelformat()))
-			read_write_padded_frame(fmt, (unsigned char *)buf, fin, sz, len, true);
-		else
-			sz = fread(buf, 1, len, fin);
+		if (support_out_crop && v4l2_fwht_find_pixfmt(fmt.g_pixelformat())) {
+			if (!read_write_padded_frame(fmt, (unsigned char *)buf,
+			    fin, sz, expected_len, buf_len, true))
+				return false;
+		} else {
+			sz = fread(buf, 1, expected_len, fin);
+		}
 
-		if (first && sz != len) {
+		if (first && sz != expected_len) {
 			fprintf(stderr, "Insufficient data\n");
 			return false;
 		}
@@ -958,12 +965,12 @@ restart:
 			goto restart;
 		}
 		b.s_bytesused(sz, j);
-		if (sz == len)
+		if (sz == expected_len)
 			continue;
 		if (sz == 0)
 			return false;
 		if (sz)
-			fprintf(stderr, "%u != %u\n", sz, len);
+			fprintf(stderr, "%u != %u\n", sz, expected_len);
 		continue;
 	}
 	first = false;
@@ -1151,7 +1158,7 @@ static void write_buffer_to_file(cv4l_fd &fd, cv4l_queue &q, cv4l_buffer &buf,
 			sz = fwrite(comp_ptr[j] + offset, 1, used, fout);
 		else if (support_cap_compose && v4l2_fwht_find_pixfmt(fmt.g_pixelformat()))
 			read_write_padded_frame(fmt, (u8 *)q.g_dataptr(buf.g_index(), j) + offset,
-						fout, sz, used, false);
+						fout, sz, used, used, false);
 		else
 			sz = fwrite((u8 *)q.g_dataptr(buf.g_index(), j) + offset, 1, used, fout);
 
-- 
2.17.1

