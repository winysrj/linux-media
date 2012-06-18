Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-gg0-f174.google.com ([209.85.161.174]:48879 "EHLO
	mail-gg0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751722Ab2FRTYG (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 18 Jun 2012 15:24:06 -0400
Received: by gglu4 with SMTP id u4so4009733ggl.19
        for <linux-media@vger.kernel.org>; Mon, 18 Jun 2012 12:24:06 -0700 (PDT)
From: Ezequiel Garcia <elezegarcia@gmail.com>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: <linux-media@vger.kernel.org>,
	Ezequiel Garcia <elezegarcia@gmail.com>
Subject: [PATCH 02/12] saa7164: Remove useless struct i2c_algo_bit_data
Date: Mon, 18 Jun 2012 16:23:35 -0300
Message-Id: <1340047425-32000-2-git-send-email-elezegarcia@gmail.com>
In-Reply-To: <1340047425-32000-1-git-send-email-elezegarcia@gmail.com>
References: <1340047425-32000-1-git-send-email-elezegarcia@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Ezequiel Garcia <elezegarcia@gmail.com>
---
 drivers/media/video/saa7164/saa7164-i2c.c |    4 ----
 drivers/media/video/saa7164/saa7164.h     |    1 -
 2 files changed, 0 insertions(+), 5 deletions(-)

diff --git a/drivers/media/video/saa7164/saa7164-i2c.c b/drivers/media/video/saa7164/saa7164-i2c.c
index 536f7dc..8df15ca 100644
--- a/drivers/media/video/saa7164/saa7164-i2c.c
+++ b/drivers/media/video/saa7164/saa7164-i2c.c
@@ -109,9 +109,6 @@ int saa7164_i2c_register(struct saa7164_i2c *bus)
 	memcpy(&bus->i2c_adap, &saa7164_i2c_adap_template,
 	       sizeof(bus->i2c_adap));
 
-	memcpy(&bus->i2c_algo, &saa7164_i2c_algo_template,
-	       sizeof(bus->i2c_algo));
-
 	memcpy(&bus->i2c_client, &saa7164_i2c_client_template,
 	       sizeof(bus->i2c_client));
 
@@ -120,7 +117,6 @@ int saa7164_i2c_register(struct saa7164_i2c *bus)
 	strlcpy(bus->i2c_adap.name, bus->dev->name,
 		sizeof(bus->i2c_adap.name));
 
-	bus->i2c_algo.data = bus;
 	bus->i2c_adap.algo_data = bus;
 	i2c_set_adapdata(&bus->i2c_adap, bus);
 	bus->i2c_rc = i2c_add_adapter(&bus->i2c_adap);
diff --git a/drivers/media/video/saa7164/saa7164.h b/drivers/media/video/saa7164/saa7164.h
index 8d120e3..fc1f854 100644
--- a/drivers/media/video/saa7164/saa7164.h
+++ b/drivers/media/video/saa7164/saa7164.h
@@ -251,7 +251,6 @@ struct saa7164_i2c {
 
 	/* I2C I/O */
 	struct i2c_adapter		i2c_adap;
-	struct i2c_algo_bit_data	i2c_algo;
 	struct i2c_client		i2c_client;
 	u32				i2c_rc;
 };
-- 
1.7.4.4

