Return-Path: <SRS0=xT8T=PG=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4476AC43387
	for <linux-media@archiver.kernel.org>; Sat, 29 Dec 2018 15:53:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id F3E332145D
	for <linux-media@archiver.kernel.org>; Sat, 29 Dec 2018 15:53:00 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Mqx81s15"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726933AbeL2PxA (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Sat, 29 Dec 2018 10:53:00 -0500
Received: from mail-wm1-f66.google.com ([209.85.128.66]:50713 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725862AbeL2Pw7 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 29 Dec 2018 10:52:59 -0500
Received: by mail-wm1-f66.google.com with SMTP id n190so20908445wmd.0
        for <linux-media@vger.kernel.org>; Sat, 29 Dec 2018 07:52:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=PUyNJU5EeGPVPl/xZPMJeaKXVQDQPLqDAK2F+Uzqreg=;
        b=Mqx81s15u4w4wap1382IaAYmsmk8UwuavEQQwuAJIr0gesThYUjrjz/25Fck57aMpH
         4CtI4+tx4aKJMZJAA2tYhV4EvaJ8AT7ru75jWLl7VImgSrg4H3XT+APKBAjiqs516u8K
         Kc6eGm9xwPrhMICtvsd6gCpTE7buscPmdpKLIv9Z6/NlA43hIU8ta3AnNUMsbJToWuKV
         AQKr0BgFbquJ+XOhD5ek34PJGlhhExkNOOGOcOY8HeVZ6c5UlJ5W6hKz68H6kjkueEkB
         e2ybXRyKI3vAIT7i7p97+OyQss7XmPOiY1SybGVTa4Jm4wrZstXbX2m+YL2S35C9Zi8N
         6dJg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=PUyNJU5EeGPVPl/xZPMJeaKXVQDQPLqDAK2F+Uzqreg=;
        b=li8rP5nyCxofpKlg+acq/1j1fAsMz1juSoEfxP+F4Ux3w0M7w8+EIYho4xm9XSVcLn
         6JlArrBp9wXX50w/UuaqxrCk1caJ2g5yl5sTZqOKUTwfSV8H0Q0CCc4fTX09zLUjBl+1
         kMKibAbi4J+xOCpCuTBXd3RbPQFyTLHiFM/kEdGQ4JXcKZafwmXW5xLy4MgK+HWyEFun
         6dmkIBuqHF3Cf57ZiqWxldfYAZ7S+tN3p7OgJa4bop6sKJxcb6+PK1TQcSi7NNrG+cdF
         uGyJ2SGQeG/XoR5jejjI3AUhBjHcxN7xHyle7uMybK8/l6s2RlJBrPMO/OGCEh3SEK8f
         nhjg==
X-Gm-Message-State: AJcUukctVUyPmXagCBQL2nb2ssEbSyqLOMd491okSwxq1u4ftx4w9ViR
        TTs++YEpNTjA5a+EdhbnBURtFrDWDfQ=
X-Google-Smtp-Source: ALg8bN61dQHmYyZbgOlGmqAdN6luiAE/WkALcMNCm95h/3/q995Vf79LeuczYBVA47q7PJ/+jaqIdw==
X-Received: by 2002:a1c:c008:: with SMTP id q8mr24708984wmf.99.1546098776664;
        Sat, 29 Dec 2018 07:52:56 -0800 (PST)
Received: from localhost.localdomain ([87.71.118.243])
        by smtp.gmail.com with ESMTPSA id k128sm38737423wmd.37.2018.12.29.07.52.55
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 29 Dec 2018 07:52:56 -0800 (PST)
From:   Dafna Hirschfeld <dafna3@gmail.com>
To:     linux-media@vger.kernel.org
Cc:     hverkuil@xs4all.nl, helen.koike@collabora.com,
        Dafna Hirschfeld <dafna3@gmail.com>
Subject: [PATCH] media: vicodec: Add num_planes field to v4l2_fwht_pixfmt_info
Date:   Sat, 29 Dec 2018 07:52:18 -0800
Message-Id: <20181229155218.26875-1-dafna3@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Add the field 'num_planes' to 'v4l2_fwht_pixfmt_info' struct.

Signed-off-by: Dafna Hirschfeld <dafna3@gmail.com>
---
 .../media/platform/vicodec/codec-v4l2-fwht.c  | 48 +++++++++----------
 .../media/platform/vicodec/codec-v4l2-fwht.h  |  1 +
 drivers/media/platform/vicodec/vicodec-core.c |  2 +-
 3 files changed, 26 insertions(+), 25 deletions(-)

diff --git a/drivers/media/platform/vicodec/codec-v4l2-fwht.c b/drivers/media/platform/vicodec/codec-v4l2-fwht.c
index 19f9d65fc0a9..0e4797e47018 100644
--- a/drivers/media/platform/vicodec/codec-v4l2-fwht.c
+++ b/drivers/media/platform/vicodec/codec-v4l2-fwht.c
@@ -11,30 +11,30 @@
 #include "codec-v4l2-fwht.h"
 
 static const struct v4l2_fwht_pixfmt_info v4l2_fwht_pixfmts[] = {
-	{ V4L2_PIX_FMT_YUV420,  1, 3, 2, 1, 1, 2, 2, 3},
-	{ V4L2_PIX_FMT_YVU420,  1, 3, 2, 1, 1, 2, 2, 3},
-	{ V4L2_PIX_FMT_YUV422P, 1, 2, 1, 1, 1, 2, 1, 3},
-	{ V4L2_PIX_FMT_NV12,    1, 3, 2, 1, 2, 2, 2, 3},
-	{ V4L2_PIX_FMT_NV21,    1, 3, 2, 1, 2, 2, 2, 3},
-	{ V4L2_PIX_FMT_NV16,    1, 2, 1, 1, 2, 2, 1, 3},
-	{ V4L2_PIX_FMT_NV61,    1, 2, 1, 1, 2, 2, 1, 3},
-	{ V4L2_PIX_FMT_NV24,    1, 3, 1, 1, 2, 1, 1, 3},
-	{ V4L2_PIX_FMT_NV42,    1, 3, 1, 1, 2, 1, 1, 3},
-	{ V4L2_PIX_FMT_YUYV,    2, 2, 1, 2, 4, 2, 1, 3},
-	{ V4L2_PIX_FMT_YVYU,    2, 2, 1, 2, 4, 2, 1, 3},
-	{ V4L2_PIX_FMT_UYVY,    2, 2, 1, 2, 4, 2, 1, 3},
-	{ V4L2_PIX_FMT_VYUY,    2, 2, 1, 2, 4, 2, 1, 3},
-	{ V4L2_PIX_FMT_BGR24,   3, 3, 1, 3, 3, 1, 1, 3},
-	{ V4L2_PIX_FMT_RGB24,   3, 3, 1, 3, 3, 1, 1, 3},
-	{ V4L2_PIX_FMT_HSV24,   3, 3, 1, 3, 3, 1, 1, 3},
-	{ V4L2_PIX_FMT_BGR32,   4, 4, 1, 4, 4, 1, 1, 3},
-	{ V4L2_PIX_FMT_XBGR32,  4, 4, 1, 4, 4, 1, 1, 3},
-	{ V4L2_PIX_FMT_RGB32,   4, 4, 1, 4, 4, 1, 1, 3},
-	{ V4L2_PIX_FMT_XRGB32,  4, 4, 1, 4, 4, 1, 1, 3},
-	{ V4L2_PIX_FMT_HSV32,   4, 4, 1, 4, 4, 1, 1, 3},
-	{ V4L2_PIX_FMT_ARGB32,  4, 4, 1, 4, 4, 1, 1, 4},
-	{ V4L2_PIX_FMT_ABGR32,  4, 4, 1, 4, 4, 1, 1, 4},
-	{ V4L2_PIX_FMT_GREY,    1, 1, 1, 1, 0, 1, 1, 1},
+	{ V4L2_PIX_FMT_YUV420,  1, 3, 2, 1, 1, 2, 2, 3, 3},
+	{ V4L2_PIX_FMT_YVU420,  1, 3, 2, 1, 1, 2, 2, 3, 3},
+	{ V4L2_PIX_FMT_YUV422P, 1, 2, 1, 1, 1, 2, 1, 3, 3},
+	{ V4L2_PIX_FMT_NV12,    1, 3, 2, 1, 2, 2, 2, 3, 2},
+	{ V4L2_PIX_FMT_NV21,    1, 3, 2, 1, 2, 2, 2, 3, 2},
+	{ V4L2_PIX_FMT_NV16,    1, 2, 1, 1, 2, 2, 1, 3, 2},
+	{ V4L2_PIX_FMT_NV61,    1, 2, 1, 1, 2, 2, 1, 3, 2},
+	{ V4L2_PIX_FMT_NV24,    1, 3, 1, 1, 2, 1, 1, 3, 2},
+	{ V4L2_PIX_FMT_NV42,    1, 3, 1, 1, 2, 1, 1, 3, 2},
+	{ V4L2_PIX_FMT_YUYV,    2, 2, 1, 2, 4, 2, 1, 3, 1},
+	{ V4L2_PIX_FMT_YVYU,    2, 2, 1, 2, 4, 2, 1, 3, 1},
+	{ V4L2_PIX_FMT_UYVY,    2, 2, 1, 2, 4, 2, 1, 3, 1},
+	{ V4L2_PIX_FMT_VYUY,    2, 2, 1, 2, 4, 2, 1, 3, 1},
+	{ V4L2_PIX_FMT_BGR24,   3, 3, 1, 3, 3, 1, 1, 3, 1},
+	{ V4L2_PIX_FMT_RGB24,   3, 3, 1, 3, 3, 1, 1, 3, 1},
+	{ V4L2_PIX_FMT_HSV24,   3, 3, 1, 3, 3, 1, 1, 3, 1},
+	{ V4L2_PIX_FMT_BGR32,   4, 4, 1, 4, 4, 1, 1, 3, 1},
+	{ V4L2_PIX_FMT_XBGR32,  4, 4, 1, 4, 4, 1, 1, 3, 1},
+	{ V4L2_PIX_FMT_RGB32,   4, 4, 1, 4, 4, 1, 1, 3, 1},
+	{ V4L2_PIX_FMT_XRGB32,  4, 4, 1, 4, 4, 1, 1, 3, 1},
+	{ V4L2_PIX_FMT_HSV32,   4, 4, 1, 4, 4, 1, 1, 3, 1},
+	{ V4L2_PIX_FMT_ARGB32,  4, 4, 1, 4, 4, 1, 1, 4, 1},
+	{ V4L2_PIX_FMT_ABGR32,  4, 4, 1, 4, 4, 1, 1, 4, 1},
+	{ V4L2_PIX_FMT_GREY,    1, 1, 1, 1, 0, 1, 1, 1, 1},
 };
 
 const struct v4l2_fwht_pixfmt_info *v4l2_fwht_find_pixfmt(u32 pixelformat)
diff --git a/drivers/media/platform/vicodec/codec-v4l2-fwht.h b/drivers/media/platform/vicodec/codec-v4l2-fwht.h
index 2a09ad13ddd6..1cd909111867 100644
--- a/drivers/media/platform/vicodec/codec-v4l2-fwht.h
+++ b/drivers/media/platform/vicodec/codec-v4l2-fwht.h
@@ -19,6 +19,7 @@ struct v4l2_fwht_pixfmt_info {
 	unsigned int width_div;
 	unsigned int height_div;
 	unsigned int components_num;
+	unsigned int planes_num;
 };
 
 struct v4l2_fwht_state {
diff --git a/drivers/media/platform/vicodec/vicodec-core.c b/drivers/media/platform/vicodec/vicodec-core.c
index bbcce826c440..12d1f3347e04 100644
--- a/drivers/media/platform/vicodec/vicodec-core.c
+++ b/drivers/media/platform/vicodec/vicodec-core.c
@@ -61,7 +61,7 @@ struct pixfmt_info {
 };
 
 static const struct v4l2_fwht_pixfmt_info pixfmt_fwht = {
-	V4L2_PIX_FMT_FWHT, 0, 3, 1, 1, 1, 1, 1, 0
+	V4L2_PIX_FMT_FWHT, 0, 3, 1, 1, 1, 1, 1, 0, 1
 };
 
 static void vicodec_dev_release(struct device *dev)
-- 
2.17.1

