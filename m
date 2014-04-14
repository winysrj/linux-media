Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:4538 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754481AbaDNJA4 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 14 Apr 2014 05:00:56 -0400
Received: from nauris.fi.intel.com (nauris.localdomain [192.168.240.2])
	by paasikivi.fi.intel.com (Postfix) with ESMTP id F1F902097A
	for <linux-media@vger.kernel.org>; Mon, 14 Apr 2014 12:00:52 +0300 (EEST)
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: linux-media@vger.kernel.org
Subject: [PATCH v2 03/21] smiapp: Fix determining the need for 8-bit read access
Date: Mon, 14 Apr 2014 11:58:28 +0300
Message-Id: <1397465926-29724-4-git-send-email-sakari.ailus@linux.intel.com>
In-Reply-To: <1397465926-29724-1-git-send-email-sakari.ailus@linux.intel.com>
References: <1397465926-29724-1-git-send-email-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

8-bit reads are needed in some cases; however the condition used was wrong.
Regular access (register width) was used if:

	len == SMIAPP_REG_8BIT && !only8

This causes 8-bit read access to be used always. The operator should be ||
instead: regular access can be used for 8-bit reads OR if allowed otherwise.

Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
---
 drivers/media/i2c/smiapp/smiapp-regs.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/i2c/smiapp/smiapp-regs.c b/drivers/media/i2c/smiapp/smiapp-regs.c
index 5d0151a..c2db205 100644
--- a/drivers/media/i2c/smiapp/smiapp-regs.c
+++ b/drivers/media/i2c/smiapp/smiapp-regs.c
@@ -172,7 +172,7 @@ static int __smiapp_read(struct smiapp_sensor *sensor, u32 reg, u32 *val,
 	    && len != SMIAPP_REG_32BIT)
 		return -EINVAL;
 
-	if (len == SMIAPP_REG_8BIT && !only8)
+	if (len == SMIAPP_REG_8BIT || !only8)
 		rval = ____smiapp_read(sensor, (u16)reg, len, val);
 	else
 		rval = ____smiapp_read_8only(sensor, (u16)reg, len, val);
-- 
1.8.3.2

