Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-vc0-f171.google.com ([209.85.220.171]:35161 "EHLO
	mail-vc0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758484Ab3ANWVx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 14 Jan 2013 17:21:53 -0500
Received: by mail-vc0-f171.google.com with SMTP id n11so4153671vch.30
        for <linux-media@vger.kernel.org>; Mon, 14 Jan 2013 14:21:52 -0800 (PST)
MIME-Version: 1.0
From: Eddi De Pieri <eddi@depieri.net>
Date: Mon, 14 Jan 2013 23:21:32 +0100
Message-ID: <CAKdnbx7Qx7z1BVxaXsDAe8mDG9jhPQeAkPbZGof++B1xK31Wsw@mail.gmail.com>
Subject: [PATCH] Support Digivox Mini HD (rtl2832)
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add support for Digivox Mini HD (rtl2832)

The tuner works, but with worst performance then realtek linux driver,
due to incomplete implementation of fc2580.c

Signed-off-by: Eddi De Pieri <eddi@depieri.net>
Tested-by: Lorenzo Dongarrà <lorenzo_64@katamail.com>

diff --git a/drivers/media/usb/dvb-usb-v2/rtl28xxu.c
b/drivers/media/usb/dvb-usb-v2/rtl28xxu.c
index b6f4849..c05ea16 100644
--- a/drivers/media/usb/dvb-usb-v2/rtl28xxu.c
+++ b/drivers/media/usb/dvb-usb-v2/rtl28xxu.c
@@ -1368,6 +1368,8 @@ static const struct usb_device_id rtl28xxu_id_table[] = {
                &rtl2832u_props, "ASUS My Cinema-U3100Mini Plus V2", NULL) },
        { DVB_USB_DEVICE(USB_VID_KWORLD_2, 0xd393,
                &rtl2832u_props, "GIGABYTE U7300", NULL) },
+       { DVB_USB_DEVICE(USB_VID_DEXATEK, 0x1104,
+               &rtl2832u_props, "Digivox Micro Hd", NULL) },
        { }
 };
 MODULE_DEVICE_TABLE(usb, rtl28xxu_id_table);
