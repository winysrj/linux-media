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
	by smtp.lore.kernel.org (Postfix) with ESMTP id A9064C43387
	for <linux-media@archiver.kernel.org>; Tue, 15 Jan 2019 14:06:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 76D112086D
	for <linux-media@archiver.kernel.org>; Tue, 15 Jan 2019 14:06:03 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="d+JYwnQS"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730303AbfAOOGD (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Tue, 15 Jan 2019 09:06:03 -0500
Received: from mail-pl1-f194.google.com ([209.85.214.194]:35308 "EHLO
        mail-pl1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727060AbfAOOGC (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 15 Jan 2019 09:06:02 -0500
Received: by mail-pl1-f194.google.com with SMTP id p8so1352144plo.2
        for <linux-media@vger.kernel.org>; Tue, 15 Jan 2019 06:06:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=V7KJzpokzs/SHc5BLW8fZKNX5ErQEMzpNlRmc6KIPCU=;
        b=d+JYwnQS8x4yppUMuScio0WhcGdPIfy7BZztOfxpwaY9q8ye/8kLs6unhEAlCC6Var
         f9DCCWDS+yEr4COwOyavbuwkgbPmh3gqObAFwMAFo5aG1K+LFHNGRDHR12+y34ngOuG1
         jkEr0Wh3MGC1sEvvmGxB1ss/VZDEplJOaEASyl37HliBQf7yC+VpXuzpjTZQZ3LhPKTn
         xvGok4FOohjzgVHtoc31y924FgePY+z1DOkHEoJTQ6Lh7z/eS+hjoyDs1erS/eHxznbM
         ya14a+TpQup0YyNSAEh/qaudgqhT3YCcLLgNwVV2A89oArIF8NSTKr00dJ6fwIUjxTpR
         QZFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=V7KJzpokzs/SHc5BLW8fZKNX5ErQEMzpNlRmc6KIPCU=;
        b=LccU/Mb0Ve2o/tW3djgO1WFwp8lJ3G7jR7vaMza5lnKdpxIsy3xtZAvgkZOPAzt8QI
         4Gmz3qprRqdjM3c9nKfenAI5mL/RPOoGVUTZqrgKlf7yOms6eG1KcyCJEqX2ojPQ4nWj
         Hv70kj06IzdTQKvsxNPgHkXbuNOAPYG2GIm7mumQFpeXA1imfrDQE2CJuvlNfVm8ZK0I
         yGEg5x3w6RcNHK1TnFnZnygN34VWRiWJeIdEDpG0tpHBKl5Q+8fKx4/oMRRTiYYhHV/r
         g5ei3U8GpywULPQRr/u/G2vF23V7to+5xqGoJY2Sb1sUOWWobsaUusHgpWIAQIR37Rsv
         BzQw==
X-Gm-Message-State: AJcUukdaSr352UpKkjKOwR/AvVpEE4QaAcpO60uEYZwDUTp2rFSa0xUe
        76lSFgyqK/B9hNxB4dmQUUXKSSoD
X-Google-Smtp-Source: ALg8bN75+hj0hEYfQNrd/ob+r8F/zfM3LA520/VIoLTIKk2K/jrN05ryh4FlgajewDR0oEqZB9RpNg==
X-Received: by 2002:a17:902:4523:: with SMTP id m32mr4266777pld.53.1547561161818;
        Tue, 15 Jan 2019 06:06:01 -0800 (PST)
Received: from localhost.localdomain ([240f:34:212d:1:5894:91d7:f206:dece])
        by smtp.gmail.com with ESMTPSA id c72sm5394125pfb.107.2019.01.15.06.05.59
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Tue, 15 Jan 2019 06:06:01 -0800 (PST)
From:   Akinobu Mita <akinobu.mita@gmail.com>
To:     linux-media@vger.kernel.org
Cc:     Akinobu Mita <akinobu.mita@gmail.com>,
        Enrico Scholz <enrico.scholz@sigma-chemnitz.de>,
        Michael Grzeschik <m.grzeschik@pengutronix.de>,
        Marco Felsch <m.felsch@pengutronix.de>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
Subject: [PATCH v3 3/3] media: mt9m111: set initial frame size other than 0x0
Date:   Tue, 15 Jan 2019 23:05:41 +0900
Message-Id: <1547561141-13504-4-git-send-email-akinobu.mita@gmail.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1547561141-13504-1-git-send-email-akinobu.mita@gmail.com>
References: <1547561141-13504-1-git-send-email-akinobu.mita@gmail.com>
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
* No changes from v2

 drivers/media/i2c/mt9m111.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/media/i2c/mt9m111.c b/drivers/media/i2c/mt9m111.c
index 9c92eca..5168bb5 100644
--- a/drivers/media/i2c/mt9m111.c
+++ b/drivers/media/i2c/mt9m111.c
@@ -1310,6 +1310,8 @@ static int mt9m111_probe(struct i2c_client *client,
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

