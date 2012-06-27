Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yx0-f174.google.com ([209.85.213.174]:52927 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755653Ab2F0QxV (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 27 Jun 2012 12:53:21 -0400
Received: by yenl2 with SMTP id l2so1090102yen.19
        for <linux-media@vger.kernel.org>; Wed, 27 Jun 2012 09:53:20 -0700 (PDT)
From: Ezequiel Garcia <elezegarcia@gmail.com>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: <linux-media@vger.kernel.org>, stoth@kernellabs.com,
	dan.carpenter@oracle.com, palash.bandyopadhyay@conexant.com,
	Ezequiel Garcia <elezegarcia@gmail.com>
Subject: [PATCH 5/9] saa7164: Remove unused saa7164_call_i2c_clients()
Date: Wed, 27 Jun 2012 13:52:50 -0300
Message-Id: <1340815974-4120-5-git-send-email-elezegarcia@gmail.com>
In-Reply-To: <1340815974-4120-1-git-send-email-elezegarcia@gmail.com>
References: <1340815974-4120-1-git-send-email-elezegarcia@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This function has no users, so it's safe to remove it.
Tested by compilation only.

Signed-off-by: Ezequiel Garcia <elezegarcia@gmail.com>
---
 drivers/media/video/saa7164/saa7164-i2c.c |    9 ---------
 1 files changed, 0 insertions(+), 9 deletions(-)

diff --git a/drivers/media/video/saa7164/saa7164-i2c.c b/drivers/media/video/saa7164/saa7164-i2c.c
index 1c54ab4..d8d7baa 100644
--- a/drivers/media/video/saa7164/saa7164-i2c.c
+++ b/drivers/media/video/saa7164/saa7164-i2c.c
@@ -69,15 +69,6 @@ err:
 	return retval;
 }
 
-void saa7164_call_i2c_clients(struct saa7164_i2c *bus, unsigned int cmd,
-	void *arg)
-{
-	if (bus->i2c_rc != 0)
-		return;
-
-	i2c_clients_command(&bus->i2c_adap, cmd, arg);
-}
-
 static u32 saa7164_functionality(struct i2c_adapter *adap)
 {
 	return I2C_FUNC_I2C;
-- 
1.7.4.4

