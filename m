Return-Path: <SRS0=KIs1=PS=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 89483C43387
	for <linux-media@archiver.kernel.org>; Thu, 10 Jan 2019 15:28:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 51B9320685
	for <linux-media@archiver.kernel.org>; Thu, 10 Jan 2019 15:28:58 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="tev/FkFb"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729657AbfAJP2z (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Thu, 10 Jan 2019 10:28:55 -0500
Received: from mail-pl1-f196.google.com ([209.85.214.196]:44610 "EHLO
        mail-pl1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729188AbfAJP2y (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 10 Jan 2019 10:28:54 -0500
Received: by mail-pl1-f196.google.com with SMTP id e11so5328415plt.11
        for <linux-media@vger.kernel.org>; Thu, 10 Jan 2019 07:28:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=BRjm403oirrjQoDG14oEXNOcD7lBBEEACEf3lxalZ68=;
        b=tev/FkFbcYCRUN8zRo93Vmwin/3OyjvHgXyzR2Ii9l2KQjYMd97FBo263TLJCiD86o
         M+rb3Fon+4ky2ri/TBR72WEjC4MGxewH03TxJOxDBjAvSX6Zedp/q6oCcrW5Uvonnp0B
         ndzB7wz/gWN/EDXHTcmotgJpOUwQ6aIL+JlfwkSLCiaPIKKtxrLKYYxvBx8P6lhzp8fV
         ok/HNMmguWtYxw19dyh5xH1cbbij3sdLxiIFoqc61U9s6XJkgfmqvNgGx28nG/XKF7Wx
         UUcawVIeFzfo8vkmeTf3ylN2EzYTcjDKy1uRPTpgk19gOFaSj0OAuoNIwAPliTCuspOp
         jnCQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=BRjm403oirrjQoDG14oEXNOcD7lBBEEACEf3lxalZ68=;
        b=jsBQRdAuD2i4LOHm/+fCj1XtI6Mo77NyDgL/s6+aFDjAtw0iqtdqwnjW8mW18Q1JhT
         L0C33y3+0TOB5Zxfx5KDM2idAUrqOzRZkRQIjSji+XPhm4696k2bSoE2HlNt2nPSR9js
         oDjVA35APQSVQcMUhbZqTj1gxAVE7rUwmo7FzI+3T3/OXO/vQd6VeRnvCcE3KVqPB4cz
         7j3txMnrkrLJdsW9IzsmokfkmQYtbm/Cf7ey1J/o1hIshpX6YVXU5xjn9H65D/meC1Su
         wZi7HvGDYyOZPzRIUNhBmcBE4fBup86cLaP2KtQaWakRGF6p5KPRfgsBfe6X69v/h/ts
         zo2g==
X-Gm-Message-State: AJcUukdXdcE/G8AXC2W+c9exsTprEISA7Yv1xkd7pwYvkj5h/c2rFXfo
        y5I4661+0VWKcBmf4fsof9NLF0SS
X-Google-Smtp-Source: ALg8bN6Sxrd7a3B58rMPIzOezBRfp/G0b9yjwHo15LcKm5g/ee+yNi0f94jGunhDdUZiXT9+MaVs5w==
X-Received: by 2002:a17:902:ab92:: with SMTP id f18mr10366360plr.221.1547134134142;
        Thu, 10 Jan 2019 07:28:54 -0800 (PST)
Received: from localhost.localdomain ([240f:34:212d:1:25a3:d6ca:ee6b:e202])
        by smtp.gmail.com with ESMTPSA id y1sm105916116pfe.9.2019.01.10.07.28.52
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Thu, 10 Jan 2019 07:28:53 -0800 (PST)
From:   Akinobu Mita <akinobu.mita@gmail.com>
To:     linux-media@vger.kernel.org
Cc:     Akinobu Mita <akinobu.mita@gmail.com>,
        Enrico Scholz <enrico.scholz@sigma-chemnitz.de>,
        Michael Grzeschik <m.grzeschik@pengutronix.de>,
        Marco Felsch <m.felsch@pengutronix.de>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
Subject: [PATCH v2 3/3] media: mt9m111: set initial frame size other than 0x0
Date:   Fri, 11 Jan 2019 00:28:29 +0900
Message-Id: <1547134109-21449-4-git-send-email-akinobu.mita@gmail.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1547134109-21449-1-git-send-email-akinobu.mita@gmail.com>
References: <1547134109-21449-1-git-send-email-akinobu.mita@gmail.com>
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

This driver sets initial frame width and height to 0x0, which is invalid.
So set it to selection rectangle bounds instead.

This is detected by v4l2-compliance detected.

Cc: Enrico Scholz <enrico.scholz@sigma-chemnitz.de>
Cc: Michael Grzeschik <m.grzeschik@pengutronix.de>
Cc: Marco Felsch <m.felsch@pengutronix.de>
Cc: Sakari Ailus <sakari.ailus@linux.intel.com>
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>
Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
---
* No changes from v1

 drivers/media/i2c/mt9m111.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/media/i2c/mt9m111.c b/drivers/media/i2c/mt9m111.c
index e758b4d..c442f80 100644
--- a/drivers/media/i2c/mt9m111.c
+++ b/drivers/media/i2c/mt9m111.c
@@ -1311,6 +1311,8 @@ static int mt9m111_probe(struct i2c_client *client,
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

