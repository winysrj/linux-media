Return-Path: <SRS0=7VZ/=QY=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,UNWANTED_LANGUAGE_BODY,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 86640C43381
	for <linux-media@archiver.kernel.org>; Sun, 17 Feb 2019 13:42:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4605F21A4A
	for <linux-media@archiver.kernel.org>; Sun, 17 Feb 2019 13:42:26 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="gKYhhhb0"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728995AbfBQNmZ (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Sun, 17 Feb 2019 08:42:25 -0500
Received: from mail-wr1-f66.google.com ([209.85.221.66]:41281 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726583AbfBQNmZ (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sun, 17 Feb 2019 08:42:25 -0500
Received: by mail-wr1-f66.google.com with SMTP id n2so3176776wrw.8
        for <linux-media@vger.kernel.org>; Sun, 17 Feb 2019 05:42:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=hhP16LADqSTjNXD+WPerFVsTAV8qU6SbtqyqTkW/fzI=;
        b=gKYhhhb0RKr9s3Hc4nwMPA2b+NBbqgPKoQhSaynulhhv+Ckm0jU4cA43ugfUaXv/wH
         lGBpQ7Xkm0G8S9grQRlDy8m2xn9+7lHNWNbA4N5OkN0AcakM6IukrU9zKnNBKkNAsser
         oVrklHTBPcoVipDNGLPhkEtTaJXQtDiBkTEUfl1uSmhlrln39htxgI3fs7k20vBGZx8u
         tRkrD0NjOwQ0g+4fuWTDYfFtGZnOv21SP77yqEb4+hulMwZZco+32IKeKN3SgHKe5i0B
         algPkfE6/nLppkkTAF1IuCRSlldkNs1Kq3rY9FBInqdQXubOAAeAYCN6wflJWsGmNrNm
         nkqQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=hhP16LADqSTjNXD+WPerFVsTAV8qU6SbtqyqTkW/fzI=;
        b=bR4+uma7vVJkNSZHRVq16japyLI6zEodfSEPhHq2PrFUztxZJ9Gs5gwe8Wkiw12VMN
         HAUJ9eIl/jmTEE/l3fs1duld36ZWYSJqPtLOgZnE4jl3rpVBLZgO4Ma1EX43pAgMk/FG
         05yBodRN9ZYsMxqmvENHRSofvErrHBQDkOzPAJF6rVt5PFoq1UL+AO/aP0hVeuEnyfbV
         F4l9KMOHjOSdBRnTR8ahXO00sYXGgrRBLGcXlRCcADeVf6rJYAuuSeg+7TdT1bITbMhK
         Ga8FTZ5o2MPRGP8S0ySmyidNFcbg7FRt0FlPYdWg8dsUQk+Bie6vSe0s0hAK7s+Y90sm
         K6Og==
X-Gm-Message-State: AHQUAuad1OTteF3SzDdT+TXVuNj0Bu+4NisGOPqFBWPIenKhNTRNXLZ3
        TNbb4W3r0GLt3d0qQvWdVQ5vkfp+ucY=
X-Google-Smtp-Source: AHgI3IbN4xXgqf19oMOlODy1IuyDOrbp9z55iTw0jfQcQMB7TW4PbazbjGeWa3rBEggIK842TPkB6g==
X-Received: by 2002:adf:822d:: with SMTP id 42mr13179018wrb.63.1550410942737;
        Sun, 17 Feb 2019 05:42:22 -0800 (PST)
Received: from localhost.localdomain ([87.71.54.246])
        by smtp.gmail.com with ESMTPSA id o5sm39200711wrh.34.2019.02.17.05.42.21
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 17 Feb 2019 05:42:22 -0800 (PST)
From:   Dafna Hirschfeld <dafna3@gmail.com>
To:     linux-media@vger.kernel.org
Cc:     hverkuil@xs4all.nl, helen.koike@collabora.com,
        Dafna Hirschfeld <dafna3@gmail.com>
Subject: [v4l-utils PATCH v2 3/4] v4l2-ctl: Add functions and variables to support fwht stateless decoder
Date:   Sun, 17 Feb 2019 05:42:08 -0800
Message-Id: <20190217134209.84066-4-dafna3@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190217134209.84066-1-dafna3@gmail.com>
References: <20190217134209.84066-1-dafna3@gmail.com>
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Add the variable 'last_fwht_bf_ts' and the array 'fwht_reqs' to
allow the fwht stateless decoder to maintain the requests.

Signed-off-by: Dafna Hirschfeld <dafna3@gmail.com>
---
 utils/v4l2-ctl/v4l2-ctl-streaming.cpp | 120 ++++++++++++++++++++++++++
 1 file changed, 120 insertions(+)

diff --git a/utils/v4l2-ctl/v4l2-ctl-streaming.cpp b/utils/v4l2-ctl/v4l2-ctl-streaming.cpp
index 40ddc1c3..ec43bd03 100644
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
@@ -80,6 +86,16 @@ static bool support_cap_compose;
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
 
@@ -420,6 +436,12 @@ static int get_out_crop_rect(cv4l_fd &fd)
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
@@ -749,6 +771,104 @@ void streaming_cmd(int ch, char *optarg)
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

