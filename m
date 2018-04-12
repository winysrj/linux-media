Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:56160 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1751870AbeDLKVy (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 12 Apr 2018 06:21:54 -0400
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: linux-media@vger.kernel.org
Cc: Wenyou Yang <wenyou.yang@microchip.com>
Subject: [PATCH 1/4] ov7740: Fix number of controls hint
Date: Thu, 12 Apr 2018 13:21:47 +0300
Message-Id: <20180412102150.29997-2-sakari.ailus@linux.intel.com>
In-Reply-To: <20180412102150.29997-1-sakari.ailus@linux.intel.com>
References: <20180412102150.29997-1-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The driver has 12 controls, not 2.

Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
---
 drivers/media/i2c/ov7740.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/i2c/ov7740.c b/drivers/media/i2c/ov7740.c
index 01f578785e79..c9b8bec6373f 100644
--- a/drivers/media/i2c/ov7740.c
+++ b/drivers/media/i2c/ov7740.c
@@ -953,7 +953,7 @@ static int ov7740_init_controls(struct ov7740 *ov7740)
 	struct v4l2_ctrl_handler *ctrl_hdlr = &ov7740->ctrl_handler;
 	int ret;
 
-	ret = v4l2_ctrl_handler_init(ctrl_hdlr, 2);
+	ret = v4l2_ctrl_handler_init(ctrl_hdlr, 12);
 	if (ret < 0)
 		return ret;
 
-- 
2.11.0
