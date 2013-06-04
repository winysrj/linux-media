Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:38856 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751067Ab3FDV4M (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 4 Jun 2013 17:56:12 -0400
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Antti Palosaari <crope@iki.fi>
Subject: [PATCH 6/7] rtl28xxu: map remote for TerraTec Cinergy T Stick Black
Date: Wed,  5 Jun 2013 00:55:02 +0300
Message-Id: <1370382903-21332-7-git-send-email-crope@iki.fi>
In-Reply-To: <1370382903-21332-1-git-send-email-crope@iki.fi>
References: <1370382903-21332-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/media/usb/dvb-usb-v2/rtl28xxu.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/usb/dvb-usb-v2/rtl28xxu.c b/drivers/media/usb/dvb-usb-v2/rtl28xxu.c
index 93313f70..04da6be 100644
--- a/drivers/media/usb/dvb-usb-v2/rtl28xxu.c
+++ b/drivers/media/usb/dvb-usb-v2/rtl28xxu.c
@@ -1395,7 +1395,7 @@ static const struct usb_device_id rtl28xxu_id_table[] = {
 	{ DVB_USB_DEVICE(USB_VID_REALTEK, 0x2838,
 		&rtl2832u_props, "Realtek RTL2832U reference design", NULL) },
 	{ DVB_USB_DEVICE(USB_VID_TERRATEC, USB_PID_TERRATEC_CINERGY_T_STICK_BLACK_REV1,
-		&rtl2832u_props, "TerraTec Cinergy T Stick Black", NULL) },
+		&rtl2832u_props, "TerraTec Cinergy T Stick Black", RC_MAP_TERRATEC_SLIM) },
 	{ DVB_USB_DEVICE(USB_VID_GTEK, USB_PID_DELOCK_USB2_DVBT,
 		&rtl2832u_props, "G-Tek Electronics Group Lifeview LV5TDLX DVB-T", NULL) },
 	{ DVB_USB_DEVICE(USB_VID_TERRATEC, USB_PID_NOXON_DAB_STICK,
-- 
1.7.11.7

