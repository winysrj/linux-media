Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:36242 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750797AbdE1McJ (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Sun, 28 May 2017 08:32:09 -0400
From: Hans de Goede <hdegoede@redhat.com>
To: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Alan Cox <alan@linux.intel.com>
Cc: Hans de Goede <hdegoede@redhat.com>, linux-media@vger.kernel.org,
        devel@driverdev.osuosl.org
Subject: [PATCH 7/7] staging: atomisp: Make ov2680 driver less chatty
Date: Sun, 28 May 2017 14:31:53 +0200
Message-Id: <20170528123153.18613-7-hdegoede@redhat.com>
In-Reply-To: <20170528123153.18613-1-hdegoede@redhat.com>
References: <20170528123153.18613-1-hdegoede@redhat.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

There is no reason for all this printk spamming and certainly
not at an error log level.

Signed-off-by: Hans de Goede <hdegoede@redhat.com>
---
 drivers/staging/media/atomisp/i2c/ov2680.c | 7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff --git a/drivers/staging/media/atomisp/i2c/ov2680.c b/drivers/staging/media/atomisp/i2c/ov2680.c
index 6dd466558701..3cabfe54c669 100644
--- a/drivers/staging/media/atomisp/i2c/ov2680.c
+++ b/drivers/staging/media/atomisp/i2c/ov2680.c
@@ -1191,9 +1191,8 @@ static int ov2680_detect(struct i2c_client *client)
 					OV2680_SC_CMMN_SUB_ID, &high);
 	revision = (u8) high & 0x0f;
 
-	dev_err(&client->dev, "sensor_revision id  = 0x%x\n", id);
-	dev_err(&client->dev, "detect ov2680 success\n");
-	dev_err(&client->dev, "################5##########\n");
+	dev_info(&client->dev, "sensor_revision id = 0x%x\n", id);
+
 	return 0;
 }
 
@@ -1448,8 +1447,6 @@ static int ov2680_probe(struct i2c_client *client,
 	void *pdata;
 	unsigned int i;
 
-	printk("++++ov2680_probe++++\n");
-	dev_info(&client->dev, "++++ov2680_probe++++\n");
 	dev = kzalloc(sizeof(*dev), GFP_KERNEL);
 	if (!dev) {
 		dev_err(&client->dev, "out of memory\n");
-- 
2.13.0
