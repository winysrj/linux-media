Return-path: <linux-media-owner@vger.kernel.org>
Received: from jusst.de ([188.40.114.84]:42302 "EHLO web01.jusst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751285AbcBWMED (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 23 Feb 2016 07:04:03 -0500
From: Julian Scheel <julian@jusst.de>
To: linux-media@vger.kernel.org, lars@metafoo.de, hverkuil@xs4all.nl
Cc: Julian Scheel <julian@jusst.de>
Subject: [PATCH] media: adv7180: Add of compatible strings for full family
Date: Tue, 23 Feb 2016 12:58:19 +0100
Message-Id: <1456228699-22575-1-git-send-email-julian@jusst.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add entries for all supported chip variants into the of_match list, so that
the matching driver_info can be selected when using dt.

Change-Id: I6ff849726c8f475c81e848423b27c35f2ccb0509
Signed-off-by: Julian Scheel <julian@jusst.de>
---
 drivers/media/i2c/adv7180.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/media/i2c/adv7180.c b/drivers/media/i2c/adv7180.c
index ff57c1d..5515f3d 100644
--- a/drivers/media/i2c/adv7180.c
+++ b/drivers/media/i2c/adv7180.c
@@ -1328,6 +1328,14 @@ static SIMPLE_DEV_PM_OPS(adv7180_pm_ops, adv7180_suspend, adv7180_resume);
 #ifdef CONFIG_OF
 static const struct of_device_id adv7180_of_id[] = {
 	{ .compatible = "adi,adv7180", },
+	{ .compatible = "adi,adv7182", },
+	{ .compatible = "adi,adv7280", },
+	{ .compatible = "adi,adv7280-m", },
+	{ .compatible = "adi,adv7281", },
+	{ .compatible = "adi,adv7281-m", },
+	{ .compatible = "adi,adv7281-ma", },
+	{ .compatible = "adi,adv7282", },
+	{ .compatible = "adi,adv7282-m", },
 	{ },
 };
 
-- 
2.7.1

