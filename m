Return-Path: <SRS0=gp/0=PH=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E5660C43444
	for <linux-media@archiver.kernel.org>; Sun, 30 Dec 2018 11:42:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C094620855
	for <linux-media@archiver.kernel.org>; Sun, 30 Dec 2018 11:42:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726136AbeL3LmF (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Sun, 30 Dec 2018 06:42:05 -0500
Received: from mail.ispras.ru ([83.149.199.45]:48790 "EHLO mail.ispras.ru"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725971AbeL3LmF (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Sun, 30 Dec 2018 06:42:05 -0500
Received: from localhost.localdomain (ppp85-140-180-153.pppoe.mtu-net.ru [85.140.180.153])
        by mail.ispras.ru (Postfix) with ESMTPSA id ACE7554006A;
        Sun, 30 Dec 2018 14:42:02 +0300 (MSK)
From:   Alexey Khoroshilov <khoroshilov@ispras.ru>
To:     Mauro Carvalho Chehab <mchehab@kernel.org>,
        Jacopo Mondi <jacopo+renesas@jmondi.org>
Cc:     Alexey Khoroshilov <khoroshilov@ispras.ru>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        ldv-project@linuxtesting.org
Subject: [PATCH v2 1/2] media: tw9910: fix failure handling in tw9910_power_on()
Date:   Sun, 30 Dec 2018 14:41:40 +0300
Message-Id: <1546170101-22732-1-git-send-email-khoroshilov@ispras.ru>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <80f84853-9991-8a64-da22-9349543d5deb@ispras.ru>
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

If gpiod_get_optional() fails in tw9910_power_on(), clk is left undisabled.

Found by Linux Driver Verification project (linuxtesting.org).

Signed-off-by: Alexey Khoroshilov <khoroshilov@ispras.ru>
---
v2: reset pdn_gpio as well as Jacopo Mondi suggested.

 drivers/media/i2c/tw9910.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/media/i2c/tw9910.c b/drivers/media/i2c/tw9910.c
index a54548cc4285..0971f8a34afb 100644
--- a/drivers/media/i2c/tw9910.c
+++ b/drivers/media/i2c/tw9910.c
@@ -610,6 +610,11 @@ static int tw9910_power_on(struct tw9910_priv *priv)
 					     GPIOD_OUT_LOW);
 	if (IS_ERR(priv->rstb_gpio)) {
 		dev_info(&client->dev, "Unable to get GPIO \"rstb\"");
+		clk_disable_unprepare(priv->clk);
+		if (priv->pdn_gpio) {
+			gpiod_set_value(priv->pdn_gpio, 1);
+			usleep_range(500, 1000);
+		}
 		return PTR_ERR(priv->rstb_gpio);
 	}
 
-- 
2.7.4

