Return-Path: <SRS0=AYlV=OX=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 90B61C43387
	for <linux-media@archiver.kernel.org>; Fri, 14 Dec 2018 16:40:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 39B70206C2
	for <linux-media@archiver.kernel.org>; Fri, 14 Dec 2018 16:40:49 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="PypQdqBI"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730200AbeLNQkr (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Fri, 14 Dec 2018 11:40:47 -0500
Received: from mail-wm1-f65.google.com ([209.85.128.65]:50675 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729619AbeLNQkr (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 14 Dec 2018 11:40:47 -0500
Received: by mail-wm1-f65.google.com with SMTP id n190so6315133wmd.0
        for <linux-media@vger.kernel.org>; Fri, 14 Dec 2018 08:40:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=lQVSNSAnQ5BA6yU8XgWw7eEzETxjR2LJ00O6uFVQmNg=;
        b=PypQdqBIJ/o1wWI6LRLsNAqVkUlmVDrukWw9U9J91W92JXSVLRWpudgMGncAvEZLva
         ayC4gEtdmi23CGHyumvxwJGzloY6Fl/OIBPdVZCrGUEuj2eiU32J7B7oOAbSSTVeqQUg
         aUYimdBH2PVbCyD7dsC5wPFX2Tl7VZgG9y90CBJTX5bzlW94z+BpLKENX1vJD0WGmiK6
         hwPAn6snILtisTo5oMIg1zhOQ+RAuHse/CCNqwoHEAZFBbKZgKMwCP9gLCcVlp/gtrBk
         d6LFW7pazudK8AY5qKBDQXjguqSqtYvOzCqT96EGS21nPBle4Cr1qtvJYV8LrwdRILwf
         pPZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=lQVSNSAnQ5BA6yU8XgWw7eEzETxjR2LJ00O6uFVQmNg=;
        b=bSzaT8OR+sGD3HR63xK7HCTk/y12vc9zK+cEUtkxuK1/cieGzHsmqmLWV0bpS7kjBi
         2MnKU+GW6oWTwO+zuat0GELASreWzCHyabHEzy8kBcMAd2EhNmoZ18JIg0hKMqXhOrsj
         I/TGTg2GJHCYmoDOAFJekM3Gn/TEhvRQbm0xFD5CcwSzSuWqUimHVTaIC5fPCDCjVPFr
         XOy/5b4bpI7x7R3M4UqUBKmIhxE5xNnHLHtiB81b/jTxdVoYCfcmGHQbS5XIBUEgACo4
         47Ryf2fENZvjcvI/xW/6ym1zlVzX66AJsx6uC0zSfZfSVtfXNH/pu3B/c+f0IYQtF86i
         pYlA==
X-Gm-Message-State: AA+aEWZurLbpNr8Cvf2PSqY0lmVxvaVryCgUN2vmjzCCqls6flHiIcaL
        zS16kKb1CY1qaPSXE9+f+qztlUf/
X-Google-Smtp-Source: AFSGD/VEvteqpRHinbu+j0vV+uePOrI1bYxc1pSWKvtL6OpGnesxgpbX+iGqUEjewt0d4VCj/c8yzg==
X-Received: by 2002:a1c:68d7:: with SMTP id d206mr3685799wmc.43.1544805644899;
        Fri, 14 Dec 2018 08:40:44 -0800 (PST)
Received: from ped.lan (ip5f5abcae.dynamic.kabel-deutschland.de. [95.90.188.174])
        by smtp.googlemail.com with ESMTPSA id c13sm7680392wrb.38.2018.12.14.08.40.43
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 14 Dec 2018 08:40:43 -0800 (PST)
From:   Philipp Zabel <philipp.zabel@gmail.com>
To:     linux-media@vger.kernel.org
Cc:     Hans Verkuil <hverkuil@xs4all.nl>,
        Philipp Zabel <philipp.zabel@gmail.com>
Subject: [PATCH 4/8] media: gspca: ov543-ov772x: move video format specific registers into bridge_start
Date:   Fri, 14 Dec 2018 17:40:27 +0100
Message-Id: <20181214164031.16757-5-philipp.zabel@gmail.com>
X-Mailer: git-send-email 2.20.0
In-Reply-To: <20181214164031.16757-1-philipp.zabel@gmail.com>
References: <20181214164031.16757-1-philipp.zabel@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

In preparation for adding SGBRG8 as a second video format besides YUYV,
move video format specific register settings from the bridge_init array
into the bridge_start arrays.

Signed-off-by: Philipp Zabel <philipp.zabel@gmail.com>
---
 drivers/media/usb/gspca/ov534.c | 19 ++++++++++---------
 1 file changed, 10 insertions(+), 9 deletions(-)

diff --git a/drivers/media/usb/gspca/ov534.c b/drivers/media/usb/gspca/ov534.c
index 44f06a58bb67..077c49a74709 100644
--- a/drivers/media/usb/gspca/ov534.c
+++ b/drivers/media/usb/gspca/ov534.c
@@ -411,9 +411,7 @@ static const u8 sensor_start_qvga_767x[][2] = {
 };
 
 static const u8 bridge_init_772x[][2] = {
-	{ 0xc2, 0x0c },
 	{ 0x88, 0xf8 },
-	{ 0xc3, 0x69 },
 	{ 0x89, 0xff },
 	{ 0x76, 0x03 },
 	{ 0x92, 0x01 },
@@ -439,7 +437,6 @@ static const u8 bridge_init_772x[][2] = {
 	{ 0x1f, 0x81 },
 	{ 0x34, 0x05 },
 	{ 0xe3, 0x04 },
-	{ 0x88, 0x00 },
 	{ 0x89, 0x00 },
 	{ 0x76, 0x00 },
 	{ 0xe7, 0x2e },
@@ -460,13 +457,7 @@ static const u8 bridge_init_772x[][2] = {
 	{ 0x1d, 0x08 }, /* turn on UVC header */
 	{ 0x1d, 0x0e }, /* .. */
 
-	{ 0x8d, 0x1c },
-	{ 0x8e, 0x80 },
 	{ 0xe5, 0x04 },
-
-	{ 0xc0, 0x50 },
-	{ 0xc1, 0x3c },
-	{ 0xc2, 0x0c },
 };
 static const u8 sensor_init_772x[][2] = {
 	{ 0x12, 0x80 },
@@ -562,6 +553,7 @@ static const u8 sensor_init_772x[][2] = {
 	{ 0x0c, 0xd0 }
 };
 static const u8 bridge_start_vga_772x[][2] = {
+	{0x88, 0x00},
 	{0x1c, 0x00},
 	{0x1d, 0x40},
 	{0x1d, 0x02},
@@ -569,8 +561,12 @@ static const u8 bridge_start_vga_772x[][2] = {
 	{0x1d, 0x02},
 	{0x1d, 0x58},
 	{0x1d, 0x00},
+	{0x8d, 0x1c},
+	{0x8e, 0x80},
 	{0xc0, 0x50},
 	{0xc1, 0x3c},
+	{0xc2, 0x0c},
+	{0xc3, 0x69},
 };
 static const u8 sensor_start_vga_772x[][2] = {
 	{0x12, 0x00},
@@ -583,6 +579,7 @@ static const u8 sensor_start_vga_772x[][2] = {
 	{0x65, 0x20},
 };
 static const u8 bridge_start_qvga_772x[][2] = {
+	{0x88, 0x00},
 	{0x1c, 0x00},
 	{0x1d, 0x40},
 	{0x1d, 0x02},
@@ -590,8 +587,12 @@ static const u8 bridge_start_qvga_772x[][2] = {
 	{0x1d, 0x01},
 	{0x1d, 0x4b},
 	{0x1d, 0x00},
+	{0x8d, 0x1c},
+	{0x8e, 0x80},
 	{0xc0, 0x28},
 	{0xc1, 0x1e},
+	{0xc2, 0x0c},
+	{0xc3, 0x69},
 };
 static const u8 sensor_start_qvga_772x[][2] = {
 	{0x12, 0x40},
-- 
2.20.0

