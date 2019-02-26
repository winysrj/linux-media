Return-Path: <SRS0=99fO=RB=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0EBDCC43381
	for <linux-media@archiver.kernel.org>; Tue, 26 Feb 2019 17:05:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D052D20C01
	for <linux-media@archiver.kernel.org>; Tue, 26 Feb 2019 17:05:51 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="OiMKldJs"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728609AbfBZRFv (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Tue, 26 Feb 2019 12:05:51 -0500
Received: from mail-wm1-f66.google.com ([209.85.128.66]:55550 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728595AbfBZRFv (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 26 Feb 2019 12:05:51 -0500
Received: by mail-wm1-f66.google.com with SMTP id q187so3166983wme.5
        for <linux-media@vger.kernel.org>; Tue, 26 Feb 2019 09:05:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=GEbCD/ih7J+/ZvXmFpUkDA3R5lsMRrCkygPLKoaIavw=;
        b=OiMKldJspIqO4F1JuU/S/09GISgXcY323uuaYGQqZpFd4CRKywvVJUdlV3Tl/gajAL
         ng/6a+7DlOE+7+DacrgEfG+MeocNAHF2iN5HLMsZge8aVDaBqJUZ3kpx24GPT89MiANU
         zmOr1nHJktc9soTvP1bhhTkEmrQUPhf+OxiQx3cxTLh5pyId925PVAHbBCN0FAj887q1
         LfnJGoAkRynBO8B6JevidzQxBsrJ1qQSWg3KaqTSRh3Frg00pQF2quZEidGt7GvhBy+2
         1yDoEbvMpg4M/9xpaumEs5/krYZHfy4G1S3c7WVhLB3m8zwmijemeUY0wNNHL0vK8dID
         /fkg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=GEbCD/ih7J+/ZvXmFpUkDA3R5lsMRrCkygPLKoaIavw=;
        b=dpS5bKKBVcg9W+gLTln+MNooHnj5blwUxkvwDUI6StQw1vCXPm2uwZnldw9sIPKyun
         40zX57ICSh22HVcQMmQO2wx199YIaf149xYP1kPhtBHEgqp1X4ssEnSWc2t9wBJ26Wi0
         rsLvGlT3bAXTZeCqW1w2t8pRLOosaKn4pjR3nuduQ9f8+V25ZTN2RVrKFAR59OlLlbu5
         SaiTmLwgjrTeo2YX+SFkcgARusD7AgHSrWJMUzCEUlaXMc7NBHSgw0UYfUk9F9Jee2oe
         eykw0ibXLfoi6Pskbpyj6XBDqzoFxFEYl3aCu/HzCAIPjryvkLl41hDthYMgbKhrfFy3
         8+kQ==
X-Gm-Message-State: AHQUAuaEAgvtEn+EebEhnz9F1ldP2LVGBCd8qkREhulEnv1MTvq8tTs7
        i3wxiv/6H1+XBmT6AWusUldjCitjMU0=
X-Google-Smtp-Source: AHgI3IZsCKsZXnK/gnxW1LIig/5SiZGu8ZvxwVSRRPJeq2mHR1rK09zVeRuFffVEsZ3InsbHKLEKIw==
X-Received: by 2002:a7b:c08d:: with SMTP id r13mr3335387wmh.55.1551200748716;
        Tue, 26 Feb 2019 09:05:48 -0800 (PST)
Received: from ubuntu.home ([77.127.107.32])
        by smtp.gmail.com with ESMTPSA id w4sm21024486wrk.85.2019.02.26.09.05.47
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 26 Feb 2019 09:05:48 -0800 (PST)
From:   Dafna Hirschfeld <dafna3@gmail.com>
To:     linux-media@vger.kernel.org
Cc:     hverkuil@xs4all.nl, helen.koike@collabora.com,
        Dafna Hirschfeld <dafna3@gmail.com>
Subject: [PATCH v5 13/21] media: vicodec: Validate version dependent header values in a separate function
Date:   Tue, 26 Feb 2019 09:05:06 -0800
Message-Id: <20190226170514.86127-14-dafna3@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190226170514.86127-1-dafna3@gmail.com>
References: <20190226170514.86127-1-dafna3@gmail.com>
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
index 4b97ba30fec3..d051f9901409 100644
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

