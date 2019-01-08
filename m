Return-Path: <SRS0=gjtM=PQ=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A1BC1C43387
	for <linux-media@archiver.kernel.org>; Tue,  8 Jan 2019 14:52:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 701D520883
	for <linux-media@archiver.kernel.org>; Tue,  8 Jan 2019 14:52:28 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ijewAaa7"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728644AbfAHOw1 (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Tue, 8 Jan 2019 09:52:27 -0500
Received: from mail-pl1-f193.google.com ([209.85.214.193]:42175 "EHLO
        mail-pl1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727656AbfAHOw1 (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Tue, 8 Jan 2019 09:52:27 -0500
Received: by mail-pl1-f193.google.com with SMTP id y1so1999220plp.9;
        Tue, 08 Jan 2019 06:52:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=HiWPQkteCVt8lOyj6Ow9cr3Hq9axr+LWdxDcwXCXxwE=;
        b=ijewAaa7frY6I17fdTjKW2ASNBbaf2PVubitXEraVQfqOJyCBsdJWSAZLsxjr13KXB
         1nyJpmL8l8immrtHkd99P3YGu3/B0k4Wrzt1xCWA9e+YxlJ4tWwqXL0wmcpM/BRKzzHt
         C8TqSysz8VRxSzVKtH8ncw2wO+ZtpbgFR1raLRhGXm1xLET5CRNuHJ/NKdDSM1hDqFnL
         FSy+sjwaJ6/IxowGbnFR8WPPFYfSrER9z7Ief6LiE9IbxBNoKyhj26hnjkvy3s+BQrbj
         agIIwTeeltahH3rJ+nBbeBD3ZdaxCpk/jp1VeCIm77LUgzj+heI5vmaiQyji3oTMCPPv
         Zkog==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=HiWPQkteCVt8lOyj6Ow9cr3Hq9axr+LWdxDcwXCXxwE=;
        b=WFY0JgnDIQuGJmoabN6iPm4qfGV+jaMuiZ6/zhuAyC3ewe4Hh/ZT+tcRKsMC+lOEIt
         Pj1xnf7Zz6JgFXyrNeoCLNTBIDyanC/iLVqymwjy6VzFWpc+90pSi3w1oNC40tPJ+HAC
         CeghDysL3uHbD4yt4NJTN6XTyORmDdP64/WSdUzbzgo1SkE4FlCvskobIm3EWWOU2qV7
         Wb9j68HBW5t8GMSyTBQS0PVsav+8OIBNQO4p7/PzaWzNM+yq2xdppRkOi7FSxpzO4f4J
         s0lUmxtJcvGV2RupHVUiXokmOilocAzbXnfedpybBrJHbpasnJnmCP+OML0pS5upx/+L
         /EaQ==
X-Gm-Message-State: AJcUukfsnfibPdRJKNMRSgpJa0BX3ANTsOW7gYK1x2LspdRW687T+h1E
        lgmUQ367627wPxxK0HJyP6RWQpkZ
X-Google-Smtp-Source: ALg8bN4PH8w9IODcrps3OxTXoq2rQIOeZYeJqqmpfgoetH95YtpBeb4tqcfJ/UhK9rM9e1AY1Pfy1A==
X-Received: by 2002:a17:902:a411:: with SMTP id p17mr2041172plq.292.1546959146531;
        Tue, 08 Jan 2019 06:52:26 -0800 (PST)
Received: from localhost.localdomain ([240f:34:212d:1:5cb2:2bb:ff67:c70d])
        by smtp.gmail.com with ESMTPSA id n78sm53546990pfk.19.2019.01.08.06.52.24
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Tue, 08 Jan 2019 06:52:25 -0800 (PST)
From:   Akinobu Mita <akinobu.mita@gmail.com>
To:     linux-media@vger.kernel.org, devicetree@vger.kernel.org
Cc:     Akinobu Mita <akinobu.mita@gmail.com>,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
Subject: [PATCH v2 05/13] media: mt9m001: add of_match_table
Date:   Tue,  8 Jan 2019 23:51:42 +0900
Message-Id: <1546959110-19445-6-git-send-email-akinobu.mita@gmail.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1546959110-19445-1-git-send-email-akinobu.mita@gmail.com>
References: <1546959110-19445-1-git-send-email-akinobu.mita@gmail.com>
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Add of_match_table for the MT9M001 CMOS image sensor.

Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: Sakari Ailus <sakari.ailus@linux.intel.com>
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>
Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
---
* No changes from v1

 drivers/media/i2c/mt9m001.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/media/i2c/mt9m001.c b/drivers/media/i2c/mt9m001.c
index dc6cf46..3864d88 100644
--- a/drivers/media/i2c/mt9m001.c
+++ b/drivers/media/i2c/mt9m001.c
@@ -738,9 +738,16 @@ static const struct i2c_device_id mt9m001_id[] = {
 };
 MODULE_DEVICE_TABLE(i2c, mt9m001_id);
 
+static const struct of_device_id mt9m001_of_match[] = {
+	{ .compatible = "onnn,mt9m001", },
+	{ /* sentinel */ },
+};
+MODULE_DEVICE_TABLE(of, mt9m001_of_match);
+
 static struct i2c_driver mt9m001_i2c_driver = {
 	.driver = {
 		.name = "mt9m001",
+		.of_match_table = mt9m001_of_match,
 	},
 	.probe		= mt9m001_probe,
 	.remove		= mt9m001_remove,
-- 
2.7.4

