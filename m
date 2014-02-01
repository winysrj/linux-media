Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:43699 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751321AbaBAObH (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 1 Feb 2014 09:31:07 -0500
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Stefan Becker <schtefan@gmx.net>, Antti Palosaari <crope@iki.fi>
Subject: [PATCH] af9035: add ID [2040:f900] Hauppauge WinTV-MiniStick 2
Date: Sat,  1 Feb 2014 16:30:50 +0200
Message-Id: <1391265050-4635-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add USB ID [2040:f900] for Hauppauge WinTV-MiniStick 2.
Device is build upon IT9135 chipset.

Tested-by: Stefan Becker <schtefan@gmx.net>
Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/media/usb/dvb-usb-v2/af9035.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/media/usb/dvb-usb-v2/af9035.c b/drivers/media/usb/dvb-usb-v2/af9035.c
index 8f9b2cea..8ede8ea 100644
--- a/drivers/media/usb/dvb-usb-v2/af9035.c
+++ b/drivers/media/usb/dvb-usb-v2/af9035.c
@@ -1539,6 +1539,8 @@ static const struct usb_device_id af9035_id_table[] = {
 		&af9035_props, "TerraTec Cinergy T Stick Dual RC (rev. 2)", NULL) },
 	{ DVB_USB_DEVICE(USB_VID_LEADTEK, 0x6a05,
 		&af9035_props, "Leadtek WinFast DTV Dongle Dual", NULL) },
+	{ DVB_USB_DEVICE(USB_VID_HAUPPAUGE, 0xf900,
+		&af9035_props, "Hauppauge WinTV-MiniStick 2", NULL) },
 	{ }
 };
 MODULE_DEVICE_TABLE(usb, af9035_id_table);
-- 
1.8.5.3

