Return-Path: <SRS0=kVnX=P5=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 839ECC31681
	for <linux-media@archiver.kernel.org>; Mon, 21 Jan 2019 18:57:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 52E5020861
	for <linux-media@archiver.kernel.org>; Mon, 21 Jan 2019 18:57:21 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="vII7JBAD"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727189AbfAUS5V (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Mon, 21 Jan 2019 13:57:21 -0500
Received: from mail-wr1-f68.google.com ([209.85.221.68]:33509 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727152AbfAUS5U (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 21 Jan 2019 13:57:20 -0500
Received: by mail-wr1-f68.google.com with SMTP id c14so24684117wrr.0
        for <linux-media@vger.kernel.org>; Mon, 21 Jan 2019 10:57:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=kc+MSQlplxxDQET2NiFuk67i44zf7Qk+gKDf9xtPe8I=;
        b=vII7JBADj47g+sxdRqEYtpVFFEzgyMi2ljUUZm55kJKOb5CKIEXWxlZsqNp3wrAlhf
         8cdp16jsKRxDib1NmH0JoSWHDzUQyo61Aec1fldlV6+KFNScIlPJtEf1IVYa5Yg64rtC
         BjaTRbiGnk/8g5iLuN3PVlRAxYEV9losEWJX6Hyes8pF1x7SF4S6tKo3zBtzosdUfPDA
         nVskSpmMrpGUjNe6i/wxffP/XBHiKoVp9hMBbBIMkjlicmhk5a6xQlPWzDhBW/dNBUN4
         RzBQHQplU1pbW8XeJCLeCHl93/a1wZ2dgYOUS6WeJzrZl/64Ii730zDTLoPyS88l4dl6
         UG9A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=kc+MSQlplxxDQET2NiFuk67i44zf7Qk+gKDf9xtPe8I=;
        b=Hcb1ea2QHkQI5mxDC80BzuTsdQXzCDNqgXAq/o7iSF2Gw7eA9nAIzqBukDgE5hqYEp
         SnAwU1i6AwQ8Ge1Q4eobkGhJ+wnc3yy5sAxTX7n2guFy/C4QGNYH+BUplUcuYzpNnn2e
         NoWlXyi+3K+0qDZP7X3657Ohdghtl1C9+6iIQNWwWWs4PSGpTIH1AK+4Fve6daQOUdb/
         tu2O/FwEITjID1E/rPbl0DAmPPJhPrObc5C4jvGmkIcNxuEgEfY0m38nVQML7H0U5Vcr
         gHXsslUtgimMiPcZ/5X6ivmj8d+YwBgQW1xXfy2pipBYm7+NwD6RioZmDB5Z9PpQq8m5
         BCyg==
X-Gm-Message-State: AJcUukc9uQOvIh9yyno/4novJOdhQb7WglmCchb+W9M99KFFHvOGbHUg
        QwYP4SDG7pVMlMP+evn4fS2eu7IBNgE=
X-Google-Smtp-Source: ALg8bN6kA+vKAzGjnHV43FvyA1nKie5bBW2ZYdj/mVfLRSpazKMmxP2t4hceVkSonghGLCYcbPuOaQ==
X-Received: by 2002:adf:9168:: with SMTP id j95mr28747273wrj.217.1548097038475;
        Mon, 21 Jan 2019 10:57:18 -0800 (PST)
Received: from localhost.localdomain ([87.70.46.65])
        by smtp.gmail.com with ESMTPSA id 67sm145061521wra.37.2019.01.21.10.57.17
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 21 Jan 2019 10:57:17 -0800 (PST)
From:   Dafna Hirschfeld <dafna3@gmail.com>
To:     linux-media@vger.kernel.org
Cc:     hverkuil@xs4all.nl, helen.koike@collabora.com,
        Dafna Hirschfeld <dafna3@gmail.com>
Subject: [v4l-utils PATCH v2 2/5] v4l2-ctl: Add function get_codec_type
Date:   Mon, 21 Jan 2019 10:56:48 -0800
Message-Id: <20190121185651.6229-3-dafna3@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190121185651.6229-1-dafna3@gmail.com>
References: <20190121185651.6229-1-dafna3@gmail.com>
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Add function get_codec_type that returns the type
of codec NOT_CODEC/ENCODER/DEOCDER.
Move the functions get_cap_compose/crop_rect
to the start of the file.

Signed-off-by: Dafna Hirschfeld <dafna3@gmail.com>
---
 utils/v4l2-ctl/v4l2-ctl-streaming.cpp | 123 ++++++++++++++++++--------
 1 file changed, 85 insertions(+), 38 deletions(-)

diff --git a/utils/v4l2-ctl/v4l2-ctl-streaming.cpp b/utils/v4l2-ctl/v4l2-ctl-streaming.cpp
index 8a98b6bd..1383c5f2 100644
--- a/utils/v4l2-ctl/v4l2-ctl-streaming.cpp
+++ b/utils/v4l2-ctl/v4l2-ctl-streaming.cpp
@@ -82,6 +82,12 @@ static bool support_out_crop;
 #define TS_WINDOW 241
 #define FILE_HDR_ID			v4l2_fourcc('V', 'h', 'd', 'r')
 
+enum codec_type {
+	NOT_CODEC,
+	ENCODER,
+	DECODER
+};
+
 class fps_timestamps {
 private:
 	unsigned idx;
@@ -334,6 +340,85 @@ void streaming_usage(void)
 	       	V4L_STREAM_PORT);
 }
 
+static enum codec_type get_codec_type(cv4l_fd &fd)
+{
+	struct v4l2_fmtdesc fmt_desc;
+	int num_cap_fmts = 0;
+	int num_compressed_cap_fmts = 0;
+	int num_out_fmts = 0;
+	int num_compressed_out_fmts = 0;
+
+	if (!fd.has_vid_m2m())
+		return NOT_CODEC;
+
+	if (fd.enum_fmt(fmt_desc, true, 0, V4L2_BUF_TYPE_VIDEO_CAPTURE))
+		return NOT_CODEC;
+
+	do {
+		if (fmt_desc.flags & V4L2_FMT_FLAG_COMPRESSED)
+			num_compressed_cap_fmts++;
+		num_cap_fmts++;
+	} while (!fd.enum_fmt(fmt_desc));
+
+
+	if (fd.enum_fmt(fmt_desc, true, 0, V4L2_BUF_TYPE_VIDEO_OUTPUT))
+		return NOT_CODEC;
+
+	do {
+		if (fmt_desc.flags & V4L2_FMT_FLAG_COMPRESSED)
+			num_compressed_out_fmts++;
+		num_out_fmts++;
+	} while (!fd.enum_fmt(fmt_desc));
+
+	if (num_compressed_out_fmts == 0 && num_compressed_cap_fmts == num_cap_fmts) {
+		return ENCODER;
+	}
+
+	if (num_compressed_cap_fmts == 0 && num_compressed_out_fmts == num_out_fmts) {
+		return DECODER;
+	}
+
+	return NOT_CODEC;
+}
+
+static int get_cap_compose_rect(cv4l_fd &fd)
+{
+	v4l2_selection sel;
+
+	memset(&sel, 0, sizeof(sel));
+	sel.type = vidcap_buftype;
+	sel.target = V4L2_SEL_TGT_COMPOSE;
+
+	if (fd.g_selection(sel) == 0) {
+		support_cap_compose = true;
+		composed_width = sel.r.width;
+		composed_height = sel.r.height;
+		return 0;
+	}
+
+	support_cap_compose = false;
+	return 0;
+}
+
+static int get_out_crop_rect(cv4l_fd &fd)
+{
+	v4l2_selection sel;
+
+	memset(&sel, 0, sizeof(sel));
+	sel.type = vidout_buftype;
+	sel.target = V4L2_SEL_TGT_CROP;
+
+	if (fd.g_selection(sel) == 0) {
+		support_out_crop = true;
+		cropped_width = sel.r.width;
+		cropped_height = sel.r.height;
+		return 0;
+	}
+
+	support_out_crop = false;
+	return 0;
+}
+
 static void set_time_stamp(cv4l_buffer &buf)
 {
 	if ((buf.g_flags() & V4L2_BUF_FLAG_TIMESTAMP_MASK) != V4L2_BUF_FLAG_TIMESTAMP_COPY)
@@ -2109,44 +2194,6 @@ done:
 		fclose(file[OUT]);
 }
 
-static int get_cap_compose_rect(cv4l_fd &fd)
-{
-	v4l2_selection sel;
-
-	memset(&sel, 0, sizeof(sel));
-	sel.type = vidcap_buftype;
-	sel.target = V4L2_SEL_TGT_COMPOSE;
-
-	if (fd.g_selection(sel) == 0) {
-		support_cap_compose = true;
-		composed_width = sel.r.width;
-		composed_height = sel.r.height;
-		return 0;
-	}
-
-	support_cap_compose = false;
-	return 0;
-}
-
-static int get_out_crop_rect(cv4l_fd &fd)
-{
-	v4l2_selection sel;
-
-	memset(&sel, 0, sizeof(sel));
-	sel.type = vidout_buftype;
-	sel.target = V4L2_SEL_TGT_CROP;
-
-	if (fd.g_selection(sel) == 0) {
-		support_out_crop = true;
-		cropped_width = sel.r.width;
-		cropped_height = sel.r.height;
-		return 0;
-	}
-
-	support_out_crop = false;
-	return 0;
-}
-
 void streaming_set(cv4l_fd &fd, cv4l_fd &out_fd)
 {
 	cv4l_disable_trace dt(fd);
-- 
2.17.1

