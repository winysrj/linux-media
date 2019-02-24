Return-Path: <SRS0=d4St=Q7=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 52F98C00319
	for <linux-media@archiver.kernel.org>; Sun, 24 Feb 2019 09:03:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 20C0E206B6
	for <linux-media@archiver.kernel.org>; Sun, 24 Feb 2019 09:03:10 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="BxSkxK3e"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728212AbfBXJDJ (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Sun, 24 Feb 2019 04:03:09 -0500
Received: from mail-wr1-f67.google.com ([209.85.221.67]:40100 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728207AbfBXJDI (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sun, 24 Feb 2019 04:03:08 -0500
Received: by mail-wr1-f67.google.com with SMTP id q1so6662876wrp.7
        for <linux-media@vger.kernel.org>; Sun, 24 Feb 2019 01:03:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=x7ib4WLUfGJ45BSE6ujgHo5L3bC+9vl6OSVSFf4Ry00=;
        b=BxSkxK3edJmCnsn87AgVlHFCe0W6UEl/Il9xEVsk9GEO8dGn3pSAxYUVqQbjQD5IYC
         qld5Fscwh3WeiV7pP5JeevvkbnWV0pzDmSYEw2K9D+55JYlw2OGL+oQVMhTDBkq5DRK1
         Msdbt6bssaHWHeAvB/u1bVX8lkLAE1LQiUZe2he1ssGsY8x0QIV2OsqlEtnMe8Qsu4k0
         Sr8BCgEcZwzLG8WqzYxzDJq7H36aplALkV1i9jQluFTsnv9CQ5kAAdtQvVa2ojf0M15A
         eWnLerbvhCya22IOsvnGvAWIP4fa4DypKotOfifCfZBXw+JOpG/hgDzBhCqSu/B2Uyez
         dLSw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=x7ib4WLUfGJ45BSE6ujgHo5L3bC+9vl6OSVSFf4Ry00=;
        b=SUAukQhDDvZx9RnwmL1z1E0YBX5hWqX2R/EGtXXaeS5bjdq99RRIMKipWuLhSF0n5S
         OqP7BieyzWASoF0ESs2FjJ7mmsHcPH5LYHZ2EFu3PS1VnYckrFwQB6WtwORufd01MGZb
         uRIUiFoJX4U0mOIhBHqS7HVkn6Re+U4AEsqQT4hcST6O2KNtHA3kgw2tHwf10LN+8HwB
         vK10wFaUy1GYa3WRGsu63FQcFQohPzBYLOPyC6ZvqRsueVzxb04cPD7XY44ARTsp/sEn
         IzqUz/BB6o5ljErBexk0uZZ20IOwFyXSOGvX0pp4DF1VBFdU4gY/Wgl7tYKDY0pGpEnG
         u+Xw==
X-Gm-Message-State: AHQUAubORrnWFVo06xdmmYY6yZiN5TeEBbjrikqhulSDK6xTdCnw55WH
        6DBtH+kF4QweYFhpkBMmEfLo547dvi4=
X-Google-Smtp-Source: AHgI3IZI546QAOZqZBNi7ppbuI5UpxHkiU6gS+DunimTJ2d2m9yVkZqWok8ffFuagDU+oOlW1cFIAQ==
X-Received: by 2002:a05:6000:1142:: with SMTP id d2mr8524668wrx.43.1550998986728;
        Sun, 24 Feb 2019 01:03:06 -0800 (PST)
Received: from ubuntu.home ([77.127.107.32])
        by smtp.gmail.com with ESMTPSA id e75sm8701971wmg.32.2019.02.24.01.03.05
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 24 Feb 2019 01:03:06 -0800 (PST)
From:   Dafna Hirschfeld <dafna3@gmail.com>
To:     linux-media@vger.kernel.org
Cc:     hverkuil@xs4all.nl, helen.koike@collabora.com,
        Dafna Hirschfeld <dafna3@gmail.com>
Subject: [PATCH v3 12/18] media: vicodec: Validate version dependent header values in a separate function
Date:   Sun, 24 Feb 2019 01:02:29 -0800
Message-Id: <20190224090234.19723-13-dafna3@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190224090234.19723-1-dafna3@gmail.com>
References: <20190224090234.19723-1-dafna3@gmail.com>
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Move the code that validates version dependent header
values to a separate function 'validate_by_version'

Signed-off-by: Dafna Hirschfeld <dafna3@gmail.com>
---
 drivers/media/platform/vicodec/vicodec-core.c | 31 ++++++++++++-------
 1 file changed, 19 insertions(+), 12 deletions(-)

diff --git a/drivers/media/platform/vicodec/vicodec-core.c b/drivers/media/platform/vicodec/vicodec-core.c
index c07e131d23ba..55b003de43a3 100644
--- a/drivers/media/platform/vicodec/vicodec-core.c
+++ b/drivers/media/platform/vicodec/vicodec-core.c
@@ -191,6 +191,23 @@ static void copy_cap_to_ref(const u8 *cap, const struct v4l2_fwht_pixfmt_info *i
 	}
 }
 
+static bool validate_by_version(unsigned int flags, unsigned int version)
+{
+	if (!version || version > FWHT_VERSION)
+		return false;
+
+	if (version >= 2) {
+		unsigned int components_num = 1 +
+			((flags & FWHT_FL_COMPONENTS_NUM_MSK) >>
+			 FWHT_FL_COMPONENTS_NUM_OFFSET);
+		unsigned int pixenc = flags & FWHT_FL_PIXENC_MSK;
+
+		if (components_num == 0 || components_num > 4 || !pixenc)
+			return false;
+	}
+	return true;
+}
+
 static int device_process(struct vicodec_ctx *ctx,
 			  struct vb2_v4l2_buffer *src_vb,
 			  struct vb2_v4l2_buffer *dst_vb)
@@ -397,21 +414,11 @@ static bool is_header_valid(const struct fwht_cframe_hdr *p_hdr)
 	unsigned int version = ntohl(p_hdr->version);
 	unsigned int flags = ntohl(p_hdr->flags);
 
-	if (!version || version > FWHT_VERSION)
-		return false;
-
 	if (w < MIN_WIDTH || w > MAX_WIDTH || h < MIN_HEIGHT || h > MAX_HEIGHT)
 		return false;
 
-	if (version >= 2) {
-		unsigned int components_num = 1 +
-			((flags & FWHT_FL_COMPONENTS_NUM_MSK) >>
-			FWHT_FL_COMPONENTS_NUM_OFFSET);
-		unsigned int pixenc = flags & FWHT_FL_PIXENC_MSK;
-
-		if (components_num == 0 || components_num > 4 || !pixenc)
-			return false;
-	}
+	if (!validate_by_version(flags, version))
+		return false;
 
 	info = info_from_header(p_hdr);
 	if (!info)
-- 
2.17.1

