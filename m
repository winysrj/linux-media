Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:65379 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934328AbaDITY6 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 9 Apr 2014 15:24:58 -0400
Received: from nauris.fi.intel.com (nauris.localdomain [192.168.240.2])
	by paasikivi.fi.intel.com (Postfix) with ESMTP id 7591B20EB1
	for <linux-media@vger.kernel.org>; Wed,  9 Apr 2014 22:24:55 +0300 (EEST)
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: linux-media@vger.kernel.org
Subject: [PATCH 16/17] smiapp: Ignore write accesses to quirk registers
Date: Wed,  9 Apr 2014 22:25:08 +0300
Message-Id: <1397071509-2071-17-git-send-email-sakari.ailus@linux.intel.com>
In-Reply-To: <1397071509-2071-1-git-send-email-sakari.ailus@linux.intel.com>
References: <1397071509-2071-1-git-send-email-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
---
 drivers/media/i2c/smiapp/smiapp-regs.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/media/i2c/smiapp/smiapp-regs.c b/drivers/media/i2c/smiapp/smiapp-regs.c
index 4fac32c..e88a59a 100644
--- a/drivers/media/i2c/smiapp/smiapp-regs.c
+++ b/drivers/media/i2c/smiapp/smiapp-regs.c
@@ -221,6 +221,13 @@ int smiapp_write(struct smiapp_sensor *sensor, u32 reg, u32 val)
 	     len != SMIA_REG_32BIT) || flags)
 		return -EINVAL;
 
+	if (smiapp_quirk_reg(sensor, reg, &val)) {
+		dev_dbg(&client->dev,
+			"ignoring write access to quirk reg 0x%4.4x\n",
+			(u16)reg);
+		return 0;
+	}
+
 	msg.addr = client->addr;
 	msg.flags = 0; /* Write */
 	msg.len = 2 + len;
-- 
1.8.3.2

