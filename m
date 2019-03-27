Return-Path: <SRS0=UobA=R6=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 845A4C43381
	for <linux-media@archiver.kernel.org>; Wed, 27 Mar 2019 18:23:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 56C2A21855
	for <linux-media@archiver.kernel.org>; Wed, 27 Mar 2019 18:23:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1553710991;
	bh=eZsqNRtN7AcSby9VLPWL4CoNCTpAnqwEXDqEMG50gLg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=iQU9Ls/90kjxT+wvIG3g/odjMNhXG9hier4mJUcWDGrV4tkE/z1/zAzYTtkqskGHp
	 nCM0ig7ABgcaS0+6XQ4kxNeyKOlwwkIlWnt6yVkhOlMrfiz14Q0l56bt35vZsdVsAk
	 jz/4FXfpe9JdTfEgXektqozMPqH898hJuBTDLn4c=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391414AbfC0SXG (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Wed, 27 Mar 2019 14:23:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:41340 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391407AbfC0SXF (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 27 Mar 2019 14:23:05 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AF8072147C;
        Wed, 27 Mar 2019 18:23:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1553710984;
        bh=eZsqNRtN7AcSby9VLPWL4CoNCTpAnqwEXDqEMG50gLg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=orfspIClEptIN4qQvx78xLCX1ss07gokJlj5ojPxcWnODemwzARFfuz1D6+RIf8EV
         gs2u1ZthJu0RelugC2Ixmjgs6YfjEIih1v4p/7l7sftZjCgpixx56GPRVQGMplfFZp
         9jOaqNRUhwVIn4TZd2TbvKJgd8BJgxzLOrStDfZs=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Pawe? Chmiel <pawel.mikolaj.chmiel@gmail.com>,
        Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        Sasha Levin <sashal@kernel.org>,
        linux-arm-kernel@lists.infradead.org, linux-media@vger.kernel.org
Subject: [PATCH AUTOSEL 4.9 78/87] media: s5p-jpeg: Check for fmt_ver_flag when doing fmt enumeration
Date:   Wed, 27 Mar 2019 14:20:31 -0400
Message-Id: <20190327182040.17444-78-sashal@kernel.org>
X-Mailer: git-send-email 2.19.1
In-Reply-To: <20190327182040.17444-1-sashal@kernel.org>
References: <20190327182040.17444-1-sashal@kernel.org>
MIME-Version: 1.0
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

From: Pawe? Chmiel <pawel.mikolaj.chmiel@gmail.com>

[ Upstream commit 49710c32cd9d6626a77c9f5f978a5f58cb536b35 ]

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

Signed-off-by: Pawe? Chmiel <pawel.mikolaj.chmiel@gmail.com>
Reviewed-by: Jacek Anaszewski <jacek.anaszewski@gmail.com>
[hverkuil-cisco@xs4all.nl: fix a few alignment issues]
Signed-off-by: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/platform/s5p-jpeg/jpeg-core.c | 19 +++++++++++--------
 1 file changed, 11 insertions(+), 8 deletions(-)

diff --git a/drivers/media/platform/s5p-jpeg/jpeg-core.c b/drivers/media/platform/s5p-jpeg/jpeg-core.c
index 06e2b72d07ca..c89922fb42ce 100644
--- a/drivers/media/platform/s5p-jpeg/jpeg-core.c
+++ b/drivers/media/platform/s5p-jpeg/jpeg-core.c
@@ -1264,13 +1264,16 @@ static int s5p_jpeg_querycap(struct file *file, void *priv,
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
+		    sjpeg_formats[i].flags & fmt_ver_flag) {
 			/* index-th format of type type found ? */
 			if (num == f->index)
 				break;
@@ -1297,11 +1300,11 @@ static int s5p_jpeg_enum_fmt_vid_cap(struct file *file, void *priv,
 	struct s5p_jpeg_ctx *ctx = fh_to_ctx(priv);
 
 	if (ctx->mode == S5P_JPEG_ENCODE)
-		return enum_fmt(sjpeg_formats, SJPEG_NUM_FORMATS, f,
+		return enum_fmt(ctx, sjpeg_formats, SJPEG_NUM_FORMATS, f,
 				SJPEG_FMT_FLAG_ENC_CAPTURE);
 
-	return enum_fmt(sjpeg_formats, SJPEG_NUM_FORMATS, f,
-					SJPEG_FMT_FLAG_DEC_CAPTURE);
+	return enum_fmt(ctx, sjpeg_formats, SJPEG_NUM_FORMATS, f,
+			SJPEG_FMT_FLAG_DEC_CAPTURE);
 }
 
 static int s5p_jpeg_enum_fmt_vid_out(struct file *file, void *priv,
@@ -1310,11 +1313,11 @@ static int s5p_jpeg_enum_fmt_vid_out(struct file *file, void *priv,
 	struct s5p_jpeg_ctx *ctx = fh_to_ctx(priv);
 
 	if (ctx->mode == S5P_JPEG_ENCODE)
-		return enum_fmt(sjpeg_formats, SJPEG_NUM_FORMATS, f,
+		return enum_fmt(ctx, sjpeg_formats, SJPEG_NUM_FORMATS, f,
 				SJPEG_FMT_FLAG_ENC_OUTPUT);
 
-	return enum_fmt(sjpeg_formats, SJPEG_NUM_FORMATS, f,
-					SJPEG_FMT_FLAG_DEC_OUTPUT);
+	return enum_fmt(ctx, sjpeg_formats, SJPEG_NUM_FORMATS, f,
+			SJPEG_FMT_FLAG_DEC_OUTPUT);
 }
 
 static struct s5p_jpeg_q_data *get_q_data(struct s5p_jpeg_ctx *ctx,
-- 
2.19.1

