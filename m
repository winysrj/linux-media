Return-Path: <SRS0=kVnX=P5=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9B9C0C31681
	for <linux-media@archiver.kernel.org>; Mon, 21 Jan 2019 18:57:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6458120861
	for <linux-media@archiver.kernel.org>; Mon, 21 Jan 2019 18:57:26 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="GR+ZptN4"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727893AbfAUS5Z (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Mon, 21 Jan 2019 13:57:25 -0500
Received: from mail-wm1-f66.google.com ([209.85.128.66]:38653 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727159AbfAUS5Z (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 21 Jan 2019 13:57:25 -0500
Received: by mail-wm1-f66.google.com with SMTP id m22so11922753wml.3
        for <linux-media@vger.kernel.org>; Mon, 21 Jan 2019 10:57:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=l4uNpZvhrIuQIG9RNlb0MSWkIOACIDRPaSK5IKM0xzA=;
        b=GR+ZptN4yW6Kr/1jbIJAfe7Z6PQwSwfeYPcqcK0B71ijfrwDxll/S0zfNC4D5CPyjF
         +ZPtTbdKX7by4PUEqgnRNAWwjSzZ3ZIZ2TvQONvh9x3FTLyygMWKvvgBe4wdPR4QRx5t
         vPR8D3vNusGk+fbVZhZJxMgEiiV+F8skTUQ/ExJF/bWfu52rAIFh2TxJKTRGeOoTr+Ji
         G+Ps3BP6vaiw5/LjaGxR3mlhfm6hYLtDjtCrwjR2w9Q2Xr58A1eoCxz901j/RFfkpfZn
         /X1qFHlF2mZm877DSgk38UoOJx7iGr27odOIxw8S2pR/lznXbCTi8VjGjUVNlodbhr9U
         P/BQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=l4uNpZvhrIuQIG9RNlb0MSWkIOACIDRPaSK5IKM0xzA=;
        b=sAJbwt1nQug84FiipmkM+c+Nl8vrH/PQH9Sz8229r4xVBNqV7GrAKuYFykpqiYlBDW
         TbQX4gEl8RveQciFTmFYhf/SYgwTaE1i+RB0itq0Dx68gV+QhyVwCpKS53BCto11UXox
         NgCnmbeuD9h+hukrqXYZwh0DqLuRVRPdnATGl+8/d2rdBC5+QSPpDQlekEf8CVoDVfat
         z9oFSNEcC2KmNSPysyNdceeDYMMgXJ0AvDHNlHv9djKjJ3vF0jI6C0ERr7PW0TuUUg8R
         rboZD2mRDmey7T/qPNgDCTzv+5DRuY4Wq9FRrVcZ1lRU0BMr0oJZ5Y7/Kj5EHw818Xpg
         DOjA==
X-Gm-Message-State: AJcUukf6OuH/IxWE9ExXC6ziekWb+ZPmrWhwoSdJntYqCV9fCKv0w1G1
        E1rrjEuHnOHQNUW2I1D3+HdLRWAFjSA=
X-Google-Smtp-Source: ALg8bN7sRw2Za2V4nC+bIPQXW1mw7zhd1HuUQ01aqCPHktW9dPjhNkarEQbn/VopWbuHtqn9vEHH8w==
X-Received: by 2002:a1c:8c05:: with SMTP id o5mr533163wmd.29.1548097042520;
        Mon, 21 Jan 2019 10:57:22 -0800 (PST)
Received: from localhost.localdomain ([87.70.46.65])
        by smtp.gmail.com with ESMTPSA id 67sm145061521wra.37.2019.01.21.10.57.21
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 21 Jan 2019 10:57:22 -0800 (PST)
From:   Dafna Hirschfeld <dafna3@gmail.com>
To:     linux-media@vger.kernel.org
Cc:     hverkuil@xs4all.nl, helen.koike@collabora.com,
        Dafna Hirschfeld <dafna3@gmail.com>
Subject: [v4l-utils PATCH v2 5/5] v4l2-ctl: Add --stream-pixformat option
Date:   Mon, 21 Jan 2019 10:56:51 -0800
Message-Id: <20190121185651.6229-6-dafna3@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190121185651.6229-1-dafna3@gmail.com>
References: <20190121185651.6229-1-dafna3@gmail.com>
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

This option sets the capture pixelformat in the
capture setup sequence.
If the format is not supported decoding will stop.
If the option is not given then the default is to set
the first supported format.

Signed-off-by: Dafna Hirschfeld <dafna3@gmail.com>
---
 utils/v4l2-ctl/v4l2-ctl-streaming.cpp | 37 +++++++++++++++++++++++++
 utils/v4l2-ctl/v4l2-ctl.cpp           | 39 ++++++++++++++++++---------
 utils/v4l2-ctl/v4l2-ctl.h             |  2 ++
 3 files changed, 65 insertions(+), 13 deletions(-)

diff --git a/utils/v4l2-ctl/v4l2-ctl-streaming.cpp b/utils/v4l2-ctl/v4l2-ctl-streaming.cpp
index 8d034b85..3e0a449c 100644
--- a/utils/v4l2-ctl/v4l2-ctl-streaming.cpp
+++ b/utils/v4l2-ctl/v4l2-ctl-streaming.cpp
@@ -78,6 +78,7 @@ static unsigned int composed_width;
 static unsigned int composed_height;
 static bool support_cap_compose;
 static bool support_out_crop;
+static unsigned int cap_pixelformat;
 static bool in_source_change_event;
 
 #define TS_WINDOW 241
@@ -272,6 +273,10 @@ void streaming_usage(void)
 	       "  --stream-from <file>\n"
 	       "                     stream from this file. The default is to generate a pattern.\n"
 	       "                     If <file> is '-', then the data is read from stdin.\n"
+	       "  --stream-pixformat <pixformat>\n"
+	       "                     set the video pixelformat."
+	       "                     <pixelformat> is either the format index as reported by\n"
+	       "                     --list-formats-out, or the fourcc value as a string.\n"
 	       "  --stream-from-hdr <file> stream from this file. Same as --stream-from, but each\n"
 	       "                     frame is prefixed by a header. Use for compressed data.\n"
 	       "  --stream-from-host <hostname[:port]>\n"
@@ -606,8 +611,16 @@ void streaming_cmd(int ch, char *optarg)
 {
 	unsigned i;
 	int speed;
+	int r;
 
 	switch (ch) {
+	case OptStreamPixformat:
+		r = parse_pixelfmt(optarg, cap_pixelformat);
+		if (r) {
+			streaming_usage();
+			exit(1);
+		}
+		break;
 	case OptStreamCount:
 		stream_count = strtoul(optarg, 0L, 0);
 		break;
@@ -1853,6 +1866,9 @@ enum stream_type {
 
 static int capture_setup(cv4l_fd &fd, cv4l_queue &in)
 {
+	v4l2_fmtdesc fmt_desc;
+	cv4l_fmt fmt;
+
 	if (fd.streamoff(in.g_type())) {
 		fprintf(stderr, "%s: fd.streamoff error\n", __func__);
 		return -1;
@@ -1865,6 +1881,27 @@ static int capture_setup(cv4l_fd &fd, cv4l_queue &in)
 		return -1;
 	}
 
+	if (cap_pixelformat) {
+		if (fd.enum_fmt(fmt_desc, true, 0, in.g_type())) {
+			fprintf(stderr, "%s: fd.enum_fmt error\n", __func__);
+			return -1;
+		}
+
+		do {
+			if (cap_pixelformat == fmt_desc.pixelformat)
+				break;
+		} while (!fd.enum_fmt(fmt_desc));
+
+		if (cap_pixelformat != fmt_desc.pixelformat) {
+			fprintf(stderr, "%s: format from user not supported\n", __func__);
+			return -1;
+		}
+
+		fd.g_fmt(fmt, in.g_type());
+		fmt.s_pixelformat(cap_pixelformat);
+		fd.s_fmt(fmt, in.g_type());
+	}
+
 	if (in.reqbufs(&fd, reqbufs_count_cap)) {
 		fprintf(stderr, "%s: in.reqbufs %u error\n", __func__,
 			reqbufs_count_cap);
diff --git a/utils/v4l2-ctl/v4l2-ctl.cpp b/utils/v4l2-ctl/v4l2-ctl.cpp
index 1783979d..2cbf519e 100644
--- a/utils/v4l2-ctl/v4l2-ctl.cpp
+++ b/utils/v4l2-ctl/v4l2-ctl.cpp
@@ -238,6 +238,7 @@ static struct option long_options[] = {
 	{"list-buffers-sdr", no_argument, 0, OptListBuffersSdr},
 	{"list-buffers-sdr-out", no_argument, 0, OptListBuffersSdrOut},
 	{"list-buffers-meta", no_argument, 0, OptListBuffersMeta},
+	{"stream-pixformat", required_argument, 0, OptStreamPixformat},
 	{"stream-count", required_argument, 0, OptStreamCount},
 	{"stream-skip", required_argument, 0, OptStreamSkip},
 	{"stream-loop", no_argument, 0, OptStreamLoop},
@@ -722,6 +723,30 @@ __u32 parse_quantization(const char *s)
 	return V4L2_QUANTIZATION_DEFAULT;
 }
 
+int parse_pixelfmt(char *value,  __u32 &pixelformat)
+{
+	int fmts = 0;
+	bool be_pixfmt;
+
+	if(!value)
+		return -EINVAL;
+
+	be_pixfmt = strlen(value) == 7 && !memcmp(value + 4, "-BE", 3);
+	if (be_pixfmt)
+		value[4] = 0;
+	if (strlen(value) == 4) {
+		pixelformat =
+			v4l2_fourcc(value[0], value[1],
+					value[2], value[3]);
+		if (be_pixfmt)
+			pixelformat |= 1 << 31;
+	} else {
+		pixelformat = strtol(value, 0L, 0);
+	}
+	fmts |= FmtPixelFormat;
+	return 0;
+}
+
 int parse_fmt(char *optarg, __u32 &width, __u32 &height, __u32 &pixelformat,
 	      __u32 &field, __u32 &colorspace, __u32 &xfer_func, __u32 &ycbcr,
 	      __u32 &quantization, __u32 &flags, __u32 *bytesperline)
@@ -729,7 +754,6 @@ int parse_fmt(char *optarg, __u32 &width, __u32 &height, __u32 &pixelformat,
 	char *value, *subs;
 	int fmts = 0;
 	unsigned bpl_index = 0;
-	bool be_pixfmt;
 
 	field = V4L2_FIELD_ANY;
 	flags = 0;
@@ -760,18 +784,7 @@ int parse_fmt(char *optarg, __u32 &width, __u32 &height, __u32 &pixelformat,
 			fmts |= FmtHeight;
 			break;
 		case 2:
-			be_pixfmt = strlen(value) == 7 && !memcmp(value + 4, "-BE", 3);
-			if (be_pixfmt)
-				value[4] = 0;
-			if (strlen(value) == 4) {
-				pixelformat =
-					v4l2_fourcc(value[0], value[1],
-							value[2], value[3]);
-				if (be_pixfmt)
-					pixelformat |= 1 << 31;
-			} else {
-				pixelformat = strtol(value, 0L, 0);
-			}
+			parse_pixelfmt(value, pixelformat);
 			fmts |= FmtPixelFormat;
 			break;
 		case 3:
diff --git a/utils/v4l2-ctl/v4l2-ctl.h b/utils/v4l2-ctl/v4l2-ctl.h
index 5a52a0a4..8eee5351 100644
--- a/utils/v4l2-ctl/v4l2-ctl.h
+++ b/utils/v4l2-ctl/v4l2-ctl.h
@@ -205,6 +205,7 @@ enum Option {
 	OptListBuffersSdr,
 	OptListBuffersSdrOut,
 	OptListBuffersMeta,
+	OptStreamPixformat,
 	OptStreamCount,
 	OptStreamSkip,
 	OptStreamLoop,
@@ -299,6 +300,7 @@ __u32 parse_xfer_func(const char *s);
 __u32 parse_ycbcr(const char *s);
 __u32 parse_hsv(const char *s);
 __u32 parse_quantization(const char *s);
+int parse_pixelfmt(char *value,  __u32 &pixelformat);
 int parse_fmt(char *optarg, __u32 &width, __u32 &height, __u32 &pixelformat,
 	      __u32 &field, __u32 &colorspace, __u32 &xfer, __u32 &ycbcr,
 	      __u32 &quantization, __u32 &flags, __u32 *bytesperline);
-- 
2.17.1

