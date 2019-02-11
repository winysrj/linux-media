Return-Path: <SRS0=8Y7M=QS=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B44ACC169C4
	for <linux-media@archiver.kernel.org>; Mon, 11 Feb 2019 20:49:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6A78A218FD
	for <linux-media@archiver.kernel.org>; Mon, 11 Feb 2019 20:49:39 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="YVRARo20"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727080AbfBKUti (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Mon, 11 Feb 2019 15:49:38 -0500
Received: from mail-wm1-f66.google.com ([209.85.128.66]:40323 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726883AbfBKUtd (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 11 Feb 2019 15:49:33 -0500
Received: by mail-wm1-f66.google.com with SMTP id q21so637780wmc.5
        for <linux-media@vger.kernel.org>; Mon, 11 Feb 2019 12:49:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=gPTd7nsb7mJAv5VF8QjEFNH5QZwxoivfetfKdc81SZ4=;
        b=YVRARo20wjqKkcRGeO+Fv/61jSHLNG07wvlOFkvor6oc9Ef2q/tJPkU0P5h22zW0Va
         tLSO6aD1hgKR4Ccaox3BYetjD+gfZKDwqYWZMVdLIMzIK4cV1uGqOtde8kWpbnJjU8Lt
         Kgkyr+JeTsGV+7FKMtuRhzXIMxX2MmMggQoiwX1xsgtIpLBlbBEye8B/A35BFnNUHEC+
         uB8jpdqqFHbrFUhNoKpnE5Ozocd9Gk4uQKxSP6MKGiwO7hp9E7kFLQ/bSZjJM2/Hobve
         eHm3/jLBPo8nyDsKRPB6WEPFcihjZpMXicjAaWac/J4Cd2iYUTnjGhUcR/yJJC/khriW
         X4Wg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=gPTd7nsb7mJAv5VF8QjEFNH5QZwxoivfetfKdc81SZ4=;
        b=WHCxPnei94+GT4U6yDNeaEtIMzL5G5z9jHhwLxr/4s3xDKdPMJeYmpj99fVhXwccpX
         Pqnt3maMxwSF8K8/UQRJ8cQtsVoM6EiJqBd56CdyzDVYZrAulTJSbILXUmOSjC6lOVZV
         rwefdE7b0+kHWQQ18EhLvWvBeH0+DTk3pPeTiUA8E+vd5q/dX4EyQPX+NInJ6b18izOH
         ONHUeQLZAlv4aXzvSEFzV0FkS37lLsnIEt7Bjb5R0N7ylb7kSeLJ5I5Mexw8lEBI0iDs
         VgDIEoLe6RLyhnr3eWlOH8PxyU6JMjbGdHftWdNtsl4EsiGOV0tuc40L1ObuP4RbOHks
         Y9yA==
X-Gm-Message-State: AHQUAuZdAFvtrL/42yeQosikZWf4jsj/B9EistUchne/28I/dTKTvMRy
        vTNGqZGLMfFGu1uTG5DodVNvUp4XexM=
X-Google-Smtp-Source: AHgI3Ib+JQtWVnGtHf5Wc4DkHjj8+O3tMF2qyLZcdENKwPK+0dvFu+Z4mWOCb14L+u5JubbqzrRPTw==
X-Received: by 2002:a1c:be0f:: with SMTP id o15mr118643wmf.34.1549918169688;
        Mon, 11 Feb 2019 12:49:29 -0800 (PST)
Received: from localhost.localdomain ([87.70.76.19])
        by smtp.gmail.com with ESMTPSA id y139sm625778wmd.22.2019.02.11.12.49.28
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 11 Feb 2019 12:49:29 -0800 (PST)
From:   Dafna Hirschfeld <dafna3@gmail.com>
To:     linux-media@vger.kernel.org
Cc:     hverkuil@xs4all.nl, helen.koike@collabora.com,
        Dafna Hirschfeld <dafna3@gmail.com>
Subject: [v4l-utils PATCH 4/4] v4l2-ctl: Add implementation for the stateless fwht decoder.
Date:   Mon, 11 Feb 2019 12:49:16 -0800
Message-Id: <20190211204916.77001-4-dafna3@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190211204916.77001-1-dafna3@gmail.com>
References: <20190211204916.77001-1-dafna3@gmail.com>
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Add code to support the stateless decoder
and the function 'stateless_m2m' that implements it.

Signed-off-by: Dafna Hirschfeld <dafna3@gmail.com>
---
 utils/v4l2-ctl/v4l2-ctl-streaming.cpp | 224 +++++++++++++++++++++++++-
 1 file changed, 221 insertions(+), 3 deletions(-)

diff --git a/utils/v4l2-ctl/v4l2-ctl-streaming.cpp b/utils/v4l2-ctl/v4l2-ctl-streaming.cpp
index 701e42ef..84ffc105 100644
--- a/utils/v4l2-ctl/v4l2-ctl-streaming.cpp
+++ b/utils/v4l2-ctl/v4l2-ctl-streaming.cpp
@@ -20,11 +20,17 @@
 
 #include "v4l2-ctl.h"
 #include "v4l-stream.h"
+#include <media-info.h>
 
 extern "C" {
 #include "v4l2-tpg.h"
 }
 
+#define VICODEC_CID_CUSTOM_BASE        (V4L2_CID_MPEG_BASE | 0xf000)
+#define VICODEC_CID_I_FRAME_QP         (VICODEC_CID_CUSTOM_BASE + 0)
+#define VICODEC_CID_P_FRAME_QP         (VICODEC_CID_CUSTOM_BASE + 1)
+#define VICODEC_CID_STATELESS_FWHT     (VICODEC_CID_CUSTOM_BASE + 2)
+
 static unsigned stream_count;
 static unsigned stream_skip;
 static __u32 memory = V4L2_MEMORY_MMAP;
@@ -1037,8 +1043,9 @@ restart:
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
@@ -1169,6 +1176,30 @@ static int do_setup_out_buffers(cv4l_fd &fd, cv4l_queue &q, FILE *fin, bool qbuf
 		if (fin && !fill_buffer_from_file(fd, q, buf, fmt, fin))
 			return -2;
 
+		if (q.g_capabilities() & V4L2_BUF_CAP_SUPPORTS_REQUESTS) {
+			int media_fd = mi_get_media_fd(fd.g_fd());
+			struct fwht_cframe_hdr *hdr =
+				(struct fwht_cframe_hdr *)q.g_dataptr(buf.g_index(), 0);
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
+			if (set_fwht_ext_ctrl(fd, hdr, last_fwht_bf_ts,
+					      buf.g_request_fd())) {
+				fprintf(stderr, "%s: set_fwht_ext_ctrls failed on %dth buf: %s\n",
+					__func__, i, strerror(errno));
+				return -1;
+			}
+		}
 		if (qbuf) {
 			set_time_stamp(buf);
 			if (fd.qbuf(buf))
@@ -1178,6 +1209,19 @@ static int do_setup_out_buffers(cv4l_fd &fd, cv4l_queue &q, FILE *fin, bool qbuf
 				fprintf(stderr, ">");
 			fflush(stderr);
 		}
+		if (q.g_capabilities() & V4L2_BUF_CAP_SUPPORTS_REQUESTS) {
+			struct fwht_cframe_hdr *hdr =
+				(struct fwht_cframe_hdr *)q.g_dataptr(buf.g_index(), 0);
+
+			set_fwht_req_by_idx(i, hdr, q.g_req_fd(i),
+					    last_fwht_bf_ts, get_ns_time_stamp(buf));
+			last_fwht_bf_ts = get_ns_time_stamp(buf);
+			if (ioctl(q.g_req_fd(i), MEDIA_REQUEST_IOC_QUEUE) < 0) {
+				fprintf(stderr, "Unable to queue media request: %s\n",
+					strerror(errno));
+				return -1;
+			}
+		}
 	}
 	if (qbuf)
 		output_field = field;
@@ -1415,6 +1459,22 @@ static int do_handle_out(cv4l_fd &fd, cv4l_queue &q, FILE *fin, cv4l_buffer *cap
 			tpg_fillbuffer(&tpg, stream_out_std, j,
 				       (u8 *)q.g_dataptr(buf.g_index(), j));
 	}
+	if (q.g_capabilities() & V4L2_BUF_CAP_SUPPORTS_REQUESTS) {
+		if (ioctl(buf.g_request_fd(), MEDIA_REQUEST_IOC_REINIT, NULL)) {
+			fprintf(stderr, "Unable to reinit media request: %s\n",
+				strerror(errno));
+			return -1;
+		}
+		struct fwht_cframe_hdr *hdr =
+			(struct fwht_cframe_hdr *)q.g_dataptr(buf.g_index(), 0);
+
+		if (set_fwht_ext_ctrl(fd, hdr, last_fwht_bf_ts,
+				      buf.g_request_fd())) {
+			fprintf(stderr, "%s: set_fwht_ext_ctrls failed: %s\n",
+				__func__, strerror(errno));
+			return -1;
+		}
+	}
 
 	set_time_stamp(buf);
 
@@ -1422,6 +1482,25 @@ static int do_handle_out(cv4l_fd &fd, cv4l_queue &q, FILE *fin, cv4l_buffer *cap
 		fprintf(stderr, "%s: failed: %s\n", "VIDIOC_QBUF", strerror(errno));
 		return -1;
 	}
+	if (q.g_capabilities() & V4L2_BUF_CAP_SUPPORTS_REQUESTS) {
+		struct fwht_cframe_hdr *hdr =
+			(struct fwht_cframe_hdr *)q.g_dataptr(buf.g_index(), 0);
+
+		if (!set_fwht_req_by_fd(hdr, buf.g_request_fd(), last_fwht_bf_ts,
+					get_ns_time_stamp(buf))) {
+			fprintf(stderr, "%s: request for fd %d does not exist\n",
+				__func__, buf.g_request_fd());
+			return -1;
+		}
+
+		last_fwht_bf_ts = get_ns_time_stamp(buf);
+		if (ioctl(buf.g_request_fd(), MEDIA_REQUEST_IOC_QUEUE) < 0) {
+			fprintf(stderr, "Unable to queue media request: %s\n",
+				strerror(errno));
+			return -1;
+		}
+	}
+
 	tpg_update_mv_count(&tpg, V4L2_FIELD_HAS_T_OR_B(output_field));
 
 	if (!verbose)
@@ -2210,6 +2289,140 @@ static void stateful_m2m(cv4l_fd &fd, cv4l_queue &in, cv4l_queue &out,
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
+	if (do_setup_out_buffers(fd, out, fout, true)) {
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
+				int idx = get_fwht_req_by_ts(get_ns_time_stamp(cap_buf));
+
+				if (idx < 0) {
+					fprintf(stderr, "%s: could not find request from buffer\n", __func__);
+					fprintf(stderr, "%s: ts = %llu\n", __func__, get_ns_time_stamp(cap_buf));
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
@@ -2246,7 +2459,12 @@ static void streaming_set_m2m(cv4l_fd &fd, cv4l_fd &exp_fd)
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

