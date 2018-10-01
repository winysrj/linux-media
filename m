Return-path: <linux-media-owner@vger.kernel.org>
Received: from forward102o.mail.yandex.net ([37.140.190.182]:55596 "EHLO
        forward102o.mail.yandex.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728960AbeJAQY5 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 1 Oct 2018 12:24:57 -0400
From: Andrey Abramov <st5pub@yandex.ru>
To: mchehab@kernel.org
Cc: gregkh@linuxfoundation.org, linux-media@vger.kernel.org,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        dan.carpenter@oracle.com, Andrey Abramov <st5pub@yandex.ru>
Subject: [PATCH] Staging: media: replaced deprecated probe method
Date: Mon,  1 Oct 2018 12:42:29 +0300
Message-Id: <20181001094229.9148-1-st5pub@yandex.ru>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Replaced i2c_driver::probe with i2c_driver::probe_new,
	because documentation says that probe method is "soon to be deprecated".
And fixed problems of the previous attempt.

Signed-off-by: Andrey Abramov <st5pub@yandex.ru>
---
 drivers/staging/media/bcm2048/radio-bcm2048.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/media/bcm2048/radio-bcm2048.c b/drivers/staging/media/bcm2048/radio-bcm2048.c
index a90b2eb112f9..6865e9fb6420 100644
--- a/drivers/staging/media/bcm2048/radio-bcm2048.c
+++ b/drivers/staging/media/bcm2048/radio-bcm2048.c
@@ -2574,8 +2574,7 @@ static const struct video_device bcm2048_viddev_template = {
 /*
  *	I2C driver interface
  */
-static int bcm2048_i2c_driver_probe(struct i2c_client *client,
-				    const struct i2c_device_id *id)
+static int bcm2048_i2c_driver_probe(struct i2c_client *client)
 {
 	struct bcm2048_device *bdev;
 	int err;
@@ -2679,7 +2678,7 @@ static struct i2c_driver bcm2048_i2c_driver = {
 	.driver		= {
 		.name	= BCM2048_DRIVER_NAME,
 	},
-	.probe		= bcm2048_i2c_driver_probe,
+	.probe_new	= bcm2048_i2c_driver_probe,
 	.remove		= bcm2048_i2c_driver_remove,
 	.id_table	= bcm2048_id,
 };
-- 
2.19.0
