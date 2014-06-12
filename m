Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.21]:55635 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751520AbaFLGWZ (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 12 Jun 2014 02:22:25 -0400
Received: from wolfgang ([88.7.218.248]) by mail.gmx.com (mrgmx003) with
 ESMTPSA (Nemesis) id 0MOOdZ-1WrPUg21TR-005mGb for
 <linux-media@vger.kernel.org>; Thu, 12 Jun 2014 08:22:23 +0200
Date: Thu, 12 Jun 2014 08:22:45 +0200
From: Sebastian Kemper <sebastian_ml@gmx.net>
To: linux-media@vger.kernel.org
Subject: [PATCH] rtl28xxu: add [1b80:d3b0] Sveon STV21
Message-ID: <20140612062245.GA1668@wolfgang>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Added Sveon STV21 device based on Realtek RTL2832U and FC0013 tuner

Signed-off-by: Sebastian Kemper <sebastian_ml@gmx.net>
---

diff --git a/drivers/media/dvb-core/dvb-usb-ids.h b/drivers/media/dvb-core/dvb-usb-ids.h
index 11d2bea..b518ada 100644
--- a/drivers/media/dvb-core/dvb-usb-ids.h
+++ b/drivers/media/dvb-core/dvb-usb-ids.h
@@ -363,6 +363,7 @@
 #define USB_PID_TVWAY_PLUS				0x0002
 #define USB_PID_SVEON_STV20				0xe39d
 #define USB_PID_SVEON_STV20_RTL2832U			0xd39d
+#define USB_PID_SVEON_STV21				0xd3b0
 #define USB_PID_SVEON_STV22				0xe401
 #define USB_PID_SVEON_STV22_IT9137			0xe411
 #define USB_PID_AZUREWAVE_AZ6027			0x3275
diff --git a/drivers/media/usb/dvb-usb-v2/rtl28xxu.c b/drivers/media/usb/dvb-usb-v2/rtl28xxu.c
index a676e44..5f8ff0f 100644
--- a/drivers/media/usb/dvb-usb-v2/rtl28xxu.c
+++ b/drivers/media/usb/dvb-usb-v2/rtl28xxu.c
@@ -1541,6 +1541,8 @@ static const struct usb_device_id rtl28xxu_id_table[] = {
 		&rtl2832u_props, "Peak DVB-T USB", NULL) },
 	{ DVB_USB_DEVICE(USB_VID_KWORLD_2, USB_PID_SVEON_STV20_RTL2832U,
 		&rtl2832u_props, "Sveon STV20", NULL) },
+	{ DVB_USB_DEVICE(USB_VID_KWORLD_2, USB_PID_SVEON_STV21,
+		&rtl2832u_props, "Sveon STV21", NULL) },
 	{ DVB_USB_DEVICE(USB_VID_KWORLD_2, USB_PID_SVEON_STV27,
 		&rtl2832u_props, "Sveon STV27", NULL) },
 
