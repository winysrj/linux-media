Return-path: <linux-media-owner@vger.kernel.org>
Received: from hapkido.dreamhost.com ([66.33.216.122]:43538 "EHLO
        hapkido.dreamhost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751226AbeAEAFQ (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Thu, 4 Jan 2018 19:05:16 -0500
Received: from homiemail-a116.g.dreamhost.com (sub5.mail.dreamhost.com [208.113.200.129])
        by hapkido.dreamhost.com (Postfix) with ESMTP id 96AEC8ED86
        for <linux-media@vger.kernel.org>; Thu,  4 Jan 2018 16:05:16 -0800 (PST)
From: Brad Love <brad@nextdimension.cc>
To: linux-media@vger.kernel.org
Cc: Brad Love <brad@nextdimension.cc>
Subject: [PATCH 5/9] em28xx: Add Hauppauge SoloHD/DualHD bulk models
Date: Thu,  4 Jan 2018 18:04:15 -0600
Message-Id: <1515110659-20145-6-git-send-email-brad@nextdimension.cc>
In-Reply-To: <1515110659-20145-1-git-send-email-brad@nextdimension.cc>
References: <1515110659-20145-1-git-send-email-brad@nextdimension.cc>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add additional pids to driver list

Signed-off-by: Brad Love <brad@nextdimension.cc>
---
 drivers/media/usb/em28xx/em28xx-cards.c | 22 +++++++++++++++++-----
 1 file changed, 17 insertions(+), 5 deletions(-)

diff --git a/drivers/media/usb/em28xx/em28xx-cards.c b/drivers/media/usb/em28xx/em28xx-cards.c
index 7f5d0b28..34c693a 100644
--- a/drivers/media/usb/em28xx/em28xx-cards.c
+++ b/drivers/media/usb/em28xx/em28xx-cards.c
@@ -507,8 +507,10 @@ static struct em28xx_reg_seq plex_px_bcud[] = {
 };
 
 /*
- * 2040:0265 Hauppauge WinTV-dualHD DVB
- * 2040:026d Hauppauge WinTV-dualHD ATSC/QAM
+ * 2040:0265 Hauppauge WinTV-dualHD DVB Isoc
+ * 2040:8265 Hauppauge WinTV-dualHD DVB Bulk
+ * 2040:026d Hauppauge WinTV-dualHD ATSC/QAM Isoc
+ * 2040:826d Hauppauge WinTV-dualHD ATSC/QAM Bulk
  * reg 0x80/0x84:
  * GPIO_0: Yellow LED tuner 1, 0=on, 1=off
  * GPIO_1: Green LED tuner 1, 0=on, 1=off
@@ -2391,7 +2393,8 @@ struct em28xx_board em28xx_boards[] = {
 		.has_dvb       = 1,
 	},
 	/*
-	 * 2040:0265 Hauppauge WinTV-dualHD (DVB version).
+	 * 2040:0265 Hauppauge WinTV-dualHD (DVB version) Isoc.
+	 * 2040:8265 Hauppauge WinTV-dualHD (DVB version) Bulk.
 	 * Empia EM28274, 2x Silicon Labs Si2168, 2x Silicon Labs Si2157
 	 */
 	[EM28174_BOARD_HAUPPAUGE_WINTV_DUALHD_DVB] = {
@@ -2407,7 +2410,8 @@ struct em28xx_board em28xx_boards[] = {
 		.leds          = hauppauge_dualhd_leds,
 	},
 	/*
-	 * 2040:026d Hauppauge WinTV-dualHD (model 01595 - ATSC/QAM).
+	 * 2040:026d Hauppauge WinTV-dualHD (model 01595 - ATSC/QAM) Isoc.
+	 * 2040:826d Hauppauge WinTV-dualHD (model 01595 - ATSC/QAM) Bulk.
 	 * Empia EM28274, 2x LG LGDT3306A, 2x Silicon Labs Si2157
 	 */
 	[EM28174_BOARD_HAUPPAUGE_WINTV_DUALHD_01595] = {
@@ -2549,8 +2553,12 @@ struct usb_device_id em28xx_id_table[] = {
 			.driver_info = EM2883_BOARD_HAUPPAUGE_WINTV_HVR_850 },
 	{ USB_DEVICE(0x2040, 0x0265),
 			.driver_info = EM28174_BOARD_HAUPPAUGE_WINTV_DUALHD_DVB },
+	{ USB_DEVICE(0x2040, 0x8265),
+			.driver_info = EM28174_BOARD_HAUPPAUGE_WINTV_DUALHD_DVB },
 	{ USB_DEVICE(0x2040, 0x026d),
 			.driver_info = EM28174_BOARD_HAUPPAUGE_WINTV_DUALHD_01595 },
+	{ USB_DEVICE(0x2040, 0x826d),
+			.driver_info = EM28174_BOARD_HAUPPAUGE_WINTV_DUALHD_01595 },
 	{ USB_DEVICE(0x0438, 0xb002),
 			.driver_info = EM2880_BOARD_AMD_ATI_TV_WONDER_HD_600 },
 	{ USB_DEVICE(0x2001, 0xf112),
@@ -2611,7 +2619,11 @@ struct usb_device_id em28xx_id_table[] = {
 			.driver_info = EM28178_BOARD_PCTV_461E },
 	{ USB_DEVICE(0x2013, 0x025f),
 			.driver_info = EM28178_BOARD_PCTV_292E },
-	{ USB_DEVICE(0x2040, 0x0264), /* Hauppauge WinTV-soloHD */
+	{ USB_DEVICE(0x2040, 0x0264), /* Hauppauge WinTV-soloHD Isoc */
+			.driver_info = EM28178_BOARD_PCTV_292E },
+	{ USB_DEVICE(0x2040, 0x8264), /* Hauppauge OEM Generic WinTV-soloHD Bulk */
+			.driver_info = EM28178_BOARD_PCTV_292E },
+	{ USB_DEVICE(0x2040, 0x8268), /* Hauppauge Retail WinTV-soloHD Bulk */
 			.driver_info = EM28178_BOARD_PCTV_292E },
 	{ USB_DEVICE(0x0413, 0x6f07),
 			.driver_info = EM2861_BOARD_LEADTEK_VC100 },
-- 
2.7.4
