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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9122CC43444
	for <linux-media@archiver.kernel.org>; Sat, 22 Dec 2018 17:13:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6198E21A48
	for <linux-media@archiver.kernel.org>; Sat, 22 Dec 2018 17:13:18 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="LcbzjwXo"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391044AbeLVRNQ (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Sat, 22 Dec 2018 12:13:16 -0500
Received: from mail-pf1-f195.google.com ([209.85.210.195]:41245 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731640AbeLVRNO (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 22 Dec 2018 12:13:14 -0500
Received: by mail-pf1-f195.google.com with SMTP id b7so4044439pfi.8;
        Sat, 22 Dec 2018 09:13:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=cAuyBb5kdZIa6fNCN4A1oNXC6uzungTRucBD0yE5KY4=;
        b=LcbzjwXoamMuLuKDLt8JuqfI4NBJdBVA1xbavDnyaDKF9Q73NaMuxYuWhIWCvtaPWn
         qYmhMsK6W4V4PW9XdtwFrJmZcUyO2Nn5T2K6e83Kqp07qK7Lr/Dt8LHJ3e39lkFvXrPP
         wce34c901Kuiq47UMH+MGdGt1U1NE9iHFNj1IA3hw6J57Oh9ekaEVlG6P+d+RXkies6I
         tfQbQo13LjeviwQ7SDW2zwb0QaKBBd95LqTU5RTFI+w2YyGuZYkR+p/P1d0VdjjMTZQO
         vMq3op4TBjoBYd3NTViV6mr29Qi1EZmlfypCgZDRHvrJqDxtPuL3h991gSoTEn6m5+2o
         HCwQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=cAuyBb5kdZIa6fNCN4A1oNXC6uzungTRucBD0yE5KY4=;
        b=XdAzQ2FE3cnAjazx/PEHA1dijwiyvlaRWXvx0P3VQDayRTok6Rmda3qd0YpenwZZAT
         sqIEcX8J1PtVeYY80hW3DO9C3DIYj0qpORu1CiAAWTNI4NQq+zYKMgSDkubZhCBvAObh
         aCRiL4htaUTi8rvbPXh+oj0EbPMOhYNccdMWwVlseulPd5NkBIjlCud7HQnBdJr9n/ck
         YNuaT/RqEGb5lsh1KWDjOlgdv1XtyM4r0O3I+l3uMHIsXJDwefgja3NPz0sOJDggGMqw
         ONecrDCFgaSZAmEj1ufsFxlz2wHareBlZa0xMHzWqARJU3UobO2jkMg6VVwTlFecUR5n
         UkPw==
X-Gm-Message-State: AJcUukf0zysS96yMhQFKP2jGbnAJNkdJ5nURLUtG8M5mCwG0NfjcTnIZ
        KGTNNOy80cVo8r8M3+WfYgu5kfO+kxw=
X-Google-Smtp-Source: ALg8bN4OJ53TozAuK1dJ7wjj2Mcls4mWvKtDBOFWP3uwKH2o36HC5NGcW3P0afyJGCC5E5ynTBuxMQ==
X-Received: by 2002:a62:5658:: with SMTP id k85mr7069712pfb.231.1545498793253;
        Sat, 22 Dec 2018 09:13:13 -0800 (PST)
Received: from localhost.localdomain ([240f:34:212d:1:966:8499:7122:52f6])
        by smtp.gmail.com with ESMTPSA id w11sm33322025pgk.16.2018.12.22.09.13.11
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Sat, 22 Dec 2018 09:13:12 -0800 (PST)
From:   Akinobu Mita <akinobu.mita@gmail.com>
To:     linux-media@vger.kernel.org, devicetree@vger.kernel.org
Cc:     Akinobu Mita <akinobu.mita@gmail.com>,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Mauro Carvalho Chehab <mchehab@s-opensource.com>
Subject: [PATCH 03/12] media: mt9m001: convert to SPDX license identifer
Date:   Sun, 23 Dec 2018 02:12:45 +0900
Message-Id: <1545498774-11754-4-git-send-email-akinobu.mita@gmail.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1545498774-11754-1-git-send-email-akinobu.mita@gmail.com>
References: <1545498774-11754-1-git-send-email-akinobu.mita@gmail.com>
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Replace GPL license statements with SPDX license identifiers (GPL-2.0).

Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: Sakari Ailus <sakari.ailus@linux.intel.com>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
---
 drivers/media/i2c/mt9m001.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/drivers/media/i2c/mt9m001.c b/drivers/media/i2c/mt9m001.c
index a1a85ff..65ff59d 100644
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
-- 
2.7.4

