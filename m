Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.gentoo.org ([140.211.166.183]:34757 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750750AbaJAFUg (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 1 Oct 2014 01:20:36 -0400
From: Matthias Schwarzott <zzam@gentoo.org>
To: linux-media@vger.kernel.org, mchehab@osg.samsung.com, crope@iki.fi
Cc: Matthias Schwarzott <zzam@gentoo.org>
Subject: [PATCH V2 03/13] cx231xx: delete i2c_client per bus
Date: Wed,  1 Oct 2014 07:20:11 +0200
Message-Id: <1412140821-16285-4-git-send-email-zzam@gentoo.org>
In-Reply-To: <1412140821-16285-1-git-send-email-zzam@gentoo.org>
References: <1412140821-16285-1-git-send-email-zzam@gentoo.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

For each i2c master there is a i2c_client allocated that could be
deleted now that its only two users have been changed to use their
own i2c_client.

Signed-off-by: Matthias Schwarzott <zzam@gentoo.org>
Reviewed-by: Antti Palosaari <crope@iki.fi>
---
 drivers/media/usb/cx231xx/cx231xx-i2c.c | 7 -------
 drivers/media/usb/cx231xx/cx231xx.h     | 1 -
 2 files changed, 8 deletions(-)

diff --git a/drivers/media/usb/cx231xx/cx231xx-i2c.c b/drivers/media/usb/cx231xx/cx231xx-i2c.c
index 67a1391..a30d400 100644
--- a/drivers/media/usb/cx231xx/cx231xx-i2c.c
+++ b/drivers/media/usb/cx231xx/cx231xx-i2c.c
@@ -455,10 +455,6 @@ static struct i2c_adapter cx231xx_adap_template = {
 	.algo = &cx231xx_algo,
 };
 
-static struct i2c_client cx231xx_client_template = {
-	.name = "cx231xx internal",
-};
-
 /* ----------------------------------------------------------- */
 
 /*
@@ -514,7 +510,6 @@ int cx231xx_i2c_register(struct cx231xx_i2c *bus)
 	BUG_ON(!dev->cx231xx_send_usb_command);
 
 	bus->i2c_adap = cx231xx_adap_template;
-	bus->i2c_client = cx231xx_client_template;
 	bus->i2c_adap.dev.parent = &dev->udev->dev;
 
 	strlcpy(bus->i2c_adap.name, bus->dev->name, sizeof(bus->i2c_adap.name));
@@ -523,8 +518,6 @@ int cx231xx_i2c_register(struct cx231xx_i2c *bus)
 	i2c_set_adapdata(&bus->i2c_adap, &dev->v4l2_dev);
 	i2c_add_adapter(&bus->i2c_adap);
 
-	bus->i2c_client.adapter = &bus->i2c_adap;
-
 	if (0 == bus->i2c_rc) {
 		if (i2c_scan)
 			cx231xx_do_i2c_scan(dev, bus->nr);
diff --git a/drivers/media/usb/cx231xx/cx231xx.h b/drivers/media/usb/cx231xx/cx231xx.h
index 5efc93e..c92382f 100644
--- a/drivers/media/usb/cx231xx/cx231xx.h
+++ b/drivers/media/usb/cx231xx/cx231xx.h
@@ -472,7 +472,6 @@ struct cx231xx_i2c {
 
 	/* i2c i/o */
 	struct i2c_adapter i2c_adap;
-	struct i2c_client i2c_client;
 	u32 i2c_rc;
 
 	/* different settings for each bus */
-- 
2.1.1

