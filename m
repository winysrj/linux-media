Return-Path: <SRS0=I7H+=PZ=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 226AAC43387
	for <linux-media@archiver.kernel.org>; Thu, 17 Jan 2019 16:18:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DF4B820652
	for <linux-media@archiver.kernel.org>; Thu, 17 Jan 2019 16:18:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728907AbfAQQSG (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Thu, 17 Jan 2019 11:18:06 -0500
Received: from lb3-smtp-cloud8.xs4all.net ([194.109.24.29]:59694 "EHLO
        lb3-smtp-cloud8.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728697AbfAQQSG (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 17 Jan 2019 11:18:06 -0500
Received: from marune.fritz.box ([IPv6:2001:983:e9a7:1:3849:86c5:b8c2:266c])
        by smtp-cloud8.xs4all.net with ESMTPA
        id kAMkgeAhPNR5ykAMmgTv0l; Thu, 17 Jan 2019 17:18:04 +0100
From:   hverkuil-cisco@xs4all.nl
To:     linux-media@vger.kernel.org
Cc:     Jacopo Mondi <jacopo+renesas@jmondi.org>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>
Subject: [PATCH 1/8] media: tw9910: Unregister subdevice with v4l2-async
Date:   Thu, 17 Jan 2019 17:17:55 +0100
Message-Id: <20190117161802.5740-2-hverkuil-cisco@xs4all.nl>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190117161802.5740-1-hverkuil-cisco@xs4all.nl>
References: <20190117161802.5740-1-hverkuil-cisco@xs4all.nl>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CMAE-Envelope: MS4wfAj7Vph+p/WN4HD1aH2v1x0kbsWz65Vm9ESFKzx0epK4Pfdn+7R5AaBRZ/rtFrnE22p74xgUuFgTwuVmPHYZa35WyZoxqQwtMX3LLeO8XkYM6zF5Re17
 gNwKaL/cvTv8pD5t0NjcxDS9xUqnF8qI+MPmKmn2L823HSytpNQst6s/MIT9ANCspQRzsYuIiD8Ckx9V5OM4hQdRszOO+ZTmOPjLtC/I/xI780lnI9B/YsIw
 H1qoMGpKrQip2uZAb4Z7eX6IFSLqLg82yBiibgWvQ8RfYVonXBHX2WPQwN5fjJXDdyLaBXx/wCOzY5n9pGsbcthvtsTlndx2il4tULKqYQYNhQ5T75/KEfWu
 3JRGmUWpBhwkhnh60apJYm7kC+WShQ==
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

From: Jacopo Mondi <jacopo+renesas@jmondi.org>

As the tw9910 subdevice is registered through the v4l2-async framework,
use the v4l2-async provided function to register it.

Fixes: 7b20f325a566 ("media: i2c: tw9910: Remove soc_camera dependencies")
Signed-off-by: Jacopo Mondi <jacopo+renesas@jmondi.org>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
---
 drivers/media/i2c/tw9910.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/i2c/tw9910.c b/drivers/media/i2c/tw9910.c
index 8d1138e13803..4d7cd736b930 100644
--- a/drivers/media/i2c/tw9910.c
+++ b/drivers/media/i2c/tw9910.c
@@ -1001,7 +1001,7 @@ static int tw9910_remove(struct i2c_client *client)
 	if (priv->pdn_gpio)
 		gpiod_put(priv->pdn_gpio);
 	clk_put(priv->clk);
-	v4l2_device_unregister_subdev(&priv->subdev);
+	v4l2_async_unregister_subdev(&priv->subdev);
 
 	return 0;
 }
-- 
2.20.1

