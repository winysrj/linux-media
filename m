Return-Path: <SRS0=BdY7=QG=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 01F01C282D7
	for <linux-media@archiver.kernel.org>; Wed, 30 Jan 2019 16:48:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B8F522086C
	for <linux-media@archiver.kernel.org>; Wed, 30 Jan 2019 16:48:12 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=linaro.org header.i=@linaro.org header.b="VKXiwQvD"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731681AbfA3QsM (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Wed, 30 Jan 2019 11:48:12 -0500
Received: from mail-wr1-f65.google.com ([209.85.221.65]:43569 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728469AbfA3QsM (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 30 Jan 2019 11:48:12 -0500
Received: by mail-wr1-f65.google.com with SMTP id r10so175591wrs.10
        for <linux-media@vger.kernel.org>; Wed, 30 Jan 2019 08:48:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id;
        bh=Ho+kzxYAYd4TY0kJUTb4OZYepxjGIOMJa+jl8zoC1/U=;
        b=VKXiwQvDltxDHVveiS7DzIyubhYlp1Fb5PS1/PkropF1UHhl4APQpwsqv8xtUG3Ges
         H12WtPm98ltztBOH9NbhxV5g9IxytGZ5HlnE2FiooxBBJpq9Ajzr79DG4iniv6RndA6o
         /LcnUWu7H3NBjB3mYCoqrw1eA45iI/1TBSAv0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=Ho+kzxYAYd4TY0kJUTb4OZYepxjGIOMJa+jl8zoC1/U=;
        b=lrBbhCkoczg6o8oKsZY9TKeeSUgGtwiT6XZHb3pbnY7NXyBOBXnUqfm8BajmBX8YxY
         tXOliUzot/luMf4AKsq83X9jh4t3VGgBVvS9XE/wXGAcbPVPobuwnQhUOHqcIFnN+Gam
         YKS6ecUBTcdiKxWn4s3BO1QezAsugho1EvdwL2BFrPQQhtDqoRnFoMrVelORU0B4lACY
         SXDN8yQUY1LD5MzSMAEXVZg8RRAk+O5iLB6pjFuMwsljlHwSzqqPbc3rqPsJsIWShyDH
         L1tSlPtxG+ioyNkyE8Al7y+oRqCG2g45Z0Hp+WF88KpwIlybn+WuUvuT05UxRtW+JKjz
         19PQ==
X-Gm-Message-State: AJcUukd/gj6io/T9DC/Kr2idyutuPN3wkFRncJgr0LBO+tBW2dRIhmG7
        DQvMhwyj/+X+V+veCpwZEqtF3A==
X-Google-Smtp-Source: ALg8bN6rJaxlNIl56XfUrJlieuJuN78y8LCaHR6WJ9g3Z3q162soNeKAZLrt6zerJ+oMSEUD8RaMQA==
X-Received: by 2002:adf:9323:: with SMTP id 32mr30299693wro.213.1548866890241;
        Wed, 30 Jan 2019 08:48:10 -0800 (PST)
Received: from localhost.localdomain (lfbn-1-10571-127.w90-89.abo.wanadoo.fr. [90.89.165.127])
        by smtp.gmail.com with ESMTPSA id v132sm2746033wme.20.2019.01.30.08.48.08
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Wed, 30 Jan 2019 08:48:09 -0800 (PST)
From:   Loic Poulain <loic.poulain@linaro.org>
To:     slongerbeam@gmail.com, mchehab@kernel.org
Cc:     linux-media@vger.kernel.org, Loic Poulain <loic.poulain@linaro.org>
Subject: [PATCH] media: i2c: ov5640: Fix post-reset delay
Date:   Wed, 30 Jan 2019 17:48:07 +0100
Message-Id: <1548866887-25746-1-git-send-email-loic.poulain@linaro.org>
X-Mailer: git-send-email 2.7.4
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

According to the ov5640 specification (2.7 power up sequence), host can
access the sensor's registers 20ms after reset. Trying to access them
before leads to undefined behavior and result in sporadic initialization
errors.

Signed-off-by: Loic Poulain <loic.poulain@linaro.org>
---
 drivers/media/i2c/ov5640.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/i2c/ov5640.c b/drivers/media/i2c/ov5640.c
index 5a909ab..6415231 100644
--- a/drivers/media/i2c/ov5640.c
+++ b/drivers/media/i2c/ov5640.c
@@ -1906,7 +1906,7 @@ static void ov5640_reset(struct ov5640_dev *sensor)
 	usleep_range(1000, 2000);
 
 	gpiod_set_value_cansleep(sensor->reset_gpio, 0);
-	usleep_range(5000, 10000);
+	usleep_range(20000, 25000);
 }
 
 static int ov5640_set_power_on(struct ov5640_dev *sensor)
-- 
2.7.4

