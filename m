Return-path: <linux-media-owner@vger.kernel.org>
Received: from sub5.mail.dreamhost.com ([208.113.200.129]:51048 "EHLO
        homiemail-a48.g.dreamhost.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1755299AbeDQQkZ (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 17 Apr 2018 12:40:25 -0400
From: Brad Love <brad@nextdimension.cc>
To: linux-media@vger.kernel.org, mchehab@s-opensource.com
Cc: Brad Love <brad@nextdimension.cc>
Subject: [PATCH 4/9] [bug] cx231xx: Ignore an i2c mux adapter
Date: Tue, 17 Apr 2018 11:39:50 -0500
Message-Id: <1523983195-28691-5-git-send-email-brad@nextdimension.cc>
In-Reply-To: <1523983195-28691-1-git-send-email-brad@nextdimension.cc>
References: <1523983195-28691-1-git-send-email-brad@nextdimension.cc>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hauppauge 935C cannot communicate with the si2157
when using the mux adapter returned by the si2168,
so disable it to fix the device.

Signed-off-by: Brad Love <brad@nextdimension.cc>
---
 drivers/media/usb/cx231xx/cx231xx-dvb.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/usb/cx231xx/cx231xx-dvb.c b/drivers/media/usb/cx231xx/cx231xx-dvb.c
index 12f2dcc..681610f 100644
--- a/drivers/media/usb/cx231xx/cx231xx-dvb.c
+++ b/drivers/media/usb/cx231xx/cx231xx-dvb.c
@@ -1146,7 +1146,7 @@ static int dvb_init(struct cx231xx *dev)
 		info.platform_data = &si2157_config;
 		request_module("si2157");
 
-		client = i2c_new_device(adapter, &info);
+		client = i2c_new_device(tuner_i2c, &info);
 		if (client == NULL || client->dev.driver == NULL) {
 			module_put(dvb->i2c_client_demod[0]->dev.driver->owner);
 			i2c_unregister_device(dvb->i2c_client_demod[0]);
-- 
2.7.4
