Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-gg0-f174.google.com ([209.85.161.174]:48879 "EHLO
	mail-gg0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752005Ab2FRTY0 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 18 Jun 2012 15:24:26 -0400
Received: by mail-gg0-f174.google.com with SMTP id u4so4009733ggl.19
        for <linux-media@vger.kernel.org>; Mon, 18 Jun 2012 12:24:26 -0700 (PDT)
From: Ezequiel Garcia <elezegarcia@gmail.com>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: <linux-media@vger.kernel.org>,
	Ezequiel Garcia <elezegarcia@gmail.com>
Subject: [PATCH 12/12] cx25821: Replace struct memcpy with struct assignment
Date: Mon, 18 Jun 2012 16:23:45 -0300
Message-Id: <1340047425-32000-12-git-send-email-elezegarcia@gmail.com>
In-Reply-To: <1340047425-32000-1-git-send-email-elezegarcia@gmail.com>
References: <1340047425-32000-1-git-send-email-elezegarcia@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Ezequiel Garcia <elezegarcia@gmail.com>
---
 drivers/media/video/cx25821/cx25821-i2c.c |    7 ++-----
 1 files changed, 2 insertions(+), 5 deletions(-)

diff --git a/drivers/media/video/cx25821/cx25821-i2c.c b/drivers/media/video/cx25821/cx25821-i2c.c
index 431fa7f..8a823b8 100644
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

