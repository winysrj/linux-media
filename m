Return-Path: <SRS0=AYlV=OX=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 58D28C43444
	for <linux-media@archiver.kernel.org>; Fri, 14 Dec 2018 16:40:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0088D206C2
	for <linux-media@archiver.kernel.org>; Fri, 14 Dec 2018 16:40:51 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="YajAzYuE"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730252AbeLNQku (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Fri, 14 Dec 2018 11:40:50 -0500
Received: from mail-wm1-f67.google.com ([209.85.128.67]:54556 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729619AbeLNQku (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 14 Dec 2018 11:40:50 -0500
Received: by mail-wm1-f67.google.com with SMTP id a62so6282586wmh.4
        for <linux-media@vger.kernel.org>; Fri, 14 Dec 2018 08:40:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=x3debq00P5WewIt9MnNKItc/RT+GqN8aHZOxBKL/8LI=;
        b=YajAzYuENeK2+C+6ETwHMdsQDI90B4vSyOjPzdMrB1aUKwUySRwH/vz8dKQ8oTOIqo
         ZSoRuthsQ8oAIiJEQ+Z7fG0PzmSRjGDdt6uUogDGuTTiWGP6xlqlkdl8p6jylqPJjQIs
         j77P8nWx8vIeZRLoMwajH9hi/5/IZP/QwQGChhHimcOC3x0YyoCBBMHIBY0AtdrfYTAd
         H1bVHXEI5unjaAyOU19koMGR+G5V6xgZTOUjBjFRdgqQc1M0Su+LSEdnR2bWML7kXogX
         UuHk28VOktD2vX0ujP6gSHAbY6Y7HV6wqMT+nF+DGxnMkksaNJjIDq0LGJWGJbtlaLpU
         Y2WA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=x3debq00P5WewIt9MnNKItc/RT+GqN8aHZOxBKL/8LI=;
        b=YZE+DibGVRi0IDWHMMyfXc2J/Wr0iDBpVUs4Hh7ye6+Ka8xR6nEMueWyB04Ni/HV8X
         jDQSRwpmCQofJ5B4YPXVdZzS7RwZJKA6TPcnE5SAmOx3Ka03GcEY+tJj3Xo1ZOVSj5+D
         Q8x0gqFKn4Hnb+gmYQR5cCvLbfN3t1w5oxXGH3Bd7bCw+8w/Mx2jo01e5ly2m/aOget0
         m5l+YzritrYTXlBGarJx6rREe55th/oQJU5cJVaMPjczdGGKqdGy2MVNMP+ffPoBW2Fs
         OaSI60LGBDr2+tzNiBT/EuP0YaVA6v+yL5VHFLX+YM97vlEzyy53Uaq9lW5Mwn/cqnwH
         SSVA==
X-Gm-Message-State: AA+aEWZhLQfhYcAae4ClMGgb/lmwNk78roZR3xI3W4szE8YH6IDqSLdW
        kqa7Hd356Ze8q0EZqX2fX6e8fi+W
X-Google-Smtp-Source: AFSGD/Uo0NyPKgFZMeLHLWNDPuGyGGUr4HBqd/q1/uC9ySw1pnqWdM/KYSPw4O+lHofmNbif2t8K8w==
X-Received: by 2002:a1c:da0c:: with SMTP id r12mr3771255wmg.54.1544805647789;
        Fri, 14 Dec 2018 08:40:47 -0800 (PST)
Received: from ped.lan (ip5f5abcae.dynamic.kabel-deutschland.de. [95.90.188.174])
        by smtp.googlemail.com with ESMTPSA id c13sm7680392wrb.38.2018.12.14.08.40.46
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 14 Dec 2018 08:40:46 -0800 (PST)
From:   Philipp Zabel <philipp.zabel@gmail.com>
To:     linux-media@vger.kernel.org
Cc:     Hans Verkuil <hverkuil@xs4all.nl>,
        Philipp Zabel <philipp.zabel@gmail.com>
Subject: [PATCH 6/8] media: gspca: ov534-ov722x: remove mode specific video data registers from bridge_init
Date:   Fri, 14 Dec 2018 17:40:29 +0100
Message-Id: <20181214164031.16757-7-philipp.zabel@gmail.com>
X-Mailer: git-send-email 2.20.0
In-Reply-To: <20181214164031.16757-1-philipp.zabel@gmail.com>
References: <20181214164031.16757-1-philipp.zabel@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

The video format, payload size, and frame size setup is video format
and frame size specific. Those registers are overwritten during
bridge_start anyway.

Signed-off-by: Philipp Zabel <philipp.zabel@gmail.com>
---
 drivers/media/usb/gspca/ov534.c | 9 ---------
 1 file changed, 9 deletions(-)

diff --git a/drivers/media/usb/gspca/ov534.c b/drivers/media/usb/gspca/ov534.c
index 5b73f7f58ae6..bc9d2eb5db30 100644
--- a/drivers/media/usb/gspca/ov534.c
+++ b/drivers/media/usb/gspca/ov534.c
@@ -462,15 +462,6 @@ static const u8 bridge_init_772x[][2] = {
 	{ 0x25, 0x42 },
 	{ 0x21, 0xf0 },
 
-	{ 0x1c, 0x00 },
-	{ 0x1d, 0x40 },
-	{ 0x1d, 0x02 }, /* payload size 0x0200 * 4 = 2048 bytes */
-	{ 0x1d, 0x00 }, /* payload size */
-
-	{ 0x1d, 0x02 }, /* frame size 0x025800 * 4 = 614400 */
-	{ 0x1d, 0x58 }, /* frame size */
-	{ 0x1d, 0x00 }, /* frame size */
-
 	{ 0x1c, 0x0a },
 	{ 0x1d, 0x08 }, /* turn on UVC header */
 	{ 0x1d, 0x0e }, /* .. */
-- 
2.20.0

