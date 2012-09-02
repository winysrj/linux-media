Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wi0-f178.google.com ([209.85.212.178]:33541 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754827Ab2IBXbo (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 2 Sep 2012 19:31:44 -0400
Received: by wibhr14 with SMTP id hr14so3437275wib.1
        for <linux-media@vger.kernel.org>; Sun, 02 Sep 2012 16:31:42 -0700 (PDT)
From: Philipp Dreimann <philipp@dreimann.net>
To: linux-media@vger.kernel.org, Antti Palosaari <crope@iki.fi>,
	Thomas Mair <thomas.mair86@googlemail.com>
Cc: Philipp Dreimann <philipp@dreimann.net>
Subject: [PATCH] Add the usb id of the Trekstor DVB-T Stick Terres 2.0
Date: Mon,  3 Sep 2012 01:30:54 +0200
Message-Id: <1346628654-3348-1-git-send-email-philipp@dreimann.net>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

It needs the e4000 tuner driver.

Signed-off-by: Philipp Dreimann <philipp@dreimann.net>
---
 drivers/media/dvb-core/dvb-usb-ids.h    |    1 +
 drivers/media/usb/dvb-usb-v2/rtl28xxu.c |    2 ++
 2 files changed, 3 insertions(+)

diff --git a/drivers/media/dvb-core/dvb-usb-ids.h b/drivers/media/dvb-core/dvb-usb-ids.h
index 26c4481..fed6dcd 100644
--- a/drivers/media/dvb-core/dvb-usb-ids.h
+++ b/drivers/media/dvb-core/dvb-usb-ids.h
@@ -82,6 +82,7 @@
 #define USB_PID_AFATECH_AF9035_1003			0x1003
 #define USB_PID_AFATECH_AF9035_9035			0x9035
 #define USB_PID_TREKSTOR_DVBT				0x901b
+#define USB_PID_TREKSTOR_TERRES_2_0			0xC803
 #define USB_VID_ALINK_DTU				0xf170
 #define USB_PID_ANSONIC_DVBT_USB			0x6000
 #define USB_PID_ANYSEE					0x861f
diff --git a/drivers/media/usb/dvb-usb-v2/rtl28xxu.c b/drivers/media/usb/dvb-usb-v2/rtl28xxu.c
index 88b5ea1..d0d23f2 100644
--- a/drivers/media/usb/dvb-usb-v2/rtl28xxu.c
+++ b/drivers/media/usb/dvb-usb-v2/rtl28xxu.c
@@ -1236,6 +1236,8 @@ static const struct usb_device_id rtl28xxu_id_table[] = {
 		&rtl2832u_props, "NOXON DAB/DAB+ USB dongle", NULL) },
 	{ DVB_USB_DEVICE(USB_VID_REALTEK, 0x2838,
 		&rtl2832u_props, "Realtek RTL2832U reference design", NULL) },
+	{ DVB_USB_DEVICE(USB_VID_GTEK, USB_PID_TREKSTOR_TERRES_2_0,
+		&rtl2832u_props, "Trekstor DVB-T Stick Terres 2.0", NULL) },
 	{ }
 };
 MODULE_DEVICE_TABLE(usb, rtl28xxu_id_table);
-- 
1.7.9.5

