Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-vb0-f45.google.com ([209.85.212.45]:51233 "EHLO
	mail-vb0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751091Ab2LVNmM (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 22 Dec 2012 08:42:12 -0500
Received: by mail-vb0-f45.google.com with SMTP id p1so6102172vbi.4
        for <linux-media@vger.kernel.org>; Sat, 22 Dec 2012 05:42:11 -0800 (PST)
MIME-Version: 1.0
From: Eddi De Pieri <eddi@depieri.net>
Date: Sat, 22 Dec 2012 14:41:49 +0100
Message-ID: <CAKdnbx593exZgqOMYaJZD1h4pDZDDNM8pNo29zf3=etrtwQT4g@mail.gmail.com>
Subject: [PATCH] Support Avermedia A835B
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add support for Avermedia A835B

Signed-off-by: Eddi De Pieri <eddi@depieri.net>

diff --git a/drivers/media/dvb-core/dvb-usb-ids.h
b/drivers/media/dvb-core/dvb-usb-ids.h
index 26c4481..84d7759 100644
--- a/drivers/media/dvb-core/dvb-usb-ids.h
+++ b/drivers/media/dvb-core/dvb-usb-ids.h
@@ -231,6 +231,10 @@
 #define USB_PID_AVERMEDIA_A815M                                0x815a
 #define USB_PID_AVERMEDIA_A835                         0xa835
 #define USB_PID_AVERMEDIA_B835                         0xb835
+#define USB_PID_AVERMEDIA_A835B_1835                   0x1835
+#define USB_PID_AVERMEDIA_A835B_2835                   0x2835
+#define USB_PID_AVERMEDIA_A835B_3835                   0x3835
+#define USB_PID_AVERMEDIA_A835B_4835                   0x4835
 #define USB_PID_AVERMEDIA_1867                         0x1867
 #define USB_PID_AVERMEDIA_A867                         0xa867
 #define USB_PID_AVERMEDIA_TWINSTAR                     0x0825
diff --git a/drivers/media/usb/dvb-usb-v2/it913x.c
b/drivers/media/usb/dvb-usb-v2/it913x.c
index 1ca8fea..b2e9b87 100644
--- a/drivers/media/usb/dvb-usb-v2/it913x.c
+++ b/drivers/media/usb/dvb-usb-v2/it913x.c
@@ -773,6 +773,18 @@ static const struct usb_device_id it913x_id_table[] = {
        { DVB_USB_DEVICE(USB_VID_ITETECH, USB_PID_ITETECH_IT9135_9006,
                &it913x_properties, "ITE 9135(9006) Generic",
                        RC_MAP_IT913X_V1) },
+       { DVB_USB_DEVICE(USB_VID_AVERMEDIA, USB_PID_AVERMEDIA_A835B_1835,
+               &it913x_properties, "Avermedia A835B(1835)",
+                       RC_MAP_IT913X_V2) },
+       { DVB_USB_DEVICE(USB_VID_AVERMEDIA, USB_PID_AVERMEDIA_A835B_2835,
+               &it913x_properties, "Avermedia A835B(2835)",
+                       RC_MAP_IT913X_V2) },
+       { DVB_USB_DEVICE(USB_VID_AVERMEDIA, USB_PID_AVERMEDIA_A835B_3835,
+               &it913x_properties, "Avermedia A835B(3835)",
+                       RC_MAP_IT913X_V2) },
+       { DVB_USB_DEVICE(USB_VID_AVERMEDIA, USB_PID_AVERMEDIA_A835B_4835,
+               &it913x_properties, "Avermedia A835B(4835)",
+                       RC_MAP_IT913X_V2) },
        {}              /* Terminating entry */
 };
