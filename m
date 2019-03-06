Return-Path: <SRS0=KHCC=RJ=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 73234C43381
	for <linux-media@archiver.kernel.org>; Wed,  6 Mar 2019 21:18:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 37B6E20661
	for <linux-media@archiver.kernel.org>; Wed,  6 Mar 2019 21:18:10 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="D+gxwLbi"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726318AbfCFVSJ (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Wed, 6 Mar 2019 16:18:09 -0500
Received: from mail-wm1-f65.google.com ([209.85.128.65]:54447 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726200AbfCFVSJ (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Wed, 6 Mar 2019 16:18:09 -0500
Received: by mail-wm1-f65.google.com with SMTP id f3so7353074wmj.4
        for <linux-media@vger.kernel.org>; Wed, 06 Mar 2019 13:18:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=eALtZQdWGW89J+GEjbIcRbfvVT6vwiS7X6VZEZ/dLUw=;
        b=D+gxwLbiPcG7oA49snTEQGsrZUn2IGK5/a5Y9IZyE1tr3yQvwTqOeUcSVT17yEjMn3
         DR831GwphBwfb/ueu5bQg4bIL3Yy8jDUhc8JO99QkNWf7g/e22YAzH8ZJAcMVusMfy16
         dIOn43uly6bOXIgJeYmr4i0+6m2Me65LWIBmZOg0xtob3VgqK7p4O0XAs9sJVBkagvvO
         d2F9hQsttg1/6rN40XM8DLFpQ+7pu/tQRFIJB+YYqnk4Y0Uh0Z0qTZrhL1Xg7fOqIMCT
         TG2QIIHPlRPZf1cRrcduNGyj+VIO6RwiaznQc6CaR7/AtDSHbb+dK4+95JLQcK5BhywM
         rEhQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=eALtZQdWGW89J+GEjbIcRbfvVT6vwiS7X6VZEZ/dLUw=;
        b=qBQvzfbM/AnXfV3zbt5D7/Xbgaxpc3zgehx4h3U7RXk52TV6WXDpQ/ijbbspprqY3K
         O2uGks0KtJCXWlzL5cl6ao7XIG/C2xYe/DP9KclZuLTUhGCgJDRgu4wXjjp9LObrUFUz
         gtnoW5WMXUd+xIxDrHVq/FHaIcHVzzO+eUSLV5dsvwFv8pgnt/wguUTqAHp4NeDbGbVc
         Pu6rp485bAfiKnVvRTPKEZMF98DCH9aEAAph5V+E1yzBQ5G49r/2dyVshDq5efdQq3UN
         2owTpouget08P5RP8GrMxxP3M6pIx0Oc9O4JEW+e2eQDcc2IsbrjOoWpTal0HpCe6SnM
         xXhA==
X-Gm-Message-State: APjAAAUJrQn7UcCuo0P83165rkLYwPltkgEZH15a6kFaiqWkGX0DQhBR
        p7sPQOJ6L0/q9y/Pe+PlC1ODrxGPRzU=
X-Google-Smtp-Source: APXvYqxzoKrfs9+8cQ5NWBgykz9pMyrtnR14HjrisGWCqttxeYG5oNc4hZXo8HzuG01mni0TgwyxCw==
X-Received: by 2002:a1c:6505:: with SMTP id z5mr3834581wmb.7.1551907087132;
        Wed, 06 Mar 2019 13:18:07 -0800 (PST)
Received: from ubuntu.home ([77.124.117.239])
        by smtp.gmail.com with ESMTPSA id c2sm5252495wrt.93.2019.03.06.13.18.05
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 06 Mar 2019 13:18:06 -0800 (PST)
From:   Dafna Hirschfeld <dafna3@gmail.com>
To:     linux-media@vger.kernel.org
Cc:     hverkuil@xs4all.nl, helen.koike@collabora.com,
        Dafna Hirschfeld <dafna3@gmail.com>
Subject: [v4l-utils PATCH v5 5/6] v4l2-ctl: Add functions and variables to support fwht stateless decoder
Date:   Wed,  6 Mar 2019 13:17:51 -0800
Message-Id: <20190306211752.15531-5-dafna3@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190306211752.15531-1-dafna3@gmail.com>
References: <20190306211752.15531-1-dafna3@gmail.com>
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Add the variable 'last_fwht_bf_ts' and the array 'fwht_reqs' to
allow the fwht stateless decoder to maintain the requests.

Signed-off-by: Dafna Hirschfeld <dafna3@gmail.com>
---
 utils/v4l2-ctl/v4l2-ctl-streaming.cpp | 138 ++++++++++++++++++++++++++
 1 file changed, 138 insertions(+)

diff --git a/utils/v4l2-ctl/v4l2-ctl-streaming.cpp b/utils/v4l2-ctl/v4l2-ctl-streaming.cpp
index 9bb58a0b..4bb2d301 100644
--- a/utils/v4l2-ctl/v4l2-ctl-streaming.cpp
+++ b/utils/v4l2-ctl/v4l2-ctl-streaming.cpp
@@ -17,9 +17,12 @@
 #include <sys/mman.h>
 #include <dirent.h>
 #include <math.h>
+#include <linux/media.h>
 
 #include "v4l2-ctl.h"
 #include "v4l-stream.h"
+#include <media-info.h>
+#include <fwht-ctrls.h>
 
 extern "C" {
 #include "v4l2-tpg.h"
@@ -80,6 +83,17 @@ static bool support_cap_compose;
 static bool support_out_crop;
 static bool in_source_change_event;
 
+static __u64 last_fwht_bf_ts;
+static fwht_cframe_hdr last_fwht_hdr;
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
 
@@ -420,6 +434,12 @@ static int get_out_crop_rect(cv4l_fd &fd)
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
@@ -749,6 +769,124 @@ void streaming_cmd(int ch, char *optarg)
 	}
 }
 
+/*
+ * Assume that the fwht stream is valid and that each
+ * frame starts right after the previous one.
+ */
+static bool read_fwht_frame(cv4l_fmt &fmt, unsigned char *buf,
+			    FILE *fpointer, unsigned &sz,
+			    unsigned &expected_len, unsigned buf_len)
+{
+	expected_len = sizeof(struct fwht_cframe_hdr);
+	if (expected_len > buf_len)
+		return false;
+	sz = fread(&last_fwht_hdr, 1, sizeof(struct fwht_cframe_hdr), fpointer);
+	if (sz < sizeof(struct fwht_cframe_hdr))
+		return true;
+
+	expected_len = ntohl(last_fwht_hdr.size);
+	if (expected_len > buf_len)
+		return false;
+	sz = fread(buf, 1, ntohl(last_fwht_hdr.size), fpointer);
+	return true;
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
+
+	/*
+	 * if last_bf_ts is 0 it indicates that either this is the
+	 * first frame, or that last frame returned with an error so
+	 * it is better not to reference it so the error won't propagate
+	 */
+	if (!last_bf_ts)
+		fwht_params.flags |= FWHT_FL_I_FRAME;
+}
+
+static int alloc_fwht_req(int media_fd, unsigned index)
+{
+	int rc = 0;
+
+	rc = ioctl(media_fd, MEDIA_IOC_REQUEST_ALLOC, &fwht_reqs[index]);
+	if (rc < 0) {
+		fprintf(stderr, "Unable to allocate media request: %s\n",
+			strerror(errno));
+		return rc;
+	}
+
+	return 0;
+}
+
+static void set_fwht_req_by_idx(unsigned idx, struct fwht_cframe_hdr *hdr,
+				__u64 last_bf_ts, __u64 ts)
+{
+	struct v4l2_ctrl_fwht_params fwht_params;
+
+	set_fwht_stateless_params(fwht_params, hdr, last_bf_ts);
+
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
+	control.id = V4L2_CID_MPEG_VIDEO_FWHT_PARAMS;
+	control.ptr = &fwht_params;
+	control.size = sizeof(fwht_params);
+	controls.which = V4L2_CTRL_WHICH_REQUEST_VAL;
+	controls.request_fd = req_fd;
+	controls.controls = &control;
+	controls.count = 1;
+	return fd.s_ext_ctrls(controls);
+}
+
 static bool read_write_padded_frame(cv4l_fmt &fmt, unsigned char *buf,
 				    FILE *fpointer, unsigned &sz,
 				    unsigned &expected_len, unsigned buf_len,
-- 
2.17.1

