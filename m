Return-Path: <SRS0=xT8T=PG=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6F18FC43387
	for <linux-media@archiver.kernel.org>; Sat, 29 Dec 2018 15:33:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1252C20869
	for <linux-media@archiver.kernel.org>; Sat, 29 Dec 2018 15:33:32 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="JwozEm7g"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726850AbeL2Pdb (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Sat, 29 Dec 2018 10:33:31 -0500
Received: from mail-wm1-f68.google.com ([209.85.128.68]:54831 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726168AbeL2Pdb (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 29 Dec 2018 10:33:31 -0500
Received: by mail-wm1-f68.google.com with SMTP id a62so20872116wmh.4
        for <linux-media@vger.kernel.org>; Sat, 29 Dec 2018 07:33:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=8zLZBY/cyHoewdGPIi3BuAGrzKDDTk37IWm2jcOtlB8=;
        b=JwozEm7g6lxB1OlL23xjKFxdCJhEfQHhLs2ZoCBUHgT3Nh8bNWm9MUg2ouCZ+LAE1E
         pN0QFdVCxF+NPX1klSsR+3y2/10pke1NyteWa3XBjFtIS/Ymc6UVNLwz6VQH4piioR7Q
         59RWkU4GzbNrKmwphpzBHv4cW4/8KdB4IhIL7wVoJFpk1TMdaonHpY/6MEsD3JU3kyLa
         JReiNX4XkXzPKNZ3opmg6QkanJ3mwCgIzl1NeO/BI6RFCA96qZ17fDI7Ie8KjcF2IGCP
         BVJwaBE5jTO3RXLS5+IykULvNGzUvtB/L3Ih1GGuKHZLPEGgA+ZkQeNBwHCzmdyxMEQG
         nJXw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=8zLZBY/cyHoewdGPIi3BuAGrzKDDTk37IWm2jcOtlB8=;
        b=s9eP8n0ev8JgqTS/c/k0JQzXVW4b679fVrItvqbnswqEPomeEUl7qkjMwjKrWNGCiX
         V9B4UcnxVio2v0fISQQHEg+ODlirk5WXVnEmJVrcudnV1i2BlQ9lZ9XIWVTjnppsSO6x
         aRdybNBS/GnGL4NCW9Gt6rgLtJllUgDDa4aMnmvPmMQ453s5j4GoaTPpiX0BgSL6ejr/
         gntqmbHqVM8brnwItsVNj59ExIArLLJKDPvwM2EqyH5t9qnzJdoSOBtF5J6WWX9NUaKJ
         64TGWj8DipxwTgvZMXlIm9gRb1zuVEwQwQ6CQUyfALI6Zb51PtYHJjJWEV/N84RQk+EJ
         5hmQ==
X-Gm-Message-State: AA+aEWYPPAJT101jvGMarLRP5KX7//LsX7ze/7NCVFnWpfr168bAjEBj
        e3ouUpLo3DtnG/W/+U/atA3qLP+K+qI=
X-Google-Smtp-Source: ALg8bN68aktQAmEu1w7HIUo3lIMdoCV6lrxrhg/aittCx67jBOjvR9ecckLEHE2Xph8CQn53U6NHxQ==
X-Received: by 2002:a1c:570d:: with SMTP id l13mr27933270wmb.139.1546097606725;
        Sat, 29 Dec 2018 07:33:26 -0800 (PST)
Received: from localhost.localdomain ([87.71.118.243])
        by smtp.gmail.com with ESMTPSA id s8sm40885664wrn.44.2018.12.29.07.33.25
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 29 Dec 2018 07:33:26 -0800 (PST)
From:   Dafna Hirschfeld <dafna3@gmail.com>
To:     linux-media@vger.kernel.org
Cc:     hverkuil@xs4all.nl, helen.koike@collabora.com,
        Dafna Hirschfeld <dafna3@gmail.com>
Subject: [PATCH v4l-utils] v4l2-ctl: Move some code from do_handle_cap to a new function
Date:   Sat, 29 Dec 2018 07:32:44 -0800
Message-Id: <20181229153244.1733-1-dafna3@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Move the code that deals with reading from file in
'do_handle_cap' to a new function 'write_buffer_to_file'

Signed-off-by: Dafna Hirschfeld <dafna3@gmail.com>
---
 utils/v4l2-ctl/v4l2-ctl-streaming.cpp | 139 +++++++++++++-------------
 1 file changed, 72 insertions(+), 67 deletions(-)

diff --git a/utils/v4l2-ctl/v4l2-ctl-streaming.cpp b/utils/v4l2-ctl/v4l2-ctl-streaming.cpp
index dee104d7..6f471842 100644
--- a/utils/v4l2-ctl/v4l2-ctl-streaming.cpp
+++ b/utils/v4l2-ctl/v4l2-ctl-streaming.cpp
@@ -926,6 +926,76 @@ static int do_setup_out_buffers(cv4l_fd &fd, cv4l_queue &q, FILE *fin, bool qbuf
 	return 0;
 }
 
+static void write_buffer_to_file(cv4l_queue &q, cv4l_buffer &buf, FILE *fout)
+{
+#ifndef NO_STREAM_TO
+	unsigned comp_size[VIDEO_MAX_PLANES];
+	__u8 *comp_ptr[VIDEO_MAX_PLANES];
+
+	if (host_fd_to >= 0) {
+		unsigned tot_comp_size = 0;
+		unsigned tot_used = 0;
+
+		for (unsigned j = 0; j < buf.g_num_planes(); j++) {
+			__u32 used = buf.g_bytesused();
+			unsigned offset = buf.g_data_offset();
+			u8 *p = (u8 *)q.g_dataptr(buf.g_index(), j) + offset;
+
+			if (ctx) {
+				comp_ptr[j] = fwht_compress(ctx, p,
+						used - offset, &comp_size[j]);
+			} else {
+				comp_ptr[j] = p;
+				comp_size[j] = rle_compress(p, used - offset,
+						bpl_cap[j]);
+			}
+			tot_comp_size += comp_size[j];
+			tot_used += used - offset;
+		}
+		write_u32(fout, ctx ? V4L_STREAM_PACKET_FRAME_VIDEO_FWHT :
+				V4L_STREAM_PACKET_FRAME_VIDEO_RLE);
+		write_u32(fout, V4L_STREAM_PACKET_FRAME_VIDEO_SIZE(buf.g_num_planes()) + tot_comp_size);
+		write_u32(fout, V4L_STREAM_PACKET_FRAME_VIDEO_SIZE_HDR);
+		write_u32(fout, buf.g_field());
+		write_u32(fout, buf.g_flags());
+		comp_perc += (tot_comp_size * 100 / tot_used);
+		comp_perc_count++;
+	}
+	if (to_with_hdr)
+		write_u32(fout, FILE_HDR_ID);
+	for (unsigned j = 0; j < buf.g_num_planes(); j++) {
+		__u32 used = buf.g_bytesused();
+		unsigned offset = buf.g_data_offset();
+		unsigned sz;
+
+		if (offset > used) {
+			// Should never happen
+			fprintf(stderr, "offset %d > used %d!\n",
+					offset, used);
+			offset = 0;
+		}
+		used -= offset;
+		if (host_fd_to >= 0) {
+			write_u32(fout, V4L_STREAM_PACKET_FRAME_VIDEO_SIZE_PLANE_HDR);
+			write_u32(fout, used);
+			write_u32(fout, comp_size[j]);
+			used = comp_size[j];
+		} else if (to_with_hdr) {
+			write_u32(fout, used);
+		}
+		if (host_fd_to >= 0)
+			sz = fwrite(comp_ptr[j] + offset, 1, used, fout);
+		else
+			sz = fwrite((u8 *)q.g_dataptr(buf.g_index(), j) + offset, 1, used, fout);
+
+		if (sz != used)
+			fprintf(stderr, "%u != %u\n", sz, used);
+	}
+	if (host_fd_to >= 0)
+		fflush(fout);
+#endif
+}
+
 static int do_handle_cap(cv4l_fd &fd, cv4l_queue &q, FILE *fout, int *index,
 			 unsigned &count, fps_timestamps &fps_ts)
 {
@@ -964,75 +1034,10 @@ static int do_handle_cap(cv4l_fd &fd, cv4l_queue &q, FILE *fout, int *index,
 	double ts_secs = buf.g_timestamp().tv_sec + buf.g_timestamp().tv_usec / 1000000.0;
 	fps_ts.add_ts(ts_secs, buf.g_sequence(), buf.g_field());
 
-#ifndef NO_STREAM_TO
 	if (fout && (!stream_skip || ignore_count_skip) &&
-	    buf.g_bytesused(0) && !(buf.g_flags() & V4L2_BUF_FLAG_ERROR)) {
-		unsigned comp_size[VIDEO_MAX_PLANES];
-		__u8 *comp_ptr[VIDEO_MAX_PLANES];
-
-		if (host_fd_to >= 0) {
-			unsigned tot_comp_size = 0;
-			unsigned tot_used = 0;
-
-			for (unsigned j = 0; j < buf.g_num_planes(); j++) {
-				__u32 used = buf.g_bytesused();
-				unsigned offset = buf.g_data_offset();
-				u8 *p = (u8 *)q.g_dataptr(buf.g_index(), j) + offset;
-
-				if (ctx) {
-					comp_ptr[j] = fwht_compress(ctx, p,
-								    used - offset, &comp_size[j]);
-				} else {
-					comp_ptr[j] = p;
-					comp_size[j] = rle_compress(p, used - offset,
-								    bpl_cap[j]);
-				}
-				tot_comp_size += comp_size[j];
-				tot_used += used - offset;
-			}
-			write_u32(fout, ctx ? V4L_STREAM_PACKET_FRAME_VIDEO_FWHT :
-					      V4L_STREAM_PACKET_FRAME_VIDEO_RLE);
-			write_u32(fout, V4L_STREAM_PACKET_FRAME_VIDEO_SIZE(buf.g_num_planes()) + tot_comp_size);
-			write_u32(fout, V4L_STREAM_PACKET_FRAME_VIDEO_SIZE_HDR);
-			write_u32(fout, buf.g_field());
-			write_u32(fout, buf.g_flags());
-			comp_perc += (tot_comp_size * 100 / tot_used);
-			comp_perc_count++;
-		}
-		if (to_with_hdr)
-			write_u32(fout, FILE_HDR_ID);
-		for (unsigned j = 0; j < buf.g_num_planes(); j++) {
-			__u32 used = buf.g_bytesused();
-			unsigned offset = buf.g_data_offset();
-			unsigned sz;
+	    buf.g_bytesused(0) && !(buf.g_flags() & V4L2_BUF_FLAG_ERROR))
+		write_buffer_to_file(q, buf, fout);
 
-			if (offset > used) {
-				// Should never happen
-				fprintf(stderr, "offset %d > used %d!\n",
-					offset, used);
-				offset = 0;
-			}
-			used -= offset;
-			if (host_fd_to >= 0) {
-				write_u32(fout, V4L_STREAM_PACKET_FRAME_VIDEO_SIZE_PLANE_HDR);
-				write_u32(fout, used);
-				write_u32(fout, comp_size[j]);
-				used = comp_size[j];
-			} else if (to_with_hdr) {
-				write_u32(fout, used);
-			}
-			if (host_fd_to >= 0)
-				sz = fwrite(comp_ptr[j] + offset, 1, used, fout);
-			else
-				sz = fwrite((u8 *)q.g_dataptr(buf.g_index(), j) + offset, 1, used, fout);
-
-			if (sz != used)
-				fprintf(stderr, "%u != %u\n", sz, used);
-		}
-		if (host_fd_to >= 0)
-			fflush(fout);
-	}
-#endif
 	if (buf.g_flags() & V4L2_BUF_FLAG_KEYFRAME)
 		ch = 'K';
 	else if (buf.g_flags() & V4L2_BUF_FLAG_PFRAME)
-- 
2.17.1

