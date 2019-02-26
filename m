Return-Path: <SRS0=99fO=RB=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.3 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,UNWANTED_LANGUAGE_BODY,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D49E6C43381
	for <linux-media@archiver.kernel.org>; Tue, 26 Feb 2019 19:29:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 89CE12186A
	for <linux-media@archiver.kernel.org>; Tue, 26 Feb 2019 19:29:31 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="lj2gzzWC"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728303AbfBZT3a (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Tue, 26 Feb 2019 14:29:30 -0500
Received: from mail-wr1-f68.google.com ([209.85.221.68]:39482 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727823AbfBZT3a (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 26 Feb 2019 14:29:30 -0500
Received: by mail-wr1-f68.google.com with SMTP id l5so15267997wrw.6
        for <linux-media@vger.kernel.org>; Tue, 26 Feb 2019 11:29:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=GCNLqt/c0fipC7pZTfyjmpO+K+c6ScPCv0mb6D6bkcA=;
        b=lj2gzzWCGOleD+/vkBpQdN6rBYbQzRMJ8utDUNuSn5Ep6IhpMpJ95t0LrM0uplSB4n
         Z1VTQTuCuZt31DR6dn3tN/6GjIlbiuPV6+xj+rqNW700Ri2VvrQ2FIrHeGymDmDRCrVJ
         kVDDQbaEZgwae+3Yar0Hs2QQTpFBDmD1rBSbhpOpggHBmWM7TJGBvr60cvCN7ycw0xtl
         LWpbHThFkKJVYdvibdurfUezUzq1uADjOgzJW6jv9A1HdAWMugzDTgTrwc69mkXjXGj7
         SyPHC/UB0Vvxy4fqsVYO5fIaZ47gHgQeUSeP8ZlPj7DVh13BcBMqvEJ1o2CtnvTtuYtv
         Uh+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=GCNLqt/c0fipC7pZTfyjmpO+K+c6ScPCv0mb6D6bkcA=;
        b=HGTQ5JiYk4ELfh+QkVseMAcXSV+gJ8+rcDB/piAc1OJxC7paDEyPig0xFdnlXeBY99
         c28cjvtaEXtKUEw4lDTOskfuDOMzTLx90c5RFPDJRlXI2SbvgFn7SkMXFHF402F8/Gxz
         yQ5aCpNaVycaKsDgBCYCblhrZjPoChtiqU+11wkPbryg/ubOppVyL8mjd2okBJDA0yzh
         ugjnhq/EDecGaLNl/Zl6tZcuCo0COLquQfhW3ciokT0w+GFhAwmh9iv11x3ISilk139Z
         o9rbAcOYjsTK50d1VOpA5UvBe2nUDKidvp3yTb3RoY5rynN+VXyDNzr08FSL57uqWBW0
         zkhw==
X-Gm-Message-State: AHQUAuZafMBlstTcmV9Nr0V26SrNn8J1e9i91Gf8usZAr6tbkM9Xmp7f
        +jrmgjaDMxFFR7y2hNjLe2SOq9y1pjY=
X-Google-Smtp-Source: AHgI3IZZVIABAhyA/beTRQ+4SixZWd1IyWpqUJzNvFqNObH9v1fL6Rc2VFC2W1szPptJUjLwpNltiA==
X-Received: by 2002:adf:9dc7:: with SMTP id q7mr16624085wre.316.1551209367057;
        Tue, 26 Feb 2019 11:29:27 -0800 (PST)
Received: from ubuntu.home ([77.127.107.32])
        by smtp.gmail.com with ESMTPSA id d21sm40176202wrc.44.2019.02.26.11.29.25
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 26 Feb 2019 11:29:26 -0800 (PST)
From:   Dafna Hirschfeld <dafna3@gmail.com>
To:     linux-media@vger.kernel.org
Cc:     hverkuil@xs4all.nl, helen.koike@collabora.com,
        Dafna Hirschfeld <dafna3@gmail.com>
Subject: [v4l-utils PATCH v4 2/3] v4l2-ctl: Add functions and variables to support fwht stateless decoder
Date:   Tue, 26 Feb 2019 11:28:59 -0800
Message-Id: <20190226192900.86461-2-dafna3@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190226192900.86461-1-dafna3@gmail.com>
References: <20190226192900.86461-1-dafna3@gmail.com>
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Add the variable 'last_fwht_bf_ts' and the array 'fwht_reqs' to
allow the fwht stateless decoder to maintain the requests.

Signed-off-by: Dafna Hirschfeld <dafna3@gmail.com>
---
 utils/v4l2-ctl/v4l2-ctl-streaming.cpp | 130 ++++++++++++++++++++++++++
 1 file changed, 130 insertions(+)

diff --git a/utils/v4l2-ctl/v4l2-ctl-streaming.cpp b/utils/v4l2-ctl/v4l2-ctl-streaming.cpp
index adfa6796..f1a0b0d0 100644
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
@@ -749,6 +768,117 @@ void streaming_cmd(int ch, char *optarg)
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

