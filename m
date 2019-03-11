Return-Path: <SRS0=G3Vt=RO=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D61EEC4360F
	for <linux-media@archiver.kernel.org>; Mon, 11 Mar 2019 15:36:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A55DF2147C
	for <linux-media@archiver.kernel.org>; Mon, 11 Mar 2019 15:36:23 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="L4GlmrnM"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727063AbfCKPgX (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Mon, 11 Mar 2019 11:36:23 -0400
Received: from mail-pf1-f194.google.com ([209.85.210.194]:42776 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726546AbfCKPgW (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 11 Mar 2019 11:36:22 -0400
Received: by mail-pf1-f194.google.com with SMTP id n74so3950265pfi.9
        for <linux-media@vger.kernel.org>; Mon, 11 Mar 2019 08:36:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=j8We34rp/0NT1UhnhDwyb+xe1pOVX9dOK6b5P0QcV2c=;
        b=L4GlmrnMoR3ofRo8xKOS9VC430WQz9Mg4KjNix93xBGuc2j4tc2feIrZ0XGoDQc6/z
         qOJWpurvj0aam+niG0pNffW1f7GATAaqydfsZ7v1PQVb3suRgRQg7hlyE/EsO2k1C/CK
         0OIENemiKOIm9DlsENQHegjknvjb96Q5BGIvwhnfSCbs/xZ/98eEtZXXgVUTEJFGnYTs
         eJ2kZNpexHTQqS7FvcELROv2glW/HysW/KR23lc+xgUPHCLfQ0n/qZ6Vu1Xxirg40Log
         17CBXPF3gFPW2o2rhxLmazdlFjDIP27t73L17M40ivIs6EAHVJBJWgpOYuF5a6K6USqF
         nliQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=j8We34rp/0NT1UhnhDwyb+xe1pOVX9dOK6b5P0QcV2c=;
        b=LwB5jCqwdQI4iQ6jDVVXBc6ib4bvSJEky0IpEN/HX1IgcX+8tr8du+IvAFrWJRPiN2
         61cB5MyL8JzipmiK74BtyF5DZr4bDFFgdXU70Nt9/8FXLGMl11DQOMrtunnPZgpVQ/3I
         guwHBnLzoaPAI9TiYSKmQss1KqK0E6xpNQJ0dBRsfzZ96MhGWdtj693j6+gEAQMQmPYo
         5uuTNe44iAU7aekjamlFs56f8jc4MgGMgJHyE4A1RFxb4xZYgXX4anWEkY3C3b8GYJLw
         ZEXp3sqwipXTQOfbgKNWbKDtgfV4oYvxn9WQDFw44awNK31+nuFfIOkGbDJdPN/dy3XU
         4pVQ==
X-Gm-Message-State: APjAAAWPR4bZ9aePlAuVp2AWEU02mEfsUPYP4DIZNHjud0hjej6UqC0X
        wt2Hu+U6jPqjBcYLZXK5qRzCzyzB
X-Google-Smtp-Source: APXvYqxJNtNC01EPg6MPX/FyxClT4WUFX18Jx9H52GLoyGuNzmgk3BzL8JgsW1WGk218jZKD/LzREA==
X-Received: by 2002:a62:b40b:: with SMTP id h11mr33401459pfn.108.1552318581719;
        Mon, 11 Mar 2019 08:36:21 -0700 (PDT)
Received: from localhost.localdomain ([240f:34:212d:1:1b24:991b:df50:ea3f])
        by smtp.gmail.com with ESMTPSA id f28sm10428364pfh.178.2019.03.11.08.36.19
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Mon, 11 Mar 2019 08:36:21 -0700 (PDT)
From:   Akinobu Mita <akinobu.mita@gmail.com>
To:     linux-media@vger.kernel.org
Cc:     Akinobu Mita <akinobu.mita@gmail.com>,
        Lubomir Rintel <lkundrak@v3.sk>,
        Jonathan Corbet <corbet@lwn.net>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
Subject: [PATCH 2/2] media: ov7670: don't access registers when the device is powered off
Date:   Tue, 12 Mar 2019 00:36:03 +0900
Message-Id: <1552318563-6685-3-git-send-email-akinobu.mita@gmail.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1552318563-6685-1-git-send-email-akinobu.mita@gmail.com>
References: <1552318563-6685-1-git-send-email-akinobu.mita@gmail.com>
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Since commit 3d6a8fe25605 ("media: ov7670: hook s_power onto v4l2 core"),
the device is actually powered off while the video stream is stopped.

So now set_format and s_frame_interval could be called while the device
is powered off, but these callbacks try to change the register settings
at this time.

The frame format and framerate will be restored right after power-up, so
we can just postpone applying these changes at these callbacks if the
device is not powered up.

Fixes: 3d6a8fe25605 ("media: ov7670: hook s_power onto v4l2 core")
Cc: Lubomir Rintel <lkundrak@v3.sk>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Sakari Ailus <sakari.ailus@linux.intel.com>
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>
Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
---
 drivers/media/i2c/ov7670.c | 31 ++++++++++++++++++++++++++-----
 1 file changed, 26 insertions(+), 5 deletions(-)

diff --git a/drivers/media/i2c/ov7670.c b/drivers/media/i2c/ov7670.c
index e65693c..44c3eed 100644
--- a/drivers/media/i2c/ov7670.c
+++ b/drivers/media/i2c/ov7670.c
@@ -864,7 +864,15 @@ static int ov7675_set_framerate(struct v4l2_subdev *sd,
 	/* Recalculate frame rate */
 	ov7675_get_framerate(sd, tpf);
 
-	return ov7675_apply_framerate(sd);
+	/*
+	 * If the device is not powered up by the host driver do
+	 * not apply any changes to H/W at this time. Instead
+	 * the framerate will be restored right after power-up.
+	 */
+	if (info->on)
+		return ov7675_apply_framerate(sd);
+
+	return 0;
 }
 
 static void ov7670_get_framerate_legacy(struct v4l2_subdev *sd,
@@ -895,7 +903,16 @@ static int ov7670_set_framerate_legacy(struct v4l2_subdev *sd,
 	info->clkrc = (info->clkrc & 0x80) | div;
 	tpf->numerator = 1;
 	tpf->denominator = info->clock_speed / div;
-	return ov7670_write(sd, REG_CLKRC, info->clkrc);
+
+	/*
+	 * If the device is not powered up by the host driver do
+	 * not apply any changes to H/W at this time. Instead
+	 * the framerate will be restored right after power-up.
+	 */
+	if (info->on)
+		return ov7670_write(sd, REG_CLKRC, info->clkrc);
+
+	return 0;
 }
 
 /*
@@ -1105,9 +1122,13 @@ static int ov7670_set_fmt(struct v4l2_subdev *sd,
 	if (ret)
 		return ret;
 
-	ret = ov7670_apply_fmt(sd);
-	if (ret)
-		return ret;
+	/*
+	 * If the device is not powered up by the host driver do
+	 * not apply any changes to H/W at this time. Instead
+	 * the frame format will be restored right after power-up.
+	 */
+	if (info->on)
+		return ov7670_apply_fmt(sd);
 
 	return 0;
 }
-- 
2.7.4

