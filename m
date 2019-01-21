Return-Path: <SRS0=kVnX=P5=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 38D3CC31680
	for <linux-media@archiver.kernel.org>; Mon, 21 Jan 2019 18:57:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id F16EA20861
	for <linux-media@archiver.kernel.org>; Mon, 21 Jan 2019 18:57:21 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="BMtj1wHp"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727338AbfAUS5V (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Mon, 21 Jan 2019 13:57:21 -0500
Received: from mail-wr1-f66.google.com ([209.85.221.66]:41176 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726575AbfAUS5U (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 21 Jan 2019 13:57:20 -0500
Received: by mail-wr1-f66.google.com with SMTP id x10so24590448wrs.8
        for <linux-media@vger.kernel.org>; Mon, 21 Jan 2019 10:57:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=ijCwH6DqnatoJm1xHFsdAVtYROaAMTdNO3FcfPqQE4w=;
        b=BMtj1wHpb31KW1h6sjfHIq0SSmv3MfJyv0hErCp3KLG2FpNUr8jqsSPiloS0FiDd5i
         QbgX2FSSkMIba2VANybjaGh0GGeXU/5KNi6TfBUYsKa5/IJBs7cq7VogHSYvi7g/d+ts
         YRjb6NUDJWIaH/T/ydEJYTe+cKSMNUXX4zVYJyXlBWyd9P8gDDYylArNT/yQf2juhY6f
         AbVGaBSpU7qAJ8FpG5EM1uWaro9/1tJCLMUtc0RCnE6iQIKbmiFRN8jLqsmOvZGbZ+4g
         XEVBZ064Ziie//0RrN5QFbQQGQGUfzfXpbqCg0WsdzBff/W8j4CURGhp3oSYTE9kTy2i
         J9Sg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=ijCwH6DqnatoJm1xHFsdAVtYROaAMTdNO3FcfPqQE4w=;
        b=hIm4QRdCl32zl+gpoMMVFW8UjrpwPDCvhxKe0FtUgQVScHEz2t6DWuhUH31i2tb3RB
         OyOnJWontgHms9KiCTkFLzjmYCKtzbGB9MBJtGHaAgvzaqFKi+KET90J1mAAcHXrWbFn
         Lz1sTgbj7ZQwajKdF+kFxW8BdictSO3L45Cn8/NbHHrn3DUPtAvmBt0TKxJ3Qu0Kd04R
         QpXnncmQa4GCp5hkk1pS7K9L9DIq3YNSgtuL5hM5pXzVoMSPSmJ/IVPW3XYctHMsRB+A
         BqAV76KzNQsaw6kAuU0oh1QxJbfiUaRisqz/Tzh/wSCTgAKAxDytLXDKU/qJfxZR2+ZI
         8ErA==
X-Gm-Message-State: AJcUukdiVZad7IJ20LxZW5Xox8oy/dvG0LdcCxsAz2OuPAcejxH35UVj
        SyCKI68Ux3ULeEnU4DzDDHH9J+5Y9Ts=
X-Google-Smtp-Source: ALg8bN49IUEkV5s+GjgtALFQ7H1lAGWagnpZmVSXVQOy2kiM310PPKMD4akw9xaiPlz96sqwSm6jXQ==
X-Received: by 2002:adf:f9cb:: with SMTP id w11mr28842737wrr.201.1548097037211;
        Mon, 21 Jan 2019 10:57:17 -0800 (PST)
Received: from localhost.localdomain ([87.70.46.65])
        by smtp.gmail.com with ESMTPSA id 67sm145061521wra.37.2019.01.21.10.57.15
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 21 Jan 2019 10:57:16 -0800 (PST)
From:   Dafna Hirschfeld <dafna3@gmail.com>
To:     linux-media@vger.kernel.org
Cc:     hverkuil@xs4all.nl, helen.koike@collabora.com,
        Dafna Hirschfeld <dafna3@gmail.com>
Subject: [v4l-utils PATCH v2 1/5] v4l2-ctl: Add support for crop and compose selection in streaming
Date:   Mon, 21 Jan 2019 10:56:47 -0800
Message-Id: <20190121185651.6229-2-dafna3@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190121185651.6229-1-dafna3@gmail.com>
References: <20190121185651.6229-1-dafna3@gmail.com>
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Support crop and compose selection.
If the driver supports crop/compose then the raw frame is arranged
inside a padded buffer.

Signed-off-by: Dafna Hirschfeld <dafna3@gmail.com>
---
 utils/common/codec-fwht.patch         |   8 +-
 utils/common/v4l-stream.c             |  14 +--
 utils/common/v4l-stream.h             |   6 +-
 utils/qvidcap/capture.cpp             |   2 +
 utils/v4l2-ctl/v4l2-ctl-streaming.cpp | 141 ++++++++++++++++++++++++--
 5 files changed, 150 insertions(+), 21 deletions(-)

diff --git a/utils/common/codec-fwht.patch b/utils/common/codec-fwht.patch
index 4d41225b..37ac4672 100644
--- a/utils/common/codec-fwht.patch
+++ b/utils/common/codec-fwht.patch
@@ -1,6 +1,6 @@
---- a/utils/common/codec-fwht.h.old	2018-11-23 13:43:52.713731559 +0100
-+++ b/utils/common/codec-fwht.h	2018-11-23 13:47:55.484198283 +0100
-@@ -8,8 +8,24 @@
+--- a/utils/common/codec-fwht.h.old	2018-12-29 11:23:58.128328613 -0800
++++ b/utils/common/codec-fwht.h	2018-12-29 11:24:16.099127560 -0800
+@@ -8,8 +8,26 @@
  #define CODEC_FWHT_H
  
  #include <linux/types.h>
@@ -17,6 +17,8 @@
 +#define GENMASK(h, l) \
 +	(((~0UL) - (1UL << (l)) + 1) & (~0UL >> ((8 * sizeof(long)) - 1 - (h))))
 +#define pr_err(arg...)
++#define __round_mask(x, y) ((__typeof__(x))((y)-1))
++#define round_up(x, y) ((((x)-1) | __round_mask(x, y))+1)
 +
 +
 +typedef __u32 u32;
diff --git a/utils/common/v4l-stream.c b/utils/common/v4l-stream.c
index 9f842e21..a1cabadb 100644
--- a/utils/common/v4l-stream.c
+++ b/utils/common/v4l-stream.c
@@ -171,25 +171,28 @@ unsigned rle_compress(__u8 *b, unsigned size, unsigned bpl)
 	return (__u8 *)dst - b;
 }
 
-struct codec_ctx *fwht_alloc(unsigned pixfmt, unsigned w, unsigned h,
+struct codec_ctx *fwht_alloc(unsigned pixfmt, unsigned visible_width, unsigned visible_height,
+			     unsigned coded_width, unsigned coded_height,
 			     unsigned field, unsigned colorspace, unsigned xfer_func,
 			     unsigned ycbcr_enc, unsigned quantization)
 {
 	struct codec_ctx *ctx;
 	const struct v4l2_fwht_pixfmt_info *info = v4l2_fwht_find_pixfmt(pixfmt);
 	unsigned int chroma_div;
-	unsigned int size = w * h;
+	unsigned int size = coded_width * coded_height;
 
 	// fwht expects macroblock alignment, check can be dropped once that
 	// restriction is lifted.
-	if (!info || w % 8 || h % 8)
+	if (!info || coded_width % 8 || coded_height % 8)
 		return NULL;
 
 	ctx = malloc(sizeof(*ctx));
 	if (!ctx)
 		return NULL;
-	ctx->state.width = w;
-	ctx->state.height = h;
+	ctx->state.coded_width = coded_width;
+	ctx->state.coded_height = coded_height;
+	ctx->state.visible_width = visible_width;
+	ctx->state.visible_height = visible_height;
 	ctx->state.info = info;
 	ctx->field = field;
 	ctx->state.colorspace = colorspace;
@@ -208,7 +211,6 @@ struct codec_ctx *fwht_alloc(unsigned pixfmt, unsigned w, unsigned h,
 		free(ctx);
 		return NULL;
 	}
-	ctx->state.ref_frame.width = ctx->state.ref_frame.height = 0;
 	ctx->state.ref_frame.cb = ctx->state.ref_frame.luma + size;
 	ctx->state.ref_frame.cr = ctx->state.ref_frame.cb + size / chroma_div;
 	ctx->state.ref_frame.alpha = ctx->state.ref_frame.cr + size / chroma_div;
diff --git a/utils/common/v4l-stream.h b/utils/common/v4l-stream.h
index c235150b..fe5dfe90 100644
--- a/utils/common/v4l-stream.h
+++ b/utils/common/v4l-stream.h
@@ -9,12 +9,13 @@
 #define _V4L_STREAM_H_
 
 #include <linux/videodev2.h>
-#include <codec-v4l2-fwht.h>
 
 #ifdef __cplusplus
 extern "C" {
 #endif /* __cplusplus */
 
+#include <codec-v4l2-fwht.h>
+
 /* Default port */
 #define V4L_STREAM_PORT 8362
 
@@ -145,7 +146,8 @@ struct codec_ctx {
 
 unsigned rle_compress(__u8 *buf, unsigned size, unsigned bytesperline);
 void rle_decompress(__u8 *buf, unsigned size, unsigned rle_size, unsigned bytesperline);
-struct codec_ctx *fwht_alloc(unsigned pixfmt, unsigned w, unsigned h, unsigned field,
+struct codec_ctx *fwht_alloc(unsigned pixfmt, unsigned visible_width, unsigned visible_height,
+			     unsigned coded_width, unsigned coded_height, unsigned field,
 			     unsigned colorspace, unsigned xfer_func, unsigned ycbcr_enc,
 			     unsigned quantization);
 void fwht_free(struct codec_ctx *ctx);
diff --git a/utils/qvidcap/capture.cpp b/utils/qvidcap/capture.cpp
index 8c11ac53..e04db6be 100644
--- a/utils/qvidcap/capture.cpp
+++ b/utils/qvidcap/capture.cpp
@@ -749,6 +749,7 @@ void CaptureWin::setModeSocket(int socket, int port)
 	if (m_ctx)
 		free(m_ctx);
 	m_ctx = fwht_alloc(m_v4l_fmt.g_pixelformat(), m_v4l_fmt.g_width(), m_v4l_fmt.g_height(),
+			   m_v4l_fmt.g_width(), m_v4l_fmt.g_height(),
 			   m_v4l_fmt.g_field(), m_v4l_fmt.g_colorspace(), m_v4l_fmt.g_xfer_func(),
 			   m_v4l_fmt.g_ycbcr_enc(), m_v4l_fmt.g_quantization());
 
@@ -1114,6 +1115,7 @@ void CaptureWin::listenForNewConnection()
 	if (m_ctx)
 		free(m_ctx);
 	m_ctx = fwht_alloc(fmt.g_pixelformat(), fmt.g_width(), fmt.g_height(),
+			   fmt.g_width(), fmt.g_height(),
 			   fmt.g_field(), fmt.g_colorspace(), fmt.g_xfer_func(),
 			   fmt.g_ycbcr_enc(), fmt.g_quantization());
 	setPixelAspect(pixelaspect);
diff --git a/utils/v4l2-ctl/v4l2-ctl-streaming.cpp b/utils/v4l2-ctl/v4l2-ctl-streaming.cpp
index 79e015ce..8a98b6bd 100644
--- a/utils/v4l2-ctl/v4l2-ctl-streaming.cpp
+++ b/utils/v4l2-ctl/v4l2-ctl-streaming.cpp
@@ -20,7 +20,6 @@
 
 #include "v4l2-ctl.h"
 #include "v4l-stream.h"
-#include "codec-fwht.h"
 
 extern "C" {
 #include "v4l2-tpg.h"
@@ -73,6 +72,13 @@ static unsigned bpl_out[VIDEO_MAX_PLANES];
 static bool last_buffer = false;
 static codec_ctx *ctx;
 
+static unsigned int cropped_width;
+static unsigned int cropped_height;
+static unsigned int composed_width;
+static unsigned int composed_height;
+static bool support_cap_compose;
+static bool support_out_crop;
+
 #define TS_WINDOW 241
 #define FILE_HDR_ID			v4l2_fourcc('V', 'h', 'd', 'r')
 
@@ -657,7 +663,60 @@ void streaming_cmd(int ch, char *optarg)
 	}
 }
 
-static bool fill_buffer_from_file(cv4l_queue &q, cv4l_buffer &b, FILE *fin)
+static void read_write_padded_frame(cv4l_fmt &fmt, unsigned char *buf,
+				    FILE *fpointer, unsigned &sz,
+				    unsigned &len, bool is_read)
+{
+	const struct v4l2_fwht_pixfmt_info *vic_fmt = v4l2_fwht_find_pixfmt(fmt.g_pixelformat());
+	unsigned coded_height = fmt.g_height();
+	unsigned real_width;
+	unsigned real_height;
+	unsigned char *plane_p = buf;
+	unsigned char *row_p;
+
+	if (is_read) {
+		real_width  = cropped_width;
+		real_height = cropped_height;
+	} else {
+		real_width  = composed_width;
+		real_height = composed_height;
+	}
+
+	sz = 0;
+	len = real_width * real_height * vic_fmt->sizeimage_mult / vic_fmt->sizeimage_div;
+
+	for (unsigned plane_idx = 0; plane_idx < vic_fmt->planes_num; plane_idx++) {
+		bool is_chroma_plane = plane_idx == 1 || plane_idx == 2;
+		unsigned h_div = is_chroma_plane ? vic_fmt->height_div : 1;
+		unsigned w_div = is_chroma_plane ? vic_fmt->width_div : 1;
+		unsigned step = is_chroma_plane ? vic_fmt->chroma_step : vic_fmt->luma_alpha_step;
+		unsigned stride_div = (vic_fmt->planes_num == 3 && plane_idx > 0) ? 2 : 1;
+
+		row_p = plane_p;
+		for (unsigned i = 0; i < real_height / h_div; i++) {
+			unsigned int wsz = 0;
+			unsigned int consume_sz = step * real_width / w_div;
+
+			if (is_read)
+				wsz = fread(row_p, 1, consume_sz, fpointer);
+			else
+				wsz = fwrite(row_p, 1, consume_sz, fpointer);
+			if (wsz == 0 && i == 0 && plane_idx == 0)
+				break;
+			if (wsz != consume_sz) {
+				fprintf(stderr, "padding: needed %u bytes, got %u\n", consume_sz, wsz);
+				return;
+			}
+			sz += wsz;
+			row_p += fmt.g_bytesperline() / stride_div;
+		}
+		plane_p += (fmt.g_bytesperline() / stride_div) * (coded_height / h_div);
+		if (sz == 0)
+			break;
+	}
+}
+
+static bool fill_buffer_from_file(cv4l_fd &fd, cv4l_queue &q, cv4l_buffer &b, FILE *fin)
 {
 	static bool first = true;
 	static bool is_fwht = false;
@@ -776,7 +835,9 @@ restart:
 		void *buf = q.g_dataptr(b.g_index(), j);
 		unsigned len = q.g_length(j);
 		unsigned sz;
+		cv4l_fmt fmt;
 
+		fd.g_fmt(fmt, q.g_type());
 		if (from_with_hdr) {
 			len = read_u32(fin);
 			if (len > q.g_length(j)) {
@@ -785,7 +846,12 @@ restart:
 				return false;
 			}
 		}
-		sz = fread(buf, 1, len, fin);
+
+		if (support_out_crop && v4l2_fwht_find_pixfmt(fmt.g_pixelformat()))
+			read_write_padded_frame(fmt, (unsigned char *)buf, fin, sz, len, true);
+		else
+			sz = fread(buf, 1, len, fin);
+
 		if (first && sz != len) {
 			fprintf(stderr, "Insufficient data\n");
 			return false;
@@ -908,7 +974,7 @@ static int do_setup_out_buffers(cv4l_fd &fd, cv4l_queue &q, FILE *fin, bool qbuf
 					tpg_fillbuffer(&tpg, stream_out_std, j, (u8 *)q.g_dataptr(i, j));
 			}
 		}
-		if (fin && !fill_buffer_from_file(q, buf, fin))
+		if (fin && !fill_buffer_from_file(fd, q, buf, fin))
 			return -2;
 
 		if (qbuf) {
@@ -926,7 +992,7 @@ static int do_setup_out_buffers(cv4l_fd &fd, cv4l_queue &q, FILE *fin, bool qbuf
 	return 0;
 }
 
-static void write_buffer_to_file(cv4l_queue &q, cv4l_buffer &buf, FILE *fout)
+static void write_buffer_to_file(cv4l_fd &fd, cv4l_queue &q, cv4l_buffer &buf, FILE *fout)
 {
 #ifndef NO_STREAM_TO
 	unsigned comp_size[VIDEO_MAX_PLANES];
@@ -967,7 +1033,9 @@ static void write_buffer_to_file(cv4l_queue &q, cv4l_buffer &buf, FILE *fout)
 		__u32 used = buf.g_bytesused();
 		unsigned offset = buf.g_data_offset();
 		unsigned sz;
+		cv4l_fmt fmt;
 
+		fd.g_fmt(fmt, q.g_type());
 		if (offset > used) {
 			// Should never happen
 			fprintf(stderr, "offset %d > used %d!\n",
@@ -985,6 +1053,9 @@ static void write_buffer_to_file(cv4l_queue &q, cv4l_buffer &buf, FILE *fout)
 		}
 		if (host_fd_to >= 0)
 			sz = fwrite(comp_ptr[j] + offset, 1, used, fout);
+		else if (support_cap_compose && v4l2_fwht_find_pixfmt(fmt.g_pixelformat()))
+			read_write_padded_frame(fmt, (u8 *)q.g_dataptr(buf.g_index(), j) + offset,
+						fout, sz, used, false);
 		else
 			sz = fwrite((u8 *)q.g_dataptr(buf.g_index(), j) + offset, 1, used, fout);
 
@@ -1036,7 +1107,7 @@ static int do_handle_cap(cv4l_fd &fd, cv4l_queue &q, FILE *fout, int *index,
 
 	if (fout && (!stream_skip || ignore_count_skip) &&
 	    buf.g_bytesused(0) && !(buf.g_flags() & V4L2_BUF_FLAG_ERROR))
-		write_buffer_to_file(q, buf, fout);
+		write_buffer_to_file(fd, q, buf, fout);
 
 	if (buf.g_flags() & V4L2_BUF_FLAG_KEYFRAME)
 		ch = 'K';
@@ -1135,7 +1206,7 @@ static int do_handle_out(cv4l_fd &fd, cv4l_queue &q, FILE *fin, cv4l_buffer *cap
 			output_field = V4L2_FIELD_TOP;
 	}
 
-	if (fin && !fill_buffer_from_file(q, buf, fin))
+	if (fin && !fill_buffer_from_file(fd, q, buf, fin))
 		return -2;
 
 	if (!fin && stream_out_refresh) {
@@ -1333,10 +1404,15 @@ recover:
 			write_u32(fout, cfmt.g_bytesperline(i));
 			bpl_cap[i] = rle_calc_bpl(cfmt.g_bytesperline(i), cfmt.g_pixelformat());
 		}
-		if (!host_lossless)
-			ctx = fwht_alloc(cfmt.g_pixelformat(), cfmt.g_width(), cfmt.g_height(),
+		if (!host_lossless) {
+			unsigned visible_width = support_cap_compose ? composed_width : cfmt.g_width();
+			unsigned visible_height = support_cap_compose ? composed_height : cfmt.g_height();
+
+			ctx = fwht_alloc(cfmt.g_pixelformat(), visible_width, visible_height,
+					 cfmt.g_width(), cfmt.g_height(),
 					 cfmt.g_field(), cfmt.g_colorspace(), cfmt.g_xfer_func(),
 					 cfmt.g_ycbcr_enc(), cfmt.g_quantization());
+		}
 		fflush(fout);
 	}
 #endif
@@ -1560,7 +1636,11 @@ static void streaming_set_out(cv4l_fd &fd)
 		cfmt.s_quantization(read_u32(fin));
 		cfmt.s_xfer_func(read_u32(fin));
 		cfmt.s_flags(read_u32(fin));
-		ctx = fwht_alloc(cfmt.g_pixelformat(), cfmt.g_width(), cfmt.g_height(),
+		unsigned visible_width = support_out_crop ? cropped_width : cfmt.g_width();
+		unsigned visible_height = support_out_crop ? cropped_height : cfmt.g_height();
+
+		ctx = fwht_alloc(cfmt.g_pixelformat(), visible_width, visible_height,
+				 cfmt.g_width(), cfmt.g_height(),
 				 cfmt.g_field(), cfmt.g_colorspace(), cfmt.g_xfer_func(),
 				 cfmt.g_ycbcr_enc(), cfmt.g_quantization());
 
@@ -2029,6 +2109,44 @@ done:
 		fclose(file[OUT]);
 }
 
+static int get_cap_compose_rect(cv4l_fd &fd)
+{
+	v4l2_selection sel;
+
+	memset(&sel, 0, sizeof(sel));
+	sel.type = vidcap_buftype;
+	sel.target = V4L2_SEL_TGT_COMPOSE;
+
+	if (fd.g_selection(sel) == 0) {
+		support_cap_compose = true;
+		composed_width = sel.r.width;
+		composed_height = sel.r.height;
+		return 0;
+	}
+
+	support_cap_compose = false;
+	return 0;
+}
+
+static int get_out_crop_rect(cv4l_fd &fd)
+{
+	v4l2_selection sel;
+
+	memset(&sel, 0, sizeof(sel));
+	sel.type = vidout_buftype;
+	sel.target = V4L2_SEL_TGT_CROP;
+
+	if (fd.g_selection(sel) == 0) {
+		support_out_crop = true;
+		cropped_width = sel.r.width;
+		cropped_height = sel.r.height;
+		return 0;
+	}
+
+	support_out_crop = false;
+	return 0;
+}
+
 void streaming_set(cv4l_fd &fd, cv4l_fd &out_fd)
 {
 	cv4l_disable_trace dt(fd);
@@ -2036,6 +2154,9 @@ void streaming_set(cv4l_fd &fd, cv4l_fd &out_fd)
 	int do_cap = options[OptStreamMmap] + options[OptStreamUser] + options[OptStreamDmaBuf];
 	int do_out = options[OptStreamOutMmap] + options[OptStreamOutUser] + options[OptStreamOutDmaBuf];
 
+	get_cap_compose_rect(fd);
+	get_out_crop_rect(fd);
+
 	if (out_fd.g_fd() < 0) {
 		out_capabilities = capabilities;
 		out_priv_magic = priv_magic;
-- 
2.17.1

