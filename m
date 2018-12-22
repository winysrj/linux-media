Return-Path: <SRS0=mDsK=O7=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A67AFC43387
	for <linux-media@archiver.kernel.org>; Sat, 22 Dec 2018 17:13:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7680A21A48
	for <linux-media@archiver.kernel.org>; Sat, 22 Dec 2018 17:13:17 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="n5BPjMDh"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391047AbeLVRNQ (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Sat, 22 Dec 2018 12:13:16 -0500
Received: from mail-pl1-f196.google.com ([209.85.214.196]:41251 "EHLO
        mail-pl1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390366AbeLVRNQ (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 22 Dec 2018 12:13:16 -0500
Received: by mail-pl1-f196.google.com with SMTP id u6so3908694plm.8;
        Sat, 22 Dec 2018 09:13:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=2T5vV+fLhKc7N1BoFTrmZ9ISXlab11bC+V+QEg6BFGs=;
        b=n5BPjMDhBFQXUcNGhBuPKIDtImpKWGZvde5yQAQw5LPPAGvi/HsZQ2qwy9Z+S3PnCp
         c/ZYHhCYvP03TrQM6Hv5WSNE7pVgxNLVNfp83KnI6PJEyicz5RJQUPcpJlXKoRvTxPlF
         N7hN/dLuq+VDStaGi0bY3WE5gb6Aq2/Juk6t6liIY7CSukpWnCaElDWK7daZxusvD0BE
         EacjcuFPcnq+y4h2Ywsm9sr3+1QeXZUWTpahKmqjzwe6kwAEKZXiHXq6uFwoFNcR2/UK
         xEAHBNE48AiDZNCv4wZ6EJzZreAitNgGa/ObxJqpkK6GdZziedSJd70V87rYwpYcl+Xb
         CZzA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=2T5vV+fLhKc7N1BoFTrmZ9ISXlab11bC+V+QEg6BFGs=;
        b=Ybfi05EOCMTFD0QKsk0I7VvXj0PzDEeoak1ceL9bPa7XQgwpfiH5v3N1BV+jvcddWG
         qbdcoApGuKH1SxJ17wfpSgQPPnjeOT5cMzWAOuQV4885iO/Ms8YBmxlrNcPuZ59zFoJs
         7fOPp9fIt1eQWe0VDA9hsAILgMnedmbUTcTWXbk/qBz3/97+m3nteEPUIyYTigZicfIG
         1w18ZKkgLdwd91Gkx+XliYui+CQNrqGYWRCPnoUrtgug/pAvpn/ZgWvK84kFNDCokVD7
         b2eEWl0V38hfbfJWhbSgXrBZ5WjRtD5z2OT3D2i+b0xBwR41IcKB2tS9XizCYBrbkGft
         rpSg==
X-Gm-Message-State: AJcUukcPtPlJByOg989mgmi66RyGP9jYl8SDKQBV8e3arDU53wKfIj43
        I0WvDYYASI7yEFdiw1VCE2UqFOnoh0g=
X-Google-Smtp-Source: ALg8bN5qGdyWycoyv3reD1jNEUplXdzcRcnGevsjzQPVIBbPt0jPaI7HQdC7Vy3HsIpUo1DDMUrB/w==
X-Received: by 2002:a17:902:145:: with SMTP id 63mr7103830plb.256.1545498795317;
        Sat, 22 Dec 2018 09:13:15 -0800 (PST)
Received: from localhost.localdomain ([240f:34:212d:1:966:8499:7122:52f6])
        by smtp.gmail.com with ESMTPSA id w11sm33322025pgk.16.2018.12.22.09.13.13
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Sat, 22 Dec 2018 09:13:14 -0800 (PST)
From:   Akinobu Mita <akinobu.mita@gmail.com>
To:     linux-media@vger.kernel.org, devicetree@vger.kernel.org
Cc:     Akinobu Mita <akinobu.mita@gmail.com>,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Mauro Carvalho Chehab <mchehab@s-opensource.com>
Subject: [PATCH 04/12] media: mt9m001: add of_match_table
Date:   Sun, 23 Dec 2018 02:12:46 +0900
Message-Id: <1545498774-11754-5-git-send-email-akinobu.mita@gmail.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1545498774-11754-1-git-send-email-akinobu.mita@gmail.com>
References: <1545498774-11754-1-git-send-email-akinobu.mita@gmail.com>
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Add of_match_table for the MT9M001 CMOS image sensor.

Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: Sakari Ailus <sakari.ailus@linux.intel.com>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
---
 drivers/media/i2c/mt9m001.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/media/i2c/mt9m001.c b/drivers/media/i2c/mt9m001.c
index 65ff59d..2d800ca 100644
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

