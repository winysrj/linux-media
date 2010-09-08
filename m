Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:5542 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758690Ab0IHMio (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 8 Sep 2010 08:38:44 -0400
Received: from int-mx01.intmail.prod.int.phx2.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id o88CchXY032304
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Wed, 8 Sep 2010 08:38:44 -0400
Received: from [10.11.11.235] (vpn-11-235.rdu.redhat.com [10.11.11.235])
	by int-mx01.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP id o88Ccfub016592
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-media@vger.kernel.org>; Wed, 8 Sep 2010 08:38:43 -0400
Message-ID: <4C8783D4.2030005@redhat.com>
Date: Wed, 08 Sep 2010 09:38:44 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH] Don't identify PV SBTVD Hybrid as a DibCom device
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@pedra>

As reported by Carlos, Prolink Pixelview SBTVD Hybrid is based on
Conexant cx231xx + Fujitsu 86A20S demodulator. However, both shares
the same USB ID. So, we need to use USB bcdDevice, in order to
properly discover what's the board.

We know for sure that bcd 0x100 is used for a dib0700 device, while
bcd 0x4001 is used for a cx23102 device. This patch reserves two ranges,
the first one from 0x0000-0x3f00 for dib0700, and the second from
0x4000-0x4fff for cx231xx devices.

This may need fixes in the future, as we get access to other devices.

Thanks-to: Carlos Americo Domiciano <c_domiciano@yahoo.com.br>
Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>

diff --git a/drivers/media/dvb/dvb-usb/dib0700_devices.c b/drivers/media/dvb/dvb-usb/dib0700_devices.c
index f634d2e..ce66c5a 100644
--- a/drivers/media/dvb/dvb-usb/dib0700_devices.c
+++ b/drivers/media/dvb/dvb-usb/dib0700_devices.c
@@ -1781,7 +1781,7 @@ struct usb_device_id dib0700_usb_id_table[] = {
 /* 60 */{ USB_DEVICE(USB_VID_TERRATEC,	USB_PID_TERRATEC_CINERGY_T_XXS_2) },
 	{ USB_DEVICE(USB_VID_DIBCOM,    USB_PID_DIBCOM_STK807XPVR) },
 	{ USB_DEVICE(USB_VID_DIBCOM,    USB_PID_DIBCOM_STK807XP) },
-	{ USB_DEVICE(USB_VID_PIXELVIEW, USB_PID_PIXELVIEW_SBTVD) },
+	{ USB_DEVICE_VER(USB_VID_PIXELVIEW, USB_PID_PIXELVIEW_SBTVD, 0x000, 0x3f00) },
 	{ USB_DEVICE(USB_VID_EVOLUTEPC, USB_PID_TVWAY_PLUS) },
 /* 65 */{ USB_DEVICE(USB_VID_PINNACLE,	USB_PID_PINNACLE_PCTV73ESE) },
 	{ USB_DEVICE(USB_VID_PINNACLE,	USB_PID_PINNACLE_PCTV282E) },
diff --git a/drivers/media/video/cx231xx/Makefile b/drivers/media/video/cx231xx/Makefile
index 755dd0c..6f2b573 100644
--- a/drivers/media/video/cx231xx/Makefile
+++ b/drivers/media/video/cx231xx/Makefile
@@ -11,4 +11,5 @@ EXTRA_CFLAGS += -Idrivers/media/video
 EXTRA_CFLAGS += -Idrivers/media/common/tuners
 EXTRA_CFLAGS += -Idrivers/media/dvb/dvb-core
 EXTRA_CFLAGS += -Idrivers/media/dvb/frontends
+EXTRA_CFLAGS += -Idrivers/media/dvb/dvb-usb
 
diff --git a/drivers/media/video/cx231xx/cx231xx-cards.c b/drivers/media/video/cx231xx/cx231xx-cards.c
index 6bdc0ef..5b7c9a9 100644
--- a/drivers/media/video/cx231xx/cx231xx-cards.c
+++ b/drivers/media/video/cx231xx/cx231xx-cards.c
@@ -32,6 +32,7 @@
 #include <media/v4l2-chip-ident.h>
 
 #include <media/cx25840.h>
+#include "dvb-usb-ids.h"
 #include "xc5000.h"
 
 #include "cx231xx.h"
@@ -175,6 +176,8 @@ struct usb_device_id cx231xx_id_table[] = {
 	 .driver_info = CX231XX_BOARD_CNXT_RDE_250},
 	{USB_DEVICE(0x0572, 0x58A1),
 	 .driver_info = CX231XX_BOARD_CNXT_RDU_250},
+	{USB_DEVICE_VER(USB_VID_PIXELVIEW, USB_PID_PIXELVIEW_SBTVD, 0x4000,0x4fff),
+	 .driver_info = CX231XX_BOARD_UNKNOWN},
 	{},
 };
 
