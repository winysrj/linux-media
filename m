Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:58175 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752457Ab2IICH4 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 8 Sep 2012 22:07:56 -0400
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Antti Palosaari <crope@iki.fi>
Subject: [PATCH 3/3] rtl28xxu: Dexatek DK DVB-T Dongle [1d19:1101]
Date: Sun,  9 Sep 2012 05:07:26 +0300
Message-Id: <1347156446-12439-3-git-send-email-crope@iki.fi>
In-Reply-To: <1347156446-12439-1-git-send-email-crope@iki.fi>
References: <1347156446-12439-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

It is RTL2832U + FC2580 reference design.

Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/media/dvb-core/dvb-usb-ids.h    | 1 +
 drivers/media/usb/dvb-usb-v2/rtl28xxu.c | 2 ++
 2 files changed, 3 insertions(+)

diff --git a/drivers/media/dvb-core/dvb-usb-ids.h b/drivers/media/dvb-core/dvb-usb-ids.h
index fed6dcd..d572307 100644
--- a/drivers/media/dvb-core/dvb-usb-ids.h
+++ b/drivers/media/dvb-core/dvb-usb-ids.h
@@ -24,6 +24,7 @@
 #define USB_VID_COMPRO_UNK			0x145f
 #define USB_VID_CONEXANT			0x0572
 #define USB_VID_CYPRESS				0x04b4
+#define USB_VID_DEXATEK				0x1d19
 #define USB_VID_DIBCOM				0x10b8
 #define USB_VID_DPOSH				0x1498
 #define USB_VID_DVICO				0x0fe9
diff --git a/drivers/media/usb/dvb-usb-v2/rtl28xxu.c b/drivers/media/usb/dvb-usb-v2/rtl28xxu.c
index f195b77..a62238f 100644
--- a/drivers/media/usb/dvb-usb-v2/rtl28xxu.c
+++ b/drivers/media/usb/dvb-usb-v2/rtl28xxu.c
@@ -1249,6 +1249,8 @@ static const struct usb_device_id rtl28xxu_id_table[] = {
 		&rtl2832u_props, "Realtek RTL2832U reference design", NULL) },
 	{ DVB_USB_DEVICE(USB_VID_GTEK, USB_PID_TREKSTOR_TERRES_2_0,
 		&rtl2832u_props, "Trekstor DVB-T Stick Terres 2.0", NULL) },
+	{ DVB_USB_DEVICE(USB_VID_DEXATEK, 0x1101,
+		&rtl2832u_props, "Dexatek DK DVB-T Dongle", NULL) },
 	{ }
 };
 MODULE_DEVICE_TABLE(usb, rtl28xxu_id_table);
-- 
1.7.11.4

