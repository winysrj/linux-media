Return-Path: <SRS0=8Y7M=QS=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C91B6C169C4
	for <linux-media@archiver.kernel.org>; Mon, 11 Feb 2019 20:49:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9749121B1A
	for <linux-media@archiver.kernel.org>; Mon, 11 Feb 2019 20:49:31 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="AvDRm/Vs"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726866AbfBKUta (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Mon, 11 Feb 2019 15:49:30 -0500
Received: from mail-wr1-f68.google.com ([209.85.221.68]:43267 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726860AbfBKUta (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 11 Feb 2019 15:49:30 -0500
Received: by mail-wr1-f68.google.com with SMTP id r2so262600wrv.10
        for <linux-media@vger.kernel.org>; Mon, 11 Feb 2019 12:49:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=EHvvK3ARkJz9UTKh+0nTMN66N1/gSjr3pEoc7HzRvOs=;
        b=AvDRm/VsMsN24RsxMGUzhTgowI2JmCqm2JtLtA/xLoL8xrhp/icg11X0wf7yHH55rI
         nSbB+jMU9mhJGjapKAUTv/UpD9o/l3lzfS57KfuX66HdiC/O6jXtVXWIeaIs4ZBHn9x/
         V6qb9jRxXftIPa9lZ8QUYO7OjaU7jek0+ulwPYtAcsyv0NGVwmzzFFMOI23HflzdIHso
         W6uqplCwo9V8AFOWvSRiXhOBxbKFl/6ur+ozRAr1wxRzMXTEfYQdNQy/oMc8QNOO6jER
         HwfKiHWf8mPz9wq5eJS8E//Z+mNsavObXjwiG6ZPeJcTh1S5TL5lECZUXb6dIGBHb2NQ
         jg5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=EHvvK3ARkJz9UTKh+0nTMN66N1/gSjr3pEoc7HzRvOs=;
        b=KuNtGMyU5Ofkd3Kdp7KAW2jzLq/N/BAIHx3loj9Ilz6ArVm326dd41B9h+CEIdxmt4
         qOagaKXtpdIq/BzHpB+C4xqDN/EhCbx+oGjFAYhBFXUfIqwRK8Yfi7SWkaLcjRxUeg4/
         0aNwvGrFPNbwNAXlvOWry7qn0oh7Jjf/rwx17vh5fNSU72bO/jjLuTm/dP4ZnnBTXbzd
         CIUxPZz25AWnijQbgj1Axfu2/jEom+Fi7OUMg1vX3o0MBLM+TbE0YmGAUrpWZtSwwIcG
         Ue0dZaC8O1+BbjDbjWB9n3yOOiYhsbSKmPJaO9cDU7iffk0tccp5DWOits+ExqRHXUXR
         evCA==
X-Gm-Message-State: AHQUAuYd+duAv9fByZtknSMIJ/64E9XWD7eTrzOliOa/gQ/iLoKibO7K
        6bxU1FmUdJbDq8rdTf9zaNKOkaO9Qa0=
X-Google-Smtp-Source: AHgI3IYdkdVOZZVwP7Wj9GqEeEgIfz1zEtSwN9lbwYGiBL7PYC2TJPFR//qBkiYylq16Zyj3UzQkGA==
X-Received: by 2002:adf:9e0c:: with SMTP id u12mr103171wre.216.1549918168319;
        Mon, 11 Feb 2019 12:49:28 -0800 (PST)
Received: from localhost.localdomain ([87.70.76.19])
        by smtp.gmail.com with ESMTPSA id y139sm625778wmd.22.2019.02.11.12.49.27
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 11 Feb 2019 12:49:27 -0800 (PST)
From:   Dafna Hirschfeld <dafna3@gmail.com>
To:     linux-media@vger.kernel.org
Cc:     hverkuil@xs4all.nl, helen.koike@collabora.com,
        Dafna Hirschfeld <dafna3@gmail.com>
Subject: [v4l-utils PATCH 3/4] v4l2-ctl: Add functions and variables to support fwht stateless decoder
Date:   Mon, 11 Feb 2019 12:49:15 -0800
Message-Id: <20190211204916.77001-3-dafna3@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190211204916.77001-1-dafna3@gmail.com>
References: <20190211204916.77001-1-dafna3@gmail.com>
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Add the variable 'last_fwht_bf_ts' and the array 'fwht_reqs' to
allow the fwht stateless decoder to maintain the requests.

Signed-off-by: Dafna Hirschfeld <dafna3@gmail.com>
---
 utils/v4l2-ctl/v4l2-ctl-streaming.cpp | 103 ++++++++++++++++++++++++++
 1 file changed, 103 insertions(+)

diff --git a/utils/v4l2-ctl/v4l2-ctl-streaming.cpp b/utils/v4l2-ctl/v4l2-ctl-streaming.cpp
index 40ddc1c3..701e42ef 100644
--- a/utils/v4l2-ctl/v4l2-ctl-streaming.cpp
+++ b/utils/v4l2-ctl/v4l2-ctl-streaming.cpp
@@ -80,6 +80,16 @@ static bool support_cap_compose;
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
 
@@ -420,6 +430,12 @@ static int get_out_crop_rect(cv4l_fd &fd)
 	return 0;
 }
 
+static __u64 get_ns_time_stamp(cv4l_buffer &buf)
+{
+	const struct timeval tv = buf.g_timestamp();
+	return v4l2_timeval_to_ns(&tv);
+}
+
 static void set_time_stamp(cv4l_buffer &buf)
 {
 	if ((buf.g_flags() & V4L2_BUF_FLAG_TIMESTAMP_MASK) != V4L2_BUF_FLAG_TIMESTAMP_COPY)
@@ -749,6 +765,93 @@ void streaming_cmd(int ch, char *optarg)
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
+	len = sizeof(struct fwht_cframe_hdr);
+	sz = fread(buf, 1, sizeof(struct fwht_cframe_hdr), fpointer);
+	if (sz < sizeof(struct fwht_cframe_hdr))
+		return;
+
+	struct fwht_cframe_hdr *h = (struct fwht_cframe_hdr *)buf;
+	len += ntohl(h->size);
+	sz += fread(buf + sz, 1, ntohl(h->size), fpointer);
+}
+
+static void set_fwht_req_by_idx(unsigned idx, struct fwht_cframe_hdr *hdr,
+				int req_fd, __u64 last_bf_ts, __u64 ts)
+{
+	struct v4l2_ctrl_fwht_params fwht_params;
+
+	memset(&fwht_params, 0, sizeof(fwht_params));
+	fwht_params.backward_ref_ts = last_bf_ts;
+	fwht_params.width = ntohl(hdr->width);
+	fwht_params.height = ntohl(hdr->height);
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
+		int req_fd, __u64 last_bf_ts, __u64 ts)
+{
+	struct v4l2_ctrl_fwht_params fwht_params;
+
+	memset(&fwht_params, 0, sizeof(fwht_params));
+	fwht_params.backward_ref_ts = last_bf_ts;
+	fwht_params.width = ntohl(hdr->width);
+	fwht_params.height = ntohl(hdr->height);
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
+			      __u64 last_bf_ts, int req_fd)
+{
+	v4l2_ext_controls controls;
+	struct v4l2_ext_control control;
+	struct v4l2_ctrl_fwht_params fwht_params;
+
+	memset(&fwht_params, 0, sizeof(fwht_params));
+	memset(&control, 0, sizeof(control));
+	memset(&controls, 0, sizeof(controls));
+
+	fwht_params.backward_ref_ts = last_bf_ts;
+	fwht_params.width = ntohl(hdr->width);
+	fwht_params.height = ntohl(hdr->height);
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

