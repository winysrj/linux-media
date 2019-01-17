Return-Path: <SRS0=I7H+=PZ=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 40BCBC43387
	for <linux-media@archiver.kernel.org>; Thu, 17 Jan 2019 14:33:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1A8A820855
	for <linux-media@archiver.kernel.org>; Thu, 17 Jan 2019 14:33:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727499AbfAQOdG (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Thu, 17 Jan 2019 09:33:06 -0500
Received: from relay4-d.mail.gandi.net ([217.70.183.196]:46813 "EHLO
        relay4-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726517AbfAQOdG (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 17 Jan 2019 09:33:06 -0500
X-Originating-IP: 2.224.242.101
Received: from uno.lan (2-224-242-101.ip172.fastwebnet.it [2.224.242.101])
        (Authenticated sender: jacopo@jmondi.org)
        by relay4-d.mail.gandi.net (Postfix) with ESMTPSA id 2B9A5E0009;
        Thu, 17 Jan 2019 14:33:02 +0000 (UTC)
From:   Jacopo Mondi <jacopo+renesas@jmondi.org>
To:     hverkuil-cisco@xs4all.nl, sakari.ailus@iki.fi, mchehab@kernel.org
Cc:     Jacopo Mondi <jacopo+renesas@jmondi.org>,
        linux-media@vger.kernel.org
Subject: [PATCH] media: tw9910: Unregister subdevice with v4l2-async
Date:   Thu, 17 Jan 2019 15:33:04 +0100
Message-Id: <20190117143304.13137-1-jacopo+renesas@jmondi.org>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

As the tw9910 subdevice is registered through the v4l2-async framework,
use the v4l2-async provided function to register it.

Fixes: 7b20f325a566 ("media: i2c: tw9910: Remove soc_camera dependencies")
Signed-off-by: Jacopo Mondi <jacopo+renesas@jmondi.org>
---
As agreed with Hans on irc, this patch makes removing soc_camera.h inclusion
from include/media/i2c/tw9910.h safe. Please have this patch in before any
series that removes soc_camera headers.

Thanks
   j
---
 drivers/media/i2c/tw9910.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/i2c/tw9910.c b/drivers/media/i2c/tw9910.c
index a54548cc4285..c7321a70e3ed 100644
--- a/drivers/media/i2c/tw9910.c
+++ b/drivers/media/i2c/tw9910.c
@@ -1000,7 +1000,7 @@ static int tw9910_remove(struct i2c_client *client)
 	if (priv->pdn_gpio)
 		gpiod_put(priv->pdn_gpio);
 	clk_put(priv->clk);
-	v4l2_device_unregister_subdev(&priv->subdev);
+	v4l2_async_unregister_subdev(&priv->subdev);

 	return 0;
 }
--
2.20.1

