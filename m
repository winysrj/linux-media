Return-Path: <SRS0=EeSY=QP=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F142AC282CB
	for <linux-media@archiver.kernel.org>; Fri,  8 Feb 2019 14:53:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C0EEC2177B
	for <linux-media@archiver.kernel.org>; Fri,  8 Feb 2019 14:53:09 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="jpabZfit"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727922AbfBHOxJ (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Fri, 8 Feb 2019 09:53:09 -0500
Received: from mail-pf1-f195.google.com ([209.85.210.195]:32840 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727843AbfBHOxJ (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 8 Feb 2019 09:53:09 -0500
Received: by mail-pf1-f195.google.com with SMTP id c123so1786105pfb.0
        for <linux-media@vger.kernel.org>; Fri, 08 Feb 2019 06:53:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=+vQIvwaVLnJA1QF80FFX3nvXI4vUF8xq+erNRgM0s98=;
        b=jpabZfitwpGja84KxoqN/Jp5ylLllTRYu7OI8LncGmFPyHSoruKc7Ptk58UC42Ct12
         htfu4ZNNOjstrCLCpbQeMWf0iZgoOhODadq9agkQknQa+/kOXqE3nJmy/0Q4Er2hZ/hs
         rYtKTlcKq/WAk7AflF71LFUXJI+JDcGrl7+U+AKyDIbmptEmpQJX+San1/R2kukfasPT
         2GFdpL93f3bKCmlt58eHTzVxSYcHC/FMV1CgbkqwSctR/002LKlz7xaGPcM80Lsu9J2T
         Z6017b249JL1npW0mY6523YCZcbkFTGHlIUV8Qfcucy94SUtTtUy+rUMr8gmNB3YVwIg
         W+mA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=+vQIvwaVLnJA1QF80FFX3nvXI4vUF8xq+erNRgM0s98=;
        b=QqP/W+4UMbCctII20aLGpSXKhu8H8I9/HCRzUI4Hdn1PPDGyDtqd4HF2wnwbdC2u+V
         1/SCEF2hNwfJrUqkAT4ENb0yVIsYT+IYmmHVAUG9wdTVSmhCnOhAdYpmT2otO6anrhiW
         oQUXNq0R7fZpXjJA88NaoacFGhC20TXZDA01ZswBk0pnHlWv0oP1Yieax0UQOMo/xO4m
         w/1kflfj4pcee6GaF2rFFDHpPmvq0d0qebEQogMsbAHTH3hRApQpFaYF4HX66y3irz6Y
         VSG/v85Qt7o8NE+E4PToFutHv7PagUqwq7wMfYpc0g3U1tyXTO5o3ynLFJYAksqn+U38
         69ZQ==
X-Gm-Message-State: AHQUAubC9KmqQlEf7A92iTa84C1gMuTe3r2egjbIEW4t/oLFy6B5iX1a
        UTnMjgNv0fSERHuUlTuGs9cYm8NmhR4=
X-Google-Smtp-Source: AHgI3IZDHqbN6PzAnyLFn/23P90xFiOMT29uxqcpuUFXjEDO8sOxfKr3iAatTmfRVRJyNUTm/oI1Yw==
X-Received: by 2002:a62:26c7:: with SMTP id m190mr22951932pfm.79.1549637587965;
        Fri, 08 Feb 2019 06:53:07 -0800 (PST)
Received: from localhost.localdomain ([240f:34:212d:1:9dad:5819:2ad0:da6f])
        by smtp.gmail.com with ESMTPSA id s79sm3425216pgs.50.2019.02.08.06.53.06
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Fri, 08 Feb 2019 06:53:07 -0800 (PST)
From:   Akinobu Mita <akinobu.mita@gmail.com>
To:     linux-media@vger.kernel.org
Cc:     Akinobu Mita <akinobu.mita@gmail.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
Subject: [PATCH 4/4] media: i2c: remove redundant MEDIA_CONTROLLER dependency
Date:   Fri,  8 Feb 2019 23:52:45 +0900
Message-Id: <1549637565-32096-5-git-send-email-akinobu.mita@gmail.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1549637565-32096-1-git-send-email-akinobu.mita@gmail.com>
References: <1549637565-32096-1-git-send-email-akinobu.mita@gmail.com>
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

VIDEO_V4L2_SUBDEV_API depends on MEDIA_CONTROLLER, so depending on both
two is redundant.

Cc: Sakari Ailus <sakari.ailus@linux.intel.com>
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>
Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
---
 drivers/media/i2c/Kconfig | 10 +++-------
 1 file changed, 3 insertions(+), 7 deletions(-)

diff --git a/drivers/media/i2c/Kconfig b/drivers/media/i2c/Kconfig
index 73eeb17..32f7011 100644
--- a/drivers/media/i2c/Kconfig
+++ b/drivers/media/i2c/Kconfig
@@ -329,8 +329,7 @@ config VIDEO_AD5820
 
 config VIDEO_AK7375
 	tristate "AK7375 lens voice coil support"
-	depends on I2C && VIDEO_V4L2 && MEDIA_CONTROLLER
-	depends on VIDEO_V4L2_SUBDEV_API
+	depends on I2C && VIDEO_V4L2 && VIDEO_V4L2_SUBDEV_API
 	help
 	  This is a driver for the AK7375 camera lens voice coil.
 	  AK7375 is a 12 bit DAC with 120mA output current sink
@@ -339,8 +338,7 @@ config VIDEO_AK7375
 
 config VIDEO_DW9714
 	tristate "DW9714 lens voice coil support"
-	depends on I2C && VIDEO_V4L2 && MEDIA_CONTROLLER
-	depends on VIDEO_V4L2_SUBDEV_API
+	depends on I2C && VIDEO_V4L2 && VIDEO_V4L2_SUBDEV_API
 	---help---
 	  This is a driver for the DW9714 camera lens voice coil.
 	  DW9714 is a 10 bit DAC with 120mA output current sink
@@ -349,8 +347,7 @@ config VIDEO_DW9714
 
 config VIDEO_DW9807_VCM
 	tristate "DW9807 lens voice coil support"
-	depends on I2C && VIDEO_V4L2 && MEDIA_CONTROLLER
-	depends on VIDEO_V4L2_SUBDEV_API
+	depends on I2C && VIDEO_V4L2 && VIDEO_V4L2_SUBDEV_API
 	---help---
 	  This is a driver for the DW9807 camera lens voice coil.
 	  DW9807 is a 10 bit DAC with 100mA output current sink
@@ -747,7 +744,6 @@ config VIDEO_OV5670
 	tristate "OmniVision OV5670 sensor support"
 	depends on I2C && VIDEO_V4L2 && VIDEO_V4L2_SUBDEV_API
 	depends on MEDIA_CAMERA_SUPPORT
-	depends on MEDIA_CONTROLLER
 	select V4L2_FWNODE
 	---help---
 	  This is a Video4Linux2 sensor driver for the OmniVision
-- 
2.7.4

