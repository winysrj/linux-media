Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:60742 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751146Ab3FDV4N (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 4 Jun 2013 17:56:13 -0400
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Antti Palosaari <crope@iki.fi>
Subject: [PATCH 5/7] rtl28xxu: correct some device names
Date: Wed,  5 Jun 2013 00:55:01 +0300
Message-Id: <1370382903-21332-6-git-send-email-crope@iki.fi>
In-Reply-To: <1370382903-21332-1-git-send-email-crope@iki.fi>
References: <1370382903-21332-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

... just because I want to be perfect ;)

Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/media/usb/dvb-usb-v2/rtl28xxu.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/media/usb/dvb-usb-v2/rtl28xxu.c b/drivers/media/usb/dvb-usb-v2/rtl28xxu.c
index 0045b19..93313f70 100644
--- a/drivers/media/usb/dvb-usb-v2/rtl28xxu.c
+++ b/drivers/media/usb/dvb-usb-v2/rtl28xxu.c
@@ -1419,13 +1419,13 @@ static const struct usb_device_id rtl28xxu_id_table[] = {
 	{ DVB_USB_DEVICE(USB_VID_KWORLD_2, 0xd393,
 		&rtl2832u_props, "GIGABYTE U7300", NULL) },
 	{ DVB_USB_DEVICE(USB_VID_DEXATEK, 0x1104,
-		&rtl2832u_props, "Digivox Micro Hd", NULL) },
+		&rtl2832u_props, "MSI DIGIVOX Micro HD", NULL) },
 	{ DVB_USB_DEVICE(USB_VID_COMPRO, 0x0620,
 		&rtl2832u_props, "Compro VideoMate U620F", NULL) },
 	{ DVB_USB_DEVICE(USB_VID_KWORLD_2, 0xd394,
 		&rtl2832u_props, "MaxMedia HU394-T", NULL) },
 	{ DVB_USB_DEVICE(USB_VID_LEADTEK, 0x6a03,
-		&rtl2832u_props, "WinFast DTV Dongle mini", NULL) },
+		&rtl2832u_props, "Leadtek WinFast DTV Dongle mini", NULL) },
 	{ }
 };
 MODULE_DEVICE_TABLE(usb, rtl28xxu_id_table);
-- 
1.7.11.7

