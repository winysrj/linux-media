Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lf0-f66.google.com ([209.85.215.66]:34236 "EHLO
        mail-lf0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753451AbcIITZA (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 9 Sep 2016 15:25:00 -0400
Received: by mail-lf0-f66.google.com with SMTP id k12so3046029lfb.1
        for <linux-media@vger.kernel.org>; Fri, 09 Sep 2016 12:24:59 -0700 (PDT)
From: Olli Salonen <olli.salonen@iki.fi>
To: linux-media@vger.kernel.org
Cc: Olli Salonen <olli.salonen@iki.fi>
Subject: [PATCH] dvb-usb-dvbsky: Add support for TechnoTrend S2-4650 CI
Date: Fri,  9 Sep 2016 22:24:54 +0300
Message-Id: <1473449094-9427-1-git-send-email-olli.salonen@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

TechnoTrend TT-connect S2-4650 CI seems to be a variation of
the DVBSky S960CI device.

Signed-off-by: Olli Salonen <olli.salonen@iki.fi>
---
 drivers/media/dvb-core/dvb-usb-ids.h  | 1 +
 drivers/media/usb/dvb-usb-v2/dvbsky.c | 4 ++++
 2 files changed, 5 insertions(+)

diff --git a/drivers/media/dvb-core/dvb-usb-ids.h b/drivers/media/dvb-core/dvb-usb-ids.h
index a7a4674..a52c5c7 100644
--- a/drivers/media/dvb-core/dvb-usb-ids.h
+++ b/drivers/media/dvb-core/dvb-usb-ids.h
@@ -262,6 +262,7 @@
 #define USB_PID_TECHNOTREND_CONNECT_CT2_4650_CI		0x3012
 #define USB_PID_TECHNOTREND_CONNECT_CT2_4650_CI_2	0x3015
 #define USB_PID_TECHNOTREND_TVSTICK_CT2_4400		0x3014
+#define USB_PID_TECHNOTREND_CONNECT_S2_4650_CI		0x3017
 #define USB_PID_TERRATEC_CINERGY_DT_XS_DIVERSITY	0x005a
 #define USB_PID_TERRATEC_CINERGY_DT_XS_DIVERSITY_2	0x0081
 #define USB_PID_TERRATEC_CINERGY_HT_USB_XE		0x0058
diff --git a/drivers/media/usb/dvb-usb-v2/dvbsky.c b/drivers/media/usb/dvb-usb-v2/dvbsky.c
index 02dbc6c..0636eac 100644
--- a/drivers/media/usb/dvb-usb-v2/dvbsky.c
+++ b/drivers/media/usb/dvb-usb-v2/dvbsky.c
@@ -851,6 +851,10 @@ static const struct usb_device_id dvbsky_id_table[] = {
 		USB_PID_TECHNOTREND_CONNECT_CT2_4650_CI_2,
 		&dvbsky_t680c_props, "TechnoTrend TT-connect CT2-4650 CI v1.1",
 		RC_MAP_TT_1500) },
+	{ DVB_USB_DEVICE(USB_VID_TECHNOTREND,
+		USB_PID_TECHNOTREND_CONNECT_S2_4650_CI,
+		&dvbsky_s960c_props, "TechnoTrend TT-connect S2-4650 CI",
+		RC_MAP_TT_1500) },
 	{ DVB_USB_DEVICE(USB_VID_TERRATEC,
 		USB_PID_TERRATEC_H7_3,
 		&dvbsky_t680c_props, "Terratec H7 Rev.4",
-- 
2.7.4

