Return-Path: <SRS0=AYlV=OX=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8D8CDC43387
	for <linux-media@archiver.kernel.org>; Fri, 14 Dec 2018 16:40:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2C6E7206DD
	for <linux-media@archiver.kernel.org>; Fri, 14 Dec 2018 16:40:57 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="TEpvX+f0"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730269AbeLNQkw (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Fri, 14 Dec 2018 11:40:52 -0500
Received: from mail-wm1-f65.google.com ([209.85.128.65]:50681 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729923AbeLNQkv (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 14 Dec 2018 11:40:51 -0500
Received: by mail-wm1-f65.google.com with SMTP id n190so6315334wmd.0
        for <linux-media@vger.kernel.org>; Fri, 14 Dec 2018 08:40:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=edGN2e55Mash8D1PpsoVee7XbO7aYKpVlUUQ7NbLuos=;
        b=TEpvX+f0zr9o6eWTxF9g4LALbdI6L75UKIXQYAjlNB5ePfD4va+I+HEZ9PyS70Dl/x
         iqrGNC/2e+j15B1AjmqPCWhsSAn82hdzpmpJzrgpttO6OxKNAboWIEDT/X9j/aGAK0wr
         YXevwVcz+NZaYTEDwsX5yFTACbSHeGVTCfqJz8q9frxVcShSX21oNHVSFWIL/iqHsldg
         ekMKoPpVdOGSKCLm4cnL1UJU6PVIQEhJ0/1d40LFpaRTDZxhrN6JsnCAY5VPVZzP2KhA
         /iMlXgeXWPRbz1B9xZaQqHQdTAPtM1snOozIYRo+WD3KPRz38e8I/IyqehjBwJiI8nxm
         z6Gw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=edGN2e55Mash8D1PpsoVee7XbO7aYKpVlUUQ7NbLuos=;
        b=pXQCk9rC/tZdil7V3R3v0WpE/5PoBVhmtbNkmyGNFS83CoXCh0ViiJjdIIjTl7YP9M
         f8CCjq3xv85KL62FOuXKdxKCJhsSWJqRVk4bF4rro0Zu934vCkWJSJpBzVXM5OpQVeGB
         u98qsmjAeggaUaEOQo4/LKjVaSUIMHbZoAjzJhlkZInzg9tovPlWaodjpGPSCAJUyVjl
         xy1la/aEgJcVu3b+ZmCW3+qmZ0vARgcjcfO0JQMB+MIh4t8QbyI4ZBdzpLlq4VK08Zuh
         TXoMvocrdIOPAW5XpBy5WpVYTAJqSAZyGLdXyIbLTPRF32fJHIQlERN/WR8XboHuUlnz
         Do/Q==
X-Gm-Message-State: AA+aEWa0YlXPf1Z4F1xyKlGKlEgsolj3VYP8O0heuOxTV20cQ1slwP7c
        tTwCN2N7GrHrSjtKwSibEDMcQExa
X-Google-Smtp-Source: AFSGD/WXrxaSmPkyt1CCwcZhdQLlQi5RsTnl8fo/xRtC769/g79zZnNLbbyd+nQV+WlnAZBRh+AKjg==
X-Received: by 2002:a7b:cd85:: with SMTP id y5mr2232025wmj.129.1544805649034;
        Fri, 14 Dec 2018 08:40:49 -0800 (PST)
Received: from ped.lan (ip5f5abcae.dynamic.kabel-deutschland.de. [95.90.188.174])
        by smtp.googlemail.com with ESMTPSA id c13sm7680392wrb.38.2018.12.14.08.40.47
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 14 Dec 2018 08:40:48 -0800 (PST)
From:   Philipp Zabel <philipp.zabel@gmail.com>
To:     linux-media@vger.kernel.org
Cc:     Hans Verkuil <hverkuil@xs4all.nl>,
        Philipp Zabel <philipp.zabel@gmail.com>
Subject: [PATCH 7/8] media: gspca: ov534-ov722x: remove camera clock setup from bridge_init
Date:   Fri, 14 Dec 2018 17:40:30 +0100
Message-Id: <20181214164031.16757-8-philipp.zabel@gmail.com>
X-Mailer: git-send-email 2.20.0
In-Reply-To: <20181214164031.16757-1-philipp.zabel@gmail.com>
References: <20181214164031.16757-1-philipp.zabel@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

This register is later overwritten by set_frame_rate anyway.

Signed-off-by: Philipp Zabel <philipp.zabel@gmail.com>
---
 drivers/media/usb/gspca/ov534.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/media/usb/gspca/ov534.c b/drivers/media/usb/gspca/ov534.c
index bc9d2eb5db30..23deeedd3279 100644
--- a/drivers/media/usb/gspca/ov534.c
+++ b/drivers/media/usb/gspca/ov534.c
@@ -465,8 +465,6 @@ static const u8 bridge_init_772x[][2] = {
 	{ 0x1c, 0x0a },
 	{ 0x1d, 0x08 }, /* turn on UVC header */
 	{ 0x1d, 0x0e }, /* .. */
-
-	{ 0xe5, 0x04 },
 };
 static const u8 sensor_init_772x[][2] = {
 	{ 0x12, 0x80 },
-- 
2.20.0

