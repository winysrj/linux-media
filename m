Return-path: <linux-media-owner@vger.kernel.org>
Received: from gmmr8.centrum.cz ([46.255.227.254]:55828 "EHLO gmmr8.centrum.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758596Ab3ENXtC (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 14 May 2013 19:49:02 -0400
Received: from gm-as1.cent (unknown [10.32.3.100])
	by gmmr8.centrum.cz (Postfix) with ESMTP id 46CFE7E6E
	for <linux-media@vger.kernel.org>; Wed, 15 May 2013 01:42:29 +0200 (CEST)
From: =?UTF-8?q?Miroslav=20=C5=A0ustek?= <sustmidown@centrum.cz>
To: Antti Palosaari <crope@iki.fi>
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
	=?UTF-8?q?Miroslav=20=C5=A0ustek?= <sustmidown@centrum.cz>
Subject: [PATCH] [media] rtl28xxu: Add USB ID for Leadtek WinFast DTV Dongle mini
Date: Wed, 15 May 2013 01:42:11 +0200
Message-Id: <1368574931-12146-1-git-send-email-sustmidown@centrum.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

USB ID 0413:6a03 is Leadtek WinFast DTV Dongle mini.
Decoder Realtek RTL2832U and tuner Infineon TUA9001.

Signed-off-by: Miroslav Šustek <sustmidown@centrum.cz>
---
 drivers/media/usb/dvb-usb-v2/rtl28xxu.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/media/usb/dvb-usb-v2/rtl28xxu.c b/drivers/media/usb/dvb-usb-v2/rtl28xxu.c
index 22015fe..d220ccc 100644
--- a/drivers/media/usb/dvb-usb-v2/rtl28xxu.c
+++ b/drivers/media/usb/dvb-usb-v2/rtl28xxu.c
@@ -1408,6 +1408,8 @@ static const struct usb_device_id rtl28xxu_id_table[] = {
 		&rtl2832u_props, "Compro VideoMate U620F", NULL) },
 	{ DVB_USB_DEVICE(USB_VID_KWORLD_2, 0xd394,
 		&rtl2832u_props, "MaxMedia HU394-T", NULL) },
+	{ DVB_USB_DEVICE(USB_VID_LEADTEK, 0x6a03,
+		&rtl2832u_props, "WinFast DTV Dongle mini", NULL) },
 	{ }
 };
 MODULE_DEVICE_TABLE(usb, rtl28xxu_id_table);
-- 
1.8.1.4

