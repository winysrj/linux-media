Return-Path: <SRS0=5UJH=RM=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 77808C43381
	for <linux-media@archiver.kernel.org>; Sat,  9 Mar 2019 17:51:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 43CD6207E0
	for <linux-media@archiver.kernel.org>; Sat,  9 Mar 2019 17:51:39 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="dstsnlXT"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726355AbfCIRvi (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Sat, 9 Mar 2019 12:51:38 -0500
Received: from mail-qk1-f196.google.com ([209.85.222.196]:34235 "EHLO
        mail-qk1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726286AbfCIRvi (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Sat, 9 Mar 2019 12:51:38 -0500
Received: by mail-qk1-f196.google.com with SMTP id n6so477820qkf.1
        for <linux-media@vger.kernel.org>; Sat, 09 Mar 2019 09:51:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=IEVhLCFHjIZ9YOZ332a4UfewczMVHB68ZMJWkKvP6Xg=;
        b=dstsnlXTrcNb1kIQn+7680Z/wQcxTGzwUrbQhczSvVAmTvNxIIZX5LtnQwV4QE5ni5
         3ne/isTFqMkBXetAU6M1UgER7vr6fW28SMfovAwsC3230aUJBnBPbNFug5U/1v7Antzc
         Nl2C7nrnAlzXCtlubD+Gue2DEkd8euN2/r5p2jLjGGDQkBklkbAngQ1HJ0Fk+vedWIau
         bLnAmEodwD/eVaveHfdY/LZjj8ryDIYMUyPHsyWa+LOl44lowViuGxTrgciPBRlOTYYT
         S8466C5rB2x31ZNYM9HoelhiKYfJTqYRjNcPk56uqDAkCb0JHNaSfIbQLXceZu7iaa1l
         4mHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=IEVhLCFHjIZ9YOZ332a4UfewczMVHB68ZMJWkKvP6Xg=;
        b=GwnCJggXfEbxmkS3rRvSCaJIBbCJf2ZZ0RXVV2RdpW3FIcy0w4FysihVpC/YdxB9/3
         ukMvJu9FbSbNtDmljuoKKmAkvWdgZZVg3W9+xAeNOupbQA7GxE5/x0OKH5Np980g3Hwk
         WJBCW1D+R7Bgb81iPiWZa5DeIjOSXC8zzJhJxoy2rfuUJgFpADTCQUHX3/uoIi9+yutn
         7jFi+SG63vXy/72M4pPUoKRMb+5bgMm4zkbv0lRvPi+hCvBs2f/CqIqGbYMfgle0JyFy
         c7FfR/3WJ7IMpTFiDV2iue9XyCLkmgXcrzXoKLpAEqRUwJyo+XowZk3sgRlFE8SXDKYw
         0K3A==
X-Gm-Message-State: APjAAAWcEqorBDod6WoxziVdnrJxiMrkz8U9FFpuqOetvh8MsUOBK1yP
        m7GUvxPwF8rVJeYdP0E3KzDE8MNi
X-Google-Smtp-Source: APXvYqwu37yPF7M/OdFCKcuqzi4QbVnekhb3mjDzSwiw6nxpdyrEuUFc59cAYCPTJt5D50O2qrNUzA==
X-Received: by 2002:a37:d88:: with SMTP id 130mr18477953qkn.314.1552153897370;
        Sat, 09 Mar 2019 09:51:37 -0800 (PST)
Received: from localhost.localdomain ([170.51.158.22])
        by smtp.gmail.com with ESMTPSA id b33sm555906qtc.14.2019.03.09.09.51.35
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 09 Mar 2019 09:51:36 -0800 (PST)
From:   claudiojpaz <claudiojpaz@gmail.com>
To:     mchehab@kernel.org, linux-media@vger.kernel.org
Cc:     claudiojpaz <claudiojpaz@gmail.com>
Subject: [PATCH] staging: media: zoran: Fixes a checkpatch.pl error in videocodec.c
Date:   Sat,  9 Mar 2019 14:50:00 -0300
Message-Id: <20190309175000.14685-1-claudiojpaz@gmail.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

ERROR: do not initialise statics to NULL

Signed-off-by: claudiojpaz <claudiojpaz@gmail.com>
---
 drivers/staging/media/zoran/videocodec.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/media/zoran/videocodec.c b/drivers/staging/media/zoran/videocodec.c
index 4427ae7126e2..044ef8455ba8 100644
--- a/drivers/staging/media/zoran/videocodec.c
+++ b/drivers/staging/media/zoran/videocodec.c
@@ -63,7 +63,7 @@ struct codec_list {
 	struct codec_list *next;
 };
 
-static struct codec_list *codeclist_top = NULL;
+static struct codec_list *codeclist_top;
 
 /* ================================================= */
 /* function prototypes of the master/slave interface */
-- 
2.20.1

