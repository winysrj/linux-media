Return-Path: <SRS0=Ztfs=PX=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 42B58C43387
	for <linux-media@archiver.kernel.org>; Tue, 15 Jan 2019 14:06:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 12F8D20657
	for <linux-media@archiver.kernel.org>; Tue, 15 Jan 2019 14:06:01 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="bteNh1FE"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730301AbfAOOGA (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Tue, 15 Jan 2019 09:06:00 -0500
Received: from mail-pl1-f193.google.com ([209.85.214.193]:46031 "EHLO
        mail-pl1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727060AbfAOOGA (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 15 Jan 2019 09:06:00 -0500
Received: by mail-pl1-f193.google.com with SMTP id a14so1326358plm.12
        for <linux-media@vger.kernel.org>; Tue, 15 Jan 2019 06:06:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=IzcF86yc78ULv0eXIurT6kXm2dhNFldic57uuQGeChI=;
        b=bteNh1FEktTDscZpycTLdCdSCBL2ETQbL1TLHHjBvVKJSwN4q4/WdeVHiuetXCiSq2
         fOur7QHcuotvHo89Q0iT1A8PTghU6RFDark59oqfxRlNRl79R5+h2Pxzh8JUOguXMTDB
         7YlDW+DDUqMwjZIIp3TDR6IaX8tbksbbNL9wjB6QtFyUqP/6PqWvAHPeNRAmWi3l96Gt
         wsCSUB/ycAyoXGDRVE3p4pM0SJ+uoVqHGcATW9OpK4kizSccGtWUVH7blX92UzXfhuPy
         Imhk/xCZQMNRkH0sYn5tLlfALIYW61ZsKfYc/25P5+/KCXWV7ZLIznzZ0L/q1vZ/vu2x
         Z7Uw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=IzcF86yc78ULv0eXIurT6kXm2dhNFldic57uuQGeChI=;
        b=Zp7aFMMp90EieabeRuEm5NA8VeEHhnxM1P4OZio7++VqLKqZm4t8US2YVg1a+PMH+1
         4suWZp4MsKTnSxy8Cqi+FNq33ASpzr6yIH+I0YMFEKfRRJWKPR/2LcgV/LXRB1eFeIfE
         dyi7OSgtw+1ZT5meQ0ENbDUdZxi0JF1eeqa/Xyjv5/CEhsA15MYs2vRYo0bJYF8wUT1L
         ibGDIgbK1vKjMbOan2icRJMB8tbwV5J3E5nftZwVx7vO16nvBhFTbLWBQGRr8R0Ua6ia
         CwKk5lp/Aj/OhTK19yu4psqaxY52sYChGG44un8vxF0hmm91YuDwWmPHPm81wmLorvGY
         FlGQ==
X-Gm-Message-State: AJcUukcM4tUTEQ/kXLBtcdEK3U4aO1mrGZ2YqwbFkzFFY7FxxEfMFCXY
        7N97hXDiGdkjOebt6guhTkDWEUPT
X-Google-Smtp-Source: ALg8bN4LphkEuY/NQu6cyHwUZTyXLKBhnGsk/J1gD2LbnEO1ns0FvWqelalhTCF+/fO78WwUrM6bxw==
X-Received: by 2002:a17:902:7d90:: with SMTP id a16mr4136787plm.249.1547561159620;
        Tue, 15 Jan 2019 06:05:59 -0800 (PST)
Received: from localhost.localdomain ([240f:34:212d:1:5894:91d7:f206:dece])
        by smtp.gmail.com with ESMTPSA id c72sm5394125pfb.107.2019.01.15.06.05.57
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Tue, 15 Jan 2019 06:05:59 -0800 (PST)
From:   Akinobu Mita <akinobu.mita@gmail.com>
To:     linux-media@vger.kernel.org
Cc:     Akinobu Mita <akinobu.mita@gmail.com>,
        Enrico Scholz <enrico.scholz@sigma-chemnitz.de>,
        Michael Grzeschik <m.grzeschik@pengutronix.de>,
        Marco Felsch <m.felsch@pengutronix.de>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
Subject: [PATCH v3 2/3] media: mt9m111: set all mbus format field when G_FMT and S_FMT ioctls
Date:   Tue, 15 Jan 2019 23:05:40 +0900
Message-Id: <1547561141-13504-3-git-send-email-akinobu.mita@gmail.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1547561141-13504-1-git-send-email-akinobu.mita@gmail.com>
References: <1547561141-13504-1-git-send-email-akinobu.mita@gmail.com>
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

This driver doesn't set all members of mbus format field when the
VIDIOC_SUBDEV_{S,G}_FMT ioctls are called.

This is detected by v4l2-compliance.

Cc: Enrico Scholz <enrico.scholz@sigma-chemnitz.de>
Cc: Michael Grzeschik <m.grzeschik@pengutronix.de>
Cc: Marco Felsch <m.felsch@pengutronix.de>
Cc: Sakari Ailus <sakari.ailus@linux.intel.com>
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>
Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
---
* No changes from v2

 drivers/media/i2c/mt9m111.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/media/i2c/mt9m111.c b/drivers/media/i2c/mt9m111.c
index 63a5253..9c92eca 100644
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
@@ -670,6 +673,10 @@ static int mt9m111_set_fmt(struct v4l2_subdev *sd,
 
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

