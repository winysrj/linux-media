Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-gg0-f174.google.com ([209.85.161.174]:48325 "EHLO
	mail-gg0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757764Ab2F0Q6p (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 27 Jun 2012 12:58:45 -0400
Received: by gglu4 with SMTP id u4so1103063ggl.19
        for <linux-media@vger.kernel.org>; Wed, 27 Jun 2012 09:58:44 -0700 (PDT)
From: Ezequiel Garcia <elezegarcia@gmail.com>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: <linux-media@vger.kernel.org>, stoth@kernellabs.com,
	dan.carpenter@oracle.com, palash.bandyopadhyay@conexant.com,
	Ezequiel Garcia <elezegarcia@gmail.com>
Subject: [PATCH 9/9] cx25821: Replace struct memcpy with struct assignment
Date: Wed, 27 Jun 2012 13:52:54 -0300
Message-Id: <1340815974-4120-9-git-send-email-elezegarcia@gmail.com>
In-Reply-To: <1340815974-4120-1-git-send-email-elezegarcia@gmail.com>
References: <1340815974-4120-1-git-send-email-elezegarcia@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Copying structs by assignment is type safe.
Plus, is shorter and easier to read.

Signed-off-by: Ezequiel Garcia <elezegarcia@gmail.com>
---
 drivers/media/video/cx25821/cx25821-i2c.c |    7 ++-----
 1 files changed, 2 insertions(+), 5 deletions(-)

diff --git a/drivers/media/video/cx25821/cx25821-i2c.c b/drivers/media/video/cx25821/cx25821-i2c.c
index 0a44b4e..9844549 100644
--- a/drivers/media/video/cx25821/cx25821-i2c.c
+++ b/drivers/media/video/cx25821/cx25821-i2c.c
@@ -305,11 +305,8 @@ int cx25821_i2c_register(struct cx25821_i2c *bus)
 
 	dprintk(1, "%s(bus = %d)\n", __func__, bus->nr);
 
-	memcpy(&bus->i2c_adap, &cx25821_i2c_adap_template,
-	       sizeof(bus->i2c_adap));
-	memcpy(&bus->i2c_client, &cx25821_i2c_client_template,
-	       sizeof(bus->i2c_client));
-
+	bus->i2c_adap = cx25821_i2c_adap_template;
+	bus->i2c_client = cx25821_i2c_client_template;
 	bus->i2c_adap.dev.parent = &dev->pci->dev;
 
 	strlcpy(bus->i2c_adap.name, bus->dev->name, sizeof(bus->i2c_adap.name));
-- 
1.7.4.4

