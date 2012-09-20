Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:40758 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754181Ab2ITVlK (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 20 Sep 2012 17:41:10 -0400
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Antti Palosaari <crope@iki.fi>, Darryl Bond <darryl.bond@gmail.com>
Subject: [PATCH] rtl28xxu: [0413:6680] DigitalNow Quad DVB-T Receiver
Date: Fri, 21 Sep 2012 00:40:42 +0300
Message-Id: <1348177242-12494-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

It is 4 x RTL2832U + 4 x FC0012 in one PCIe board.
Of course there is a PCIe USB host controller too.

Big thanks for Darryl Bond reporting and testing that!

Cc: Darryl Bond <darryl.bond@gmail.com>
Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/media/usb/dvb-usb-v2/rtl28xxu.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/media/usb/dvb-usb-v2/rtl28xxu.c b/drivers/media/usb/dvb-usb-v2/rtl28xxu.c
index 70c2df1..f62cfba 100644
--- a/drivers/media/usb/dvb-usb-v2/rtl28xxu.c
+++ b/drivers/media/usb/dvb-usb-v2/rtl28xxu.c
@@ -1342,6 +1342,8 @@ static const struct usb_device_id rtl28xxu_id_table[] = {
 		&rtl2832u_props, "Trekstor DVB-T Stick Terres 2.0", NULL) },
 	{ DVB_USB_DEVICE(USB_VID_DEXATEK, 0x1101,
 		&rtl2832u_props, "Dexatek DK DVB-T Dongle", NULL) },
+	{ DVB_USB_DEVICE(USB_VID_LEADTEK, 0x6680,
+		&rtl2832u_props, "DigitalNow Quad DVB-T Receiver", NULL) },
 	{ }
 };
 MODULE_DEVICE_TABLE(usb, rtl28xxu_id_table);
-- 
1.7.11.4

