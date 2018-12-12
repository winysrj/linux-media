Return-Path: <SRS0=2Dg0=OV=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 98261C67839
	for <linux-media@archiver.kernel.org>; Wed, 12 Dec 2018 16:20:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5DA5820839
	for <linux-media@archiver.kernel.org>; Wed, 12 Dec 2018 16:20:23 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="pQvTQBJa"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 5DA5820839
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-media-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727691AbeLLQUS (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Wed, 12 Dec 2018 11:20:18 -0500
Received: from mail-pg1-f194.google.com ([209.85.215.194]:45200 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726879AbeLLQUS (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 12 Dec 2018 11:20:18 -0500
Received: by mail-pg1-f194.google.com with SMTP id y4so8527915pgc.12;
        Wed, 12 Dec 2018 08:20:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=6Q/+2+qK3okIZ1zaF6zOX7bxQDy3cH8F5XXDZkvzn0I=;
        b=pQvTQBJazVT5wuzAdIN01sbXVVwLqsdG3UjOUbZYtXgt9O1Q0M9LHr+wJvK7MOjxd5
         1OPzYRQOVG7r5Ta+8W9hEnZXPDOzW3QZDVTmpeaEdQSCxxkKziNJ0WKzyeiQiujI4E/j
         rGmybZZwMMsHUlq88CJiCB0Oa+vCNxDn4YsUijWHaWkhRZJWGFvuqRdybhCDEaTnCn3q
         Kz9yd2alymKBrJNRF19vRpd+vVpe+emBuCYsHP01xHY+9YWrKMUzb4KI47UOLZf/+MLh
         yCmJNeIy+4eL1DU0CMO0oMLddWGGtJXstkxzpXQcZZ9aLJ0T3jrF0c3NTEiB9WvtpXY9
         YLNw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=6Q/+2+qK3okIZ1zaF6zOX7bxQDy3cH8F5XXDZkvzn0I=;
        b=Fg27Gh4EsbOAgRhKFVZKSfhSa0pKhbBcCl55SqC+PnkGBBSJ1I6hmNaUgQEuifOYM1
         ctKm2NfJWFt3J2RENtFDpgj8nMmQDvG6rmsIch2D21JaDRI67Vaw6rQyxOC5YTX81D2A
         jwf2iDTFPL+Sy76jKRPuRiU94waN7IOvPkq1ekY3D8OvtaJP/oQe5xg4y6VlgBtvGwi1
         uxmETR+lDGZyKhbtbfUUrvz/3Dl5zIv7Avs7UAUV4mGVtxc01SHRc/pAVPkXQ2Kv1KT9
         bultD++k3TGlLvEYX3D93v867I6aLmgpeYKlvTLuNjaGr+JZMkNEAh+CDBYn7PXFtABI
         DYIQ==
X-Gm-Message-State: AA+aEWYSdJBtRQ7Rzg14KG7uZFtYhPAUkXYOe4eCaZZC2YTG1KO93tE1
        dM1fKnPHPJYHVbjMdeOMBz4=
X-Google-Smtp-Source: AFSGD/WGb+lQDbWNpoQEbGn7/dYu9dzescV2XMisM88YcFvhFjxPijOYP3QbAmqaUvl6tOebdz2krw==
X-Received: by 2002:a62:7086:: with SMTP id l128mr20645206pfc.68.1544631617047;
        Wed, 12 Dec 2018 08:20:17 -0800 (PST)
Received: from localhost (68.168.130.77.16clouds.com. [68.168.130.77])
        by smtp.gmail.com with ESMTPSA id z62sm27586179pfl.33.2018.12.12.08.20.16
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 12 Dec 2018 08:20:16 -0800 (PST)
From:   Yangtao Li <tiny.windzz@gmail.com>
To:     kyungmin.park@samsung.com, s.nawrocki@samsung.com,
        mchehab@kernel.org, kgene@kernel.org, krzk@kernel.org
Cc:     linux-media@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org,
        Yangtao Li <tiny.windzz@gmail.com>
Subject: [PATCH v3] media: exynos4-is: convert to DEFINE_SHOW_ATTRIBUTE
Date:   Wed, 12 Dec 2018 11:20:14 -0500
Message-Id: <20181212162014.23409-1-tiny.windzz@gmail.com>
X-Mailer: git-send-email 2.17.0
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Use DEFINE_SHOW_ATTRIBUTE macro to simplify the code.

Signed-off-by: Yangtao Li <tiny.windzz@gmail.com>
---
 drivers/media/platform/exynos4-is/fimc-is.c | 16 +++-------------
 1 file changed, 3 insertions(+), 13 deletions(-)

diff --git a/drivers/media/platform/exynos4-is/fimc-is.c b/drivers/media/platform/exynos4-is/fimc-is.c
index f5fc54de19da..02da0b06e56a 100644
--- a/drivers/media/platform/exynos4-is/fimc-is.c
+++ b/drivers/media/platform/exynos4-is/fimc-is.c
@@ -738,7 +738,7 @@ int fimc_is_hw_initialize(struct fimc_is *is)
 	return 0;
 }
 
-static int fimc_is_log_show(struct seq_file *s, void *data)
+static int fimc_is_show(struct seq_file *s, void *data)
 {
 	struct fimc_is *is = s->private;
 	const u8 *buf = is->memory.vaddr + FIMC_IS_DEBUG_REGION_OFFSET;
@@ -752,17 +752,7 @@ static int fimc_is_log_show(struct seq_file *s, void *data)
 	return 0;
 }
 
-static int fimc_is_debugfs_open(struct inode *inode, struct file *file)
-{
-	return single_open(file, fimc_is_log_show, inode->i_private);
-}
-
-static const struct file_operations fimc_is_debugfs_fops = {
-	.open		= fimc_is_debugfs_open,
-	.read		= seq_read,
-	.llseek		= seq_lseek,
-	.release	= single_release,
-};
+DEFINE_SHOW_ATTRIBUTE(fimc_is);
 
 static void fimc_is_debugfs_remove(struct fimc_is *is)
 {
@@ -777,7 +767,7 @@ static int fimc_is_debugfs_create(struct fimc_is *is)
 	is->debugfs_entry = debugfs_create_dir("fimc_is", NULL);
 
 	dentry = debugfs_create_file("fw_log", S_IRUGO, is->debugfs_entry,
-				     is, &fimc_is_debugfs_fops);
+				     is, &fimc_is_fops);
 	if (!dentry)
 		fimc_is_debugfs_remove(is);
 
-- 
2.17.0

