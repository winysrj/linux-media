Return-Path: <SRS0=HRs9=P4=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 98E22C61CE4
	for <linux-media@archiver.kernel.org>; Sun, 20 Jan 2019 11:15:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 624592087E
	for <linux-media@archiver.kernel.org>; Sun, 20 Jan 2019 11:15:35 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="WKZYw9Kt"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730494AbfATLPe (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Sun, 20 Jan 2019 06:15:34 -0500
Received: from mail-wr1-f67.google.com ([209.85.221.67]:40969 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730485AbfATLPe (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sun, 20 Jan 2019 06:15:34 -0500
Received: by mail-wr1-f67.google.com with SMTP id x10so20030391wrs.8
        for <linux-media@vger.kernel.org>; Sun, 20 Jan 2019 03:15:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=lhUt4MCSYBcoj9QkV5uD5hupkXsfjcJMHDwhcTO/SYE=;
        b=WKZYw9Ktz3EnbLHkOXRlZr445VxadwheeeaTvQiIL2m0TCFaBRhZR4dC5YxzAgXwbj
         Oh1W6+d/Sq0YpPRN1wh19ef27+FlGvBKKySqC0UinRH+DcesaE9+vgbzdhp3jz6dgY47
         5hwFPArKbMgcc9xaj0LPrCc0vuHm3kwkrx97BchpS8wCyZgxSUFRyHy3VqR/U6hLqweO
         c+hip+wyWdXSPmL0gJ4fA1+TYUElxc2j20HYQ4FwrE4C0Lk0FhnXARou5guT2yOfAO4a
         qQ1GnjbWghS0I8f69bIVjFgUUIfK/OPrFf//OoL9rnJVKxdf3ntCl6NYHWTV89T2eIFu
         AuVw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=lhUt4MCSYBcoj9QkV5uD5hupkXsfjcJMHDwhcTO/SYE=;
        b=O2xP/uMuFK0Q7rFU0V1SK36MPNS0IrkLjV/IzkiszhFzVDuM9L1TXJGMKlbqXDJoET
         5nafp+cT7V13lknTdkR1nk5sWn7v8o9v82SagybdsuWXNHxjfzxtuQKr72YWK6JpgDJo
         AuDdny+3LIfWxTF18dm4x9zOXTKZzzKf8mAGfkLqy50q7keI/dqaJXU+GIsXplE/MDqq
         YzQGmcY5tie62xaVZuK9FFp5+Ym1lnAzM3qBMx7khQob+CIikUTPy6usRlLxlbJ9IJ+S
         uypmLidm/nAI+CPatrnjnfDKDRVFa73AkxqOwV7K3RYhKEEReIrzVQQN7dI9Ct9Y0sSX
         BfCQ==
X-Gm-Message-State: AJcUuke8LlNSt6mIMZMP+pH5tiXBIWKX7ib1ghwqujk69O7OzW8fLKK0
        yD82Z8udh0Id+P8qk5K0LZcVMQ1sWmI=
X-Google-Smtp-Source: ALg8bN5/zACBm53FgnpkDBqzvAzrdSksZX0J4gkoBUbDjFswBQJKwR6jS8R4VtFI9uPxMj06NwNH3A==
X-Received: by 2002:a5d:49cd:: with SMTP id t13mr24185533wrs.144.1547982931795;
        Sun, 20 Jan 2019 03:15:31 -0800 (PST)
Received: from localhost.localdomain ([87.70.46.65])
        by smtp.gmail.com with ESMTPSA id n11sm28281796wrw.60.2019.01.20.03.15.30
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 20 Jan 2019 03:15:31 -0800 (PST)
From:   Dafna Hirschfeld <dafna3@gmail.com>
To:     linux-media@vger.kernel.org
Cc:     hverkuil@xs4all.nl, helen.koike@collabora.com,
        Dafna Hirschfeld <dafna3@gmail.com>
Subject: [v4l-utils PATCH 2/6] v4l2-ctl: Add function get_codec_type
Date:   Sun, 20 Jan 2019 03:15:16 -0800
Message-Id: <20190120111520.114305-3-dafna3@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190120111520.114305-1-dafna3@gmail.com>
References: <20190120111520.114305-1-dafna3@gmail.com>
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
 utils/v4l2-ctl/v4l2-ctl-streaming.cpp | 126 ++++++++++++++++++--------
 1 file changed, 88 insertions(+), 38 deletions(-)

diff --git a/utils/v4l2-ctl/v4l2-ctl-streaming.cpp b/utils/v4l2-ctl/v4l2-ctl-streaming.cpp
index 8a98b6bd..3e81fdfc 100644
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
@@ -334,6 +340,88 @@ void streaming_usage(void)
 	       	V4L_STREAM_PORT);
 }
 
+static int get_codec_type(cv4l_fd &fd, enum codec_type &codec_type)
+{
+	struct v4l2_fmtdesc fmt_desc;
+	int num_cap_fmts = 0;
+	int num_compressed_cap_fmts = 0;
+	int num_out_fmts = 0;
+	int num_compressed_out_fmts = 0;
+
+	codec_type = NOT_CODEC;
+	if (!fd.has_vid_m2m())
+		return 0;
+
+	if (fd.enum_fmt(fmt_desc, true, 0, V4L2_BUF_TYPE_VIDEO_CAPTURE))
+		return -1;
+
+	do {
+		if (fmt_desc.flags & V4L2_FMT_FLAG_COMPRESSED)
+			num_compressed_cap_fmts++;
+		num_cap_fmts++;
+	} while (!fd.enum_fmt(fmt_desc));
+
+
+	if (fd.enum_fmt(fmt_desc, true, 0, V4L2_BUF_TYPE_VIDEO_OUTPUT))
+		return -1;
+
+	do {
+		if (fmt_desc.flags & V4L2_FMT_FLAG_COMPRESSED)
+			num_compressed_out_fmts++;
+		num_out_fmts++;
+	} while (!fd.enum_fmt(fmt_desc));
+
+	if (num_compressed_out_fmts == 0 && num_compressed_cap_fmts == num_cap_fmts) {
+		codec_type = ENCODER;
+		return 0;
+	}
+
+	if (num_compressed_cap_fmts == 0 && num_compressed_out_fmts == num_out_fmts) {
+		codec_type = DECODER;
+		return 0;
+	}
+
+	return 0;
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
@@ -2109,44 +2197,6 @@ done:
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

