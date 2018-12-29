Return-Path: <SRS0=xT8T=PG=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DC445C43387
	for <linux-media@archiver.kernel.org>; Sat, 29 Dec 2018 17:07:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id AAA1A2145D
	for <linux-media@archiver.kernel.org>; Sat, 29 Dec 2018 17:07:59 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="qtjOOwKc"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727545AbeL2RH7 (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Sat, 29 Dec 2018 12:07:59 -0500
Received: from mail-pg1-f196.google.com ([209.85.215.196]:44950 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727530AbeL2RH6 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 29 Dec 2018 12:07:58 -0500
Received: by mail-pg1-f196.google.com with SMTP id t13so11233006pgr.11
        for <linux-media@vger.kernel.org>; Sat, 29 Dec 2018 09:07:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=jNsxWjc3RCpR0fM6DE6EOaHiHD9ZdrtINc39zi3t07M=;
        b=qtjOOwKcGtUTa4+2uSPQdZGYLhhInsVCDsN7WPXxky0QCO+zxlivyq0mK3QblqRvDF
         UTYZfsDk9/nEfFkDtBDL+2X9QPTlH2/HHciQ6zHCv9hwe16wrpqwEaHND//pBrQRK4JF
         jnS2Fte1PTAnw+4nRpGHsuw5ADFjAzCpRx3tXgggJsjqunBktsnbPI4FAnvLPup26zMK
         VBQzPvo4BQP7mg+bpYvl85vKVk94Lqn5t6oIA1BAOAQzBJQubzvRmAWspa96nKD9wE1k
         jzcAg1DeH3EtcsMb5kHv+b1MrMHWgDgfBERJ0YpIGhWRxkAh20au6AwwbVDctKN8rG3R
         YgpA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=jNsxWjc3RCpR0fM6DE6EOaHiHD9ZdrtINc39zi3t07M=;
        b=jLCao511afWywZaxLBt4F0q4ZezI5bDPqUTRg/MpakiVcvoSGFNAv2LZ2YI8tOLG3M
         1eakzXKK5u2QP9CPdg10Jqs3dWJ6P4qke5UBfmtRfZKL7mwRkJ0LbZUVGgo39772Fe20
         F0Dxw4kwG5gNo8SIHp/oUagYyBJQ7ZL/3Pys6xe7wemw+FgjIvR/sxufrfbqNxcIbh0y
         ATWwM8AtbW/xokzOmJMwygMiGwhqXBmsCpkuHVCaLjv1OCyp98it3HjxDhldmg48aT0k
         K0hR52dHk2CHssOKtQepAK0AOOKxK8xHNawE/GcZHTsSLw/vMWUwrwzyRKt0e7qpwN3L
         TuDQ==
X-Gm-Message-State: AJcUukche6xCQD2TUv0EDTjMtZVcv1gYeOLr0CXaekKJRXal6bQ9J61w
        BaL8i9tEIi+uWeOz14ojbW8I+Xq1My8=
X-Google-Smtp-Source: ALg8bN5tYM1oKAUbZxtNV/JcEX519UFqt6DxIwrhWM2NIOBb3mLcI9yDjKzCAxsCapBvMm8FhJvExw==
X-Received: by 2002:a65:484c:: with SMTP id i12mr2177034pgs.309.1546103277840;
        Sat, 29 Dec 2018 09:07:57 -0800 (PST)
Received: from localhost.localdomain ([240f:34:212d:1:d91e:35b2:75a8:1394])
        by smtp.gmail.com with ESMTPSA id h134sm86856276pfe.27.2018.12.29.09.07.55
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Sat, 29 Dec 2018 09:07:57 -0800 (PST)
From:   Akinobu Mita <akinobu.mita@gmail.com>
To:     linux-media@vger.kernel.org
Cc:     Akinobu Mita <akinobu.mita@gmail.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
Subject: [PATCH 3/4] media: mt9m111: set all mbus format field when G_FMT and S_FMT ioctls
Date:   Sun, 30 Dec 2018 02:07:37 +0900
Message-Id: <1546103258-29025-4-git-send-email-akinobu.mita@gmail.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1546103258-29025-1-git-send-email-akinobu.mita@gmail.com>
References: <1546103258-29025-1-git-send-email-akinobu.mita@gmail.com>
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

This driver doesn't set all members of mbus format field when the
VIDIOC_SUBDEV_{S,G}_FMT ioctls are called.

This is detected by v4l2-compliance.

Cc: Sakari Ailus <sakari.ailus@linux.intel.com>
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>
Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
---
 drivers/media/i2c/mt9m111.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/media/i2c/mt9m111.c b/drivers/media/i2c/mt9m111.c
index acb4dee..465e920 100644
--- a/drivers/media/i2c/mt9m111.c
+++ b/drivers/media/i2c/mt9m111.c
@@ -543,6 +543,9 @@ static int mt9m111_get_fmt(struct v4l2_subdev *sd,
 	mf->code	= mt9m111->fmt->code;
 	mf->colorspace	= mt9m111->fmt->colorspace;
 	mf->field	= V4L2_FIELD_NONE;
+	mf->ycbcr_enc	= V4L2_YCBCR_ENC_DEFAULT;
+	mf->quantization	= V4L2_QUANTIZATION_DEFAULT;
+	mf->xfer_func	= V4L2_XFER_FUNC_DEFAULT;
 
 	return 0;
 }
@@ -671,6 +674,10 @@ static int mt9m111_set_fmt(struct v4l2_subdev *sd,
 
 	mf->code = fmt->code;
 	mf->colorspace = fmt->colorspace;
+	mf->field	= V4L2_FIELD_NONE;
+	mf->ycbcr_enc	= V4L2_YCBCR_ENC_DEFAULT;
+	mf->quantization	= V4L2_QUANTIZATION_DEFAULT;
+	mf->xfer_func	= V4L2_XFER_FUNC_DEFAULT;
 
 	if (format->which == V4L2_SUBDEV_FORMAT_TRY) {
 		cfg->try_fmt = *mf;
-- 
2.7.4

