Return-path: <linux-media-owner@vger.kernel.org>
Received: from sub5.mail.dreamhost.com ([208.113.200.129]:44140 "EHLO
        homiemail-a48.g.dreamhost.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1753876AbeCFTPH (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 6 Mar 2018 14:15:07 -0500
From: Brad Love <brad@nextdimension.cc>
To: linux-media@vger.kernel.org
Cc: Brad Love <brad@nextdimension.cc>
Subject: [PATCH 3/8] cx231xx: Use frontend i2c adapter with tuner
Date: Tue,  6 Mar 2018 13:14:57 -0600
Message-Id: <1520363702-25536-4-git-send-email-brad@nextdimension.cc>
In-Reply-To: <1520363702-25536-1-git-send-email-brad@nextdimension.cc>
References: <1520363702-25536-1-git-send-email-brad@nextdimension.cc>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Utilize the i2c mux adapter returned by the frontend.

Signed-off-by: Brad Love <brad@nextdimension.cc>
---
 drivers/media/usb/cx231xx/cx231xx-dvb.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/usb/cx231xx/cx231xx-dvb.c b/drivers/media/usb/cx231xx/cx231xx-dvb.c
index 63deca9..c3b2d69 100644
--- a/drivers/media/usb/cx231xx/cx231xx-dvb.c
+++ b/drivers/media/usb/cx231xx/cx231xx-dvb.c
@@ -1221,7 +1221,7 @@ static int dvb_init(struct cx231xx *dev)
 		info.platform_data = &si2157_config;
 		request_module("si2157");
 
-		client = i2c_new_device(tuner_i2c, &info);
+		client = i2c_new_device(adapter, &info);
 		if (client == NULL || client->dev.driver == NULL) {
 			module_put(dvb->i2c_client_demod[0]->dev.driver->owner);
 			i2c_unregister_device(dvb->i2c_client_demod[0]);
-- 
2.7.4
