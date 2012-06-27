Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yx0-f174.google.com ([209.85.213.174]:52927 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755653Ab2F0QxZ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 27 Jun 2012 12:53:25 -0400
Received: by mail-yx0-f174.google.com with SMTP id l2so1090102yen.19
        for <linux-media@vger.kernel.org>; Wed, 27 Jun 2012 09:53:25 -0700 (PDT)
From: Ezequiel Garcia <elezegarcia@gmail.com>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: <linux-media@vger.kernel.org>, stoth@kernellabs.com,
	dan.carpenter@oracle.com, palash.bandyopadhyay@conexant.com,
	Ezequiel Garcia <elezegarcia@gmail.com>
Subject: [PATCH 7/9] cx23885: Replace struct memcpy with struct assignment
Date: Wed, 27 Jun 2012 13:52:52 -0300
Message-Id: <1340815974-4120-7-git-send-email-elezegarcia@gmail.com>
In-Reply-To: <1340815974-4120-1-git-send-email-elezegarcia@gmail.com>
References: <1340815974-4120-1-git-send-email-elezegarcia@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Copying structs by assignment is type safe.
Plus, is shorter and easier to read.

Signed-off-by: Ezequiel Garcia <elezegarcia@gmail.com>
---
 drivers/media/video/cx23885/cx23885-i2c.c |    7 ++-----
 1 files changed, 2 insertions(+), 5 deletions(-)

diff --git a/drivers/media/video/cx23885/cx23885-i2c.c b/drivers/media/video/cx23885/cx23885-i2c.c
index 615c71f..4887314 100644
--- a/drivers/media/video/cx23885/cx23885-i2c.c
+++ b/drivers/media/video/cx23885/cx23885-i2c.c
@@ -316,11 +316,8 @@ int cx23885_i2c_register(struct cx23885_i2c *bus)
 
 	dprintk(1, "%s(bus = %d)\n", __func__, bus->nr);
 
-	memcpy(&bus->i2c_adap, &cx23885_i2c_adap_template,
-	       sizeof(bus->i2c_adap));
-	memcpy(&bus->i2c_client, &cx23885_i2c_client_template,
-	       sizeof(bus->i2c_client));
-
+	bus->i2c_adap = cx23885_i2c_adap_template;
+	bus->i2c_client = cx23885_i2c_client_template;
 	bus->i2c_adap.dev.parent = &dev->pci->dev;
 
 	strlcpy(bus->i2c_adap.name, bus->dev->name,
-- 
1.7.4.4

