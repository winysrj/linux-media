Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:40804 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756091Ab1G1WSB (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 28 Jul 2011 18:18:01 -0400
Received: from dyn3-82-128-185-212.psoas.suomi.net ([82.128.185.212] helo=localhost.localdomain)
	by mail.kapsi.fi with esmtpsa (TLS1.0:DHE_RSA_AES_256_CBC_SHA1:32)
	(Exim 4.69)
	(envelope-from <crope@iki.fi>)
	id 1QmYtz-0001u3-QF
	for linux-media@vger.kernel.org; Fri, 29 Jul 2011 01:17:59 +0300
Message-ID: <4E31E017.3080209@iki.fi>
Date: Fri, 29 Jul 2011 01:17:59 +0300
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: [PATCH 2/2] af9015: use logic or instead of sum numbers
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Style issue.

Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/media/dvb/dvb-usb/af9015.c |   26 +++++++++++++-------------
 1 files changed, 13 insertions(+), 13 deletions(-)

diff --git a/drivers/media/dvb/dvb-usb/af9015.c b/drivers/media/dvb/dvb-usb/af9015.c
index 1fb8248..3e7e9d9 100644
--- a/drivers/media/dvb/dvb-usb/af9015.c
+++ b/drivers/media/dvb/dvb-usb/af9015.c
@@ -744,31 +744,31 @@ static const struct af9015_rc_setup af9015_rc_setup_hashes[] = {
 };
 
 static const struct af9015_rc_setup af9015_rc_setup_usbids[] = {
-	{ (USB_VID_TERRATEC << 16) + USB_PID_TERRATEC_CINERGY_T_STICK_RC,
+	{ (USB_VID_TERRATEC << 16) | USB_PID_TERRATEC_CINERGY_T_STICK_RC,
 		RC_MAP_TERRATEC_SLIM_2 },
-	{ (USB_VID_TERRATEC << 16) + USB_PID_TERRATEC_CINERGY_T_STICK_DUAL_RC,
+	{ (USB_VID_TERRATEC << 16) | USB_PID_TERRATEC_CINERGY_T_STICK_DUAL_RC,
 		RC_MAP_TERRATEC_SLIM },
-	{ (USB_VID_VISIONPLUS << 16) + USB_PID_AZUREWAVE_AD_TU700,
+	{ (USB_VID_VISIONPLUS << 16) | USB_PID_AZUREWAVE_AD_TU700,
 		RC_MAP_AZUREWAVE_AD_TU700 },
-	{ (USB_VID_VISIONPLUS << 16) + USB_PID_TINYTWIN,
+	{ (USB_VID_VISIONPLUS << 16) | USB_PID_TINYTWIN,
 		RC_MAP_AZUREWAVE_AD_TU700 },
-	{ (USB_VID_MSI_2 << 16) + USB_PID_MSI_DIGI_VOX_MINI_III,
+	{ (USB_VID_MSI_2 << 16) | USB_PID_MSI_DIGI_VOX_MINI_III,
 		RC_MAP_MSI_DIGIVOX_III },
-	{ (USB_VID_MSI_2 << 16) + USB_PID_MSI_DIGIVOX_DUO,
+	{ (USB_VID_MSI_2 << 16) | USB_PID_MSI_DIGIVOX_DUO,
 		RC_MAP_MSI_DIGIVOX_III },
-	{ (USB_VID_LEADTEK << 16) + USB_PID_WINFAST_DTV_DONGLE_GOLD,
+	{ (USB_VID_LEADTEK << 16) | USB_PID_WINFAST_DTV_DONGLE_GOLD,
 		RC_MAP_LEADTEK_Y04G0051 },
-	{ (USB_VID_LEADTEK << 16) + USB_PID_WINFAST_DTV2000DS,
+	{ (USB_VID_LEADTEK << 16) | USB_PID_WINFAST_DTV2000DS,
 		RC_MAP_LEADTEK_Y04G0051 },
-	{ (USB_VID_AVERMEDIA << 16) + USB_PID_AVERMEDIA_VOLAR_X,
+	{ (USB_VID_AVERMEDIA << 16) | USB_PID_AVERMEDIA_VOLAR_X,
 		RC_MAP_AVERMEDIA_M135A },
-	{ (USB_VID_AFATECH << 16) + USB_PID_TREKSTOR_DVBT,
+	{ (USB_VID_AFATECH << 16) | USB_PID_TREKSTOR_DVBT,
 		RC_MAP_TREKSTOR },
-	{ (USB_VID_KWORLD_2 << 16) + USB_PID_TINYTWIN_2,
+	{ (USB_VID_KWORLD_2 << 16) | USB_PID_TINYTWIN_2,
 		RC_MAP_DIGITALNOW_TINYTWIN },
-	{ (USB_VID_GTEK << 16) + USB_PID_TINYTWIN_3,
+	{ (USB_VID_GTEK << 16) | USB_PID_TINYTWIN_3,
 		RC_MAP_DIGITALNOW_TINYTWIN },
-	{ (USB_VID_KWORLD_2 << 16) + USB_PID_SVEON_STV22,
+	{ (USB_VID_KWORLD_2 << 16) | USB_PID_SVEON_STV22,
 		RC_MAP_MSI_DIGIVOX_III },
 	{ }
 };
-- 
1.7.6

-- 
http://palosaari.fi/
