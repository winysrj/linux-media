Return-Path: <SRS0=NzSx=OO=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EBC60C04EBF
	for <linux-media@archiver.kernel.org>; Wed,  5 Dec 2018 15:49:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A613D20878
	for <linux-media@archiver.kernel.org>; Wed,  5 Dec 2018 15:49:19 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="qtkSgPIi"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org A613D20878
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-media-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728093AbeLEPsz (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Wed, 5 Dec 2018 10:48:55 -0500
Received: from mail-lf1-f67.google.com ([209.85.167.67]:42723 "EHLO
        mail-lf1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728051AbeLEPsy (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Wed, 5 Dec 2018 10:48:54 -0500
Received: by mail-lf1-f67.google.com with SMTP id l10so15058446lfh.9;
        Wed, 05 Dec 2018 07:48:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=jlxCKYT+/bGGxNDhXvCFjFcnBbho+Yzq9ypg9mJV4aQ=;
        b=qtkSgPIieYYm1MekCJi1sNuirVcqFnjubsHcGF4nVLspOqBYPbk+N+WTXAZZpSCLMq
         rUBIpdLs3bIQcNq1yOSwpuuoRuT8D80a0MeQNQgcid8del7OvoA+77xgSgr/p0ErfQpL
         1lc8qQ7/OS8Qh1z8FBMFPe9jUlqpGn2gVI3iN9B65KEcIxNBULwc0ZpJklg1VL53lmR3
         Wv5Hw49ipHqh7JcyP2LXCt30FdpcuKgscK0APVTsmgp6ad1+2C4/tTa87rATvGOzepH8
         8SaRQMUCHIY4Sumx0GMOcDD9hbLnZ+l3xHbZDBbguyiuTBRZZJO8NljqO1kLkICn6mp0
         QwpQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=jlxCKYT+/bGGxNDhXvCFjFcnBbho+Yzq9ypg9mJV4aQ=;
        b=IUknAKUJIcdphPlWf0as9TErqBh50nQXhFI/AJLc1kNFc+MQUPOWC+uvMF9/rsZkuG
         F6VsCNbkwGpKzxEdStQLTWTlH5Eq1pgaBQn+ARwfZ1ZbG4cEVWpc6Ho8DKS2pWFyz6RD
         i/vzSfgVgDLT4ofQQX2EbnkLON7dfhdWSAqC1wBYdbKiQZDgWGWaQB4bwo7usvBOar3I
         f6avZxx2VZxNWWGPBFlQ8Ct4fCLZx58xaeeOWQyc9A+a8yqfz8H4cjQX8IlVbL10JIGV
         p4ntV9gHUCj04pSyYHCOyGzOs+YWpQZiSFM0xxtyeLGZl9FKqDZa1Z8fb41KMJk/UzeP
         3ciw==
X-Gm-Message-State: AA+aEWYLvLkZfHtL08BtGiUmLQnxKOcQHozdGtM6sY46xuPMQkjPRVsW
        z4mDgAwWYQ14rbFXiywGM97bpZseZz9RAA==
X-Google-Smtp-Source: AFSGD/VcqnQViEXRP3yniLY1OR2yJJlGAShP9NSwAVfsN4vhw/rUqShU2Q3ouA7crPhY5q37DooKPQ==
X-Received: by 2002:a19:a7c1:: with SMTP id q184mr14000716lfe.4.1544024931361;
        Wed, 05 Dec 2018 07:48:51 -0800 (PST)
Received: from localhost.localdomain ([2a02:a315:5445:5300:41e8:260c:942a:b736])
        by smtp.googlemail.com with ESMTPSA id t18sm3592517lft.93.2018.12.05.07.48.49
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 05 Dec 2018 07:48:50 -0800 (PST)
From:   =?UTF-8?q?Pawe=C5=82=20Chmiel?= <pawel.mikolaj.chmiel@gmail.com>
To:     mchehab@kernel.org, robh+dt@kernel.org, mark.rutland@arm.com
Cc:     hverkuil@xs4all.nl, fischerdouglasc@gmail.com,
        keescook@chromium.org, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        =?UTF-8?q?Pawe=C5=82=20Chmiel?= <pawel.mikolaj.chmiel@gmail.com>
Subject: [PATCH 1/5] si470x-i2c: Add device tree support
Date:   Wed,  5 Dec 2018 16:47:46 +0100
Message-Id: <20181205154750.17996-2-pawel.mikolaj.chmiel@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20181205154750.17996-1-pawel.mikolaj.chmiel@gmail.com>
References: <20181205154750.17996-1-pawel.mikolaj.chmiel@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

This commit enables device tree support adding simple of_match table.

Signed-off-by: Paweł Chmiel <pawel.mikolaj.chmiel@gmail.com>
---
 drivers/media/radio/si470x/radio-si470x-i2c.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/media/radio/si470x/radio-si470x-i2c.c b/drivers/media/radio/si470x/radio-si470x-i2c.c
index 9751ea1d80be..250828ddb5fa 100644
--- a/drivers/media/radio/si470x/radio-si470x-i2c.c
+++ b/drivers/media/radio/si470x/radio-si470x-i2c.c
@@ -527,6 +527,13 @@ static int si470x_i2c_resume(struct device *dev)
 static SIMPLE_DEV_PM_OPS(si470x_i2c_pm, si470x_i2c_suspend, si470x_i2c_resume);
 #endif
 
+#if IS_ENABLED(CONFIG_OF)
+static const struct of_device_id si470x_of_match[] = {
+	{ .compatible = "silabs,si470x" },
+	{ },
+};
+MODULE_DEVICE_TABLE(of, si470x_of_match);
+#endif
 
 /*
  * si470x_i2c_driver - i2c driver interface
@@ -534,6 +541,7 @@ static SIMPLE_DEV_PM_OPS(si470x_i2c_pm, si470x_i2c_suspend, si470x_i2c_resume);
 static struct i2c_driver si470x_i2c_driver = {
 	.driver = {
 		.name		= "si470x",
+		.of_match_table = of_match_ptr(si470x_of_match),
 #ifdef CONFIG_PM_SLEEP
 		.pm		= &si470x_i2c_pm,
 #endif
-- 
2.17.1

