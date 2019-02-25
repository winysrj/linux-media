Return-Path: <SRS0=o7tn=RA=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A5D9CC43381
	for <linux-media@archiver.kernel.org>; Mon, 25 Feb 2019 22:22:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6EAD2213A2
	for <linux-media@archiver.kernel.org>; Mon, 25 Feb 2019 22:22:26 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="MauBkCUI"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727616AbfBYWW0 (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Mon, 25 Feb 2019 17:22:26 -0500
Received: from mail-wr1-f68.google.com ([209.85.221.68]:42033 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727554AbfBYWWZ (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 25 Feb 2019 17:22:25 -0500
Received: by mail-wr1-f68.google.com with SMTP id r5so11699404wrg.9
        for <linux-media@vger.kernel.org>; Mon, 25 Feb 2019 14:22:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=GEbCD/ih7J+/ZvXmFpUkDA3R5lsMRrCkygPLKoaIavw=;
        b=MauBkCUIGR++dPfS171zKSBMnrNGIJwEdzD4s+0Y1fNjkUTMlCzWMBJ2x+3dEZ2sgK
         +6SJwwrtvXkd9sfRCHgL7mn55V3lPTl5IN4F7x8NI4K4EQZ9rX+r0uUdE9dr2Up1Eg0/
         uN0rVYyhL8ozOG3dgWYOozZds1BdQNBkehHKxAG+zX93j0L12251jrWRVljj0wcy+2jn
         OtsvmgFXWS+hCMxu8Si7JZ9zxrsbR287+uAKlohOb9idaJlz4d5GsEF0UWkNXJVzo27L
         kJRg1TpD3TwHLxrfmYT7j0Yj0hjtZXTHlUySMwBVi6QUAnTF9dTkpJme3x47SmoDF32j
         H79Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=GEbCD/ih7J+/ZvXmFpUkDA3R5lsMRrCkygPLKoaIavw=;
        b=q33s9SNuaaUEDf0nXwMoPKtOCr65bSX6VuDF9YFVTnZWuifG90b6y03IAbxuwjVOiV
         ciiRvsL3GM+Krq0GLdj03iqcx6V72l2J7epC82l4Uboska5uD4NgPowiPCKrDI7RTgEP
         M2wiiv254ydkQWNsPEvEPuplz833b01HYN2hcf38LW4g2qqYj/fUgDiC8QCI8DfUORqY
         dfR4ZT0vOIweQKDR10ExBpjpPSMJBOP7UbQhnSBYoSUJaOGgkNmZY/vik9RfQ81LYZlo
         aAweMvA5S8id0S2dj9880AfWd9c5AXeg6o2tTo+ltrVX+EJvbrQZuN2j+26IJTXk+mql
         tn8w==
X-Gm-Message-State: AHQUAuYdxvGt3DW3N1pwLCPFgl6ehLy0jiDNblqLKSgYO7Ufm7+BT+qw
        5z92MpbWXpXZbzJdSXMAHgUKiH9B4zc=
X-Google-Smtp-Source: AHgI3IbyHcKnF1pBPUhURGYr63OEPsEik2/KyExj4gTSpb0QTYhdWbHQ19dCJzSsfJLrEhPP6jcaIg==
X-Received: by 2002:a5d:6a8e:: with SMTP id s14mr13856748wru.31.1551133343498;
        Mon, 25 Feb 2019 14:22:23 -0800 (PST)
Received: from ubuntu.home ([77.127.107.32])
        by smtp.gmail.com with ESMTPSA id d206sm16981422wmc.11.2019.02.25.14.22.22
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 25 Feb 2019 14:22:22 -0800 (PST)
From:   Dafna Hirschfeld <dafna3@gmail.com>
To:     linux-media@vger.kernel.org
Cc:     hverkuil@xs4all.nl, helen.koike@collabora.com,
        Dafna Hirschfeld <dafna3@gmail.com>
Subject: [PATCH v4 13/21] media: vicodec: Validate version dependent header values in a separate function
Date:   Mon, 25 Feb 2019 14:22:04 -0800
Message-Id: <20190225222210.121713-4-dafna3@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190225222210.121713-1-dafna3@gmail.com>
References: <20190225222210.121713-1-dafna3@gmail.com>
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

