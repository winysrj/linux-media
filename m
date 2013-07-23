Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pb0-f52.google.com ([209.85.160.52]:42206 "EHLO
	mail-pb0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757536Ab3GWPYO (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 23 Jul 2013 11:24:14 -0400
Received: by mail-pb0-f52.google.com with SMTP id xa12so8495175pbc.25
        for <linux-media@vger.kernel.org>; Tue, 23 Jul 2013 08:24:14 -0700 (PDT)
From: Chris Lee <updatelee@gmail.com>
To: linux-media@vger.kernel.org
Cc: Chris Lee <updatelee@gmail.com>
Subject: [PATCH] gp8psk: Implement gp8psk_fe_read_ber
Date: Tue, 23 Jul 2013 09:24:02 -0600
Message-Id: <1374593042-13574-1-git-send-email-updatelee@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


Signed-off-by: Chris Lee <updatelee@gmail.com>
---
 drivers/media/usb/dvb-usb/gp8psk-fe.c | 13 ++++++++++---
 drivers/media/usb/dvb-usb/gp8psk.h    |  1 +
 2 files changed, 11 insertions(+), 3 deletions(-)

diff --git a/drivers/media/usb/dvb-usb/gp8psk-fe.c b/drivers/media/usb/dvb-usb/gp8psk-fe.c
index 5864f37..223a3ca 100644
--- a/drivers/media/usb/dvb-usb/gp8psk-fe.c
+++ b/drivers/media/usb/dvb-usb/gp8psk-fe.c
@@ -68,11 +68,18 @@ static int gp8psk_fe_read_status(struct dvb_frontend* fe, fe_status_t *status)
 	return 0;
 }
 
-/* not supported by this Frontend */
 static int gp8psk_fe_read_ber(struct dvb_frontend* fe, u32 *ber)
 {
-	(void) fe;
-	*ber = 0;
+	struct gp8psk_fe_state *st = fe->demodulator_priv;
+
+	u8 buf[4];
+
+	if (gp8psk_usb_in_op(st->d, GET_BER_RATE, 0, 0, buf, 4)) {
+		return -EINVAL;
+	}
+
+	*ber = (buf[3] << 24) + (buf[2] << 16) + (buf[1] << 8) + buf[0];
+
 	return 0;
 }
 
diff --git a/drivers/media/usb/dvb-usb/gp8psk.h b/drivers/media/usb/dvb-usb/gp8psk.h
index ed32b9d..ff6bb3c 100644
--- a/drivers/media/usb/dvb-usb/gp8psk.h
+++ b/drivers/media/usb/dvb-usb/gp8psk.h
@@ -52,6 +52,7 @@ extern int dvb_usb_gp8psk_debug;
 #define GET_SERIAL_NUMBER               0x93    /* in */
 #define USE_EXTRA_VOLT                  0x94
 #define GET_FPGA_VERS			0x95
+#define GET_BER_RATE			0x9B
 #define CW3K_INIT			0x9d
 
 /* PSK_configuration bits */
-- 
1.8.1.2

