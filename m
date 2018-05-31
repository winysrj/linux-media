Return-path: <linux-media-owner@vger.kernel.org>
Received: from relay6-d.mail.gandi.net ([217.70.183.198]:48465 "EHLO
        relay6-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755737AbeEaRfN (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 31 May 2018 13:35:13 -0400
From: Jacopo Mondi <jacopo+renesas@jmondi.org>
To: corbet@lwn.net, mchehab@kernel.org
Cc: Jacopo Mondi <jacopo+renesas@jmondi.org>,
        linux-media@vger.kernel.org
Subject: [PATCH] media: i2c: ov7670: Put ep fwnode after use
Date: Thu, 31 May 2018 19:35:03 +0200
Message-Id: <1527788103-23694-1-git-send-email-jacopo+renesas@jmondi.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The just parsed endpoint fwnode has to be put after use.
Currently this is done only in error handling path. Fix that by putting node
unconditionally after use.

Fixes: 01b8444828fc ("media: v4l2: i2c: ov7670: Implement OF mbus configuration")

Signed-off-by: Jacopo Mondi <jacopo+renesas@jmondi.org>
---
 drivers/media/i2c/ov7670.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/media/i2c/ov7670.c b/drivers/media/i2c/ov7670.c
index 3474ef83..31bf577 100644
--- a/drivers/media/i2c/ov7670.c
+++ b/drivers/media/i2c/ov7670.c
@@ -1744,14 +1744,12 @@ static int ov7670_parse_dt(struct device *dev,
 		return -EINVAL;

 	ret = v4l2_fwnode_endpoint_parse(ep, &bus_cfg);
-	if (ret) {
-		fwnode_handle_put(ep);
+	fwnode_handle_put(ep);
+	if (ret)
 		return ret;
-	}

 	if (bus_cfg.bus_type != V4L2_MBUS_PARALLEL) {
 		dev_err(dev, "Unsupported media bus type\n");
-		fwnode_handle_put(ep);
 		return ret;
 	}
 	info->mbus_config = bus_cfg.bus.parallel.flags;
--
2.7.4
