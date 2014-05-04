Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wg0-f52.google.com ([74.125.82.52]:35713 "EHLO
	mail-wg0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752142AbaEDKHh (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 4 May 2014 06:07:37 -0400
Received: by mail-wg0-f52.google.com with SMTP id l18so5302194wgh.23
        for <linux-media@vger.kernel.org>; Sun, 04 May 2014 03:07:36 -0700 (PDT)
From: Alessandro Miceli <angelofsky1980@gmail.com>
To: linux-media@vger.kernel.org
Cc: Alessandro Miceli <angelofsky1980@gmail.com>
Subject: [PATCH] DVB-USB-V2: added entry for Sveon STV20 device (RTL2832u+FC0012 tuner)
Date: Sun,  4 May 2014 12:07:07 +0200
Message-Id: <1399198027-23294-1-git-send-email-angelofsky1980@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

---
 drivers/media/usb/dvb-usb-v2/rtl28xxu.c |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/media/usb/dvb-usb-v2/rtl28xxu.c b/drivers/media/usb/dvb-usb-v2/rtl28xxu.c
index dcbd392..0b63c3f 100644
--- a/drivers/media/usb/dvb-usb-v2/rtl28xxu.c
+++ b/drivers/media/usb/dvb-usb-v2/rtl28xxu.c
@@ -1537,6 +1537,8 @@ static const struct usb_device_id rtl28xxu_id_table[] = {
 		&rtl2832u_props, "Crypto ReDi PC 50 A", NULL) },
 	{ DVB_USB_DEVICE(USB_VID_KYE, 0x707f,
 		&rtl2832u_props, "Genius TVGo DVB-T03", NULL) },
+	{ DVB_USB_DEVICE(USB_VID_KWORLD_2, USB_PID_SVEON_STV20_RTL2832U,
+		&rtl2832u_props, "Sveon STV20", NULL) },
 
 	/* RTL2832P devices: */
 	{ DVB_USB_DEVICE(USB_VID_HANFTEK, 0x0131,
-- 
1.7.9.5

