Return-Path: <SRS0=HRs9=P4=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D6344C61CE4
	for <linux-media@archiver.kernel.org>; Sun, 20 Jan 2019 11:15:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9C5372087E
	for <linux-media@archiver.kernel.org>; Sun, 20 Jan 2019 11:15:40 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="VMa6rXNJ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730473AbfATLPk (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Sun, 20 Jan 2019 06:15:40 -0500
Received: from mail-wm1-f66.google.com ([209.85.128.66]:52084 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730485AbfATLPj (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sun, 20 Jan 2019 06:15:39 -0500
Received: by mail-wm1-f66.google.com with SMTP id b11so8294240wmj.1
        for <linux-media@vger.kernel.org>; Sun, 20 Jan 2019 03:15:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=x4XFwEO8zi394fzsOH/mreWQHo+TLvhMV9apS6XZqTc=;
        b=VMa6rXNJ1/oWbCg2XxgVkEeMp8x11Biju4iZpBlnI1Q0H/SVY0hzA67WtWOj9Z2ZL6
         O0Z36wLbNk4TiaALPaV7Mr6DGulNvqYHQIQ7mWspcqM0K2vZpv8V6gHuJZF4ElU1TW5o
         FtAOamFpeWkVQZ3KODlhmKUSU7EHBYObuPZ4Gt6e8lRAveZ16GayBXoHv4P2AncO/Jio
         ML215BtAbOxxJYV+C3yWdyH+p9CdgnLf0+G6hcSV1XAk+NMUScDm8Oku/PHAKZs0PGKY
         egDjN9V/UduwzMUhR+5wrKJe55ZkSTnJ5itfZFO27yTb2HMYwJ/KNYQOwwrJGJjgc3+q
         Pg7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=x4XFwEO8zi394fzsOH/mreWQHo+TLvhMV9apS6XZqTc=;
        b=ORX5T7qCLxGKj7HmEhuuTjx4bSFZbVRyNw7OGpU5S8+xOpbL6j7uhCKLN6sZ+g81BX
         xn3Ik/RXGYuvHMwD3j1lqACuZ4M4+0E9U8HQSPPHQswxrv4c1SBj1W4JvAjNuYzU263O
         4OzW1nUF7xhb+5RZ1M4hDc2chjL/1QuIOxK0fJAI+NLR/nDNdNwF8FRdROTvfeKPoT/G
         qcgzgJV/7RwPW0/rgxnLaLyzsSMXBnQSzdHLd4RxorHy+2PPA7VAdaThBjH90QZrdb4S
         TECdQenIbeu6UIzgZ1sajnyYrRoIgx2kErpHy6S6sI+KjusVYkfsRE7OM3ZrfHO9YIkq
         1vEg==
X-Gm-Message-State: AJcUukfmtg6bNvdg3fyJfcsEX0yufLarr7+Q/EurRJyYc1e49h8YyDkr
        e1um7UVdwL/Dghk7AjRFXTclJnVEVrk=
X-Google-Smtp-Source: ALg8bN73vT4yOC9Hpt0GQqHlco6zkkBNZxEaQNNDnrvsfa664uPAOiLro49cpRw6coVPmKm4672SKA==
X-Received: by 2002:a1c:1d8e:: with SMTP id d136mr11688101wmd.98.1547982936881;
        Sun, 20 Jan 2019 03:15:36 -0800 (PST)
Received: from localhost.localdomain ([87.70.46.65])
        by smtp.gmail.com with ESMTPSA id n11sm28281796wrw.60.2019.01.20.03.15.35
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 20 Jan 2019 03:15:36 -0800 (PST)
From:   Dafna Hirschfeld <dafna3@gmail.com>
To:     linux-media@vger.kernel.org
Cc:     hverkuil@xs4all.nl, helen.koike@collabora.com,
        Dafna Hirschfeld <dafna3@gmail.com>
Subject: [v4l-utils PATCH 6/6] v4l2-ctl: Add --stream-pixformat option
Date:   Sun, 20 Jan 2019 03:15:20 -0800
Message-Id: <20190120111520.114305-7-dafna3@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190120111520.114305-1-dafna3@gmail.com>
References: <20190120111520.114305-1-dafna3@gmail.com>
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
 utils/v4l2-ctl/v4l2-ctl-streaming.cpp | 29 +++++++++++++++++++-
 utils/v4l2-ctl/v4l2-ctl.cpp           | 39 ++++++++++++++++++---------
 utils/v4l2-ctl/v4l2-ctl.h             |  2 ++
 3 files changed, 56 insertions(+), 14 deletions(-)

diff --git a/utils/v4l2-ctl/v4l2-ctl-streaming.cpp b/utils/v4l2-ctl/v4l2-ctl-streaming.cpp
index 61dd84db..7ee472b1 100644
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
@@ -609,8 +614,16 @@ void streaming_cmd(int ch, char *optarg)
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
@@ -1869,6 +1882,7 @@ static int capture_setup(cv4l_fd &fd, cv4l_queue &in)
 {
 	struct v4l2_fmtdesc fmt_desc;
 	cv4l_fmt fmt;
+	unsigned int chosen_pixformat;
 
 	if (fd.streamoff(in.g_type())) {
 		fprintf(stderr, "%s: fd.streamoff error\n", __func__);
@@ -1887,8 +1901,21 @@ static int capture_setup(cv4l_fd &fd, cv4l_queue &in)
 		return -1;
 	}
 
+	if (cap_pixelformat) {
+		do {
+			if (cap_pixelformat == fmt_desc.pixelformat)
+				break;
+		} while (!fd.enum_fmt(fmt_desc));
+
+		if (cap_pixelformat != fmt_desc.pixelformat) {
+			fprintf(stderr, "%s: format from user not supported\n", __func__);
+			return -1;
+		}
+	}
+
+	chosen_pixformat = fmt_desc.pixelformat;
 	fd.g_fmt(fmt, in.g_type());
-	fmt.s_pixelformat(fmt_desc.pixelformat);
+	fmt.s_pixelformat(chosen_pixformat);
 	fd.s_fmt(fmt, in.g_type());
 
 	if (in.reqbufs(&fd, reqbufs_count_cap)) {
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

