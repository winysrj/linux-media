Return-path: <linux-media-owner@vger.kernel.org>
Received: from sub5.mail.dreamhost.com ([208.113.200.129]:34158 "EHLO
        homiemail-a56.g.dreamhost.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751593AbeAEO51 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 5 Jan 2018 09:57:27 -0500
From: Brad Love <brad@nextdimension.cc>
To: linux-media@vger.kernel.org
Cc: Brad Love <brad@nextdimension.cc>
Subject: [PATCH 1/2] lgdt3306a: Fix module count mismatch on usb unplug
Date: Fri,  5 Jan 2018 08:57:12 -0600
Message-Id: <1515164233-2423-2-git-send-email-brad@nextdimension.cc>
In-Reply-To: <1515164233-2423-1-git-send-email-brad@nextdimension.cc>
References: <1515164233-2423-1-git-send-email-brad@nextdimension.cc>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

When used as an i2c device there is a module usage count mismatch on
removal, preventing the driver from being used thereafter. dvb_attach
increments the usage count so it is properly balanced on removal.

On disconnect of Hauppauge SoloHD/DualHD before:

lsmod | grep lgdt3306a
lgdt3306a              28672  -1
i2c_mux                16384  1 lgdt3306a

On disconnect of Hauppauge SoloHD/DualHD after:

lsmod | grep lgdt3306a
lgdt3306a              28672  0
i2c_mux                16384  1 lgdt3306a

Signed-off-by: Brad Love <brad@nextdimension.cc>
---
 drivers/media/dvb-frontends/lgdt3306a.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/dvb-frontends/lgdt3306a.c b/drivers/media/dvb-frontends/lgdt3306a.c
index 6356815..d370671 100644
--- a/drivers/media/dvb-frontends/lgdt3306a.c
+++ b/drivers/media/dvb-frontends/lgdt3306a.c
@@ -2169,7 +2169,7 @@ static int lgdt3306a_probe(struct i2c_client *client,
 			sizeof(struct lgdt3306a_config));
 
 	config->i2c_addr = client->addr;
-	fe = lgdt3306a_attach(config, client->adapter);
+	fe = dvb_attach(lgdt3306a_attach, config, client->adapter);
 	if (fe == NULL) {
 		ret = -ENODEV;
 		goto err_fe;
-- 
2.7.4
