Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.gentoo.org ([140.211.166.183]:43837 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750864AbaIYFIV (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 25 Sep 2014 01:08:21 -0400
From: Matthias Schwarzott <zzam@gentoo.org>
To: linux-media@vger.kernel.org, mchehab@osg.samsung.com
Cc: Matthias Schwarzott <zzam@gentoo.org>
Subject: [PATCH 04/12] cx231xx: give each master i2c bus a seperate name
Date: Thu, 25 Sep 2014 07:07:56 +0200
Message-Id: <1411621684-8295-4-git-send-email-zzam@gentoo.org>
In-Reply-To: <1411621684-8295-1-git-send-email-zzam@gentoo.org>
References: <1411621684-8295-1-git-send-email-zzam@gentoo.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Matthias Schwarzott <zzam@gentoo.org>
---
 drivers/media/usb/cx231xx/cx231xx-i2c.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/media/usb/cx231xx/cx231xx-i2c.c b/drivers/media/usb/cx231xx/cx231xx-i2c.c
index a30d400..178fa48 100644
--- a/drivers/media/usb/cx231xx/cx231xx-i2c.c
+++ b/drivers/media/usb/cx231xx/cx231xx-i2c.c
@@ -506,6 +506,7 @@ void cx231xx_do_i2c_scan(struct cx231xx *dev, int i2c_port)
 int cx231xx_i2c_register(struct cx231xx_i2c *bus)
 {
 	struct cx231xx *dev = bus->dev;
+	char bus_name[3];
 
 	BUG_ON(!dev->cx231xx_send_usb_command);
 
@@ -513,6 +514,10 @@ int cx231xx_i2c_register(struct cx231xx_i2c *bus)
 	bus->i2c_adap.dev.parent = &dev->udev->dev;
 
 	strlcpy(bus->i2c_adap.name, bus->dev->name, sizeof(bus->i2c_adap.name));
+	bus_name[0] = '-';
+	bus_name[1] = '0' + bus->nr;
+	bus_name[2] = '\0';
+	strlcat(bus->i2c_adap.name, bus_name, sizeof(bus->i2c_adap.name));
 
 	bus->i2c_adap.algo_data = bus;
 	i2c_set_adapdata(&bus->i2c_adap, &dev->v4l2_dev);
-- 
2.1.1

