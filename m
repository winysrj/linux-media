Return-Path: <SRS0=AYlV=OX=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 69303C43387
	for <linux-media@archiver.kernel.org>; Fri, 14 Dec 2018 16:40:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 105EF206E0
	for <linux-media@archiver.kernel.org>; Fri, 14 Dec 2018 16:40:56 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="T+UWouVe"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730073AbeLNQkx (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Fri, 14 Dec 2018 11:40:53 -0500
Received: from mail-wm1-f67.google.com ([209.85.128.67]:38156 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730263AbeLNQkx (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 14 Dec 2018 11:40:53 -0500
Received: by mail-wm1-f67.google.com with SMTP id m22so6435332wml.3
        for <linux-media@vger.kernel.org>; Fri, 14 Dec 2018 08:40:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=kzhQWoew42A1nYV5l020Z5/UB55GqT3SXwsSzqRKNR8=;
        b=T+UWouVeddM1syzeZs+j3efcPCjbAVd1/FQyHjUEmMWybPm5OQZLENvLPfNREi73bo
         SXIWPnGynxNdUrmgNLYn5NgWUt0Ooesmk0NkOLIY6NVF3hIJAObsVSR1laC7RHakPHD3
         kP6c9Wi9YYyKjXTZddSckaE4jBn5eYkWSYovzvntWATy32JZxE0ijnHgGADAphWM4ZJG
         Sp8SBjcJIfaNzUSI0t7ExhKB16lqQw6Q7magTy192hSK7iv9yL3++0lUq38uGDEIn5Ym
         x9wSNG+NEDzBjPDFywqYcQem9v6BsddnigPDW7kBpcNPMonFM3RPGC4XLBx0u/HNwkD/
         TmtA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=kzhQWoew42A1nYV5l020Z5/UB55GqT3SXwsSzqRKNR8=;
        b=F1QnIrIsHSbsVDI7mn0kw4FDLBw4mtI1yVV2guEInugdjPbWvhaYlcqoI3+DyX+IGY
         tRp8A6sVdb6K4p1iO+VJSDhRbAk1tA5E1xmkNkPU5O9LKsdQyJXXxM3QIWxh3gdM7OkP
         XAyLiKhb14lCoaDly9apCNOnnPCc283xXOQN0QZIlLZwzQHyYJFmjgewcAOJgvYo6Z2t
         SKlplnN3jESw4zGBbx99bSau5UPCmrb7fC6EzAJYQiV2BEb3gwRqiUk91sPZM8ak8hY4
         K71nvZJ0JMeaC25/s8dk0dsEqGCchgZajnU8TzyW9GdzrxeLt3mPI9KUD0DKqfNFFbK+
         ndng==
X-Gm-Message-State: AA+aEWZYL3RE65rsPCvp5WKnn5LaPD2LsN4enNYZxiANRG8I4qR8dags
        9EAK3CALIfg8OYLnazCJpqHddkfW
X-Google-Smtp-Source: AFSGD/WTljKW5tdKXHiATxeLtAoc43LYQs6Ww0NPK3+OM+cXe3sVhUwq223JRXu7CxS84aIMJYeurA==
X-Received: by 2002:a1c:1d2:: with SMTP id 201mr4160229wmb.69.1544805650762;
        Fri, 14 Dec 2018 08:40:50 -0800 (PST)
Received: from ped.lan (ip5f5abcae.dynamic.kabel-deutschland.de. [95.90.188.174])
        by smtp.googlemail.com with ESMTPSA id c13sm7680392wrb.38.2018.12.14.08.40.49
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 14 Dec 2018 08:40:49 -0800 (PST)
From:   Philipp Zabel <philipp.zabel@gmail.com>
To:     linux-media@vger.kernel.org
Cc:     Hans Verkuil <hverkuil@xs4all.nl>,
        Philipp Zabel <philipp.zabel@gmail.com>
Subject: [PATCH 8/8] media: gspca: ov534-ov772x: remove unnecessary COM3 initialization
Date:   Fri, 14 Dec 2018 17:40:31 +0100
Message-Id: <20181214164031.16757-9-philipp.zabel@gmail.com>
X-Mailer: git-send-email 2.20.0
In-Reply-To: <20181214164031.16757-1-philipp.zabel@gmail.com>
References: <20181214164031.16757-1-philipp.zabel@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

The COM3 register at address 0x0c already defaults to 0x10, the two bits
COM3[7:6] are set according to V4L2 controls by sethvflip later.
There is no need to set it multiple times during bridge initialization.

Signed-off-by: Philipp Zabel <philipp.zabel@gmail.com>
---
 drivers/media/usb/gspca/ov534.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/drivers/media/usb/gspca/ov534.c b/drivers/media/usb/gspca/ov534.c
index 23deeedd3279..02c90ad96b76 100644
--- a/drivers/media/usb/gspca/ov534.c
+++ b/drivers/media/usb/gspca/ov534.c
@@ -543,13 +543,10 @@ static const u8 sensor_init_772x[][2] = {
 	{ 0x8c, 0xe8 },
 	{ 0x8d, 0x20 },
 
-	{ 0x0c, 0x90 },
-
 	{ 0x2b, 0x00 },
 	{ 0x22, 0x7f },
 	{ 0x23, 0x03 },
 	{ 0x11, 0x01 },
-	{ 0x0c, 0xd0 },
 	{ 0x64, 0xff },
 	{ 0x0d, 0x41 },
 
@@ -557,7 +554,6 @@ static const u8 sensor_init_772x[][2] = {
 	{ 0x0e, 0xcd },
 	{ 0xac, 0xbf },
 	{ 0x8e, 0x00 },		/* De-noise threshold */
-	{ 0x0c, 0xd0 }
 };
 static const u8 bridge_start_vga_yuyv_772x[][2] = {
 	{0x88, 0x00},
-- 
2.20.0

