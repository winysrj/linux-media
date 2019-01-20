Return-Path: <SRS0=HRs9=P4=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 74BFBC61CE4
	for <linux-media@archiver.kernel.org>; Sun, 20 Jan 2019 11:15:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 385A42087E
	for <linux-media@archiver.kernel.org>; Sun, 20 Jan 2019 11:15:39 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="P6HmigCl"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730508AbfATLPi (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Sun, 20 Jan 2019 06:15:38 -0500
Received: from mail-wm1-f66.google.com ([209.85.128.66]:37199 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730458AbfATLPi (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sun, 20 Jan 2019 06:15:38 -0500
Received: by mail-wm1-f66.google.com with SMTP id g67so8242351wmd.2
        for <linux-media@vger.kernel.org>; Sun, 20 Jan 2019 03:15:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=EtonKIt+3G0rODzQaQI97BdBzvKU5a7Lt9SBpSYGRuw=;
        b=P6HmigClfBnzqVVRja4PEYHcWJ5x17ZhaINZfapm8JFNMCSk8EGw8q0S+rKBfdud+L
         L0AVpyOa9QaB+L/J+TU96X6vBAasBaa1RPu/Tfp0VPXC3elsWquF6bSCdbxXWPVHeNBC
         P/jv1Ib7E85zRydYZ4knEWQDtw+3K3TA6bylYjlExiVxsWyT1pI1OtSKnU7OLA5RSroX
         SmOz4LZwLXMrzxniNdVyXJy7v32J8XFTkphbo+WzkCPXngzCPkuE9PT09/6DEBdVd7Xa
         suKMCnjyxYZDwgto5zQkdb/k8QgGT069Cwlwqq5BwGJDMpk4AR3H/ObVdHeAGSy73uoX
         9MeA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=EtonKIt+3G0rODzQaQI97BdBzvKU5a7Lt9SBpSYGRuw=;
        b=qyoICF1XdrKVIOeftJ06I1hFZJzCTJq6rwc148YOPKA8mp5sBLfNFW2geA/IaOM0PL
         a2sLLlbeZVCdCEiLzNQn+f7L+pSFgGlaV1wcjLsKVhfr3Y07XZpTYmfDJO2+rCsZLWJT
         Ec6ilbbIIC9ToYbzqGeDpWq7d2Z+K+UkiQQFADDvrYZYP69EUAk3Ood+hra70f03OhLt
         Lv+lXmrzjec3ZFLTQeY1Lymd3PUgRHzITgYEKPMF8AJt/yL5Y5l8pt62TV9LJngIQX/+
         WKljUBvdF3L1VeArtqMXo/3SXcelCmVYVmXieytyESoVjN9bKqcJKqtWZYw+OFMKTFxN
         HvqA==
X-Gm-Message-State: AJcUuke3ggboWXdBQE9LD5U4GvTlnapsQs2evmOC1iHPAsm6ByHfUYRu
        B+par/QLTiIu6dcx2ECb7DYVrEeZWmY=
X-Google-Smtp-Source: ALg8bN4WVQm0PRyaD8XWf8dkZDSxchj4kSebbhpXBpYrQwnhb8OTia0mOCWtqjUbGWZAcWB2B5AHPw==
X-Received: by 2002:a1c:bc82:: with SMTP id m124mr20904936wmf.77.1547982935550;
        Sun, 20 Jan 2019 03:15:35 -0800 (PST)
Received: from localhost.localdomain ([87.70.46.65])
        by smtp.gmail.com with ESMTPSA id n11sm28281796wrw.60.2019.01.20.03.15.34
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 20 Jan 2019 03:15:35 -0800 (PST)
From:   Dafna Hirschfeld <dafna3@gmail.com>
To:     linux-media@vger.kernel.org
Cc:     hverkuil@xs4all.nl, helen.koike@collabora.com,
        Dafna Hirschfeld <dafna3@gmail.com>
Subject: [v4l-utils PATCH 5/6] v4l2-ctl: Add support for source change event for m2m decoder
Date:   Sun, 20 Jan 2019 03:15:19 -0800
Message-Id: <20190120111520.114305-6-dafna3@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190120111520.114305-1-dafna3@gmail.com>
References: <20190120111520.114305-1-dafna3@gmail.com>
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Subscribe to source change event.
The capture setup sequence is executed only due to a
change event.

Signed-off-by: Dafna Hirschfeld <dafna3@gmail.com>
---
 utils/v4l2-ctl/v4l2-ctl-streaming.cpp | 90 ++++++++++++++++++++++-----
 1 file changed, 76 insertions(+), 14 deletions(-)

diff --git a/utils/v4l2-ctl/v4l2-ctl-streaming.cpp b/utils/v4l2-ctl/v4l2-ctl-streaming.cpp
index cd20dec7..61dd84db 100644
--- a/utils/v4l2-ctl/v4l2-ctl-streaming.cpp
+++ b/utils/v4l2-ctl/v4l2-ctl-streaming.cpp
@@ -78,6 +78,7 @@ static unsigned int composed_width;
 static unsigned int composed_height;
 static bool support_cap_compose;
 static bool support_out_crop;
+static bool in_source_change_event;
 
 #define TS_WINDOW 241
 #define FILE_HDR_ID			v4l2_fourcc('V', 'h', 'd', 'r')
@@ -755,8 +756,11 @@ static void read_write_padded_frame(cv4l_fmt &fmt, unsigned char *buf,
 				    FILE *fpointer, unsigned &sz,
 				    unsigned &len, bool is_read)
 {
-	const struct v4l2_fwht_pixfmt_info *vic_fmt = v4l2_fwht_find_pixfmt(fmt.g_pixelformat());
-	unsigned coded_height = fmt.g_height();
+	const struct v4l2_fwht_pixfmt_info *vic_fmt;
+	const static struct v4l2_fwht_pixfmt_info *old_info =
+		v4l2_fwht_find_pixfmt(fmt.g_pixelformat());
+	static cv4l_fmt old_fmt = fmt;
+	unsigned coded_height;
 	unsigned real_width;
 	unsigned real_height;
 	unsigned char *plane_p = buf;
@@ -770,6 +774,21 @@ static void read_write_padded_frame(cv4l_fmt &fmt, unsigned char *buf,
 		real_height = composed_height;
 	}
 
+	/*
+	 * if the source change event was dequeued but the stream was not yet
+	 * restarted then the current buffers still fit the old resolution so
+	 * we need to save it
+	 */
+	if (in_source_change_event) {
+		vic_fmt = old_info;
+		fmt = old_fmt;
+	} else {
+		vic_fmt = v4l2_fwht_find_pixfmt(fmt.g_pixelformat());
+		old_info = vic_fmt;
+		old_fmt = fmt;
+	}
+
+	coded_height = fmt.g_height();
 	sz = 0;
 	len = real_width * real_height * vic_fmt->sizeimage_mult / vic_fmt->sizeimage_div;
 
@@ -1208,8 +1227,18 @@ static int do_handle_cap(cv4l_fd &fd, cv4l_queue &q, FILE *fout, int *index,
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
 
@@ -1890,6 +1919,7 @@ static void streaming_set_m2m(cv4l_fd &fd)
 	fd_set *rd_fds = &fds[0]; /* for capture */
 	fd_set *ex_fds = &fds[1]; /* for capture */
 	fd_set *wr_fds = &fds[2]; /* for output */
+	bool cap_streaming = false;
 
 	if (!fd.has_vid_m2m()) {
 		fprintf(stderr, "unsupported m2m stream type\n");
@@ -1920,6 +1950,11 @@ static void streaming_set_m2m(cv4l_fd &fd)
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
@@ -1941,6 +1976,10 @@ static void streaming_set_m2m(cv4l_fd &fd)
 			return;
 		}
 	}
+	enum codec_type codec_type;
+
+	if (get_codec_type(fd, codec_type))
+		goto done;
 
 	if (out.reqbufs(&fd, reqbufs_count_out))
 		goto done;
@@ -1951,8 +1990,9 @@ static void streaming_set_m2m(cv4l_fd &fd)
 	if (fd.streamon(out.g_type()))
 		goto done;
 
-	if (capture_setup(fd, in))
-		goto done;
+	if (codec_type != DECODER)
+		if (capture_setup(fd, in))
+			goto done;
 
 	fps_ts[CAP].determine_field(fd.g_fd(), in.g_type());
 	fps_ts[OUT].determine_field(fd.g_fd(), out.g_type());
@@ -1999,12 +2039,25 @@ static void streaming_set_m2m(cv4l_fd &fd)
 			struct v4l2_event ev;
 
 			while (!fd.dqevent(ev)) {
-				if (ev.type != V4L2_EVENT_EOS)
-					continue;
-				wr_fds = NULL;
-				fprintf(stderr, "EOS");
-				fflush(stderr);
-				break;
+				if (ev.type == V4L2_EVENT_EOS) {
+					wr_fds = NULL;
+					fprintf(stderr, "EOS");
+					fflush(stderr);
+				} else if (ev.type == V4L2_EVENT_SOURCE_CHANGE) {
+					fprintf(stderr, "SOURCE CHANGE\n");
+
+					/*
+					 * if capture is already streaming,
+					 * wait to the a capture buffer with
+					 * LAST_BUFFER flag
+					 */
+					if (cap_streaming) {
+						in_source_change_event = true;
+						continue;
+					}
+					if (capture_setup(fd, in))
+						goto done;
+				}
 			}
 		}
 
@@ -2018,8 +2071,17 @@ static void streaming_set_m2m(cv4l_fd &fd)
 					break;
 				}
 			}
-			if (last_buffer)
-				break;
+			if (last_buffer) {
+				if (in_source_change_event) {
+					in_source_change_event = false;
+					last_buffer = false;
+					if (capture_setup(fd, in))
+						goto done;
+					cap_streaming = true;
+				} else {
+					break;
+				}
+			}
 		}
 
 		if (wr_fds && FD_ISSET(fd.g_fd(), wr_fds)) {
-- 
2.17.1

