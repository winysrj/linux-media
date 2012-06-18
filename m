Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-gh0-f174.google.com ([209.85.160.174]:38201 "EHLO
	mail-gh0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752686Ab2FRTYO (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 18 Jun 2012 15:24:14 -0400
Received: by mail-gh0-f174.google.com with SMTP id r11so3997516ghr.19
        for <linux-media@vger.kernel.org>; Mon, 18 Jun 2012 12:24:14 -0700 (PDT)
From: Ezequiel Garcia <elezegarcia@gmail.com>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: <linux-media@vger.kernel.org>,
	Ezequiel Garcia <elezegarcia@gmail.com>
Subject: [PATCH 06/12] cx23885: Replace struct memcpy with struct assignment
Date: Mon, 18 Jun 2012 16:23:39 -0300
Message-Id: <1340047425-32000-6-git-send-email-elezegarcia@gmail.com>
In-Reply-To: <1340047425-32000-1-git-send-email-elezegarcia@gmail.com>
References: <1340047425-32000-1-git-send-email-elezegarcia@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Ezequiel Garcia <elezegarcia@gmail.com>
---
 drivers/media/video/cx23885/cx23885-i2c.c |    7 ++-----
 1 files changed, 2 insertions(+), 5 deletions(-)

diff --git a/drivers/media/video/cx23885/cx23885-i2c.c b/drivers/media/video/cx23885/cx23885-i2c.c
index 1404050..4c7941b 100644
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

