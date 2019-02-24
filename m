Return-Path: <SRS0=d4St=Q7=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9610DC00319
	for <linux-media@archiver.kernel.org>; Sun, 24 Feb 2019 08:41:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 61FB12083E
	for <linux-media@archiver.kernel.org>; Sun, 24 Feb 2019 08:41:48 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="C9GePsei"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726865AbfBXIlr (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Sun, 24 Feb 2019 03:41:47 -0500
Received: from mail-wr1-f68.google.com ([209.85.221.68]:39594 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725771AbfBXIlr (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sun, 24 Feb 2019 03:41:47 -0500
Received: by mail-wr1-f68.google.com with SMTP id l5so6638052wrw.6
        for <linux-media@vger.kernel.org>; Sun, 24 Feb 2019 00:41:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=dABEz0fJdhaPuLioYTDa9ju/kgubMdcKZ7LfKuQKK1M=;
        b=C9GePseimwzh/trIGz4A8cSMxxbDfxMQG/VReePMqAwDWSNLG2B7C3ERavS6sGhuc3
         +FNE/q0kDsy4VyGkRwy3pRgNFLxKkbYtmznN4EyrK6h8uAoZ0xowGaqBn1NuSl9E/fES
         tyliN8kjYRIQbYSJR8iGY+gU4RZKpT3vtCUcoeZzgDh56Dpy7w9B0rRie+31tlIeF0VI
         AmkAenzdEtlMSbHv/NbTc50b2HB3Cuk5KYaa0hw+AwnZJszm5y+jz0BZ2NXFs9XO2T6x
         v/J8J81Rrk/U8AeAIkw++uC+sevERcPJ8ZfPgVBQQaO8Qn/QzxEOgLcQSUhssilJ0pbd
         ogrw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=dABEz0fJdhaPuLioYTDa9ju/kgubMdcKZ7LfKuQKK1M=;
        b=jmJFt+wHwIER7aoCFzxoUAA2NfcwnhvkEEjFccANw2C0XPdF4B24ZwVbgSSb2glfUq
         7VAe8MI5LwoWMq2rxcFpCy6+e6iE9aQMBC1CtvG65rhgnyFJNeGDWlgpe2z52Q4JlZJ5
         qX/FyewYUvcMPw4lTxqmb3IBKEOQDpk41bfpaz0CTzvXYahToWWQdunazR4ZBM1tCyTF
         6cKK4knFAgqhH4S83Te9S2iUSQKFjLH7NYJP5qbnBxoauhCIBC2aPW56FnVfwb4UVHgT
         syh1bkFctDOqMHrBY/fgl5Uh/CVos8ijsJTXXgFYB4ETKzdjKpFB1QFlOuoktPWh0Sgx
         kdTw==
X-Gm-Message-State: AHQUAuYoyXpAj6Lh6GBGSMs/AKrigo19rLAru1dl9YpBeSrU7H6ODLM3
        l9n8w9wxYDvPC8VvVwjkKCve6lONMGQ=
X-Google-Smtp-Source: AHgI3Ibkz8e+w+yU0dc0SGaUpUkqtQG7JRiNduCi7U/qKXvnlEWQ2pT/ucn7ONBfl+SuZoAAGJSZ4Q==
X-Received: by 2002:adf:f3d0:: with SMTP id g16mr8579380wrp.29.1550997705319;
        Sun, 24 Feb 2019 00:41:45 -0800 (PST)
Received: from ubuntu.home ([77.127.107.32])
        by smtp.gmail.com with ESMTPSA id x24sm6837465wmi.5.2019.02.24.00.41.44
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 24 Feb 2019 00:41:44 -0800 (PST)
From:   Dafna Hirschfeld <dafna3@gmail.com>
To:     linux-media@vger.kernel.org
Cc:     hverkuil@xs4all.nl, helen.koike@collabora.com,
        Dafna Hirschfeld <dafna3@gmail.com>
Subject: [v4l-utils PATCH v3 2/8] v4l2-ctl: bugfix: correctly read/write V4L2_PIX_FMT_NV24 padded buffer
Date:   Sun, 24 Feb 2019 00:41:20 -0800
Message-Id: <20190224084126.19412-3-dafna3@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190224084126.19412-1-dafna3@gmail.com>
References: <20190224084126.19412-1-dafna3@gmail.com>
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

For V4L2_PIX_FMT_NV24/42 types the chroma stride is twice the
luma stride. Add support for it in 'read_write_padded_frame'

Signed-off-by: Dafna Hirschfeld <dafna3@gmail.com>
---
 utils/v4l2-ctl/v4l2-ctl-streaming.cpp | 18 +++++++++++++-----
 1 file changed, 13 insertions(+), 5 deletions(-)

diff --git a/utils/v4l2-ctl/v4l2-ctl-streaming.cpp b/utils/v4l2-ctl/v4l2-ctl-streaming.cpp
index 352b946d..6f4317bf 100644
--- a/utils/v4l2-ctl/v4l2-ctl-streaming.cpp
+++ b/utils/v4l2-ctl/v4l2-ctl-streaming.cpp
@@ -760,6 +760,7 @@ static void read_write_padded_frame(cv4l_fmt &fmt, unsigned char *buf,
 	unsigned real_height;
 	unsigned char *plane_p = buf;
 	unsigned char *row_p;
+	unsigned stride = fmt.g_bytesperline();
 
 	if (is_read) {
 		real_width  = cropped_width;
@@ -776,13 +777,20 @@ static void read_write_padded_frame(cv4l_fmt &fmt, unsigned char *buf,
 		bool is_chroma_plane = plane_idx == 1 || plane_idx == 2;
 		unsigned h_div = is_chroma_plane ? info->height_div : 1;
 		unsigned w_div = is_chroma_plane ? info->width_div : 1;
-		unsigned step = is_chroma_plane ? info->chroma_step : info->luma_alpha_step;
-		unsigned stride_div = (info->planes_num == 3 && plane_idx > 0) ? 2 : 1;
+		unsigned step = is_chroma_plane ? info->chroma_step :
+			info->luma_alpha_step;
+		unsigned int consume_sz = step * real_width / w_div;
+
+		if (info->planes_num == 3 && plane_idx == 1)
+			stride /= 2;
+
+		if (plane_idx == 1 &&
+		    (info->id == V4L2_PIX_FMT_NV24 || info->id == V4L2_PIX_FMT_NV42))
+			stride *= 2;
 
 		row_p = plane_p;
 		for (unsigned i = 0; i < real_height / h_div; i++) {
 			unsigned int wsz = 0;
-			unsigned int consume_sz = step * real_width / w_div;
 
 			if (is_read)
 				wsz = fread(row_p, 1, consume_sz, fpointer);
@@ -795,9 +803,9 @@ static void read_write_padded_frame(cv4l_fmt &fmt, unsigned char *buf,
 				return;
 			}
 			sz += wsz;
-			row_p += fmt.g_bytesperline() / stride_div;
+			row_p += stride;
 		}
-		plane_p += (fmt.g_bytesperline() / stride_div) * (coded_height / h_div);
+		plane_p += stride * (coded_height / h_div);
 		if (sz == 0)
 			break;
 	}
-- 
2.17.1

