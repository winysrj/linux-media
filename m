Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wi0-f169.google.com ([209.85.212.169]:34987 "EHLO
	mail-wi0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753940AbbJ2VjU (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 29 Oct 2015 17:39:20 -0400
Received: by wicll6 with SMTP id ll6so238811112wic.0
        for <linux-media@vger.kernel.org>; Thu, 29 Oct 2015 14:39:19 -0700 (PDT)
From: Heiner Kallweit <hkallweit1@gmail.com>
Subject: [PATCH] media: rc-core: simplify logging in rc_register_device
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Cc: linux-media@vger.kernel.org
Message-ID: <563291FA.5020804@gmail.com>
Date: Thu, 29 Oct 2015 22:39:06 +0100
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Simplify the logging.

I had some doubts about using the elvis operator as it's GNU extension.
However GNU extensions are explicitely allowed and this operator is
used at several places in the kernel code.

Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
---
 drivers/media/rc/rc-main.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/media/rc/rc-main.c b/drivers/media/rc/rc-main.c
index 3f0f71a..c47ed33 100644
--- a/drivers/media/rc/rc-main.c
+++ b/drivers/media/rc/rc-main.c
@@ -1420,10 +1420,8 @@ int rc_register_device(struct rc_dev *dev)
 	dev->input_dev->rep[REP_PERIOD] = 125;
 
 	path = kobject_get_path(&dev->dev.kobj, GFP_KERNEL);
-	printk(KERN_INFO "%s: %s as %s\n",
-		dev_name(&dev->dev),
-		dev->input_name ? dev->input_name : "Unspecified device",
-		path ? path : "N/A");
+	dev_info(&dev->dev, "%s as %s\n",
+		dev->input_name ?: "Unspecified device", path ?: "N/A");
 	kfree(path);
 
 	if (dev->driver_type == RC_DRIVER_IR_RAW) {
-- 
2.6.2


