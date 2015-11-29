Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.bredband2.com ([83.219.192.166]:36658 "EHLO
	smtp.bredband2.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752788AbbK2Bxh (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 28 Nov 2015 20:53:37 -0500
Received: from benjamin-desktop.lan (c-ce09e555.03-170-73746f36.cust.bredbandsbolaget.se [85.229.9.206])
	(Authenticated sender: ed8153)
	by smtp.bredband2.com (Postfix) with ESMTPA id 3F98F727C3
	for <linux-media@vger.kernel.org>; Sun, 29 Nov 2015 02:53:32 +0100 (CET)
From: Benjamin Larsson <benjamin@southpole.se>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH 1/2] Add Terratec Cinergy S2 usb id's
Date: Sun, 29 Nov 2015 02:53:31 +0100
Message-Id: <1448762012-9661-1-git-send-email-benjamin@southpole.se>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Benjamin Larsson <benjamin@southpole.se>
---
 drivers/media/dvb-core/dvb-usb-ids.h | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/media/dvb-core/dvb-usb-ids.h b/drivers/media/dvb-core/dvb-usb-ids.h
index 1c1c298..d62ac1f 100644
--- a/drivers/media/dvb-core/dvb-usb-ids.h
+++ b/drivers/media/dvb-core/dvb-usb-ids.h
@@ -255,6 +255,10 @@
 #define USB_PID_TERRATEC_CINERGY_T_EXPRESS		0x0062
 #define USB_PID_TERRATEC_CINERGY_T_XXS			0x0078
 #define USB_PID_TERRATEC_CINERGY_T_XXS_2		0x00ab
+#define USB_PID_TERRATEC_CINERGY_S2_R1			0x00a8
+#define USB_PID_TERRATEC_CINERGY_S2_R2			0x00b0
+#define USB_PID_TERRATEC_CINERGY_S2_R3			0x0102
+#define USB_PID_TERRATEC_CINERGY_S2_R4			0x0105
 #define USB_PID_TERRATEC_H7				0x10b4
 #define USB_PID_TERRATEC_H7_2				0x10a3
 #define USB_PID_TERRATEC_H7_3				0x10a5
-- 
2.1.4

