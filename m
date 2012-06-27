Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yx0-f174.google.com ([209.85.213.174]:38194 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754627Ab2F0Q6l (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 27 Jun 2012 12:58:41 -0400
Received: by yenl2 with SMTP id l2so1095242yen.19
        for <linux-media@vger.kernel.org>; Wed, 27 Jun 2012 09:58:40 -0700 (PDT)
From: Ezequiel Garcia <elezegarcia@gmail.com>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: <linux-media@vger.kernel.org>, stoth@kernellabs.com,
	dan.carpenter@oracle.com, palash.bandyopadhyay@conexant.com,
	Ezequiel Garcia <elezegarcia@gmail.com>
Subject: [PATCH 6/9] saa7164: Replace struct memcpy with struct assignment
Date: Wed, 27 Jun 2012 13:52:51 -0300
Message-Id: <1340815974-4120-6-git-send-email-elezegarcia@gmail.com>
In-Reply-To: <1340815974-4120-1-git-send-email-elezegarcia@gmail.com>
References: <1340815974-4120-1-git-send-email-elezegarcia@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Copying structs by assignment is type safe.
Plus, is shorter and easier to read.

Signed-off-by: Ezequiel Garcia <elezegarcia@gmail.com>
---
 drivers/media/video/saa7164/saa7164-i2c.c |    7 ++-----
 1 files changed, 2 insertions(+), 5 deletions(-)

diff --git a/drivers/media/video/saa7164/saa7164-i2c.c b/drivers/media/video/saa7164/saa7164-i2c.c
index d8d7baa..4f7e3b4 100644
--- a/drivers/media/video/saa7164/saa7164-i2c.c
+++ b/drivers/media/video/saa7164/saa7164-i2c.c
@@ -97,11 +97,8 @@ int saa7164_i2c_register(struct saa7164_i2c *bus)
 
 	dprintk(DBGLVL_I2C, "%s(bus = %d)\n", __func__, bus->nr);
 
-	memcpy(&bus->i2c_adap, &saa7164_i2c_adap_template,
-	       sizeof(bus->i2c_adap));
-
-	memcpy(&bus->i2c_client, &saa7164_i2c_client_template,
-	       sizeof(bus->i2c_client));
+	bus->i2c_adap = saa7164_i2c_adap_template;
+	bus->i2c_client = saa7164_i2c_client_template;
 
 	bus->i2c_adap.dev.parent = &dev->pci->dev;
 
-- 
1.7.4.4

