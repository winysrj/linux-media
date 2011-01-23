Return-path: <mchehab@pedra>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:38526 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751416Ab1AWVWw (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 23 Jan 2011 16:22:52 -0500
Received: by wwa36 with SMTP id 36so3688236wwa.1
        for <linux-media@vger.kernel.org>; Sun, 23 Jan 2011 13:22:51 -0800 (PST)
Subject: [PATCH 1/2] DM04/QQBOX Update V1.76 - use 32 bit remote decoding
From: Malcolm Priestley <tvboxspy@gmail.com>
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 23 Jan 2011 21:22:45 +0000
Message-ID: <1295817765.3007.4.camel@tvboxspy>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Use 32 bit decoding to add support for more than one variant of remote
control.

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/media/dvb/dvb-usb/lmedm04.c |    7 ++++---
 1 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/media/dvb/dvb-usb/lmedm04.c b/drivers/media/dvb/dvb-usb/lmedm04.c
index 46ccd01..c58d3fc 100644
--- a/drivers/media/dvb/dvb-usb/lmedm04.c
+++ b/drivers/media/dvb/dvb-usb/lmedm04.c
@@ -191,7 +191,7 @@ static int lme2510_stream_restart(struct dvb_usb_device *d)
 			rbuff, sizeof(rbuff));
 	return ret;
 }
-static int lme2510_remote_keypress(struct dvb_usb_adapter *adap, u16 keypress)
+static int lme2510_remote_keypress(struct dvb_usb_adapter *adap, u32 keypress)
 {
 	struct dvb_usb_device *d = adap->dev;
 
@@ -237,7 +237,8 @@ static void lme2510_int_response(struct urb *lme_urb)
 		case 0xaa:
 			debug_data_snipet(1, "INT Remote data snipet in", ibuf);
 			lme2510_remote_keypress(adap,
-				(u16)(ibuf[4]<<8)+ibuf[5]);
+				(u32)(ibuf[2] << 24) + (ibuf[3] << 16) +
+				(ibuf[4] << 8) + ibuf[5]);
 			break;
 		case 0xbb:
 			switch (st->tuner_config) {
@@ -1109,5 +1110,5 @@ module_exit(lme2510_module_exit);
 
 MODULE_AUTHOR("Malcolm Priestley <tvboxspy@gmail.com>");
 MODULE_DESCRIPTION("LME2510(C) DVB-S USB2.0");
-MODULE_VERSION("1.75");
+MODULE_VERSION("1.76");
 MODULE_LICENSE("GPL");
-- 
1.7.1


