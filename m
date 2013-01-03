Return-path: <linux-media-owner@vger.kernel.org>
Received: from imap.imec.msu.ru ([93.180.3.203]:53127 "EHLO imap.imec.msu.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752524Ab3ACO1H (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 3 Jan 2013 09:27:07 -0500
Received: from localhost (localhost [127.0.0.1])
	by imap.imec.msu.ru (Postfix) with ESMTP id 827D8C3C0
	for <linux-media@vger.kernel.org>; Thu,  3 Jan 2013 18:16:58 +0400 (MSK)
Date: Thu, 3 Jan 2013 18:16:36 +0400
From: Alexander Inyukhin <shurick@sectorb.msk.ru>
To: linux-media@vger.kernel.org
Subject: [media] rtl28xxu: add Gigabyte U7300 DVB-T Dongle
Message-ID: <20130103141636.GA5893@shurick.grid.su>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="OgqxwSJOaUobr8KG"
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--OgqxwSJOaUobr8KG
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Device with ID 1b80:d393 is the Gigabyte U7300 DVB-T dongle.
It contains decoder Realtek RTL2832U and tuner Fitipower FC0012.


Signed-off-by: Alexander Inyukhin <shurick@sectorb.msk.ru>

--OgqxwSJOaUobr8KG
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: attachment; filename=patch

diff --git a/drivers/media/usb/dvb-usb-v2/rtl28xxu.c b/drivers/media/usb/dvb-usb-v2/rtl28xxu.c
index a4c302d..7fe3609 100644
--- a/drivers/media/usb/dvb-usb-v2/rtl28xxu.c
+++ b/drivers/media/usb/dvb-usb-v2/rtl28xxu.c
@@ -1352,6 +1352,8 @@ static const struct usb_device_id rtl28xxu_id_table[] = {
 		&rtl2832u_props, "Dexatek DK mini DVB-T Dongle", NULL) },
 	{ DVB_USB_DEVICE(USB_VID_TERRATEC, 0x00d7,
 		&rtl2832u_props, "TerraTec Cinergy T Stick+", NULL) },
+	{ DVB_USB_DEVICE(USB_VID_KWORLD_2, 0xd393,
+		&rtl2832u_props, "Gigabyte U7300 DVB-T Dongle", NULL) },
 	{ }
 };
 MODULE_DEVICE_TABLE(usb, rtl28xxu_id_table);

--OgqxwSJOaUobr8KG--
