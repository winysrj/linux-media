Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:39935 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754928Ab3KFTZX (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 6 Nov 2013 14:25:23 -0500
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Michael Piko <michael@piko.com.au>, Antti Palosaari <crope@iki.fi>
Subject: [PATCH] af9035: add [0413:6a05] Leadtek WinFast DTV Dongle Dual
Date: Wed,  6 Nov 2013 21:25:06 +0200
Message-Id: <1383765906-14210-2-git-send-email-crope@iki.fi>
In-Reply-To: <1383765906-14210-1-git-send-email-crope@iki.fi>
References: <1383765906-14210-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

It is IT9135 dual design.

Thanks to Michael Piko for reporting that!

Reported-by: Michael Piko <michael@piko.com.au>
Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/media/usb/dvb-usb-v2/af9035.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/media/usb/dvb-usb-v2/af9035.c b/drivers/media/usb/dvb-usb-v2/af9035.c
index 1ea17dc..73ce27b 100644
--- a/drivers/media/usb/dvb-usb-v2/af9035.c
+++ b/drivers/media/usb/dvb-usb-v2/af9035.c
@@ -1511,6 +1511,8 @@ static const struct usb_device_id af9035_id_table[] = {
 	/* XXX: that same ID [0ccd:0099] is used by af9015 driver too */
 	{ DVB_USB_DEVICE(USB_VID_TERRATEC, 0x0099,
 		&af9035_props, "TerraTec Cinergy T Stick Dual RC (rev. 2)", NULL) },
+	{ DVB_USB_DEVICE(USB_VID_LEADTEK, 0x6a05,
+		&af9035_props, "Leadtek WinFast DTV Dongle Dual", NULL) },
 	{ }
 };
 MODULE_DEVICE_TABLE(usb, af9035_id_table);
-- 
1.8.4.2

