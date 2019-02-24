Return-Path: <SRS0=d4St=Q7=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E5C69C00319
	for <linux-media@archiver.kernel.org>; Sun, 24 Feb 2019 08:41:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A95EB206BA
	for <linux-media@archiver.kernel.org>; Sun, 24 Feb 2019 08:41:56 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="V3GVFFh5"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728149AbfBXIl4 (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Sun, 24 Feb 2019 03:41:56 -0500
Received: from mail-wr1-f67.google.com ([209.85.221.67]:44047 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726459AbfBXIlz (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sun, 24 Feb 2019 03:41:55 -0500
Received: by mail-wr1-f67.google.com with SMTP id w2so6612555wrt.11
        for <linux-media@vger.kernel.org>; Sun, 24 Feb 2019 00:41:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=Ga5/g3343M9bUseYVhoKeXA13d/ynfyPrcFECoXQMd0=;
        b=V3GVFFh5pcgKwV1XdokPId9rmkGbTpSY03+NcGGeWeIBz3/eseytIqKIs47HoF7t2I
         OUkjA4bEbyqsHZbDCicDDib4n/TR/WfByOmd4PPYKTM1Xdr4oHllMRb/MNORFKoANyTt
         5MRkwWdgW0Q0aIBEitG+zh/z3WwbUskeEYMTRWuElwSChvBG3Bn91mMeowSlJFMscpMx
         M0OVhI97HZxuTySPCsafubXRtP33PEtO9llgHi3RaHwtqxjWHC3Ga7LbUewX0gnpQJAg
         ZR39/DXUKX4n4kK1VSrPodm3DqXKWSsOJ061ifJOic+PhSnGf+J2+k6daDpzAK+kISga
         MJPQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=Ga5/g3343M9bUseYVhoKeXA13d/ynfyPrcFECoXQMd0=;
        b=eUgJw8P7yi7Kjq1ov8HZZAgIglQr5W8GqDySII4lo1TnflvQvaekmMidFyreRP2IE7
         mrpnMTjVSguhNWkkaHm6SMIyfvhQlMcfKGg3ZhAmD5VvP1RigRjJAfv4u1cW/wwRwhaf
         zpkBropKiy1fFivWVq2WZU+fJ4j444sGl6Npd8VzzJBv3WGlcbhNQz1oD9kvHhZaJh/x
         C7w+9ORSNBGEH82NLzmQh3sAu6CAduQHgQ1KsKD1eEByU5g+dzxQOc+lVAl8NDVcUtAV
         jF2ka9p4NayRmHKK/SC+SNA24XTmP5FJtNEm2fl0bch7ZWZsNvVejdKf8HqgEo1kqYNl
         RguA==
X-Gm-Message-State: AHQUAuaQKBpeVo7SvMnMS9DkJUQqgSm7Xfa3clBAkPHxLQtg3JsunLLv
        2EQ0DM+7RrVghk7jjPA2SLlPoMe+9aQ=
X-Google-Smtp-Source: AHgI3IYTzP6fasaVN9hKi1i1ZopWLZZvrC7ldItj/9jmjFr/40X2LOJ4L3GbgFwmeWumbG00PkuHKg==
X-Received: by 2002:a5d:5111:: with SMTP id s17mr8516065wrt.183.1550997713598;
        Sun, 24 Feb 2019 00:41:53 -0800 (PST)
Received: from ubuntu.home ([77.127.107.32])
        by smtp.gmail.com with ESMTPSA id x24sm6837465wmi.5.2019.02.24.00.41.52
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 24 Feb 2019 00:41:53 -0800 (PST)
From:   Dafna Hirschfeld <dafna3@gmail.com>
To:     linux-media@vger.kernel.org
Cc:     hverkuil@xs4all.nl, helen.koike@collabora.com,
        Dafna Hirschfeld <dafna3@gmail.com>
Subject: [v4l-utils PATCH v3 8/8] v4l2-ctl: Add implementation for the stateless fwht decoder.
Date:   Sun, 24 Feb 2019 00:41:26 -0800
Message-Id: <20190224084126.19412-9-dafna3@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190224084126.19412-1-dafna3@gmail.com>
References: <20190224084126.19412-1-dafna3@gmail.com>
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Add code to support the stateless decoder
and the function 'stateless_m2m' that implements it.

Signed-off-by: Dafna Hirschfeld <dafna3@gmail.com>
---
 utils/v4l2-ctl/v4l2-ctl-streaming.cpp | 236 +++++++++++++++++++++++++-
 1 file changed, 233 insertions(+), 3 deletions(-)

diff --git a/utils/v4l2-ctl/v4l2-ctl-streaming.cpp b/utils/v4l2-ctl/v4l2-ctl-streaming.cpp
index 82a93d4b..db6734e9 100644
--- a/utils/v4l2-ctl/v4l2-ctl-streaming.cpp
+++ b/utils/v4l2-ctl/v4l2-ctl-streaming.cpp
@@ -1063,8 +1063,9 @@ restart:
 				return false;
 			}
 		}
-
-		if (support_out_crop && v4l2_fwht_find_pixfmt(fmt.g_pixelformat()))
+		if (q.g_capabilities() & V4L2_BUF_CAP_SUPPORTS_REQUESTS)
+			read_fwht_frame(fmt, (unsigned char *)buf, fin, sz, len);
+		else if (support_out_crop && v4l2_fwht_find_pixfmt(fmt.g_pixelformat()))
 			read_write_padded_frame(fmt, (unsigned char *)buf, fin, sz, len, true);
 		else
 			sz = fread(buf, 1, len, fin);
@@ -1091,6 +1092,21 @@ restart:
 	return true;
 }
 
+static bool split_fwht_frame(u8 *frame, struct fwht_cframe_hdr *hdr, unsigned max_len)
+{
+	unsigned int len;
+	bool ret = true;
+
+	memcpy(hdr, frame, sizeof(struct fwht_cframe_hdr));
+	len = ntohl(hdr->size);
+	if (len > max_len) {
+		len = max_len;
+		ret = false;
+	}
+	memmove(frame, frame + sizeof(struct fwht_cframe_hdr), len);
+	return ret;
+}
+
 static int do_setup_out_buffers(cv4l_fd &fd, cv4l_queue &q, FILE *fin, bool qbuf)
 {
 	tpg_pixel_aspect aspect = TPG_PIXEL_ASPECT_SQUARE;
@@ -1195,6 +1211,35 @@ static int do_setup_out_buffers(cv4l_fd &fd, cv4l_queue &q, FILE *fin, bool qbuf
 		if (fin && !fill_buffer_from_file(fd, q, buf, fmt, fin))
 			return -2;
 
+		struct fwht_cframe_hdr hdr;
+
+		if (q.g_capabilities() & V4L2_BUF_CAP_SUPPORTS_REQUESTS) {
+			int media_fd = mi_get_media_fd(fd.g_fd());
+
+			if (!split_fwht_frame((u8 *)q.g_dataptr(buf.g_index(), 0),
+					      &hdr, buf.g_length(0)))
+				fprintf(stderr, "%s: warning: size field in fwht header is larger than buf size\n",
+					__func__);
+
+			if (media_fd < 0) {
+				fprintf(stderr, "%s: mi_get_media_fd failed\n", __func__);
+				return media_fd;
+			}
+
+			if (q.alloc_req(media_fd, i)) {
+				fprintf(stderr, "%s: q.alloc_req failed\n", __func__);
+				return -1;
+			}
+			buf.s_request_fd(q.g_req_fd(i));
+			buf.or_flags(V4L2_BUF_FLAG_REQUEST_FD);
+
+			if (set_fwht_ext_ctrl(fd, &hdr, last_fwht_bf_ts,
+					      buf.g_request_fd())) {
+				fprintf(stderr, "%s: set_fwht_ext_ctrls failed on %dth buf: %s\n",
+					__func__, i, strerror(errno));
+				return -1;
+			}
+		}
 		if (qbuf) {
 			set_time_stamp(buf);
 			if (fd.qbuf(buf))
@@ -1204,6 +1249,16 @@ static int do_setup_out_buffers(cv4l_fd &fd, cv4l_queue &q, FILE *fin, bool qbuf
 				fprintf(stderr, ">");
 			fflush(stderr);
 		}
+		if (q.g_capabilities() & V4L2_BUF_CAP_SUPPORTS_REQUESTS) {
+			set_fwht_req_by_idx(i, &hdr, q.g_req_fd(i),
+					    last_fwht_bf_ts, get_ns_timestamp(buf));
+			last_fwht_bf_ts = get_ns_timestamp(buf);
+			if (ioctl(q.g_req_fd(i), MEDIA_REQUEST_IOC_QUEUE) < 0) {
+				fprintf(stderr, "Unable to queue media request: %s\n",
+					strerror(errno));
+				return -1;
+			}
+		}
 	}
 	if (qbuf)
 		output_field = field;
@@ -1442,12 +1497,48 @@ static int do_handle_out(cv4l_fd &fd, cv4l_queue &q, FILE *fin, cv4l_buffer *cap
 				       (u8 *)q.g_dataptr(buf.g_index(), j));
 	}
 
+	struct fwht_cframe_hdr hdr;
+
+	if (q.g_capabilities() & V4L2_BUF_CAP_SUPPORTS_REQUESTS) {
+		if (ioctl(buf.g_request_fd(), MEDIA_REQUEST_IOC_REINIT, NULL)) {
+			fprintf(stderr, "Unable to reinit media request: %s\n",
+				strerror(errno));
+			return -1;
+		}
+		if (!split_fwht_frame((u8 *)q.g_dataptr(buf.g_index(), 0), &hdr, buf.g_length(0)))
+			fprintf(stderr, "%s: warning: size field in fwht header is larger than buf size\n",
+					__func__);
+
+		if (set_fwht_ext_ctrl(fd, &hdr, last_fwht_bf_ts,
+				      buf.g_request_fd())) {
+			fprintf(stderr, "%s: set_fwht_ext_ctrls failed: %s\n",
+				__func__, strerror(errno));
+			return -1;
+		}
+	}
+
 	set_time_stamp(buf);
 
 	if (fd.qbuf(buf)) {
 		fprintf(stderr, "%s: failed: %s\n", "VIDIOC_QBUF", strerror(errno));
 		return -1;
 	}
+	if (q.g_capabilities() & V4L2_BUF_CAP_SUPPORTS_REQUESTS) {
+		if (!set_fwht_req_by_fd(&hdr, buf.g_request_fd(), last_fwht_bf_ts,
+					get_ns_timestamp(buf))) {
+			fprintf(stderr, "%s: request for fd %d does not exist\n",
+				__func__, buf.g_request_fd());
+			return -1;
+		}
+
+		last_fwht_bf_ts = get_ns_timestamp(buf);
+		if (ioctl(buf.g_request_fd(), MEDIA_REQUEST_IOC_QUEUE) < 0) {
+			fprintf(stderr, "Unable to queue media request: %s\n",
+				strerror(errno));
+			return -1;
+		}
+	}
+
 	tpg_update_mv_count(&tpg, V4L2_FIELD_HAS_T_OR_B(output_field));
 
 	if (!verbose)
@@ -2236,6 +2327,140 @@ static void stateful_m2m(cv4l_fd &fd, cv4l_queue &in, cv4l_queue &out,
 	tpg_free(&tpg);
 }
 
+static void stateless_m2m(cv4l_fd &fd, cv4l_queue &in, cv4l_queue &out,
+			  FILE *fin, FILE *fout, cv4l_fd *exp_fd_p)
+{
+	fps_timestamps fps_ts[2];
+	unsigned count[2] = { 0, 0 };
+	cv4l_fmt fmt[2];
+	int fd_flags = fcntl(fd.g_fd(), F_GETFL);
+
+	fd.g_fmt(fmt[OUT], out.g_type());
+	fd.g_fmt(fmt[CAP], in.g_type());
+
+	if (out.reqbufs(&fd, reqbufs_count_out)) {
+		fprintf(stderr, "%s: out.reqbufs failed\n", __func__);
+		return;
+	}
+
+	if (in.reqbufs(&fd, reqbufs_count_cap)) {
+		fprintf(stderr, "%s: in.reqbufs failed\n", __func__);
+		return;
+	}
+
+	if (exp_fd_p && in.export_bufs(exp_fd_p, exp_fd_p->g_type()))
+		return;
+
+	if (in.obtain_bufs(&fd)) {
+		fprintf(stderr, "%s: in.obtain_bufs error\n", __func__);
+		return;
+	}
+
+	if (do_setup_out_buffers(fd, out, fout, true) == -1) {
+		fprintf(stderr, "%s: do_setup_out_buffers failed\n", __func__);
+		return;
+	}
+
+	if (in.queue_all(&fd)) {
+		fprintf(stderr, "%s: in.queue_all failed\n", __func__);
+		return;
+	}
+
+	if (fd.streamon(out.g_type())) {
+		fprintf(stderr, "%s: streamon for out failed\n", __func__);
+		return;
+	}
+
+	if (fd.streamon(in.g_type())) {
+		fprintf(stderr, "%s: streamon for in failed\n", __func__);
+		return;
+	}
+	int index = 0;
+	bool queue_lst_buf = false;
+	cv4l_buffer last_in_buf;
+
+	fcntl(fd.g_fd(), F_SETFL, fd_flags | O_NONBLOCK);
+
+	while (true) {
+		fd_set except_fds;
+		int req_fd = out.g_req_fd(index);
+		struct timeval tv = { 2, 0 };
+
+		FD_ZERO(&except_fds);
+		FD_SET(req_fd, &except_fds);
+
+		int rc = select(req_fd + 1, NULL, NULL, &except_fds, &tv);
+
+		if (rc == 0) {
+			fprintf(stderr, "Timeout when waiting for media request\n");
+			return;
+		} else if (rc < 0) {
+			fprintf(stderr, "Unable to select media request: %s\n",
+				strerror(errno));
+			return;
+		}
+		/*
+		 * it is safe to queue back last cap buffer only after
+		 * the following request is done so that the buffer
+		 * is not needed anymore as a reference frame
+		 */
+		if (queue_lst_buf) {
+			if (fd.qbuf(last_in_buf) < 0) {
+				fprintf(stderr, "%s: qbuf failed\n", __func__);
+				return;
+			}
+		}
+		int buf_idx = -1;
+		  /*
+		   * fin is not sent to do_handle_cap since the capture buf is
+		   * written to the file in current function
+		   */
+		rc = do_handle_cap(fd, in, NULL, &buf_idx, count[CAP],
+				   fps_ts[CAP], fmt[CAP]);
+		if (rc) {
+			fprintf(stderr, "%s: do_handle_cap err\n", __func__);
+			return;
+		}
+		/*
+		 * in case of an error in the frame, set last ts to 0 as a mean
+		 * to recover so that next request will not use a
+		 * reference buffer. Otherwise the error flag will be set to
+		 * all the future capture buffers.
+		 */
+		if (buf_idx == -1) {
+			fprintf(stderr, "%s: frame returned with error\n", __func__);
+			last_fwht_bf_ts	= 0;
+		} else {
+			cv4l_buffer cap_buf(in, index);
+			if (fd.querybuf(cap_buf))
+				return;
+			last_in_buf = cap_buf;
+			queue_lst_buf = true;
+			if (fin && cap_buf.g_bytesused(0) &&
+			    !(cap_buf.g_flags() & V4L2_BUF_FLAG_ERROR)) {
+				int idx = get_fwht_req_by_ts(get_ns_timestamp(cap_buf));
+
+				if (idx < 0) {
+					fprintf(stderr, "%s: could not find request from buffer\n", __func__);
+					fprintf(stderr, "%s: ts = %llu\n", __func__, get_ns_timestamp(cap_buf));
+					return;
+				}
+				composed_width = fwht_reqs[idx].params.width;
+				composed_height = fwht_reqs[idx].params.height;
+				write_buffer_to_file(fd, in, cap_buf,
+						     fmt[CAP], fin);
+			}
+		}
+		rc = do_handle_out(fd, out, fout, NULL, count[OUT],
+				   fps_ts[OUT], fmt[OUT]);
+		if (rc) {
+			fprintf(stderr, "%s: output stream ended\n", __func__);
+			close(req_fd);
+		}
+		index = (index + 1) % out.g_buffers();
+	}
+}
+
 static void streaming_set_m2m(cv4l_fd &fd, cv4l_fd &exp_fd)
 {
 	cv4l_queue in(fd.g_type(), memory);
@@ -2272,7 +2497,12 @@ static void streaming_set_m2m(cv4l_fd &fd, cv4l_fd &exp_fd)
 		if (out.export_bufs(&exp_fd, exp_fd.g_type()))
 			return;
 	}
-	stateful_m2m(fd, in, out, file[CAP], file[OUT], exp_fd_p);
+	if (out.reqbufs(&fd, 0))
+		goto done;
+	if (out.g_capabilities() & V4L2_BUF_CAP_SUPPORTS_REQUESTS)
+		stateless_m2m(fd, in, out, file[CAP], file[OUT], exp_fd_p);
+	else
+		stateful_m2m(fd, in, out, file[CAP], file[OUT], exp_fd_p);
 done:
 	if (options[OptStreamDmaBuf] || options[OptStreamOutDmaBuf])
 		exp_q.close_exported_fds();
-- 
2.17.1

