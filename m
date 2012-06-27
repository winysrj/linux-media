Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-gh0-f174.google.com ([209.85.160.174]:59412 "EHLO
	mail-gh0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755653Ab2F0Qx2 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 27 Jun 2012 12:53:28 -0400
Received: by mail-gh0-f174.google.com with SMTP id r11so1108076ghr.19
        for <linux-media@vger.kernel.org>; Wed, 27 Jun 2012 09:53:28 -0700 (PDT)
From: Ezequiel Garcia <elezegarcia@gmail.com>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: <linux-media@vger.kernel.org>, stoth@kernellabs.com,
	dan.carpenter@oracle.com, palash.bandyopadhyay@conexant.com,
	Ezequiel Garcia <elezegarcia@gmail.com>
Subject: [PATCH 8/9] cx231xx: Replace struct memcpy with struct assignment
Date: Wed, 27 Jun 2012 13:52:53 -0300
Message-Id: <1340815974-4120-8-git-send-email-elezegarcia@gmail.com>
In-Reply-To: <1340815974-4120-1-git-send-email-elezegarcia@gmail.com>
References: <1340815974-4120-1-git-send-email-elezegarcia@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Copying structs by assignment is type safe.
Plus, is shorter and easier to read.

Signed-off-by: Ezequiel Garcia <elezegarcia@gmail.com>
---
 drivers/media/video/cx231xx/cx231xx-i2c.c |    6 ++----
 1 files changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/media/video/cx231xx/cx231xx-i2c.c b/drivers/media/video/cx231xx/cx231xx-i2c.c
index 7c0ed1b..781feed 100644
--- a/drivers/media/video/cx231xx/cx231xx-i2c.c
+++ b/drivers/media/video/cx231xx/cx231xx-i2c.c
@@ -499,10 +499,8 @@ int cx231xx_i2c_register(struct cx231xx_i2c *bus)
 
 	BUG_ON(!dev->cx231xx_send_usb_command);
 
-	memcpy(&bus->i2c_adap, &cx231xx_adap_template, sizeof(bus->i2c_adap));
-	memcpy(&bus->i2c_client, &cx231xx_client_template,
-	       sizeof(bus->i2c_client));
-
+	bus->i2c_adap = cx231xx_adap_template;
+	bus->i2c_client = cx231xx_client_template;
 	bus->i2c_adap.dev.parent = &dev->udev->dev;
 
 	strlcpy(bus->i2c_adap.name, bus->dev->name, sizeof(bus->i2c_adap.name));
-- 
1.7.4.4

