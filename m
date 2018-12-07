Return-Path: <SRS0=1NWX=OQ=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5685EC07E85
	for <linux-media@archiver.kernel.org>; Fri,  7 Dec 2018 13:58:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1BCC1214C1
	for <linux-media@archiver.kernel.org>; Fri,  7 Dec 2018 13:58:29 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="GGg0NJeN"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 1BCC1214C1
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-media-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726190AbeLGN61 (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Fri, 7 Dec 2018 08:58:27 -0500
Received: from mail-lj1-f195.google.com ([209.85.208.195]:42402 "EHLO
        mail-lj1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726018AbeLGN60 (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 7 Dec 2018 08:58:26 -0500
Received: by mail-lj1-f195.google.com with SMTP id l15-v6so3620564lja.9;
        Fri, 07 Dec 2018 05:58:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=jlxCKYT+/bGGxNDhXvCFjFcnBbho+Yzq9ypg9mJV4aQ=;
        b=GGg0NJeNOeBUoGwFv223xbra9tj9RNR+bT26siwN5ZyRjTLizhVqMbsjH02IusnhAa
         OM0d+THOS6DFDSykZAKTDShfRbMXoJHLmX2a2mtqeaYt/TX3aWrkkaNkDQo/4z5UNTqT
         Wr7IYICeDhBRrZz60o1WZ2BLObNeXsYFshuBjRxUJE9MhZFHwTJ1mXQWLOZTzJBwrR2L
         vu3zlQAT3kXn/r/cLfajz/SivMxSL56Wagnw1fbrGQiGWalURwBdf6OoFAYD6c35XgM3
         u68yv26xmtRt+muCgjlvps52iZeuMisrct3mBT0HHV8iQq6mS6/IPlL2MQIwGK7Jx6gI
         8k4Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=jlxCKYT+/bGGxNDhXvCFjFcnBbho+Yzq9ypg9mJV4aQ=;
        b=Ft6geQF7gcHTVTDUxs4uv4UJya0ZuZEzAOCt+USRhsHml7lZzMLU8iIPfmWtg+Iy4t
         /26hF1ROKKPIKrPXLdBtYXlC/KjO7eEyLJ7wbnkWrZOsQ2SwrhrdfHPsBpUT8BJHUYxU
         m2vQb4op3/NeY4XXXdpzMkcWIqqRiFh/qXLmv41oJNGYY2V/SLTFP7GN9jEaeyXbzbbB
         K3a3BN3zL/0F7DcFCw+wBDTqYoexxD8zfLyOkABkplcvh3yx78nuQJBK+nu/2GJIkxGe
         2O2a7Z1Pr516OZlMLGlx/VNLpMOLWWp7MoA9PfwktaTVVBC1vnYX/90Ez9Jx9ELr6aGS
         g6FQ==
X-Gm-Message-State: AA+aEWZtzRmCIp2LhEo3TkVbe13tPnxg6ypQmT6WR/EPKRSfYZBS2HZk
        et3wl5Co3q3nP9jTWhTMiw0=
X-Google-Smtp-Source: AFSGD/XsZbvireXJJWKbCzRWWAmPwtKq7HlCdQCS27+W9GXomxOTRKD47NmNWcvgZRhoRJNfpl8PYw==
X-Received: by 2002:a2e:5152:: with SMTP id b18-v6mr1252705lje.88.1544191103748;
        Fri, 07 Dec 2018 05:58:23 -0800 (PST)
Received: from localhost.localdomain ([2a02:a315:5445:5300:74d5:51ba:2673:f3f4])
        by smtp.googlemail.com with ESMTPSA id i143sm624609lfg.74.2018.12.07.05.58.22
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 07 Dec 2018 05:58:23 -0800 (PST)
From:   =?UTF-8?q?Pawe=C5=82=20Chmiel?= <pawel.mikolaj.chmiel@gmail.com>
To:     mchehab@kernel.org, robh+dt@kernel.org, mark.rutland@arm.com
Cc:     hverkuil@xs4all.nl, fischerdouglasc@gmail.com,
        keescook@chromium.org, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        =?UTF-8?q?Pawe=C5=82=20Chmiel?= <pawel.mikolaj.chmiel@gmail.com>
Subject: [PATCH v2 1/4] si470x-i2c: Add device tree support
Date:   Fri,  7 Dec 2018 14:58:09 +0100
Message-Id: <20181207135812.12842-2-pawel.mikolaj.chmiel@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20181207135812.12842-1-pawel.mikolaj.chmiel@gmail.com>
References: <20181207135812.12842-1-pawel.mikolaj.chmiel@gmail.com>
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

