Return-Path: <SRS0=2oy6=QW=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 06BC0C43381
	for <linux-media@archiver.kernel.org>; Fri, 15 Feb 2019 20:47:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B8C11222D7
	for <linux-media@archiver.kernel.org>; Fri, 15 Feb 2019 20:47:31 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="nkSL53m7"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390056AbfBOUrb (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Fri, 15 Feb 2019 15:47:31 -0500
Received: from mail-wr1-f67.google.com ([209.85.221.67]:46278 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727198AbfBOUra (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 15 Feb 2019 15:47:30 -0500
Received: by mail-wr1-f67.google.com with SMTP id i16so3446846wrs.13
        for <linux-media@vger.kernel.org>; Fri, 15 Feb 2019 12:47:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=kzyV3uWTg+zmCOLRQvO2qIJXn1S3kx+GS8OrXiXFcBE=;
        b=nkSL53m7AUcNKVAyO2kycUIhDZY6aKXP25PR5so3UN1obZbUQHKDttN+kJprniu10f
         +GRBSjgijgfsP+s060PHZJy8vYIw+E9mM1kw40PZAiAMILOifWgThgs6G3+hCmNIjGNl
         RzeKEMY9d+Dmh9zUA+Zh14sT8y74JVgDb+T3oyoJ44actABY6+AgG8J7sOTZVG1IFUa0
         kNaHVyRErsrVpnHvnYzDa31Eq+KumS/Is9onyimwGAXYxKjF/hdvXSBIF4/n+cV9Hmzh
         7Z4/vY99VmYknGCjyKDxIWjGA0/ZjOGW8JgzRtFyXl7r9WHQEpZbPchgR2EHApwZ8HyC
         ie+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=kzyV3uWTg+zmCOLRQvO2qIJXn1S3kx+GS8OrXiXFcBE=;
        b=AfC1tYxyQvG0WBydMR7UR+MlQ1ierz58/kFm9ssq5xMmE18ZoJ3nG0g8T6bIhEeOtX
         Yvka9PJYUPWc2vEEa3ucA/TgFSGh9qOArsUCz3tE0jgJ/VJmIXXWSuZCO5tSK1BrWd0u
         KE5Wo8W73k34AMEx7i5lmMCBXacs64+RcJp4R3rHYhN8fwtUDRub6wiLFn9G74vtQseI
         yqgEBmoFhNz/sesADxqr02M72aL813f/ZaN/gwWeEIQiblUVMECLUneFT5LTyWbnI4m6
         2ihnTvc6nLfacEMXtMdCX5tYq9Z+I36GHISY42pR9Nd2puJZmplPxJIsgpJzlskbEznW
         3Xfg==
X-Gm-Message-State: AHQUAua+ouGqAtJvdQkoifUYxGTW2hKDw495onLaoK2TU2o+Hl9Hml4Q
        V5JX+I/AnHZLohapWB8Q8DLkXcoG26U=
X-Google-Smtp-Source: AHgI3IYWDSKIk4YjwHdaRjfMqfMXCOjd5U/NAFdmS1YJHTOPChH4hKpbd5Q8p6rZ6bCD299uIn+TPw==
X-Received: by 2002:a5d:428b:: with SMTP id k11mr8568093wrq.17.1550263648265;
        Fri, 15 Feb 2019 12:47:28 -0800 (PST)
Received: from localhost.localdomain ([37.26.146.189])
        by smtp.gmail.com with ESMTPSA id w26sm13054227wmc.2.2019.02.15.12.47.25
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 15 Feb 2019 12:47:27 -0800 (PST)
From:   Dafna Hirschfeld <dafna3@gmail.com>
To:     linux-media@vger.kernel.org
Cc:     hverkuil@xs4all.nl, helen.koike@collabora.com,
        Dafna Hirschfeld <dafna3@gmail.com>
Subject: [PATCH] media: vicodec: Add a flag for I-frames in fwht header
Date:   Fri, 15 Feb 2019 12:47:16 -0800
Message-Id: <20190215204716.21821-1-dafna3@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Add a flag 'FWHT_FL_I_FRAME' that indicates that
this is an I-frame. This requires incrementing
to version 3

Signed-off-by: Dafna Hirschfeld <dafna3@gmail.com>
---
 drivers/media/platform/vicodec/codec-fwht.h      | 3 ++-
 drivers/media/platform/vicodec/codec-v4l2-fwht.c | 2 +-
 drivers/media/platform/vicodec/vicodec-core.c    | 4 ++--
 3 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/media/platform/vicodec/codec-fwht.h b/drivers/media/platform/vicodec/codec-fwht.h
index 60d71d9dacb3..c410512d47c5 100644
--- a/drivers/media/platform/vicodec/codec-fwht.h
+++ b/drivers/media/platform/vicodec/codec-fwht.h
@@ -56,7 +56,7 @@
 #define FWHT_MAGIC1 0x4f4f4f4f
 #define FWHT_MAGIC2 0xffffffff
 
-#define FWHT_VERSION 2
+#define FWHT_VERSION 3
 
 /* Set if this is an interlaced format */
 #define FWHT_FL_IS_INTERLACED		BIT(0)
@@ -76,6 +76,7 @@
 #define FWHT_FL_CHROMA_FULL_HEIGHT	BIT(7)
 #define FWHT_FL_CHROMA_FULL_WIDTH	BIT(8)
 #define FWHT_FL_ALPHA_IS_UNCOMPRESSED	BIT(9)
+#define FWHT_FL_I_FRAME			BIT(10)
 
 /* A 4-values flag - the number of components - 1 */
 #define FWHT_FL_COMPONENTS_NUM_MSK	GENMASK(18, 16)
diff --git a/drivers/media/platform/vicodec/codec-v4l2-fwht.c b/drivers/media/platform/vicodec/codec-v4l2-fwht.c
index c15034849133..93be8acabdb4 100644
--- a/drivers/media/platform/vicodec/codec-v4l2-fwht.c
+++ b/drivers/media/platform/vicodec/codec-v4l2-fwht.c
@@ -265,7 +265,7 @@ int v4l2_fwht_decode(struct v4l2_fwht_state *state, u8 *p_in, u8 *p_out)
 
 	flags = ntohl(state->header.flags);
 
-	if (version == FWHT_VERSION) {
+	if (version >= 2) {
 		if ((flags & FWHT_FL_PIXENC_MSK) != info->pixenc)
 			return -EINVAL;
 		components_num = 1 + ((flags & FWHT_FL_COMPONENTS_NUM_MSK) >>
diff --git a/drivers/media/platform/vicodec/vicodec-core.c b/drivers/media/platform/vicodec/vicodec-core.c
index 9d739ea5542d..d7636fe9e174 100644
--- a/drivers/media/platform/vicodec/vicodec-core.c
+++ b/drivers/media/platform/vicodec/vicodec-core.c
@@ -339,7 +339,7 @@ info_from_header(const struct fwht_cframe_hdr *p_hdr)
 	unsigned int pixenc = 0;
 	unsigned int version = ntohl(p_hdr->version);
 
-	if (version == FWHT_VERSION) {
+	if (version >= 2) {
 		components_num = 1 + ((flags & FWHT_FL_COMPONENTS_NUM_MSK) >>
 				FWHT_FL_COMPONENTS_NUM_OFFSET);
 		pixenc = (flags & FWHT_FL_PIXENC_MSK);
@@ -362,7 +362,7 @@ static bool is_header_valid(const struct fwht_cframe_hdr *p_hdr)
 	if (w < MIN_WIDTH || w > MAX_WIDTH || h < MIN_HEIGHT || h > MAX_HEIGHT)
 		return false;
 
-	if (version == FWHT_VERSION) {
+	if (version >= 2) {
 		unsigned int components_num = 1 +
 			((flags & FWHT_FL_COMPONENTS_NUM_MSK) >>
 			FWHT_FL_COMPONENTS_NUM_OFFSET);
-- 
2.17.1

