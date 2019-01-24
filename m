Return-Path: <SRS0=42/h=QA=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D697AC282C6
	for <linux-media@archiver.kernel.org>; Thu, 24 Jan 2019 17:58:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A66152184C
	for <linux-media@archiver.kernel.org>; Thu, 24 Jan 2019 17:58:16 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=amarulasolutions.com header.i=@amarulasolutions.com header.b="IqbSIc5X"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729182AbfAXR6O (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Thu, 24 Jan 2019 12:58:14 -0500
Received: from mail-pg1-f193.google.com ([209.85.215.193]:34663 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728952AbfAXR6O (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 24 Jan 2019 12:58:14 -0500
Received: by mail-pg1-f193.google.com with SMTP id j10so2992828pga.1
        for <linux-media@vger.kernel.org>; Thu, 24 Jan 2019 09:58:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=amarulasolutions.com; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=UgKgBH2JVUi6gOvsZblmkwUAuP/sSEuCNVyEfyghO6s=;
        b=IqbSIc5XgVHHOIv5erHSDMFjnRPYddcKBgDJOFn5EHROrRciNQA+2OJwzAakBXWy2b
         YucLfT1eltg5oo3kQDIYJdOdtS9UPhD5V5Tp3il5uEUXMXeU8EBFzSEcW7IUBUC7G0Sy
         /sL2nbmFGf6TxsOnotERcrjqNYWzJzIybuBNs=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=UgKgBH2JVUi6gOvsZblmkwUAuP/sSEuCNVyEfyghO6s=;
        b=NtA9yUKkgE1xr06kb/KBNIy9Adke1EyHzmYT7jG+0lJpvFg32eaAvCowFVPrL8hFvX
         7bFbOaTUMgukf+x1qQkdtXIHMuJ11ciUKXWs76BV89KGFiu3W0cvCYtApVSkBXoLPdB/
         pSyO877eaIOkEpeIhwHmvKd580/xzuJDXdx3cc3NH6B5iw801GykpaQP7biFE33dNEln
         5g2F2qwBs8BlPWPYdoqrfhgaNfop6HgXgoKs1lEVxbQWiiMLfhwSU8wwKf7KGjrtYo3z
         UPEWi+yGUo1ZhCPhwgzp0tHN6ijgNwg4MLTxvsWm213mVlMQ2wFm/R/iZvrT56bacqhV
         SaPw==
X-Gm-Message-State: AJcUukfJe0bT42YK92GEB84WD3Y9JRsFem5nSYEGc5PIlqmRa6/niiUj
        E2iEjzShLjeqxO0cNdn8gDAM6hQcSDs=
X-Google-Smtp-Source: ALg8bN7nHSlmZFpQvuviUvZnz1P7PKT9UKC0lWaBRroiQOjVtYiTV1Fzj/lQCQf/atjl6fgUKgQoLw==
X-Received: by 2002:a65:40c5:: with SMTP id u5mr257887pgp.46.1548352693228;
        Thu, 24 Jan 2019 09:58:13 -0800 (PST)
Received: from localhost.localdomain ([115.97.179.75])
        by smtp.gmail.com with ESMTPSA id 4sm28684826pfq.10.2019.01.24.09.58.09
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 24 Jan 2019 09:58:12 -0800 (PST)
From:   Jagan Teki <jagan@amarulasolutions.com>
To:     Steve Longerbeam <slongerbeam@gmail.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Maxime Ripard <maxime.ripard@bootlin.com>,
        Jacopo Mondi <jacopo+renesas@jmondi.org>
Cc:     linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        Michael Trimarchi <michael@amarulasolutions.com>,
        linux-amarula@amarulasolutions.com,
        Jagan Teki <jagan@amarulasolutions.com>
Subject: [PATCH] media: ov5640: Fix set 15fps regression
Date:   Thu, 24 Jan 2019 23:28:01 +0530
Message-Id: <20190124175801.28018-1-jagan@amarulasolutions.com>
X-Mailer: git-send-email 2.18.0.321.gffc6fa0e3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

The ov5640_try_frame_interval operation updates the FPS as per user
input based on default ov5640_frame_rate, OV5640_30_FPS which is failed
to update when user trigger 15fps.

So, initialize the default ov5640_frame_rate to OV5640_15_FPS so-that
it can satisfy to update all fps.

Fixes: 5a3ad937bc78 ("media: ov5640: Make the return rate type more explicit")
Signed-off-by: Jagan Teki <jagan@amarulasolutions.com>
---
 drivers/media/i2c/ov5640.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/i2c/ov5640.c b/drivers/media/i2c/ov5640.c
index 5a909abd0a2d..4081c29176c6 100644
--- a/drivers/media/i2c/ov5640.c
+++ b/drivers/media/i2c/ov5640.c
@@ -2072,7 +2072,7 @@ static int ov5640_try_frame_interval(struct ov5640_dev *sensor,
 				     u32 width, u32 height)
 {
 	const struct ov5640_mode_info *mode;
-	enum ov5640_frame_rate rate = OV5640_30_FPS;
+	enum ov5640_frame_rate rate = OV5640_15_FPS;
 	int minfps, maxfps, best_fps, fps;
 	int i;
 
-- 
2.18.0.321.gffc6fa0e3

