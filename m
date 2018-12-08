Return-Path: <SRS0=LTSq=OR=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BA0C1C04EB8
	for <linux-media@archiver.kernel.org>; Sat,  8 Dec 2018 04:45:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7D48C2082D
	for <linux-media@archiver.kernel.org>; Sat,  8 Dec 2018 04:45:02 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="CJsn5CnU"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 7D48C2082D
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-media-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726104AbeLHEpB (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Fri, 7 Dec 2018 23:45:01 -0500
Received: from mail-pg1-f193.google.com ([209.85.215.193]:38245 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726081AbeLHEpB (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 7 Dec 2018 23:45:01 -0500
Received: by mail-pg1-f193.google.com with SMTP id g189so2588515pgc.5
        for <linux-media@vger.kernel.org>; Fri, 07 Dec 2018 20:45:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=WBQlmUFigG6XjRPhVyNz9kgraxu7zwYVtMWk1l0gYuk=;
        b=CJsn5CnULZKRoGKBpPOdzdE6k84qQzTH9nftCiKyQDSLX2jGnxWPANKl/3prX9X+zV
         +ecie3GBJ2IXmQJSjk8JmbMKxjk/quxbw0bjFijsCmUMsck6xGNgnDQyCElamwo12G5a
         X94X7UHorTzvN2mnoY2SWT9m0BYwmlg9hpdkS0FYGaH1z4RO14rcoFIDLFw3OtXhYVdi
         IFHPJb5u6ylqC/3+sUbyQDDPR6vTeFt+BE4jYLrHy/yNWa0mK601LMxwNG8tTSPqEW9W
         EAlLWScFOOHCpC0egsywOxV9+vzopVNqiUKBr7B6BQMy2wIezK+vfwjgU1+dY1J2T8u9
         rlKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=WBQlmUFigG6XjRPhVyNz9kgraxu7zwYVtMWk1l0gYuk=;
        b=unIj2DbUf7Rac+3IadtFh0thQ7389cClRXjQ2bqKP9KENsW2m5sNfUN+UwXnKEOUxm
         RIeaxaqQM2jHZITNeWp8xfksABQmkwbjL+cpckRlfJENyqe9gzX4L7wPIzxOu3B+m6nu
         4TTc0Qo+JY2Bf26QdT3yJmaxYDP1Jn9IYWwfyKkKWf+ez2hJng7BMW3Ep2cUQ8+BIvbR
         GxOxc16qldfGg61e14NkySehIakzgGFRQVukXE9kEYlk0RR5sEE+Aj8BhgL8W+WTlZnn
         3ciWFwKF1ydQJZA84V0UZ7/D+oSBmxgoS6Sb5nlBKjHT5zNdTFbxpeqIfqMqT2yl/lEM
         MR0w==
X-Gm-Message-State: AA+aEWappzWA64UhPhMu0iDi6T0Xgp303Coi/QarQybZXsrvqSIEhKmU
        BXtuzdtxCTE6e8M0nmapqiZOATav
X-Google-Smtp-Source: AFSGD/WJTyOZ3fLDNnOCx8NiEcC0UZATcfkTqjRW/xzJeqi3s0XoGy7v/rmsoDozqUriVoOOJr09qA==
X-Received: by 2002:a62:710a:: with SMTP id m10mr4769757pfc.69.1544244300478;
        Fri, 07 Dec 2018 20:45:00 -0800 (PST)
Received: from localhost.localdomain ([240f:34:212d:1:9ca3:939e:b94a:438e])
        by smtp.gmail.com with ESMTPSA id h74sm8248193pfd.35.2018.12.07.20.44.58
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Fri, 07 Dec 2018 20:45:00 -0800 (PST)
From:   Akinobu Mita <akinobu.mita@gmail.com>
To:     linux-media@vger.kernel.org
Cc:     Akinobu Mita <akinobu.mita@gmail.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
Subject: [PATCH 1/3] media: ov2640: set default window and format code at probe time
Date:   Sat,  8 Dec 2018 13:44:44 +0900
Message-Id: <1544244286-11597-2-git-send-email-akinobu.mita@gmail.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1544244286-11597-1-git-send-email-akinobu.mita@gmail.com>
References: <1544244286-11597-1-git-send-email-akinobu.mita@gmail.com>
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Set default window and format code at probe time instead of always checking
if they have not been set yet when VIDIOC_SUBDEV_G_FMT ioctl is called.

This change simplifies the next patch (make VIDIOC_SUBDEV_G_FMT ioctl work
with V4L2_SUBDEV_FORMAT_TRY).

Cc: Sakari Ailus <sakari.ailus@linux.intel.com>
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>
Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
---
 drivers/media/i2c/ov2640.c | 10 +++-------
 1 file changed, 3 insertions(+), 7 deletions(-)

diff --git a/drivers/media/i2c/ov2640.c b/drivers/media/i2c/ov2640.c
index d8e91bc..a07e6f2 100644
--- a/drivers/media/i2c/ov2640.c
+++ b/drivers/media/i2c/ov2640.c
@@ -842,9 +842,6 @@ static int ov2640_set_params(struct i2c_client *client,
 	u8 val;
 	int ret;
 
-	if (!win)
-		return -EINVAL;
-
 	switch (code) {
 	case MEDIA_BUS_FMT_RGB565_2X8_BE:
 		dev_dbg(&client->dev, "%s: Selected cfmt RGB565 BE", __func__);
@@ -929,10 +926,6 @@ static int ov2640_get_fmt(struct v4l2_subdev *sd,
 	if (format->pad)
 		return -EINVAL;
 
-	if (!priv->win) {
-		priv->win = ov2640_select_win(SVGA_WIDTH, SVGA_HEIGHT);
-		priv->cfmt_code = MEDIA_BUS_FMT_UYVY8_2X8;
-	}
 
 	mf->width	= priv->win->width;
 	mf->height	= priv->win->height;
@@ -1193,6 +1186,9 @@ static int ov2640_probe(struct i2c_client *client,
 	if (ret)
 		goto err_clk;
 
+	priv->win = ov2640_select_win(SVGA_WIDTH, SVGA_HEIGHT);
+	priv->cfmt_code = MEDIA_BUS_FMT_UYVY8_2X8;
+
 	v4l2_i2c_subdev_init(&priv->subdev, client, &ov2640_subdev_ops);
 	priv->subdev.flags |= V4L2_SUBDEV_FL_HAS_DEVNODE |
 			      V4L2_SUBDEV_FL_HAS_EVENTS;
-- 
2.7.4

