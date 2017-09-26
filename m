Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wr0-f193.google.com ([209.85.128.193]:34747 "EHLO
        mail-wr0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754506AbdIZVK4 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 26 Sep 2017 17:10:56 -0400
Received: by mail-wr0-f193.google.com with SMTP id z1so309586wre.1
        for <linux-media@vger.kernel.org>; Tue, 26 Sep 2017 14:10:55 -0700 (PDT)
From: Malcolm Priestley <tvboxspy@gmail.com>
To: linux-media@vger.kernel.org
Cc: Andrey Konovalov <andreyknvl@google.com>,
        Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH 1/2] media: dvb-usb-v2: lmedm04: Improve logic checking of warm start.
Date: Tue, 26 Sep 2017 22:10:20 +0100
Message-Id: <20170926211021.11036-1-tvboxspy@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Warm start has no check as whether a genuine device has
connected and proceeds to next execution path.

Check device should read 0x47 at offset of 2 on USB descriptor read
and it is the amount requested of 6 bytes.

Fix for
kasan: CONFIG_KASAN_INLINE enabled
kasan: GPF could be caused by NULL-ptr deref or user memory access as

Reported-by: Andrey Konovalov <andreyknvl@google.com>
Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/media/usb/dvb-usb-v2/lmedm04.c | 26 ++++++++++++++++++--------
 1 file changed, 18 insertions(+), 8 deletions(-)

diff --git a/drivers/media/usb/dvb-usb-v2/lmedm04.c b/drivers/media/usb/dvb-usb-v2/lmedm04.c
index 5e320fa4a795..992f2011a6ba 100644
--- a/drivers/media/usb/dvb-usb-v2/lmedm04.c
+++ b/drivers/media/usb/dvb-usb-v2/lmedm04.c
@@ -494,18 +494,23 @@ static int lme2510_pid_filter(struct dvb_usb_adapter *adap, int index, u16 pid,
 
 static int lme2510_return_status(struct dvb_usb_device *d)
 {
-	int ret = 0;
+	int ret;
 	u8 *data;
 
-	data = kzalloc(10, GFP_KERNEL);
+	data = kzalloc(6, GFP_KERNEL);
 	if (!data)
 		return -ENOMEM;
 
-	ret |= usb_control_msg(d->udev, usb_rcvctrlpipe(d->udev, 0),
-			0x06, 0x80, 0x0302, 0x00, data, 0x0006, 200);
-	info("Firmware Status: %x (%x)", ret , data[2]);
+	ret = usb_control_msg(d->udev, usb_rcvctrlpipe(d->udev, 0),
+			      0x06, 0x80, 0x0302, 0x00,
+			      data, 0x6, 200);
+	if (ret != 6)
+		ret = -EINVAL;
+	else
+		ret = data[2];
+
+	info("Firmware Status: %6ph", data);
 
-	ret = (ret < 0) ? -ENODEV : data[2];
 	kfree(data);
 	return ret;
 }
@@ -1189,6 +1194,7 @@ static int lme2510_get_adapter_count(struct dvb_usb_device *d)
 static int lme2510_identify_state(struct dvb_usb_device *d, const char **name)
 {
 	struct lme2510_state *st = d->priv;
+	int status;
 
 	usb_reset_configuration(d->udev);
 
@@ -1197,12 +1203,16 @@ static int lme2510_identify_state(struct dvb_usb_device *d, const char **name)
 
 	st->dvb_usb_lme2510_firmware = dvb_usb_lme2510_firmware;
 
-	if (lme2510_return_status(d) == 0x44) {
+	status = lme2510_return_status(d);
+	if (status == 0x44) {
 		*name = lme_firmware_switch(d, 0);
 		return COLD;
 	}
 
-	return 0;
+	if (status != 0x47)
+		return -EINVAL;
+
+	return WARM;
 }
 
 static int lme2510_get_stream_config(struct dvb_frontend *fe, u8 *ts_type,
-- 
2.14.1
