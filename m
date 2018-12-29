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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 84C83C43387
	for <linux-media@archiver.kernel.org>; Sat, 29 Dec 2018 17:07:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 54BDE2184C
	for <linux-media@archiver.kernel.org>; Sat, 29 Dec 2018 17:07:56 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="B+E3uVZs"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727539AbeL2RHz (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Sat, 29 Dec 2018 12:07:55 -0500
Received: from mail-pl1-f195.google.com ([209.85.214.195]:45909 "EHLO
        mail-pl1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727532AbeL2RHz (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 29 Dec 2018 12:07:55 -0500
Received: by mail-pl1-f195.google.com with SMTP id a14so11206459plm.12
        for <linux-media@vger.kernel.org>; Sat, 29 Dec 2018 09:07:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=LixWnpehVNoPfXFEQn+kJGTokJpiPMy5ZsylAeis1hI=;
        b=B+E3uVZs58nG+5kyCz7RORkMWjdQwgZfjtCjnKeCfkryysZ6ChwNLZAD1Cy9LtZ2zo
         6IM3gx9bqMgOYq/RF5qEbA4jHSZt1A/MzYBzb8H60y8kvKJSeRhb0qnNhxgJVoHTwszb
         ggcTw2/jxEr1wueCvGXm95p1WrF2tKJjOKn9Q980LM/LpXH6iwsmZWE1bYXWUOiKrud7
         KlbOhbKylhtT1ewxtaFVpHAplwsw6iU7GsLdFh8ZNhfjpCxgvBwsst2IDCzRi3gDLEdk
         2+smbXXnUMRb5hpdVn2uw8KWEqD9gWPbPQRC0zGScgzHrRAN25fB5ZO+kPVX2wPChNvt
         o0cg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=LixWnpehVNoPfXFEQn+kJGTokJpiPMy5ZsylAeis1hI=;
        b=gfhqN3FXQt1Nu4lDHY2TbGfdcfm/ECcwTYUPYGJKRlz7GQeGqxy+a8vWcPdl9bAFM6
         MQy2+Gq/hYOeEtBOmDSmVxYX6MDDRF1gZMBT2Kf5IshseNvAHjohAOZI8Zc4OwSmVgo3
         CILwrgbNTTMpXaRTEDPq0juW+7pZlapCJaj50vOVoax/a1yDOctOaKnQN4uxpdPmhU8i
         ndmRBmEU//za7aqSZrKhHM/G+iQxwO8ObVm04okijPRWD0z9Cjy5//0dCCGGou5vc+8n
         /JYOsYc8bT7ghf2yxRBSuWD+spec8XYNGheCeyFiCpnbpiLBNqmvLq6fhMWluPLHU0DD
         etEQ==
X-Gm-Message-State: AJcUukcUHnflnE5VusqXMe89tBcRU9TDFrKnHMGeKwZfcW59OCyjVmDG
        A/BguTE7XdaEjEZ6lLbh2fzLLez88cI=
X-Google-Smtp-Source: ALg8bN7qHj+7l5GjJY5S8ChzZKSHp9hiEDlJTzYvX7fyyD1psUJUORo9iAZUUJiikTERmHI/Az73kg==
X-Received: by 2002:a17:902:ac8f:: with SMTP id h15mr30779048plr.245.1546103273700;
        Sat, 29 Dec 2018 09:07:53 -0800 (PST)
Received: from localhost.localdomain ([240f:34:212d:1:d91e:35b2:75a8:1394])
        by smtp.gmail.com with ESMTPSA id h134sm86856276pfe.27.2018.12.29.09.07.51
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Sat, 29 Dec 2018 09:07:53 -0800 (PST)
From:   Akinobu Mita <akinobu.mita@gmail.com>
To:     linux-media@vger.kernel.org
Cc:     Akinobu Mita <akinobu.mita@gmail.com>,
        Enrico Scholz <enrico.scholz@sigma-chemnitz.de>,
        Michael Grzeschik <m.grzeschik@pengutronix.de>,
        Marco Felsch <m.felsch@pengutronix.de>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
Subject: [PATCH 1/4] media: mt9m111: fix setting pixclk polarity
Date:   Sun, 30 Dec 2018 02:07:35 +0900
Message-Id: <1546103258-29025-2-git-send-email-akinobu.mita@gmail.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1546103258-29025-1-git-send-email-akinobu.mita@gmail.com>
References: <1546103258-29025-1-git-send-email-akinobu.mita@gmail.com>
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Since commit 98480d65c48c ("media: mt9m111: allow to setup pixclk
polarity"), the MT9M111_OUTFMT_INV_PIX_CLOCK bit in the output format
control 2 register has to be changed depending on the pclk-sample property
setting.

Without this change, the MT9M111_OUTFMT_INV_PIX_CLOCK bit is unchanged.

Fixes: 98480d65c48c ("media: mt9m111: allow to setup pixclk polarity")
Cc: Enrico Scholz <enrico.scholz@sigma-chemnitz.de>
Cc: Michael Grzeschik <m.grzeschik@pengutronix.de>
Cc: Marco Felsch <m.felsch@pengutronix.de>
Cc: Sakari Ailus <sakari.ailus@linux.intel.com>
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>
Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
---
 drivers/media/i2c/mt9m111.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/media/i2c/mt9m111.c b/drivers/media/i2c/mt9m111.c
index d639b9b..f0e47fd 100644
--- a/drivers/media/i2c/mt9m111.c
+++ b/drivers/media/i2c/mt9m111.c
@@ -542,6 +542,7 @@ static int mt9m111_set_pixfmt(struct mt9m111 *mt9m111,
 {
 	struct i2c_client *client = v4l2_get_subdevdata(&mt9m111->subdev);
 	u16 data_outfmt2, mask_outfmt2 = MT9M111_OUTFMT_PROCESSED_BAYER |
+		MT9M111_OUTFMT_INV_PIX_CLOCK |
 		MT9M111_OUTFMT_BYPASS_IFP | MT9M111_OUTFMT_RGB |
 		MT9M111_OUTFMT_RGB565 | MT9M111_OUTFMT_RGB555 |
 		MT9M111_OUTFMT_RGB444x | MT9M111_OUTFMT_RGBx444 |
-- 
2.7.4

