Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:50567 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750711Ab1IUW5u (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 21 Sep 2011 18:57:50 -0400
Received: by wwf22 with SMTP id 22so1336623wwf.1
        for <linux-media@vger.kernel.org>; Wed, 21 Sep 2011 15:57:49 -0700 (PDT)
Subject: [PATCH] [VER 1.06] it913x add remote control support.
From: tvboxspy <tvboxspy@gmail.com>
To: linux-media@vger.kernel.org
Date: Wed, 21 Sep 2011 23:57:41 +0100
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Message-ID: <4e7a6bec.c964e30a.677a.ffffb4af@mx.google.com>
Mime-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add remote support for KWORLD UB499-2T-T09

The remote supplied is the same as KWORLD_315U.

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/media/dvb/dvb-usb/it913x.c |   34 +++++++++++++++++++++++++++++++++-
 1 files changed, 33 insertions(+), 1 deletions(-)

diff --git a/drivers/media/dvb/dvb-usb/it913x.c b/drivers/media/dvb/dvb-usb/it913x.c
index 6d2f281..f027a2c 100644
--- a/drivers/media/dvb/dvb-usb/it913x.c
+++ b/drivers/media/dvb/dvb-usb/it913x.c
@@ -306,6 +306,30 @@ static struct i2c_algorithm it913x_i2c_algo = {
 };
 
 /* Callbacks for DVB USB */
+#define IT913X_POLL 250
+static int it913x_rc_query(struct dvb_usb_device *d)
+{
+	u8 ibuf[4];
+	int ret;
+	u32 key;
+	/* Avoid conflict with frontends*/
+	if (mutex_lock_interruptible(&d->i2c_mutex) < 0)
+			return -EAGAIN;
+
+	ret = it913x_io(d->udev, READ_LONG, PRO_LINK, CMD_IR_GET,
+		0, 0, &ibuf[0], sizeof(ibuf));
+
+	if ((ibuf[2] + ibuf[3]) == 0xff) {
+		key = ibuf[2];
+		key += ibuf[0] << 8;
+		deb_info(1, "INT Key =%08x", key);
+		if (d->rc_dev != NULL)
+			rc_keydown(d->rc_dev, key, 0);
+	}
+	mutex_unlock(&d->i2c_mutex);
+
+	return ret;
+}
 static int it913x_identify_state(struct usb_device *udev,
 		struct dvb_usb_device_properties *props,
 		struct dvb_usb_device_description **desc,
@@ -575,6 +599,14 @@ static struct dvb_usb_device_properties it913x_properties = {
 		}
 	},
 	.identify_state   = it913x_identify_state,
+	.rc.core = {
+		.protocol	= RC_TYPE_NEC,
+		.module_name	= "it913x",
+		.rc_query	= it913x_rc_query,
+		.rc_interval	= IT913X_POLL,
+		.allowed_protos	= RC_TYPE_NEC,
+		.rc_codes	= RC_MAP_KWORLD_315U,
+	},
 	.i2c_algo         = &it913x_i2c_algo,
 	.num_device_descs = 1,
 	.devices = {
@@ -615,5 +647,5 @@ module_exit(it913x_module_exit);
 
 MODULE_AUTHOR("Malcolm Priestley <tvboxspy@gmail.com>");
 MODULE_DESCRIPTION("it913x USB 2 Driver");
-MODULE_VERSION("1.05");
+MODULE_VERSION("1.06");
 MODULE_LICENSE("GPL");
-- 
1.7.5.4


