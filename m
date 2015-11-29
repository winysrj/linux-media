Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.bredband2.com ([83.219.192.166]:36657 "EHLO
	smtp.bredband2.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752784AbbK2Bxh (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 28 Nov 2015 20:53:37 -0500
Received: from benjamin-desktop.lan (c-ce09e555.03-170-73746f36.cust.bredbandsbolaget.se [85.229.9.206])
	(Authenticated sender: ed8153)
	by smtp.bredband2.com (Postfix) with ESMTPA id 6A0CC727C4
	for <linux-media@vger.kernel.org>; Sun, 29 Nov 2015 02:53:32 +0100 (CET)
From: Benjamin Larsson <benjamin@southpole.se>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH 2/2] Add support for Terratec Cinergy S2 Rev.4
Date: Sun, 29 Nov 2015 02:53:32 +0100
Message-Id: <1448762012-9661-2-git-send-email-benjamin@southpole.se>
In-Reply-To: <1448762012-9661-1-git-send-email-benjamin@southpole.se>
References: <1448762012-9661-1-git-send-email-benjamin@southpole.se>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Benjamin Larsson <benjamin@southpole.se>
---
 drivers/media/usb/dvb-usb-v2/dvbsky.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/media/usb/dvb-usb-v2/dvbsky.c b/drivers/media/usb/dvb-usb-v2/dvbsky.c
index 1dd9625..2d922b9 100644
--- a/drivers/media/usb/dvb-usb-v2/dvbsky.c
+++ b/drivers/media/usb/dvb-usb-v2/dvbsky.c
@@ -851,6 +851,9 @@ static const struct usb_device_id dvbsky_id_table[] = {
 		USB_PID_TERRATEC_H7_3,
 		&dvbsky_t680c_props, "Terratec H7 Rev.4",
 		RC_MAP_TT_1500) },
+	{ DVB_USB_DEVICE(USB_VID_TERRATEC, USB_PID_TERRATEC_CINERGY_S2_R4,
+		&dvbsky_s960_props, "Terratec Cinergy S2 Rev.4",
+		RC_MAP_DVBSKY) },
 	{ }
 };
 MODULE_DEVICE_TABLE(usb, dvbsky_id_table);
-- 
2.1.4

