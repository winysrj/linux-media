Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-gh0-f174.google.com ([209.85.160.174]:38201 "EHLO
	mail-gh0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752686Ab2FRTYU (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 18 Jun 2012 15:24:20 -0400
Received: by mail-gh0-f174.google.com with SMTP id r11so3997516ghr.19
        for <linux-media@vger.kernel.org>; Mon, 18 Jun 2012 12:24:20 -0700 (PDT)
From: Ezequiel Garcia <elezegarcia@gmail.com>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: <linux-media@vger.kernel.org>,
	Ezequiel Garcia <elezegarcia@gmail.com>
Subject: [PATCH 09/12] cx231xx: Replace struct memcpy with struct assignment
Date: Mon, 18 Jun 2012 16:23:42 -0300
Message-Id: <1340047425-32000-9-git-send-email-elezegarcia@gmail.com>
In-Reply-To: <1340047425-32000-1-git-send-email-elezegarcia@gmail.com>
References: <1340047425-32000-1-git-send-email-elezegarcia@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Ezequiel Garcia <elezegarcia@gmail.com>
---
 drivers/media/video/cx231xx/cx231xx-i2c.c |    6 ++----
 1 files changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/media/video/cx231xx/cx231xx-i2c.c b/drivers/media/video/cx231xx/cx231xx-i2c.c
index f5f4844..2b2e91e 100644
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

