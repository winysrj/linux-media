Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pa0-f54.google.com ([209.85.220.54]:50888 "EHLO
	mail-pa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753341AbaKHIee (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 8 Nov 2014 03:34:34 -0500
Received: by mail-pa0-f54.google.com with SMTP id rd3so5042916pab.13
        for <linux-media@vger.kernel.org>; Sat, 08 Nov 2014 00:34:34 -0800 (PST)
Date: Sat, 8 Nov 2014 16:34:30 +0800
From: "Nibble Max" <nibble.max@gmail.com>
To: "Olli Salonen" <olli.salonen@iki.fi>
Cc: "linux-media" <linux-media@vger.kernel.org>,
	"Antti Palosaari" <crope@iki.fi>
Subject: [PATCH 1/1] dvb-usb-dvbsky: fix i2c adapter for sp2 device
Message-ID: <201411081634137039659@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

It is wrong that sp2 device uses the i2c adapter from m88ds3103 return.
sp2 device sits on the same i2c bus with m88ds3103, not behind m88ds3103.

Signed-off-by: Nibble Max <nibble.max@gmail.com>
---
 drivers/media/usb/dvb-usb-v2/dvbsky.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/usb/dvb-usb-v2/dvbsky.c b/drivers/media/usb/dvb-usb-v2/dvbsky.c
index c67a118..8be8447 100644
--- a/drivers/media/usb/dvb-usb-v2/dvbsky.c
+++ b/drivers/media/usb/dvb-usb-v2/dvbsky.c
@@ -479,7 +479,7 @@ static int dvbsky_s960c_attach(struct dvb_usb_adapter *adap)
 	info.addr = 0x40;
 	info.platform_data = &sp2_config;
 	request_module("sp2");
-	client_ci = i2c_new_device(i2c_adapter, &info);
+	client_ci = i2c_new_device(&d->i2c_adap, &info);
 	if (client_ci == NULL || client_ci->dev.driver == NULL) {
 		ret = -ENODEV;
 		goto fail_ci_device;
 
-- 
1.9.1

