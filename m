Return-Path: <SRS0=gjtM=PQ=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 76298C43387
	for <linux-media@archiver.kernel.org>; Tue,  8 Jan 2019 14:52:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 43F9C206BB
	for <linux-media@archiver.kernel.org>; Tue,  8 Jan 2019 14:52:25 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Urtinqto"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728587AbfAHOwY (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Tue, 8 Jan 2019 09:52:24 -0500
Received: from mail-pf1-f195.google.com ([209.85.210.195]:46240 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727656AbfAHOwY (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Tue, 8 Jan 2019 09:52:24 -0500
Received: by mail-pf1-f195.google.com with SMTP id c73so2020199pfe.13;
        Tue, 08 Jan 2019 06:52:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=hm01CGexkoLYwdctde6xGXd/63Q5F3tNzbQ7JrfTmc4=;
        b=Urtinqtoh2kB7ZXwoUaH4YJ91Vr4IhEP0VXr1GVkvzbeAA/JSCmmy74f51F0TXma3G
         DdrtYHhpoSzWJnNEXa6r+Mf+S5IdCdEMEmGRqkpTiUKiQQcE98l3BGmNa8bVlxoipDFV
         gDPPh/j6Nvt1qun9+Wkkk5xXmK1Qmn+gG/JlmINxvqzzpR8AHbwIliequTkm6b3nsGja
         RoMtFn/v1HqSZMzZuhtelnjAMCB0q8Xpy6VOgFpbxnineaMYpdpeXScKWMSgFB0Dhse1
         Vg9DvmYYJ0JgCxFqbRC5ybidKmZtnjDkvwl/qfXFMDbWiWgrGvG3dEs/4DkqzEiCzPnO
         7jpw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=hm01CGexkoLYwdctde6xGXd/63Q5F3tNzbQ7JrfTmc4=;
        b=XyhLL3QQMJn2xNqFjR+7gMw36sZPqJWOocoiBY9wrJtG+Q5MMwHZ2ljRFvjaIPh48Q
         xN57tj1zP9XLLhxHf9dTostGQcxEyibJESBXrMfqimb6R03NMZOV40lQIlXPjHSF23B4
         Z7ox6qUEd8q4MXiE3AN8A1Nep3qp3vntnEkAi68u+oes9hwOVSfWHA3WZWScYTWRDi8J
         cVKBRENuI6acQIOOaRDs00EprkqFkcqrohPRHymxYbSTKtWlBM3YULjgOiWlbTbjraxX
         EQc4r+HNl+7UhEnpB+hpuaHjTGXlDhYyu/5OWWothx8r2SpOr0i9ecg2+jr1+B8hFH0s
         Phvg==
X-Gm-Message-State: AJcUukeT8Tb4Cm8NWVgtDhGK4OMiR0TCcYV6SEwIYsF5JFY/hOwFzRSx
        L4gqIhJLqQCDmVX+U/IkWsnLzIZL
X-Google-Smtp-Source: ALg8bN4vo4eyIAWSGESjVKVZLMc7w/zegN6Ux3kas5AN2x8T3ZQVf0EXNT1Vx39z21nMqkauqFPoIw==
X-Received: by 2002:a63:585c:: with SMTP id i28mr1823762pgm.178.1546959143938;
        Tue, 08 Jan 2019 06:52:23 -0800 (PST)
Received: from localhost.localdomain ([240f:34:212d:1:5cb2:2bb:ff67:c70d])
        by smtp.gmail.com with ESMTPSA id n78sm53546990pfk.19.2019.01.08.06.52.21
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Tue, 08 Jan 2019 06:52:23 -0800 (PST)
From:   Akinobu Mita <akinobu.mita@gmail.com>
To:     linux-media@vger.kernel.org, devicetree@vger.kernel.org
Cc:     Akinobu Mita <akinobu.mita@gmail.com>,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
Subject: [PATCH v2 04/13] media: mt9m001: sort headers alphabetically
Date:   Tue,  8 Jan 2019 23:51:41 +0900
Message-Id: <1546959110-19445-5-git-send-email-akinobu.mita@gmail.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1546959110-19445-1-git-send-email-akinobu.mita@gmail.com>
References: <1546959110-19445-1-git-send-email-akinobu.mita@gmail.com>
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Sort header block alphabetically for easy maintenance.

Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: Sakari Ailus <sakari.ailus@linux.intel.com>
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>
Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
---
* New patch from v2

 drivers/media/i2c/mt9m001.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/media/i2c/mt9m001.c b/drivers/media/i2c/mt9m001.c
index c0b6b0c..dc6cf46 100644
--- a/drivers/media/i2c/mt9m001.c
+++ b/drivers/media/i2c/mt9m001.c
@@ -5,17 +5,17 @@
  * Copyright (C) 2008, Guennadi Liakhovetski <kernel@pengutronix.de>
  */
 
-#include <linux/videodev2.h>
-#include <linux/slab.h>
 #include <linux/i2c.h>
 #include <linux/log2.h>
 #include <linux/module.h>
+#include <linux/slab.h>
+#include <linux/videodev2.h>
 
-#include <media/soc_camera.h>
 #include <media/drv-intf/soc_mediabus.h>
+#include <media/soc_camera.h>
 #include <media/v4l2-clk.h>
-#include <media/v4l2-subdev.h>
 #include <media/v4l2-ctrls.h>
+#include <media/v4l2-subdev.h>
 
 /*
  * mt9m001 i2c address 0x5d
-- 
2.7.4

