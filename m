Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:51347 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751767AbbDJWnf (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 10 Apr 2015 18:43:35 -0400
Received: from lanttu.localdomain (lanttu.localdomain [192.168.5.64])
	by hillosipuli.retiisi.org.uk (Postfix) with ESMTP id ED19B6009F
	for <linux-media@vger.kernel.org>; Sat, 11 Apr 2015 01:43:32 +0300 (EEST)
From: Sakari Ailus <sakari.ailus@iki.fi>
To: linux-media@vger.kernel.org
Subject: [PATCH 1/1] smiapp: Remove useless rval assignment in smiapp_get_pdata()
Date: Sat, 11 Apr 2015 01:42:47 +0300
Message-Id: <1428705767-3241-1-git-send-email-sakari.ailus@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The value is not used after the assignment.

Signed-off-by: Sakari Ailus <sakari.ailus@iki.fi>
---
 drivers/media/i2c/smiapp/smiapp-core.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/media/i2c/smiapp/smiapp-core.c b/drivers/media/i2c/smiapp/smiapp-core.c
index 636ebd6..4b1e112 100644
--- a/drivers/media/i2c/smiapp/smiapp-core.c
+++ b/drivers/media/i2c/smiapp/smiapp-core.c
@@ -3032,10 +3032,8 @@ static struct smiapp_platform_data *smiapp_get_pdata(struct device *dev)
 	pdata->op_sys_clock = devm_kcalloc(
 		dev, bus_cfg->nr_of_link_frequencies + 1 /* guardian */,
 		sizeof(*pdata->op_sys_clock), GFP_KERNEL);
-	if (!pdata->op_sys_clock) {
-		rval = -ENOMEM;
+	if (!pdata->op_sys_clock)
 		goto out_err;
-	}
 
 	for (i = 0; i < bus_cfg->nr_of_link_frequencies; i++) {
 		pdata->op_sys_clock[i] = bus_cfg->link_frequencies[i];
-- 
1.7.10.4

