Return-Path: <SRS0=d4St=Q7=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A4611C43381
	for <linux-media@archiver.kernel.org>; Sun, 24 Feb 2019 08:41:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 69F9520840
	for <linux-media@archiver.kernel.org>; Sun, 24 Feb 2019 08:41:51 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="XEs7qeIS"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728044AbfBXIlu (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Sun, 24 Feb 2019 03:41:50 -0500
Received: from mail-wr1-f65.google.com ([209.85.221.65]:39997 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728004AbfBXIlu (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sun, 24 Feb 2019 03:41:50 -0500
Received: by mail-wr1-f65.google.com with SMTP id q1so6634386wrp.7
        for <linux-media@vger.kernel.org>; Sun, 24 Feb 2019 00:41:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=ns4WGCSLgi1S+SEMpf3XoTWMZrlpDZ1rKCBURPTfYvk=;
        b=XEs7qeISuDq1tJgmXFzqtUT/MD7aH6rfA9a/DZJ+xzKVoizJAb2Kh00X+KNIg9oYgJ
         +h4JdHK7cgyG2IFLKai9J3cgHjlqHN2bbbF/Iz87syasDpcO6kp8IUJ3SF/8MK5HGe9r
         PxrTuInJFNQszyak4U28L6nfk1keDaty4JWqne1o4SVjTa+JyVuZbJFjEJItyNI8vDiF
         qNIXa1/zgV/uDmRbw+KGozFwUK8bhRF+YY+lVS40OqVcwnAWoXX/hD4ck2Kl79ovP97K
         Bs0agsz8qydo2vPqWLS0Ew8SATEGB5gw73JnxgRqA6jbE3GnWSyH0GG9XDK0DVYxE6dt
         nUwQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=ns4WGCSLgi1S+SEMpf3XoTWMZrlpDZ1rKCBURPTfYvk=;
        b=LD5+3W6AlWj01UBKxteQjF4aWw4VjbY1sKAbcqXLLmInQmFXHIC8/1uEZRp+LjvXvJ
         Jv5qBpqHYLLsVyyNopcs8ePOjHCCLuNlVwp4YC5S+V4BGU075ZZFIi20oV2s+x1r+R0I
         EhmgaA9RNEMms9WshO3jSIZqrWAkDYpA+5xyXzxwq95SUZug/QYvf5bcuElRYS+ZjsPG
         AjS/ohKUSFzL/Z8q3jCQit/WXHmEMi0giiaD8yzDhJyiKSQ0jNfIayni7zIIROxf06Mn
         AA8T6II2pO/bmhmhGMujszFv0zkOlUvJomIaNen7L2XDAS1Bso0SUVjcsSkoKpBDfrUC
         yLwQ==
X-Gm-Message-State: AHQUAubL1qEj1FeIvrZG7uYBye+oCuZAPkaQQsAft4tNfXVsEugTS5cT
        bG3h5Umy9LfmeYnMh0zEMYg62tkaZe8=
X-Google-Smtp-Source: AHgI3IbgJ6PbrswsSMzL6g+bktei5xLgripAPREmtHDATb6iGAJrmHd24EHx81d2FBCzPTAEDRauBA==
X-Received: by 2002:adf:9d85:: with SMTP id p5mr8598679wre.215.1550997708086;
        Sun, 24 Feb 2019 00:41:48 -0800 (PST)
Received: from ubuntu.home ([77.127.107.32])
        by smtp.gmail.com with ESMTPSA id x24sm6837465wmi.5.2019.02.24.00.41.46
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 24 Feb 2019 00:41:47 -0800 (PST)
From:   Dafna Hirschfeld <dafna3@gmail.com>
To:     linux-media@vger.kernel.org
Cc:     hverkuil@xs4all.nl, helen.koike@collabora.com,
        Dafna Hirschfeld <dafna3@gmail.com>
Subject: [v4l-utils PATCH v3 4/8] v4l2-ctl: move stateful m2m decode code to a separate function
Date:   Sun, 24 Feb 2019 00:41:22 -0800
Message-Id: <20190224084126.19412-5-dafna3@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190224084126.19412-1-dafna3@gmail.com>
References: <20190224084126.19412-1-dafna3@gmail.com>
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
index d023aa12..adfa6796 100644
--- a/utils/v4l2-ctl/v4l2-ctl-streaming.cpp
+++ b/utils/v4l2-ctl/v4l2-ctl-streaming.cpp
@@ -1941,16 +1941,12 @@ static int capture_setup(cv4l_fd &fd, cv4l_queue &in, cv4l_fd *exp_fd)
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
@@ -1961,19 +1957,6 @@ static void streaming_set_m2m(cv4l_fd &fd, cv4l_fd &exp_fd)
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
@@ -1994,34 +1977,18 @@ static void streaming_set_m2m(cv4l_fd &fd, cv4l_fd &exp_fd)
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
 
-	if (do_setup_out_buffers(fd, out, file[OUT], true) == -1)
-		goto done;
+	if (do_setup_out_buffers(fd, out, fout, true) == -1)
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
@@ -2057,15 +2024,15 @@ static void streaming_set_m2m(cv4l_fd &fd, cv4l_fd &exp_fd)
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
@@ -2077,7 +2044,7 @@ static void streaming_set_m2m(cv4l_fd &fd, cv4l_fd &exp_fd)
 		}
 
 		if (wr_fds && FD_ISSET(fd.g_fd(), wr_fds)) {
-			r = do_handle_out(fd, out, file[OUT], NULL,
+			r = do_handle_out(fd, out, fout, NULL,
 					  count[OUT], fps_ts[OUT], fmt[OUT]);
 			if (r < 0)  {
 				wr_fds = NULL;
@@ -2128,7 +2095,7 @@ static void streaming_set_m2m(cv4l_fd &fd, cv4l_fd &exp_fd)
 				in_source_change_event = false;
 				last_buffer = false;
 				if (capture_setup(fd, in, exp_fd_p))
-					goto done;
+					return;
 				fd.g_fmt(fmt[OUT], out.g_type());
 				fd.g_fmt(fmt[CAP], in.g_type());
 				cap_streaming = true;
@@ -2146,7 +2113,45 @@ static void streaming_set_m2m(cv4l_fd &fd, cv4l_fd &exp_fd)
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

