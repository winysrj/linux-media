Return-Path: <SRS0=8Y7M=QS=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 46EF4C169C4
	for <linux-media@archiver.kernel.org>; Mon, 11 Feb 2019 20:49:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id F2AFB218D8
	for <linux-media@archiver.kernel.org>; Mon, 11 Feb 2019 20:49:28 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="tBLuTxGb"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726852AbfBKUt2 (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Mon, 11 Feb 2019 15:49:28 -0500
Received: from mail-wm1-f50.google.com ([209.85.128.50]:50381 "EHLO
        mail-wm1-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726080AbfBKUt2 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 11 Feb 2019 15:49:28 -0500
Received: by mail-wm1-f50.google.com with SMTP id x7so671086wmj.0
        for <linux-media@vger.kernel.org>; Mon, 11 Feb 2019 12:49:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=GBbQ/vkk1SAuZy9P+bDsHlaMw6sm4ht6Ti5xqOT37qs=;
        b=tBLuTxGbYADSs+PTGEPxb9u75gpAiGR0/dMchmnn03Y0niKEv/dGqYxtU2d81FYAcr
         yaEdkx76LPpwlGl/Bvxr8L9NgnJvyg4JXPBoaSh5buobO9/9QHGRnqD9K5xK8l967jii
         aN4EwPNQOnquV8yPfb3Dy9FOM1M4SMSwOA1c19jKEI2hFKC4B+fj/yGluB1mxcA9aHz9
         QQukSh0yJK3iWg1Y2TZh3PlSqiJ3Y33Pu1LpChd5fVQA7Q6kTVKyBUyGEKIpHwyUSm2u
         bc6VcuvV3QDjCtSfROyGV3NEueKbHnkBb9724GVG36R1mJhSJDTBXSHvYLnK7R5qLoOW
         ZTNQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=GBbQ/vkk1SAuZy9P+bDsHlaMw6sm4ht6Ti5xqOT37qs=;
        b=QgljG9ls2P2qRkNbNoQ9FAuChe1fqwNpD6XG3E3sKIKZ2vMmDqc903fTm0SFK21Byl
         j7qm++Y9ObBzVwYmyQpEJ/SIWx8cVoIql2/tbHCk3XlXyCXds0AhvZvMDeRbsTdOWtR8
         eGyr5HFODczfCrAWzW1DXWnUyCBFNLg8+bLx11zVb4F5DNYcaUHGjMnrFLFb2HAQu4R/
         hVvzHzGxfySRlA0/6+5i1hWBoaJKMFOqXgj4yfHzAnysjZfdQs/3I/W8I1zXKYlBolGx
         9jurILJGPeQQxjGaLIQzPTnsEB/3L8l8H4HB1Mp6tGLfBbNEpznOUkdyRRz1N8N4q0Yy
         5tnA==
X-Gm-Message-State: AHQUAuZU7pOMwXbc3x4NmVu1bTtnWUyWHJ7vlgyWqU72KI0AlXN3KHtB
        7TOac617Vc32ZDyNvG4xyav+nZFinYE=
X-Google-Smtp-Source: AHgI3IZIQ0XZdJvDO+ojCeOAZlUMR+AT92ciMdAhBb7DmmLTRg2++Lymwzsy8zseyRtAotAbiWhvbQ==
X-Received: by 2002:a7b:cc86:: with SMTP id p6mr117488wma.32.1549918165515;
        Mon, 11 Feb 2019 12:49:25 -0800 (PST)
Received: from localhost.localdomain ([87.70.76.19])
        by smtp.gmail.com with ESMTPSA id y139sm625778wmd.22.2019.02.11.12.49.24
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 11 Feb 2019 12:49:24 -0800 (PST)
From:   Dafna Hirschfeld <dafna3@gmail.com>
To:     linux-media@vger.kernel.org
Cc:     hverkuil@xs4all.nl, helen.koike@collabora.com,
        Dafna Hirschfeld <dafna3@gmail.com>
Subject: [v4l-utils PATCH 1/4] v4l2-ctl: move stateful m2m decode code to a separate function
Date:   Mon, 11 Feb 2019 12:49:13 -0800
Message-Id: <20190211204916.77001-1-dafna3@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Add the function stateful_m2m that implements the stateful
codec api.
This is a preparation for having both stateful and stateless
implementations

Signed-off-by: Dafna Hirschfeld <dafna3@gmail.com>
---
 utils/v4l2-ctl/v4l2-ctl-streaming.cpp | 95 ++++++++++++++-------------
 1 file changed, 50 insertions(+), 45 deletions(-)

diff --git a/utils/v4l2-ctl/v4l2-ctl-streaming.cpp b/utils/v4l2-ctl/v4l2-ctl-streaming.cpp
index 766872b5..40ddc1c3 100644
--- a/utils/v4l2-ctl/v4l2-ctl-streaming.cpp
+++ b/utils/v4l2-ctl/v4l2-ctl-streaming.cpp
@@ -1933,16 +1933,12 @@ static int capture_setup(cv4l_fd &fd, cv4l_queue &in, cv4l_fd *exp_fd)
 	return 0;
 }
 
-static void streaming_set_m2m(cv4l_fd &fd, cv4l_fd &exp_fd)
+static void stateful_m2m(cv4l_fd &fd, cv4l_queue &in, cv4l_queue &out,
+			 FILE *fin, FILE *fout, cv4l_fd *exp_fd_p)
 {
 	int fd_flags = fcntl(fd.g_fd(), F_GETFL);
-	cv4l_queue in(fd.g_type(), memory);
-	cv4l_queue out(v4l_type_invert(fd.g_type()), out_memory);
-	cv4l_queue exp_q(exp_fd.g_type(), V4L2_MEMORY_MMAP);
-	cv4l_fd *exp_fd_p = NULL;
 	fps_timestamps fps_ts[2];
 	unsigned count[2] = { 0, 0 };
-	FILE *file[2] = {NULL, NULL};
 	fd_set fds[3];
 	fd_set *rd_fds = &fds[0]; /* for capture */
 	fd_set *ex_fds = &fds[1]; /* for capture */
@@ -1953,19 +1949,6 @@ static void streaming_set_m2m(cv4l_fd &fd, cv4l_fd &exp_fd)
 	fd.g_fmt(fmt[OUT], out.g_type());
 	fd.g_fmt(fmt[CAP], in.g_type());
 
-	if (!fd.has_vid_m2m()) {
-		fprintf(stderr, "unsupported m2m stream type\n");
-		return;
-	}
-	if (options[OptStreamDmaBuf] && options[OptStreamOutDmaBuf]) {
-		fprintf(stderr, "--stream-dmabuf and --stream-out-dmabuf not supported for m2m devices\n");
-		return;
-	}
-	if ((options[OptStreamDmaBuf] || options[OptStreamOutDmaBuf]) && exp_fd.g_fd() < 0) {
-		fprintf(stderr, "--stream-dmabuf or --stream-out-dmabuf can only work in combination with --export-device\n");
-		return;
-	}
-
 	struct v4l2_event_subscription sub;
 
 	memset(&sub, 0, sizeof(sub));
@@ -1986,34 +1969,18 @@ static void streaming_set_m2m(cv4l_fd &fd, cv4l_fd &exp_fd)
 	sub.type = V4L2_EVENT_SOURCE_CHANGE;
 	bool have_source_change = !fd.subscribe_event(sub);
 
-	file[CAP] = open_output_file(fd);
-	file[OUT] = open_input_file(fd, out.g_type());
-
 	if (out.reqbufs(&fd, reqbufs_count_out))
-		goto done;
-
-	if (options[OptStreamDmaBuf]) {
-		if (exp_q.reqbufs(&exp_fd, reqbufs_count_cap))
-			goto done;
-		exp_fd_p = &exp_fd;
-	}
-
-	if (options[OptStreamOutDmaBuf]) {
-		if (exp_q.reqbufs(&exp_fd, reqbufs_count_out))
-			goto done;
-		if (out.export_bufs(&exp_fd, exp_fd.g_type()))
-			goto done;
-	}
+		return;
 
-	if (do_setup_out_buffers(fd, out, file[OUT], true))
-		goto done;
+	if (do_setup_out_buffers(fd, out, fout, true))
+		return;
 
 	if (fd.streamon(out.g_type()))
-		goto done;
+		return;
 
 	if (codec_type != DECODER || !have_source_change)
 		if (capture_setup(fd, in, exp_fd_p))
-			goto done;
+			return;
 
 	fps_ts[CAP].determine_field(fd.g_fd(), in.g_type());
 	fps_ts[OUT].determine_field(fd.g_fd(), out.g_type());
@@ -2049,15 +2016,15 @@ static void streaming_set_m2m(cv4l_fd &fd, cv4l_fd &exp_fd)
 				continue;
 			fprintf(stderr, "select error: %s\n",
 					strerror(errno));
-			goto done;
+			return;
 		}
 		if (r == 0) {
 			fprintf(stderr, "select timeout\n");
-			goto done;
+			return;
 		}
 
 		if (rd_fds && FD_ISSET(fd.g_fd(), rd_fds)) {
-			r = do_handle_cap(fd, in, file[CAP], NULL,
+			r = do_handle_cap(fd, in, fin, NULL,
 					  count[CAP], fps_ts[CAP], fmt[CAP]);
 			if (r < 0) {
 				rd_fds = NULL;
@@ -2069,7 +2036,7 @@ static void streaming_set_m2m(cv4l_fd &fd, cv4l_fd &exp_fd)
 		}
 
 		if (wr_fds && FD_ISSET(fd.g_fd(), wr_fds)) {
-			r = do_handle_out(fd, out, file[OUT], NULL,
+			r = do_handle_out(fd, out, fout, NULL,
 					  count[OUT], fps_ts[OUT], fmt[OUT]);
 			if (r < 0)  {
 				wr_fds = NULL;
@@ -2120,7 +2087,7 @@ static void streaming_set_m2m(cv4l_fd &fd, cv4l_fd &exp_fd)
 				in_source_change_event = false;
 				last_buffer = false;
 				if (capture_setup(fd, in, exp_fd_p))
-					goto done;
+					return;
 				fd.g_fmt(fmt[OUT], out.g_type());
 				fd.g_fmt(fmt[CAP], in.g_type());
 				cap_streaming = true;
@@ -2138,7 +2105,45 @@ static void streaming_set_m2m(cv4l_fd &fd, cv4l_fd &exp_fd)
 	in.free(&fd);
 	out.free(&fd);
 	tpg_free(&tpg);
+}
+
+static void streaming_set_m2m(cv4l_fd &fd, cv4l_fd &exp_fd)
+{
+	cv4l_queue in(fd.g_type(), memory);
+	cv4l_queue out(v4l_type_invert(fd.g_type()), out_memory);
+	cv4l_queue exp_q(exp_fd.g_type(), V4L2_MEMORY_MMAP);
+	cv4l_fd *exp_fd_p = NULL;
+	FILE *file[2] = {NULL, NULL};
+
+	if (!fd.has_vid_m2m()) {
+		fprintf(stderr, "unsupported m2m stream type\n");
+		return;
+	}
+	if (options[OptStreamDmaBuf] && options[OptStreamOutDmaBuf]) {
+		fprintf(stderr, "--stream-dmabuf and --stream-out-dmabuf not supported for m2m devices\n");
+		return;
+	}
+	if ((options[OptStreamDmaBuf] || options[OptStreamOutDmaBuf]) && exp_fd.g_fd() < 0) {
+		fprintf(stderr, "--stream-dmabuf or --stream-out-dmabuf can only work in combination with --export-device\n");
+		return;
+	}
 
+	file[CAP] = open_output_file(fd);
+	file[OUT] = open_input_file(fd, out.g_type());
+
+	if (options[OptStreamDmaBuf]) {
+		if (exp_q.reqbufs(&exp_fd, reqbufs_count_cap))
+			return;
+		exp_fd_p = &exp_fd;
+	}
+
+	if (options[OptStreamOutDmaBuf]) {
+		if (exp_q.reqbufs(&exp_fd, reqbufs_count_out))
+			return;
+		if (out.export_bufs(&exp_fd, exp_fd.g_type()))
+			return;
+	}
+	stateful_m2m(fd, in, out, file[CAP], file[OUT], exp_fd_p);
 done:
 	if (options[OptStreamDmaBuf] || options[OptStreamOutDmaBuf])
 		exp_q.close_exported_fds();
-- 
2.17.1

