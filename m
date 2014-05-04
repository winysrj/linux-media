Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:40640 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752733AbaEDWIV (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 4 May 2014 18:08:21 -0400
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Brian Healy <healybrian@gmail.com>, Antti Palosaari <crope@iki.fi>
Subject: [PATCH 1/3] rtl28xxu: add 1b80:d395 Peak DVB-T USB
Date: Mon,  5 May 2014 01:07:27 +0300
Message-Id: <1399241249-12065-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Brian Healy <healybrian@gmail.com>

Add USB ID for Peak DVB-T USB.

[crope@iki.fi: fix Brian email address and indentation]
Signed-off-by: Brian Healy <healybrian@gmail.com>
Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/media/usb/dvb-usb-v2/rtl28xxu.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/media/usb/dvb-usb-v2/rtl28xxu.c b/drivers/media/usb/dvb-usb-v2/rtl28xxu.c
index dcbd392..df60b5f 100644
--- a/drivers/media/usb/dvb-usb-v2/rtl28xxu.c
+++ b/drivers/media/usb/dvb-usb-v2/rtl28xxu.c
@@ -1537,6 +1537,8 @@ static const struct usb_device_id rtl28xxu_id_table[] = {
 		&rtl2832u_props, "Crypto ReDi PC 50 A", NULL) },
 	{ DVB_USB_DEVICE(USB_VID_KYE, 0x707f,
 		&rtl2832u_props, "Genius TVGo DVB-T03", NULL) },
+	{ DVB_USB_DEVICE(USB_VID_KWORLD_2, 0xd395,
+		&rtl2832u_props, "Peak DVB-T USB", NULL) },
 
 	/* RTL2832P devices: */
 	{ DVB_USB_DEVICE(USB_VID_HANFTEK, 0x0131,
-- 
1.9.0

