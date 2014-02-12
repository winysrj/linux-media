Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:49024 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752580AbaBLTgv (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 12 Feb 2014 14:36:51 -0500
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: =?UTF-8?q?Till=20D=C3=B6rges?= <till@doerges.net>,
	Antti Palosaari <crope@iki.fi>
Subject: [REVIEW PATCH] rtl28xxu: add ID [0ccd:00b4] TerraTec NOXON DAB Stick (rev 3)
Date: Wed, 12 Feb 2014 21:36:36 +0200
Message-Id: <1392233796-13782-1-git-send-email-crope@iki.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Till Dörges <till@doerges.net>

I've got the following DAB USB stick that also works fine with the
DVB_USB_RTL28XXU driver after I added its USB ID:

--- snip ---
user@box:~> lsusb -d 0ccd:00b4
Bus 001 Device 009: ID 0ccd:00b4 TerraTec Electronic GmbH
--- snap ---

[crope@iki.fi: apply patch partly manually]
Signed-off-by: Till Dörges <till@doerges.net>
Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/media/dvb-core/dvb-usb-ids.h    | 1 +
 drivers/media/usb/dvb-usb-v2/rtl28xxu.c | 2 ++
 2 files changed, 3 insertions(+)

diff --git a/drivers/media/dvb-core/dvb-usb-ids.h b/drivers/media/dvb-core/dvb-usb-ids.h
index f19a2cc..1bdc0e7 100644
--- a/drivers/media/dvb-core/dvb-usb-ids.h
+++ b/drivers/media/dvb-core/dvb-usb-ids.h
@@ -257,6 +257,7 @@
 #define USB_PID_TERRATEC_T5				0x10a1
 #define USB_PID_NOXON_DAB_STICK				0x00b3
 #define USB_PID_NOXON_DAB_STICK_REV2			0x00e0
+#define USB_PID_NOXON_DAB_STICK_REV3			0x00b4
 #define USB_PID_PINNACLE_EXPRESSCARD_320CX		0x022e
 #define USB_PID_PINNACLE_PCTV2000E			0x022c
 #define USB_PID_PINNACLE_PCTV_DVB_T_FLASH		0x0228
diff --git a/drivers/media/usb/dvb-usb-v2/rtl28xxu.c b/drivers/media/usb/dvb-usb-v2/rtl28xxu.c
index fda5c64..8e61523 100644
--- a/drivers/media/usb/dvb-usb-v2/rtl28xxu.c
+++ b/drivers/media/usb/dvb-usb-v2/rtl28xxu.c
@@ -1401,6 +1401,8 @@ static const struct usb_device_id rtl28xxu_id_table[] = {
 		&rtl2832u_props, "TerraTec NOXON DAB Stick", NULL) },
 	{ DVB_USB_DEVICE(USB_VID_TERRATEC, USB_PID_NOXON_DAB_STICK_REV2,
 		&rtl2832u_props, "TerraTec NOXON DAB Stick (rev 2)", NULL) },
+	{ DVB_USB_DEVICE(USB_VID_TERRATEC, USB_PID_NOXON_DAB_STICK_REV3,
+		&rtl2832u_props, "TerraTec NOXON DAB Stick (rev 3)", NULL) },
 	{ DVB_USB_DEVICE(USB_VID_GTEK, USB_PID_TREKSTOR_TERRES_2_0,
 		&rtl2832u_props, "Trekstor DVB-T Stick Terres 2.0", NULL) },
 	{ DVB_USB_DEVICE(USB_VID_DEXATEK, 0x1101,
-- 
1.8.5.3

