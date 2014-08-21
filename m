Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pa0-f44.google.com ([209.85.220.44]:47191 "EHLO
	mail-pa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754343AbaHUJZ1 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 21 Aug 2014 05:25:27 -0400
Received: by mail-pa0-f44.google.com with SMTP id eu11so13921563pac.3
        for <linux-media@vger.kernel.org>; Thu, 21 Aug 2014 02:25:26 -0700 (PDT)
From: Zhangfei Gao <zhangfei.gao@linaro.org>
To: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	=?UTF-8?q?David=20H=C3=A4rdeman?= <david@hardeman.nu>,
	arnd@arndb.de, haifeng.yan@linaro.org, jchxue@gmail.com
Cc: linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org,
	linux-media@vger.kernel.org, Zhangfei Gao <zhangfei.gao@linaro.org>
Subject: [PATCH v2 3/3] [media] rc: remove change_protocol in rc-ir-raw.c
Date: Thu, 21 Aug 2014 17:24:45 +0800
Message-Id: <1408613086-12538-4-git-send-email-zhangfei.gao@linaro.org>
In-Reply-To: <1408613086-12538-1-git-send-email-zhangfei.gao@linaro.org>
References: <1408613086-12538-1-git-send-email-zhangfei.gao@linaro.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

With commit 4924a311a62f ("[media] rc-core: rename ir-raw.c"),
empty change_protocol was introduced.
As a result, rc_register_device will set dev->enabled_protocols
addording to rc_map->rc_type, which prevent using all protocols.

Signed-off-by: Zhangfei Gao <zhangfei.gao@linaro.org>
---
 drivers/media/rc/rc-ir-raw.c |    7 -------
 1 file changed, 7 deletions(-)

diff --git a/drivers/media/rc/rc-ir-raw.c b/drivers/media/rc/rc-ir-raw.c
index e8fff2a..a118539 100644
--- a/drivers/media/rc/rc-ir-raw.c
+++ b/drivers/media/rc/rc-ir-raw.c
@@ -240,12 +240,6 @@ ir_raw_get_allowed_protocols(void)
 	return protocols;
 }
 
-static int change_protocol(struct rc_dev *dev, u64 *rc_type)
-{
-	/* the caller will update dev->enabled_protocols */
-	return 0;
-}
-
 /*
  * Used to (un)register raw event clients
  */
@@ -263,7 +257,6 @@ int ir_raw_event_register(struct rc_dev *dev)
 
 	dev->raw->dev = dev;
 	dev->enabled_protocols = ~0;
-	dev->change_protocol = change_protocol;
 	rc = kfifo_alloc(&dev->raw->kfifo,
 			 sizeof(struct ir_raw_event) * MAX_IR_EVENT_SIZE,
 			 GFP_KERNEL);
-- 
1.7.9.5

