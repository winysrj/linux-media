Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:46190 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965406AbbD1MDs (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 28 Apr 2015 08:03:48 -0400
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	=?UTF-8?q?Pali=20Roh=C3=A1r?= <pali.rohar@gmail.com>,
	Pavel Machek <pavel@ucw.cz>,
	Navya Sri Nizamkari <navyasri.tech@gmail.com>,
	Luke Hart <luke.hart@birchleys.eu>,
	Anil Belur <askb23@gmail.com>,
	Haneen Mohammed <hamohammed.sa@gmail.com>,
	Vaishali Thakkar <vthakkar1994@gmail.com>,
	devel@driverdev.osuosl.org
Subject: [PATCH] radio-bcm2048: remove unused var
Date: Tue, 28 Apr 2015 09:03:41 -0300
Message-Id: <5784d4a9f48f7661ab1814ef4e8d210fa065bafb.1430222617.git.mchehab@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

drivers/staging/media/bcm2048/radio-bcm2048.c: In function 'bcm2048_i2c_driver_probe':
drivers/staging/media/bcm2048/radio-bcm2048.c:2596:11: warning: variable 'skip_release' set but not used [-Wunused-but-set-variable]
  int err, skip_release = 0;
           ^

Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>

diff --git a/drivers/staging/media/bcm2048/radio-bcm2048.c b/drivers/staging/media/bcm2048/radio-bcm2048.c
index e9d0691b21d3..5e11a78ceef3 100644
--- a/drivers/staging/media/bcm2048/radio-bcm2048.c
+++ b/drivers/staging/media/bcm2048/radio-bcm2048.c
@@ -2593,7 +2593,7 @@ static int bcm2048_i2c_driver_probe(struct i2c_client *client,
 					const struct i2c_device_id *id)
 {
 	struct bcm2048_device *bdev;
-	int err, skip_release = 0;
+	int err;
 
 	bdev = kzalloc(sizeof(*bdev), GFP_KERNEL);
 	if (!bdev) {
@@ -2646,7 +2646,6 @@ free_sysfs:
 	bcm2048_sysfs_unregister_properties(bdev, ARRAY_SIZE(attrs));
 free_registration:
 	video_unregister_device(&bdev->videodev);
-	skip_release = 1;
 free_irq:
 	if (client->irq)
 		free_irq(client->irq, bdev);
-- 
2.1.0

