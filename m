Return-Path: <SRS0=99fO=RB=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 62839C4360F
	for <linux-media@archiver.kernel.org>; Tue, 26 Feb 2019 19:29:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 16B262063F
	for <linux-media@archiver.kernel.org>; Tue, 26 Feb 2019 19:29:33 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="rYAmymbG"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728341AbfBZT3c (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Tue, 26 Feb 2019 14:29:32 -0500
Received: from mail-wm1-f68.google.com ([209.85.128.68]:39793 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727054AbfBZT3b (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 26 Feb 2019 14:29:31 -0500
Received: by mail-wm1-f68.google.com with SMTP id z84so3367313wmg.4
        for <linux-media@vger.kernel.org>; Tue, 26 Feb 2019 11:29:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=KN09xgNX/askgndhvBRgVYvSYlJqLFC+27z6uyOIS4g=;
        b=rYAmymbG5Qr4KQ6Qpu5PG5Tbdnk7i7yjC0leAptwGwhVHJxam3+ouLp1/BAY8KIm3u
         gwf4WGS9xtXbIN4eaOSaNstBKdSozrr1HTd26uBH+o1D4H+PQx4+in372AAiwEK/XYLh
         7Qe05q+AFFfL3LvHYEGzJ0g6GuFgU+2XSFfBdhCUfS5Pbzn//NMO0s6BKyrBrfyPoELZ
         463RBTYoTqpT0NSnWhaYb/FouxnFg72VGZwV/soIme8yEWtgWI1Ew03DOdEvAIAPlnNH
         Z77+BzowLNPAcuOhTY7T/tsOLd5d5s8QIMP18faoAxLZQKa4oqvOWQWsb0tIdsBwy9Sv
         7fmg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=KN09xgNX/askgndhvBRgVYvSYlJqLFC+27z6uyOIS4g=;
        b=bxK8h24ngOhZZ3TjWij0LCsKSUatNOOIRD+ERgNw0vHj8GyTqCESHQidvd0QEOFSv9
         VBxIeeE6JeE9fkQHnlMHHKstwM1rAE+d9GL8AyjK8lzBhD1676bPyC2v9Yg0uS8ZKq0z
         exX3B/P1yFZn5hC020KNLeP10CyaEVlgI+HWDBB3zxmG5oveTyazV8LXKHiK2gWguljc
         pz6Avri8OWxhR4ioHavdum6hT9KQi4U1McNBuSOR4IefOTIm6JZDiqadiOm5rkcmhWRg
         UOaIKeYYb4HLa9TKrcJ0M+/eNcCjWBT09Pk2+FqwsBBq2HyFjhTvZZcSXPKvRZfV9YQK
         zQzw==
X-Gm-Message-State: AHQUAua07hxRkahVGPCTQLi9i5d9F/+7lXVHhv506By0+/HYiXr0aetG
        +YPR5W8STAY+Dcvlp+6/HvjCmwD2908=
X-Google-Smtp-Source: AHgI3IYW8qjaduzh6hPtDcesHjT2cAGY2G5IxsOgN92NkweKWEDgH69odq5+26OnYGUSYRUBUvMhvA==
X-Received: by 2002:a1c:228b:: with SMTP id i133mr3835000wmi.105.1551209368668;
        Tue, 26 Feb 2019 11:29:28 -0800 (PST)
Received: from ubuntu.home ([77.127.107.32])
        by smtp.gmail.com with ESMTPSA id d21sm40176202wrc.44.2019.02.26.11.29.27
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 26 Feb 2019 11:29:28 -0800 (PST)
From:   Dafna Hirschfeld <dafna3@gmail.com>
To:     linux-media@vger.kernel.org
Cc:     hverkuil@xs4all.nl, helen.koike@collabora.com,
        Dafna Hirschfeld <dafna3@gmail.com>
Subject: [v4l-utils PATCH v4 3/3] v4l2-ctl: Add implementation for the stateless fwht decoder.
Date:   Tue, 26 Feb 2019 11:29:00 -0800
Message-Id: <20190226192900.86461-3-dafna3@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190226192900.86461-1-dafna3@gmail.com>
References: <20190226192900.86461-1-dafna3@gmail.com>
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Add code to support the stateless decoder
and the function 'stateless_m2m' that implements it.

Signed-off-by: Dafna Hirschfeld <dafna3@gmail.com>
---
 utils/v4l2-ctl/v4l2-ctl-streaming.cpp | 234 +++++++++++++++++++++++++-
 1 file changed, 231 insertions(+), 3 deletions(-)

diff --git a/utils/v4l2-ctl/v4l2-ctl-streaming.cpp b/utils/v4l2-ctl/v4l2-ctl-streaming.cpp
index f1a0b0d0..f2704229 100644
--- a/utils/v4l2-ctl/v4l2-ctl-streaming.cpp
+++ b/utils/v4l2-ctl/v4l2-ctl-streaming.cpp
@@ -1072,8 +1072,9 @@ restart:
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
@@ -1100,6 +1101,21 @@ restart:
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
@@ -1204,6 +1220,33 @@ static int do_setup_out_buffers(cv4l_fd &fd, cv4l_queue &q, FILE *fin, bool qbuf
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
+			if (alloc_fwht_req(media_fd, i))
+				return -1;
+			buf.s_request_fd(fwht_reqs[i].fd);
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
@@ -1213,6 +1256,16 @@ static int do_setup_out_buffers(cv4l_fd &fd, cv4l_queue &q, FILE *fin, bool qbuf
 				fprintf(stderr, ">");
 			fflush(stderr);
 		}
+		if (q.g_capabilities() & V4L2_BUF_CAP_SUPPORTS_REQUESTS) {
+			set_fwht_req_by_idx(i, &hdr,
+					    last_fwht_bf_ts, get_ns_timestamp(buf));
+			last_fwht_bf_ts = get_ns_timestamp(buf);
+			if (ioctl(buf.g_request_fd(), MEDIA_REQUEST_IOC_QUEUE) < 0) {
+				fprintf(stderr, "Unable to queue media request: %s\n",
+					strerror(errno));
+				return -1;
+			}
+		}
 	}
 	if (qbuf)
 		output_field = field;
@@ -1451,12 +1504,48 @@ static int do_handle_out(cv4l_fd &fd, cv4l_queue &q, FILE *fin, cv4l_buffer *cap
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
@@ -2245,6 +2334,140 @@ static void stateful_m2m(cv4l_fd &fd, cv4l_queue &in, cv4l_queue &out,
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
+		int req_fd =fwht_reqs[index].fd;
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
@@ -2281,7 +2504,12 @@ static void streaming_set_m2m(cv4l_fd &fd, cv4l_fd &exp_fd)
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

