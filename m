Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:60516 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754569AbaCZWak (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 26 Mar 2014 18:30:40 -0400
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Jan Vcelak <jv@fcelda.cz>, Antti Palosaari <crope@iki.fi>
Subject: [PATCH] rtl28xxu: remove duplicate ID 0458:707f Genius TVGo DVB-T03
Date: Thu, 27 Mar 2014 00:30:13 +0200
Message-Id: <1395873013-16750-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

That ID was added twice mistakenly.
1st commit ac298ccdde4fe9b0a966e548a232ff4e8a6b8a31
2nd commit 1c1b8734094551eb4075cf68cf76892498c0da61

Revert commit 1c1b8734094551eb4075cf68cf76892498c0da61

Reported-by: Jan Vcelak <jv@fcelda.cz>
Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/media/usb/dvb-usb-v2/rtl28xxu.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/media/usb/dvb-usb-v2/rtl28xxu.c b/drivers/media/usb/dvb-usb-v2/rtl28xxu.c
index c83c16c..61d196e 100644
--- a/drivers/media/usb/dvb-usb-v2/rtl28xxu.c
+++ b/drivers/media/usb/dvb-usb-v2/rtl28xxu.c
@@ -1503,8 +1503,6 @@ static const struct usb_device_id rtl28xxu_id_table[] = {
 	/* RTL2832P devices: */
 	{ DVB_USB_DEVICE(USB_VID_HANFTEK, 0x0131,
 		&rtl2832u_props, "Astrometa DVB-T2", NULL) },
-	{ DVB_USB_DEVICE(USB_VID_KYE, 0x707f,
-		&rtl2832u_props, "Genius TVGo DVB-T03", NULL) },
 	{ }
 };
 MODULE_DEVICE_TABLE(usb, rtl28xxu_id_table);
-- 
1.8.5.3

