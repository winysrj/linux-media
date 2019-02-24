Return-Path: <SRS0=d4St=Q7=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,UNWANTED_LANGUAGE_BODY,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 16B41C43381
	for <linux-media@archiver.kernel.org>; Sun, 24 Feb 2019 08:41:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CFD1F206BA
	for <linux-media@archiver.kernel.org>; Sun, 24 Feb 2019 08:41:55 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="S3r6RuDf"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728143AbfBXIlz (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Sun, 24 Feb 2019 03:41:55 -0500
Received: from mail-wr1-f66.google.com ([209.85.221.66]:36294 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727852AbfBXIlz (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sun, 24 Feb 2019 03:41:55 -0500
Received: by mail-wr1-f66.google.com with SMTP id o17so6658587wrw.3
        for <linux-media@vger.kernel.org>; Sun, 24 Feb 2019 00:41:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=3WBY80YWjmrk2S5u9d0O5Idg6JypkTmldeUtaZbtG8Y=;
        b=S3r6RuDfUw4qAW3LyKq1izmS83T0fFHMAOnXbgmKt6c1hB4voYB0dQA/MYd6kMfxY1
         haRt5zz2hiA3yTP9mXw6EWEPhiMZELwTkFd17xbiUWsjwg6XjHJNrIcCykdd6CsVKMph
         u+uGpR6StvLkp4IpJvljtEIUsVjwM5mWJJIHANxkTuHMFVkusLUbI86YH3CXdenobpN2
         0clTbQChKG/o9Dj0JO4K2/8XjsSBkMAg1/loUtrksLaKc1GeD5P8thZg0PDyQjHYzEqv
         vPHBWuDNeUg3q/9rQVDvfzKR7YPqU/gCuD0lJHbUMpb5HJG+dS4x29+PtPa1aPPPVYEO
         3n/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=3WBY80YWjmrk2S5u9d0O5Idg6JypkTmldeUtaZbtG8Y=;
        b=JP/rkkTkshHBmyKDefldEa6x/je5r88lH1SeniKpzy0B4k23kP0OfXaAVHo2hLQusT
         Ct5AXhr6CaoMMGStPhfWxMChROOzdohfU1gRM4pWvZiELY9CN/xffgQI8V9UNOnfSRn8
         94E5kwCaHXXfIxfi1bu6lCHTwj6qM6GYunb7Oh4Q/k4AGzbt2TnbAxU4xObxjyT64ldA
         wLGxagazDxAqx5T9Xoxs9+Li6aZWyPAj1VQfGRJtK8DIxwoUCAWjGoO+gwUw8D7qGKXi
         nA35AjdrjGlfFyDLNkd7q+F2geDpF5ziOAlPy+AEQINJjRKI+KdNqIlSPHVW77xReIIo
         N0HA==
X-Gm-Message-State: AHQUAuYvaJfNZZtv1q5NepHq2EKvS1iGEBru6Isl7FOI54LImftjua0U
        UBby+9JLjS3RM4pppfxqU/O6RJ8LTng=
X-Google-Smtp-Source: AHgI3IaW/F0dSFRg9j+fdutetVhlVFEJsg5cS2TsdYMXi+gR3Br7HUmMQ2c4bCIrscAaNXY84Ag+uw==
X-Received: by 2002:adf:e5c5:: with SMTP id a5mr8586304wrn.13.1550997712128;
        Sun, 24 Feb 2019 00:41:52 -0800 (PST)
Received: from ubuntu.home ([77.127.107.32])
        by smtp.gmail.com with ESMTPSA id x24sm6837465wmi.5.2019.02.24.00.41.50
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 24 Feb 2019 00:41:51 -0800 (PST)
From:   Dafna Hirschfeld <dafna3@gmail.com>
To:     linux-media@vger.kernel.org
Cc:     hverkuil@xs4all.nl, helen.koike@collabora.com,
        Dafna Hirschfeld <dafna3@gmail.com>
Subject: [v4l-utils PATCH v3 7/8] v4l2-ctl: Add functions and variables to support fwht stateless decoder
Date:   Sun, 24 Feb 2019 00:41:25 -0800
Message-Id: <20190224084126.19412-8-dafna3@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190224084126.19412-1-dafna3@gmail.com>
References: <20190224084126.19412-1-dafna3@gmail.com>
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Add the variable 'last_fwht_bf_ts' and the array 'fwht_reqs' to
allow the fwht stateless decoder to maintain the requests.

Signed-off-by: Dafna Hirschfeld <dafna3@gmail.com>
---
 utils/v4l2-ctl/v4l2-ctl-streaming.cpp | 121 ++++++++++++++++++++++++++
 1 file changed, 121 insertions(+)

diff --git a/utils/v4l2-ctl/v4l2-ctl-streaming.cpp b/utils/v4l2-ctl/v4l2-ctl-streaming.cpp
index adfa6796..82a93d4b 100644
--- a/utils/v4l2-ctl/v4l2-ctl-streaming.cpp
+++ b/utils/v4l2-ctl/v4l2-ctl-streaming.cpp
@@ -20,11 +20,18 @@
 
 #include "v4l2-ctl.h"
 #include "v4l-stream.h"
+#include <media-info.h>
+#include <fwht-ctrls.h>
 
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
@@ -80,6 +87,16 @@ static bool support_cap_compose;
 static bool support_out_crop;
 static bool in_source_change_event;
 
+static __u64 last_fwht_bf_ts;
+
+struct request_fwht {
+	int fd;
+	__u64 ts;
+	struct v4l2_ctrl_fwht_params params;
+};
+
+static request_fwht fwht_reqs[VIDEO_MAX_FRAME];
+
 #define TS_WINDOW 241
 #define FILE_HDR_ID			v4l2_fourcc('V', 'h', 'd', 'r')
 
@@ -420,6 +437,12 @@ static int get_out_crop_rect(cv4l_fd &fd)
 	return 0;
 }
 
+static __u64 get_ns_timestamp(cv4l_buffer &buf)
+{
+	const struct timeval tv = buf.g_timestamp();
+	return v4l2_timeval_to_ns(&tv);
+}
+
 static void set_time_stamp(cv4l_buffer &buf)
 {
 	if ((buf.g_flags() & V4L2_BUF_FLAG_TIMESTAMP_MASK) != V4L2_BUF_FLAG_TIMESTAMP_COPY)
@@ -749,6 +772,104 @@ void streaming_cmd(int ch, char *optarg)
 	}
 }
 
+/*
+ * Assume that the fwht stream is valid and that each
+ * frame starts right after the previous one.
+ */
+static void read_fwht_frame(cv4l_fmt &fmt, unsigned char *buf,
+			    FILE *fpointer, unsigned &sz,
+			    unsigned &len)
+{
+	struct fwht_cframe_hdr *h = (struct fwht_cframe_hdr *)buf;
+
+	len = sizeof(struct fwht_cframe_hdr);
+	sz = fread(buf, 1, sizeof(struct fwht_cframe_hdr), fpointer);
+	if (sz < sizeof(struct fwht_cframe_hdr))
+		return;
+
+	len += ntohl(h->size);
+	sz += fread(buf + sz, 1, ntohl(h->size), fpointer);
+}
+
+static void set_fwht_stateless_params(struct v4l2_ctrl_fwht_params &fwht_params,
+				      const struct fwht_cframe_hdr *hdr,
+				      __u64 last_bf_ts)
+{
+	fwht_params.backward_ref_ts = last_bf_ts;
+	fwht_params.version = ntohl(hdr->version);
+	fwht_params.width = ntohl(hdr->width);
+	fwht_params.height = ntohl(hdr->height);
+	fwht_params.flags = ntohl(hdr->flags);
+	fwht_params.colorspace = ntohl(hdr->colorspace);
+	fwht_params.xfer_func = ntohl(hdr->xfer_func);
+	fwht_params.ycbcr_enc = ntohl(hdr->ycbcr_enc);
+	fwht_params.quantization = ntohl(hdr->quantization);
+	fwht_params.comp_frame_size = ntohl(hdr->size);
+
+	if (!last_bf_ts)
+		fwht_params.flags |= FWHT_FL_I_FRAME;
+}
+
+static void set_fwht_req_by_idx(unsigned idx, struct fwht_cframe_hdr *hdr,
+				int req_fd, __u64 last_bf_ts, __u64 ts)
+{
+	struct v4l2_ctrl_fwht_params fwht_params;
+
+	set_fwht_stateless_params(fwht_params, hdr, last_bf_ts);
+
+	fwht_reqs[idx].fd = req_fd;
+	fwht_reqs[idx].ts = ts;
+	fwht_reqs[idx].params = fwht_params;
+}
+
+static int get_fwht_req_by_ts(__u64 ts)
+{
+	for (int idx = 0; idx < VIDEO_MAX_FRAME; idx++) {
+		if (fwht_reqs[idx].ts == ts)
+			return idx;
+	}
+	return -1;
+}
+
+static bool set_fwht_req_by_fd(struct fwht_cframe_hdr *hdr,
+			       int req_fd, __u64 last_bf_ts, __u64 ts)
+{
+	struct v4l2_ctrl_fwht_params fwht_params;
+
+	set_fwht_stateless_params(fwht_params, hdr, last_bf_ts);
+
+	for (int idx = 0; idx < VIDEO_MAX_FRAME; idx++) {
+		if (fwht_reqs[idx].fd == req_fd) {
+			fwht_reqs[idx].ts = ts;
+			fwht_reqs[idx].params = fwht_params;
+			return true;
+		}
+	}
+	return false;
+}
+
+static int set_fwht_ext_ctrl(cv4l_fd &fd, struct fwht_cframe_hdr *hdr,
+			     __u64 last_bf_ts, int req_fd)
+{
+	v4l2_ext_controls controls;
+	struct v4l2_ext_control control;
+	struct v4l2_ctrl_fwht_params fwht_params;
+
+	memset(&control, 0, sizeof(control));
+	memset(&controls, 0, sizeof(controls));
+
+	set_fwht_stateless_params(fwht_params, hdr, last_bf_ts);
+
+	control.id = VICODEC_CID_STATELESS_FWHT;
+	control.ptr = &fwht_params;
+	control.size = sizeof(fwht_params);
+	controls.which = V4L2_CTRL_WHICH_REQUEST_VAL;
+	controls.request_fd = req_fd;
+	controls.controls = &control;
+	controls.count = 1;
+	return fd.s_ext_ctrls(controls);
+}
+
 static void read_write_padded_frame(cv4l_fmt &fmt, unsigned char *buf,
 				    FILE *fpointer, unsigned &sz,
 				    unsigned &len, bool is_read)
-- 
2.17.1

