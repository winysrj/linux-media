Return-Path: <SRS0=kVnX=P5=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 30D2CC31681
	for <linux-media@archiver.kernel.org>; Mon, 21 Jan 2019 18:57:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id ED0BE20861
	for <linux-media@archiver.kernel.org>; Mon, 21 Jan 2019 18:57:24 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="iKKtXfHg"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727869AbfAUS5Y (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Mon, 21 Jan 2019 13:57:24 -0500
Received: from mail-wm1-f65.google.com ([209.85.128.65]:32870 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727430AbfAUS5Y (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 21 Jan 2019 13:57:24 -0500
Received: by mail-wm1-f65.google.com with SMTP id r24so6829894wmh.0
        for <linux-media@vger.kernel.org>; Mon, 21 Jan 2019 10:57:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=y1Vt+vupSml16wurFI+vB0XMni0wWuun1RPz8W5SZWk=;
        b=iKKtXfHg4LHfqNA1M0BHo0PH5DZ9ppMm18DOu3kVbe3KEgHuOh+rrH1zCVcSBkC/VR
         my1Zu74n5BqBeL4W0h8da5mxW71jrSAkUBOYWWWRqpAxFbnT9EyoeFjD/N39lI2+3YqB
         4P80K5FZZMuAKt7piHISBbWy2ktq1ZzjrXFRoDgH/8uzVLWZgPTmYida8i+taS2VyDEs
         XeYbglhLnFV9A4DB/P9vmeJhY/Nx5rTWf6xP/4LMyZqidoOPRKB5im6TtwMTpg0VB2RS
         nt2toYP9Fr9WsBsIM47E1Kxb1JWcc8bmhS7zoeVfy3lkac3eJK5kBwWGiwi1TED6lW9I
         50qw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=y1Vt+vupSml16wurFI+vB0XMni0wWuun1RPz8W5SZWk=;
        b=ofYiYk+hmLeAsRhx0wetTAA5uaX/D4WEp8yNGIZQ24mKVyUlWHAW/Bf1f8xtq15uy6
         zMgKni3hZo5jaxt0hMRw8yc8cqZcBMwXTkHCD734WOIYiBh8Nk4j3hGhR8uW2yY02mcE
         nXR3a4KEaPzGcQmDZkx6mpPcalMsSQmP4OSDedPwwznlM2h1LGC32/RyNRXwSYwsSZ7s
         qVLsk1CCf7qX0vSexFzNsT4dLhknHwXNVlqR0XHTgVtNzTEvjz1uKnx56UFqHcSS7P+f
         rMSQv20Spx2ZryQIf+v8WtYJaBVyTL5ClpY/wLekSo74p4kbiqw63VNGS2yNDxrYznIK
         rCsQ==
X-Gm-Message-State: AJcUuke7u6epxmvwaPOS2VeMhL4scb6SCZzmsMCiod707uHF5vCtTwqS
        s3843snt27U1v+vdTpwbEkfvcPR3hPo=
X-Google-Smtp-Source: ALg8bN78KM6vBt8z5dv+D2lmSd7unNv5fOg3u5JJ55VBO20zJ7KxtTaj1oIX7JMI1Y2HkBIzl1FRcA==
X-Received: by 2002:a1c:5fd7:: with SMTP id t206mr557135wmb.145.1548097041114;
        Mon, 21 Jan 2019 10:57:21 -0800 (PST)
Received: from localhost.localdomain ([87.70.46.65])
        by smtp.gmail.com with ESMTPSA id 67sm145061521wra.37.2019.01.21.10.57.19
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 21 Jan 2019 10:57:20 -0800 (PST)
From:   Dafna Hirschfeld <dafna3@gmail.com>
To:     linux-media@vger.kernel.org
Cc:     hverkuil@xs4all.nl, helen.koike@collabora.com,
        Dafna Hirschfeld <dafna3@gmail.com>
Subject: [v4l-utils PATCH v2 4/5] v4l2-ctl: Add support for source change event for m2m decoder
Date:   Mon, 21 Jan 2019 10:56:50 -0800
Message-Id: <20190121185651.6229-5-dafna3@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190121185651.6229-1-dafna3@gmail.com>
References: <20190121185651.6229-1-dafna3@gmail.com>
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Subscribe to source change event.
The capture setup sequence is executed only due to a
change event.

Signed-off-by: Dafna Hirschfeld <dafna3@gmail.com>
---
 utils/v4l2-ctl/v4l2-ctl-streaming.cpp | 112 +++++++++++++++++++-------
 1 file changed, 85 insertions(+), 27 deletions(-)

diff --git a/utils/v4l2-ctl/v4l2-ctl-streaming.cpp b/utils/v4l2-ctl/v4l2-ctl-streaming.cpp
index d74a6c0b..8d034b85 100644
--- a/utils/v4l2-ctl/v4l2-ctl-streaming.cpp
+++ b/utils/v4l2-ctl/v4l2-ctl-streaming.cpp
@@ -78,6 +78,7 @@ static unsigned int composed_width;
 static unsigned int composed_height;
 static bool support_cap_compose;
 static bool support_out_crop;
+static bool in_source_change_event;
 
 #define TS_WINDOW 241
 #define FILE_HDR_ID			v4l2_fourcc('V', 'h', 'd', 'r')
@@ -752,7 +753,8 @@ static void read_write_padded_frame(cv4l_fmt &fmt, unsigned char *buf,
 				    FILE *fpointer, unsigned &sz,
 				    unsigned &len, bool is_read)
 {
-	const struct v4l2_fwht_pixfmt_info *vic_fmt = v4l2_fwht_find_pixfmt(fmt.g_pixelformat());
+	const struct v4l2_fwht_pixfmt_info *vic_fmt =
+			v4l2_fwht_find_pixfmt(fmt.g_pixelformat());
 	unsigned coded_height = fmt.g_height();
 	unsigned real_width;
 	unsigned real_height;
@@ -801,7 +803,8 @@ static void read_write_padded_frame(cv4l_fmt &fmt, unsigned char *buf,
 	}
 }
 
-static bool fill_buffer_from_file(cv4l_fd &fd, cv4l_queue &q, cv4l_buffer &b, FILE *fin)
+static bool fill_buffer_from_file(cv4l_fd &fd, cv4l_queue &q, cv4l_buffer &b,
+				  cv4l_fmt &fmt, FILE *fin)
 {
 	static bool first = true;
 	static bool is_fwht = false;
@@ -1059,7 +1062,7 @@ static int do_setup_out_buffers(cv4l_fd &fd, cv4l_queue &q, FILE *fin, bool qbuf
 					tpg_fillbuffer(&tpg, stream_out_std, j, (u8 *)q.g_dataptr(i, j));
 			}
 		}
-		if (fin && !fill_buffer_from_file(fd, q, buf, fin))
+		if (fin && !fill_buffer_from_file(fd, q, buf, fmt, fin))
 			return -2;
 
 		if (qbuf) {
@@ -1077,7 +1080,8 @@ static int do_setup_out_buffers(cv4l_fd &fd, cv4l_queue &q, FILE *fin, bool qbuf
 	return 0;
 }
 
-static void write_buffer_to_file(cv4l_fd &fd, cv4l_queue &q, cv4l_buffer &buf, FILE *fout)
+static void write_buffer_to_file(cv4l_fd &fd, cv4l_queue &q, cv4l_buffer &buf,
+				 cv4l_fmt &fmt, FILE *fout)
 {
 #ifndef NO_STREAM_TO
 	unsigned comp_size[VIDEO_MAX_PLANES];
@@ -1118,9 +1122,7 @@ static void write_buffer_to_file(cv4l_fd &fd, cv4l_queue &q, cv4l_buffer &buf, F
 		__u32 used = buf.g_bytesused();
 		unsigned offset = buf.g_data_offset();
 		unsigned sz;
-		cv4l_fmt fmt;
 
-		fd.g_fmt(fmt, q.g_type());
 		if (offset > used) {
 			// Should never happen
 			fprintf(stderr, "offset %d > used %d!\n",
@@ -1153,7 +1155,7 @@ static void write_buffer_to_file(cv4l_fd &fd, cv4l_queue &q, cv4l_buffer &buf, F
 }
 
 static int do_handle_cap(cv4l_fd &fd, cv4l_queue &q, FILE *fout, int *index,
-			 unsigned &count, fps_timestamps &fps_ts)
+			 unsigned &count, fps_timestamps &fps_ts, cv4l_fmt &fmt)
 {
 	char ch = '<';
 	int ret;
@@ -1192,7 +1194,7 @@ static int do_handle_cap(cv4l_fd &fd, cv4l_queue &q, FILE *fout, int *index,
 
 	if (fout && (!stream_skip || ignore_count_skip) &&
 	    buf.g_bytesused(0) && !(buf.g_flags() & V4L2_BUF_FLAG_ERROR))
-		write_buffer_to_file(fd, q, buf, fout);
+		write_buffer_to_file(fd, q, buf, fmt, fout);
 
 	if (buf.g_flags() & V4L2_BUF_FLAG_KEYFRAME)
 		ch = 'K';
@@ -1205,8 +1207,18 @@ static int do_handle_cap(cv4l_fd &fd, cv4l_queue &q, FILE *fout, int *index,
 				     host_fd_to >= 0 ? 100 - comp_perc / comp_perc_count : -1);
 		comp_perc_count = comp_perc = 0;
 	}
-	if (!last_buffer && index == NULL && fd.qbuf(buf))
-		return -1;
+	if (!last_buffer && index == NULL) {
+		/*
+		 * EINVAL in qbuf can happen if this is the last buffer before
+		 * a dynamic resolution change sequence. In this case the buffer
+		 * has the size that fits the old resolution and might not
+		 * fit to the new one.
+		 */
+		if (fd.qbuf(buf) && errno != EINVAL) {
+			fprintf(stderr, "%s: qbuf error\n", __func__);
+			return -1;
+		}
+	}
 	if (index)
 		*index = buf.g_index();
 
@@ -1246,7 +1258,7 @@ static int do_handle_cap(cv4l_fd &fd, cv4l_queue &q, FILE *fout, int *index,
 }
 
 static int do_handle_out(cv4l_fd &fd, cv4l_queue &q, FILE *fin, cv4l_buffer *cap,
-			 unsigned &count, fps_timestamps &fps_ts)
+			 unsigned &count, fps_timestamps &fps_ts, cv4l_fmt fmt)
 {
 	cv4l_buffer buf(q);
 	int ret = 0;
@@ -1291,7 +1303,7 @@ static int do_handle_out(cv4l_fd &fd, cv4l_queue &q, FILE *fin, cv4l_buffer *cap
 			output_field = V4L2_FIELD_TOP;
 	}
 
-	if (fin && !fill_buffer_from_file(fd, q, buf, fin))
+	if (fin && !fill_buffer_from_file(fd, q, buf, fmt, fin))
 		return -2;
 
 	if (!fin && stream_out_refresh) {
@@ -1365,6 +1377,9 @@ static void streaming_set_cap(cv4l_fd &fd)
 	bool eos;
 	bool source_change;
 	FILE *fout = NULL;
+	cv4l_fmt fmt;
+
+	fd.g_fmt(fmt);
 
 	if (!(capabilities & (V4L2_CAP_VIDEO_CAPTURE | V4L2_CAP_VIDEO_CAPTURE_MPLANE |
 			      V4L2_CAP_VBI_CAPTURE | V4L2_CAP_SLICED_VBI_CAPTURE |
@@ -1573,7 +1588,7 @@ recover:
 
 		if (FD_ISSET(fd.g_fd(), &read_fds)) {
 			r = do_handle_cap(fd, q, fout, NULL,
-					   count, fps_ts);
+					   count, fps_ts, fmt);
 			if (r == -1)
 				break;
 		}
@@ -1605,6 +1620,9 @@ static void streaming_set_out(cv4l_fd &fd)
 	fps_timestamps fps_ts;
 	unsigned count = 0;
 	FILE *fin = NULL;
+	cv4l_fmt fmt;
+
+	fd.g_fmt(fmt);
 
 	if (!(capabilities & (V4L2_CAP_VIDEO_OUTPUT | V4L2_CAP_VIDEO_OUTPUT_MPLANE |
 			      V4L2_CAP_VBI_OUTPUT | V4L2_CAP_SLICED_VBI_OUTPUT |
@@ -1806,7 +1824,7 @@ static void streaming_set_out(cv4l_fd &fd)
 			}
 		}
 		r = do_handle_out(fd, q, fin, NULL,
-				   count, fps_ts);
+				   count, fps_ts, fmt);
 		if (r == -1)
 			break;
 
@@ -1875,6 +1893,11 @@ static void streaming_set_m2m(cv4l_fd &fd)
 	fd_set *rd_fds = &fds[0]; /* for capture */
 	fd_set *ex_fds = &fds[1]; /* for capture */
 	fd_set *wr_fds = &fds[2]; /* for output */
+	bool cap_streaming = false;
+	cv4l_fmt fmt[2];
+
+	fd.g_fmt(fmt[OUT], out.g_type());
+	fd.g_fmt(fmt[CAP], in.g_type());
 
 	if (!fd.has_vid_m2m()) {
 		fprintf(stderr, "unsupported m2m stream type\n");
@@ -1897,6 +1920,10 @@ static void streaming_set_m2m(cv4l_fd &fd)
 
 	bool have_eos = !fd.subscribe_event(sub);
 	bool is_encoder = false;
+	enum codec_type codec_type = get_codec_type(fd);
+
+	if (codec_type == NOT_CODEC)
+		goto done;
 
 	if (have_eos) {
 		cv4l_fmt fmt(in.g_type());
@@ -1905,6 +1932,11 @@ static void streaming_set_m2m(cv4l_fd &fd)
 		is_encoder = !fmt.g_bytesperline();
 	}
 
+	memset(&sub, 0, sizeof(sub));
+	sub.type = V4L2_EVENT_SOURCE_CHANGE;
+	if (fd.subscribe_event(sub))
+		goto done;
+
 	if (file_to) {
 		if (!strcmp(file_to, "-"))
 			file[CAP] = stdout;
@@ -1936,8 +1968,9 @@ static void streaming_set_m2m(cv4l_fd &fd)
 	if (fd.streamon(out.g_type()))
 		goto done;
 
-	if (capture_setup(fd, in))
-		goto done;
+	if (codec_type == ENCODER)
+		if (capture_setup(fd, in))
+			goto done;
 
 	fps_ts[CAP].determine_field(fd.g_fd(), in.g_type());
 	fps_ts[OUT].determine_field(fd.g_fd(), out.g_type());
@@ -1982,7 +2015,7 @@ static void streaming_set_m2m(cv4l_fd &fd)
 
 		if (rd_fds && FD_ISSET(fd.g_fd(), rd_fds)) {
 			r = do_handle_cap(fd, in, file[CAP], NULL,
-					  count[CAP], fps_ts[CAP]);
+					  count[CAP], fps_ts[CAP], fmt[CAP]);
 			if (r < 0) {
 				rd_fds = NULL;
 				if (!have_eos) {
@@ -1990,13 +2023,11 @@ static void streaming_set_m2m(cv4l_fd &fd)
 					break;
 				}
 			}
-			if (last_buffer)
-				break;
 		}
 
 		if (wr_fds && FD_ISSET(fd.g_fd(), wr_fds)) {
 			r = do_handle_out(fd, out, file[OUT], NULL,
-					  count[OUT], fps_ts[OUT]);
+					  count[OUT], fps_ts[OUT], fmt[OUT]);
 			if (r < 0)  {
 				wr_fds = NULL;
 
@@ -2022,11 +2053,35 @@ static void streaming_set_m2m(cv4l_fd &fd)
 			struct v4l2_event ev;
 
 			while (!fd.dqevent(ev)) {
-				if (ev.type != V4L2_EVENT_EOS)
-					continue;
-				wr_fds = NULL;
-				fprintf(stderr, "EOS");
-				fflush(stderr);
+				if (ev.type == V4L2_EVENT_EOS) {
+					wr_fds = NULL;
+					fprintf(stderr, "EOS");
+					fflush(stderr);
+				} else if (ev.type == V4L2_EVENT_SOURCE_CHANGE) {
+					fprintf(stderr, "SOURCE CHANGE\n");
+					in_source_change_event = true;
+
+					/*
+					 * if capture is not streaming, the
+					 * driver will not send a last buffer so
+					 * we set it here
+					 */
+					if (!cap_streaming)
+						last_buffer = true;
+				}
+			}
+		}
+
+		if (last_buffer) {
+			if (in_source_change_event) {
+				in_source_change_event = false;
+				last_buffer = false;
+				if (capture_setup(fd, in))
+					goto done;
+				fd.g_fmt(fmt[OUT], out.g_type());
+				fd.g_fmt(fmt[CAP], in.g_type());
+				cap_streaming = true;
+			} else {
 				break;
 			}
 		}
@@ -2063,7 +2118,10 @@ static void streaming_set_cap2out(cv4l_fd &fd, cv4l_fd &out_fd)
 	FILE *file[2] = {NULL, NULL};
 	fd_set fds;
 	unsigned cnt = 0;
+	cv4l_fmt fmt[2];
 
+	fd.g_fmt(fmt[OUT], out.g_type());
+	fd.g_fmt(fmt[CAP], in.g_type());
 	if (!(capabilities & (V4L2_CAP_VIDEO_CAPTURE |
 			      V4L2_CAP_VIDEO_CAPTURE_MPLANE |
 			      V4L2_CAP_VIDEO_M2M |
@@ -2179,7 +2237,7 @@ static void streaming_set_cap2out(cv4l_fd &fd, cv4l_fd &out_fd)
 			int index = -1;
 
 			r = do_handle_cap(fd, in, file[CAP], &index,
-					   count[CAP], fps_ts[CAP]);
+					  count[CAP], fps_ts[CAP], fmt[CAP]);
 			if (r)
 				fprintf(stderr, "handle cap %d\n", r);
 			if (!r) {
@@ -2188,7 +2246,7 @@ static void streaming_set_cap2out(cv4l_fd &fd, cv4l_fd &out_fd)
 				if (fd.querybuf(buf))
 					break;
 				r = do_handle_out(out_fd, out, file[OUT], &buf,
-					   count[OUT], fps_ts[OUT]);
+						  count[OUT], fps_ts[OUT], fmt[OUT]);
 			}
 			if (r)
 				fprintf(stderr, "handle out %d\n", r);
-- 
2.17.1

