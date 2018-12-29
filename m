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
	by smtp.lore.kernel.org (Postfix) with ESMTP id DA5AAC43387
	for <linux-media@archiver.kernel.org>; Sat, 29 Dec 2018 17:08:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A975E2145D
	for <linux-media@archiver.kernel.org>; Sat, 29 Dec 2018 17:08:01 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="NFmOUOCo"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727550AbeL2RIB (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Sat, 29 Dec 2018 12:08:01 -0500
Received: from mail-pf1-f196.google.com ([209.85.210.196]:39102 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727530AbeL2RIA (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 29 Dec 2018 12:08:00 -0500
Received: by mail-pf1-f196.google.com with SMTP id r136so11701612pfc.6
        for <linux-media@vger.kernel.org>; Sat, 29 Dec 2018 09:08:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=GsYYj9hvF53lNra8umQJWkpQxGtDlYUa8ZF1UB6gZzQ=;
        b=NFmOUOCoVajrbEBXFTLSyPw30Jz5slqdqojeN234zCUqsootlA1lk255ZO2WZh+cj/
         GdDGWF7KZWMnNvOiwHTc2BG+l2vGLAwlEMlOAAYfnMniUF22Q/XHpaoG1YJkSPtEYauC
         cfziXD1Py8Zj1N0rU7wj2gowQDvxOaskeuPrD9nN2CjktawkyM7LGUXfF1DkkAAS9Oru
         J+vrtMRr0O6UdERBR3KxBydlUvcMOrbbr9DgV2v5HLf2R8nRjiYNNKu12yI6S883eWC0
         sR2v4NTibFdk+S+5p8HN6n9YzAsPOVjfTKCLZAQkqdT2ZsmGZW70boU9hQn5yHSPq8+E
         N/bw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=GsYYj9hvF53lNra8umQJWkpQxGtDlYUa8ZF1UB6gZzQ=;
        b=QNum2vDXA8BqJNSX7YsBUtVFUEBOOBWebVP/ADYYa1Yrniu3DmffGKi2aN13jujk6Q
         s9lL76tP4XROPyeK/ExMaCH5xq8JkftIW/HKlCotH8xwCblSbTcFGxUJkTg6ZdpYS5GQ
         b7HAb9tjVuUZjhrcJEP3/1WZOIj76jEXHUUXtpiYsexUE2hqMsaXaae+OU0qu4E/KHwF
         HU+zinYuKgxHvObHmD06MSchFWWkGPQR2RNSPgh8gNRjiLH7SdWeWPR3kRwhibJ250uH
         IiEki9tLGaoQshHfshjtdPqb01+iGMWG7dl36p3Xql6JUeIGrXvWgJpTo2t8nmg+OwFB
         dkTw==
X-Gm-Message-State: AJcUukeZKbTVBOZrJIeywf60ZdZrvgloVbLcH1Wl3m4xZv5eerTZSM85
        sS0Kuj9lqj+DUQPEN49p91ugVdYsdaA=
X-Google-Smtp-Source: ALg8bN6P5x3VsDHGyyhV8hGa6U0kTcRt8yeDR3Vy2HKWAYoyEpN+mSCazTICeWsg6s24tIFGm2+gRg==
X-Received: by 2002:a63:7154:: with SMTP id b20mr2167994pgn.342.1546103279978;
        Sat, 29 Dec 2018 09:07:59 -0800 (PST)
Received: from localhost.localdomain ([240f:34:212d:1:d91e:35b2:75a8:1394])
        by smtp.gmail.com with ESMTPSA id h134sm86856276pfe.27.2018.12.29.09.07.58
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Sat, 29 Dec 2018 09:07:59 -0800 (PST)
From:   Akinobu Mita <akinobu.mita@gmail.com>
To:     linux-media@vger.kernel.org
Cc:     Akinobu Mita <akinobu.mita@gmail.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
Subject: [PATCH 4/4] media: mt9m111: set initial frame size other than 0x0
Date:   Sun, 30 Dec 2018 02:07:38 +0900
Message-Id: <1546103258-29025-5-git-send-email-akinobu.mita@gmail.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1546103258-29025-1-git-send-email-akinobu.mita@gmail.com>
References: <1546103258-29025-1-git-send-email-akinobu.mita@gmail.com>
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

This driver sets initial frame width and height to 0x0, which is invalid.
So set it to selection rectangle bounds instead.

This is detected by v4l2-compliance detected.

Cc: Sakari Ailus <sakari.ailus@linux.intel.com>
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>
Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
---
 drivers/media/i2c/mt9m111.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/media/i2c/mt9m111.c b/drivers/media/i2c/mt9m111.c
index 465e920..638236f 100644
--- a/drivers/media/i2c/mt9m111.c
+++ b/drivers/media/i2c/mt9m111.c
@@ -1312,6 +1312,8 @@ static int mt9m111_probe(struct i2c_client *client,
 	mt9m111->rect.top	= MT9M111_MIN_DARK_ROWS;
 	mt9m111->rect.width	= MT9M111_MAX_WIDTH;
 	mt9m111->rect.height	= MT9M111_MAX_HEIGHT;
+	mt9m111->width		= mt9m111->rect.width;
+	mt9m111->height		= mt9m111->rect.height;
 	mt9m111->fmt		= &mt9m111_colour_fmts[0];
 	mt9m111->lastpage	= -1;
 	mutex_init(&mt9m111->power_lock);
-- 
2.7.4

