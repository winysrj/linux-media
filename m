Return-Path: <SRS0=gjtM=PQ=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4EA3AC43387
	for <linux-media@archiver.kernel.org>; Tue,  8 Jan 2019 14:52:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1C43720883
	for <linux-media@archiver.kernel.org>; Tue,  8 Jan 2019 14:52:23 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="d6K2WGm+"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727885AbfAHOwW (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Tue, 8 Jan 2019 09:52:22 -0500
Received: from mail-pg1-f196.google.com ([209.85.215.196]:36406 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727656AbfAHOwW (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Tue, 8 Jan 2019 09:52:22 -0500
Received: by mail-pg1-f196.google.com with SMTP id n2so1841492pgm.3;
        Tue, 08 Jan 2019 06:52:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=G061K61azQp3YXHiwwoCy96MrNzyxcy5eXMiGya7uSU=;
        b=d6K2WGm+iNWMdslF/QluMIajyCJoT3+3kKlGUWwjRUQjT9ictuE0gUpFHtUK67X7B0
         zvu6zCPgcX8EoevURDF9lrQxXuJxcG5bQpW9VJAMIc6Pg+Ibj/seu5/33dDRmw0XWFb2
         DbbRx8mxLfhF/S5P/2omHIWi88+Fm7k+WGibyJjxrbE/Md9NEzk238hrDUC7LtGnQZoT
         NxPXmSqMTvYB3zs2ZcFFbzolSynldEKBqsvwLB8SwqaRN8I2GL2h/NgLJCW4GU6ROjjG
         y/DOqxI6uv1dtc2PS+S05q7UjCaCJ9e+8HovseJOHACPTvWU5/kLOmaTwM5++VCsFtJd
         3fTQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=G061K61azQp3YXHiwwoCy96MrNzyxcy5eXMiGya7uSU=;
        b=rBEyPdxtV5JnZj93g9JSaxSbVyCD/xcRsZWVJwMF5DkuEOzI2LRBKarAcx9b3lvoZi
         sgoARSCPsJpKHS7eIsSIeywaxJW4F2CGGE1Mv9Z446Vo7AU2ispRSXbKiyYqIykrx6wP
         ughK8+T2OYZQz4Wo6fi89qa/PLQ2N3axnlChCZUk+cxQSoeKTQv2FLG6SIw23AqrxPt8
         FGzbMGi9jPtle5jEdZrwY91lvKnXH5glM8iRAOaEl3BE0zwxd/R9vz+pK44dXHIZYNre
         u33kPyCda59hX3unw+EVSScvCEGcX4lNGbgFyxETyCNf1YQvqUI2G/hhHqiO+jv69Hjp
         oIXA==
X-Gm-Message-State: AJcUukeXOL7N3Gsx4prlyMbhfetvUME1EskJ2WFn8+iULmfa9WdUcNkQ
        abmiKwRVfz2TAg0aO9WBA0JDmBtY
X-Google-Smtp-Source: ALg8bN6lFQwDNwYcD5oCf7oDD7m07ZgVhKQidlLs7pGk5S1vmtGxJZ4eMQHBxAwWoIc9nOnzNO4rPw==
X-Received: by 2002:a63:fa06:: with SMTP id y6mr1780219pgh.177.1546959141421;
        Tue, 08 Jan 2019 06:52:21 -0800 (PST)
Received: from localhost.localdomain ([240f:34:212d:1:5cb2:2bb:ff67:c70d])
        by smtp.gmail.com with ESMTPSA id n78sm53546990pfk.19.2019.01.08.06.52.10
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Tue, 08 Jan 2019 06:52:20 -0800 (PST)
From:   Akinobu Mita <akinobu.mita@gmail.com>
To:     linux-media@vger.kernel.org, devicetree@vger.kernel.org
Cc:     Akinobu Mita <akinobu.mita@gmail.com>,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
Subject: [PATCH v2 03/13] media: mt9m001: convert to SPDX license identifer
Date:   Tue,  8 Jan 2019 23:51:40 +0900
Message-Id: <1546959110-19445-4-git-send-email-akinobu.mita@gmail.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1546959110-19445-1-git-send-email-akinobu.mita@gmail.com>
References: <1546959110-19445-1-git-send-email-akinobu.mita@gmail.com>
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Replace GPL license statements with SPDX license identifiers (GPL-2.0).

This also fixes MODULE_LICENSE() ident to match the actual license text.

Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: Sakari Ailus <sakari.ailus@linux.intel.com>
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>
Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
---
* v2
- Fix MODULE_LICENSE() masmatch.

 drivers/media/i2c/mt9m001.c | 7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff --git a/drivers/media/i2c/mt9m001.c b/drivers/media/i2c/mt9m001.c
index a1a85ff..c0b6b0c 100644
--- a/drivers/media/i2c/mt9m001.c
+++ b/drivers/media/i2c/mt9m001.c
@@ -1,11 +1,8 @@
+// SPDX-License-Identifier: GPL-2.0
 /*
  * Driver for MT9M001 CMOS Image Sensor from Micron
  *
  * Copyright (C) 2008, Guennadi Liakhovetski <kernel@pengutronix.de>
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License version 2 as
- * published by the Free Software Foundation.
  */
 
 #include <linux/videodev2.h>
@@ -754,4 +751,4 @@ module_i2c_driver(mt9m001_i2c_driver);
 
 MODULE_DESCRIPTION("Micron MT9M001 Camera driver");
 MODULE_AUTHOR("Guennadi Liakhovetski <kernel@pengutronix.de>");
-MODULE_LICENSE("GPL");
+MODULE_LICENSE("GPL v2");
-- 
2.7.4

