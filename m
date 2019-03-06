Return-Path: <SRS0=KHCC=RJ=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4D253C4360F
	for <linux-media@archiver.kernel.org>; Wed,  6 Mar 2019 21:18:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0E44720661
	for <linux-media@archiver.kernel.org>; Wed,  6 Mar 2019 21:18:12 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="lke5UHoL"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726351AbfCFVSL (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Wed, 6 Mar 2019 16:18:11 -0500
Received: from mail-wm1-f67.google.com ([209.85.128.67]:55859 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726200AbfCFVSL (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Wed, 6 Mar 2019 16:18:11 -0500
Received: by mail-wm1-f67.google.com with SMTP id q187so7354685wme.5
        for <linux-media@vger.kernel.org>; Wed, 06 Mar 2019 13:18:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=lOU282FEQucw25HOiA+H9k2htNwyhXrwhYPJi2Za5Fg=;
        b=lke5UHoLn9xhSxZKmw2W5oz84ehrAjJQQ8HeYNx+3IQ0I1kezHO/stF46riwtRWy06
         P0MedP7zkf5jHRL32vVmPKODlFqXo6m0UkcHbFldYrr3obyAUCq+lUxloSV72Vp7rPk2
         pTNFJDLiRv+gmIu7tTkz0BNS1d6DRO89DVEeBeL7ULQ+YaVgch0XePVe5zxMDKQDi8eq
         /Btj6zs4/UCU2FpltyW2W5pcvSN4TuZVl+NF3nStX+Jf1CbuTVob5DZ/1Vyg4vsXvg0l
         6MwIlV7ewmEfbMFsFh0SucVQs7wc1x0P1xE1Pw7kiljCC9DbE546ACuEixEkr1uR/TAU
         jUYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=lOU282FEQucw25HOiA+H9k2htNwyhXrwhYPJi2Za5Fg=;
        b=MKwKhx19lZC30oh+wMk5mH6dMWzjHCatijWJIeyBCI4L+cNH7SWRwQwSyzmG/i+1uQ
         unC+Ipk2EDTIR8bPXqZ/lcCvLy8h7+Q284gBOgyU/Or+mKlpQkYMP50PB5gnuCMyC+pk
         mB1EqPFgFMbDPG8y50XXCEHlX+IP0U9XtN8Jyb9V8EK0Gg1lU+/W7Ldhu6DANp14P7sz
         3dUBUeMRasUT6cudFHJy8Wn42UyJ+6wX6CHQgiA1iPJJ0xjOBedU+94lMlO72bsWDnJZ
         /+aYJNGlJX7A9zBGNXBTN6fAxLZ2y/6TkPK7IAGrNH357VB3/Wx8TgfvRkDyeF862QWA
         k3wA==
X-Gm-Message-State: APjAAAX79NW2fZj/KVOquKWNA8GPjRgc4flBoULmeZJF0oc5ta8Ss7wH
        /qZZ6LQNfaipbq1DkHgZ7beFVjAa1ho=
X-Google-Smtp-Source: APXvYqy5jK5MFda6Y8B+P9lplLc8oVb/AwFh7Zg6iYacmoLBYszzReNX1sP7zilWsT4WuNfgQDGVUQ==
X-Received: by 2002:a7b:c92b:: with SMTP id h11mr3606440wml.33.1551907089002;
        Wed, 06 Mar 2019 13:18:09 -0800 (PST)
Received: from ubuntu.home ([77.124.117.239])
        by smtp.gmail.com with ESMTPSA id c2sm5252495wrt.93.2019.03.06.13.18.07
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 06 Mar 2019 13:18:08 -0800 (PST)
From:   Dafna Hirschfeld <dafna3@gmail.com>
To:     linux-media@vger.kernel.org
Cc:     hverkuil@xs4all.nl, helen.koike@collabora.com,
        Dafna Hirschfeld <dafna3@gmail.com>
Subject: [v4l-utils PATCH v5 6/6] v4l2-ctl: Add implementation for the stateless fwht decoder.
Date:   Wed,  6 Mar 2019 13:17:52 -0800
Message-Id: <20190306211752.15531-6-dafna3@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190306211752.15531-1-dafna3@gmail.com>
References: <20190306211752.15531-1-dafna3@gmail.com>
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Add code to support the stateless decoder
and the function 'stateless_m2m' that implements it.

Signed-off-by: Dafna Hirschfeld <dafna3@gmail.com>
---
 utils/v4l2-ctl/v4l2-ctl-streaming.cpp | 218 +++++++++++++++++++++++++-
 1 file changed, 210 insertions(+), 8 deletions(-)

diff --git a/utils/v4l2-ctl/v4l2-ctl-streaming.cpp b/utils/v4l2-ctl/v4l2-ctl-streaming.cpp
index 4bb2d301..2911e74f 100644
--- a/utils/v4l2-ctl/v4l2-ctl-streaming.cpp
+++ b/utils/v4l2-ctl/v4l2-ctl-streaming.cpp
@@ -1074,6 +1074,7 @@ restart:
 		unsigned expected_len = q.g_length(j);
 		unsigned sz;
 		cv4l_fmt fmt;
+		bool res = true;
 
 		fd.g_fmt(fmt, q.g_type());
 		if (from_with_hdr) {
@@ -1085,16 +1086,22 @@ restart:
 			}
 		}
 
-		if (support_out_crop && v4l2_fwht_find_pixfmt(fmt.g_pixelformat())) {
-			if (!read_write_padded_frame(fmt, (unsigned char *)buf,
-			    fin, sz, expected_len, buf_len, true))
-				return false;
-		} else {
+		if (fmt.g_pixelformat() == V4L2_PIX_FMT_FWHT_STATELESS)
+			res = read_fwht_frame(fmt, (unsigned char *)buf, fin,
+					      sz, expected_len, buf_len);
+		else if (support_out_crop && v4l2_fwht_find_pixfmt(fmt.g_pixelformat()))
+			res = read_write_padded_frame(fmt, (unsigned char *)buf,
+						      fin, sz, expected_len, buf_len, true);
+		else
 			sz = fread(buf, 1, expected_len, fin);
-		}
 
+		if (!res) {
+			fprintf(stderr, "amount intended to be read/written is larger than the buffer size\n");
+			return false;
+		}
 		if (first && sz != expected_len) {
-			fprintf(stderr, "Insufficient data\n");
+			fprintf(stderr, "%s: size read (%u) is different than needed (%u) in the first frame\n",
+				__func__, sz, expected_len);
 			return false;
 		}
 		if (j == 0 && sz == 0 && stream_loop) {
@@ -1219,6 +1226,26 @@ static int do_setup_out_buffers(cv4l_fd &fd, cv4l_queue &q, FILE *fin, bool qbuf
 		if (fin && !fill_buffer_from_file(fd, q, buf, fmt, fin))
 			return -2;
 
+		if (fmt.g_pixelformat() == V4L2_PIX_FMT_FWHT_STATELESS) {
+			int media_fd = mi_get_media_fd(fd.g_fd());
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
+			if (set_fwht_ext_ctrl(fd, &last_fwht_hdr, last_fwht_bf_ts,
+					      buf.g_request_fd())) {
+				fprintf(stderr, "%s: set_fwht_ext_ctrls failed on %dth buf: %s\n",
+					__func__, i, strerror(errno));
+				return -1;
+			}
+		}
 		if (qbuf) {
 			set_time_stamp(buf);
 			if (fd.qbuf(buf))
@@ -1228,6 +1255,16 @@ static int do_setup_out_buffers(cv4l_fd &fd, cv4l_queue &q, FILE *fin, bool qbuf
 				fprintf(stderr, ">");
 			fflush(stderr);
 		}
+		if (fmt.g_pixelformat() == V4L2_PIX_FMT_FWHT_STATELESS) {
+			set_fwht_req_by_idx(i, &last_fwht_hdr,
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
@@ -1466,12 +1503,43 @@ static int do_handle_out(cv4l_fd &fd, cv4l_queue &q, FILE *fin, cv4l_buffer *cap
 				       (u8 *)q.g_dataptr(buf.g_index(), j));
 	}
 
+	if (fmt.g_pixelformat() == V4L2_PIX_FMT_FWHT_STATELESS) {
+		if (ioctl(buf.g_request_fd(), MEDIA_REQUEST_IOC_REINIT, NULL)) {
+			fprintf(stderr, "Unable to reinit media request: %s\n",
+				strerror(errno));
+			return -1;
+		}
+
+		if (set_fwht_ext_ctrl(fd, &last_fwht_hdr, last_fwht_bf_ts,
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
+	if (fmt.g_pixelformat() == V4L2_PIX_FMT_FWHT_STATELESS) {
+		if (!set_fwht_req_by_fd(&last_fwht_hdr, buf.g_request_fd(), last_fwht_bf_ts,
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
@@ -2257,6 +2325,137 @@ static void stateful_m2m(cv4l_fd &fd, cv4l_queue &in, cv4l_queue &out,
 	tpg_free(&tpg);
 }
 
+static void stateless_m2m(cv4l_fd &fd, cv4l_queue &in, cv4l_queue &out,
+			  FILE *fin, FILE *fout, cv4l_fmt &fmt_in,
+			  cv4l_fmt &fmt_out, cv4l_fd *exp_fd_p)
+{
+	fps_timestamps fps_ts[2];
+	unsigned count[2] = { 0, 0 };
+	int fd_flags = fcntl(fd.g_fd(), F_GETFL);
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
+				   fps_ts[CAP], fmt_in);
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
+						     fmt_in, fin);
+			}
+		}
+		rc = do_handle_out(fd, out, fout, NULL, count[OUT],
+				   fps_ts[OUT], fmt_out);
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
@@ -2297,7 +2496,10 @@ static void streaming_set_m2m(cv4l_fd &fd, cv4l_fd &exp_fd)
 		if (out.export_bufs(&exp_fd, exp_fd.g_type()))
 			goto done;
 	}
-	stateful_m2m(fd, in, out, file[CAP], file[OUT], exp_fd_p);
+	if (fmt[OUT].g_pixelformat() == V4L2_PIX_FMT_FWHT_STATELESS)
+		stateless_m2m(fd, in, out, file[CAP], file[OUT], fmt[CAP], fmt[OUT], exp_fd_p);
+	else
+		stateful_m2m(fd, in, out, file[CAP], file[OUT], fmt[CAP], fmt[OUT], exp_fd_p);
 
 done:
 	if (options[OptStreamDmaBuf] || options[OptStreamOutDmaBuf])
-- 
2.17.1

