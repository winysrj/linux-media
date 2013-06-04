Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:51877 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751129Ab3FDV4N (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 4 Jun 2013 17:56:13 -0400
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: =?UTF-8?q?Miroslav=20=C5=A0ustek?= <sustmidown@centrum.cz>,
	Antti Palosaari <crope@iki.fi>
Subject: [PATCH 4/7] rtl28xxu: Add USB ID for Leadtek WinFast DTV Dongle mini
Date: Wed,  5 Jun 2013 00:55:00 +0300
Message-Id: <1370382903-21332-5-git-send-email-crope@iki.fi>
In-Reply-To: <1370382903-21332-1-git-send-email-crope@iki.fi>
References: <1370382903-21332-1-git-send-email-crope@iki.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Miroslav Šustek <sustmidown@centrum.cz>

USB ID 0413:6a03 is Leadtek WinFast DTV Dongle mini.
Decoder Realtek RTL2832U and tuner Infineon TUA9001.

Signed-off-by: Miroslav Šustek <sustmidown@centrum.cz>
Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/media/usb/dvb-usb-v2/rtl28xxu.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/media/usb/dvb-usb-v2/rtl28xxu.c b/drivers/media/usb/dvb-usb-v2/rtl28xxu.c
index 8bbc6ab..0045b19 100644
--- a/drivers/media/usb/dvb-usb-v2/rtl28xxu.c
+++ b/drivers/media/usb/dvb-usb-v2/rtl28xxu.c
@@ -1424,6 +1424,8 @@ static const struct usb_device_id rtl28xxu_id_table[] = {
 		&rtl2832u_props, "Compro VideoMate U620F", NULL) },
 	{ DVB_USB_DEVICE(USB_VID_KWORLD_2, 0xd394,
 		&rtl2832u_props, "MaxMedia HU394-T", NULL) },
+	{ DVB_USB_DEVICE(USB_VID_LEADTEK, 0x6a03,
+		&rtl2832u_props, "WinFast DTV Dongle mini", NULL) },
 	{ }
 };
 MODULE_DEVICE_TABLE(usb, rtl28xxu_id_table);
-- 
1.7.11.7

