Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ea0-f175.google.com ([209.85.215.175]:39112 "EHLO
	mail-ea0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758467Ab3BKSAs (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 11 Feb 2013 13:00:48 -0500
Received: by mail-ea0-f175.google.com with SMTP id d1so2760617eab.6
        for <linux-media@vger.kernel.org>; Mon, 11 Feb 2013 10:00:46 -0800 (PST)
From: =?UTF-8?q?Frank=20Sch=C3=A4fer?= <fschaefer.oss@googlemail.com>
To: mchehab@redhat.com
Cc: linux-media@vger.kernel.org,
	=?UTF-8?q?Frank=20Sch=C3=A4fer?= <fschaefer.oss@googlemail.com>
Subject: [PATCH] em28xx: fix spacing and some comments in em28xx.h
Date: Mon, 11 Feb 2013 19:01:20 +0100
Message-Id: <1360605680-3311-1-git-send-email-fschaefer.oss@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Frank Schäfer <fschaefer.oss@googlemail.com>
---
 drivers/media/usb/em28xx/em28xx.h |   95 +++++++++++++++----------------------
 1 Datei geändert, 37 Zeilen hinzugefügt(+), 58 Zeilen entfernt(-)

diff --git a/drivers/media/usb/em28xx/em28xx.h b/drivers/media/usb/em28xx/em28xx.h
index a3c08ae..4160a2a 100644
--- a/drivers/media/usb/em28xx/em28xx.h
+++ b/drivers/media/usb/em28xx/em28xx.h
@@ -42,28 +42,28 @@
 #include "em28xx-reg.h"
 
 /* Boards supported by driver */
-#define EM2800_BOARD_UNKNOWN			0
-#define EM2820_BOARD_UNKNOWN			1
-#define EM2820_BOARD_TERRATEC_CINERGY_250	2
-#define EM2820_BOARD_PINNACLE_USB_2		3
-#define EM2820_BOARD_HAUPPAUGE_WINTV_USB_2      4
-#define EM2820_BOARD_MSI_VOX_USB_2              5
-#define EM2800_BOARD_TERRATEC_CINERGY_200       6
-#define EM2800_BOARD_LEADTEK_WINFAST_USBII      7
-#define EM2800_BOARD_KWORLD_USB2800             8
-#define EM2820_BOARD_PINNACLE_DVC_90		9
-#define EM2880_BOARD_HAUPPAUGE_WINTV_HVR_900	10
-#define EM2880_BOARD_TERRATEC_HYBRID_XS		11
-#define EM2820_BOARD_KWORLD_PVRTV2800RF		12
-#define EM2880_BOARD_TERRATEC_PRODIGY_XS	13
-#define EM2820_BOARD_PROLINK_PLAYTV_USB2	14
-#define EM2800_BOARD_VGEAR_POCKETTV             15
-#define EM2883_BOARD_HAUPPAUGE_WINTV_HVR_950	16
-#define EM2880_BOARD_PINNACLE_PCTV_HD_PRO	17
-#define EM2880_BOARD_HAUPPAUGE_WINTV_HVR_900_R2	18
-#define EM2860_BOARD_SAA711X_REFERENCE_DESIGN	19
-#define EM2880_BOARD_AMD_ATI_TV_WONDER_HD_600   20
-#define EM2800_BOARD_GRABBEEX_USB2800           21
+#define EM2800_BOARD_UNKNOWN			  0
+#define EM2820_BOARD_UNKNOWN			  1
+#define EM2820_BOARD_TERRATEC_CINERGY_250	  2
+#define EM2820_BOARD_PINNACLE_USB_2		  3
+#define EM2820_BOARD_HAUPPAUGE_WINTV_USB_2	  4
+#define EM2820_BOARD_MSI_VOX_USB_2		  5
+#define EM2800_BOARD_TERRATEC_CINERGY_200	  6
+#define EM2800_BOARD_LEADTEK_WINFAST_USBII	  7
+#define EM2800_BOARD_KWORLD_USB2800		  8
+#define EM2820_BOARD_PINNACLE_DVC_90		  9
+#define EM2880_BOARD_HAUPPAUGE_WINTV_HVR_900	  10
+#define EM2880_BOARD_TERRATEC_HYBRID_XS		  11
+#define EM2820_BOARD_KWORLD_PVRTV2800RF		  12
+#define EM2880_BOARD_TERRATEC_PRODIGY_XS	  13
+#define EM2820_BOARD_PROLINK_PLAYTV_USB2	  14
+#define EM2800_BOARD_VGEAR_POCKETTV		  15
+#define EM2883_BOARD_HAUPPAUGE_WINTV_HVR_950	  16
+#define EM2880_BOARD_PINNACLE_PCTV_HD_PRO	  17
+#define EM2880_BOARD_HAUPPAUGE_WINTV_HVR_900_R2	  18
+#define EM2860_BOARD_SAA711X_REFERENCE_DESIGN	  19
+#define EM2880_BOARD_AMD_ATI_TV_WONDER_HD_600	  20
+#define EM2800_BOARD_GRABBEEX_USB2800		  21
 #define EM2750_BOARD_UNKNOWN			  22
 #define EM2750_BOARD_DLCW_130			  23
 #define EM2820_BOARD_DLINK_USB_TV		  24
@@ -99,35 +99,35 @@
 #define EM2882_BOARD_KWORLD_VS_DVBT		  54
 #define EM2882_BOARD_TERRATEC_HYBRID_XS		  55
 #define EM2882_BOARD_PINNACLE_HYBRID_PRO_330E	  56
-#define EM2883_BOARD_KWORLD_HYBRID_330U                  57
+#define EM2883_BOARD_KWORLD_HYBRID_330U		  57
 #define EM2820_BOARD_COMPRO_VIDEOMATE_FORYOU	  58
 #define EM2883_BOARD_HAUPPAUGE_WINTV_HVR_850	  60
 #define EM2820_BOARD_PROLINK_PLAYTV_BOX4_USB2	  61
 #define EM2820_BOARD_GADMEI_TVR200		  62
-#define EM2860_BOARD_KAIOMY_TVNPC_U2              63
-#define EM2860_BOARD_EASYCAP                      64
+#define EM2860_BOARD_KAIOMY_TVNPC_U2		  63
+#define EM2860_BOARD_EASYCAP			  64
 #define EM2820_BOARD_IODATA_GVMVP_SZ		  65
 #define EM2880_BOARD_EMPIRE_DUAL_TV		  66
 #define EM2860_BOARD_TERRATEC_GRABBY		  67
 #define EM2860_BOARD_TERRATEC_AV350		  68
 #define EM2882_BOARD_KWORLD_ATSC_315U		  69
 #define EM2882_BOARD_EVGA_INDTUBE		  70
-#define EM2820_BOARD_SILVERCREST_WEBCAM           71
-#define EM2861_BOARD_GADMEI_UTV330PLUS           72
-#define EM2870_BOARD_REDDO_DVB_C_USB_BOX          73
+#define EM2820_BOARD_SILVERCREST_WEBCAM		  71
+#define EM2861_BOARD_GADMEI_UTV330PLUS		  72
+#define EM2870_BOARD_REDDO_DVB_C_USB_BOX	  73
 #define EM2800_BOARD_VC211A			  74
 #define EM2882_BOARD_DIKOM_DK300		  75
 #define EM2870_BOARD_KWORLD_A340		  76
 #define EM2874_BOARD_LEADERSHIP_ISDBT		  77
-#define EM28174_BOARD_PCTV_290E                   78
+#define EM28174_BOARD_PCTV_290E			  78
 #define EM2884_BOARD_TERRATEC_H5		  79
-#define EM28174_BOARD_PCTV_460E                   80
+#define EM28174_BOARD_PCTV_460E			  80
 #define EM2884_BOARD_HAUPPAUGE_WINTV_HVR_930C	  81
 #define EM2884_BOARD_CINERGY_HTC_STICK		  82
-#define EM2860_BOARD_HT_VIDBOX_NW03 		  83
-#define EM2874_BOARD_MAXMEDIA_UB425_TC            84
-#define EM2884_BOARD_PCTV_510E                    85
-#define EM2884_BOARD_PCTV_520E                    86
+#define EM2860_BOARD_HT_VIDBOX_NW03		  83
+#define EM2874_BOARD_MAXMEDIA_UB425_TC		  84
+#define EM2884_BOARD_PCTV_510E			  85
+#define EM2884_BOARD_PCTV_520E			  86
 #define EM2884_BOARD_TERRATEC_HTC_USB_XS	  87
 
 /* Limits minimum and default number of buffers */
@@ -172,27 +172,6 @@
 
 #define EM28XX_INTERLACED_DEFAULT 1
 
-/*
-#define (use usbview if you want to get the other alternate number infos)
-#define
-#define alternate number 2
-#define 			Endpoint Address: 82
-			Direction: in
-			Attribute: 1
-			Type: Isoc
-			Max Packet Size: 1448
-			Interval: 125us
-
-  alternate number 7
-
-			Endpoint Address: 82
-			Direction: in
-			Attribute: 1
-			Type: Isoc
-			Max Packet Size: 3072
-			Interval: 125us
-*/
-
 /* time in msecs to wait for i2c writes to finish */
 #define EM2800_I2C_XFER_TIMEOUT		20
 
@@ -509,8 +488,8 @@ struct em28xx {
 	unsigned int is_audio_only:1;
 
 	/* Controls audio streaming */
-	struct work_struct wq_trigger;              /* Trigger to start/stop audio for alsa module */
-	 atomic_t       stream_started;      /* stream should be running if true */
+	struct work_struct wq_trigger;	/* Trigger to start/stop audio for alsa module */
+	atomic_t       stream_started;	/* stream should be running if true */
 
 	struct em28xx_fmt *format;
 
@@ -598,7 +577,7 @@ struct em28xx {
 	u8 analog_ep_isoc;	/* address of isoc endpoint for analog */
 	u8 analog_ep_bulk;	/* address of bulk endpoint for analog */
 	u8 dvb_ep_isoc;		/* address of isoc endpoint for DVB */
-	u8 dvb_ep_bulk;		/* address of bulk endpoint for DVC */
+	u8 dvb_ep_bulk;		/* address of bulk endpoint for DVB */
 	int alt;		/* alternate setting */
 	int max_pkt_size;	/* max packet size of the selected ep at alt */
 	int packet_multiplier;	/* multiplier for wMaxPacketSize, used for
-- 
1.7.10.4

