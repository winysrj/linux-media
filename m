Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ww0-f42.google.com ([74.125.82.42]:44180 "EHLO
	mail-ww0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751494Ab1K1WWx (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 28 Nov 2011 17:22:53 -0500
Received: by wwo28 with SMTP id 28so8273425wwo.1
        for <linux-media@vger.kernel.org>; Mon, 28 Nov 2011 14:22:52 -0800 (PST)
Message-ID: <1322518961.2121.26.camel@tvbox>
Subject: [PATCH] it913x support for NEC extended keys
From: Malcolm Priestley <tvboxspy@gmail.com>
To: linux-media@vger.kernel.org
Date: Mon, 28 Nov 2011 22:22:41 +0000
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


Add support for NEC extended keys.

The default remote has now changed to RC_MAP_MSI_DIGIVOX_III

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/media/dvb/dvb-usb/it913x.c |   10 ++++++----
 1 files changed, 6 insertions(+), 4 deletions(-)

diff --git a/drivers/media/dvb/dvb-usb/it913x.c b/drivers/media/dvb/dvb-usb/it913x.c
index d57e062..394bbf4 100644
--- a/drivers/media/dvb/dvb-usb/it913x.c
+++ b/drivers/media/dvb/dvb-usb/it913x.c
@@ -328,11 +328,13 @@ static int it913x_rc_query(struct dvb_usb_device *d)
 
 	if ((ibuf[2] + ibuf[3]) == 0xff) {
 		key = ibuf[2];
-		key += ibuf[0] << 8;
-		deb_info(1, "INT Key =%08x", key);
+		key += ibuf[0] << 16;
+		key += ibuf[1] << 8;
+		deb_info(1, "NEC Extended Key =%08x", key);
 		if (d->rc_dev != NULL)
 			rc_keydown(d->rc_dev, key, 0);
 	}
+
 	mutex_unlock(&d->i2c_mutex);
 
 	return ret;
@@ -701,7 +703,7 @@ static struct dvb_usb_device_properties it913x_properties = {
 		.rc_query	= it913x_rc_query,
 		.rc_interval	= IT913X_POLL,
 		.allowed_protos	= RC_TYPE_NEC,
-		.rc_codes	= RC_MAP_KWORLD_315U,
+		.rc_codes	= RC_MAP_MSI_DIGIVOX_III,
 	},
 	.i2c_algo         = &it913x_i2c_algo,
 	.num_device_descs = 3,
@@ -748,5 +750,5 @@ module_exit(it913x_module_exit);
 
 MODULE_AUTHOR("Malcolm Priestley <tvboxspy@gmail.com>");
 MODULE_DESCRIPTION("it913x USB 2 Driver");
-MODULE_VERSION("1.09");
+MODULE_VERSION("1.11");
 MODULE_LICENSE("GPL");
-- 
1.7.7.1


