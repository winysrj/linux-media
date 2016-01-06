Return-path: <linux-media-owner@vger.kernel.org>
Received: from v-smtpgw2.han.skanova.net ([81.236.60.205]:51413 "EHLO
	v-smtpgw2.han.skanova.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751595AbcAFQ1Q (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 6 Jan 2016 11:27:16 -0500
From: =?UTF-8?q?Torbj=C3=B6rn=20Jansson?=
	<torbjorn.jansson@mbox200.swipnet.se>
To: linux-media@vger.kernel.org
Cc: Nibble Max <nibble.max@gmail.com>,
	Olli Salonen <olli.salonen@iki.fi>,
	=?UTF-8?q?Torbj=C3=B6rn=20Jansson?=
	<torbjorn.jansson@mbox200.swipnet.se>
Subject: [PATCH] dvb-usb-dvbsky: add new product id for TT CT2-4650 CI
Date: Wed,  6 Jan 2016 17:26:31 +0100
Message-Id: <1452097591-20184-1-git-send-email-torbjorn.jansson@mbox200.swipnet.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add a new product id to dvb-usb-dvbsky for new version of TechnoTrend CT2-4650 CI

Signed-off-by: Torbjörn Jansson <torbjorn.jansson@mbox200.swipnet.se>
---
 drivers/media/dvb-core/dvb-usb-ids.h  | 1 +
 drivers/media/usb/dvb-usb-v2/dvbsky.c | 4 ++++
 2 files changed, 5 insertions(+)

diff --git a/drivers/media/dvb-core/dvb-usb-ids.h b/drivers/media/dvb-core/dvb-usb-ids.h
index 1c1c298..a3761e9 100644
--- a/drivers/media/dvb-core/dvb-usb-ids.h
+++ b/drivers/media/dvb-core/dvb-usb-ids.h
@@ -247,6 +247,7 @@
 #define USB_PID_TECHNOTREND_CONNECT_CT3650		0x300d
 #define USB_PID_TECHNOTREND_CONNECT_S2_4600             0x3011
 #define USB_PID_TECHNOTREND_CONNECT_CT2_4650_CI		0x3012
+#define USB_PID_TECHNOTREND_CONNECT_CT2_4650_CI_2	0x3015
 #define USB_PID_TECHNOTREND_TVSTICK_CT2_4400		0x3014
 #define USB_PID_TERRATEC_CINERGY_DT_XS_DIVERSITY	0x005a
 #define USB_PID_TERRATEC_CINERGY_DT_XS_DIVERSITY_2	0x0081
diff --git a/drivers/media/usb/dvb-usb-v2/dvbsky.c b/drivers/media/usb/dvb-usb-v2/dvbsky.c
index 1dd9625..b4620b7 100644
--- a/drivers/media/usb/dvb-usb-v2/dvbsky.c
+++ b/drivers/media/usb/dvb-usb-v2/dvbsky.c
@@ -847,6 +847,10 @@ static const struct usb_device_id dvbsky_id_table[] = {
 		USB_PID_TECHNOTREND_CONNECT_CT2_4650_CI,
 		&dvbsky_t680c_props, "TechnoTrend TT-connect CT2-4650 CI",
 		RC_MAP_TT_1500) },
+	{ DVB_USB_DEVICE(USB_VID_TECHNOTREND,
+		USB_PID_TECHNOTREND_CONNECT_CT2_4650_CI_2,
+		&dvbsky_t680c_props, "TechnoTrend TT-connect CT2-4650 CI v1.1",
+		RC_MAP_TT_1500) },
 	{ DVB_USB_DEVICE(USB_VID_TERRATEC,
 		USB_PID_TERRATEC_H7_3,
 		&dvbsky_t680c_props, "Terratec H7 Rev.4",
-- 
2.4.3

