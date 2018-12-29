Return-Path: <SRS0=xT8T=PG=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AC0D0C43387
	for <linux-media@archiver.kernel.org>; Sat, 29 Dec 2018 15:46:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7BD6F2145D
	for <linux-media@archiver.kernel.org>; Sat, 29 Dec 2018 15:46:20 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="FHh3A4fr"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727090AbeL2PqO (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Sat, 29 Dec 2018 10:46:14 -0500
Received: from mail-lf1-f68.google.com ([209.85.167.68]:33043 "EHLO
        mail-lf1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726910AbeL2PqO (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 29 Dec 2018 10:46:14 -0500
Received: by mail-lf1-f68.google.com with SMTP id i26so16228909lfc.0;
        Sat, 29 Dec 2018 07:46:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=HJ2D6S+BDoyT03ZFRm8ignD7WKbmeioqnKEpSljjok8=;
        b=FHh3A4frWZa9R5ZnhGNKmr+YDMPmuGTRRHei39/mQ11mNUSL3H0I0EE6w/ZIQAWcii
         Q0wAbv9SwgcHvnYBDORQ9xW7CYdKE6eSm1x0C2k6/EBgPw7OcjUwI2A520e0XK2NZSRg
         uk5Hy+/N8iJOCYa/Fw3br9EBCW8JSiT+0qgcI9HDt0DaOQfG5B+jXgTM+cSsC7/+obi4
         Xx+8vXEyZAQZEEe+yvq5WqhenrY5CdWBR4DgTZQPlB7iTBDcMJQg/a6mN8WXC0TTG1V9
         h3PTcdLSUOzfjr+Li/k5eJr97dxjFk0BH31rcw+Dq/Vh50xrCTu3pGdnB8kx6rwyJxz6
         ZWhg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=HJ2D6S+BDoyT03ZFRm8ignD7WKbmeioqnKEpSljjok8=;
        b=adql6/8WXj2+pwqWy8fjzWVlDIXjyIs3y1hyCO0hJ9GzVYKIGFEhCUyolClJJJ4lz2
         DO9SUrpGN766+F3Vfz/qhMI5LHuOAtq8WChencrkWW9NEXT2fOW7A9bW/S2NOSDoMUS4
         7UKEwUau+cpUE+0WyXlKRFifslGtSLdK2zhgWDvUZsfUNok1LFBpTDQYXhjxuXF+qgRr
         okWaoEkQpFiOQIznx5t8vb6x8XLM2RQ0m6HnpjZiZyyCWjba5afzEUzYTU+g2khJ4onU
         WeRwhFfvT+9BfNYurGELZl8yd8pTjJ0ec1Za6kv+EoAUEiM0CzUtv0Z3LuXvJwK7HJxJ
         LyUg==
X-Gm-Message-State: AA+aEWYf+s3BWuQWHFf/9jL5TtH+8LPyrRqZqZWzOlXxZup28gWuU2f3
        tBdMg/rDYp/p0XUgQnEmhEQ=
X-Google-Smtp-Source: AFSGD/WXaxorWkt/A8rmcraHPQ/UJpJ10nGCFUq8X/6Uvvj4axZdkmEjvuPZ6N8fDU5IkDOfVxOcaA==
X-Received: by 2002:a19:200b:: with SMTP id g11mr15577555lfg.58.1546098372092;
        Sat, 29 Dec 2018 07:46:12 -0800 (PST)
Received: from localhost.localdomain ([2a02:a315:5445:5300:59d9:2ac4:8755:7a21])
        by smtp.googlemail.com with ESMTPSA id d19-v6sm9106105ljc.37.2018.12.29.07.46.10
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 29 Dec 2018 07:46:11 -0800 (PST)
From:   =?UTF-8?q?Pawe=C5=82=20Chmiel?= <pawel.mikolaj.chmiel@gmail.com>
To:     andrzej.p@samsung.com
Cc:     jacek.anaszewski@gmail.com, mchehab@kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        =?UTF-8?q?Pawe=C5=82=20Chmiel?= <pawel.mikolaj.chmiel@gmail.com>
Subject: [PATCH] media: s5p-jpeg: Check for fmt_ver_flag when doing fmt enumeration
Date:   Sat, 29 Dec 2018 16:46:01 +0100
Message-Id: <20181229154602.25693-1-pawel.mikolaj.chmiel@gmail.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Previously when doing format enumeration, it was returning all
 formats supported by driver, even if they're not supported by hw.
Add missing check for fmt_ver_flag, so it'll be fixed and only those
 supported by hw will be returned. Similar thing is already done
 in s5p_jpeg_find_format.

It was found by using v4l2-compliance tool and checking result
 of VIDIOC_ENUM_FMT/FRAMESIZES/FRAMEINTERVALS test
and using v4l2-ctl to get list of all supported formats.

Tested on s5pv210-galaxys (Samsung i9000 phone).

Fixes: bb677f3ac434 ("[media] Exynos4 JPEG codec v4l2 driver")
Signed-off-by: Paweł Chmiel <pawel.mikolaj.chmiel@gmail.com>
---
 drivers/media/platform/s5p-jpeg/jpeg-core.c | 15 +++++++++------
 1 file changed, 9 insertions(+), 6 deletions(-)

diff --git a/drivers/media/platform/s5p-jpeg/jpeg-core.c b/drivers/media/platform/s5p-jpeg/jpeg-core.c
index 3f9000b70385..232b75cf209f 100644
--- a/drivers/media/platform/s5p-jpeg/jpeg-core.c
+++ b/drivers/media/platform/s5p-jpeg/jpeg-core.c
@@ -1293,13 +1293,16 @@ static int s5p_jpeg_querycap(struct file *file, void *priv,
 	return 0;
 }
 
-static int enum_fmt(struct s5p_jpeg_fmt *sjpeg_formats, int n,
+static int enum_fmt(struct s5p_jpeg_ctx *ctx,
+		    struct s5p_jpeg_fmt *sjpeg_formats, int n,
 		    struct v4l2_fmtdesc *f, u32 type)
 {
 	int i, num = 0;
+	unsigned int fmt_ver_flag = ctx->jpeg->variant->fmt_ver_flag;
 
 	for (i = 0; i < n; ++i) {
-		if (sjpeg_formats[i].flags & type) {
+		if (sjpeg_formats[i].flags & type &&
+			sjpeg_formats[i].flags & fmt_ver_flag) {
 			/* index-th format of type type found ? */
 			if (num == f->index)
 				break;
@@ -1326,10 +1329,10 @@ static int s5p_jpeg_enum_fmt_vid_cap(struct file *file, void *priv,
 	struct s5p_jpeg_ctx *ctx = fh_to_ctx(priv);
 
 	if (ctx->mode == S5P_JPEG_ENCODE)
-		return enum_fmt(sjpeg_formats, SJPEG_NUM_FORMATS, f,
+		return enum_fmt(ctx, sjpeg_formats, SJPEG_NUM_FORMATS, f,
 				SJPEG_FMT_FLAG_ENC_CAPTURE);
 
-	return enum_fmt(sjpeg_formats, SJPEG_NUM_FORMATS, f,
+	return enum_fmt(ctx, sjpeg_formats, SJPEG_NUM_FORMATS, f,
 					SJPEG_FMT_FLAG_DEC_CAPTURE);
 }
 
@@ -1339,10 +1342,10 @@ static int s5p_jpeg_enum_fmt_vid_out(struct file *file, void *priv,
 	struct s5p_jpeg_ctx *ctx = fh_to_ctx(priv);
 
 	if (ctx->mode == S5P_JPEG_ENCODE)
-		return enum_fmt(sjpeg_formats, SJPEG_NUM_FORMATS, f,
+		return enum_fmt(ctx, sjpeg_formats, SJPEG_NUM_FORMATS, f,
 				SJPEG_FMT_FLAG_ENC_OUTPUT);
 
-	return enum_fmt(sjpeg_formats, SJPEG_NUM_FORMATS, f,
+	return enum_fmt(ctx, sjpeg_formats, SJPEG_NUM_FORMATS, f,
 					SJPEG_FMT_FLAG_DEC_OUTPUT);
 }
 
-- 
2.17.1

