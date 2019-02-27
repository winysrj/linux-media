Return-Path: <SRS0=SnUM=RC=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.3 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,UNWANTED_LANGUAGE_BODY,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 96F1EC43381
	for <linux-media@archiver.kernel.org>; Wed, 27 Feb 2019 07:08:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5E0FA21852
	for <linux-media@archiver.kernel.org>; Wed, 27 Feb 2019 07:08:15 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="cJy5pumU"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729514AbfB0HIO (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Wed, 27 Feb 2019 02:08:14 -0500
Received: from mail-wm1-f65.google.com ([209.85.128.65]:52816 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726889AbfB0HIO (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 27 Feb 2019 02:08:14 -0500
Received: by mail-wm1-f65.google.com with SMTP id m1so4701683wml.2
        for <linux-media@vger.kernel.org>; Tue, 26 Feb 2019 23:08:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=Mq/Yod24JfhKhxr6FkbFBOpWzvVCj70kIlU3Jk+e1uY=;
        b=cJy5pumUsrioez80HnxK2gu/+1FLTNWY4BQkAbBEyqybLaTcx0wdiUaBPvvW/ZQYFi
         f1q+J5l2xYoFggYq7fMnCOUGygalrTb3en6VuwXhyKqSz3oy/wMa9ZyoxBIBOtBnB0Rs
         33v19MrnZ5XpKvtg2hyOTg7b3PKzhgCE3GUR4HwBixyN50ltnqVF++UIGOM0zmPSaqwV
         T78L1vGvl8MS2AwZpKHfNm662o/mr/pOusD+88OhlbfqqdQwB1KamZtb3Ip3+82Q9A84
         HQ3M0dNNL+ardb378KCEqqTMKVFjC5qsexXZVmH2V2l/oTUN8QDPKQzmpXyRl2NDnMQ2
         L2wg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=Mq/Yod24JfhKhxr6FkbFBOpWzvVCj70kIlU3Jk+e1uY=;
        b=JtkXbttZ2/xOFui7OUN5mV3b3WPkVXi7yVtCO8VGWa7tczio2KbJWtPlilia9E8JzZ
         7kxV24gVLF1GVdCnipZIiZ+rD7cLwqFfjoA5IbOtrLBz8J5QA77mRwNo3TQX55TTxqn3
         tuHudOzSgf8I3kDhj0E8vkEGH2YE9oTtXLJ14xVNYuqyX1TL2wWdKoHEfSdy3+8Fh8D0
         UiDRzSWgdOtzZe4WTkXqhKDBNPnLlTUZD5VNBGAUHb/LKxj5Mphn9dMIyY4obfijvSq0
         lPj0iG/FQNAaiHuVGtOoRHv3X3fUR+YPDCkbpOs6f3vCG4m2iZlDcgGArX0zLuJT4tsS
         qthg==
X-Gm-Message-State: AHQUAuY5NH0pfGqakavB6DpHOOb+CN8rFnTWycwHSlgdK/7Izxgea9ou
        UqAd0g9CMpH0ve5OtEMdrQ4vd2yy12Y=
X-Google-Smtp-Source: AHgI3IbWw1QhWijK4OqLkK4Mqnq6XMvR4aTtfrRBdKBF2lmOOybTuyrUVLuSDsAPI2wm/Pl9jgyLFA==
X-Received: by 2002:a1c:7008:: with SMTP id l8mr1126787wmc.63.1551251290314;
        Tue, 26 Feb 2019 23:08:10 -0800 (PST)
Received: from ubuntu.home ([77.127.107.32])
        by smtp.gmail.com with ESMTPSA id i10sm41984852wrx.54.2019.02.26.23.08.09
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 26 Feb 2019 23:08:09 -0800 (PST)
From:   Dafna Hirschfeld <dafna3@gmail.com>
To:     linux-media@vger.kernel.org
Cc:     hverkuil@xs4all.nl, helen.koike@collabora.com,
        Dafna Hirschfeld <dafna3@gmail.com>
Subject: [v4l-utils PATCH v5 2/3] v4l2-ctl: Add functions and variables to support fwht stateless decoder
Date:   Tue, 26 Feb 2019 23:07:56 -0800
Message-Id: <20190227070757.25092-3-dafna3@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190227070757.25092-1-dafna3@gmail.com>
References: <20190227070757.25092-1-dafna3@gmail.com>
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Add the variable 'last_fwht_bf_ts' and the array 'fwht_reqs' to
allow the fwht stateless decoder to maintain the requests.

Signed-off-by: Dafna Hirschfeld <dafna3@gmail.com>
---
 utils/v4l2-ctl/v4l2-ctl-streaming.cpp | 129 ++++++++++++++++++++++++++
 1 file changed, 129 insertions(+)

diff --git a/utils/v4l2-ctl/v4l2-ctl-streaming.cpp b/utils/v4l2-ctl/v4l2-ctl-streaming.cpp
index adfa6796..dd0eeef6 100644
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
@@ -80,6 +83,16 @@ static bool support_cap_compose;
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
 
@@ -420,6 +433,12 @@ static int get_out_crop_rect(cv4l_fd &fd)
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
@@ -749,6 +768,116 @@ void streaming_cmd(int ch, char *optarg)
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
+
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
 static void read_write_padded_frame(cv4l_fmt &fmt, unsigned char *buf,
 				    FILE *fpointer, unsigned &sz,
 				    unsigned &len, bool is_read)
-- 
2.17.1

