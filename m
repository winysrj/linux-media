Return-Path: <SRS0=xT8T=PG=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D4B6BC43387
	for <linux-media@archiver.kernel.org>; Sat, 29 Dec 2018 21:35:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 93FDF20815
	for <linux-media@archiver.kernel.org>; Sat, 29 Dec 2018 21:35:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728173AbeL2Vfg (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Sat, 29 Dec 2018 16:35:36 -0500
Received: from mail.ispras.ru ([83.149.199.45]:53408 "EHLO mail.ispras.ru"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726876AbeL2Vfg (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Sat, 29 Dec 2018 16:35:36 -0500
Received: from localhost.localdomain (109-252-60-93.nat.spd-mgts.ru [109.252.60.93])
        by mail.ispras.ru (Postfix) with ESMTPSA id 500D954006A;
        Sun, 30 Dec 2018 00:35:33 +0300 (MSK)
From:   Alexey Khoroshilov <khoroshilov@ispras.ru>
To:     Mauro Carvalho Chehab <mchehab@kernel.org>,
        Jacopo Mondi <jacopo+renesas@jmondi.org>
Cc:     Alexey Khoroshilov <khoroshilov@ispras.ru>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        ldv-project@linuxtesting.org
Subject: [PATCH] media: tw9910: add missed clk_disable_unprepare() on failure path
Date:   Sun, 30 Dec 2018 00:35:20 +0300
Message-Id: <1546119320-11841-1-git-send-email-khoroshilov@ispras.ru>
X-Mailer: git-send-email 2.7.4
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

If gpiod_get_optional() fails in tw9910_power_on(), clk is left undisabled.

Found by Linux Driver Verification project (linuxtesting.org).

Signed-off-by: Alexey Khoroshilov <khoroshilov@ispras.ru>
---
 drivers/media/i2c/tw9910.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/media/i2c/tw9910.c b/drivers/media/i2c/tw9910.c
index a54548cc4285..109770d678d2 100644
--- a/drivers/media/i2c/tw9910.c
+++ b/drivers/media/i2c/tw9910.c
@@ -610,6 +610,7 @@ static int tw9910_power_on(struct tw9910_priv *priv)
 					     GPIOD_OUT_LOW);
 	if (IS_ERR(priv->rstb_gpio)) {
 		dev_info(&client->dev, "Unable to get GPIO \"rstb\"");
+		clk_disable_unprepare(priv->clk);
 		return PTR_ERR(priv->rstb_gpio);
 	}
 
-- 
2.7.4

