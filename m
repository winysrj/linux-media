Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pa0-f45.google.com ([209.85.220.45]:43220 "EHLO
	mail-pa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751309AbaKZMfa (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 26 Nov 2014 07:35:30 -0500
Received: by mail-pa0-f45.google.com with SMTP id lj1so2791837pab.18
        for <linux-media@vger.kernel.org>; Wed, 26 Nov 2014 04:35:30 -0800 (PST)
Date: Wed, 26 Nov 2014 20:35:28 +0800
From: "Nibble Max" <nibble.max@gmail.com>
To: "Olli Salonen" <olli.salonen@iki.fi>
Cc: "linux-media" <linux-media@vger.kernel.org>,
	"Antti Palosaari" <crope@iki.fi>
Subject: [PATCH 3/3] dvb-usb-dvbsky: add TechnoTrend CT2-4400 and CT2-4650 devices support
Message-ID: <201411262035251093366@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="gb2312"
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


Signed-off-by: Nibble Max <nibble.max@gmail.com>
---
 drivers/media/usb/dvb-usb-v2/dvbsky.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/media/usb/dvb-usb-v2/dvbsky.c b/drivers/media/usb/dvb-usb-v2/dvbsky.c
index 86db800..9b5add4 100644
--- a/drivers/media/usb/dvb-usb-v2/dvbsky.c
+++ b/drivers/media/usb/dvb-usb-v2/dvbsky.c
@@ -837,6 +837,14 @@ static const struct usb_device_id dvbsky_id_table[] = {
 		&dvbsky_t680c_props, "DVBSky T680CI", RC_MAP_DVBSKY) },
 	{ DVB_USB_DEVICE(0x0572, 0x0320,
 		&dvbsky_t330_props, "DVBSky T330", RC_MAP_DVBSKY) },
+	{ DVB_USB_DEVICE(USB_VID_TECHNOTREND,
+		USB_PID_TECHNOTREND_TVSTICK_CT2_4400,
+		&dvbsky_t330_props, "TechnoTrend TVStick CT2-4400",
+		RC_MAP_TT_1500) },
+	{ DVB_USB_DEVICE(USB_VID_TECHNOTREND,
+		USB_PID_TECHNOTREND_CONNECT_CT2_4650_CI,
+		&dvbsky_t680c_props, "TechnoTrend TT-connect CT2-4650 CI",
+		RC_MAP_TT_1500) },
 	{ }
 };
 MODULE_DEVICE_TABLE(usb, dvbsky_id_table);

-- 
1.9.1

