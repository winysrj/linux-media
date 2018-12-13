Return-Path: <SRS0=yFxv=OW=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 20601C65BAE
	for <linux-media@archiver.kernel.org>; Thu, 13 Dec 2018 15:39:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DD6D8208E7
	for <linux-media@archiver.kernel.org>; Thu, 13 Dec 2018 15:39:13 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="veYyEAOT"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org DD6D8208E7
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-media-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729196AbeLMPjN (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Thu, 13 Dec 2018 10:39:13 -0500
Received: from mail-lf1-f67.google.com ([209.85.167.67]:39729 "EHLO
        mail-lf1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728983AbeLMPjN (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 13 Dec 2018 10:39:13 -0500
Received: by mail-lf1-f67.google.com with SMTP id n18so1895660lfh.6
        for <linux-media@vger.kernel.org>; Thu, 13 Dec 2018 07:39:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=I/WeZtUIF/kAVoZSlRa9CMWzDdQmisHIbkScuIUoHRM=;
        b=veYyEAOTwyCNgkpiBvWzlznlimAfFuJTcxp/Rz4D6zzMbGk/iwzFKm0arGOPP/uU/9
         oIakF+ZefGxmdSNMSYm4W5GssNpd+AA2ZxIJ8emFrKu8XXFjgnIxL9S4x53gY0jZIPIk
         P7igIgTboyxg68Ic9C2PHg948LfjGrm13lWjFgStki95iPeoxaMedf4yiWK5RTKqI74e
         JIQsuyyNbgQQ+Q864DIQWOVz4NB83kd8CvQWLI71moI1wSr3+MwH2KxNBae4MTNKXKtM
         5bWQ6YTyk2L8ay1v+2erk3E45fxosAN2uH1yN0Va1/ChG+gMX5I4zR+xPQECDwwG4Sj9
         bwqQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=I/WeZtUIF/kAVoZSlRa9CMWzDdQmisHIbkScuIUoHRM=;
        b=MBo39JMrnwAKbSUWx4TiSrVwrmXi37c6Jv9nVxDN//dFwlEBzLuZYJQKik481LpnXR
         gTjPAt6fSn2r8WJpLYzOuWwcPjCxe/mjrxtTFOL7jTuw7nKp+LttkxbRTg3uc1t0dbK2
         PztjhPtW5YHfaH9E2SsXumR87LIbtp68kNkN3o8Kw9RImG9KaE03nreJeH/+2PV61oa1
         Cs07mRZDATs6NadbwF6yv43qwJ0ybVxfJZT1jca9WSC5h+0KC5RDkeAA/m2wKJE7On1d
         zcWXztM4EMkZiwXHlAAyhP69879uFE6VWxvFxYwbo9/gms9I9rQAtpFHDZq0ZUB4Jpp2
         6/KA==
X-Gm-Message-State: AA+aEWaaw63CEOUU7O9RGWmlqQ1Zub5MFeA2WzVXtROenKz5JiS7TWK5
        JWun5jTnZ8WDUHeDT8UXjHA=
X-Google-Smtp-Source: AFSGD/VMZSdX3mi2JU5w69JMo5Hy9lgahLqRGxEmp6+h5pBojMwKpV1QgzLILICJaVS9pZEn9sBjOg==
X-Received: by 2002:a19:789:: with SMTP id 131mr15253446lfh.11.1544715550251;
        Thu, 13 Dec 2018 07:39:10 -0800 (PST)
Received: from kontron.lan (2001-1ae9-0ff1-f191-41f2-812a-df1c-0485.ip6.tmcz.cz. [2001:1ae9:ff1:f191:41f2:812a:df1c:485])
        by smtp.gmail.com with ESMTPSA id q67sm412869lfe.19.2018.12.13.07.39.08
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 13 Dec 2018 07:39:09 -0800 (PST)
From:   petrcvekcz@gmail.com
X-Google-Original-From: petrcvekcz.gmail.com
To:     hans.verkuil@cisco.com, jacopo@jmondi.org, mchehab@kernel.org,
        marek.vasut@gmail.com
Cc:     Petr Cvek <petrcvekcz@gmail.com>, linux-media@vger.kernel.org,
        robert.jarzmik@free.fr, slapin@ossfans.org,
        philipp.zabel@gmail.com, sakari.ailus@iki.fi
Subject: [PATCH v3 4/8] media: i2c: ov9640: add missing SPDX identifiers
Date:   Thu, 13 Dec 2018 16:39:15 +0100
Message-Id: <3b92813bc04a177cab684a1f2c8d77f6e2e5560e.1544713575.git.petrcvekcz@gmail.com>
X-Mailer: git-send-email 2.20.0
In-Reply-To: <cover.1544713575.git.petrcvekcz@gmail.com>
References: <cover.1544713575.git.petrcvekcz@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

From: Petr Cvek <petrcvekcz@gmail.com>

Add missing SPDX identifiers to .c and .h files of the sensor driver.

Signed-off-by: Petr Cvek <petrcvekcz@gmail.com>
---
 drivers/media/i2c/ov9640.c | 5 +----
 drivers/media/i2c/ov9640.h | 5 +----
 2 files changed, 2 insertions(+), 8 deletions(-)

diff --git a/drivers/media/i2c/ov9640.c b/drivers/media/i2c/ov9640.c
index 1f7cf01d037f..9a6fa609e8c4 100644
--- a/drivers/media/i2c/ov9640.c
+++ b/drivers/media/i2c/ov9640.c
@@ -1,3 +1,4 @@
+// SPDX-License-Identifier: GPL-2.0
 /*
  * OmniVision OV96xx Camera Driver
  *
@@ -14,10 +15,6 @@
  * Copyright 2006-7 Jonathan Corbet <corbet@lwn.net>
  * Copyright (C) 2008 Magnus Damm
  * Copyright (C) 2008, Guennadi Liakhovetski <kernel@pengutronix.de>
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License version 2 as
- * published by the Free Software Foundation.
  */
 
 #include <linux/init.h>
diff --git a/drivers/media/i2c/ov9640.h b/drivers/media/i2c/ov9640.h
index be5e4b29ac69..a8ed6992c1a8 100644
--- a/drivers/media/i2c/ov9640.h
+++ b/drivers/media/i2c/ov9640.h
@@ -1,11 +1,8 @@
+/* SPDX-License-Identifier: GPL-2.0 */
 /*
  * OmniVision OV96xx Camera Header File
  *
  * Copyright (C) 2009 Marek Vasut <marek.vasut@gmail.com>
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License version 2 as
- * published by the Free Software Foundation.
  */
 
 #ifndef	__DRIVERS_MEDIA_VIDEO_OV9640_H__
-- 
2.20.0

