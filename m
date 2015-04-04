Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.ispras.ru ([83.149.199.45]:38399 "EHLO mail.ispras.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752085AbbDDAQW (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 3 Apr 2015 20:16:22 -0400
From: Alexey Khoroshilov <khoroshilov@ispras.ru>
To: Jonathan Corbet <corbet@lwn.net>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Cc: Alexey Khoroshilov <khoroshilov@ispras.ru>,
	ldv-project@linuxtesting.org, linux-media@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] [media] marvell-ccic: fix memory leak on failure path in cafe_smbus_setup()
Date: Sat,  4 Apr 2015 03:16:01 +0300
Message-Id: <1428106561-12623-1-git-send-email-khoroshilov@ispras.ru>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

If i2c_add_adapter() fails, adap is not deallocated.

Found by Linux Driver Verification project (linuxtesting.org).

Signed-off-by: Alexey Khoroshilov <khoroshilov@ispras.ru>
---
 drivers/media/platform/marvell-ccic/cafe-driver.c | 12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/drivers/media/platform/marvell-ccic/cafe-driver.c b/drivers/media/platform/marvell-ccic/cafe-driver.c
index 562845361246..9d45505370cd 100644
--- a/drivers/media/platform/marvell-ccic/cafe-driver.c
+++ b/drivers/media/platform/marvell-ccic/cafe-driver.c
@@ -339,17 +339,21 @@ static int cafe_smbus_setup(struct cafe_camera *cam)
 	adap = kzalloc(sizeof(*adap), GFP_KERNEL);
 	if (adap == NULL)
 		return -ENOMEM;
-	cam->mcam.i2c_adapter = adap;
-	cafe_smbus_enable_irq(cam);
 	adap->owner = THIS_MODULE;
 	adap->algo = &cafe_smbus_algo;
 	strcpy(adap->name, "cafe_ccic");
 	adap->dev.parent = &cam->pdev->dev;
 	i2c_set_adapdata(adap, cam);
 	ret = i2c_add_adapter(adap);
-	if (ret)
+	if (ret) {
 		printk(KERN_ERR "Unable to register cafe i2c adapter\n");
-	return ret;
+		kfree(adap);
+		return ret;
+	}
+
+	cam->mcam.i2c_adapter = adap;
+	cafe_smbus_enable_irq(cam);
+	return 0;
 }
 
 static void cafe_smbus_shutdown(struct cafe_camera *cam)
-- 
1.9.1

